
modifier_oldtroll_fervor_troll = class({})

function modifier_oldtroll_fervor_troll:IsHidden() return true end
function modifier_oldtroll_fervor_troll:IsBuff() return true end
function modifier_oldtroll_fervor_troll:IsDebuff() return false end
function modifier_oldtroll_fervor_troll:IsStunDebuff() return false end
function modifier_oldtroll_fervor_troll:IsPurgable() return false end
function modifier_oldtroll_fervor_troll:IsPurgeException() return false end

function modifier_oldtroll_fervor_troll:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_oldtroll_fervor_troll:OnAttackLanded(params)
    if not IsServer() then return end
    if params.attacker~=self:GetCaster() then return end  --如果不是本人那没事了
    local caster = self:GetCaster()
    local attacker = params.attacker
    local ability = self:GetAbility()
    if not caster:IsAlive() or caster:IsIllusion() then return end
    if not params.target then return end	--可能能防报错吧我也不知道随手一加
	if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
    if params.target:IsBuilding() then return end --如果攻击建筑那没事了
    --if params.inflictor then return end --如果是技能造成的攻击那没事了
    if caster:PassivesDisabled() then return end  --如果本人被破坏那没事了

    local duration = ability:GetSpecialValueFor("fervor_duration") + caster:TG_GetTalentValue("special_bonus_oldtroll_15r")
    --local buff = caster:FindModifierByName("modifier_oldtroll_fervor_stack")

    caster:AddNewModifier(caster,ability, "modifier_oldtroll_fervor_stack", {duration = duration})


    local stundur = ability:GetSpecialValueFor("fervor_stun")
    if PseudoRandom:RollPseudoRandom(ability, ability:GetSpecialValueFor("fervor_chance")) then
        params.target:EmitSound("Hero_TrollWarlord.BerserkersRage.Stun")
        params.target:AddNewModifier(caster,ability, "modifier_imba_stunned", {duration = stundur})
    end

end
