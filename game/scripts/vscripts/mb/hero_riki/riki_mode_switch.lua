--2021 01 13 by MysticBug-------
--------------------------------
--------------------------------

ENUM_DAGGER_DANCER = 1
ENUM_ASSASSINATION = 2
ENUM_POISONED = 3
------------------------------------------------------------
----------------     IMBA_RIKI_MODE_SWITCH   ---------------
------------------------------------------------------------
imba_riki_mode_switch = class({})

LinkLuaModifier("modifier_imba_riki_mode_switch","mb/hero_riki/riki_mode_switch", LUA_MODIFIER_MOTION_NONE)

function imba_riki_mode_switch:IsHiddenWhenStolen() 	return false end
function imba_riki_mode_switch:IsRefreshable() 		return false end
function imba_riki_mode_switch:IsStealable() 			return false end
function imba_riki_mode_switch:OnHeroLevelUp()
	if self:GetLevel() <= 0 then 
		self:SetLevel(1)
		self:GetCaster():AddNewModifierWhenPossible(self:GetCaster(), self, "modifier_imba_riki_mode_switch", {})
		self:GetCaster():SetModifierStackCount("modifier_imba_riki_mode_switch", nil, 1)
	end

end
function imba_riki_mode_switch:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	--SwitchAbility
	if caster:HasModifier("modifier_imba_riki_mode_switch") then
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", nil) 	
		split_type = split_type + 1
		if split_type > ENUM_POISONED then 
			split_type = ENUM_DAGGER_DANCER
		end
		caster:SetModifierStackCount("modifier_imba_riki_mode_switch", nil, split_type)
	else
		caster:AddNewModifierWhenPossible(caster, self, "modifier_imba_riki_mode_switch", {})
		caster:SetModifierStackCount("modifier_imba_riki_mode_switch", nil, 1)
	end
end

-------------------------------------------------------
-------      MODIFIER_IMBA_RIKI_MODE_SWITCH     -------
-------------------------------------------------------
--模式选择
modifier_imba_riki_mode_switch = class({})

function modifier_imba_riki_mode_switch:IsDebuff()			return false end
function modifier_imba_riki_mode_switch:IsHidden() 			return true end
function modifier_imba_riki_mode_switch:IsPurgable() 			return false end
function modifier_imba_riki_mode_switch:IsPurgeException() 	return false end
function modifier_imba_riki_mode_switch:RemoveOnDeath() 		return false end
function modifier_imba_riki_mode_switch:OnCreated() self:SetStackCount(1) end