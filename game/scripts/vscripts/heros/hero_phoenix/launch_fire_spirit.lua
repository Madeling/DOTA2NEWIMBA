launch_fire_spirit=class({})
LinkLuaModifier("modifier_launch_fire_spirit_debuff", "heros/hero_phoenix/launch_fire_spirit.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function launch_fire_spirit:IsHiddenWhenStolen()
    return false
end

function launch_fire_spirit:IsStealable()
    return false
end


function launch_fire_spirit:IsRefreshable()
    return true
end

function launch_fire_spirit:GetAOERadius()
    return self:GetSpecialValueFor("rd")
end

function launch_fire_spirit:GetAssociatedPrimaryAbilities()
    return "fire_spirits"
end

function launch_fire_spirit:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local cur_pos=self:GetCursorPosition()
    cur_pos.z=cur_pos.z+10
    local dir=TG_Direction(caster_pos,cur_pos)
    local sp=self:GetSpecialValueFor("sp")
    if caster:HasModifier("modifier_icarus_dive_move") or caster:HasModifier("modifier_icarus_dive_move2") or caster:HasModifier("modifier_phoenix_icarus_dive") then
        sp=sp+1500
    end
    caster:EmitSound("Hero_Phoenix.FireSpirits.Launch")
    local null = CreateUnitByName(
        "npc_dummy_unit",
        cur_pos,
         true,
         nil,
         nil,
         caster:GetTeamNumber())
    if caster:HasModifier("modifier_fire_spirits")  then
       local mod=caster:FindModifierByName("modifier_fire_spirits")
       if mod~=nil then
        if mod:GetStackCount()>0 then
            local fx = caster.fire_spiritsfx
            local num=mod:GetStackCount()
            mod:SetStackCount(num-1)
            ParticleManager:SetParticleControl( fx, 1, Vector( num, 0, 0 ) )
            ParticleManager:SetParticleControl( fx, 6, Vector( num, 0, 0 ) )
            for i=1, 4+caster:TG_GetTalentValue("special_bonus_phoenix_2") do
                local vh = 0
                if i < num  then
                    vh = 1
                end
                ParticleManager:SetParticleControl( fx, 8+i, Vector( vh, 0, 0 ) )
            end
            local Projectile =
            {
                Target = null,
                Source = caster,
                Ability = self,
                EffectName = "particles/heros/phoenix/launch_fire_spirit.vpcf",
                iMoveSpeed = sp,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                bDrawsOnMinimap = false,
                bDodgeable = false,
                bIsAttack = false,
                bVisibleToEnemies = true,
                bReplaceExisting = false,
                flExpireTime = GameRules:GetGameTime() + 10,
                bProvidesVision = false,
                ExtraData = {null = null:entindex()},
            }
            TG_CreateProjectile({id=1,team=caster:GetTeamNumber() ,owner=caster,p=Projectile})
            if mod:GetStackCount()<=0 then
                caster:RemoveModifierByName("modifier_fire_spirits")
            end
        end
       end
    end

end


function launch_fire_spirit:OnProjectileHit_ExtraData(target, location,kv)
    local unit = EntIndexToHScript( kv.null)
    local caster=self:GetCaster()
    TG_IS_ProjectilesValue1(caster,function()
        unit:ForceKill(false)
        target=nil
    end)
	if not target then
		return
    end
    local unit_pos= unit:GetAbsOrigin()
    local team=caster:GetTeamNumber()
    local rd = self:GetSpecialValueFor( "rd" )+caster:TG_GetTalentValue("special_bonus_phoenix_1")
    if caster:HasModifier("modifier_icarus_dive_move") or caster:HasModifier("modifier_icarus_dive_move2") or caster:HasModifier("modifier_phoenix_icarus_dive") then
        rd=rd+200
    end
    unit:EmitSound("Hero_Phoenix.ProjectileImpact")
    unit:EmitSound("Hero_Phoenix.FireSpirits.Target")
    unit:EmitSound("Hero_Phoenix.FireSpirits.ProjectileHit")
    AddFOWViewer(team, unit_pos, rd, 1, true)
	local fx = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0, location)
    ParticleManager:SetParticleControl(fx, 1, Vector(rd,0,0))
    ParticleManager:SetParticleControl(fx, 3, location)
	ParticleManager:ReleaseParticleIndex(fx)
    local dur = self:GetSpecialValueFor( "dam_dur" )
    local heros = FindUnitsInRadius(
        team,
        unit_pos,
        nil,
        rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,false)
     for _, hero in pairs(heros) do
        if not hero:IsMagicImmune()  then
            hero:AddNewModifier_RS(caster, self, "modifier_launch_fire_spirit_debuff", {duration=dur})
        end
    end
    unit:ForceKill(false)
end

modifier_launch_fire_spirit_debuff=class({})

function modifier_launch_fire_spirit_debuff:IsDebuff()
    return true
end

function modifier_launch_fire_spirit_debuff:IsHidden()
    return false
end

function modifier_launch_fire_spirit_debuff:IsPurgable()
    return true
end

function modifier_launch_fire_spirit_debuff:IsPurgeException()
    return true
end

function modifier_launch_fire_spirit_debuff:GetEffectName()
    return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf"
end

function modifier_launch_fire_spirit_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_launch_fire_spirit_debuff:OnCreated()
    local tick = self:GetAbility():GetSpecialValueFor( "tick" )
    local dam_dur = self:GetAbility():GetSpecialValueFor( "dam_dur" )
    self.DAM = self:GetAbility():GetSpecialValueFor( "dam" )
    self.ATTSP = self:GetAbility():GetSpecialValueFor( "att_sp" )
    if not IsServer() then
        return
    end
   -- if not  self:GetCaster() :HasModifier("modifier_icarus_dive_move") and  not  self:GetCaster() :HasModifier("modifier_icarus_dive_move2") then
    --    self:StartIntervalThink(tick)
    --else
        local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.DAM,--(self.DAM*(1/tick)*dam_dur)*0.25,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            }
        ApplyDamage(damageTable)
    --end
end

function modifier_launch_fire_spirit_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_launch_fire_spirit_debuff:OnIntervalThink()
    local damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage =   self.DAM,
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
        }
    ApplyDamage(damageTable)
end


function modifier_launch_fire_spirit_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_launch_fire_spirit_debuff:GetModifierAttackSpeedBonus_Constant()
    return  self.ATTSP
end
