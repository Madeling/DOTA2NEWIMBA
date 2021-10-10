CreateTalents("npc_dota_hero_pudge", "heros/hero_pudge/meat_hook.lua")
meat_hook=class({})
LinkLuaModifier("modifier_meat_hook_move", "heros/hero_pudge/meat_hook.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_meat_hook_stack", "heros/hero_pudge/meat_hook.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function meat_hook:IsHiddenWhenStolen()return false
end
function meat_hook:IsStealable() return true
end
function meat_hook:IsRefreshable()return true
end
function meat_hook:Init()
      self.caster=self:GetCaster()
end
function meat_hook:GetCooldown(iLevel)
      if self.caster:HasScepter() then
            return self.BaseClass.GetCooldown(self,iLevel)-self:GetSpecialValueFor("acd")
      end
             return self.BaseClass.GetCooldown(self,iLevel)
end
function meat_hook:GetCastRange(vLocation, hTarget)
	return  self.BaseClass.GetCastRange( self, vLocation, hTarget )+ self.caster:GetModifierStackCount("modifier_meat_hook_stack", self.caster)
end
function meat_hook:OnAbilityPhaseStart()
	self.caster:StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end
function meat_hook:OnAbilityPhaseInterrupted()
	self.caster:RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end
function meat_hook:OnOwnerDied()
	self.caster:RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	self.caster:RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 )
end
function meat_hook:OnSpellStart()
      self.sp=self:GetSpecialValueFor("hook_speed")
      self.sp1=self:GetSpecialValueFor("hook_speed1")
      self.dmg=self:GetSpecialValueFor("dmg")*0.01
      self.damage=self:GetSpecialValueFor("damage")
      self.wh=self:GetSpecialValueFor("hook_width")
      self.dis=self:GetSpecialValueFor("hook_distance")
      self.vision_radius=self:GetSpecialValueFor("vision_radius")
      self.auto=false
      if self.caster and self.caster:IsHero() then
		local hHook = self.caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if hHook ~= nil then
			hHook:AddEffects( EF_NODRAW )
		end
	end
      if self:GetAutoCastState() then
            self.auto=true
            self:StartCooldown(10)
      end
      local angle,stack,num,hooksp=0,0,0,0
      stack=stack+self.caster:GetModifierStackCount("modifier_meat_hook_stack", self.caster)
      num=self.auto and 3 or 1
      angle=self.auto and -30 or 0
      hooksp=self.auto and self.sp1 or  self.sp
      for a=1, num do
            local cpos=self.caster:GetAbsOrigin()
            local epos=self:GetCursorPosition()
            local dir=(epos - cpos):Normalized() dir.z = 0.0
            local pos=RotatePosition(cpos, QAngle(0, angle, 0), cpos + dir * 1000)
            local dir1=(pos - cpos):Normalized() dir1.z = 0.0
            local dis1=stack+self.dis+self.caster:GetCastRangeBonus()
            local tpos=cpos + dir1* dis1
            local fx=ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
            ParticleManager:SetParticleAlwaysSimulate( fx )
            ParticleManager:SetParticleControlEnt( fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", cpos+Vector( 0, 0, 96 ), true )
            ParticleManager:SetParticleControl( fx, 1, tpos)
            ParticleManager:SetParticleControl( fx, 2, Vector( hooksp, dis1, self.wh ) )
            ParticleManager:SetParticleControl( fx, 3, Vector( ( ( dis1 / hooksp ) * 2 ), 0, 0 ) )
            ParticleManager:SetParticleControl( fx, 4, Vector( 1, 0, 0 ) )
            ParticleManager:SetParticleControl( fx, 5, Vector( 0, 0, 0 ) )
            ParticleManager:SetParticleControlEnt( fx, 7, self.caste, PATTACH_CUSTOMORIGIN, nil, cpos, true )
            EmitSoundOn( "Hero_Pudge.AttackHookExtend", self.caster )
            local PP =
            {
                  Ability = self,
                  vSpawnOrigin =cpos ,
                  vVelocity = dir1 * hooksp,
                  fDistance = dis1,
                  fStartRadius = self.wh ,
                  fEndRadius = self.wh ,
                  Source =self.caster,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE ,
                  bVisibleToEnemies = true,
                  bProvidesVision = true,
                  iVisionRadius = self.vision_radius,
                  iVisionTeamNumber = self.caster:GetTeamNumber(),
                  ExtraData={hs=hooksp,fx=fx ,hook=a,dmg=num>1 and self.dmg*self.damage or self.damage  }
            }
            ProjectileManager:CreateLinearProjectile( PP )
            angle=angle+30
      end
end

function meat_hook:OnProjectileHit_ExtraData( hTarget, vLocation,kv )
      if hTarget~=nil and (  hTarget == self.caster or  ( (hTarget:IsBoss() or hTarget:IsCreep() ) and Is_Chinese_TG(hTarget,self.caster) ) ) or kv.fx==nil  then
		return false
	end
      local fx=kv.fx
      local cpos=self.caster:GetAbsOrigin()
	if hTarget    then
                  if hTarget:HasModifier("modifier_fountain_aura_buff") or (self:GetAutoCastState() and hTarget:IsMagicImmune()) then
                        	return false
                  else
                        local tpos=hTarget:GetAbsOrigin()
                        hTarget:InterruptMotionControllers(true)
                        if hTarget:HasModifier("modifier_meat_hook_move") then
                                    hTarget:RemoveModifierByName("modifier_meat_hook_move")
                        end
                        if hTarget:IsRealHero() and not Is_Chinese_TG(hTarget,self.caster) then
                              local rg=self.caster:GetModifierStackCount("modifier_meat_hook_stack", self.caster)
                              if ( rg+self:GetSpecialValueFor("hook_distance"))<self:GetSpecialValueFor("hook_max") then
                                    self.caster:SetModifierStackCount("modifier_meat_hook_stack",self.caster,rg+self:GetSpecialValueFor("hook_rg") )
                              end
                        end
                              if hTarget:IsHero() and self.caster:HasScepter() then
                                    local hp=self.caster:GetMaxHealth()*0.01*self:GetSpecialValueFor("heal")
                                    self.caster:Heal(hp, self)
                                    SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,hp, nil)
                              end
                              EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
                              EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )
                              hTarget:AddNewModifier( self.caster, self, "modifier_meat_hook_move", {fx=fx} )
                              ParticleManager:SetParticleControlEnt( fx, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", tpos+Vector( 0, 0, 96 ) , true )
                              ParticleManager:SetParticleControl( fx, 4, Vector( 0, 0, 0 ) )
                              ParticleManager:SetParticleControl( fx, 5, Vector( 1, 0, 0 ) )
                              if  (hTarget:GetTeamNumber() ~= self.caster:GetTeamNumber() ) then
                                    local damageTable={
                                          victim = hTarget,
                                          attacker = self.caster,
                                          damage_type = DAMAGE_TYPE_PURE,
                                          damage = kv.dmg,
                                          ability = self,
                                    }
                                    ApplyDamage(damageTable)
                                    if not hTarget or not IsValidEntity(hTarget) or not hTarget:IsAlive() then
                                          self:HookEnd(vLocation,fx,kv.hs)
                                    end
                              end
                  end
      else
                 self:HookEnd(vLocation,fx,kv.hs)
	end
      if self.caster :IsAlive() then
			self.caster :RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
			self.caster :StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 )
	end
	            return true
end
function meat_hook:GetIntrinsicModifierName() return "modifier_meat_hook_stack" end

function meat_hook:HookEnd(vLocation,fx,hs)
                  ParticleManager:SetParticleControlEnt( fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self.caster:GetAbsOrigin()+Vector( 0, 0, 96 ), true);
                 	ParticleManager:SetParticleControl( fx, 4, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( fx, 5, Vector( 1, 0, 0 ) )
                  Timers:CreateTimer(TG_Distance(self.caster:GetAbsOrigin(),vLocation)/hs*2, function()
                        if fx then
                              ParticleManager:DestroyParticle( fx, false )
                              ParticleManager:ReleaseParticleIndex(  fx )
                        end
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                       if self.caster and self.caster:IsHero() then
                              local hHook =self.caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
                              if hHook ~= nil then
                                    hHook:RemoveEffects( EF_NODRAW )
                              end
                        end
                        return nil
                  end)
end

modifier_meat_hook_move=class({})
function modifier_meat_hook_move:IsDebuff()return true
end
function modifier_meat_hook_move:IsPurgable()return false
end
function modifier_meat_hook_move:IsPurgeException()return false
end
function modifier_meat_hook_move:RemoveOnDeath()return false
end
function modifier_meat_hook_move:GetMotionPriority()return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_meat_hook_move:OnCreated( tg )
      self.ability=self:GetAbility()
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.team=self.parent:GetTeamNumber()
	if IsServer() then
            self.FX=tg.fx
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
            self:StartIntervalThink(FrameTime())
	end
end
function modifier_meat_hook_move:CheckState()
	return
      {
		[MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_PROVIDES_VISION] = true,

	}
end
function modifier_meat_hook_move:DeclareFunctions()
	return
       {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_meat_hook_move:GetOverrideAnimation( )
	return ACT_DOTA_FLAIL
end
function modifier_meat_hook_move:GetModifierProvidesFOWVision( )
	return 1
end
function modifier_meat_hook_move:OnIntervalThink( )
           if IsValidEntity(self.caster) and IsValidEntity(self.parent) then
                        local pos = (self.caster:GetAbsOrigin()-self.parent:GetAbsOrigin())
                        self.parent:SetAbsOrigin( self.parent:GetAbsOrigin() +pos:Normalized()* (self.ability.sp / (1.0 / FrameTime())) )
                        if   pos:Length2D() < 150 then
                              if self.FX then
                                    ParticleManager:DestroyParticle( self.FX, true )
                                    ParticleManager:ReleaseParticleIndex(self.FX)
                              end
                                    FindClearSpaceForUnit(self.parent,self.parent:GetAbsOrigin(), false )
                                    self:Destroy()
                                    return
                        end
            end
end
function modifier_meat_hook_move:UpdateHorizontalMotion( me, dt )
end
function modifier_meat_hook_move:OnHorizontalMotionInterrupted()
	if IsServer() then
                  if self.FX then
			      ParticleManager:SetParticleControlEnt( self.FX, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self.caster:GetAbsOrigin()+Vector( 0, 0, 96 ), true )
			end
                  self:Destroy()
	end
end
function modifier_meat_hook_move:OnDestroy()
	if IsServer() then
				self.parent:RemoveHorizontalMotionController(self)
                        if self.caster and self.caster:IsHero() then
                              local hHook =self.caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
                              if hHook ~= nil then
                                    hHook:RemoveEffects( EF_NODRAW )
                              end
                        end
                        StopSoundOn( "Hero_Pudge.AttackHookRetract", self.parent )
                        EmitSoundOn( "Hero_Pudge.AttackHookRetractStop",self.caster )
                        self:SetDuration(0,true)
	end
end


modifier_meat_hook_stack=class({})
function modifier_meat_hook_stack:IsPurgable()return false
end
function modifier_meat_hook_stack:IsPurgeException()return false
end
function modifier_meat_hook_stack:RemoveOnDeath()return false
end
function modifier_meat_hook_stack:IsPermanent()return true
end
function modifier_meat_hook_stack:IsHidden()return false
end
function modifier_meat_hook_stack:OnCreated()
      self.ability=self:GetAbility()
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.team=self.parent:GetTeamNumber()
      if IsServer() then
            self:SetStackCount(0)
      end
end
function modifier_meat_hook_stack:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_meat_hook_stack:OnDeath(tg)
	if IsServer() then
            if tg.unit==self.caster and not self.caster:IsIllusion() then
                  if self.caster:TG_HasTalent("special_bonus_pudge_8") then
                        local pudge=CreateUnitByName("npc_butcher", self.caster:GetAbsOrigin(), true, self.caster, self.caster, self.team)
                        pudge:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
                        pudge:AddNewModifier(self.caster, self, "modifier_kill", {duration=24})
                        local ab=pudge:FindAbilityByName("meat_hook")
                        if ab then
                              ab:SetLevel(4)
                        end
                        if self.caster:HasScepter() then
                              pudge:AddNewModifier(self.caster, self, "modifier_item_ultimate_scepter_consumed", {duration=24})
                        end
                  end
            end
	end
end
