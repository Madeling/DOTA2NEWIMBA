LinkLuaModifier("modifier_item_abyssal_blade_v2_pa", "items/item_abyssal_blade_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyssal_blade_v2_debuff", "items/item_abyssal_blade_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_abyssal_blade_v2_debuff2", "items/item_abyssal_blade_v2.lua", LUA_MODIFIER_MOTION_NONE)
item_abyssal_blade_v2= class({})

function item_abyssal_blade_v2:GetIntrinsicModifierName()return "modifier_item_abyssal_blade_v2_pa"
end

function item_abyssal_blade_v2:OnSpellStart()
       -- local t1 = GetSystemTimeMS()
        self.caster=self.caster or self:GetCaster()
        self.stun_m=self.stun_m or self:GetSpecialValueFor("stun_m")
        self.pa_dur=self.pa_dur or self:GetSpecialValueFor("pa_dur")
        local target=self:GetCursorTarget()
        local tpos=target:GetAbsOrigin()
        if  target:TG_TriggerSpellAbsorb(self) then
                return
        end
        EmitSoundOn("DOTA_Item.AbyssalBlade.Activate",target)
        target:AddNewModifier_RS(self.caster, self, "modifier_item_abyssal_blade_v2_debuff", {duration=self.stun_m})
        target:AddNewModifier_RS(self.caster, self, "modifier_item_abyssal_blade_v2_debuff2", {duration=self.pa_dur})
       self.caster:MoveToPositionAggressive(tpos)
      -- local t2 =GetSystemTimeMS()
       --print(string.format("time: %.10f\n", t2 - t1))
end

modifier_item_abyssal_blade_v2_pa = class({})

function modifier_item_abyssal_blade_v2_pa:GetTexture()return "item_abyssal_blade"
end
function modifier_item_abyssal_blade_v2_pa:IsHidden()return true
end
function modifier_item_abyssal_blade_v2_pa:IsPurgable()return false
end
function modifier_item_abyssal_blade_v2_pa:IsPurgeException()return false
end
function modifier_item_abyssal_blade_v2_pa:AllowIllusionDuplicate()return false
end

function modifier_item_abyssal_blade_v2_pa:DeclareFunctions()
        return
        {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
            MODIFIER_EVENT_ON_ATTACK_LANDED,
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
        }
end


function modifier_item_abyssal_blade_v2_pa:OnCreated()
    self.ability,self.parent,self.stunned,self.cd=self:GetAbility(),self:GetParent(),true,1.5
    if not  self.ability then
		return
    end
    self.att, self.str,self.stun,self.ch_r,self.ch_m,self.dam=
    self.ability:GetSpecialValueFor("att"),
    self.ability:GetSpecialValueFor("str"),
    self.ability:GetSpecialValueFor("stun"),
    self.ability:GetSpecialValueFor("ch_r"),
    self.ability:GetSpecialValueFor("ch_m"),
    self.ability:GetSpecialValueFor("dam")
    self.damageTable = {
        attacker = self.parent,
        damage = self.dam,
        ability = self.ability,
        damage_type =DAMAGE_TYPE_PHYSICAL
        }
end

function modifier_item_abyssal_blade_v2_pa:OnIntervalThink()
    self.stunned=true
    self:StartIntervalThink(-1)
end

function modifier_item_abyssal_blade_v2_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent and not self.parent:Has_Ability_Table(NOT_Abyssal_Blade) and not tg.target:IsBuilding() and not self.parent:IsIllusion() then
        local ch=self.parent:IsRangedAttacker() and self.ch_r or self.ch_m
        if  RollPseudoRandomPercentage(ch,0,self.ability) then
            if self.stunned==true then
                self.stunned=false
                self:StartIntervalThink(self.cd)
                tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_imba_stunned", {duration=self.stun})
            end
            self.damageTable.victim = tg.target
            ApplyDamage(self.damageTable)
        end
    end
end

function modifier_item_abyssal_blade_v2_pa:GetModifierPreAttack_BonusDamage()return  self.att
end

function modifier_item_abyssal_blade_v2_pa:GetModifierBonusStats_Strength()return  self.str
end


 modifier_item_abyssal_blade_v2_debuff=class({})

function modifier_item_abyssal_blade_v2_debuff:GetTexture()return "item_abyssal_blade_v2"
end

function modifier_item_abyssal_blade_v2_debuff:IsDebuff()return true
end

function modifier_item_abyssal_blade_v2_debuff:IsHidden()return false
end

function modifier_item_abyssal_blade_v2_debuff:IsPurgable()return false
end

function modifier_item_abyssal_blade_v2_debuff:IsPurgeException()return true
end

function modifier_item_abyssal_blade_v2_debuff:OnCreated()
        local pfx1=ParticleManager:CreateParticle("particles/items_fx/abyssal_blade.vpcf", PATTACH_OVERHEAD_FOLLOW,self:GetParent())
        ParticleManager:ReleaseParticleIndex( pfx1)
end

function modifier_item_abyssal_blade_v2_debuff:OnRefresh()
        self:OnCreated()
end


function modifier_item_abyssal_blade_v2_debuff:CheckState()
        return
        {
            [MODIFIER_STATE_STUNNED] = true,
        }
end

modifier_item_abyssal_blade_v2_debuff2=class({})

function modifier_item_abyssal_blade_v2_debuff2:GetTexture()return "item_abyssal_blade_v2"
end

function modifier_item_abyssal_blade_v2_debuff2:IsDebuff()return true
end


function modifier_item_abyssal_blade_v2_debuff2:IsHidden()return false
end

function modifier_item_abyssal_blade_v2_debuff2:IsPurgable()return true
end

function modifier_item_abyssal_blade_v2_debuff2:IsPurgeException()return true
end


function modifier_item_abyssal_blade_v2_debuff2:CheckState()
        return
        {
            [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        }
end