axe_sprint = class({})
LinkLuaModifier("modifier_axe_sprint_motion", "heros/hero_axe/axe_sprint.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_axe_sprint_hp", "heros/hero_axe/axe_sprint.lua", LUA_MODIFIER_MOTION_NONE)

function axe_sprint:IsHiddenWhenStolen()return false
end
function axe_sprint:IsStealable() return true
end
function axe_sprint:IsRefreshable()return true
end

function axe_sprint:OnSpellStart()
	local caster=self:GetCaster()
	local casterpos=caster:GetAbsOrigin()
	local curpos=self:GetCursorPosition()
	local direction = TG_Direction(curpos,casterpos)
	local distance =TG_Distance(casterpos,curpos)
	local dis=self:GetSpecialValueFor("dis")
	if distance>dis then
		distance=dis
	end
	local duration=distance/self:GetSpecialValueFor("speed")
	caster:AddNewModifier(caster, self, "modifier_axe_sprint_motion", {duration = duration, direction = direction})
	caster:AddNewModifier(caster, self, "modifier_axe_sprint_hp", {duration =self:GetSpecialValueFor( "hp_time")+caster:TG_GetTalentValue("special_bonus_axe_4")  })
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

function axe_sprint:GetCastRange()
	return self:GetSpecialValueFor("dis")
end

--飞跃
modifier_axe_sprint_motion = modifier_axe_sprint_motion or class({})

function modifier_axe_sprint_motion:IsDebuff()return false
end

function modifier_axe_sprint_motion:IsHidden()return true
end

function modifier_axe_sprint_motion:IsPurgable()return false
end

function modifier_axe_sprint_motion:IsPurgeException()return false
end

function modifier_axe_sprint_motion:OnCreated(tg)
	if IsServer() then
		self.direction=ToVector(tg.direction)
			if not self:ApplyHorizontalMotionController()then
				self:Destroy()
			end
	end
end

function modifier_axe_sprint_motion:UpdateHorizontalMotion( t, g )
	self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.direction* (1500 / (1.0 / g)))
end

function modifier_axe_sprint_motion:OnDestroy()

	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		EmitSoundOn( "TG.axejump", self:GetParent() )
		local particle = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(particle)
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end

function modifier_axe_sprint_motion:GetEffectName()
	return "particles/heros/axe/axe_sp_m.vpcf"
end

function modifier_axe_sprint_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_axe_sprint_motion:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end


function modifier_axe_sprint_motion:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

--生命恢复加成
modifier_axe_sprint_hp = modifier_axe_sprint_hp or class({})

function modifier_axe_sprint_hp:IsBuff()
	return true
end

function modifier_axe_sprint_hp:IsHidden()
	return false
end

function modifier_axe_sprint_hp:IsPurgable()
	return false
end

function modifier_axe_sprint_hp:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_axe_sprint_hp:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("hp")+self:GetParent():TG_GetTalentValue("special_bonus_axe_3")
end
