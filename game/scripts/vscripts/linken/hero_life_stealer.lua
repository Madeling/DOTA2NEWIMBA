CreateTalents("npc_dota_hero_life_stealer", "linken/hero_life_stealer.lua")
function IsEnemy(caster, target)
  if caster:GetTeamNumber()==target:GetTeamNumber() then   
    return false  
  else
    return true
  end 
end
imba_life_stealer_rage = class({})
LinkLuaModifier("modifier_imba_life_stealer_rage_self", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_rage_enemy", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_life_stealer_rage:IsHiddenWhenStolen()    return false end
function imba_life_stealer_rage:IsStealable()       return true end
function imba_life_stealer_rage:GetCastRange() return self:GetSpecialValueFor("range") end
function imba_life_stealer_rage:OnSpellStart()
  local caster = self:GetCaster()
  local duration = self:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_life_stealer_5")
  --定位目标
  if not caster:HasModifier("modifier_imba_life_stealer_buff") then
    caster:AddNewModifier(
    caster, 
    self, 
    "modifier_imba_life_stealer_rage_self", 
    {duration = duration}) 
  end    
    local targets = FindUnitsInRadius(
    caster:GetTeamNumber(),	-- int, your team number
    caster:GetAbsOrigin() ,	-- point, center point
    nil,	-- handle, cacheUnit. (not known)
    700,	-- float, radius. or use FIND_UNITS_EVERYWHERE 用了everywhere就是全图单位
    DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
    DOTA_UNIT_TARGET_HERO,	-- int, type filter
    DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
    FIND_CLOSEST,	-- int, order filter 或者从远到近，或者随机单位
    false	-- bool, can grow cache
    )
  
  for _, enemy in pairs(targets) do
    local buff = enemy:HasModifier("modifier_imba_life_stealer_target_buff")
    if buff then
      enemy:Purge(false, true, false, true, false)
      enemy:AddNewModifier(
      caster, 
      self, 
      "modifier_imba_life_stealer_rage_self", 
      {duration = duration})
    end
    

    if enemy and enemy ~= caster and not enemy:IsMagicImmune() and not buff then
      if self:GetAutoCastState() and IsEnemy(caster, enemy) then
        enemy:Purge(true, false, false, false, false)
        enemy:AddNewModifier(
        caster, 
        self, 
        "modifier_imba_life_stealer_rage_enemy", 
        {duration = duration})
        return
      elseif not self:GetAutoCastState() and not IsEnemy(caster, enemy) then
        enemy:Purge(false, true, false, true, false)
        enemy:AddNewModifier(
        caster, 
        self, 
        "modifier_imba_life_stealer_rage_enemy", 
        {duration = duration})
        return       
      end
    end
  end
end  





modifier_imba_life_stealer_rage_self    = class({})
function modifier_imba_life_stealer_rage_self:IsDebuff()      return false end
function modifier_imba_life_stealer_rage_self:IsHidden()      return false end
function modifier_imba_life_stealer_rage_self:IsPurgable()    return false end
function modifier_imba_life_stealer_rage_self:IsPurgeException()  return false end
function modifier_imba_life_stealer_rage_self:IsRefreshable()       return true end
function modifier_imba_life_stealer_rage_self:IsHiddenWhenStolen()    return false end
function modifier_imba_life_stealer_rage_self:IsRefreshable()       return true end
function modifier_imba_life_stealer_rage_self:IsStealable()       return true end
function modifier_imba_life_stealer_rage_self:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end
function modifier_imba_life_stealer_rage_self:DeclareFunctions()
  return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_imba_life_stealer_rage_self:GetModifierMoveSpeedBonus_Percentage() return (self:GetAbility():GetSpecialValueFor("speed")) end

function modifier_imba_life_stealer_rage_self:GetStatusEffectName()
  return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end
function modifier_imba_life_stealer_rage_self:OnCreated()
  if IsServer() then
    self:GetParent():EmitSound("Hero_lifestealer.rage")
    self:GetCaster():Purge(false, true, false, true, false)
    self:GetCaster():StartGesture(ACT_DOTA_LIFESTEALER_RAGE)
    self.pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage_mid.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
    self:AddParticle(self.pfx, false, false, -1, true, false)
  end
end
function modifier_imba_life_stealer_rage_self:OnRefresh()
  if IsServer() then
    self:OnCreated()
  end
end
function modifier_imba_life_stealer_rage_self:OnDestroy()
  if IsServer() then
    if self.pfx then
      ParticleManager:DestroyParticle(self.pfx, false)
      ParticleManager:ReleaseParticleIndex(self.pfx)
    end  
  end
end


modifier_imba_life_stealer_rage_enemy   = class({})
function modifier_imba_life_stealer_rage_enemy:IsDebuff()      return IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_life_stealer_rage_enemy:IsHidden()      return false end
function modifier_imba_life_stealer_rage_enemy:IsPurgable()    return false end
function modifier_imba_life_stealer_rage_enemy:IsPurgeException()  return false end
function modifier_imba_life_stealer_rage_enemy:IsRefreshable()       return true end
function modifier_imba_life_stealer_rage_enemy:IsHiddenWhenStolen()    return false end
function modifier_imba_life_stealer_rage_enemy:IsRefreshable()       return true end
function modifier_imba_life_stealer_rage_enemy:IsStealable()       return true end
function modifier_imba_life_stealer_rage_enemy:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = (not self:GetCaster():HasModifier("modifier_imba_life_stealer_buff")), [MODIFIER_STATE_SILENCED] = self:IsDebuff(), [MODIFIER_STATE_MUTED] = self:IsDebuff()} end
function modifier_imba_life_stealer_rage_enemy:DeclareFunctions()
  return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_imba_life_stealer_rage_enemy:GetModifierMoveSpeedBonus_Percentage()
    if self:IsDebuff() then 
      return ( 0 - self:GetAbility():GetSpecialValueFor("speed") * 2) 
    end
    return self:GetAbility():GetSpecialValueFor("speed")  
end
function modifier_imba_life_stealer_rage_enemy:GetStatusEffectName()
  return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end
function modifier_imba_life_stealer_rage_enemy:OnCreated()
  if IsServer() then
    self:GetParent():EmitSound("Hero_lifestealer.rage")
    local duration = (self:GetAbility():GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_life_stealer_5")) * (self:GetAbility():GetSpecialValueFor("duration_int")/100)
    if not self:GetCaster():TG_HasTalent("special_bonus_imba_life_stealer_4") then
      self:SetDuration(duration, true)
    end  
  end
end
function modifier_imba_life_stealer_rage_enemy:OnRefresh()
  if IsServer() then
    self:OnCreated()
  end
end
function modifier_imba_life_stealer_rage_enemy:OnDestroy()
  if IsServer() then   
  end
end






imba_life_stealer_feast = class({})
LinkLuaModifier("modifier_imba_life_stealer_feast_damage", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_life_stealer_feast:GetIntrinsicModifierName()
  return "modifier_imba_life_stealer_feast_damage"
end
modifier_imba_life_stealer_feast_damage = class({})
function modifier_imba_life_stealer_feast_damage:IsDebuff()      return false end
function modifier_imba_life_stealer_feast_damage:IsHidden()      return true end
function modifier_imba_life_stealer_feast_damage:IsPurgable()    return false end
function modifier_imba_life_stealer_feast_damage:IsPurgeException()  return false end
function modifier_imba_life_stealer_feast_damage:DeclareFunctions() return  {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_EVENT_ON_ATTACK,  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_life_stealer_feast_damage:GetModifierPreAttack_BonusDamage(keys)
  if keys.attacker ~= nil and not keys.attacker:PassivesDisabled() then
    local shuzhi1 = (self:GetAbility():GetSpecialValueFor("hp_leech_percent") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_life_stealer_6")) /100
    local ability = self:GetParent():FindAbilityByName("imba_life_stealer_control")
    local int = self:GetAbility():GetSpecialValueFor("int") * 0.01
    if self:GetCaster():HasModifier("modifier_imba_life_stealer_selfbuff") then
      shuzhi1 = shuzhi1 * ((ability:GetSpecialValueFor("add_feast") / 100) + 1)
    end
    if keys.target and keys.target:GetName() == "npc_dota_roshan" or keys.target:IsBuilding() then
      shuzhi1 = shuzhi1 * int
    end

    return (keys.target:GetMaxHealth() * shuzhi1)
  end  
end
function modifier_imba_life_stealer_feast_damage:OnAttack(keys)
  if not keys.attacker:PassivesDisabled() and keys.attacker == self:GetParent() then
    local shuzhi2 = (self:GetAbility():GetSpecialValueFor("hp_leech_percent") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_life_stealer_6")) /100
    local ability = self:GetParent():FindAbilityByName("imba_life_stealer_control")
    local int = self:GetAbility():GetSpecialValueFor("int") * 0.01
    if self:GetCaster():HasModifier("modifier_imba_life_stealer_selfbuff") then
      shuzhi2 = shuzhi2 * ((ability:GetSpecialValueFor("add_feast") / 100) + 1)
    end
    if keys.target and keys.target:GetName() == "npc_dota_roshan" or keys.target:IsBuilding() then
      shuzhi2 = shuzhi2 * int
    end
    self:GetParent():Heal(keys.target:GetMaxHealth() * shuzhi2 * (1+int), self:GetCaster())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, keys.target:GetMaxHealth() * shuzhi2 * (1+int), nil)    
    local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(lifesteal_particle)
  end
end

function modifier_imba_life_stealer_feast_damage:GetModifierAttackSpeedBonus_Constant()
  return (self:GetAbility():GetSpecialValueFor("as_bonus"))
end


imba_life_stealer_ghoul_frenzy = class({})
LinkLuaModifier("modifier_imba_life_stealer_ghoul_frenzy_pass", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_stealer_ghoul_frenzy_slow", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE)
function imba_life_stealer_ghoul_frenzy:Set_InitialUpgrade(tg)       
    return {LV=1} 
end
function imba_life_stealer_ghoul_frenzy:GetIntrinsicModifierName()
  return "modifier_imba_life_stealer_ghoul_frenzy_pass"
end
modifier_imba_life_stealer_ghoul_frenzy_pass= class({})
function modifier_imba_life_stealer_ghoul_frenzy_pass:IsDebuff()      return false end
function modifier_imba_life_stealer_ghoul_frenzy_pass:IsHidden()      return true end
function modifier_imba_life_stealer_ghoul_frenzy_pass:IsPurgable()    return false end
function modifier_imba_life_stealer_ghoul_frenzy_pass:IsPurgeException()  return false end
function modifier_imba_life_stealer_ghoul_frenzy_pass:DeclareFunctions() return  {MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_life_stealer_ghoul_frenzy_pass:OnCreated(params)
  local caster = self:GetCaster()
  self.duration = self:GetAbility():GetSpecialValueFor("duration")    
  self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
  self.radius = self:GetAbility():GetSpecialValueFor("radius")  
  if IsServer() then
    self:StartIntervalThink(1)
  end
end
function modifier_imba_life_stealer_ghoul_frenzy_pass:OnIntervalThink()
  local ability = self:GetAbility()
  if self:GetParent():Has_Aghanims_Shard() then
     ability:SetHidden(false)
    self:StartIntervalThink(-1)
  end 
end
function modifier_imba_life_stealer_ghoul_frenzy_pass:OnAttack(keys)
  if not keys.attacker:PassivesDisabled() and keys.attacker == self:GetParent() and self:GetParent():Has_Aghanims_Shard() then
    local caster = self:GetCaster()
    local target = keys.target
     target:AddNewModifier(
        caster,
        self:GetAbility(),
        "modifier_imba_life_stealer_ghoul_frenzy_slow",
        { duration = self.duration }
      )      
    local targets = FindUnitsInRadius(
    caster:GetTeamNumber(), -- int, your team number
    target:GetAbsOrigin() , -- point, center point
    nil,  -- handle, cacheUnit. (not known)
    self.radius ,  -- float, radius. or use FIND_UNITS_EVERYWHERE 用了everywhere就是全图单位
    DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
    DOTA_UNIT_TARGET_HERO,  -- int, type filter
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- int, flag filter
    FIND_CLOSEST, -- int, order filter 或者从远到近，或者随机单位
    false -- bool, can grow cache
    )
  
    for _, enemy in pairs(targets) do
      if enemy ~= target then
        enemy:AddNewModifier(
          caster,
          self:GetAbility(),
          "modifier_imba_life_stealer_ghoul_frenzy_slow",
          { duration = self.duration }
        )
      end   
    end
  end  
end

function modifier_imba_life_stealer_ghoul_frenzy_pass:GetModifierAttackSpeedBonus_Constant()
  return self.as_bonus
end

modifier_imba_life_stealer_ghoul_frenzy_slow= class({})
function modifier_imba_life_stealer_ghoul_frenzy_slow:IsDebuff()      return true end
function modifier_imba_life_stealer_ghoul_frenzy_slow:IsHidden()      return false end
function modifier_imba_life_stealer_ghoul_frenzy_slow:IsPurgable()    return false end
function modifier_imba_life_stealer_ghoul_frenzy_slow:IsPurgeException()  return false end
--function modifier_imba_life_stealer_ghoul_frenzy_slow:GetStatusEffectName() return "particles/status_fx/status_effect_poison_viper.vpcf" end
--function modifier_imba_life_stealer_ghoul_frenzy_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_life_stealer_ghoul_frenzy_slow:DeclareFunctions() return  {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_life_stealer_ghoul_frenzy_slow:OnCreated(params)
  local caster = self:GetCaster()
  self.movement_slow = 0-self:GetAbility():GetSpecialValueFor("movement_slow") 
    if IsServer() then
      self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
      ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
      --ParticleManager:ReleaseParticleIndex(self.pfx)
    end
end
function modifier_imba_life_stealer_ghoul_frenzy_slow:OnDestroy()
  if IsServer() then
    if self.pfx then
      ParticleManager:DestroyParticle(self.pfx, true)
      ParticleManager:ReleaseParticleIndex(self.pfx) 
    end     
  end 
end
function modifier_imba_life_stealer_ghoul_frenzy_slow:GetModifierMoveSpeedBonus_Percentage()  
  return self.movement_slow 
end
--------------------------------------------------------------------------------------------------------------------------------
imba_lifestealer_open_wounds = class({})
LinkLuaModifier( "modifier_imba_lifestealer_open_wounds", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
function imba_lifestealer_open_wounds:OnSpellStart(scepter)
  local caster = self:GetCaster()
  local target = self:GetCursorTarget()
  if target:TriggerSpellAbsorb( self ) then return end
  local duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_life_stealer_8")
  if target:IsMagicImmune() and not target:HasModifier("modifier_imba_life_stealer_rage_enemy") then
    duration = duration * (self:GetSpecialValueFor("immune_duration") / 100)
  end
  target:AddNewModifier(
    caster,
    self,
    "modifier_imba_lifestealer_open_wounds",
    { duration = duration }
  )

  local sound_cast = "Hero_LifeStealer.OpenWounds.Cast"
  local sound_target = "Hero_LifeStealer.OpenWounds"
  EmitSoundOn( sound_cast, caster )
  EmitSoundOn( sound_target, target )
  if caster:TG_HasTalent("special_bonus_imba_life_stealer_7") then
    if not scepter then
      local radius = self:GetSpecialValueFor("range")  
      local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
      for _, hero in pairs(heroes) do
        if hero ~= target then
          caster:SetCursorCastTarget(hero)
          self:OnSpellStart(true)
          return
        end
      end
      local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for _, unit in pairs(units) do
        if unit ~= target then
          caster:SetCursorCastTarget(unit)
          self:OnSpellStart(true)
          return
        end
      end 
    end
  end     
end


modifier_imba_lifestealer_open_wounds = class({})

function modifier_imba_lifestealer_open_wounds:IsHidden()
  return false
end

function modifier_imba_lifestealer_open_wounds:IsDebuff()
  return true
end

function modifier_imba_lifestealer_open_wounds:IsPurgable()
  return (not self:GetCaster():TG_HasTalent("special_bonus_imba_life_stealer_2"))
end

function modifier_imba_lifestealer_open_wounds:OnCreated( kv )

  self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" )/100
  self.step = 1
end

function modifier_imba_lifestealer_open_wounds:OnRefresh( kv )
  self.heal = self:GetAbility():GetSpecialValueFor( "heal_percent" )/100
  self.step = 1
end

function modifier_imba_lifestealer_open_wounds:OnDestroy( kv )

end
function modifier_imba_lifestealer_open_wounds:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }

  return funcs
end

function modifier_imba_lifestealer_open_wounds:GetModifierMoveSpeedBonus_Percentage()
  local duration = self:GetRemainingTime()
  local int = math.min(duration / (self:GetDuration()) * 100, self:GetAbility():GetSpecialValueFor( "slow_max" ))
  --print(math.min(0-int, 0-self:GetAbility():GetSpecialValueFor( "slow_min" ))) 
  return math.min(0-int, 0-self:GetAbility():GetSpecialValueFor( "slow_min" ))
end
function modifier_imba_lifestealer_open_wounds:GetModifierIncomingDamage_Percentage( keys )
  local x = keys.target:GetHealth() / keys.target:GetMaxHealth() * 100
  return math.min(100-x, self:GetAbility():GetSpecialValueFor( "vulnerability" ))
end

function modifier_imba_lifestealer_open_wounds:OnTakeDamage( params )
  if IsServer() then
    if params.unit ~= self:GetParent() then return end
    if params.attacker:GetTeamNumber()~=self:GetCaster():GetTeamNumber() or params.attacker:IsBuilding() then return end
    params.attacker:Heal( self.heal * params.damage, self:GetCaster() )
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, params.attacker, self.heal * params.damage, nil)
    self:PlayEffects( params.attacker )
  end
end
function modifier_imba_lifestealer_open_wounds:OnIntervalThink()
  self.step = self.step + 1
end
function modifier_imba_lifestealer_open_wounds:GetEffectName()
  return "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf"
end

function modifier_imba_lifestealer_open_wounds:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_lifestealer_open_wounds:PlayEffects( target )
  local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )

  ParticleManager:ReleaseParticleIndex( effect_cast )
end

------------------------------------------------------------------------------------------
imba_life_stealer_control = class({})
LinkLuaModifier( "modifier_imba_life_stealer_selfbuff", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_life_stealer_buff", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_life_stealer_target_buff", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_life_stealer_add_speed", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
function imba_life_stealer_control:IsRefreshable()       return true end
function imba_life_stealer_control:IsHiddenWhenStolen()    return true end
function imba_life_stealer_control:IsStealable()       return false end
function imba_life_stealer_control:GetCastRange()
  return self:GetCaster():HasScepter() and self:GetSpecialValueFor("range_scepter") or self:GetSpecialValueFor("range")
end
function imba_life_stealer_control:OnUpgrade()
  if self:GetLevel() <= 1 then
    local caster = self:GetCaster()
    local name = "imba_life_stealer_assimilate_eject"
    local name2 = "imba_life_stealer_parasite"
    local ability = caster:FindAbilityByName(name)  
    local ability2 = caster:FindAbilityByName(name2)  
    ability:SetLevel(1)
    ability2:SetLevel(1)
  end 
end
--[[function imba_life_stealer_control:GetCooldown(level)
  local cooldown = self.BaseClass.GetCooldown(self, level)
  local caster = self:GetCaster()
    if caster:TG_HasTalent("special_bonus_imba_life_stealer_3") then
      return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_life_stealer_3"))
    end
  return cooldown
end]]
function imba_life_stealer_control:OnAbilityPhaseStart() 
  local target = self:GetCursorTarget()

  if not target:IsAlive() or target:IsInvulnerable() or target:IsOutOfGame() then
    return false
  else
    return true
  end
end
function imba_life_stealer_control:OnSpellStart()
  local infest_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_infest", self:GetCaster())
  --local target = infest_modifier.infest_effect_modifier:GetParent()
  local target = self:GetCursorTarget()
  local caster = self:GetCaster()
  if target:IsInvulnerable() or target:IsOutOfGame() then return end

  local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_POINT, target)
  ParticleManager:SetParticleControl(infest_particle, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(infest_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(infest_particle)
  self:GetCaster():EmitSound("Hero_LifeStealer.Infest")
  ProjectileManager:ProjectileDodge(self:GetCaster())
  if IsEnemy(caster, target) then
    if target:IsHero() or target:IsBoss() then
      caster:AddNewModifier(caster, self, "modifier_imba_life_stealer_selfbuff", {duration = self:GetSpecialValueFor("duration")})
      return
    end
    caster:AddNewModifier(caster, self, "modifier_imba_life_stealer_buff", {})
    target:AddNewModifier(caster, self, "modifier_imba_life_stealer_target_buff", {})
  elseif target == caster then
    caster:AddNewModifier(caster, self, "modifier_imba_life_stealer_selfbuff", {duration = self:GetSpecialValueFor("duration")})
  else
    caster:AddNewModifier(caster, self, "modifier_imba_life_stealer_buff", {})
    target:AddNewModifier(caster, self, "modifier_imba_life_stealer_target_buff", {})
  end
  if target == caster and caster:TG_HasTalent("special_bonus_imba_life_stealer_3") then
    local cd = caster:TG_GetTalentValue("special_bonus_imba_life_stealer_3") * caster:GetCooldownReduction()
    self:EndCooldown()
    self:StartCooldown(cd)
  end  
end
----------------------------------------------------------------------------------------
modifier_imba_life_stealer_selfbuff = class({}) --对自身释放正面buff
function modifier_imba_life_stealer_selfbuff:IsPurgable() return false end
function modifier_imba_life_stealer_selfbuff:IsPurgeException()  return false end
function modifier_imba_life_stealer_selfbuff:IsDebuff()      return false end
function modifier_imba_life_stealer_selfbuff:IsHidden()      return false end
function modifier_imba_life_stealer_selfbuff:OnCreated()
  self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:AddParticle(self.pfx, false, false, -1, true, false)
end
function modifier_imba_life_stealer_selfbuff:OnDestroy()
  if IsServer() then
    if self.pfx then
      ParticleManager:DestroyParticle(self.pfx, false)
      ParticleManager:ReleaseParticleIndex(self.pfx)
    end  
  end
end
modifier_imba_life_stealer_add_speed = class({}) --被恐惧增加移速
function modifier_imba_life_stealer_add_speed:IsPurgable() return false end
function modifier_imba_life_stealer_add_speed:IsPurgeException()  return false end
function modifier_imba_life_stealer_add_speed:IsDebuff()      return true end
function modifier_imba_life_stealer_add_speed:IsHidden()      return false end
function modifier_imba_life_stealer_add_speed:DeclareFunctions()
  return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end
function modifier_imba_life_stealer_add_speed:OnCreated(keys)
  self.speed = 0-self:GetAbility():GetSpecialValueFor("speed_add")
end
function modifier_imba_life_stealer_add_speed:GetModifierMoveSpeedBonus_Percentage()
  return self.speed
end

----------------------------------------------------------------------------------------
modifier_imba_life_stealer_buff = class({}) --自身的隐藏效果
function modifier_imba_life_stealer_buff:IsPurgable() return false end
function modifier_imba_life_stealer_buff:IsPurgeException()  return false end
function modifier_imba_life_stealer_buff:IsDebuff()      return false end
function modifier_imba_life_stealer_buff:IsHidden()      return false end
function modifier_imba_life_stealer_buff:OnCreated( params )
  if not IsServer() then return end
  self:GetCaster():Purge(true, true, false, false, false)
  Timers:CreateTimer(FrameTime(), function()
    self:GetCaster():AddNoDraw()
  end)
  self.order = false
  self:GetCaster():SwapAbilities(
    self:GetAbility():GetAbilityName(),
    "imba_life_stealer_assimilate_eject",
    false,
    true
  )
  self:GetCaster():SwapAbilities(
  "imba_life_stealer_feast",
  "imba_life_stealer_parasite",
  false,
  true
  )
   --scepter Check
  if self:GetCaster():HasScepter() then
    for i=0,4 do
      local ability = self:GetCaster():GetAbilityByIndex(i)
      if ability then
        ability:SetActivated(true)
      end
    end
  else
     for i=0,4 do
        local ability = self:GetCaster():GetAbilityByIndex(i)
        if ability then
          ability:SetActivated(false)
        end
      end
  end
  self:StartIntervalThink(1)
  for i=0,5 do
    if self:GetParent():GetItemInSlot(i) ~= nil then
      local dm = self:GetParent():GetItemInSlot(i):GetName()
      if i ~= 0 then
        self:GetParent():GetItemInSlot(i):SetActivated(false)
      end  
    end
  end  
end

function modifier_imba_life_stealer_buff:OnOrder(keys)
  if IsServer() and keys.unit == self:GetParent() then
    if keys.order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
      self.order = true
    end
  end
end

function modifier_imba_life_stealer_buff:OnIntervalThink()
  if not IsServer() then return end
  for i=0,5 do
    if self:GetParent():GetItemInSlot(i) ~= nil then
      local dm = self:GetParent():GetItemInSlot(i):GetName()
      if i ~= 0 then
        self:GetParent():GetItemInSlot(i):SetActivated(false)
      end  
      local jc = dm == "item_imba_rapier_magic"  or dm == "item_imba_rapier_magic_2" or dm == "item_imba_rapier_cursed"
      if jc then
        self.order = true
      end
    end
  end
end

function modifier_imba_life_stealer_buff:CheckState()
  local state = {
    [MODIFIER_STATE_INVULNERABLE]             = true,
    [MODIFIER_STATE_OUT_OF_GAME]              = true,
    [MODIFIER_STATE_MAGIC_IMMUNE]             = true,
    [MODIFIER_STATE_ROOTED]                   = true,
    [MODIFIER_STATE_DISARMED]                 = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION]        = true,
    [MODIFIER_STATE_MUTED]                    = self.order,
    --[MODIFIER_STATE_COMMAND_RESTRICTED]       = order,
    [MODIFIER_STATE_NO_HEALTH_BAR]            = true,
    [MODIFIER_STATE_STUNNED]                  = not self:GetCaster():HasScepter(),
    [MODIFIER_STATE_UNSELECTABLE]             = true
  }
  return state

end

function modifier_imba_life_stealer_buff:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    MODIFIER_EVENT_ON_ORDER
  }
  return decFuncs
end
function modifier_imba_life_stealer_buff:GetModifierHealthRegenPercentage()
  return self:GetAbility():GetSpecialValueFor("base_regen")
end
function modifier_imba_life_stealer_buff:OnDestroy( params )
  if not IsServer() then return end
  self.order = false
  local cd = (self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction()
  self.modifier_cd = self:GetElapsedTime()
  if cd > self.modifier_cd then
    self:GetAbility():StartCooldown(cd)
  else
    self:GetAbility():StartCooldown(self.modifier_cd)
  end
  self.radius = self:GetAbility():GetSpecialValueFor("radius")
  self.damage = self:GetAbility():GetSpecialValueFor("damage")
  self:GetParent():EmitSound("Hero_LifeStealer.Consume")
  local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:ReleaseParticleIndex(infest_particle)

  self:GetParent():StartGesture(ACT_DOTA_LIFESTEALER_INFEST_END)

  local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _, enemy in pairs(targets) do
      local damageTable = {
        victim      = enemy,
        damage      = self.damage,
        damage_type   = self:GetAbility():GetAbilityDamageType(),
        damage_flags  = DOTA_DAMAGE_FLAG_NONE,
        attacker    = self:GetCaster(),
        ability     = self:GetAbility()
      }

      ApplyDamage(damageTable)
    end
    self:GetCaster():RemoveNoDraw()
    local caster = self:GetParent()
    local main_ability_name = "imba_life_stealer_control"
    local sub_ability_name  = "imba_life_stealer_assimilate_eject"
    self:GetCaster():SwapAbilities( main_ability_name, sub_ability_name, true, false )
    self:GetCaster():SwapAbilities(
      "imba_life_stealer_feast",
      "imba_life_stealer_parasite",
      true,
      false
    )
    FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
    self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_phased", {duration = 0.2})
    local scope_duration=self:GetAbility():GetSpecialValueFor("scope_duration")
    local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("scope_aoe"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
    for _, enemy in pairs(targets) do
      if enemy:IsCreep() then
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = scope_duration})
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_add_speed", {duration = (scope_duration)})
      else
        if IsEnemy(self:GetCaster(), enemy) and self:GetCaster():TG_HasTalent("special_bonus_imba_life_stealer_1") then
          enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = (scope_duration/2)})
          enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_add_speed", {duration = (scope_duration/2)})
          else
        end
      end
    end
     --scepter check
    for i=0,4 do
      local ability = self:GetCaster():GetAbilityByIndex(i)
      if ability then
        ability:SetActivated(true)
      end
    end
  for i=0,5 do
    if self:GetParent():GetItemInSlot(i) ~= nil then
      self:GetParent():GetItemInSlot(i):SetActivated(true)
    end
  end    
end
----------------------------------------------------------------------------------------

modifier_imba_life_stealer_target_buff = class({}) -- 大招目标的修饰器
function modifier_imba_life_stealer_target_buff:IsPurgable() return false end
function modifier_imba_life_stealer_target_buff:IsPurgeException()  return false end
function modifier_imba_life_stealer_target_buff:IsDebuff()      return false end
function modifier_imba_life_stealer_target_buff:IsHidden()      return true end
function modifier_imba_life_stealer_target_buff:GetModifierHealthRegenPercentage()
  return (self:GetAbility():GetSpecialValueFor("base_regen") / 2)
end
function modifier_imba_life_stealer_target_buff:GetModifierHealthBonus()
  return (self:GetAbility():GetSpecialValueFor("max_hp"))
end
function modifier_imba_life_stealer_target_buff:OnCreated()
  if not IsServer() then return end
  self.pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
  self:AddParticle(self.pfx, false, false, -1, true, false)
  local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("scope_aoe"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
  for _, enemy in pairs(targets) do
    if enemy:IsCreep() then
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = self:GetAbility():GetSpecialValueFor("scope_duration")})
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_add_speed", {duration = (self:GetAbility():GetSpecialValueFor("scope_duration"))})
    else
      if IsEnemy(self:GetCaster(), enemy) and self:GetCaster():TG_HasTalent("special_bonus_imba_life_stealer_1") then
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", {duration = (self:GetAbility():GetSpecialValueFor("scope_duration")/2)})
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_life_stealer_add_speed", {duration = (self:GetAbility():GetSpecialValueFor("scope_duration")/2)})
        else
      end
    end
  end

  self:StartIntervalThink(0.1)
end
function modifier_imba_life_stealer_target_buff:OnIntervalThink()
  if not IsServer() then return end
  self:GetCaster():SetAbsOrigin(self:GetParent():GetAbsOrigin())
  if not self:GetCaster():HasModifier("modifier_imba_life_stealer_buff") then
    Timers:CreateTimer(FrameTime(), function()
      self:Destroy()
    end)
   end
end
function modifier_imba_life_stealer_target_buff:OnDestroy(params)
  if not IsServer() then return end
  local infest_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_buff", self:GetCaster())
  if infest_modifier then
    infest_modifier:Destroy()
  end
  local infest_modifier2 = self:GetParent():FindModifierByNameAndCaster("modifier_imba_life_stealer_parasite", self:GetCaster())
  if infest_modifier2 then
    infest_modifier2:Destroy()
  end  
  if self.pfx then
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
  end  
end
function modifier_imba_life_stealer_target_buff:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_BONUS
  }
  return decFuncs
end
function modifier_imba_life_stealer_target_buff:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("speed_bonus")
end


imba_life_stealer_assimilate_eject = class({})
function imba_life_stealer_assimilate_eject:IsStealable() return false end
function imba_life_stealer_assimilate_eject:GetAssociatedPrimaryAbilities()  return "imba_life_stealer_control" end
function imba_life_stealer_assimilate_eject:OnSpellStart()
  local infest_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_life_stealer_buff", self:GetCaster())
  if infest_modifier then
    infest_modifier:Destroy()
  end
   local control = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 200, 3, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
   for k = 1, #control do
      if #control ~= 0 and control[k]:HasModifier("modifier_imba_life_stealer_target_buff") and control[k]:IsCreep() then
        control[k]:Kill(self, self:GetCaster())
      end
    end
end
--[[function imba_life_stealer_assimilate_eject:OnOwnerSpawned()
  local control_ability = self:GetCaster():FindAbilityByName("imba_life_stealer_control")

  if control_ability and control_ability:IsHidden() then
    self:GetCaster():SwapAbilities("imba_life_stealer_control", "imba_life_stealer_assimilate_eject", true, false)
  end
end]]

imba_life_stealer_parasite = class({})
LinkLuaModifier( "modifier_imba_life_stealer_parasite", "linken/hero_life_stealer.lua", LUA_MODIFIER_MOTION_NONE )
function imba_life_stealer_parasite:IsStealable() return false end
function imba_life_stealer_parasite:OnSpellStart()
  local caster = self:GetCaster()
  self:GetCaster():Purge(false, true, false, true, true)
  if caster:HasModifier("modifier_imba_life_stealer_buff") then
    local control = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
      for k = 1, #control do
        if #control ~= 0 and control[k]:HasModifier("modifier_imba_life_stealer_target_buff") then
          control[k]:AddNewModifier(caster, self, "modifier_imba_life_stealer_parasite", {duration = self:GetSpecialValueFor("duration")})
        end
      end
  end
end
modifier_imba_life_stealer_parasite = class({}) -- 分摊伤害修饰器
function modifier_imba_life_stealer_parasite:IsPurgable() return false end
function modifier_imba_life_stealer_parasite:IsPurgeException()  return false end
function modifier_imba_life_stealer_parasite:IsDebuff()      return false end
function modifier_imba_life_stealer_parasite:IsHidden()      return false end
function modifier_imba_life_stealer_parasite:OnCreated()
  if IsServer() then
    self.m2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/life_stealer/life_stealer.vmdl"})
    self.m2:SetParent(self:GetParent(), nil)
    self.m2:FollowEntity(self:GetParent(), true)
    self.m3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/lifestealer/immortal_back/lifestealer_immortal_back.vmdl"})
    self.m3 :SetParent(self:GetParent(), nil)
    self.m3 :FollowEntity(self:GetParent(), true) 
    local infest_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(infest_particle)
    self:GetParent():EmitSound("Hero_LifeStealer.Consume")
  end  
end
function modifier_imba_life_stealer_parasite:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }

  return funcs
end
function modifier_imba_life_stealer_parasite:OnDestroy()
  if IsServer() then
    self.m2:RemoveSelf()
    self.m3:RemoveSelf()  
  end
end
function modifier_imba_life_stealer_parasite:GetModifierIncomingDamage_Percentage()
  return (0-self:GetAbility():GetSpecialValueFor("reduce_damage"))
end
function modifier_imba_life_stealer_parasite:OnTakeDamage( keys )
    if not IsServer() then
      return
    end
    if keys.unit ~= self:GetParent() then
      return
    end
    if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
      return
    end
    --ApplyDamage({attacker = keys.attacker, victim = self:GetCaster(), damage = keys.original_damage, damage_type = DAMAGE_TYPE_NONE, ability = self:GetAbility()})
    local damage_taken = keys.original_damage * 0.6
    local caster_hp = self:GetCaster():GetHealth()
    if caster_hp <= damage_taken then
        self:GetCaster():Kill(self:GetAbility(), keys.attacker)
    else
      self:GetCaster():SetHealth(math.ceil(caster_hp - (damage_taken * self:GetAbility():GetSpecialValueFor("add_damage") / 100)))
    end
end
