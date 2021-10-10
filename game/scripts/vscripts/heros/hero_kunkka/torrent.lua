CreateTalents("npc_dota_hero_kunkka", "heros/hero_kunkka/torrent.lua")
torrent = class({})
LinkLuaModifier("modifier_torrent", "heros/hero_kunkka/torrent.lua", LUA_MODIFIER_MOTION_NONE)

function torrent:IsHiddenWhenStolen()
    return false
end

function torrent:IsStealable()
    return true
end

function torrent:IsRefreshable()
    return true
end

function torrent:GetAOERadius()
	return 250+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_1")
end

function torrent:OnSpellStart()
    local caster = self:GetCaster()
    local cpos = caster:GetAbsOrigin()
    local cur_pos = self:GetCursorPosition()
    local delay = self:GetSpecialValueFor( "delay" )
    local rd2 = self:GetSpecialValueFor( "rd2" )
    local dis=TG_Distance(cur_pos,cpos)
    dis=dis>1500 and 1500 or dis
    local dir=TG_Direction(cur_pos+Vector(1,1,1),cpos)
    EmitSoundOnLocationForAllies(cur_pos, "Ability.pre.Torrent", caster)
    AddFOWViewer(caster:GetTeamNumber(), cur_pos, rd2, delay*2, false)
    CreateModifierThinker(caster, self, "modifier_torrent", {duration=delay}, cur_pos, caster:GetTeamNumber(), false)
    if self:GetAutoCastState() then
        caster:EmitSound( "Ability.Ghostship.bell" )
        local projectile = {
            Ability = self,
            EffectName = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf",
            vSpawnOrigin =cpos,
            fDistance = dis,
            fStartRadius = 350,
            fEndRadius = 350,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            bProvidesVision = true,
            iVisionRadius = 500,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            vVelocity = dir*1000,
        }
        ProjectileManager:CreateLinearProjectile(projectile)
    end
end

function torrent:OnProjectileThink_ExtraData(location, kv)
        local heros = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            location,
            nil,
            350,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #heros>0 then
                for _, hero in pairs(heros) do
                    if hero:IsAlive() and not hero:IsMagicImmune() and not hero:IsBoss() and not hero:HasModifier("modifier_ghostship_debuff") then
                        if hero:HasModifier("modifier_knockback") then
                            hero:RemoveModifierByName("modifier_knockback")
                        end
                        if hero:HasModifier("modifier_tree_dance_height") then
                            hero:RemoveModifierByName("modifier_tree_dance_height")
                        end
                        hero:AddNewModifier(self:GetCaster(),self,"modifier_phased",{duration=2})
                        hero:SetAbsOrigin(GetGroundPosition(location, hero))
                    end
                end
        end
end

function torrent:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
    if hTarget==nil then
        return
    end
    if self:GetCaster():TG_HasTalent("special_bonus_kunkka_7") and hTarget:IsHero() then
        hTarget:AddNewModifier_RS(self:GetCaster(),self,"modifier_imba_stunned",{duration=1})
    end
end

modifier_torrent=class({})

function modifier_torrent:IsHidden()
	return true
end

function modifier_torrent:IsPurgable()
	return false
end

function modifier_torrent:IsPurgeException()
	return false
end

function modifier_torrent:GetPriority()
	return 10
end

function modifier_torrent:OnCreated()
    if not IsServer() then
        return
    end
    self.rd2=self:GetAbility():GetSpecialValueFor( "rd2" )
    self.stun=self:GetAbility():GetSpecialValueFor( "stun" )
    local particle= ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(particle, 0,self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, 20, false, false)
end


function modifier_torrent:OnDestroy()
    if not IsServer() then
        return
    end
    local dam=self:GetAbility():GetSpecialValueFor( "dam" )+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_2")
    EmitSoundOnLocationForAllies(self:GetParent():GetAbsOrigin(), "Ability.Torrent", self:GetParent())
    local particle1 = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle1, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle1)
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor( "rd" ),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if not hero:IsMagicImmune() then
                local damageTable = {
                    victim = hero,
                    attacker = self:GetCaster(),
                    damage = dam,
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(),
                    }
                 ApplyDamage(damageTable)
                 local Knockback ={
                    should_stun = self.stun,
                    knockback_duration = self.stun,
                    duration = self.stun,
                    knockback_distance = 0,
                    knockback_height = 400,
                    center_x =  hero:GetAbsOrigin().x,
                    center_y =  hero:GetAbsOrigin().y,
                    center_z =  hero:GetAbsOrigin().z
                }
                hero:AddNewModifier_RS(self:GetParent(),self:GetAbility(), "modifier_knockback", Knockback)
             end
        end
    end
end