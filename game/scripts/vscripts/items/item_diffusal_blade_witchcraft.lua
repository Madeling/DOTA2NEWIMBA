item_diffusal_blade_witchcraft=class({})
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_pa", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_buff", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_debuff", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_debuff2", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_witchcraft_debuff3", "items/item_diffusal_blade_witchcraft.lua", LUA_MODIFIER_MOTION_NONE)

function item_diffusal_blade_witchcraft:GetIntrinsicModifierName()
    return "modifier_item_diffusal_blade_witchcraft_pa"
end

function item_diffusal_blade_witchcraft:GetAOERadius()
    return 300
end

function item_diffusal_blade_witchcraft:OnSpellStart()
	local caster = self:GetCaster()
    local target_pos = self:GetCursorPosition()
    local gold =self:GetSpecialValueFor("gold")
        caster:EmitSound( "DOTA_Item.DiffusalBlade.Activate" )
        EmitSoundOnLocationWithCaster( target_pos, "DOTA_Item.DiffusalBlade.Target", caster )
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            target_pos,
            nil,
            self:GetSpecialValueFor( "rd" ),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
            if heros~=nil and #heros>0 then
                for _, hero in pairs(heros) do
                    if not hero:HasModifier("modifier_illusions_mirror_image") and (hero:IsIllusion() or (hero:IsCreature() and not hero:IsConsideredHero())) then
                        hero:Kill(self, caster)
                    end
                    if not hero:IsMagicImmune() then
                        local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
                        ParticleManager:ReleaseParticleIndex(pfx)
                        hero:Purge(true, false, false, false, false)
                        hero:AddNewModifier_RS(caster, self, "modifier_item_diffusal_blade_witchcraft_debuff", {duration=self:GetSpecialValueFor( "mana_dur" )})
                    end
                        hero:AddNewModifier_RS(caster, self, "modifier_item_diffusal_blade_witchcraft_debuff2", {duration=self:GetSpecialValueFor( "mana_dur" )})
                end
            end
end

modifier_item_diffusal_blade_witchcraft_pa=class({})

function modifier_item_diffusal_blade_witchcraft_pa:IsHidden()
    return true
end

function modifier_item_diffusal_blade_witchcraft_pa:IsPurgable()
    return false
end

function modifier_item_diffusal_blade_witchcraft_pa:IsPurgeException()
    return false
end

function modifier_item_diffusal_blade_witchcraft_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end


function modifier_item_diffusal_blade_witchcraft_pa:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
  self.ch=self.ability:GetSpecialValueFor("ch")
  self.mana_base=self.ability:GetSpecialValueFor("mana_base")
  self.mana_pe=self.ability:GetSpecialValueFor("mana_pe")
  self.int=self.ability:GetSpecialValueFor( "int" )
  self.agi=self.ability:GetSpecialValueFor( "agi" )
  self.attch=self.ability:GetSpecialValueFor( "attch" )
  self.dam=0
end


function modifier_item_diffusal_blade_witchcraft_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if (tg.attacker:IsBuilding() or tg.attacker:IsIllusion()) then
        return
    end
    if tg.attacker == self.parent and tg.target:IS_TrueHero_TG() then
       local mana = tg.target:GetMana()
       local manamax=tg.target:GetMaxMana()
       if RollPseudoRandomPercentage(self.attch,0,self.parent) then
                tg.target:Purge(false, true, false, false, false)
       end
       if mana then
            self.dam=self.mana_base
            if mana<=manamax/2 or tg.target:HasModifier("modifier_item_diffusal_blade_witchcraft_debuff") then
                self.dam=self.mana_base+manamax*self.mana_pe*0.01
            end
                local damageTable = {
                    victim = tg.target,
                    attacker = self.parent,
                    damage = self.dam,
                    damage_type =DAMAGE_TYPE_PHYSICAL,
                    ability = self.ability,
                    }
                ApplyDamage(damageTable)
                tg.target:ReduceMana(self.dam)
            end

     --[[ if RollPseudoRandomPercentage(self.ch,0,self:GetParent()) then
            if not tg.target:IsMagicImmune() then
                tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_diffusal_blade_witchcraft_debuff3", {duration=1})
            end
        end]]
    end
end

function modifier_item_diffusal_blade_witchcraft_pa:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_item_diffusal_blade_witchcraft_pa:GetModifierBonusStats_Agility()
    return self.agi
end


modifier_item_diffusal_blade_witchcraft_debuff=class({})

function modifier_item_diffusal_blade_witchcraft_debuff:IsDebuff()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsHidden()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsPurgable()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff:IsPurgeException()
    return false
end



function modifier_item_diffusal_blade_witchcraft_debuff:OnCreated()
    self.parent=self:GetParent()
    if not IsServer() then
        return
    end
    self.curmana=self.parent:GetMana()
    self.mana=0-self.parent:GetMaxMana()
end

function modifier_item_diffusal_blade_witchcraft_debuff:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:GiveMana(self.curmana)
end


function modifier_item_diffusal_blade_witchcraft_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MANA_BONUS,
    }
end

function modifier_item_diffusal_blade_witchcraft_debuff:GetModifierManaBonus()
    if self.mana~=nil then
        return self.mana
    else
        return 0
end
end

modifier_item_diffusal_blade_witchcraft_debuff2=class({})

function modifier_item_diffusal_blade_witchcraft_debuff2:IsDebuff()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff2:IsHidden()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff2:IsPurgable()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff2:IsPurgeException()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff2:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_diffusal_blade_witchcraft_debuff2:GetEffectName()
    return "particles/tgp/items/diffusal_blade/bloodstone_heal_change.vpcf"
end


function modifier_item_diffusal_blade_witchcraft_debuff2:OnCreated()
    if not self:GetAbility() then
		return
	end
    self.sp=0-self:GetAbility():GetSpecialValueFor("sp")
end


function modifier_item_diffusal_blade_witchcraft_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_diffusal_blade_witchcraft_debuff2:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end

modifier_item_diffusal_blade_witchcraft_debuff3=class({})

function modifier_item_diffusal_blade_witchcraft_debuff3:IsDebuff()
    return true
end

function modifier_item_diffusal_blade_witchcraft_debuff3:IsHidden()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff3:IsPurgable()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff3:IsPurgeException()
    return false
end

function modifier_item_diffusal_blade_witchcraft_debuff3:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(FrameTime())

end

function modifier_item_diffusal_blade_witchcraft_debuff3:OnIntervalThink()

    self:GetParent():Stop()
end
