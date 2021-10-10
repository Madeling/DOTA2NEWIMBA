tidebringer=class({})

LinkLuaModifier("modifier_tidebringer", "heros/hero_kunkka/tidebringer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tidebringer_att", "heros/hero_kunkka/tidebringer.lua", LUA_MODIFIER_MOTION_NONE)

function tidebringer:IsHiddenWhenStolen()
    return false
end

function tidebringer:IsStealable()
    return true
end

function tidebringer:IsRefreshable()
    return true
end

function tidebringer:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_3")
end

function tidebringer:GetIntrinsicModifierName()
    return "modifier_tidebringer"
end

function tidebringer:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
    if hTarget==nil then
        return
    end
   if not Is_Chinese_TG(hTarget,self:GetCaster()) then
    if not hTarget:IsMagicImmune() then
        local damageTable = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = 777,
            damage_type =DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
            ability = self,
            }
        ApplyDamage(damageTable)
        hTarget:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_stunned", {duration=1})
    end
   end
end

modifier_tidebringer=class({})

function modifier_tidebringer:IsHidden()
	return true
end

function modifier_tidebringer:IsPurgable()
    return false
end

function modifier_tidebringer:IsPurgeException()
    return false
end

function modifier_tidebringer:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
        MODIFIER_EVENT_ON_ATTACK_FINISHED
	}
end

function modifier_tidebringer:OnCreated()
       if not IsServer() then
            return
       end
       self.attnum=0
       self.swh=self:GetAbility():GetSpecialValueFor( "swh" )
       self.ewh=self:GetAbility():GetSpecialValueFor( "ewh" )
       self.dis=self:GetAbility():GetSpecialValueFor( "dis" )
       self:StartIntervalThink(0.1)
end

function modifier_tidebringer:OnIntervalThink()
    if self:GetAbility():IsCooldownReady() then
        if self.particle==nil then
            EmitSoundOn("Hero_Kunkaa.Tidebringer", self:GetParent())
			self.particle = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_plunder/kunkka_weapon_tidebringer_plunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            local point=self:GetParent():GetUnitName()=="npc_dota_hero_kunkka" and "attach_sword" or "attach_attack1"
            ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, point, self:GetParent():GetAbsOrigin(), true)
		end
	else
		if self.particle~=nil then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
			self.particle = nil
		end
    end
end

function modifier_tidebringer:OnAttackStart(tg)
    if not IsServer() then
        return
    end

    if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
        if not self:GetAbility():IsCooldownReady() then
            if self:GetParent():HasModifier("modifier_tidebringer_att") then
                self:GetParent():RemoveModifierByName("modifier_tidebringer_att")
            end
        else
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tidebringer_att", {})
        end
    end
end

function modifier_tidebringer:OnAttackCancelled(tg)
    if not IsServer() then
        return
    end

    if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
        if self:GetParent():HasModifier("modifier_tidebringer_att") then
            self:GetParent():RemoveModifierByName("modifier_tidebringer_att")
        end
    end
end

function modifier_tidebringer:OnAttackFinished(tg)
    if not IsServer() then
        return
    end

    if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
        if self:GetParent():HasModifier("modifier_tidebringer_att") then
            self:GetParent():RemoveModifierByName("modifier_tidebringer_att")
        end
    end
end

function modifier_tidebringer:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() and self:GetAbility():IsCooldownReady() and self:GetAbility():GetAutoCastState() and not tg.target:IsOther() then
            EmitSoundOn("Hero_Kunkka.Tidebringer.Attack", self:GetParent())
            self.attnum=self.attnum+1
                if self.attnum>=100 then
                    self.attnum=0
                     EmitSoundOn("kunkka_kunk_spawn_08", self:GetParent())
                     EmitGlobalSound("TG.kunkka")
                     local num=0
                     local pos=self:GetParent():GetAbsOrigin()
                     local dir=self:GetParent():GetForwardVector()*150
                        Timers:CreateTimer(0, function()
                            num=num+1
                            local projectile = {
                                Ability = self:GetAbility(),
                                EffectName = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf",
                                vSpawnOrigin =Vector(pos.x+math.random(-2000,2000),pos.y+math.random(-2000,2000),pos.z),
                                fDistance = 2000,
                                fStartRadius = 500,
                                fEndRadius = 500,
                                Source = self:GetParent(),
                                bHasFrontalCone = false,
                                bReplaceExisting = false,
                                bProvidesVision = true,
                                iVisionRadius = 500,
                                iVisionTeamNumber = self:GetParent():GetTeamNumber(),
                                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                vVelocity = dir,
                            }
                            ProjectileManager:CreateLinearProjectile(projectile)
                            if num==7 then
                                return nil
                            end
                                return 0.25
                        end)
                end
                local heros = FindUnitsInLine(
                    self:GetParent():GetTeam(),
                    self:GetParent():GetAbsOrigin(),
                    self:GetParent():GetAbsOrigin()+self:GetParent():GetForwardVector()*self.dis,
                    self:GetParent(),
                    self.swh,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
                    if #heros>0 then
                        for _,target in pairs(heros) do
                            if target~=tg.target then
                                local damageTable = {
                                    attacker = self:GetParent(),
                                    victim = target,
                                    damage = tg.damage*(self:GetAbility():GetSpecialValueFor( "num" )+(self:GetAbility():GetSpecialValueFor( "num1" )*#heros)+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_4")),
                                    damage_type = DAMAGE_TYPE_PURE,
                                    damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
                                    ability = self:GetAbility()
                                }
                                ApplyDamage(damageTable)
                            end
                        end
                    end
                DoCleaveAttack(
                    self:GetParent(),
                    tg.target,
                    self:GetAbility(),
                    0,
                    0,
                    0,
                    0,
                    "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf" )
                self:GetAbility():UseResources(false, false, true)
    end
        if tg.attacker == self:GetParent() then
            if self:GetParent():HasModifier("modifier_tidebringer_att") then
                self:GetParent():RemoveModifierByName("modifier_tidebringer_att")
            end
            if RollPseudoRandomPercentage(20,0,self:GetAbility()) then
                self:GetAbility():EndCooldown()
            end
        end


end


modifier_tidebringer_att=class({})

function modifier_tidebringer_att:IsHidden()
	return true
end

function modifier_tidebringer_att:IsPurgable()
    return false
end


function modifier_tidebringer_att:IsPurgeException()
    return false
end

function modifier_tidebringer_att:OnCreated()
    self.ATT=self:GetAbility():GetSpecialValueFor( "att" )
end

function modifier_tidebringer_att:OnRefresh()
    self:OnCreated()
end


function modifier_tidebringer_att:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_tidebringer_att:GetModifierPreAttack_BonusDamage()
    return self.ATT+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_8")
end