CreateTalents("npc_dota_hero_enchantress", "heros/hero_enchantress/impetus.lua")
impetus= class({})
LinkLuaModifier("modifier_impetus", "heros/hero_enchantress/impetus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_impetus_buff", "heros/hero_enchantress/impetus.lua", LUA_MODIFIER_MOTION_NONE)

function impetus:GetIntrinsicModifierName()
    return "modifier_impetus"
end

function impetus:OnHeroLevelUp()
    local caster=self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_impetus_buff", {})
end

modifier_impetus = class({})

function modifier_impetus:IsPassive()
	return true
end

function modifier_impetus:IsPurgable()
    return false
end

function modifier_impetus:IsPurgeException()
    return false
end

function modifier_impetus:IsHidden()
    return true
end

function modifier_impetus:IsPermanent()
    return true
end

function modifier_impetus:OnCreated()
    if IsServer() then
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
        self.dam=self.ability:GetSpecialValueFor("dam")*0.01
        self.damage= {
            attacker = self.parent,
            damage_flags =  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            ability = self.ability,
            }
    end
end

function modifier_impetus:OnRefresh()
    self:OnCreated()
end

function modifier_impetus:OnAttackStart(tg)
	if not IsServer() then
		return
    end
    if tg.attacker == self.parent then
        self.parent:EmitSound(" Hero_Enchantress.Impetus")
    end
end
function modifier_impetus:OnAttackLanded(tg)
	if not IsServer() then
		return
	end

    if tg.attacker == self.parent  then
        if  tg.target:IsOther() or tg.target:IsBuilding() or self.parent:IsIllusion() then
            return
        end
        local dis=TG_Distance(tg.target:GetAbsOrigin(),tg.attacker:GetAbsOrigin())
        if dis>=10000 and not self.parent:TG_HasTalent("special_bonus_enchantress_2") then
            dis=10000
        end
        if dis>=1000 and  self.parent:TG_HasTalent("special_bonus_enchantress_4") then
                 tg.target:AddNewModifier(self.parent,self.ability,"modifier_imba_stunned",{duration=0.5})
        end
            local dmg=dis*self.dam
            self.damage.damage=dmg
            self.damage.victim = tg.target
            self.damage.damage_type = self.parent:HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL
            ApplyDamage( self.damage)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, tg.target, dmg, nil)
    end
end


function modifier_impetus:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end


function modifier_impetus:GetModifierProjectileName()
    return  "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf"
end


modifier_impetus_buff= class({})

function modifier_impetus_buff:IsHidden()
    return true
end

function modifier_impetus_buff:IsPurgable()
    return false
end

function modifier_impetus_buff:IsPurgeException()
    return false
end

function modifier_impetus_buff:RemoveOnDeath()
    return false
end

function modifier_impetus_buff:IsPermanent()
    return true
end

function modifier_impetus_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_impetus_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS
    }
end

function modifier_impetus_buff:GetModifierProjectileSpeedBonus()
    if self:GetAbility()~=nil then
    return  self:GetAbility():GetSpecialValueFor("psp")
    end
    return 0
end