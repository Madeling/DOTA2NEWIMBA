CreateTalents("npc_dota_hero_lycan", "heros/hero_lycan/wolf_bite.lua")
wolf_bite=class({})

LinkLuaModifier("modifier_wolf_bite_buff", "heros/hero_lycan/wolf_bite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wolf_bite_debuff", "heros/hero_lycan/wolf_bite.lua", LUA_MODIFIER_MOTION_NONE)
function wolf_bite:IsHiddenWhenStolen()
    return false
end

function wolf_bite:IsStealable()
    return true
end

function wolf_bite:IsRefreshable()
    return true
end

function wolf_bite:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:HasScepter() then
		self:SetLevel(1)
        self:SetHidden(false)
    else
        self:SetLevel(0)
        self:SetHidden(true)
    end
end


function wolf_bite:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local pos = target:GetAbsOrigin()
    local duration=self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
    local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,target)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:ReleaseParticleIndex(particle)
    target:AddNewModifier(caster, self, "modifier_wolf_bite_buff", {duration=duration})
end


modifier_wolf_bite_buff=class({})

function modifier_wolf_bite_buff:IsHidden()
    return false
end

function modifier_wolf_bite_buff:IsPurgable()
    return false
end

function modifier_wolf_bite_buff:IsPurgeException()
    return false
end

function modifier_wolf_bite_buff:RemoveOnDeath()
    return false
end

function modifier_wolf_bite_buff:GetEffectName()
    return "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
end


function modifier_wolf_bite_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_wolf_bite_buff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_wolf_bite_buff:GetModifierModelChange()
    return "models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl"
end

function modifier_wolf_bite_buff:AllowIllusionDuplicate()
    return true
end


function modifier_wolf_bite_buff:OnCreated()
    self.crit = {}
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.crit_multiplier=self.ability:GetSpecialValueFor("crit_multiplier")
    self.crit_chance=self.ability:GetSpecialValueFor("crit_chance")
    self.speed=self.ability:GetSpecialValueFor("speed")
    self.chance=self.ability:GetSpecialValueFor("chance")
    self.dam=self.ability:GetSpecialValueFor("dam")
end

function modifier_wolf_bite_buff:OnRefresh()
    self:OnCreated()
end

function modifier_wolf_bite_buff:OnDestroy()
    self.crit = nil
    if not IsServer() then
        return
    end
    local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
    ParticleManager:SetParticleControl(particle, 0,self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3,self.parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
end


function modifier_wolf_bite_buff:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() then
		return
	end
    if tg.attacker == self.parent and not tg.target:IsBuilding() and not self.parent:IsIllusion() then
        if RollPseudoRandomPercentage(self.crit_chance,0,self.parent) then
            self.crit[tg.record] = true
            return  self.crit_multiplier
		else
			return 0
		end
	end
end


function modifier_wolf_bite_buff:OnAttackFail(tg)
    if not IsServer() then
        return
    end
    self.crit[tg.record] = nil
end



function modifier_wolf_bite_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_wolf_bite_buff:GetModifierMoveSpeedBonus_Constant()
	return  self.speed
end

function modifier_wolf_bite_buff:CheckState()
    return
    {
        [MODIFIER_STATE_UNSLOWABLE] = true,
    }
end


function modifier_wolf_bite_buff:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self.parent or  tg.target:IsBuilding() then
		return
    end
    if tg.target:IsRealHero() then
        tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_wolf_bite_debuff", {duration=10})
    end
    if RollPseudoRandomPercentage(self.chance,0,self.parent) then
        local p = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_crit_overtheshoulder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(p, 0,self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControlForward(p, 1,self.parent:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(p)
        local damageTable = {
            victim = tg.target,
            attacker = self.parent,
            damage = self.dam*0.01*self.parent:GetAverageTrueAttackDamage(self.parent),
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR,
            ability = self.ability,
            }
        ApplyDamage(damageTable)
    end
end


modifier_wolf_bite_debuff=class({})

function modifier_wolf_bite_debuff:IsHidden()
    return false
end

function modifier_wolf_bite_debuff:IsPurgable()
    return false
end

function modifier_wolf_bite_debuff:IsPurgeException()
    return false
end

function modifier_wolf_bite_debuff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    if IsServer() then
        local p = ParticleManager:CreateParticleForPlayer("particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_ground_default.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent,PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()))
        ParticleManager:SetParticleControl(p, 0,self.parent:GetAbsOrigin())
        self:AddParticle(p, false, false, -1, false, false)
    end
end

function modifier_wolf_bite_debuff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
end

function modifier_wolf_bite_debuff:GetModifierProvidesFOWVision()
	return 1
end
