phantom_strike=class({})
LinkLuaModifier("modifier_phantom_strike_buff", "heros/hero_phantom_assassin/phantom_strike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_phantom_strike_pa", "heros/hero_phantom_assassin/phantom_strike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_phantom_strike_tree", "heros/hero_phantom_assassin/phantom_strike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function phantom_strike:IsHiddenWhenStolen()
    return false
end

function phantom_strike:IsStealable()
    return true
end

function phantom_strike:IsRefreshable()
    return true
end

function phantom_strike:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_phantom_assassin_4")
end

function phantom_strike:OnSpellStart()
	local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local caster_team=caster:GetTeamNumber()
	local target=self:GetCursorTarget()
    local target_pos=target:GetAbsOrigin()
    local base_num=self:GetSpecialValueFor("base_num")
    local num=0
    caster:EmitSound("Hero_PhantomAssassin.Strike.Start")

    local p1 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p1, 0, caster_pos)
	ParticleManager:ReleaseParticleIndex(p1)
    FindClearSpaceForUnit(caster, target_pos, true)
    caster:AddNewModifier(caster, self, "modifier_phantom_strike_buff", {duration = self:GetSpecialValueFor("duration")})
    local p2 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(p2, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
    if caster:HasScepter() then
        base_num=base_num+1
    end

    caster:MoveToTargetToAttack(target)

    Timers:CreateTimer(0, function()
        EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast", caster)
        local npos=caster_pos+Vector(RandomInt(-500,500),RandomInt(-300,300),0)
        local dir=( target_pos-npos):Normalized()  dir.z=0
        local dis=( npos - target_pos):Length2D()
        local P =
        {
            Ability = self,
            EffectName = "particles/tgp/tgab/ab8-1.vpcf",
            vSpawnOrigin =npos,
            fDistance = dis+200,
            fStartRadius = 200,
            fEndRadius = 200,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            vVelocity = dir * 2000,
        }
        ProjectileManager:CreateLinearProjectile(P)
        num=num+1
        if num>=base_num then
            return nil
        else
            return 0.1
        end
    end)

end

function phantom_strike:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
        local agi=self:GetSpecialValueFor("agi")
        if caster:HasScepter() then
            agi=agi*2
        end
        local damageTable = {
                        victim = target,
                        attacker = caster,
                        damage =caster:GetAgility()*agi,
                        damage_type =DAMAGE_TYPE_PHYSICAL,
                        ability = self,
                        }
                    ApplyDamage(damageTable)
end

function phantom_strike:GetIntrinsicModifierName()
    return "modifier_phantom_strike_pa"
end

modifier_phantom_strike_pa=class({})

function modifier_phantom_strike_pa:IsDebuff()
	return false
end

function modifier_phantom_strike_pa:IsHidden()
	return true
end

function modifier_phantom_strike_pa:IsPurgable()
	return false
end

function modifier_phantom_strike_pa:IsPurgeException()
	return false
end

function modifier_phantom_strike_pa:OnCreated()
    if not self:GetAbility() then
        return
    end
    self.rdtree=self:GetAbility():GetSpecialValueFor("rdtree")
    if not IsServer() then
        return
    end
    self:StartIntervalThink(3)
end

function modifier_phantom_strike_pa:OnRefresh()
    self.rdtree=self:GetAbility():GetSpecialValueFor("rdtree")
end

function modifier_phantom_strike_pa:OnIntervalThink()
    if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),  self.rdtree, true) then
        if not  self:GetParent():HasModifier( "modifier_phantom_strike_tree") then
            self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_phantom_strike_tree", {})
        end
    else
        TG_Remove_Modifier( self:GetParent(),"modifier_phantom_strike_tree",0)
    end
end

function modifier_phantom_strike_pa:OnDestroy()
    self.rdtree=nil
end

modifier_phantom_strike_tree=class({})

function modifier_phantom_strike_tree:IsDebuff()
	return false
end

function modifier_phantom_strike_tree:IsHidden()
	return false
end

function modifier_phantom_strike_tree:IsPurgable()
	return false
end

function modifier_phantom_strike_tree:IsPurgeException()
	return false
end

function modifier_phantom_strike_tree:GetEffectName()
    return "particles/econ/events/new_bloom/new_bloom_tree_cast_leaves.vpcf"
end

function modifier_phantom_strike_tree:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_phantom_strike_tree:OnCreated()
    self.castrgtree=self:GetAbility():GetSpecialValueFor("castrgtree")
end

function modifier_phantom_strike_tree:OnRefresh()
    self.castrgtree=self:GetAbility():GetSpecialValueFor("castrgtree")
end


function modifier_phantom_strike_tree:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    }
end

function modifier_phantom_strike_tree:GetModifierCastRangeBonus()
    return self.castrgtree
end


modifier_phantom_strike_buff=class({})

function modifier_phantom_strike_buff:IsDebuff()
	return false
end

function modifier_phantom_strike_buff:IsHidden()
	return false
end

function modifier_phantom_strike_buff:IsPurgable()
	return true
end

function modifier_phantom_strike_buff:IsPurgeException()
	return true
end

function modifier_phantom_strike_buff:OnCreated()
    self.SP=self:GetAbility():GetSpecialValueFor("bonus_attack_speed")+self:GetCaster():TG_GetTalentValue("special_bonus_phantom_assassin_3")
end

function modifier_phantom_strike_buff:OnRefresh()
    self:OnCreated()
end


function modifier_phantom_strike_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_phantom_strike_buff:GetModifierAttackSpeedBonus_Constant()
    return self.SP
end