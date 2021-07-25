
modifier_oldsky_mflare_thinker = class({})

function modifier_oldsky_mflare_thinker:OnCreated()
    if not IsServer() then return end

    self:GetParent():EmitSound("Hero_SkywrathMage.MysticFlare")         --音效

    self:StartIntervalThink(0.1)

end

function modifier_oldsky_mflare_thinker:OnIntervalThink()
	local pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("mflare_radius") * 0.8)      --特效用
	local dmg = self:GetAbility():GetSpecialValueFor("mflare_damage") / (self:GetDuration() / 0.1)       --每次打击伤害
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("mflare_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if #enemies ~= 0 then
		pos = RandomFromTable(enemies):GetAbsOrigin()
		dmg = dmg / #enemies        --分摊打击伤害
		for _, enemy in pairs(enemies) do
			local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = dmg,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			ApplyDamage(damageTable)
		end
	end

end

function modifier_oldsky_mflare_thinker:OnRemoved()
    if not IsServer() then return end

    local dmg = self:GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("mflare_intco_exdam")      --爆炸智力伤害
    local radius = self:GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("mflare_intco_exrad") + self:GetAbility():GetSpecialValueFor("mflare_radius")   --爆炸半径扩大
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do       --爆炸AOE，老天怒特殊设定了不伤害被噩梦的单位
		local damageTable = {
							victim = enemy,
							attacker = self:GetCaster(),
							damage = dmg,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
    end

    self:GetAbility():playeffects("end",self:GetParent():GetAbsOrigin())    --特效。调用技能的特效函数。特效在技能里操作更灵活

end
