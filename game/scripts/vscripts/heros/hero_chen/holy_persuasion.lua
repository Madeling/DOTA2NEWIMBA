holy_persuasion=class({})
LinkLuaModifier("modifier_holy_persuasion_buff", "heros/hero_chen/holy_persuasion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_holy_persuasion_stack", "heros/hero_chen/holy_persuasion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_holy_persuasion_knock", "heros/hero_chen/holy_persuasion.lua", LUA_MODIFIER_MOTION_NONE)
function holy_persuasion:IsHiddenWhenStolen()
    return false
end

function holy_persuasion:IsStealable()
    return true
end


function holy_persuasion:IsRefreshable()
    return true
end

function holy_persuasion:CastFilterResultTarget(target)
	if ( not target:IsCreep() and not target:IsNeutralUnitType() and target~=self:GetCaster() ) or target:IsBoss()  then
		return UF_FAIL_CUSTOM
	end
end

function holy_persuasion:GetCustomCastErrorTarget(target)
        return "无法对其使用"
end

function holy_persuasion:GetAbilityTextureName()
    if not self:GetCaster():HasModifier("modifier_holy_persuasion_stack") then
        return "chen_holy_persuasion"
    else
        return "Launch_Creature"
    end
end

function holy_persuasion:GetBehavior()
    if not self:GetCaster():HasModifier("modifier_holy_persuasion_stack") then
        return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    else
        return DOTA_ABILITY_BEHAVIOR_POINT
    end
end

function holy_persuasion:GetCooldown(iLevel)
    if self:GetCaster():HasScepter() then
        return self.BaseClass.GetCooldown(self,iLevel)-4
    else
        return self.BaseClass.GetCooldown(self,iLevel)
    end
end


function holy_persuasion:OnSpellStart()
    local caster=self:GetCaster()
    local casterpos=caster:GetAbsOrigin()
    EmitSoundOn("Hero_Chen.HolyPersuasionCast", caster)
    if not caster:HasModifier("modifier_holy_persuasion_stack") then
        local tar=self:GetCursorTarget()
        local dur=self:GetSpecialValueFor("dur")
        if tar==caster then
            local modifier=
            {
                outgoing_damage=0,
                incoming_damage=0,
                bounty_base=0,
                bounty_growth=0,
                outgoing_damage_structure=0,
                outgoing_damage_roshan=0,
            }
                local illusions=CreateIllusions(caster, caster, modifier, 1, 0, true, true)
                illusions[1]:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
                caster.holy_persuasion_target="npc_dota_seasonal_ti10_soccer_ball"
        else
            local name=tar:GetUnitName()
            tar:Kill(self, caster)
            local unit=CreateUnitByName(name, casterpos+caster:GetForwardVector()*100, true, caster, caster, caster:GetTeamNumber())
            local p = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
            ParticleManager:SetParticleControl(p, 0,unit:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(p)
            caster.holy_persuasion_target=name
            unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
            unit:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
            unit:AddNewModifier(caster, self, "modifier_holy_persuasion_buff", {duration=dur})
            if caster:TG_HasTalent("special_bonus_chen_4") then
                local ab=unit:AddAbility(RandomAbility[RandomInt(1, #RandomAbility)])
                ab:SetLevel(ab:GetMaxLevel())
                unit:GiveMana(9999)
            end
        end
        caster:AddNewModifier(caster, self, "modifier_holy_persuasion_stack", {})
        self:EndCooldown()
    else
        caster:RemoveModifierByName("modifier_holy_persuasion_stack")
        if caster.holy_persuasion_target then
            local pos=self:GetCursorPosition()
            local dis=TG_Distance(pos,casterpos)
            local dir=TG_Direction(casterpos,pos)
            local unit1=CreateUnitByName(caster.holy_persuasion_target, casterpos, false, caster, caster, caster:GetTeamNumber())
            local unitpos=unit1:GetAbsOrigin()
            unit1:AddNewModifier(caster, self, "modifier_holy_persuasion_buff", {duration=1})
            unit1:AddNewModifier(caster, self, "modifier_kill", {duration=0.5})
            unit1:AddNewModifier(caster, self, "modifier_holy_persuasion_knock", {duration=0.5})
            local Knockback ={
                should_stun = false,
                knockback_duration = 0.4,
                duration = 0.4,
                knockback_distance = dis,
                knockback_height = 300,
                center_x =  dir.x+casterpos.x,
                center_y =  dir.y+casterpos.y,
                center_z =  casterpos.z,
            }
            unit1:AddNewModifier(caster,self, "modifier_knockback", Knockback)
        end
    end
end

modifier_holy_persuasion_knock=class({})


function modifier_holy_persuasion_knock:IsPurgable()
    return false
end

function modifier_holy_persuasion_knock:IsPurgeException()
    return false
end

function modifier_holy_persuasion_knock:IsHidden()
    return true
end

function modifier_holy_persuasion_knock:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.dam=self.ability:GetSpecialValueFor("dam")
    self.stun=self.ability:GetSpecialValueFor("stun")
    if IsServer() then
        if self.parent:IsNeutralUnitType() or self.parent:IsCreep() then
            self.dam=self.dam*self.parent:GetMaxHealth()*0.01
        else
            self.dam=self.dam/2*self.caster:GetMaxHealth()*0.01
        end
    end
end


function modifier_holy_persuasion_knock:OnDestroy()
    if IsServer() then
        local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(p1, 0, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(p1)
        local heros = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #heros>0 then
            for _, target in pairs(heros) do
                if not target:IsMagicImmune() then
                     target:AddNewModifier_RS(self.parent, self.ability, "modifier_imba_stunned", {duration = self.stun})
                    local damageTable = {
                        victim = target,
                        attacker = self.parent,
                        damage = self.dam,
                        damage_type =self:GetCaster():HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
                        ability = self.ability,
                        }
                    ApplyDamage(damageTable)
                end
            end
        end
    end
end

function modifier_holy_persuasion_knock:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end


modifier_holy_persuasion_buff=class({})


function modifier_holy_persuasion_buff:IsPurgable()
    return false
end

function modifier_holy_persuasion_buff:IsPurgeException()
    return false
end

function modifier_holy_persuasion_buff:IsHidden()
    return true
end

function modifier_holy_persuasion_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS
	}
end

function modifier_holy_persuasion_buff:OnCreated()
    self.ability=self:GetAbility()
    self.hp=self.ability:GetSpecialValueFor("hp")
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.ar=self.ability:GetSpecialValueFor("ar")
end

function modifier_holy_persuasion_buff:OnRefresh()
   self:OnCreated()
end

function modifier_holy_persuasion_buff:GetModifierExtraHealthBonus()
    return self.hp
end

function modifier_holy_persuasion_buff:GetModifierPhysicalArmorBonus()
    return self.ar
end

function modifier_holy_persuasion_buff:GetModifierMoveSpeedBonus_Constant()
    return self.sp
end

function modifier_holy_persuasion_buff:GetModifierExtraManaBonus()
    return 1000
end

modifier_holy_persuasion_stack=class({})


function modifier_holy_persuasion_stack:IsPurgable()
    return false
end

function modifier_holy_persuasion_stack:IsPurgeException()
    return false
end

function modifier_holy_persuasion_stack:IsHidden()
    return false
end

function modifier_holy_persuasion_stack:RemoveOnDeath()
    return false
end

function modifier_holy_persuasion_stack:OnCreated()
    self.ability=self:GetAbility()
    self.num=self:GetAbility():GetSpecialValueFor( "num")
    if IsServer() then
        self:SetStackCount(self.num)
    end
end

function modifier_holy_persuasion_stack:OnRefresh()
   self:OnCreated()
end
