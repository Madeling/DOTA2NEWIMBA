bunny_hop = class({})
LinkLuaModifier("modifier_bunny_hop_motion", "heros/hero_enchantress/bunny_hop.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bunny_hop_buff", "heros/hero_enchantress/bunny_hop.lua", LUA_MODIFIER_MOTION_NONE)
function bunny_hop:IsHiddenWhenStolen()
    return false
end

function bunny_hop:IsStealable()
    return true
end


function bunny_hop:IsRefreshable()
    return true
end

function bunny_hop:GetCooldown(iLevel)
        return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_enchantress_3")
end


function bunny_hop:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:Has_Aghanims_Shard() then
		self:SetLevel(1)
		self:SetHidden(false)
    end
end

function bunny_hop:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local cur_pos=self:GetCursorPosition()
	local fw = self:GetSpecialValueFor("dis")
    	local dis=TG_Distance(caster_pos,cur_pos+caster:GetForwardVector()*fw)--
	local dir=TG_Direction(caster_pos,cur_pos)
	local sp=self:GetSpecialValueFor("speed")
	if dis > fw then
		dis=fw
	end
    local time=dis/sp
	caster:EmitSound("Hero_Enchantress.EnchantCreep")
	caster:AddNewModifier(caster, self, "modifier_bunny_hop_motion", {duration=time,dir=dir,sp=sp})
end

modifier_bunny_hop_motion=class({})

function modifier_bunny_hop_motion:IsHidden()
    return true
end

function modifier_bunny_hop_motion:IsPurgable()
    return false
end

function modifier_bunny_hop_motion:IsPurgeException()
    return false
end

function modifier_bunny_hop_motion:OnCreated(tg)
    if not IsServer() then
        return
	end
	local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
	if #heros>0 then
        for a=1,4 do
			self:GetParent():PerformAttack(heros[RandomInt(1,#heros)],true, false, true, false, true, false, false)
        end
    end
    	local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle( particle, false, false, 20, false, false )
	self.SP=tg.sp
    	self.DIR=ToVector(tg.dir)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_bunny_hop_motion:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
	end

	if  not self:GetParent():IsAlive() then
        self:Destroy()
    else
		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (self.SP / (1.0 / FrameTime())))
    end

end

function modifier_bunny_hop_motion:OnHorizontalMotionInterrupted()
    if  IsServer() then
		self:Destroy()
	end
end


function modifier_bunny_hop_motion:OnDestroy()

    if  IsServer() then
		self:GetParent():AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_bunny_hop_buff", {duration=self:GetAbility():GetSpecialValueFor("dur")})
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end

function modifier_bunny_hop_motion:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_bunny_hop_motion:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function modifier_bunny_hop_motion:GetModifierTurnRate_Percentage()
	return 100
end


modifier_bunny_hop_buff= class({})

function modifier_bunny_hop_buff:IsHidden()
	return false
end

function modifier_bunny_hop_buff:IsPurgable()
	return false
end

function modifier_bunny_hop_buff:IsPurgeException()
	return false
end

function modifier_bunny_hop_buff:OnCreated()
	self.AttackR=self:GetAbility():GetSpecialValueFor("AttackR")
end

function modifier_bunny_hop_buff:OnRefresh()
	self:OnCreated()
end


function modifier_bunny_hop_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_bunny_hop_buff:GetModifierAttackRangeBonus()
	return self.AttackR
end
