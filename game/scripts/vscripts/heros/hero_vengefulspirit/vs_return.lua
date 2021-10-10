vs_return=class({})

function vs_return:IsHiddenWhenStolen() 
    return false 
end

function vs_return:IsStealable() 
    return false 
end


function vs_return:IsRefreshable() 			
    return true 
end

function vs_return:Set_InitialUpgrade(tg) 			
    return {lv=1} 
end

function vs_return:OnSpellStart()
    local caster=self:GetCaster()
	local caster_pos=caster:GetAbsOrigin()
    local team=caster:GetTeamNumber()
    if caster.nether_swap_pos then   
        EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", caster )
        FindClearSpaceForUnit( caster, caster.nether_swap_pos, true )
        local fx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt( fx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), false )
        ParticleManager:ReleaseParticleIndex( fx2 )
        EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror" , caster)
        local pos1=caster.nether_swap_pos+caster:GetRightVector()*1000
        local pos2=caster.nether_swap_pos+caster:GetForwardVector()*1000
        local p = 
        {
            EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
            Ability = self,
            vSpawnOrigin = pos1, 
            fStartRadius = 300,
            fEndRadius = 300,
            vVelocity = TG_Direction(caster.nether_swap_pos,pos1) * 3000,
            fDistance = 1500,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bProvidesVision = true,
            iVisionTeamNumber = team,
            iVisionRadius = 500,
        }
        ProjectileManager:CreateLinearProjectile(p)

        local p1 = 
        {
            EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
            Ability = self,
            vSpawnOrigin = pos2, 
            fStartRadius = 300,
            fEndRadius = 300,
            vVelocity = TG_Direction(caster.nether_swap_pos,pos2) * 3000,
            fDistance = 1500,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            bProvidesVision = true,
            iVisionTeamNumber = team,
            iVisionRadius = 500,
        }
        ProjectileManager:CreateLinearProjectile(p1)
        if caster:HasModifier("modifier_nether_swap_buff") then   
            caster:RemoveModifierByName("modifier_nether_swap_buff")
        end 
    end 
end 

function vs_return:OnProjectileHit( target, location)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
        target:AddNewModifier(caster, self, "modifier_wave_of_terror_debuff", {duration=8})
        if caster:TG_HasTalent("special_bonus_vengefulspirit_4") then
            caster:PerformAttack(target, false, true, true, false, false, false, true)  
        else 
            caster:PerformAttack(target, false, false, true, false, false, false, true)  
        end

end