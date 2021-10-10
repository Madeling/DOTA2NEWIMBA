CreateTalents("npc_dota_hero_obsidian_destroyer", "heros/hero_obsidian_destroyer/arcane_orb.lua")
arcane_orb=class({})
LinkLuaModifier("modifier_arcane_orb", "heros/hero_obsidian_destroyer/arcane_orb.lua", LUA_MODIFIER_MOTION_NONE)

function arcane_orb:GetIntrinsicModifierName() 
    return "modifier_arcane_orb" 
end

function arcane_orb:OnAbilityPhaseStart() 
    local caster=self:GetCaster() 
    local att=caster:GetBaseAttackTime()
    if self:IsOwnersManaEnough()  then
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, att)
    end
    return true
end


function arcane_orb:OnSpellStart() 
    local caster=self:GetCaster() 
    local target=self:GetCursorTarget() 
    local att=caster:GetBaseAttackTime()
        local P = 
        {
            Target = target,
            Source = caster,
            Ability = self,	
            EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
            iMoveSpeed = caster:GetProjectileSpeed(),
            vSourceLoc = caster:GetAbsOrigin(),
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = true,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 10,
            bProvidesVision = false,
        }
        ProjectileManager:CreateTrackingProjectile(P)
end

function arcane_orb:OnProjectileHit(target, location)
    if target==nil then
        return
    end
    local caster=self:GetCaster() 
    local mana_pool_damage_pct=self:GetSpecialValueFor("mana_pool_damage_pct")+caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_1")
    local rd=self:GetSpecialValueFor("rd")+caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_2")
    local dam=caster:GetMaxMana()*mana_pool_damage_pct*0.01
    local damage= {
        attacker = caster,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self,
        }
    if not target:IsBuilding() then 
        damage.damage = target:IsMagicImmune() and dam/2 or dam
        damage.victim = target
        ApplyDamage(damage)
    end 
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        rd, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        FIND_ANY_ORDER,false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if hero~=target then
                    damage.damage = hero:IsMagicImmune() and dam/4 or dam/2
                    damage.victim = hero
                    ApplyDamage(damage)
                end
            end
        end

end


modifier_arcane_orb=class({})

function modifier_arcane_orb:IsPurgable() 			
    return false 
end

function modifier_arcane_orb:IsPurgeException() 	
    return false 
end

function modifier_arcane_orb:IsHidden()				
    return true 
end

function modifier_arcane_orb:OnCreated()				
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.mana_pool_damage_pct=self.ability:GetSpecialValueFor("mana_pool_damage_pct")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_1")
    self.rd=self.ability:GetSpecialValueFor("rd")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_2")
    self.team=self.parent:GetTeamNumber()
    self.damage= {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self.ability,
        }
end

function modifier_arcane_orb:OnRefresh()				
    self:OnCreated()
end


function modifier_arcane_orb:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_arcane_orb:GetModifierProjectileName()
    if self.ability:GetAutoCastState() and self.ability:IsOwnersManaEnough()  then
        return  "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf" 
    end
    return ""
end 


function modifier_arcane_orb:OnAttackLanded(tg)
    if not IsServer() then
        return
    end  
    if tg.attacker == self.parent and self.ability:GetAutoCastState()  and self.ability:IsOwnersManaEnough()  then
        self.ability:UseResources(true, false, false) 
        local dam=self.parent:GetMaxMana()*self.mana_pool_damage_pct*0.01
        if not tg.target:IsBuilding() then 
            self.damage.damage = tg.target:IsMagicImmune() and dam/2 or dam
            self.damage.victim = tg.target
            ApplyDamage(self.damage)
        end 
        local heros = FindUnitsInRadius(
            self.team,
            tg.target:GetAbsOrigin(),
            nil,
            self.rd, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            FIND_ANY_ORDER,false)
            if #heros>0 then
                for _, hero in pairs(heros) do
                    if hero~=tg.target then
                        self.damage.damage = hero:IsMagicImmune() and dam/4 or dam/2
                        self.damage.victim = hero
                        ApplyDamage(self.damage)
                    end
                end
            end
    end
end