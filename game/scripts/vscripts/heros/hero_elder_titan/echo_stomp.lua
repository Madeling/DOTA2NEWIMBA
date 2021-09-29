echo_stomp=class({})
LinkLuaModifier("modifier_echo_stomp", "heros/hero_elder_titan/echo_stomp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_echo_stomp_debuff", "heros/hero_elder_titan/echo_stomp.lua", LUA_MODIFIER_MOTION_NONE)

function echo_stomp:IsHiddenWhenStolen()
    return false
end

function echo_stomp:IsStealable()
    return true
end

function echo_stomp:IsRefreshable()
    return true
end


function echo_stomp:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", caster)
    if caster:TG_HasTalent("special_bonus_elder_titan_2") then
        caster:Purge(false, true, false, true, true)
    end
    local particle3= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_cast_combined_detail_ti7.vpcf", PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl(particle3, 0,caster_pos)
    ParticleManager:SetParticleControl(particle3, 6,caster_pos)
    ParticleManager:ReleaseParticleIndex( particle3 )
    if not caster:HasModifier("modifier_ancestral_spirit_echo_stomp") then
        local  particle4= ParticleManager:CreateParticle("particles/heros/elder_titan/echo_stomp_cast_combined_ti7.vpcf", PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl(particle4, 0,caster_pos)
        ParticleManager:SetParticleControlForward(particle4,6, caster:GetAnglesAsVector())
        ParticleManager:ReleaseParticleIndex( particle4 )
    end
    caster:AddNewModifier( caster, self, "modifier_echo_stomp", {duration=1})
    if  caster.A then
        caster.B=false
    if caster.ancestral1~= nil then
        local AB= caster.ancestral1:FindAbilityByName("echo_stomp_spirit")
        if AB~=nil then
            caster.ancestral1:CastAbilityNoTarget( AB, caster.ancestral1:GetPlayerOwnerID())
        end
   end
end
end

function echo_stomp:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    if not bInterrupted then
        EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
        EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7_layer", caster)
        if  RollPseudoRandomPercentage(50,0,self) then
            local particle= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf", PATTACH_ABSORIGIN,caster)
            ParticleManager:SetParticleControl(particle, 0,caster_pos)
            ParticleManager:SetParticleControl(particle, 1,Vector(3000,3000,3000))
            ParticleManager:SetParticleControl(particle, 2,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
            ParticleManager:SetParticleControl(particle, 3,caster_pos)
            ParticleManager:ReleaseParticleIndex( particle )
        else
            local particle2= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_magical.vpcf", PATTACH_ABSORIGIN,caster)
            ParticleManager:SetParticleControl(particle2, 0,caster_pos)
            ParticleManager:SetParticleControl(particle2, 1,Vector(3000,3000,3000))
            ParticleManager:SetParticleControl(particle2, 3,caster_pos)
            ParticleManager:ReleaseParticleIndex( particle2 )
        end
        local dam=self:GetSpecialValueFor( "dam" )+caster:TG_GetTalentValue("special_bonus_elder_titan_1")
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster_pos,
            nil,
            self:GetSpecialValueFor( "rd" ),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
            for _, hero in pairs(heros) do
                if not hero:IsMagicImmune() then
                    if not caster:HasModifier("modifier_ancestral_spirit_echo_stomp") then
                        local damageTable = {
                            victim = hero,
                            attacker = caster,
                            damage =dam ,
                            damage_type =DAMAGE_TYPE_PHYSICAL,
                            ability = self,
                            }
                            ApplyDamage(damageTable)

                            local damageTable2 = {
                                victim = hero,
                                attacker = caster,
                                damage = dam,
                                damage_type =DAMAGE_TYPE_MAGICAL,
                                ability = self,
                                }

                            ApplyDamage(damageTable2)
                    else
                            local damageTable = {
                                    victim = hero,
                                    attacker = caster,
                                    damage = dam,
                                    damage_type =DAMAGE_TYPE_PHYSICAL,
                                    ability = self,
                                    }
                            ApplyDamage(damageTable)
                    end
                    hero:AddNewModifier( caster,self, "modifier_echo_stomp_debuff", {duration=self:GetSpecialValueFor( "sleep_dur" )})
                 end
            end

            if caster:HasScepter() then
                EmitSoundOn( "Hero_ElderTitan.EarthSplitter.Cast", caster )
                local dis=caster_pos+caster:GetForwardVector()*(self:GetSpecialValueFor("dis")*2)
                local t=self:GetSpecialValueFor("t")
                local team=caster:GetTeam()
                local wh=self:GetSpecialValueFor("wh")
                local dam2=self:GetSpecialValueFor("dam2")
                local stun_dur=self:GetSpecialValueFor("stun_dur")
                local particle5= ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_ABSORIGIN,caster)
                ParticleManager:SetParticleControl(particle5, 0,caster_pos)
                ParticleManager:SetParticleControl(particle5, 1,dis)
                ParticleManager:SetParticleControl(particle5, 3,Vector(0,t,0))
                ParticleManager:SetParticleControl(particle5, 60,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
                ParticleManager:SetParticleControl(particle5, 61,Vector(1,1,1))
                ParticleManager:ReleaseParticleIndex( particle5 )
                Timers:CreateTimer(t, function()
                    EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster )
                    local heros = FindUnitsInLine(
                        team,
                        caster_pos,
                        dis,
                        caster,
                        wh,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
                        DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
                    for _,hero in pairs(heros) do
                        local damageTable = {
                            attacker = caster,
                            victim = hero,
                            damage = dam2,
                            damage_type = DAMAGE_TYPE_PHYSICAL,
                            ability = self
                        }
                        ApplyDamage(damageTable)
                        hero:AddNewModifier(caster, self, "modifier_stunned", {duration =stun_dur})
                    end
                        return nil
                    end)
                end
         else
                StopSoundOn("Hero_ElderTitan.EchoStomp.Channel.ti7_layer", caster)
                if caster:HasModifier("modifier_echo_stomp_spirit") then
                    caster:RemoveModifierByName( "modifier_echo_stomp_spirit")
                end
                caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
        end
    caster.B=true
end


modifier_echo_stomp=class({})
function modifier_echo_stomp:IsHidden()
	return true
end

function modifier_echo_stomp:IsPurgable()
	return false
end

function modifier_echo_stomp:IsPurgeException()
	return false
end

function modifier_echo_stomp:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
    }
end

function modifier_echo_stomp:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end

function modifier_echo_stomp:GetOverrideAnimationRate()
    return 1.9
end

modifier_echo_stomp_debuff=class({})

function modifier_echo_stomp_debuff:IsDebuff()
    return true
end

function modifier_echo_stomp_debuff:IsHidden()
	return false
end

function modifier_echo_stomp_debuff:IsPurgable()
	return false
end

function modifier_echo_stomp_debuff:IsPurgeException()
	return true
end

function modifier_echo_stomp_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_echo_stomp_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_echo_stomp_debuff:OnCreated()
    self.limit=self:GetAbility():GetSpecialValueFor( "limit" )
end

function modifier_echo_stomp_debuff:OnRefresh()
    self.limit=self:GetAbility():GetSpecialValueFor( "limit" )
end

function modifier_echo_stomp_debuff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_echo_stomp_debuff:OnTakeDamage(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent() and tg.damage>self.limit and tg.unit:HasModifier("modifier_echo_stomp_debuff") then
        self:GetParent():RemoveModifierByName("modifier_echo_stomp_debuff")
    end
end

function modifier_echo_stomp_debuff:CheckState()
    return
     {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end
