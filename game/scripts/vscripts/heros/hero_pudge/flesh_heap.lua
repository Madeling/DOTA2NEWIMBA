flesh_heap=class({})
LinkLuaModifier("modifier_flesh_heap_pa", "heros/hero_pudge/flesh_heap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_heap_hook_move", "heros/hero_pudge/flesh_heap.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_flesh_heap_buff", "heros/hero_pudge/flesh_heap.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_flesh_heap_cd", "heros/hero_pudge/flesh_heap.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function flesh_heap:Init()
      self.caster=self:GetCaster()
      self.stack=self.stack or 0
end
function flesh_heap:OnHeroDiedNearby(target, owner, table)
      if target==owner or not target:IsTrueHero() or not self.caster:IsAlive() or self.caster:IsIllusion() or  Is_Chinese_TG(target,self.caster) then
            return
      end
	if   TG_Distance(target:GetAbsOrigin(),self.caster:GetAbsOrigin())<= 500  then
            self.stack=self.stack+1
            if self.caster:HasModifier("modifier_flesh_heap_pa") then
                  self.caster:SetModifierStackCount("modifier_flesh_heap_pa",self.caster,self.stack)
            end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
function flesh_heap:OnSpellStart()
            local sp=self:GetSpecialValueFor("hook_speed")
            local wh=self:GetSpecialValueFor("hook_width")
            local dis=self:GetSpecialValueFor("hook_distance")
            local vision_radius=self:GetSpecialValueFor("vision_radius")
            local cpos=self.caster:GetAbsOrigin()
            local epos=self:GetCursorPosition()
            local dir=(epos - cpos):Normalized() dir.z = 0.0
            local tpos=cpos + dir* dis
            local fx=ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_ti10_immortal/pudge_ti10_immortal_meathook.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
            ParticleManager:SetParticleAlwaysSimulate( fx )
            ParticleManager:SetParticleControlEnt( fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", cpos, true )
            ParticleManager:SetParticleControl( fx, 1, tpos)
            ParticleManager:SetParticleControl( fx, 2, Vector( sp,   dis, wh ) )
            ParticleManager:SetParticleControl( fx, 3, Vector( ( (   dis / sp ) * 2 ), 0, 0 ) )
            ParticleManager:SetParticleControl( fx, 4, Vector( 1, 0, 0 ) )
            ParticleManager:SetParticleControl( fx, 5, Vector( 0, 0, 0 ) )
            local fx1=ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_swallow_release.vpcf", PATTACH_CENTER_FOLLOW , self.caster )
            ParticleManager:SetParticleControl( fx1, 0, cpos)
            ParticleManager:ReleaseParticleIndex(fx1)
            EmitSoundOn( "Hero_Pudge.AttackHookExtend", self.caster )
            local PP =
            {
                  Ability = self,
                  vSpawnOrigin =cpos ,
                  vVelocity = dir *sp,
                  fDistance =   dis,
                  fStartRadius = wh ,
                  fEndRadius = wh ,
                  Source =self.caster,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE ,
                  bVisibleToEnemies = true,
                  bProvidesVision = true,
                  iVisionRadius = vision_radius,
                  iVisionTeamNumber = self.caster:GetTeamNumber(),
                  ExtraData={hs=dis/sp,fx=fx,x=cpos.x,y=cpos.y,z=cpos.z }
            }
            ProjectileManager:CreateLinearProjectile( PP )
end

function flesh_heap:OnProjectileHit_ExtraData( hTarget, vLocation,kv )
      if hTarget~=nil and (  hTarget == self.caster or  ( (hTarget:IsBoss() or hTarget:IsCreep() ) and Is_Chinese_TG(hTarget,self.caster) ) ) or kv.fx==nil   then
		return false
	end
      local fx=kv.fx
      local cpos=self.caster:GetAbsOrigin()
	if hTarget    then
            if hTarget:HasModifier("modifier_fountain_aura_buff") then
                        	return false
                  else
                        local tpos=hTarget:GetAbsOrigin()
                        hTarget:InterruptMotionControllers(true)
                        if hTarget:HasModifier("modifier_flesh_heap_hook_move") then
                                    hTarget:RemoveModifierByName("modifier_flesh_heap_hook_move")
                        end
                              local fx1=ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN,hTarget )
                              ParticleManager:SetParticleControlEnt( fx1, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", tpos , true )
                              ParticleManager:ReleaseParticleIndex(fx1)
                              EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
                              EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )
                              hTarget:AddNewModifier( self.caster, self, "modifier_flesh_heap_hook_move", {fx=fx,x=kv.x,y=kv.y,z=kv.z} )
                               if hTarget:IsHero() and self.caster:HasScepter() and self.caster:TG_HasTalent("special_bonus_pudge_2") then
                                    local hp=self.caster:GetMaxHealth()*0.01*5
                                    self.caster:Heal(hp, self)
                                    SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,hp, nil)
                              end
                              if self.caster:TG_HasTalent("special_bonus_pudge_1") then
                                    if not  Is_Chinese_TG(hTarget,self.caster) then
                                          local damageTable={
                                                victim = hTarget,
                                                attacker = self.caster,
                                                damage_type = DAMAGE_TYPE_MAGICAL,
                                                damage = 300,
                                                ability = self,
                                          }
                                          ApplyDamage(damageTable)
                                    end
                              end
                              Timers:CreateTimer(kv.hs*2, function()
                                    ParticleManager:SetParticleControlEnt( fx, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", tpos , true )
                                    ParticleManager:SetParticleControl( fx, 4, Vector( 0, 0, 0 ) )
                                    ParticleManager:SetParticleControl( fx, 5, Vector( 1, 0, 0 ) )
                                    if fx then
                                          ParticleManager:DestroyParticle( fx, false )
                                          ParticleManager:ReleaseParticleIndex(  fx )
                                    end
                                    EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                                    return nil
                              end)
                  end
      else
                 self:HookEnd(vLocation,fx,kv.hs)
	end
end
function flesh_heap:HookEnd(vLocation,fx,hs)
                  ParticleManager:SetParticleControlEnt( fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true);
                 	ParticleManager:SetParticleControl( fx, 4, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( fx, 5, Vector( 1, 0, 0 ) )
                  Timers:CreateTimer(hs, function()
                        if fx then
                              ParticleManager:DestroyParticle( fx, false )
                              ParticleManager:ReleaseParticleIndex(  fx )
                        end
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                        return nil
                  end)
end
function flesh_heap:GetIntrinsicModifierName() return "modifier_flesh_heap_pa" end

modifier_flesh_heap_pa=class({})
function modifier_flesh_heap_pa:IsPurgable()return false
end
function modifier_flesh_heap_pa:IsPurgeException()return false
end
function modifier_flesh_heap_pa:IsHidden()return false
end
function modifier_flesh_heap_pa:DeclareFunctions()
      return
      {
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
            MODIFIER_PROPERTY_MODEL_SCALE,
            MODIFIER_EVENT_ON_DAMAGE_CALCULATED
      }
end
function modifier_flesh_heap_pa:OnCreated()
      self.ability=self:GetAbility()
	self.parent=self:GetParent()
      self.caster=self:GetCaster()
      if not self.ability then
            return
      end
	self.magic_resistance=self.ability:GetSpecialValueFor("magic_resistance")
	self.flesh_heap_strength_buff_amount=self.ability:GetSpecialValueFor("flesh_heap_strength_buff_amount")
      if IsServer() then
		self:SetStackCount(self.ability.stack)
	end
end
function modifier_flesh_heap_pa:OnRefresh()
      self.ability=self:GetAbility()
	self.parent=self:GetParent()
      self.caster=self:GetCaster()
      if not self.ability then
            return
      end
	self.flesh_heap_strength_buff_amount=self.ability:GetSpecialValueFor("flesh_heap_strength_buff_amount")
end
function modifier_flesh_heap_pa:GetModifierBonusStats_Strength()
      return self.parent:PassivesDisabled() and 0 or self:GetStackCount()*self.flesh_heap_strength_buff_amount
end
function modifier_flesh_heap_pa:GetModifierMagicalResistanceBonus()
      return  self.magic_resistance
end
function modifier_flesh_heap_pa:GetModifierModelScale()
	return self.ability:GetLevel()*10
end
function modifier_flesh_heap_pa:OnDamageCalculated(tg)
	if IsServer() then
            if tg.target==self.parent and not self.parent:IsIllusion() and self.parent:GetHealth()<=600 and not self.parent:IsInvulnerable() then
                  if self.caster:TG_HasTalent("special_bonus_pudge_7") and not  self.caster:HasModifier("modifier_flesh_heap_cd")     then
                         self.caster:AddNewModifier( self.caster, self.ability, "modifier_flesh_heap_cd", {duration=100})
                         self.caster:AddNewModifier( self.caster, self.ability, "modifier_flesh_heap_buff", {duration=6})
                  end
            end
	end
end


modifier_flesh_heap_hook_move=class({})
function modifier_flesh_heap_hook_move:IsDebuff()return true
end
function modifier_flesh_heap_hook_move:IsPurgable()return false
end
function modifier_flesh_heap_hook_move:IsPurgeException()return false
end
function modifier_flesh_heap_hook_move:RemoveOnDeath()return false
end
function modifier_flesh_heap_hook_move:GetMotionPriority()return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_flesh_heap_hook_move:OnCreated( tg )
      self.ability=self:GetAbility()
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.team=self.parent:GetTeamNumber()
       self.sp=self.ability:GetSpecialValueFor("hook_speed")
	if IsServer() then
            self.FX=tg.fx
            self.POS=Vector(tg.x,tg.y,tg.z)
            if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
            self:StartIntervalThink(FrameTime())
	end
end
function modifier_flesh_heap_hook_move:CheckState()
	return
      {
		[MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_PROVIDES_VISION] = true,

	}
end
function modifier_flesh_heap_hook_move:DeclareFunctions()
	return
       {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_flesh_heap_hook_move:GetOverrideAnimation( )
	return ACT_DOTA_FLAIL
end
function modifier_flesh_heap_hook_move:GetModifierProvidesFOWVision( )
	return 1
end
function modifier_flesh_heap_hook_move:OnIntervalThink( )
                        if IsValidEntity(self.caster) and IsValidEntity(self.parent) then
                              local pos = (self.POS-self.parent:GetAbsOrigin())
                              self.parent:SetAbsOrigin( self.parent:GetAbsOrigin() +pos:Normalized()* ((self.sp+600) / (1.0 / FrameTime())) )
                              if   pos:Length2D() < 150 then
                                          FindClearSpaceForUnit(self.parent,self.parent:GetAbsOrigin(), false )
                                          self:Destroy()
                                          return
                              end
                        end
end
function modifier_flesh_heap_hook_move:UpdateHorizontalMotion( me, dt )
end
function modifier_flesh_heap_hook_move:OnHorizontalMotionInterrupted()
	if IsServer() then
                  if self.FX then
			      ParticleManager:SetParticleControlEnt( self.FX, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
			end
                  self:Destroy()
	end
end
function modifier_flesh_heap_hook_move:OnDestroy()
	if IsServer() then
                        self.parent:RemoveHorizontalMotionController(self)
                        StopSoundOn( "Hero_Pudge.AttackHookRetract", self.parent )
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                        self:SetDuration(0,true)
	end
end
modifier_flesh_heap_buff=class({})
function modifier_flesh_heap_buff:IsPurgable()return false
end
function modifier_flesh_heap_buff:IsPurgeException()return false
end
function modifier_flesh_heap_buff:GetStatusEffectName()return "particles/tgp/pudge/status_effect_jason.vpcf"
end
function modifier_flesh_heap_buff:StatusEffectPriority()return 4
end
function modifier_flesh_heap_buff:GetEffectAttachType()return PATTACH_OVERHEAD_FOLLOW
end
function modifier_flesh_heap_buff:GetEffectName()return "particles/units/heroes/hero_pudge/pudge_swallow.vpcf"
end
function modifier_flesh_heap_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_MIN_HEALTH ,
                MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function modifier_flesh_heap_buff:GetDisableHealing()return 1
end
function modifier_flesh_heap_buff:GetMinHealth()return 1
end
function modifier_flesh_heap_buff:GetAbsoluteNoDamageMagical()return 1
end
function modifier_flesh_heap_buff:GetAbsoluteNoDamagePhysical()return 1
end
function modifier_flesh_heap_buff:GetAbsoluteNoDamagePure()return 1
end


modifier_flesh_heap_cd=class({})
function modifier_flesh_heap_cd:IsHidden()return false
end
function modifier_flesh_heap_cd:IsPurgable()return false
end
function modifier_flesh_heap_cd:IsPurgeException()return false
end
function modifier_flesh_heap_cd:RemoveOnDeath()return false
end