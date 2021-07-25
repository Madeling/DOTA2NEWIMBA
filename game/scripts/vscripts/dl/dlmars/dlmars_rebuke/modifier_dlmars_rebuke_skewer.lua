
modifier_dlmars_rebuke_skewer = class({})

function modifier_dlmars_rebuke_skewer:IsDebuff()			return false end
function modifier_dlmars_rebuke_skewer:IsHidden() 			return true end
function modifier_dlmars_rebuke_skewer:IsPurgable() 		return false end
function modifier_dlmars_rebuke_skewer:IsPurgeException() 	return false end
function modifier_dlmars_rebuke_skewer:IsStunDebuff()		return true end
function modifier_dlmars_rebuke_skewer:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_dlmars_rebuke_skewer:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_dlmars_rebuke_skewer:GetModifierDisableTurning() return 1 end
function modifier_dlmars_rebuke_skewer:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_3 end
function modifier_dlmars_rebuke_skewer:IsMotionController() return true end
function modifier_dlmars_rebuke_skewer:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_dlmars_rebuke_skewer:OnCreated(keys)
	if IsServer() then
		self.hitted = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed = self:GetAbility():GetSpecialValueFor("rebuke_rushspeed")
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_shield", self:GetParent():GetAbsOrigin(), true)
			self:AddParticle(pfx, false, false, 15, false, false)
		else
			self:Destroy()
		end
	end
end

function modifier_dlmars_rebuke_skewer:OnIntervalThink()
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	local horn_pos = self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_shield"))     --下面这个150是吸人半径，意味着总宽度是300
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) and not enemy:HasModifier("modifier_imba_tricks_of_the_trade_caster") then
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dlmars_rebuke_stun", {})
			self.hitted[#self.hitted+1] = enemy
		end
	end
	for i, enemy in pairs(self.hitted) do
		if enemy and enemy:IsAlive() then
			enemy:SetOrigin(GetGroundPosition(horn_pos, nil))
		else
			self.hitted[i] = nil
		end
	end
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("rebuke_tree"), false)        --破坏沿途树木
end

----------------------------------

function modifier_dlmars_rebuke_skewer:OnDestroy()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local radius = ability:GetSpecialValueFor("rebuke_radius")
    local angle = ability:GetSpecialValueFor("rebuke_angle")/2 		--不要忘了除以2
    local cast_direction = caster:GetForwardVector() --(ability.point-caster:GetOrigin()):Normalized() 用这个有时候会歪

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	for _, enemy in pairs(self.hitted) do   --拱结束给每个敌人去除眩晕，安排空位
		if enemy then
			local a = enemy:FindModifierByNameAndCaster("modifier_dlmars_rebuke_stun", self:GetParent()) and enemy:FindModifierByNameAndCaster("modifier_dlmars_rebuke_stun", self:GetParent()):Destroy() or 1
			FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
            enemy:Stop()
        end
    end

    ability:duangduang(radius,angle,cast_direction,true)    --true意味着冲击盾，不会触发环形炖鸡

    self.hitted = nil
	self.pos = nil
	self.speed = nil

end
