dragon_blood=class({})

LinkLuaModifier("modifier_dragon_blood", "heros/hero_dragon_knight/dragon_blood.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_blood_buff", "heros/hero_dragon_knight/dragon_blood.lua", LUA_MODIFIER_MOTION_NONE)

function dragon_blood:GetIntrinsicModifierName()
    return "modifier_dragon_blood"
end

function dragon_blood:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local target_pos = caster:GetCursorPosition()
    local dis = self:GetSpecialValueFor("dis")
    local wh = self:GetSpecialValueFor("wh")
    local dir = TG_Direction(target_pos,pos)
    EmitSoundOn( "TG.dg", caster)
    if caster:HasModifier("modifier_elder_dragon_form") then
        caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local projectile = {
        Ability = self,
        EffectName = "particles/tgp/dk/azuremircourierfinal1.vpcf",
        vSpawnOrigin =pos,
        fDistance = dis,
        fStartRadius = wh,
        fEndRadius = wh,
        fExpireTime = GameRules:GetGameTime() + 10,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        bProvidesVision = true,
        iVisionRadius = 500,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity = dir*1500,
    }
    ProjectileManager:CreateLinearProjectile(projectile)

end

function dragon_blood:OnProjectileHit_ExtraData( target, vLocation, kv )
    local caster = self:GetCaster()
    if target==nil then
        return
    end
    if not target:IsMagicImmune() then
        local dam = self:GetSpecialValueFor("dam")
        local dur = self:GetSpecialValueFor("dur")+caster:TG_GetTalentValue("special_bonus_dragon_knight_6")
        local att = self:GetSpecialValueFor("att")
        local damageTable = {
            victim = target,
            attacker = caster,
            damage =dam,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
            }
        ApplyDamage(damageTable)
        caster:AddNewModifier(caster, self, "modifier_dragon_blood_buff", {duration=dur,att=att})
    end

end


modifier_dragon_blood=class({})

function modifier_dragon_blood:IsPassive()
	return true
end

function modifier_dragon_blood:IsPurgable()
    return false
end

function modifier_dragon_blood:IsPurgeException()
    return false
end

function modifier_dragon_blood:IsHidden()
    return true
end


function modifier_dragon_blood:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_dragon_blood:OnCreated()
    self.ability=self:GetAbility()
    self.ar=self.ability:GetSpecialValueFor("bonus_armor")
    self.hr=self.ability:GetSpecialValueFor("bonus_health_regen")
end

function modifier_dragon_blood:OnRefresh()
   self:OnCreated()
end


function modifier_dragon_blood:GetModifierPhysicalArmorBonus()
    if self:GetCaster():TG_HasTalent("special_bonus_dragon_knight_8") then
        return self.ar*2
    else
        return self.ar
    end
end

function modifier_dragon_blood:GetModifierConstantHealthRegen()
    if self:GetCaster():TG_HasTalent("special_bonus_dragon_knight_8") then
        return self.hr*2
    else
        return self.hr
    end
end


modifier_dragon_blood_buff=class({})


function modifier_dragon_blood_buff:IsPurgable()
    return false
end

function modifier_dragon_blood_buff:IsPurgeException()
    return false
end

function modifier_dragon_blood_buff:IsHidden()
    return false
end


function modifier_dragon_blood_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_dragon_blood_buff:OnCreated(tg)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+tg.att)
    end
end

function modifier_dragon_blood_buff:OnRefresh(tg)
   self:OnCreated(tg)
end


function modifier_dragon_blood_buff:GetModifierMagicalResistanceBonus()
    return self:GetStackCount()
end

function modifier_dragon_blood_buff:GetModifierPhysicalArmorBonus()
    return self:GetStackCount()
end
