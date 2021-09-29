elder_dragon_form=class({})
LinkLuaModifier("modifier_elder_dragon_form", "heros/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_dragon_form_buff", "heros/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_dragon_form_debuff", "heros/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_dragon_human", "heros/hero_dragon_knight/elder_dragon_form.lua", LUA_MODIFIER_MOTION_NONE)
function elder_dragon_form:IsHiddenWhenStolen()
    return false
end

function elder_dragon_form:IsStealable()
    return true
end

function elder_dragon_form:IsRefreshable()
    return true
end

function elder_dragon_form:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_dragon_knight_7")
end


function elder_dragon_form:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:Has_Aghanims_Shard() then
        local ab=caster:FindAbilityByName("dragon_knight_fireball")
        if ab then
		    ab:SetLevel(1)
            ab:SetHidden(false)
        end
    end
end

function elder_dragon_form:OnSpellStart()
    local caster=self:GetCaster()
    local lv=self:GetLevel()
    local num="default"
    local duration=self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_DragonKnight.ElderDragonForm", caster)
    caster:AddNewModifier(caster, self, "modifier_elder_dragon_form", {duration=duration})
    if lv==2 then
            num="1"
    elseif lv==3 then
            num="2"
    end
    if caster:HasScepter() then
        num="3"
        caster:AddNewModifier(caster, self, "modifier_elder_dragon_form_buff", {duration=duration})
    end
     caster:SetMaterialGroup(num)
end

function elder_dragon_form:GetIntrinsicModifierName()
    return "modifier_elder_dragon_human"
end


modifier_elder_dragon_human=class({})
function modifier_elder_dragon_human:IsHidden()
    return false
end

function modifier_elder_dragon_human:IsPurgable()
    return false
end

function modifier_elder_dragon_human:IsPurgeException()
    return false
end

function modifier_elder_dragon_human:RemoveOnDeath()
    return false
end

function modifier_elder_dragon_human:AllowIllusionDuplicate()
    return false
end
function modifier_elder_dragon_human:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.corrosive_breath_damage=self.ability:GetSpecialValueFor("corrosive_breath_damage")
    self.tower_dam=self.ability:GetSpecialValueFor("tower_dam")
    self.damage= {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self.ability,
        }
end

function modifier_elder_dragon_human:OnRefresh()
    self:OnCreated()
end

function modifier_elder_dragon_human:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_elder_dragon_human:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent and not self.parent:IsIllusion() and self.parent:TG_HasTalent("special_bonus_dragon_knight_5") then
            self.damage.damage = tg.target:IsBuilding() and self.corrosive_breath_damage*self.tower_dam*0.01 or self.corrosive_breath_damage
            self.damage.victim = tg.target
            ApplyDamage(self.damage)
	end
end

modifier_elder_dragon_form=class({})

function modifier_elder_dragon_form:IsHidden()
    return false
end

function modifier_elder_dragon_form:IsPurgable()
    return false
end

function modifier_elder_dragon_form:IsPurgeException()
    return false
end

function modifier_elder_dragon_form:RemoveOnDeath()
    return true
end

function modifier_elder_dragon_form:AllowIllusionDuplicate()
    return true
end

function modifier_elder_dragon_form:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.bonus_attack_range=self.ability:GetSpecialValueFor("bonus_attack_range")
    self.bonus_movement_speed=self.ability:GetSpecialValueFor("bonus_movement_speed")
    self.corrosive_breath_damage=self.ability:GetSpecialValueFor("corrosive_breath_damage")
    self.tower_dam=self.ability:GetSpecialValueFor("tower_dam")
    self.splash_radius=self.ability:GetSpecialValueFor("splash_radius")
    self.frost_duration=self.ability:GetSpecialValueFor("frost_duration")
    self.splash_damage_percent=self.ability:GetSpecialValueFor("splash_damage_percent")*0.01
    self.damage= {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self.ability,
        }
    self.damage2= {
            attacker = self.parent,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            ability = self.ability,
    }
    self.pn=""
    self.tn=""
    self.pos=self.parent:GetAbsOrigin()
    self.lv=self.ability:GetLevel()
    self.team=self.parent:GetTeamNumber()
    if IsServer() then
            if  self.parent:HasScepter() then
                    self.pn="particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_attack_black.vpcf"
                    self.tn="particles/units/heroes/hero_dragon_knight/dragon_knight_transform_black.vpcf"
            else
                if self.lv==1 then
                    self.pn="particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
                    self.tn="particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf"
                elseif self.lv==2 then
                    self.pn="particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
                    self.tn="particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
                elseif self.lv==3 then
                    self.pn="particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
                    self.tn="particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf"
                end
            end
            local pf1 = ParticleManager:CreateParticle(self.tn, PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControl(pf1, 0,self.pos)
            ParticleManager:SetParticleControl(pf1, 1,self.pos)
            ParticleManager:ReleaseParticleIndex(pf1)
            self.parent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
        end
end

function modifier_elder_dragon_form:OnRefresh()
    self:OnCreated()
end

function modifier_elder_dragon_form:OnDestroy()
    if IsServer() then
        self.parent:SetRenderColor(255,255,255)
        self.parent:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    end
end



function modifier_elder_dragon_form:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
end

function modifier_elder_dragon_form:GetModifierProjectileName()
    return self.pn
end

function modifier_elder_dragon_form:GetModifierModelChange()
    return "models/heroes/dragon_knight_persona/dk_persona_dragon.vmdl"
end

function modifier_elder_dragon_form:GetAttackSound()
    return "Hero_DragonKnight.ElderDragonShoot3.Attack"
end

function modifier_elder_dragon_form:GetModifierModelScale()
    return 30
end

function modifier_elder_dragon_form:GetModifierAttackRangeBonus()
    return self.bonus_attack_range
end

function modifier_elder_dragon_form:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_movement_speed
end

function modifier_elder_dragon_form:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent and not self.parent:IsIllusion() then
        if self.lv==1 then
            self.damage.damage = tg.target:IsBuilding() and self.corrosive_breath_damage*self.tower_dam*0.01 or self.corrosive_breath_damage
            self.damage.victim = tg.target
            ApplyDamage(self.damage)
        else
            local heros = FindUnitsInRadius(
                self.team,
                tg.target:GetAbsOrigin(),
                nil,
                self.splash_radius,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_ANY_ORDER,false)
                if #heros>0 then
                    for _, hero in pairs(heros) do
                        if self.lv==3 then
                          hero:AddNewModifier_RS(self.parent, self.ability, "modifier_elder_dragon_form_debuff", {duration=self.frost_duration})
                        end
                        if self.lv==2 or self.lv==3 then
                            self.damage.damage = hero:IsBuilding() and self.corrosive_breath_damage*self.tower_dam*0.01 or self.corrosive_breath_damage
                            self.damage.victim = hero
                            ApplyDamage(self.damage)
                            if not hero:IsBuilding() and hero~=tg.target then
                                self.damage2.damage = tg.original_damage*self.splash_damage_percent
                                self.damage2.victim = hero
                                ApplyDamage(self.damage2)
                            end
                        end
                    end
                end
        end

	end
end


modifier_elder_dragon_form_buff=class({})

function modifier_elder_dragon_form_buff:IsHidden()
    return true
end

function modifier_elder_dragon_form_buff:IsPurgable()
    return false
end

function modifier_elder_dragon_form_buff:IsPurgeException()
    return false
end

function modifier_elder_dragon_form_buff:RemoveOnDeath()
    return false
end

function modifier_elder_dragon_form_buff:AllowIllusionDuplicate()
    return true
end

function modifier_elder_dragon_form_buff:CheckState()
    return
     {
           [MODIFIER_STATE_FLYING] = true,
       }
end

function modifier_elder_dragon_form_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_elder_dragon_form_buff:OnCreated()
    self.ability=self:GetAbility()
    self.mr=self.ability:GetSpecialValueFor("mr")
    self.sr=self.ability:GetSpecialValueFor("sr")
    self.att=self.ability:GetSpecialValueFor("att")
end

function modifier_elder_dragon_form_buff:OnRefresh()
    self:OnCreated()
end

function modifier_elder_dragon_form_buff:GetModifierMagicalResistanceBonus()
    return  self.mr
end

function modifier_elder_dragon_form_buff:GetModifierStatusResistanceStacking()
    return self.sr
end

function modifier_elder_dragon_form_buff:GetModifierAttackSpeedBonus_Constant()
    return   self.att
end

modifier_elder_dragon_form_debuff=class({})

function modifier_elder_dragon_form_debuff:IsDebuff()
    return true
end

function modifier_elder_dragon_form_debuff:IsHidden()
    return false
end

function modifier_elder_dragon_form_debuff:IsPurgable()
    return false
end

function modifier_elder_dragon_form_debuff:IsPurgeException()
    return false
end



function modifier_elder_dragon_form_debuff:OnCreated()
    self.ability=self:GetAbility()
    self.frost_bonus_movement_speed=self.ability:GetSpecialValueFor("frost_bonus_movement_speed")
    self.frost_bonus_attack_speed=self.ability:GetSpecialValueFor("frost_bonus_attack_speed")
end

function modifier_elder_dragon_form_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_elder_dragon_form_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_elder_dragon_form_debuff:GetModifierAttackSpeedBonus_Constant()
    return self.frost_bonus_attack_speed
end

function modifier_elder_dragon_form_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.frost_bonus_movement_speed
end