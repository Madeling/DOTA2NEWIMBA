sleight_of_fist=class({})

LinkLuaModifier("modifier_sleight_of_fist_buff", "heros/hero_ember_spirit/sleight_of_fist.lua", LUA_MODIFIER_MOTION_NONE)

function sleight_of_fist:IsHiddenWhenStolen() 		
    return false
end

function sleight_of_fist:IsRefreshable() 			
    return true 
end

function sleight_of_fist:IsStealable() 			
    return true 
end

function sleight_of_fist:OnOwnerSpawned() 			
    self:SetActivated(true) 
end



function sleight_of_fist:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local team = caster:GetTeamNumber()
    local cur_pos = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    local attack_interval = self:GetSpecialValueFor("attack_interval")
    local wh = self:GetSpecialValueFor("wh")
    local dis = self:GetSpecialValueFor("dis")
    local stack = 1
    local heroes = {}
    local op = {}
    EmitSoundOn("Hero_EmberSpirit.SleightOfFist.Cast", caster)  
    if self:GetAutoCastState() then 
        local fpos=cur_pos+TG_Direction(cur_pos,pos)*dis
        local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(trail, 0,cur_pos)
        ParticleManager:SetParticleControl(trail, 1,fpos)
        ParticleManager:ReleaseParticleIndex(trail)   
        heroes = FindUnitsInLine(team,cur_pos,fpos,caster,wh,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    else 
        local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pf, 0, cur_pos)
        ParticleManager:SetParticleControl(pf, 1, Vector(radius, 0, 0))
        ParticleManager:ReleaseParticleIndex(pf)
        heroes = FindUnitsInRadius(team, cur_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    end 
    if #heroes>0 then 
        self:SetActivated(false) 
        local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pf1, 0, pos)
        ParticleManager:SetParticleControlForward(pf1, 1, caster:GetForwardVector())
        ParticleManager:SetParticleControl(pf1, 62, Vector(10, 0, 0))
        for a=1,#heroes do
            op[a] = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, heroes[a])
            ParticleManager:SetParticleControl( op[a], 0, heroes[a]:GetAbsOrigin())
        end
        caster:AddNewModifier(caster, self, "modifier_sleight_of_fist_buff", {})
        Timers:CreateTimer(0, function()
          --  if   caster:HasModifier("modifier_activate_fire_remnant") then 
          --      sleight_of_fist:End_Des(op,caster,pf1) 
          --      return nil 
          --  end 
            if  heroes~=nil and stack<=#heroes then 
                if heroes[stack]~=nil and heroes[stack]:IsAlive() then 
                    local tpos=heroes[stack]:GetAbsOrigin()
                    local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                    ParticleManager:SetParticleControl(trail, 0,caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(trail, 1,tpos)
                    ParticleManager:ReleaseParticleIndex(trail)   
                    if  not caster:HasModifier("modifier_activate_fire_remnant") then 
                        caster:SetAbsOrigin(tpos)
                    end
                    caster:PerformAttack(heroes[stack], false, true, true, false, false, false, false)
                    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroes[stack])
                    ParticleManager:SetParticleControl(pf, 0,tpos)
                    ParticleManager:ReleaseParticleIndex(pf)       
                        if op[stack]~=nil then 
                            ParticleManager:DestroyParticle(op[stack], false)
                            ParticleManager:ReleaseParticleIndex(op[stack])
                        end
                end
                stack=stack+1
            else 
                sleight_of_fist:End_Des(op,caster,pf1) 
                if  not caster:HasModifier("modifier_activate_fire_remnant") then 
                    FindClearSpaceForUnit(caster, pos, true)
                end
                return nil 
            end 
                return caster:HasModifier("modifier_activate_fire_remnant") and 0 or attack_interval
        end
        )
    end 
end


function sleight_of_fist:End_Des(op,caster,pf1) 			
    if op~=nil then 
        for a=1,#op do
            ParticleManager:DestroyParticle(op[a], false)
            ParticleManager:ReleaseParticleIndex(op[a])
        end
    end
    if caster:HasModifier("modifier_sleight_of_fist_buff") then 
        caster:RemoveModifierByName("modifier_sleight_of_fist_buff")
    end 
    if  pf1~=nil then 
        ParticleManager:DestroyParticle(pf1, false)
        ParticleManager:ReleaseParticleIndex(pf1)
    end 
end


modifier_sleight_of_fist_buff=class({})

function modifier_sleight_of_fist_buff:IsHidden() 			
    return true 
end

function modifier_sleight_of_fist_buff:IsPurgable() 			
    return false 
end

function modifier_sleight_of_fist_buff:IsPurgeException() 	
    return false 
end

function modifier_sleight_of_fist_buff:CheckState() 
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        [MODIFIER_STATE_CANNOT_MISS] = true, 
        [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
    } 
end

function modifier_sleight_of_fist_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    } 
end

function modifier_sleight_of_fist_buff:OnCreated()	
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
    self.damage=self.ability:GetSpecialValueFor("damage")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_3")
end

function modifier_sleight_of_fist_buff:OnDestroy()	
    if IsServer() then    
        self.ability:SetActivated(true)
    end 
end


function modifier_sleight_of_fist_buff:GetModifierPreAttack_BonusDamage() 
    return self.damage
end

function modifier_sleight_of_fist_buff:GetModifierModelChange() 
    return ""
end

function modifier_sleight_of_fist_buff:GetModifierIgnoreCastAngle()
    return 1
end


