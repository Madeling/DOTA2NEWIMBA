howl=class({})
LinkLuaModifier("modifier_howl_buff", "heros/hero_lycan/howl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_howl_buff1", "heros/hero_lycan/howl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wolf_bite_debuff", "heros/hero_lycan/wolf_bite.lua", LUA_MODIFIER_MOTION_NONE)
function howl:IsHiddenWhenStolen() 
    return false 
end

function howl:IsStealable() 
    return true 
end

function howl:IsRefreshable() 			
    return true 
end


function howl:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local team = caster:GetTeamNumber()
    local lv = tostring(self:GetLevel())
    local howl_duration=self:GetSpecialValueFor("howl_duration")
    local radius=self:GetSpecialValueFor("radius")
    local num=self:GetSpecialValueFor("num")
    local num1=1
    local att=caster:GetAverageTrueAttackDamage(caster)*self:GetSpecialValueFor("att")*0.01
    EmitSoundOn("Hero_Lycan.Howl", caster)
    GameRules:BeginTemporaryNight(howl_duration)
    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(p, 0,caster_pos)
    ParticleManager:SetParticleControl(p, 1,caster_pos)
    ParticleManager:ReleaseParticleIndex(p)
    caster:AddNewModifier(caster, self, "modifier_howl_buff", {duration=howl_duration})
    local heros = FindUnitsInRadius(team, caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #heros>0 then
        Timers:CreateTimer(0, function()
            if num1>#heros then
                return nil
            end
            if heros and heros[num1] then 
                if Is_Chinese_TG(heros[num1],caster) then    
                    heros[num1]:AddNewModifier(caster, self, "modifier_howl_buff", {duration=howl_duration})
                else
                    if heros[num1]:IsRealHero() then
                        local unit=CreateUnitByName("npc_dota_lycan_wolf"..lv, heros[num1]:GetAbsOrigin(), true, caster, caster,team)
                        unit:AddNewModifier(caster, self, "modifier_kill", {duration=howl_duration})
                        unit:AddNewModifier(caster, self, "modifier_no_healthbar", {duration=howl_duration})
                        unit:AddNewModifier(caster, self, "modifier_howl_buff1", {duration=howl_duration})
                        unit:SetBaseDamageMin(att)
                        unit:SetBaseDamageMax(att)
                        unit:MoveToTargetToAttack(heros[num1])
                    end
                end
                num1=num1+1
            end
            return 0.5
        end)
    end
end

modifier_howl_buff=class({})

function modifier_howl_buff:IsHidden() 			
	return false 
end

function modifier_howl_buff:IsPurgable() 		
	return true 
end

function modifier_howl_buff:IsPurgeException() 	
	return true 
end

function modifier_howl_buff:OnCreated() 	
    self.ability=self:GetAbility()	
    self.caster=self:GetCaster()
    self.vision=self.ability:GetSpecialValueFor("vision")+self.caster:TG_GetTalentValue("special_bonus_lycan_4")
    self.sp=self.ability:GetSpecialValueFor("sp")+self.caster:TG_GetTalentValue("special_bonus_lycan_3")
end

function modifier_howl_buff:OnRefresh() 	
    self:OnCreated()
end

function modifier_howl_buff:DeclareFunctions() 
    return 
    {
       
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    } 
end

function modifier_howl_buff:GetBonusNightVision() 	
	return self.vision
end

function modifier_howl_buff:GetModifierMoveSpeedBonus_Constant() 	
	return self.sp
end


modifier_howl_buff1=class({})

function modifier_howl_buff1:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_howl_buff1:OnCreated() 
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
end

function modifier_howl_buff1:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self.parent or  tg.target:IsBuilding() then
		return
    end
    if tg.target:IsRealHero() then
        tg.target:AddNewModifier(self:GetCaster(), self.ability, "modifier_wolf_bite_debuff", {duration=10})    
    end 
end