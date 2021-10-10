mystic_snake=class({})
LinkLuaModifier("modifier_mystic_snake_debuff", "heros/hero_medusa/mystic_snake.lua", LUA_MODIFIER_MOTION_NONE)

function mystic_snake:IsHiddenWhenStolen()
    return false
end

function mystic_snake:IsStealable()
    return true
end

function mystic_snake:IsRefreshable()
    return true
end

function mystic_snake:GetCooldown(iLevel)
    local caster = self:GetCaster()
    if caster:HasScepter() then
        return self.BaseClass.GetCooldown(self,iLevel)-caster:TG_GetTalentValue("special_bonus_medusa_1")-4
    end
    return self.BaseClass.GetCooldown(self,iLevel)-caster:TG_GetTalentValue("special_bonus_medusa_1")
end

function mystic_snake:OnUpgrade()
    local caster = self:GetCaster()
    local ab = caster:FindAbilityByName("medusa_mystic_snake")
    if ab then
        ab:SetLevel(self:GetLevel())
    end
end

function mystic_snake:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    EmitSoundOn("Hero_Medusa.MysticSnake.Cast", caster)
    caster.hit_target = {}
    caster.mystic_snake_mana = 0
    caster.mystic_snake_jump = 0
    caster.mystic_snake_dam = self:GetSpecialValueFor("snake_damage")
    local P =
    {
		Target=target,
		Source=caster,
		Ability=self,
		EffectName="particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
		iMoveSpeed=1500,
		bDodgeable=false,
		iSourceAttachment=DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap=false,
		bVisibleToEnemies=true,
        iVisionTeamNumber=caster:GetTeamNumber(),
	}
    ProjectileManager:CreateTrackingProjectile(P)
end

function mystic_snake:OnProjectileHit_ExtraData( target, location, kv )
    if not target then
        return
    end
    local caster = self:GetCaster()
    local jumpnum=self:GetSpecialValueFor("snake_jumps")
    if target==caster   then
        if caster:IsAlive() then
            caster:GiveMana(caster.mystic_snake_mana)
            EmitSoundOn("Hero_Medusa.MysticSnake.Return", caster)
            SendOverheadEventMessage(nil,OVERHEAD_ALERT_MANA_ADD,caster,caster.mystic_snake_mana,caster:GetPlayerOwner())
        end
            return
    end

    if not target:IsMagicImmune() then
		EmitSoundOn("Hero_Medusa.MysticSnake.Target", target)
        local damageTable = {
			victim = target,
			attacker = caster,
			damage = caster.mystic_snake_dam,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}
        ApplyDamage(damageTable)
        target:AddNewModifier_RS(caster, self, "modifier_mystic_snake_debuff", {duration=self:GetSpecialValueFor("slow_duration")})
        target:AddNewModifier_RS(caster, self, "modifier_rooted", {duration=1.5+caster:TG_GetTalentValue("special_bonus_medusa_3")})
    end
    local mana_steal=self:GetSpecialValueFor("snake_mana_steal")+caster:TG_GetTalentValue("special_bonus_medusa_2")
    caster.hit_target[target] = true
    caster.mystic_snake_mana = caster.mystic_snake_mana + target:GetMaxMana()*mana_steal*0.01
    caster.mystic_snake_jump =  caster.mystic_snake_jump + 1
    caster.mystic_snake_dam = caster.mystic_snake_dam+caster.mystic_snake_dam*self:GetSpecialValueFor("dam")*0.01
    if  caster.mystic_snake_jump>=jumpnum then
        caster.mystic_snake_jump=0
        caster.mystic_snake_dam=self:GetSpecialValueFor("snake_damage")
        local P =
        {
            Target=caster,
            Source=target,
            Ability=self,
            EffectName="particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf",
            iMoveSpeed=1500,
            bDodgeable=false,
            iSourceAttachment=DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
            bDrawsOnMinimap=false,
            bVisibleToEnemies=true,
            iVisionTeamNumber=caster:GetTeamNumber(),
        }
        ProjectileManager:CreateTrackingProjectile(P)
    else
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil,self:GetSpecialValueFor("radius")+caster:TG_GetTalentValue("special_bonus_medusa_4"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
        if #enemies>0 then
            local next_target = nil
            for _,enemy in pairs(enemies) do
                local has_tar = false
                for unit,_ in pairs(caster.hit_target) do
                    if enemy==unit then
                        has_tar = true
                            break
                    end
                end
                if not has_tar then
                   next_target = enemy
                    break
                end
            end

                if caster.mystic_snake_jump>=jumpnum or not next_target then
                    caster.mystic_snake_jump=0
                    caster.mystic_snake_dam=self:GetSpecialValueFor("snake_damage")
                    local P =
                    {
                        Target=caster,
                        Source=target,
                        Ability=self,
                        EffectName="particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf",
                        iMoveSpeed=1500,
                        bDodgeable=false,
                        iSourceAttachment=DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                        bDrawsOnMinimap=false,
                        bVisibleToEnemies=true,
                        iVisionTeamNumber=caster:GetTeamNumber(),
                    }
                    ProjectileManager:CreateTrackingProjectile(P)
                    return
                end

            local P =
            {
                Target=next_target,
                Source=target,
                Ability=self,
                EffectName="particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
                iMoveSpeed=1500,
                bDodgeable=false,
                iSourceAttachment=DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
                bDrawsOnMinimap=false,
                bVisibleToEnemies=true,
                iVisionTeamNumber=caster:GetTeamNumber(),
            }
            ProjectileManager:CreateTrackingProjectile(P)
            caster.hit_target={}
        end
    end

end


modifier_mystic_snake_debuff=class({})

function modifier_mystic_snake_debuff:IsDebuff()
    return true
end

function modifier_mystic_snake_debuff:IsPurgable()
    return true
end

function modifier_mystic_snake_debuff:IsPurgeException()
    return true
end

function modifier_mystic_snake_debuff:IsHidden()
    return false
end

function modifier_mystic_snake_debuff:OnCreated()
    self.movement_slow=self:GetAbility():GetSpecialValueFor( "movement_slow" )
    self.turn_slow=self:GetAbility():GetSpecialValueFor( "turn_slow" )
end

function modifier_mystic_snake_debuff:OnRefresh()
    self:OnCreated()
end


function modifier_mystic_snake_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_mystic_snake_debuff:GetModifierMoveSpeedBonus_Percentage()
        return 0- self.movement_slow
end

function modifier_mystic_snake_debuff:GetModifierTurnRate_Percentage()
    return 0- self.turn_slow
end