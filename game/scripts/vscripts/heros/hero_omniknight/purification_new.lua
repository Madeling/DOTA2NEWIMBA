CreateTalents("npc_dota_hero_omniknight", "heros/hero_omniknight/purification_new.lua")
purification_new=class({})
LinkLuaModifier("modifier_purification_new_debuff", "heros/hero_omniknight/purification_new.lua", LUA_MODIFIER_MOTION_NONE)
function purification_new:IsHiddenWhenStolen() 
    return false 
end

function purification_new:IsStealable() 
    return true 
end


function purification_new:IsRefreshable() 			
    return true 
end

function purification_new:CastFilterResultTarget(hTarget)	
    local caster=self:GetCaster() 	
    if hTarget:GetTeamNumber()==caster:GetTeamNumber() and hTarget:HasModifier("modifier_repel_buff") then
        self.purification_new_cast=25000
    else 
        self.purification_new_cast=1000
    end 
    if IsServer() then
        local unit = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber() )
        return unit
    end
    return UF_SUCCESS
end


function purification_new:GetCustomCastErrorTarget(hTarget)	
    return  "无法对其使用"
end

function purification_new:GetCastRange()	
    return  (self.purification_new_cast or 1000)+self:GetCaster():GetCastRangeBonus()
end

function purification_new:OnSpellStart(tg)
    local caster=self:GetCaster() 
    local target=self:GetCursorTarget() 
    local dur=self:GetSpecialValueFor("dur")
    local radius=self:GetSpecialValueFor("radius")
    local heal=self:GetSpecialValueFor("heal")+caster:TG_GetTalentValue("special_bonus_omniknight_1")
    local dur2=self:GetSpecialValueFor("dur2")
    local hp=self:GetSpecialValueFor("hp")+caster:TG_GetTalentValue("special_bonus_omniknight_2")
    if caster.purification_newrdbuff==nil then   
        caster.purification_newrdbuff={
            "modifier_rune_doubledamage_tg",
            "modifier_rune_flying_haste",
            "modifier_rune_super_invis",
            "modifier_rune_super_regen",
        }
    end 
    if target==nil then  
        if tg==nil then   
            target=caster
        else  
            target=tg
        end 
    end 
    local num=target:GetHealthPercent()<=hp and 2 or 1
    EmitSoundOn("Hero_Omniknight.purification", caster)
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx2)
    for a=1,num do     
        target:Heal(heal, caster)
        SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target,heal, nil)
        target:AddNewModifier(caster, self, caster.purification_newrdbuff[math.random(1, #caster.purification_newrdbuff)], {duration=dur2})
        local heroes = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
        if #heroes>0 then
            for _, hero in pairs(heroes) do
                        local damageTable = {
                        victim = hero,
                        attacker = caster,
                        damage = heal,
                        damage_type = DAMAGE_TYPE_PURE,
                        ability = self, 
                        }
                    ApplyDamage(damageTable)
                    hero:AddNewModifier(caster, self, "modifier_purification_new_debuff",  {duration=dur})
            end
        end
    end 

end



modifier_purification_new_debuff=class({})

function modifier_purification_new_debuff:IsPurgable() 			
    return true 
end

function modifier_purification_new_debuff:IsPurgeException() 	
    return true 
end

function modifier_purification_new_debuff:IsHidden()				
    return false 
end

function modifier_purification_new_debuff:IsDebuff()				
    return true 
end


function modifier_purification_new_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end


function modifier_purification_new_debuff:GetModifierMiss_Percentage() 
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("miss") 
    end
    return 0
end
