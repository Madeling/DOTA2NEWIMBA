polymerization=class({})
LinkLuaModifier("modifier_polymerization", "rd/polymerization.lua", LUA_MODIFIER_MOTION_NONE)
function polymerization:IsHiddenWhenStolen() 
    return false 
end

function polymerization:IsStealable() 
    return true 
end


function polymerization:IsRefreshable() 			
    return true 
end

function polymerization:Precache( context )
	PrecacheResource( "model", "models/creeps/darkreef/gaoler/darkreef_gaoler.vmdl", context )
	PrecacheResource( "particle", "particles/heros/jugg/jugg_dog.vpcf", context )
    PrecacheResource( "particle", "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", context )
end

function polymerization:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if not target:IsRealHero() or target==caster  then
		return UF_FAIL_CUSTOM
	end
end

function polymerization:GetCustomCastErrorTarget(target) 
        return "无法对其使用" 
end

function polymerization:OnSpellStart()
    local cur_tar=self:GetCursorTarget()
    local caster=self:GetCaster() 
    EmitSoundOn("TG.aaice", caster)
    local p1 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_dog.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(p1, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)
    caster:AddNewModifier(caster, self, "modifier_polymerization", 
    {
        duration=self:GetSpecialValueFor("dur"),
        agi=math.floor(cur_tar:GetAgility()/2),
        str=math.floor(cur_tar:GetStrength()/2),
        int=math.floor(cur_tar:GetIntellect()/2),
        hp=math.floor(cur_tar:GetMaxHealth()/2),
        ar=math.floor(cur_tar:GetPhysicalArmorValue(false)/2),
        sp=math.floor(cur_tar:GetMoveSpeedModifier(cur_tar:GetBaseMoveSpeed(), true)/2),
        mana=math.floor(cur_tar:GetMaxMana()/2),
    })
end

modifier_polymerization=class({})

function modifier_polymerization:IsPurgable() 			
    return false 
end

function modifier_polymerization:IsPurgeException() 	
    return false 
end

function modifier_polymerization:IsHidden()				
    return false 
end

function modifier_polymerization:OnCreated(tg)		
        self.agi=tg.agi
        self.str=tg.str
        self.int=tg.int
        self.hp=tg.hp
        self.ar=tg.ar
        self.sp=tg.sp
        self.mana=tg.mana
        local p2 = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        self:AddParticle( p2, false, false, 20, false, false )  
end

function modifier_polymerization:OnRefresh(tg)				
    self:OnCreated(tg)
end

function modifier_polymerization:CheckState() 
    return 
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    } 
end


function modifier_polymerization:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
    } 
end

function modifier_polymerization:GetModifierModelChange() 
    return "models/creeps/darkreef/gaoler/darkreef_gaoler.vmdl"
end

function modifier_polymerization:GetModifierModelScale() 
    return 50
end

function modifier_polymerization:GetModifierBonusStats_Intellect() 
    return self.int
end

function modifier_polymerization:GetModifierBonusStats_Agility() 
    return self.agi
end

function modifier_polymerization:GetModifierBonusStats_Strength() 
    return self.str
end

function modifier_polymerization:GetModifierHealthBonus() 
    return self.hp
end 

function modifier_polymerization:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end 

function modifier_polymerization:GetModifierPhysicalArmorBonus() 
    return self.ar
end 

function modifier_polymerization:GetModifierManaBonus() 
    return self.mana
end 