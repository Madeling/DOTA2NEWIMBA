sand_storm=class({})

LinkLuaModifier("modifier_sand_storm", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_inv", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_cd", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_debuff", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sand_storm_1", "heros/hero_sand_king/sand_storm.lua", LUA_MODIFIER_MOTION_NONE)
function sand_storm:IsHiddenWhenStolen() 
    return false 
end

function sand_storm:IsStealable() 
    return true 
end

function sand_storm:IsRefreshable() 			
    return true 
end

function sand_storm:GetIntrinsicModifierName() 
    return "modifier_sand_storm_1" 
end

function sand_storm:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
    EmitSoundOn( "Ability.SandKing_SandStorm.start", caster )
    ProjectileManager:ProjectileDodge(caster)
    CreateModifierThinker(caster, self, "modifier_sand_storm", {duration=self:GetSpecialValueFor("duration")}, casterpos, caster:GetTeamNumber(), false)
end

modifier_sand_storm_1=class({})

function modifier_sand_storm_1:IsHidden() 				
    return true 
end

function modifier_sand_storm_1:IsPurgable() 				
    return false 
end

function modifier_sand_storm_1:IsPurgeException() 		
    return false 
end

function modifier_sand_storm_1:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(10)
end

function modifier_sand_storm_1:OnIntervalThink()
    if self.caster:IsAlive() and not self.parent:IsIllusion() and self.ability:GetAutoCastState() and self.caster:TG_HasTalent("special_bonus_sand_king_5") then
        CreateModifierThinker(self.caster, self.ability, "modifier_sand_storm", {duration=5},self.caster:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
    end
end

modifier_sand_storm=class({})

function modifier_sand_storm:IsHidden() 				
    return true 
end

function modifier_sand_storm:IsPurgable() 				
    return false 
end

function modifier_sand_storm:IsPurgeException() 		
    return false 
end

function modifier_sand_storm:IsAura()
    return true
 end
 
 function modifier_sand_storm:GetAuraDuration() 
    return 0 
 end
 
 function modifier_sand_storm:GetModifierAura() 
    return "modifier_sand_storm_inv" 
 end
 
 function modifier_sand_storm:GetAuraRadius() 
    return self.ability:GetSpecialValueFor("sand_storm_radius")
 end
 
 function modifier_sand_storm:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end
 
 function modifier_sand_storm:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 end
 
 function modifier_sand_storm:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO 
 end

function modifier_sand_storm:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.pos=self.caster:GetAbsOrigin()
    self.damage_tick_rate=self.ability:GetSpecialValueFor("damage_tick_rate")
    self.sand_storm_radius=self.ability:GetSpecialValueFor("sand_storm_radius")+self.caster:GetCastRangeBonus()
    self.sand_storm_damage=self.ability:GetSpecialValueFor("sand_storm_damage")
    self.move=true
    if not IsServer() then
        return
    end
    EmitSoundOn( "Ability.SandKing_SandStorm.loop", self.parent )
    self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(self.fx, 0,self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(self.fx, 1, Vector(self.sand_storm_radius, self.sand_storm_radius, self.sand_storm_radius))
    self:AddParticle(self.fx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(self.damage_tick_rate)
end

function modifier_sand_storm:OnIntervalThink()
    if self.caster:HasModifier("modifier_sand_storm_inv") then
        local targets = FindUnitsInRadius(
                self.team,
                self.pos,
                nil,
                self.sand_storm_radius,
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST,
                false)
            if #targets>0 then
                    for _, target in pairs(targets) do
                                    local damageTable= 
                                    {
                                        victim = target,
                                        attacker = self.caster,
                                        damage = self.sand_storm_damage,
                                        damage_type = DAMAGE_TYPE_MAGICAL,
                                        ability = self.ability,
                                    }
                                    ApplyDamage(damageTable)
                                if self.move and self.ability:GetAutoCastState() and not target:HasModifier("modifier_fountain_aura_buff") then 
                                    FindClearSpaceForUnit(target, self.pos, true)
                                end
                                target:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_debuff", {duration=self.fade_delay})
                            end
                    self.move=false
            end
    end
end

function modifier_sand_storm:OnDestroy()
    if not IsServer() then
        return
    end
        StopSoundOn("Ability.SandKing_SandStorm.loop", self.parent)
end

modifier_sand_storm_inv=class({})

function modifier_sand_storm_inv:IsHidden() 				
    return false 
end

function modifier_sand_storm_inv:IsPurgable() 				
    return false 
end

function modifier_sand_storm_inv:IsPurgeException() 		
    return false 
end

function modifier_sand_storm_inv:DeclareFunctions()
	return 
    {
        MODIFIER_EVENT_ON_ATTACK, 
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_START
    }
end

function modifier_sand_storm_inv:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.fade_delay=self.ability:GetSpecialValueFor("fade_delay")
    self.hp=self.ability:GetSpecialValueFor("hp")+self.caster:TG_GetTalentValue("special_bonus_sand_king_2")
    if not IsServer() then
        return
    end
end

function modifier_sand_storm_inv:OnAttack(tg)
	if not IsServer() then
		return
	end
	if tg.attacker == self.parent then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_cd", {duration=self.fade_delay})
	end
end

function modifier_sand_storm_inv:OnAbilityStart(tg)
	if not IsServer() then
		return
	end
	if tg.unit == self.parent then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_sand_storm_cd", {duration=self.fade_delay})
	end
end

function modifier_sand_storm_inv:GetModifierInvisibilityLevel() 
    if self.parent:HasModifier("modifier_sand_storm_cd") then
        return 0
    else 
        return 1
    end 
end

function modifier_sand_storm_inv:GetModifierHealthRegenPercentage() 
    return self.hp
end


function modifier_sand_storm_inv:CheckState()
   if self.parent:HasModifier("modifier_sand_storm_cd") then
        return {}
    else 
        return 
        {
            [MODIFIER_STATE_INVISIBLE] = true, 
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        }
    end 
end



modifier_sand_storm_cd=class({})

function modifier_sand_storm_cd:IsHidden() 				
    return true 
end

function modifier_sand_storm_cd:IsPurgable() 				
    return false 
end

function modifier_sand_storm_cd:IsPurgeException() 		
    return false 
end

modifier_sand_storm_debuff=class({})

function modifier_sand_storm_debuff:IsHidden() 				
    return true 
end

function modifier_sand_storm_debuff:IsPurgable() 				
    return false 
end

function modifier_sand_storm_debuff:IsPurgeException() 		
    return false 
end