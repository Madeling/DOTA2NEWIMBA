nether_swap=class({})
LinkLuaModifier("modifier_nether_swap_buff", "heros/hero_vengefulspirit/nether_swap.lua", LUA_MODIFIER_MOTION_NONE)
function nether_swap:IsHiddenWhenStolen() 
    return false 
end

function nether_swap:IsStealable() 
    return true 
end


function nether_swap:IsRefreshable() 			
    return true 
end

function nether_swap:GetCastPoint()			
    if self:GetCaster():Has_Aghanims_Shard()  then
        return 0
    else
        return 0.3
    end
end

function nether_swap:GetCooldown( lv )
    return self.BaseClass.GetCooldown(self,lv)-self:GetCaster():TG_GetTalentValue("special_bonus_vengefulspirit_3")
end

function nether_swap:OnSpellStart()
	local caster=self:GetCaster()
	local target=self:GetCursorTarget()
    local cpos=caster:GetAbsOrigin()
	local tpos=target:GetAbsOrigin()
    local root=self:GetSpecialValueFor("root")
    EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror" , caster)
    local wot=caster:FindAbilityByName("wave_of_terror")
    if wot and  wot:GetLevel()>0 then   
        wot:OnSpellStart()
    end
    caster.nether_swap_pos=cpos
    caster:AddNewModifier(caster, self, "modifier_nether_swap_buff", {duration=7})
    local ab=caster:FindAbilityByName("vs_return")
    if ab  then   
        if caster:TG_HasTalent("special_bonus_vengefulspirit_7") then 
            ab:EndCooldown()
        else 
            ab:UseResources(false, false, true)
        end
    end 
    if caster:Has_Aghanims_Shard()  then
        caster:Purge(false, true, false, true, true)
        caster:AddNewModifier(caster, self, "modifier_magic_immune", {duration=4})
    end
    if Is_Chinese_TG(caster,target) then 
        EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", target )
        target:Purge(false, true, false, true, true)
        FindClearSpaceForUnit( target, cpos, true )
        local fx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt( fx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), false )
        ParticleManager:ReleaseParticleIndex( fx2 )
    else 
        if  target:TG_TriggerSpellAbsorb(self) then
            return
        end
        if self:GetAutoCastState() then 
            EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", caster )
            local heros = FindUnitsInRadius(
                caster:GetTeamNumber(),
                target:GetAbsOrigin(),
                nil,
                self:GetSpecialValueFor("radius"),
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                FIND_ANY_ORDER,
                false)
            if #heros>0 then 
                for _,target in pairs(heros) do
                    FindClearSpaceForUnit( target, heros[RandomInt(1, #heros)]:GetAbsOrigin(), true )
                    target:AddNewModifier(caster, self, "modifier_rooted", {duration=root})
                    target:Interrupt()
                    target:Stop()
                end
            end   
        else
            caster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
            EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", caster )
            EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", target )
            FindClearSpaceForUnit( caster, tpos, true )
            FindClearSpaceForUnit( target, cpos, true )
            local fx1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt( fx1, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetAbsOrigin(), false )
            ParticleManager:ReleaseParticleIndex( fx1 )
            local fx2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt( fx2, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), false )
            ParticleManager:ReleaseParticleIndex( fx2 )
            target:Interrupt()
            target:Stop()
        end 
    end
end


modifier_nether_swap_buff=class({})

function modifier_nether_swap_buff:IsHidden() 			
	return false 
end

function modifier_nether_swap_buff:IsPurgable() 		
	return  false
end

function modifier_nether_swap_buff:IsPurgeException() 	
	return false 
end

function modifier_nether_swap_buff:OnDestroy() 	
	if IsServer() then   
        self:GetCaster().nether_swap_pos=nil
    end 
end