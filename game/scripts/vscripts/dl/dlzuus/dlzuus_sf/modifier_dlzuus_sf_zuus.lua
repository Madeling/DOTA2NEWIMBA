modifier_dlzuus_sf_zuus = ({})

function modifier_dlzuus_sf_zuus:IsHidden() return true end
function modifier_dlzuus_sf_zuus:IsBuff() return true end
function modifier_dlzuus_sf_zuus:IsDebuff() return false end
function modifier_dlzuus_sf_zuus:IsStunDebuff() return false end
function modifier_dlzuus_sf_zuus:IsPurgable() return false end
function modifier_dlzuus_sf_zuus:IsPurgeException() return false end

function modifier_dlzuus_sf_zuus:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_dlzuus_sf_zuus:OnTakeDamage(keys)
    if not IsServer() then return end

    --DeepPrintTable(keys)  --经测试可以检测到原版技能伤害以及雷云的雷击，但是恐怕分不清是宙斯还是别人的雷云
    --[[print(1)
    if inflictor then print(inflictor:GetAbilityName().."") end
    if keys.attacker ~= caster then return end
    if inflictor then print("abitem") end
    if not inflictor then print("attack") end
    if inflictor and inflictor:IsItem() then print("item") end
    if inflictor and not inflictor:IsItem() then print("ab") end]]

    local caster = self:GetParent()
    local victim = keys.unit
    local ability = self:GetAbility()
    local inflictor = keys.inflictor

    if caster:PassivesDisabled() or not caster:IsAlive() or caster:IsIllusion() then return end  --被破坏或者死了或者是幻象那没事了
    if not inflictor or keys.damage_type ~= 2 then return end --不是正常技能那没事了。雷云消失会被OTD检测，有inflictor但damagetype为0。普攻dt为1，物品技能为2
    if inflictor == ability or inflictor:IsItem() then return end --是静电场或者物品那没事了。
    if keys.attacker ~= caster and inflictor:GetAbilityName() ~= "zuus_lightning_bolt" then return end --不是宙斯也不是雷云那没事了
    if victim:GetTeamNumber() == caster:GetTeamNumber() then return end --如果受害者是友军那没事了。此条防止敌人雷云对己方触发静电场。同时友军雷云可以白嫖静电场。

    local damper = ability:GetSpecialValueFor("sf_per") + caster:TG_GetTalentValue("special_bonus_dlzuus_25l")  --天赋加伤
    local vichp  = victim:GetHealth()
    local damage = vichp*damper/100

    local damageTable = {
        attacker = caster,
        victim = victim,
        damage = damage,
        damage_type = ability:GetAbilityDamageType(),
        ability = ability,
    }
    ApplyDamage( damageTable )
    self:playeffects(victim)
end

function modifier_dlzuus_sf_zuus:OnAttackLanded(params)
    if not IsServer() then return end

    local caster = self:GetCaster()
    local attacker = params.attacker
    local ability = self:GetAbility()
    if not caster:IsAlive() or caster:IsIllusion() then return end
    if not params.target then return end	--可能能防报错吧我也不知道随手一加
	if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
    if params.target~=caster then return end  --如果被打的不是本人那没事了
    if params.inflictor then return end --如果是技能造成的攻击那没事了
    if caster:PassivesDisabled() then return end  --如果本人被破坏那没事了
    if params.ranged_attack then return end	--如果是远程攻击那没事了
    if not attacker:IsHero() then return end --如果是小兵那没事了
    if attacker:IsMagicImmune() then return end --如果攻击者魔免那没事了

    self:playsounds(caster)
    TG_AddNewModifier_RS(attacker, caster, ability, "modifier_paralyzed", {duration = ability:GetSpecialValueFor("sf_paradura")})

    if caster:Has_Aghanims_Shard() then                  --魔晶
        local intdamage = caster:GetIntellect()*ability:GetSpecialValueFor("sf_shardam")
        local damageTable = {
            attacker = caster,
            victim = attacker,
            damage = intdamage,
            damage_type = ability:GetAbilityDamageType(),
            ability = ability,
        }
        ApplyDamage( damageTable )
    end

end


function modifier_dlzuus_sf_zuus:playeffects(t)
    local particle_cast = "particles/units/heroes/hero_zuus/zuus_static_field.vpcf"
    local sound_cast = "Hero_Zuus.StaticField"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    local tpos = t:GetAbsOrigin() tpos.z = tpos.z+400

    ParticleManager:SetParticleControl( effect_cast, 0, tpos )

	ParticleManager:ReleaseParticleIndex( effect_cast )
    EmitSoundOn( sound_cast, t )
end

function modifier_dlzuus_sf_zuus:playsounds(caster)
    local soundname = "zuus_zuus_pain_0"..RandomInt(1, 5)
    caster:EmitSound(soundname)
end
