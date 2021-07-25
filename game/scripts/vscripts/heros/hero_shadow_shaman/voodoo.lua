voodoo =voodoo or class({})
LinkLuaModifier("modifier_voodoo_ani", "heros/hero_shadow_shaman/voodoo.lua", LUA_MODIFIER_MOTION_NONE)

function voodoo:IsHiddenWhenStolen()
    return false
end

function voodoo:IsStealable()
    return true
end

function voodoo:IsRefreshable()
    return true
end

function voodoo:ProcsMagicStick()
    return true
end

function voodoo:OnSpellStart()
    local caster=self:GetCaster()
    local curtar=self:GetCursorTarget()
    if curtar:TG_TriggerSpellAbsorb(self)  then
		return
    end
    if caster.voodooani==nil then
        caster.voodooani={
            "models/items/courier/mighty_chicken/mighty_chicken.vmdl" ,
            "models/courier/mighty_boar/mighty_boar.vmdl",
            "models/props_gameplay/chicken.vmdl",
            "models/courier/frog/frog.vmdl",
        }
    end
    curtar:EmitSound("Hero_ShadowShaman.Hex.Target")
    if curtar:IsIllusion() then
        curtar:SetTeam(caster:GetTeamNumber())
        curtar:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
    else
        curtar:AddNewModifier_RS(caster, self, "modifier_voodoo_ani", {duration =self:GetSpecialValueFor( "stun")+caster:TG_GetTalentValue("special_bonus_shadow_shaman_3")})
    end
end

modifier_voodoo_ani = modifier_voodoo_ani or class({})

function modifier_voodoo_ani:IsDebuff()
    return true
end

function modifier_voodoo_ani:IsPurgable()
    return false
end

function modifier_voodoo_ani:IsPurgeException()
    return true
end

function modifier_voodoo_ani:IsHidden()
    return false
end

function modifier_voodoo_ani:OnCreated()
    local dur=self:GetAbility():GetSpecialValueFor("dur")
    if not IsServer() then
        return
    end
    local fx = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(fx, false, false, 20, false, false)
    self.ani=self:GetCaster().voodooani[RandomInt(1,#self:GetCaster().voodooani)]
    local modifier_count = self:GetParent():GetModifierCount()
    if modifier_count>0 then
        for i = 0, modifier_count do
            local modifier_name = self:GetParent():GetModifierNameByIndex(i)
            local modifier= self:GetParent():FindModifierByName(modifier_name)
            if modifier~=nil then
                local name=modifier:GetName()
                if modifier:IsDebuff()  and name~="modifier_voodoo_ani" and name~="modifier_serpent_ward_pos" then
                    modifier:SetDuration(modifier:GetDuration()+dur, true)
                end
            end
        end
    end
    self:StartIntervalThink(0.2)
end

function modifier_voodoo_ani:OnIntervalThink()
    self:GetParent():MoveToPosition(self:GetCaster():GetAbsOrigin())
end

function modifier_voodoo_ani:OnRefresh()
   self:OnCreated()
end

function modifier_voodoo_ani:OnDestroy()
    self.ani=nil
end

function modifier_voodoo_ani:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_MODEL_CHANGE,
    }
end

function modifier_voodoo_ani:CheckState()
    return
    {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
        [MODIFIER_STATE_BLOCK_DISABLED] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end

function modifier_voodoo_ani:GetModifierMoveSpeedOverride()
	return 200
end


function modifier_voodoo_ani:GetModifierModelChange()
	return self.ani
end
