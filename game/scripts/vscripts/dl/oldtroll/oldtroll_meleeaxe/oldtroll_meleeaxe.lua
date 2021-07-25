
oldtroll_meleeaxe = class({})

LinkLuaModifier( "modifier_oldtroll_meleeaxe_debuff", "dl/oldtroll/oldtroll_meleeaxe/modifier_oldtroll_meleeaxe_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oldtroll_meleeaxe_troll", "dl/oldtroll/oldtroll_meleeaxe/modifier_oldtroll_meleeaxe_troll", LUA_MODIFIER_MOTION_NONE )

function oldtroll_meleeaxe:IsHiddenWhenStolen() 		return false end
function oldtroll_meleeaxe:IsRefreshable() 			return true end
function oldtroll_meleeaxe:IsStealable() 				return true end
function oldtroll_meleeaxe:GetAOERadius()           return self:GetSpecialValueFor("meleeaxe_radius") end

function oldtroll_meleeaxe:OnSpellStart()

    local caster = self:GetCaster()

    caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Melee")
    caster:AddNewModifier(caster, self, "modifier_oldtroll_meleeaxe_troll", {duration = self:GetSpecialValueFor("meleeaxe_duration")})

end

