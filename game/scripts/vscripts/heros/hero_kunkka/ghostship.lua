ghostship=class({})
LinkLuaModifier("modifier_ghostship", "heros/hero_kunkka/ghostship.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghostship_buff", "heros/hero_kunkka/ghostship.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghostship_debuff", "heros/hero_kunkka/ghostship.lua", LUA_MODIFIER_MOTION_NONE)
function ghostship:IsHiddenWhenStolen()
    return false
end

function ghostship:IsStealable()
    return true
end

function ghostship:IsRefreshable()
    return true
end

function ghostship:OnSpellStart()
    local caster=self:GetCaster()
    local cur_pos=self:GetCursorPosition()
    local dis=TG_Distance(cur_pos,caster:GetAbsOrigin())
    local sp=self:GetSpecialValueFor("sp")
    local rd_s=self:GetSpecialValueFor("rd_s")
    dis=dis>2500 and 2500 or dis
    local dis_time=dis/sp
    local direction=TG_Direction(caster:GetAbsOrigin(),cur_pos+Vector(1,1,1))
    local thinker=CreateModifierThinker(caster, self, "modifier_ghostship",  {duration=dis_time}, cur_pos, caster:GetTeamNumber(), false)
    thinker:EmitSound( "kunkka_kunk_ability_ghostshp_01" )
    local projectile = {
        Ability = self,
        EffectName = "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
        vSpawnOrigin = cur_pos,
        fDistance = dis,
        fStartRadius = rd_s,
        fEndRadius = rd_s,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        bProvidesVision = true,
		iVisionRadius = rd_s,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity = direction*sp,
        ExtraData = {tk=thinker:entindex()}
    }
    ProjectileManager:CreateLinearProjectile(projectile)
    thinker:EmitSound( "Ability.Ghostship.bell" )
    thinker:EmitSound( "Ability.Ghostship" )
end

function ghostship:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
    if hTarget==nil then
        return
    end
   if Is_Chinese_TG(hTarget,self:GetCaster()) then
        hTarget:AddNewModifier(self:GetCaster(),self,"modifier_ghostship_buff",{duration=self:GetSpecialValueFor("dur_buff")})
   end
end

function ghostship:OnProjectileThink_ExtraData(location, kv)
    local tk=EntIndexToHScript(kv.tk)
        local heros = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            location,
            nil,
            self:GetSpecialValueFor("rd_s"),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #heros>0 then
                for _, hero in pairs(heros) do
                    if hero:IsAlive() and not hero:IsMagicImmune() and not Is_Chinese_TG(hero,self:GetCaster()) and not hero:IsBoss()  and  not hero:HasModifier("modifier_fountain_aura_buff")then
                        if hero:HasModifier("modifier_knockback") then
                            hero:RemoveModifierByName("modifier_knockback")
                        end
                        if hero:HasModifier("modifier_tree_dance_height") then
                            hero:RemoveModifierByName("modifier_tree_dance_height")
                        end
                        hero:AddNewModifier(self:GetCaster(),self,"modifier_phased",{duration=1})
                        hero:AddNewModifier(self:GetCaster(),self,"modifier_ghostship_debuff",{duration=1})
                        hero:SetAbsOrigin(GetGroundPosition(location, hero))
                    end
                end
        end
        if tk then
            tk:SetAbsOrigin(location)
        end
end

modifier_ghostship_debuff=class({})

function modifier_ghostship_debuff:IsHidden()
	return true
end

function modifier_ghostship_debuff:IsPurgable()
    return false
end

function modifier_ghostship_debuff:IsPurgeException()
    return false
end

modifier_ghostship=class({})

function modifier_ghostship:IsPurgable()
    return false
end

function modifier_ghostship:IsPurgeException()
    return false
end

function modifier_ghostship:GetPriority()
	return 50
end


function modifier_ghostship:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound( "Ability.Ghostship.crash" )
    self:GetParent():EmitSound( "kunkka_kunk_ability_failure_01" )
    local heros = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor("rd_s"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if not hero:IsMagicImmune() then
                    local damageTable = {
                        victim = hero,
                        attacker = self:GetCaster(),
                        damage = self:GetAbility():GetSpecialValueFor("dam")+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_6"),
                        damage_type =DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                        }
                    ApplyDamage(damageTable)
                    hero:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_stunned", {duration=self:GetAbility():GetSpecialValueFor("stun")})
                end
            end
        end
end

modifier_ghostship_buff=class({})

function modifier_ghostship_buff:IsBuff()
	return true
end

function modifier_ghostship_buff:IsHidden()
	return false
end

function modifier_ghostship_buff:IsPurgable()
    return false
end

function modifier_ghostship_buff:IsPurgeException()
    return false
end

function modifier_ghostship_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_rum.vpcf"
end

function modifier_ghostship_buff:StatusEffectPriority()
    return 20
end


function modifier_ghostship_buff:OnCreated()
    self.SPBUFF=self:GetAbility():GetSpecialValueFor( "sp_buff" )
    self.DAMBUFF=self:GetAbility():GetSpecialValueFor( "dam_buff" )
end

function modifier_ghostship_buff:OnRefresh()
    self.SPBUFF=self:GetAbility():GetSpecialValueFor( "sp_buff" )
    self.DAMBUFF=self:GetAbility():GetSpecialValueFor( "dam_buff" )
end

function modifier_ghostship_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_ghostship_buff:GetModifierMoveSpeedBonus_Percentage()
    return  self.SPBUFF
end

function modifier_ghostship_buff:GetModifierIncomingDamage_Percentage()
    return self.DAMBUFF
end
