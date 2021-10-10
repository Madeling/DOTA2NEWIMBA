vampiric_aura=class({})

LinkLuaModifier("modifier_vampiric_aura", "heros/hero_skeleton_king/vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vampiric_aura_buff", "heros/hero_skeleton_king/vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vampiric_aura_buff2", "heros/hero_skeleton_king/vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vampiric_aura_buff3", "heros/hero_skeleton_king/vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE)
function vampiric_aura:IsHiddenWhenStolen()
    return false
end

function vampiric_aura:IsStealable()
    return true
end


function vampiric_aura:IsRefreshable()
    return true
end

function vampiric_aura:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_2") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function vampiric_aura:GetIntrinsicModifierName()
    return "modifier_vampiric_aura"
end

function vampiric_aura:OnSpellStart()
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_vampiric_aura_buff3") then
        caster:RemoveModifierByName("modifier_vampiric_aura_buff3")
    end
    caster:AddNewModifier(caster, self, "modifier_vampiric_aura_buff", {duration=0.4})
    caster:EmitSound("Hero_SkeletonKing.CriticalStrike")
    if caster.KINGMODEL==nil then
        caster.KINGMODEL={
            "models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl",
            "models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl",
            "models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl",
            "models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl",
            "models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl",
            "models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl"
        }

    end
    if caster.KINGMOD==nil then
        caster.KINGMOD={}
    end
        local heros = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, hero in pairs(heros) do
                hero:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=1})
        end
end

--
modifier_vampiric_aura=class({})

function modifier_vampiric_aura:IsHidden()
	return true
end

function modifier_vampiric_aura:IsPurgable()
	return false
end

function modifier_vampiric_aura:IsPurgeException()
	return false
end


function modifier_vampiric_aura:DeclareFunctions()
    return
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_vampiric_aura:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self:GetParent() and not self:GetParent():IsIllusion() and not tg.target:IsBuilding() then
        local vampiric=self:GetParent():HasModifier("modifier_vampiric_aura_buff3") and 100 or self:GetAbility():GetSpecialValueFor( "vampiric_aura" )
        local hp=tg.damage*vampiric*0.01
        SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),hp, nil)
        self:GetParent():Heal(hp, self:GetParent())
    end
end


modifier_vampiric_aura_buff=class({})

function modifier_vampiric_aura_buff:IsHidden()
	return true
end

function modifier_vampiric_aura_buff:IsPurgable()
	return false
end

function modifier_vampiric_aura_buff:IsPurgeException()
	return false
end


function modifier_vampiric_aura_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vampiric_aura_buff:GetEffectName()
	return "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_rare_run.vpcf"
end


function modifier_vampiric_aura_buff:OnDestroy()
    if IsServer() then
            local particle = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self:GetParent())
            ParticleManager:ReleaseParticleIndex(particle)
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_vampiric_aura_buff2", {duration=4})
    end
end

function modifier_vampiric_aura_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end


function modifier_vampiric_aura_buff:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end


modifier_vampiric_aura_buff2=class({})

function modifier_vampiric_aura_buff2:IsHidden()
	return true
end

function modifier_vampiric_aura_buff2:IsPurgable()
	return false
end

function modifier_vampiric_aura_buff2:IsPurgeException()
	return false
end

function modifier_vampiric_aura_buff2:OnCreated()
    if IsServer() then
        self:GetParent():EmitSound("TG.king")
        local particle = ParticleManager:CreateParticle( "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self:GetParent())
        ParticleManager:SetParticleControl(particle,0,self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle,1,Vector(4,0,0))
        ParticleManager:SetParticleControl(particle,11,self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle)
     end
 end

 function modifier_vampiric_aura_buff2:OnDestroy()
    if IsServer() then
        self:GetParent():EmitSound("Hero_SkeletonKing.Hellfire_Blast")
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_vampiric_aura_buff3", {duration=self:GetAbility():GetSpecialValueFor( "dur" )})
        local heros = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for _, hero in pairs(heros) do
                hero:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_stunned", {duration=1})
        end
        if self:GetParent():TG_HasTalent("special_bonus_skeleton_king_7") then
            self:GetParent():Heal(99999, self:GetAbility())
        end
    end
 end

 function modifier_vampiric_aura_buff2:CheckState()
    return
    {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end

function modifier_vampiric_aura_buff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end


function modifier_vampiric_aura_buff2:GetModifierModelChange()
	return "models/heroes/wraith_king/wraith_king_prop.vmdl"
end

function modifier_vampiric_aura_buff2:GetModifierModelScale()
	return 70
end

modifier_vampiric_aura_buff3=class({})

function modifier_vampiric_aura_buff3:IsHidden()
	return false
end

function modifier_vampiric_aura_buff3:IsPurgable()
	return false
end

function modifier_vampiric_aura_buff3:IsPurgeException()
	return false
end

function modifier_vampiric_aura_buff3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vampiric_aura_buff3:GetEffectName()
	return "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf"
end

function modifier_vampiric_aura_buff3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_vampiric_aura_buff3:OnCreated()

    if not IsServer() then
        return
    end
   local model=self:GetCaster().KINGMODEL
   self.w=nil
    for num=1,#model do
        local mod = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model[num]})
        if model[num] =="models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl" then
            self.w=mod
        end
        mod:SetParent(self:GetCaster(), nil)
        mod:FollowEntity(self:GetCaster(), true)
        table.insert (self:GetCaster().KINGMOD, mod)
    end
    local caster_pos=self:GetCaster():GetAbsOrigin()

    local particle = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)

    local weapon = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.w)
    ParticleManager:SetParticleControl(weapon, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(weapon, 5, Vector(0,0,0))
    ParticleManager:SetParticleControl(weapon, 1, Vector(0,0,0))
    ParticleManager:SetParticleControl(weapon, 2, Vector(0,0,0))
    self:AddParticle(weapon, false, true, 15, true, false)

    local head = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_ambient_head.vpcf", PATTACH_OVERHEAD_FOLLOW , self:GetParent())
    self:AddParticle(head, false, true, 15, true, false)

    local body = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_victory_stub.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetParent())
    self:AddParticle(body, false, true, 15, true, false)

end

function modifier_vampiric_aura_buff3:OnDestroy()
    if not IsServer() then
        return
    end
    local body = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_victory_stub.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetParent())
    self:AddParticle(body, false, true, 15, true, false)
    local model=self:GetCaster().KINGMOD
    if model~=nil  and #model>0  then
        for num=1,#model do
            model[num]:RemoveSelf()
        end
        self:GetCaster().KINGMOD={}
    end
end

function modifier_vampiric_aura_buff3:GetModifierModelChange()
	return "models/items/wraith_king/arcana/wraith_king_arcana.vmdl"
end

function modifier_vampiric_aura_buff3:GetModifierModelScale()
	return 30
end

function modifier_vampiric_aura_buff3:CheckState()
        return
        {
            [MODIFIER_STATE_UNSLOWABLE] = true,
        }
end