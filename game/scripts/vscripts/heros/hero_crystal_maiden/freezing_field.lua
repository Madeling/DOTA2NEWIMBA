freezing_field=class({})
LinkLuaModifier("modifier_freezing_field", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freezing_field_debuff", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freezing_field_buff", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freezing_field_th", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_freezing_field_move", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_freezing_field_cd", "heros/hero_crystal_maiden/freezing_field.lua", LUA_MODIFIER_MOTION_NONE)
function freezing_field:IsHiddenWhenStolen()
    return false
end

function freezing_field:IsStealable()
    return true
end


function freezing_field:IsRefreshable()
    return true
end

function freezing_field:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end



function freezing_field:OnSpellStart()
	local caster = self:GetCaster()
	local cur_pos = self:GetCursorPosition()
    local dur= self:GetSpecialValueFor("duration")+caster:TG_GetTalentValue("special_bonus_crystal_maiden_6")
    dur=dur+math.floor(caster:GetMana()/100)*0.1
    if self:GetAutoCastState() then
        if caster:HasScepter() then
            caster:AddNewModifier(caster, self, "modifier_freezing_field_buff", {duration=dur})
         end
        caster:AddNewModifier(caster, self, "modifier_freezing_field", {duration=dur})
    else
	    CreateModifierThinker(caster, self, "modifier_freezing_field", {duration = dur}, cur_pos, caster:GetTeamNumber(), false)
    end
    if caster:TG_HasTalent("special_bonus_crystal_maiden_7") then
                    for a=1,10 do
                            local Projectile =
                            {
                                Ability = self,
                                EffectName = "particles/tgp/maiden_crystal/snowball_m.vpcf",
                                vSpawnOrigin =caster:GetAbsOrigin()+Vector(RandomInt(-1000,1000),RandomInt(-1000,1000),0),
                                fDistance = 3000,
                                fStartRadius = 100,
                                fEndRadius = 100,
                                Source = caster,
                                bHasFrontalCone = false,
                                bReplaceExisting = false,
                                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                vVelocity = caster:GetForwardVector() * 1000,
                                bProvidesVision = true,
                                iVisionRadius=300,
                                iVisionTeamNumber=caster:GetTeamNumber()
                            }
                            ProjectileManager:CreateLinearProjectile(Projectile)
                    end
    end

        if caster:TG_HasTalent("special_bonus_crystal_maiden_8") and self:GetAutoCastState() then
                EmitSoundOn("TG.cm",caster)
                caster:AddNewModifier(caster, self, "modifier_freezing_field_th", {duration=dur})
        end

end

function freezing_field:OnProjectileHit_ExtraData(target, location,kv)
    	local caster = self:GetCaster()
        if not target then
            return
        end
        if not target:IsMagicImmune() then
            target:AddNewModifier_RS(caster,self,"modifier_stunned",{duration=0.5})
                        local damageTable = {
                            attacker = caster,
                            victim = target,
                            damage = caster:GetIntellect(),
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self
                        }
                    ApplyDamage(damageTable)
        end
end

modifier_freezing_field_buff=class({})

function modifier_freezing_field_buff:IsPurgable()
    return false
end

function modifier_freezing_field_buff:IsPurgeException()
    return false
end

function modifier_freezing_field_buff:IsHidden()
    return false
end

function modifier_freezing_field_buff:DeclareFunctions()
        return
        {

            MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
        }
end

function modifier_freezing_field_buff:CheckState()
        return
        {
            [MODIFIER_STATE_UNSLOWABLE] = true,
        }
end


function modifier_freezing_field_buff:GetModifierIncomingDamage_Percentage()
    return  -20
end

modifier_freezing_field=class({})


function modifier_freezing_field:IsPurgable()
    return false
end

function modifier_freezing_field:IsPurgeException()
    return false
end

function modifier_freezing_field:IsHidden()
    return true
end

function modifier_freezing_field:OnCreated()
    self.caster=self:GetCaster()
    self.slow_duration=self:GetAbility():GetSpecialValueFor("slow_duration")
    self.radius=self:GetAbility():GetSpecialValueFor("radius")
    self.damage=self:GetAbility():GetSpecialValueFor("damage")
    self.explosion_radius=self:GetAbility():GetSpecialValueFor("explosion_radius")
    if not IsServer() then
        return
    end
    self.POS=self:GetParent():GetAbsOrigin()
    self.TEAM=self:GetParent():GetTeamNumber()
        self.fx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetParent())
        ParticleManager:SetParticleControl( self.fx, 0, self.POS)
        ParticleManager:SetParticleControl( self.fx, 1, Vector(self.radius, 0, 0))
        ParticleManager:SetParticleControl( self.fx, 3, self.POS)
        self:AddParticle( self.fx, false, false, -1, false, false)
        self:StartIntervalThink(0.2)
end

function modifier_freezing_field:OnIntervalThink()
        if not self.caster or not IsValidEntity(self.caster)  or not self.caster:IsAlive() then
            self:StartIntervalThink(-1)
            self:Destroy()
            return
        end
        local pos = GetGroundPosition(GetRandomPosition2D(self:GetParent():GetAbsOrigin(),self.radius),self:GetParent())
        ParticleManager:SetParticleControl( self.fx, 0,pos)
        ParticleManager:SetParticleControl( self.fx, 3, pos)
        EmitSoundOnLocationWithCaster(pos, "hero_Crystal.freezingField.explosion",self:GetParent())
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(fx, 0, pos)
        ParticleManager:ReleaseParticleIndex(fx)
	    local heros = FindUnitsInRadius(
        self.TEAM,
        pos,
        nil,
        self.explosion_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if not hero:IsMagicImmune() then
                    hero:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_freezing_field_debuff", {duration=self.slow_duration})
                    local damageTable =
                    {
                            victim = hero,
                            attacker = self:GetCaster(),
                            damage =  self.damage,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self:GetAbility(),
                    }
                    ApplyDamage(damageTable)
                end
            end
	    end
 end


function modifier_freezing_field:OnRefresh()
   self:OnCreated()
end

function modifier_freezing_field:OnDestroy()
    if  IsServer() then
        self:GetParent():StopSound("hero_Crystal.freezingField.wind")
    end
end


modifier_freezing_field_debuff=class({})

function modifier_freezing_field_debuff:IsDebuff()
    return true
end

function modifier_freezing_field_debuff:IsPurgable()
    return true
end

function modifier_freezing_field_debuff:IsPurgeException()
    return true
end

function modifier_freezing_field_debuff:IsHidden()
    return false
end

function modifier_freezing_field_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_freezing_field_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_freezing_field_debuff:OnCreated()
    self.movespeed_slow=self:GetAbility():GetSpecialValueFor("movespeed_slow")
    self.attack_slow=self:GetAbility():GetSpecialValueFor("attack_slow")
end

function modifier_freezing_field_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_freezing_field_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_freezing_field_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow
end

function modifier_freezing_field_debuff:GetModifierAttackSpeedBonus_Constant()
    return  self.attack_slow
end



modifier_freezing_field_th=class({})

function modifier_freezing_field_th:IsHidden()
    return true
end

function modifier_freezing_field_th:IsPurgable()
    return false
end

function modifier_freezing_field_th:IsPurgeException()
    return false
end

function modifier_freezing_field_th:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ORDER ,
    }
end
function modifier_freezing_field_th:OnOrder(tg)
        if IsServer() and tg.unit==self:GetParent() and  (tg.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or tg.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET) and not  self:GetParent():HasModifier("modifier_freezing_field_cd") and self:GetAbility():GetAutoCastState() then
                    if self:GetParent():HasModifier("modifier_freezing_field_move") then  self:GetParent():RemoveModifierByName("modifier_freezing_field_move") end
                    local dir=TG_Direction(tg.new_pos,self:GetParent():GetAbsOrigin())
                    local dis =TG_Distance(tg.new_pos,self:GetParent():GetAbsOrigin())
                    dis=dis>1000 and 1000 or dis
                    local time = dis/1000
                    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_freezing_field_cd", {duration=time})
                    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_freezing_field_move", {duration=time,dir=dir})
        end
end

modifier_freezing_field_move=class({})

function modifier_freezing_field_move:IsHidden()
    return true
end

function modifier_freezing_field_move:IsPurgable()
    return false
end

function modifier_freezing_field_move:IsPurgeException()
    return false
end

function modifier_freezing_field_move:RemoveOnDeath()
    return false
end

function modifier_freezing_field_move:OnCreated(tg)
	if IsServer() then
		self.direction=ToVector(tg.dir)

            local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            self:AddParticle( particle, false, false, 20, false, false )
            local particle1 = ParticleManager:CreateParticle("particles/econ/events/ti7/teleport_end_ti7_lvl3_rays.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(particle1,0,self:GetParent():GetAbsOrigin())
            self:AddParticle( particle1, false, false, 20, false, false )
			if not self:ApplyHorizontalMotionController()then
				self:Destroy()
			end
	end
end


function modifier_freezing_field_move:UpdateHorizontalMotion( t, g )
	    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.direction* (1000 / (1.0 / g)))
end


function modifier_freezing_field_move:OnHorizontalMotionInterrupted()
        if not IsServer() then
            return
        end
        self:Destroy()
end


function modifier_freezing_field_move:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

function modifier_freezing_field_move:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_freezing_field_move:GetOverrideAnimation()
        return ACT_DOTA_LOADOUT
end

function modifier_freezing_field_move:GetActivityTranslationModifiers()
    return "spinwheel"
end

modifier_freezing_field_cd=class({})

function modifier_freezing_field_cd:IsHidden()
    return false
end

function modifier_freezing_field_cd:IsPurgable()
    return false
end

function modifier_freezing_field_cd:IsPurgeException()
    return false
end