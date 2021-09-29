CreateTalents("npc_dota_hero_gyrocopter", "heros/hero_gyrocopter/rocket_barrage.lua")
rocket_barrage=class({})

LinkLuaModifier("modifier_rocket_barrage", "heros/hero_gyrocopter/rocket_barrage.lua", LUA_MODIFIER_MOTION_NONE)

function rocket_barrage:IsHiddenWhenStolen()
    return false
end

function rocket_barrage:IsStealable()
    return true
end

function rocket_barrage:IsRefreshable()
    return true
end

function rocket_barrage:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_gyrocopter_2") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function rocket_barrage:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_rocket_barrage", {duration=self:GetSpecialValueFor( "dur" )})
end


function rocket_barrage:OnProjectileHit_ExtraData( target, location, table )
    local caster=self:GetCaster()
   if target==nil then
        return
   end
   if not target:IsMagicImmune() and not target:IsInvisible() then
    EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage.Impact", caster)
        local dmg=self:GetSpecialValueFor( "dam" )
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = dmg,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
            }
        ApplyDamage(damageTable)
        local Knockback ={
            should_stun =false,
            knockback_duration = self:GetSpecialValueFor( "Knockback_dur" ),
            duration =0,
            knockback_distance = self:GetSpecialValueFor( "Knockback" ),
            knockback_height = 0,
            center_x =  caster:GetAbsOrigin().x,
            center_y =  caster:GetAbsOrigin().y,
            center_z =  caster:GetAbsOrigin().z
        }
        target:AddNewModifier(caster, self, "modifier_knockback", Knockback)
        if caster:TG_HasTalent("special_bonus_gyrocopter_1") then
             target:ReduceMana(dmg)
        end
    end
end

modifier_rocket_barrage=class({})

function modifier_rocket_barrage:IsBuff()
    return true
end

function modifier_rocket_barrage:IsHidden()
	return false
end

function modifier_rocket_barrage:IsPurgable()
	return false
end

function modifier_rocket_barrage:IsPurgeException()
	return false
end


function modifier_rocket_barrage:OnCreated()
    if not IsServer() then
        return
    end
    self.num=1
    self.rd=self:GetAbility():GetSpecialValueFor( "rd" )
    local i=self:GetAbility():GetSpecialValueFor( "dam_i" )
    EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage", self:GetParent())
    self.ATT=
    {
        DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
    }
    if self:GetParent():Has_Aghanims_Shard() then
        self.rd=self.rd+200
        self.num=2
    end
    if self:GetParent():HasModifier("modifier_call_down_buff") and self:GetParent():TG_HasTalent("special_bonus_gyrocopter_7") then
        self.rd=self.rd+400
    end
    self:StartIntervalThink(i)
end



function modifier_rocket_barrage:OnIntervalThink()
	 local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS,
            FIND_CLOSEST,
            false)

             if  #heros>0 then
                for a=0, self.num do
                    local target=TG_Random_Table(heros)
                    if not target:IsMagicImmune() and not target:IsInvisible() then
                    EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage.Launch", self:GetParent())
                    local P=
                    {
                        Target = target,
                        Source = self:GetParent(),
                        Ability = self:GetAbility(),
                        iSourceAttachment =  self.ATT and self.ATT[RandomInt(1, #self.ATT)] or DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                        EffectName ="particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf",
                        iMoveSpeed = 1000,
                        bDrawsOnMinimap = false,
                        bDodgeable = false,
                        bIsAttack = false,
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = false,
                    }
                    TG_CreateProjectile({id=1,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),p=P})

              --[[    local P2=
                    {
                        Target = target,
                        Source =  self:GetParent(),
                        Ability = self:GetAbility(),
                        iSourceAttachment =  DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
                        EffectName ="particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf",
                        iMoveSpeed = 1000,
                        bDrawsOnMinimap = false,
                        bDodgeable = false,
                        bIsAttack = false,
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = false,
                    }
                    TG_CreateProjectile({id=1,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),p=P})]]
                end
            end
        end
end



function modifier_rocket_barrage:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
end

function modifier_rocket_barrage:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end

function modifier_rocket_barrage:GetActivityTranslationModifiers()
    return "guns"
end
