tower3_laser=class({})
LinkLuaModifier("modifier_tower3_laser", "towers/tower3_laser.lua", LUA_MODIFIER_MOTION_NONE)

function tower3_laser:GetIntrinsicModifierName() 
    return "modifier_tower3_laser" 
end

modifier_tower3_laser = class({})


function modifier_tower3_laser:IsHidden() 			
    return false 
end

function modifier_tower3_laser:IsPurgable() 			
    return false 
end

function modifier_tower3_laser:IsPurgeException() 	
    return false 
end

function modifier_tower3_laser:GetTexture() 			
    return "tower3_laser" 
end

function modifier_tower3_laser:OnCreated()
    if not IsServer() then
        return
    end
	self:StartIntervalThink(1)
end


function modifier_tower3_laser:OnIntervalThink()
    if not  self:GetAbility():IsCooldownReady()  then
		return
    end
    if not self:GetParent():IsAlive()   then
        self:StartIntervalThink(-1)
        return 
    end 

    local heros = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
        1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
        false)
        
        if #heros>0 then
        EmitSoundOn( "Ability.Powershot", self:GetParent() )
        local projectileTable =
	    {
		EffectName ="particles/units/heroes/hero_windrunner/windrunner_spell_powershot_rubick.vpcf",
		Ability =  self:GetAbility(),
		vSpawnOrigin =self:GetParent():GetAbsOrigin(),
		vVelocity =self:GetParent():GetForwardVector()*6000,
		fDistance = 1400,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = self:GetParent(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    }
         Projectile=ProjectileManager:CreateLinearProjectile( projectileTable )
    
            local enemies = FindUnitsInLine(
                self:GetParent():GetTeam(), 
                self:GetParent():GetAbsOrigin(),
                self:GetParent():GetAbsOrigin()+self:GetParent():GetForwardVector()*1400, 
                self:GetParent(), 
                350, 
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
                DOTA_UNIT_TARGET_FLAG_INVULNERABLE)
            if #enemies>0 then
                for _, enemie in pairs(enemies) do
                    local damageTable = {
                        attacker = self:GetParent(),
                        victim = enemie,
                        damage = 777,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility()
                    }
                    if enemie~=tar and not enemie:IsMagicImmune() then
                        ApplyDamage(damageTable)
                    end
                end
                self:GetAbility():UseResources(false, false, true)
            end
        end  

    
end