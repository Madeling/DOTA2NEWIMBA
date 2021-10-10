CreateTalents("npc_dota_hero_juggernaut", "heros/hero_juggernaut/blade_fury.lua")
blade_fury=class({})
LinkLuaModifier("modifier_blade_fury_buff", "heros/hero_juggernaut/blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blade_fury_buff2", "heros/hero_juggernaut/blade_fury.lua", LUA_MODIFIER_MOTION_NONE)

function blade_fury:IsHiddenWhenStolen()
    return false
end

function blade_fury:IsStealable()
    return true
end


function blade_fury:IsRefreshable()
    return true
end

function blade_fury:CastFilterResult(tg)
    local caster=self:GetCaster()
    if not caster:HasModifier("modifier_blade_dance_move") and (caster:IsNightmared() or caster:IsStunned() or caster:IsFrozen() or caster:IsHexed()) then
        return UF_FAIL_CUSTOM
	end
end

function blade_fury:GetCustomCastError(tg)
    return "被控制无法使用"
end


function blade_fury:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local dur=self:GetSpecialValueFor("dur")+caster:TG_GetTalentValue("special_bonus_juggernaut_1")
    caster:AddNewModifier(caster, self, "modifier_blade_fury_buff2", {duration =dur })
    caster:Purge(false,true,false,false,false)
    caster:AddNewModifier(caster, self, "modifier_blade_fury_buff", {duration = dur})
end



modifier_blade_fury_buff = class({})

function modifier_blade_fury_buff:IsHidden()
	return false
end

function modifier_blade_fury_buff:IsPurgable()
	return false
end

function modifier_blade_fury_buff:IsPurgeException()
	return false
end

function modifier_blade_fury_buff:OnCreated(tg)
    self.RD=self:GetAbility():GetSpecialValueFor("rd")+self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_2")
    self.TICK=self:GetAbility():GetSpecialValueFor("tick")
    self.DAM=self:GetAbility():GetSpecialValueFor("dam")*self.TICK
    self.des_rd=self:GetAbility():GetSpecialValueFor("des_rd")
    if not IsServer() then
        return
    end
        self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
        self.IS_COL=false
        local fx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(fx,0, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(fx,5,Vector( self.RD,1,1))
        self:AddParticle( fx, false, false, 4, false, false )
		self:StartIntervalThink(self.TICK)
end

function modifier_blade_fury_buff:OnRefresh(tg)
    self:OnDestroy()
    self:OnCreated(tg)
end

function modifier_blade_fury_buff:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.RD,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
    if #heros>0 then
            for _, hero in pairs(heros) do
                if hero:IsAlive() and not hero:IsMagicImmune()then
                    EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Hero_Juggernaut.BladeFury.Impact", hero)
                    local damageTable = {
                        victim = hero,
                        attacker = self:GetParent(),
                        damage =self.DAM,
                        damage_type =DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                        }
                    ApplyDamage(damageTable)
                end
            end
    end
end


function modifier_blade_fury_buff:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
    self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
end

function modifier_blade_fury_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
 }
end

function modifier_blade_fury_buff:GetOverrideAnimation(tg)
        return ACT_DOTA_OVERRIDE_ABILITY_1
end

function modifier_blade_fury_buff:CheckState()
	return
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end

modifier_blade_fury_buff2= class({})

function modifier_blade_fury_buff2:IsHidden()
	return false
end

function modifier_blade_fury_buff2:IsPurgable()
	return false
end

function modifier_blade_fury_buff2:IsPurgeException()
	return false
end

function modifier_blade_fury_buff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
 }
end

function modifier_blade_fury_buff2:GetModifierMagicalResistanceBonus()
        return 100
end