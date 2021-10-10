item_battle_fury=class({})

LinkLuaModifier("modifier_item_battle_fury_pa", "items/item_battle_fury.lua", LUA_MODIFIER_MOTION_NONE)

function item_battle_fury:GetIntrinsicModifierName()return "modifier_item_battle_fury_pa"
end

function item_battle_fury:OnSpellStart()
    local caster=self:GetCaster()
    local pos=self:GetCursorPosition()
    local team=caster:GetTeamNumber()
    local id=caster:GetPlayerOwnerID()
    GridNav:DestroyTreesAroundPoint(pos,300,false)
        local targets = FindUnitsInRadius(
		team,
		pos,
		nil,
		300,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_OTHER,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
        false)

        for _, target in pairs(targets) do
            local name=target:GetName()
            if name~=nil and (name=="npc_dota_ward_base_truesight" or name=="npc_dota_ward_base") then
                if CDOTA_PlayerResource.TG_HERO[id + 1].des_ward then
                        CDOTA_PlayerResource.TG_HERO[id + 1].des_ward=CDOTA_PlayerResource.TG_HERO[id+ 1].des_ward+1
                end
                target:Kill( nil, caster )
            end
        end
end

modifier_item_battle_fury_pa = class({})

function modifier_item_battle_fury_pa:IsHidden()return true
end
function modifier_item_battle_fury_pa:IsPurgable()return false
end
function modifier_item_battle_fury_pa:IsPurgeException()return false
end
function modifier_item_battle_fury_pa:AllowIllusionDuplicate()return false
end

function modifier_item_battle_fury_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
   }
end

function modifier_item_battle_fury_pa:OnCreated()
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    self.team=self.parent:GetTeamNumber()
    if self.ability == nil then
		return
    end
    self.bonus_damage,self.bonus_health_regen,self.bonus_mana_regen,self.cleave_damage_percent,self.rd,self.max_distance,self.damageTable=
    self.ability:GetSpecialValueFor("bonus_damage"),
    self.ability:GetSpecialValueFor("bonus_health_regen"),
    self.ability:GetSpecialValueFor("bonus_mana_regen"),
    self.ability:GetSpecialValueFor("cleave_damage_percent")*0.01,
    self.ability:GetSpecialValueFor("rd"),
    self.ability:GetSpecialValueFor("max_distance"),
     {
        attacker = self.parent,
        damage = self.dam,
        ability = self.ability,
        damage_type =DAMAGE_TYPE_PURE,
        damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
    }
end

function modifier_item_battle_fury_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent  and not self.parent:IsIllusion() then
        local pos=tg.target:GetAbsOrigin()
        local fx = ParticleManager:CreateParticle("particles/tgp/items/bfury_cleave/bfury_cleave_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(fx, 0, pos)
        ParticleManager:SetParticleControl(fx, 1, Vector(self.rd,0,0))
        ParticleManager:SetParticleControl(fx, 2, Vector(0.5,0,0))
		ParticleManager:ReleaseParticleIndex(fx)
        local units = FindUnitsInRadius(self.team,
        pos,
        nil,
        self.rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER, false)
        if #units>0 then
            for _, unit in pairs(units) do
                if unit~=tg.target and TG_Distance(unit:GetAbsOrigin(),self.parent:GetAbsOrigin())<self.max_distance then
                    self.damageTable.victim = unit
                    self.damageTable.damage =  self.parent:IsRangedAttacker() and tg.original_damage*0.1 or tg.original_damage*self.cleave_damage_percent
                    ApplyDamage(self.damageTable)
                end
            end
        end
    end
end

function modifier_item_battle_fury_pa:GetModifierPreAttack_BonusDamage()return  self.bonus_damage
end
function modifier_item_battle_fury_pa:GetModifierConstantHealthRegen()return  self.bonus_health_regen
end
function modifier_item_battle_fury_pa:GetModifierConstantManaRegen()return  self.bonus_mana_regen
end
