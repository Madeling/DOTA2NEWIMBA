CreateTalents("npc_dota_hero_sven", "heros/hero_sven/storm_bolt.lua")
storm_bolt = class({})
LinkLuaModifier("modifier_storm_bolt_buff", "heros/hero_sven/storm_bolt.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_storm_bolt_buff2", "heros/hero_sven/storm_bolt.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function storm_bolt:IsHiddenWhenStolen()
    return false
end

function storm_bolt:IsStealable()
    return true
end

function storm_bolt:IsRefreshable()
    return true
end

function storm_bolt:GetAOERadius()
		return self:GetSpecialValueFor( "rd" )
end

function storm_bolt:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_sven_5") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function storm_bolt:GetCastRange()
	if IsServer() then
		if self:GetCaster():TG_HasTalent("special_bonus_sven_7") then
			return 99999
		else
			if self:GetAutoCastState() then
				return self:GetSpecialValueFor( "rg1" ) + self:GetSpecialValueFor( "rg2" )
			else
				return self:GetSpecialValueFor( "rg1" )
			end
		end
	end
end

function storm_bolt:OnAbilityPhaseStart()
	local caster=self:GetCaster()
	local offset = caster:GetAbsOrigin() + Vector( 0, 0, 1600 )
	local name= caster:GetUnitName()=="npc_dota_hero_sven" and "attach_sword" or  "attach_attack1"
	local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", PATTACH_CUSTOMORIGIN,caster )
	ParticleManager:SetParticleControlEnt( fx, 0, caster, PATTACH_POINT_FOLLOW, name,caster:GetAbsOrigin() , true )
	ParticleManager:SetParticleControl( fx, 1, offset )
	ParticleManager:ReleaseParticleIndex( fx )
	return true
end

function storm_bolt:OnSpellStart()
	local caster=self:GetCaster()
	local caster_pos=caster:GetAbsOrigin()
	local target=self:GetCursorTarget()
	local caster_team=caster:GetTeamNumber()
	local vrd = self:GetSpecialValueFor( "vrd" )
	local sp = caster:TG_HasTalent("special_bonus_sven_7") and 3000 or self:GetSpecialValueFor( "sp" )
	caster.storm_bolt_distance = TG_Distance(caster_pos,target:GetAbsOrigin())>1500 and true or false
	if self:GetAutoCastState() then
		caster.storm_boltfly=false
		caster:AddNewModifier(caster, self, "modifier_storm_bolt_buff", {target=target:entindex()})
	end
	local P = {
			Ability = self,
			EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
			iMoveSpeed = sp,
			Source =caster,
			Target = target,
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bProvidesVision = true,
			bReplaceExisting = false,
			iVisionTeamNumber =caster_team,
			iVisionRadius = vrd,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		}
		TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
		EmitSoundOn( "Hero_Sven.StormBolt", caster)

end


function storm_bolt:OnProjectileHit_ExtraData( target, location,kv)
	local caster=self:GetCaster()
	caster.storm_boltfly=true
	if target == nil  then
		return
	end
    if  target:TG_TriggerSpellAbsorb(self) then
        return
    end
	if self:GetCaster():TG_HasTalent("special_bonus_sven_2") then
		caster:AddNewModifier( caster, self, "modifier_storm_bolt_buff2", { duration = 1 } )
	end
		EmitSoundOn( "Hero_Sven.StormBoltImpact", target )
		local rd = self:GetSpecialValueFor( "rd" )
		local dam = self:GetSpecialValueFor( "dam" )
		local stun = self:GetSpecialValueFor( "stun" )
		local heros = FindUnitsInRadius(
			caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			target,
			rd,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false )
		if #heros > 0 then
			for _,hero in pairs(heros) do
				if not hero:IsMagicImmune() then
					if caster.storm_bolt_distance==false then
						hero:AddNewModifier_RS( caster, self, "modifier_stunned", { duration = stun } )
						if caster:HasScepter() then
							caster:PerformAttack(hero, true, true, true, false, true, false, true)
						end
					end
					if caster:Has_Aghanims_Shard() then
						hero:Purge(true, false, false, false, false)
					end
					local damage = {
						victim = hero,
						attacker = caster,
						damage = dam,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}
					ApplyDamage( damage )
				end
			end
		end
end



modifier_storm_bolt_buff=class({})

function modifier_storm_bolt_buff:IsHidden()
	return true
end

function modifier_storm_bolt_buff:IsPurgable()
	return false
end

function modifier_storm_bolt_buff:IsPurgeException()
	return false
end

function modifier_storm_bolt_buff:GetPriority()
    return MODIFIER_PRIORITY_HIGH
end

function modifier_storm_bolt_buff:GetMotionPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
 end

function modifier_storm_bolt_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
	if self:GetCaster():TG_HasTalent("special_bonus_sven_7") then
		local fx = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_d.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle( fx, false, false, 1, false, true )
	end
		self.sp=self:GetParent():TG_HasTalent("special_bonus_sven_7") and 3000 or 1600
		self.team=self:GetParent():GetTeamNumber()
    	self.Target=EntIndexToHScript(tg.target)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
end

function modifier_storm_bolt_buff:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
	end
	if self:GetParent().storm_boltfly==true then
		self:Destroy()
		return
	end
	self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	local pos=self:GetParent():GetAbsOrigin()
	local dir=TG_Direction(self.Target:GetAbsOrigin(),pos)
    	self:GetParent():SetAbsOrigin(pos+dir* (self.sp / (1.0 / FrameTime())))
	if self:GetParent():TG_HasTalent("special_bonus_sven_1") then
		local heros = FindUnitsInRadius(
			self.team,
			pos,
			self:GetParent(),
			300,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false )
		if #heros > 0 then
			for _,hero in pairs(heros) do
				if not hero:IsMagicImmune() and not hero:HasModifier("modifier_stunned") then
					hero:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = 1 } )
				end
			end
		end
	end
end

function modifier_storm_bolt_buff:OnHorizontalMotionInterrupted()
	if not IsServer() then
		return
	end
	self:Destroy()
end


function modifier_storm_bolt_buff:OnDestroy()
    if  IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		self:GetParent():RemoveHorizontalMotionController(self)
    end
end


function modifier_storm_bolt_buff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_ORDER,
    }
end


function modifier_storm_bolt_buff:GetModifierDisableTurning()
    return 1
end

function modifier_storm_bolt_buff:OnOrder(tg)
	if not IsServer() then
		return
	end
	if tg.unit==self:GetParent()  then
		if  tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self:Destroy()
		end
	end
end

function modifier_storm_bolt_buff:CheckState()
	return
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end

modifier_storm_bolt_buff2=class({})

function modifier_storm_bolt_buff2:IsHidden()
	return false
end

function modifier_storm_bolt_buff2:IsPurgable()
	return false
end

function modifier_storm_bolt_buff2:IsPurgeException()
	return false
end

function modifier_storm_bolt_buff2:OnCreated()
	if IsServer() then
		local fx  = ParticleManager:CreateParticle( "particles/heros/axe/axe_bkb.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetCaster())
		self:AddParticle(fx, false, false, 20, false, false)
	end
end

function modifier_storm_bolt_buff2:CheckState()
	return
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end