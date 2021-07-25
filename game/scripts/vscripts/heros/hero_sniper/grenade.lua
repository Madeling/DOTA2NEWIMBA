grenade=class({})
LinkLuaModifier("modifier_grenade", "heros/hero_sniper/grenade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grenade_inv", "heros/hero_sniper/grenade.lua", LUA_MODIFIER_MOTION_NONE)
function grenade:IsHiddenWhenStolen() 
    return false 
end

function grenade:IsStealable() 
    return true 
end

function grenade:IsRefreshable() 			
    return true 
end

function grenade:ProcsMagicStick() 			
    return true 
end


function grenade:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local pos=self:GetCursorPosition()
    local dir=TG_Direction(pos,caster_pos)
    EmitSoundOn("DOTA_Item.MinotaurHorn.Cast", caster)
    local null = CreateUnitByNameAsync("npc_sniper_air", caster_pos+dir*-500, false,nil, nil, caster:GetTeamNumber(),function(null)
        Timers:CreateTimer(0.01, function()
            null:MoveToPosition(pos)
            null:AddNewModifier( caster, self, "modifier_grenade", {duration=16} )
            null:AddNewModifier( caster, self, "modifier_kill", {duration=16} )
            return nil
        end
        )
    end)
    caster.cc=null
end

function grenade:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
    local dam=self:GetSpecialValueFor("dam")
    if not target:IsMagicImmune() and not target:IsInvisible() then
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = dam,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
            }
            ApplyDamage(damageTable)
    end
end


modifier_grenade=class({})


function modifier_grenade:IsHidden() 			
	return false 
end

function modifier_grenade:IsPurgable() 		
	return false 
end

function modifier_grenade:IsPurgeException() 	
	return false 
end

function modifier_grenade:RemoveOnDeath()
	return true 
end

function modifier_grenade:IsAura() 
    return true 
end


function modifier_grenade:GetModifierAura() 
    return "modifier_grenade_inv" 

end

function modifier_grenade:GetAuraRadius() 
        return self:GetAbility():GetSpecialValueFor( "rd" )
end

function modifier_grenade:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_grenade:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_grenade:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO
end

function modifier_grenade:OnCreated() 	
    self.rd=self:GetAbility():GetSpecialValueFor("rd")
    if not IsServer() then
        return 
    end
    local particle= ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(particle, 1, Vector(self.rd, 0, 0))
    ParticleManager:SetParticleControl(particle, 2, Vector(15, 0, 0))
    ParticleManager:SetParticleControl(particle, 3, Vector(100, 0, 0))
    ParticleManager:SetParticleControl(particle, 15, Vector(255,255,0))
    self:AddParticle( particle, true, false, 10, false, false )
    self:GetParent():SetHealth(self:GetAbility():GetSpecialValueFor("hp"))
    self:GetParent():SetPhysicalArmorBaseValue( self:GetAbility():GetSpecialValueFor("ar") )
    local particle2= ParticleManager:CreateParticle("particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013_ghosts.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    self:AddParticle( particle2, false, false, 100, false, false )
    self:StartIntervalThink(1)
end

function modifier_grenade:OnIntervalThink() 	
    if not self:GetParent():IsAlive() then 
        return 
    end 
    local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_CLOSEST,
            false)

            for _, hero in pairs(heros) do
                if not hero:IsMagicImmune() and not hero:IsInvisible() then
                    EmitSoundOn("soundboard.new_year_firecrackers2", self:GetParent())
                local P= 
                {
                    Target = hero,
                    Source = self:GetParent(),
                    Ability = self:GetAbility(),	
                    vSourceLoc = self:GetParent():GetAbsOrigin(),
                    EffectName = "particles/heros/sniper/grenade1.vpcf",
                    iMoveSpeed = 1000,
                    bDrawsOnMinimap = false,
                    bDodgeable = false,
                    bIsAttack = false,
                    bVisibleToEnemies = true,
                    bReplaceExisting = false,
                    flExpireTime = GameRules:GetGameTime() + 10,
                    bProvidesVision = false,
                }
                TG_CreateProjectile({id=1,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),target=hero,p=P})
            end
            end
end


function modifier_grenade:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
    } 
end

function modifier_grenade:GetVisualZDelta() 
        return 300
end

function modifier_grenade:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNSLOWABLE] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }
end


modifier_grenade_inv=class({})


function modifier_grenade_inv:IsHidden() 			
	return true 
end

function modifier_grenade_inv:IsPurgable() 		
	return false 
end

function modifier_grenade_inv:IsPurgeException() 	
	return false 
end

function modifier_grenade_inv:RemoveOnDeath()
	return true 
end

function modifier_grenade_inv:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS 
    } 
end

function modifier_grenade_inv:GetModifierMoveSpeedBonus_Percentage() 
    if self:GetCaster():TG_HasTalent("special_bonus_sniper_25l") then
        return 50
    else 
        return 0
    end
end
function modifier_grenade_inv:GetModifierHealthBonus() 
    if self:GetCaster():TG_HasTalent("special_bonus_sniper_25r") then
        return 1500
    else 
        return 0
    end
end 