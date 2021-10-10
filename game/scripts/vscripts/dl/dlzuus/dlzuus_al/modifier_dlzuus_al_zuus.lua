modifier_dlzuus_al_zuus = ({})

function modifier_dlzuus_al_zuus:IsHidden() return true end
function modifier_dlzuus_al_zuus:IsBuff() return true end
function modifier_dlzuus_al_zuus:IsDebuff() return false end
function modifier_dlzuus_al_zuus:IsStunDebuff() return false end
function modifier_dlzuus_al_zuus:IsPurgable() return false end
function modifier_dlzuus_al_zuus:IsPurgeException() return false end
function modifier_dlzuus_al_zuus:RemoveOnDeath() return self:GetCaster():IsIllusion() or true end

function modifier_dlzuus_al_zuus:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_dlzuus_al_zuus:OnAttackLanded( params )
    if not IsServer() then return end
    if params.attacker~=self:GetParent() then return end
	if not params.target then return end	--可能能防报错吧我也不知道随手一加
	if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
	if self:GetParent():PassivesDisabled() then return end
	if params.target:IsBuilding() then return end
	if params.target:IsMagicImmune() then return end
	--if params.attacker:IsIllusion() then return end --分身可继承吗？也许可以做成天赋，或者分身概率触发。

    local attacker = self:GetParent()
    local target = params.target
    local dur = self:GetAbility():GetSpecialValueFor("al_delay")

	if target:HasModifier("modifier_dlzuus_al_target") then return end --不能让目标modi刷新，要不攻速太快连不出去
    local debuff = target:AddNewModifier(
					attacker, -- player source
					self:GetAbility(), -- ability source
					"modifier_dlzuus_al_target", -- modifier name
					{
						duration = dur
					} -- kv
                )

	self:playeffects(attacker,target)

end

function modifier_dlzuus_al_zuus:playeffects(z,t)
    local particle_cast = "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"
    local sound_cast = "Hero_Zuus.ArcLightning.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    local zpos = z:GetAbsOrigin()   zpos.z = zpos.z+100
    local tpos = t:GetAbsOrigin() tpos.z = tpos.z+100   --不加100在脚底下，调成0在地底下

    ParticleManager:SetParticleControl( effect_cast, 0, zpos )
	ParticleManager:SetParticleControl( effect_cast, 1, tpos )
	ParticleManager:SetParticleControl(effect_cast, 62, Vector(0,100,200))

	ParticleManager:ReleaseParticleIndex( effect_cast )
    EmitSoundOn( sound_cast, t )
end
