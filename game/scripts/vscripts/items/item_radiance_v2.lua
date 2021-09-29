item_radiance_v2=class({})
LinkLuaModifier("modifier_item_radiance_v2", "items/item_radiance_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_radiance_v2_pa", "items/item_radiance_v2.lua", LUA_MODIFIER_MOTION_NONE)


function item_radiance_v2:GetIntrinsicModifierName()
    return "modifier_item_radiance_v2_pa"
end

function item_radiance_v2:GetAbilityTextureName()
    if  self:GetCaster():HasModifier("modifier_item_radiance_v2") then
        return "imba_radiance"
    else
        return "imba_radiance_inactive"
    end
end

function item_radiance_v2:OnOwnerSpawned()
    local caster=self:GetCaster()
    local radiance=caster:FindItemInInventory("item_radiance_v2")
    if radiance and not radiance:IsInBackpack() and not radiance:GetToggleState()  then
        self:OnToggle()
    end
end

function item_radiance_v2:OnToggle()
    local caster=self:GetCaster()
    if  caster:HasModifier("modifier_item_radiance_v2") then
        caster:RemoveModifierByName("modifier_item_radiance_v2")
    else
        caster:AddNewModifier(caster, self, "modifier_item_radiance_v2", {})
    end
end

modifier_item_radiance_v2_pa=class({})

function modifier_item_radiance_v2_pa:IsPassive()
    return true
end

function modifier_item_radiance_v2_pa:IsHidden()
    return true
end

function modifier_item_radiance_v2_pa:IsPurgable()
    return false
end

function modifier_item_radiance_v2_pa:IsPurgeException()
    return false
end

function modifier_item_radiance_v2_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_radiance_v2_pa:OnCreated()
	if not self:GetAbility() then
        return
    end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_evasion=self.ability:GetSpecialValueFor("bonus_evasion")
    if IsServer() then
        if not  self.parent:HasModifier("modifier_item_radiance_v2") then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_radiance_v2", {})
        end
    end
end

function modifier_item_radiance_v2_pa:OnDestroy()
    if IsServer() then
        if  self.parent:HasModifier("modifier_item_radiance_v2") then
                self.parent:RemoveModifierByName("modifier_item_radiance_v2")
        end
    end
end

function modifier_item_radiance_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
end

function modifier_item_radiance_v2_pa:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_item_radiance_v2_pa:GetModifierEvasion_Constant()
    return self.bonus_evasion
end


modifier_item_radiance_v2=class({})

function modifier_item_radiance_v2:IsHidden()
    return true
end

function modifier_item_radiance_v2:IsPurgable()
    return false
end

function modifier_item_radiance_v2:IsPurgeException()
    return false
end

function modifier_item_radiance_v2:AllowIllusionDuplicate()
    return false
end

function modifier_item_radiance_v2:OnCreated()
    if IsServer() then
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
        self.radius=self:GetAbility():GetSpecialValueFor("radius")
        self.interval=self:GetAbility():GetSpecialValueFor("interval")
        self.base_dmg=self:GetAbility():GetSpecialValueFor("base_dmg")
        self.extra_dmg=self:GetAbility():GetSpecialValueFor("extra_dmg")*0.01
        self.damageTable =
        {
            attacker = self.parent,
            damage_type=DAMAGE_TYPE_MAGICAL,
            damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
            ability = self.ability,
        }
        self.fx=ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        self:AddParticle(self.fx, true, false, 1, false, false)
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_radiance_v2:OnIntervalThink()
    if  self.parent and  self.parent:IsAlive() then
        local units = FindUnitsInRadius(
        self.team,
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        if #units>0 then
            for _, unit in pairs(units) do
                    self.damageTable.victim = unit
                    if self.parent:IsIllusion() then
                                if  not unit:IsHero() then
                                    self.damageTable.damage = self.base_dmg
                                end
                    else
                        if unit:IsHero() then
                                if TG_Distance(unit:GetAbsOrigin(),self.parent:GetAbsOrigin())<350 then
                                    self.damageTable.damage = self.base_dmg+unit:GetMaxHealth()*self.extra_dmg
                                else
                                    self.damageTable.damage = self.base_dmg+unit:GetHealth()*self.extra_dmg
                                end
                        else
                                self.damageTable.damage = self.base_dmg
                        end
                    end
                    ApplyDamage(self.damageTable)
            end
        end
    end
end