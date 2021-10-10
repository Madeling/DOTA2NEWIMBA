-- Editors:
-- MysticBug, 25.09.2021
--Abilities
monster_killer_witch_potion = class({})

LinkLuaModifier( "modifier_monster_killer_witch_potion_buff", "mb/monster_killer/monster_killer_witch_potion.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monster_killer_witch_potion_immune", "mb/monster_killer/monster_killer_witch_potion.lua", LUA_MODIFIER_MOTION_NONE )

function monster_killer_witch_potion:IsHiddenWhenStolen() 			return false end
function monster_killer_witch_potion:IsRefreshable() 				return true end
function monster_killer_witch_potion:IsStealable() 					return true end
function monster_killer_witch_potion:Set_InitialUpgrade() 		return {LV=1,CD=true}  end
function monster_killer_witch_potion:OnSpellStart()
	local caster              = self:GetCaster()
	local target              = self:GetCursorTarget()
	local sound_cast          = "Hero_Alchemist.BerserkPotion.Cast"
	local resistant_duration  = self:GetSpecialValueFor("duration")
	local stack               = self:GetSpecialValueFor("stack")
	local wolf_blood_duration = self:GetSpecialValueFor("wolf_blood_duration")
	--音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
	--添加持续效果
	target:AddNewModifier(caster, self, "modifier_monster_killer_witch_potion_buff", {duration = resistant_duration})
	--wolf blood
	if target:HasModifier("modifier_monster_killer_shapeshift_buff") then 
		local modifier = target:FindModifierByName("modifier_monster_killer_shapeshift_buff")
		local duration = (modifier:GetRemainingTime() + wolf_blood_duration)
		modifier:SetDuration(duration, true)
	elseif target:HasAbility("monster_killer_shapeshift") then 
		target:SetModifierStackCount("modifier_monster_killer_shapeshift_pa", nil, target:GetModifierStackCount("modifier_monster_killer_shapeshift_pa", nil) + stack)
	end
	--[[if target ~= caster then 
		caster:Purge(false, true, false, true, true)
		caster:AddNewModifier(caster, self, "modifier_monster_killer_witch_potion_buff", {duration = resistant_duration})
	end]]
end
--攻速 回复
modifier_monster_killer_witch_potion_buff = class({})

function modifier_monster_killer_witch_potion_buff:IsDebuff()			return false end
function modifier_monster_killer_witch_potion_buff:IsHidden() 			return false end
function modifier_monster_killer_witch_potion_buff:IsPurgable() 			return true end
function modifier_monster_killer_witch_potion_buff:IsPurgeException() 	return true end
function modifier_monster_killer_witch_potion_buff:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_monster_killer_witch_potion_buff:OnCreated(keys)
	if IsServer() then 
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_berserk_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx,0,self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 20, false, false)
	end 
 end
function modifier_monster_killer_witch_potion_buff:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attack_speed") end
function modifier_monster_killer_witch_potion_buff:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("hp_regen") end
function modifier_monster_killer_witch_potion_buff:GetModifierStatusResistanceStacking() return self:GetAbility():GetSpecialValueFor("status_resistance") end
function modifier_monster_killer_witch_potion_buff:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("status_resistance") end
function modifier_monster_killer_witch_potion_buff:OnDestroy() end

--天赋
modifier_monster_killer_witch_potion_immune = class({})

function modifier_monster_killer_witch_potion_immune:IsHidden() 			return false end
function modifier_monster_killer_witch_potion_immune:IsPurgable() 		return false end
function modifier_monster_killer_witch_potion_immune:IsPurgeException() return false end
function modifier_monster_killer_witch_potion_immune:GetEffectName() 	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_monster_killer_witch_potion_immune:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_monster_killer_witch_potion_immune:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end