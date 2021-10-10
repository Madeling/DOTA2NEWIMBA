CreateTalents("npc_dota_hero_night_stalker", "heros/hero_night_stalker/void.lua")
void = void or class({})

LinkLuaModifier("modifier_void", "heros/hero_night_stalker/void.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_void_debuff", "heros/hero_night_stalker/void.lua", LUA_MODIFIER_MOTION_NONE)
function void:IsHiddenWhenStolen()
    return false
end

function void:IsStealable()
    return true
end


function void:IsRefreshable()
    return true
end

function void:GetAOERadius()
    return self:GetSpecialValueFor("rd")
end



function void:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos =caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = TG_Direction(target_pos,caster_pos)
	local distance =TG_Distance(caster_pos,target_pos)
	local jumpsp=GameRules:IsDaytime() and self:GetSpecialValueFor("j_d") or self:GetSpecialValueFor("j_n")
	local j_dis=self:GetSpecialValueFor("j_dis")
	local pfx_pos=target_pos
	if distance>j_dis then
		distance=j_dis
		pfx_pos=caster_pos+direction*j_dis
	end

	local duration = distance / jumpsp
	caster:EmitSound("Hero_Nightstalker.Void")
	caster:AddNewModifier(caster, self, "modifier_void", {duration = duration,pfx_pos=pfx_pos, direction = direction,distance=distance,sp=jumpsp})
	local particle1 = ParticleManager:CreateParticle("particles/items_fx/abyssal_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW , caster)
    ParticleManager:ReleaseParticleIndex(particle1)
end


modifier_void = modifier_void or class({})


function modifier_void:IsHidden()
	return true
end

function modifier_void:RemoveOnDeath()
	return false
end


function modifier_void:OnCreated(tg)
	if IsServer() then
		self.spos=self:GetParent():GetAbsOrigin()
		self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_3_END )
		self.direction = ToVector(tg.direction)
		self.sp = tg.sp
		local particle= ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_WORLDORIGIN,nil)
		ParticleManager:SetParticleControl(particle, 0,ToVector(tg.pfx_pos))
		ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("rd"), 0, 0))
		ParticleManager:SetParticleControl(particle, 2, Vector(20, 0, 0))
		ParticleManager:SetParticleControl(particle, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(particle, 15, Vector(65,105,225))
		self:AddParticle(particle, true, false, 1, false, false)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
	end
end

function modifier_void:UpdateHorizontalMotion( t, g )
	self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.direction*(self.sp  / (1.0 / g)))
end

function modifier_void:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_void:OnDestroy()
    if IsServer() then
		self:GetParent():RemoveGesture( ACT_DOTA_CAST_ABILITY_3_END )
		local dam=self:GetAbility():GetSpecialValueFor("dam")
		local damt=GameRules:IsDaytime() and DAMAGE_TYPE_MAGICAL or DAMAGE_TYPE_PURE
		local particle2 = ParticleManager:CreateParticle("particles/items_fx/abyssal_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW ,  self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle2)
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,self:GetAbility():GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies>0 then
			for _, target in pairs(enemies) do
				if target:IsHero() then
					self.target=target
				end
				local damageTable = {
					victim = target,
					attacker =self:GetParent(),
					damage =dam,
					damage_type = damt,
					ability = self:GetAbility(),
					}
					ApplyDamage(damageTable)
			end
		end
		if self.target and  IsValidEntity(self.target) and not self.target:IsMagicImmune() then
			FindClearSpaceForUnit( self:GetParent(), self.spos, true )
			FindClearSpaceForUnit( self.target, self.spos, true )
			self.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_void_debuff", {duration = self:GetAbility():GetSpecialValueFor("dur")})
		else
			FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
		end
		self:GetParent():RemoveHorizontalMotionController(self)
    end
end


function modifier_void:CheckState()
	return
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end


function modifier_void:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end



modifier_void_debuff =modifier_void_debuff or class({})

function modifier_void_debuff:IsDebuff()
	return true
end

function modifier_void_debuff:IsHidden()
	return false
end

function modifier_void_debuff:IsPurgable()
	return true
end

function modifier_void_debuff:IsPurgeException()
	return true
end

function modifier_void_debuff:OnCreated()

	self.v=self:GetAbility():GetSpecialValueFor("v")
	self.sp_n=self:GetAbility():GetSpecialValueFor("sp_n")
	if IsServer() then
		local particle =ParticleManager:CreateParticle("particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle( particle, false, false, 20, false, false )
	end
end

function modifier_void_debuff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 }
end

function modifier_void_debuff:GetBonusVisionPercentage()
	return 0-(self.v+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_1"))
end

function modifier_void_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.sp_n
end
