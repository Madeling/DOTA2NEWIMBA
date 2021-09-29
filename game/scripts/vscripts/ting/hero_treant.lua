CreateTalents("npc_dota_hero_treant", "ting/hero_treant")
--自然卷握
imba_treant_natures_grasp = class({})
LinkLuaModifier("modifier_imba_treant_natures_grasp_flag", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_debuff", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_slow", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_pa", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_root", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)


function imba_treant_natures_grasp:IsHiddenWhenStolen() 
    return false 
end

function imba_treant_natures_grasp:IsStealable() 
    return true 
end

function imba_treant_natures_grasp:IsRefreshable() 			
    return true 
end

function imba_treant_natures_grasp:OnSpellStart()
    local caster = self:GetCaster()
    local cpos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
    local team = caster:GetTeamNumber()
    local dir=TG_Direction(pos,cpos)
    local dur = self:GetSpecialValueFor("vines_duration")
	local next_pos = GetGroundPosition(caster:GetAbsOrigin() + dir * 250, caster)
	local count_max = math.floor((self:GetSpecialValueFor("range")+self:GetCaster():GetCastRangeBonus()) /250)
    CreateModifierThinker(caster, self, "modifier_imba_treant_natures_grasp_debuff", {duration=dur+count_max*0.02,dir_x = dir.x,dir_y = dir.y,dir_z = dir.z,count = 0}, next_pos, team, false)
	if caster:FindAbilityByName("imba_treant_overgrowth") then
		caster:AddNewModifier(caster,self,"modifier_imba_treant_overgrowth_pa",{duration = dur})
	end


end
modifier_imba_treant_natures_grasp_debuff=class({})
LinkLuaModifier("modifier_imba_treant_natures_grasp_debuff", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_flag", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_slow", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_treant_natures_grasp_debuff:IsPurgable() 			
    return false
end

function modifier_imba_treant_natures_grasp_debuff:IsPurgeException() 		
    return false 
end

function modifier_imba_treant_natures_grasp_debuff:IsHidden()				
    return true 
end

function modifier_imba_treant_natures_grasp_debuff:OnCreated(keys)	
    self.parent=self:GetParent()	
    self.caster=self:GetCaster()	
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()	
    self.stpos=self.parent:GetAbsOrigin()	
    self.damage= self:GetAbility():GetSpecialValueFor("damage")*0.5
	self.dir = Vector(keys.dir_x,keys.dir_y,keys.dir_z)
	self.count_max = math.floor((self.ability:GetSpecialValueFor("range")+self:GetCaster():GetCastRangeBonus()) /250)
	self.tree = keys.tree 
	self.dur = self:GetAbility():GetSpecialValueFor("vines_duration")
	self.isovergrowth  = keys.overgrowth
	self.ab = self.caster:FindAbilityByName("imba_treant_overgrowth") 
	if IsServer() then
       	self.bramble_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_bramble_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.bramble_particle, 0, Vector(0, 0, 0))
		self:AddParticle(self.bramble_particle, false, false, -1, false, false)
        EmitSoundOn("hero_jakiro.imba_treant_natures_grasp", self.parent)
		if self.isovergrowth~=nil and self.isovergrowth == 1  then 			
			return
		end
		local next_pos =  GetGroundPosition(self:GetParent():GetAbsOrigin() + self.dir  * 250, self:GetParent())
		if GridNav:IsNearbyTree(self.stpos,250, true) then
			self.tree = 1
		end
		local count = keys.count + 1
		local dir = Vector(keys.dir_x,keys.dir_y,keys.dir_z)
        self.damageTable = {
            attacker = self.caster,
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
        }
        self.root=true
	
	
		if count < self.count_max then
				Timers:CreateTimer(0.02, function()
		local thinker = CreateModifierThinker(self.caster, self:GetAbility(), "modifier_imba_treant_natures_grasp_debuff", {duration=self.dur+(self.count_max-count)*0.02,dir_x = dir.x,dir_y = dir.y,dir_z = dir.z,count = count , tree = self.tree}, next_pos, self.caster:GetTeamNumber(), false)
		thinker:EmitSound("Hero_Treant.NaturesGrasp.Spawn")
		end)
		end
		if count == self.count_max then
			self.max = true
			self:OnIntervalThink()	
			self:StartIntervalThink(0.5)		
		end
    end
end

function modifier_imba_treant_natures_grasp_debuff:OnIntervalThink()	
	if not IsServer() then return end
	if self.tree == 1 then
		self.damageTable.damage = self.damage*self:GetAbility():GetSpecialValueFor("damage_ex")
	end
	local pos_start = self.stpos + self.dir*-75
	local pos_end = self.stpos + self.dir*-250*(self.count_max-1)
	local root = false
	if self.ab then
		if self.caster:HasScepter() and self.ab:GetLevel() > 0 then
			local cas = FindUnitsInLine(
			self.team,
			pos_start,
			pos_end, 
			self.parent,
			225, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_NONE)
		for _,unit in pairs(cas) do
				unit:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_natures_grasp_flag",{duration = 0.5})		
		end
		end
	end
	
    local heros = FindUnitsInLine(
        self.team,
        pos_start,
		pos_end, 
        self.parent,
        225, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE)
        if heros and #heros>0 then
            for _,target in pairs(heros) do
					if self.caster:HasModifier("modifier_imba_treant_natures_grasp_flag") then
						--target:AddNewModifier(self.caster,self:GetAbility(),"modifier_rooted",{duration = 0.6})
						target:AddNewModifier(self.caster,self.ab,"modifier_imba_treant_overgrowth_root",{duration = 0.6})
					end
					target:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_natures_grasp_slow",{duration = 0.6})
                    self.damageTable.victim = target
                    ApplyDamage(self.damageTable)
            end
        end
end



modifier_imba_treant_natures_grasp_flag = class({})
function modifier_imba_treant_natures_grasp_flag:IsDebuff()			return false end
function modifier_imba_treant_natures_grasp_flag:IsHidden() 			return true end
function modifier_imba_treant_natures_grasp_flag:IsPurgable() 			return false end
function modifier_imba_treant_natures_grasp_flag:IsPurgeException() 	return false end

modifier_imba_treant_natures_grasp_slow = class({})
function modifier_imba_treant_natures_grasp_slow:IsDebuff()			return true end
function modifier_imba_treant_natures_grasp_slow:IsHidden() 			return true end
function modifier_imba_treant_natures_grasp_slow:IsPurgable() 			return true end
function modifier_imba_treant_natures_grasp_slow:CheckState()
	return
	{
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = true,
        [MODIFIER_STATE_TETHERED] = true,
	}
end
function modifier_imba_treant_natures_grasp_slow:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		}
end
function modifier_imba_treant_natures_grasp_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end

function modifier_imba_treant_natures_grasp_slow:OnCreated()
	self.move = self:GetAbility():GetSpecialValueFor("movement_slow")*-1
end


--寄生种子
imba_treant_leech_seed = class({})
LinkLuaModifier("modifier_imba_treant_leech_seed_debuff", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function imba_treant_leech_seed:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	target:AddNewModifier_RS(caster,self,"modifier_imba_treant_leech_seed_debuff",{duration = self:GetSpecialValueFor("duration")})

	self:GetCaster():EmitSound("Hero_Treant.LeechSeed.Target")
end
function imba_treant_leech_seed:OnProjectileHit_ExtraData(target, location, ExtraData)
	target:Heal(self:GetSpecialValueFor("heal"), self:GetCaster())
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target,self:GetSpecialValueFor("heal"), nil)
end
modifier_imba_treant_leech_seed_debuff = class({})
function modifier_imba_treant_leech_seed_debuff:IsDebuff()			return true end
function modifier_imba_treant_leech_seed_debuff:IsHidden() 			return false end
function modifier_imba_treant_leech_seed_debuff:IsPurgable() 			return not self:GetCaster():TG_HasTalent("special_bonus_imba_treant_6") end
function modifier_imba_treant_leech_seed_debuff:RemoveOnDeath()			return false end
function modifier_imba_treant_leech_seed_debuff:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_treant_leech_seed_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end
function modifier_imba_treant_leech_seed_debuff:OnCreated()
	self.move = self:GetAbility():GetSpecialValueFor("movement_slow")
	if not IsServer() then return end
	self:OnIntervalThink()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("damage_interval"))
end
function modifier_imba_treant_leech_seed_debuff:OnIntervalThink()
	if not IsServer() then  return end
	self:GetParent():EmitSound("Hero_Treant.LeechSeed.Tick")
	local damage = self:GetAbility():GetSpecialValueFor("leech_damage")
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	if self:GetParent():IsHero() then
		local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetOrigin(),radius , false )
		damage = self:GetAbility():GetSpecialValueFor("leech_damage") + #trees*self:GetParent():GetHealth()*0.01*self:GetAbility():GetSpecialValueFor("heal_tree")
	end	
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
	particle = nil
		if self:GetParent():IsAlive() then
		ApplyDamage({
			victim 			= self:GetParent(),
			damage 			= damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
		end


	self.friend = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	 for _,fri in pairs(self.friend) do      

			
			local projectile = {
			EffectName			= "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
			Ability				= self:GetAbility(),
			Source				= self:GetParent(),
			vSourceLoc			= fri:GetAbsOrigin(),
			Target				= fri,
			iMoveSpeed			= self:GetAbility():GetSpecialValueFor("projectile_speed"),
			flExpireTime		= nil,
			bDodgeable			= false,
			bIsAttack			= false,
			bReplaceExisting	= false,
			iSourceAttachment	= nil,
			bDrawsOnMinimap		= nil,
			bVisibleToEnemies	= true,
			bProvidesVision		= false,
			iVisionRadius		= nil,
			iVisionTeamNumber	= nil,
			ExtraData			= {}
		}
			ProjectileManager:CreateTrackingProjectile(projectile)
        end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_treant_6") and self:GetParent():IsMagicImmune() then
		self:SetDuration(self:GetRemainingTime() + 1, true)
	end
end

function modifier_imba_treant_leech_seed_debuff:OnDeath(keys)	
	if not IsServer() then return end
	if not keys.unit:IsHero() then return end
	if keys.unit == self:GetParent() and self:GetParent():HasModifier("modifier_imba_treant_leech_seed_debuff") then
	local ab = self:GetCaster():FindAbilityByName("imba_treant_living_armor")
		CreateTempTree(keys.unit:GetAbsOrigin(), 1)
		CreateTempTreeWithModel(keys.unit:GetAbsOrigin(), 3,"models/props_tree/ti7/ggbranch.vmdl")
	if ab and ab:GetLevel() > 0 then
	local fr = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,f in pairs(fr) do
			f:AddNewModifier(self:GetCaster(),ab,"modifier_imba_treant_living_armor_buff",{duration = ab:GetSpecialValueFor("duration")})
		end
	end
	end
end
--活体护甲
imba_treant_living_armor = class({})
LinkLuaModifier("modifier_imba_treant_living_armor_buff", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_living_armor_tran", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)

function imba_treant_living_armor:OnChannelFinish(b)
	if IsServer() then	
		if self.pos~=nil and not b then
		FindClearSpaceForUnit(self:GetCaster(), self.pos, true)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex( pfx )
		self:addarmor(self:GetCaster())
		self:GetCaster():EmitSound("Hero_Treant.LeechSeed.Tick")
		end
	end
end
function imba_treant_living_armor:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
		if self:GetCursorTarget() then
			self:addarmor(self:GetCursorTarget())
			caster:Stop()
		else
			local tran = Entities:FindAllInSphere(pos, 200)
			for _,tr in pairs(tran) do
				if tr:GetName() == "npc_dota_treant_eyes" then
				self.pos = tr:GetAbsOrigin()
				return
				end
			end
			local target0 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #target0 >= 1 then
				self:addarmor(target0[1])
				caster:Stop()
				return 
			end
			local target1 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #target1 >= 1 then
				self:addarmor(target1[1])
				caster:Stop()
				return 
			end
			local target2 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #target2 >= 1 then
				self:addarmor(target2[1])
				caster:Stop()
				return 
			end
			self:addarmor(caster)
			caster:Stop()
		end	
end
function imba_treant_living_armor:addarmor(target)
	if not IsServer() then return end
	local tar = target
	if self:GetCaster():TG_HasTalent("special_bonus_imba_treant_4") then		
		local radius = self:GetCaster():TG_GetTalentValue("special_bonus_imba_treant_4")
		if target~=nil then
			local fr = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,f in pairs(fr) do
				f:AddNewModifier(self:GetCaster(),self,"modifier_imba_treant_living_armor_buff",{duration = self:GetSpecialValueFor("duration")})
			end	
		end
		else
		tar:AddNewModifier(self:GetCaster(),self,"modifier_imba_treant_living_armor_buff",{duration = self:GetSpecialValueFor("duration")})
	end
	
end
modifier_imba_treant_living_armor_buff = class({})
function modifier_imba_treant_living_armor_buff:IsDebuff()			return not Is_Chinese_TG(self:GetParent(),self:GetCaster()) end
function modifier_imba_treant_living_armor_buff:IsHidden() 			return false end
function modifier_imba_treant_living_armor_buff:IsPurgable() 			return true end
function modifier_imba_treant_living_armor_buff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_treant_living_armor_buff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() + self.armor 
end

function modifier_imba_treant_living_armor_buff:OnCreated() 
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.heal = self:GetAbility():GetSpecialValueFor("total_heal")/self:GetAbility():GetSpecialValueFor("duration")/2
	if self:GetParent():IsHero() then
		self.heal = self.heal * self:GetAbility():GetSpecialValueFor("heal_hero")
	end
	self.damage_re = self:GetAbility():GetSpecialValueFor("damage_re")*-1
	if IsServer() then
	self.armor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.armor_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.armor_particle, false, false, -1, false, false)
	self:StartIntervalThink(0.5)
	self:OnRefresh()
	end	
end
function modifier_imba_treant_living_armor_buff:OnRefresh()
	if not IsServer() then return end
	if not self:GetParent():IsBuilding() then
	local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false )
	local heal = self:GetParent():GetMaxHealth()*0.01*#trees
	self:GetParent():Heal(heal, self:GetCaster())	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(),heal, nil)
		if self:GetCaster():TG_HasTalent("special_bonus_imba_treant_2") then 
		self:SetStackCount(#trees)
	end
	end
end
function modifier_imba_treant_living_armor_buff:OnIntervalThink()
	if not IsServer() then return end
		self:GetParent():Heal(self.heal, self:GetCaster())	
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(),self.heal, nil)
end
--疯狂生长
imba_treant_overgrowth = class({})
LinkLuaModifier("modifier_imba_treant_overgrowth_root", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_g", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_pa", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_damage", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)


function imba_treant_overgrowth:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Treant.Overgrowth.Cast")
	if caster:HasScepter() then --防止a失效 树木刷新时间
		GameRules:SetTreeRegrowTime(10)
	end
	local duration_overgrowth = self:GetSpecialValueFor("duration")
	local cast_particle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	local enemy_hero = FindUnitsInRadius(caster:GetTeamNumber(),
	caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)	
	
		for _,enemy in pairs(enemy_hero) do	
			if not self:GetAutoCastState() then
			enemy:Stop()
			enemy:AddNewModifier_RS(caster, self, "modifier_imba_treant_overgrowth_root", {duration = duration_overgrowth})	
			enemy:AddNewModifier_RS(caster, self, "modifier_imba_treant_overgrowth_damage", {duration = duration_overgrowth})	
			
			end

		end
	--自动大	
	if self:GetAutoCastState() then
			CreateModifierThinker(caster, self, "modifier_imba_treant_overgrowth", {duration = duration_overgrowth}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
			AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 1250, duration_overgrowth+1, false)	--1250高空视野
	
	--召树
	local tab = {
				"maps/jungle_assets/trees/kapok/export/kapok_001.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_002.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_003.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_004.vmdl",
				}
				
	for tr = 0,5,1 do 
	local newpos =RotatePosition(caster:GetAbsOrigin(), QAngle(0, tr*72, 0), caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * 600)
		for i = 1,5,1 do
			local pos_end = GetRandomPosition2D(newpos,600)			
			CreateTempTreeWithModel(pos_end, duration_overgrowth,tab[math.random(1,#tab)])
		end
	end	
	end
	--树眼大
	local gr = Entities:FindAllByName("npc_dota_treant_eyes")
	local ab_eye = caster:FindAbilityByName("imba_treant_eyes_in_the_forest")
	if ab_eye and ab_eye:GetLevel() > 0 then
	for _,g in pairs(gr) do	
		if g:IsAlive() and g:GetOwner() == self:GetCaster() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, g)
			ParticleManager:ReleaseParticleIndex(particle)
			local enemy_tree = FindUnitsInRadius(caster:GetTeamNumber(),
			g:GetAbsOrigin(), nil, ab_eye:GetSpecialValueFor("overgrowth_aoe_imba")+caster:TG_GetTalentValue("special_bonus_imba_treant_7"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)	
	
			for _,enemy in pairs(enemy_tree) do	
				enemy:Stop()
				enemy:AddNewModifier_RS(caster, self, "modifier_imba_treant_overgrowth_root", {duration = duration_overgrowth})	
				enemy:AddNewModifier_RS(caster, self, "modifier_imba_treant_overgrowth_damage", {duration = duration_overgrowth})	
			end
		end
	end
	end
	caster:AddNewModifier(caster,self,"modifier_imba_treant_overgrowth_pa",{duration = duration_overgrowth})
	
end
--大招召树thinker

modifier_imba_treant_overgrowth = class({})
LinkLuaModifier("modifier_imba_treant_overgrowth_g", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_flag", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_treant_overgrowth:IsHidden() 			return true end
function modifier_imba_treant_overgrowth:IsDebuff() 			return false end
function modifier_imba_treant_overgrowth:IsPurgable() 			return false end
function modifier_imba_treant_overgrowth:OnCreated(parms) 
	if not IsServer() then return end


	self.tab = {
				"maps/jungle_assets/trees/kapok/export/kapok_001.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_002.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_003.vmdl",
				"maps/jungle_assets/trees/kapok/export/kapok_004.vmdl",
				}
	self.caster = self:GetCaster()
	self.root = false
	local hero = FindUnitsInRadius(self.caster:GetTeamNumber(),
	self.caster:GetAbsOrigin(), nil, 1250, 
	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	for _,h in pairs(hero) do
		h:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_overgrowth_g",{duration = 1})
	end
	--召藤曼
	local ab = self.caster:FindAbilityByName("imba_treant_natures_grasp")
	if ab and ab:GetLevel()>0 then
	self.root_flag = true
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),1250, true) then
		self.damage = self.damage*ab:GetSpecialValueFor("damage_ex")
	end

      local particle2 = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(particle2, 1, Vector(1200, 0, 0))
        ParticleManager:SetParticleControl(particle2, 2, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 3, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 15, Vector(220, 20, 60))

	end	

	self:StartIntervalThink(1.0)
end
function modifier_imba_treant_overgrowth:OnIntervalThink()
	if not IsServer() then return end
	if (self:GetParent():GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() < 1200 then
		self.caster:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_natures_grasp_flag",{duration = 1.2})
		self.root = true
	end
	local hero = FindUnitsInRadius(self.caster:GetTeamNumber(),
	self:GetParent():GetAbsOrigin(), nil, 1200, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	for _,h in pairs(hero) do
		if Is_Chinese_TG(h,self.caster) then
		h:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_overgrowth_g",{duration = 1.1})
		else
			if self.root and self.root_flag then
		ApplyDamage({
			victim 			= h,
			damage 			= self.damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
				h:AddNewModifier(self.caster,self:GetAbility(),"modifier_rooted",{duration = 1.1})
			end
		end
	end		

	self.root = false

end


--穿树buff
modifier_imba_treant_overgrowth_g = class({})
function modifier_imba_treant_overgrowth_g:IsHidden() 			return true end
function modifier_imba_treant_overgrowth_g:IsDebuff() 			return false end
function modifier_imba_treant_overgrowth_g:IsPurgable() 			return false end
function modifier_imba_treant_overgrowth_g:IsPurgeException() 			return false end
function modifier_imba_treant_overgrowth_g:CheckState() 			return {[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,} end
--大缠绕
modifier_imba_treant_overgrowth_root = class({})
function modifier_imba_treant_overgrowth_root:IsHidden() 			return false end
function modifier_imba_treant_overgrowth_root:IsDebuff() 			return true end
function modifier_imba_treant_overgrowth_root:IsPurgable() 			return true end
function modifier_imba_treant_overgrowth_root:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_treant_overgrowth_root:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_treant_overgrowth_root:CheckState() 			
	return {
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = true,
        [MODIFIER_STATE_TETHERED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		} 
	end 	
function modifier_imba_treant_overgrowth_root:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

--大伤害
modifier_imba_treant_overgrowth_damage = class({})
function modifier_imba_treant_overgrowth_damage:IsHidden() 			return true end
function modifier_imba_treant_overgrowth_damage:IsDebuff() 			return true end
function modifier_imba_treant_overgrowth_damage:IsPurgable() 			return true end
function modifier_imba_treant_overgrowth_damage:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	if IsServer() then 
		self:StartIntervalThink(1.0)
	end
end
function modifier_imba_treant_overgrowth_damage:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({
			victim 			= self:GetParent(),
			damage 			= self.damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
end

--树眼
imba_treant_eyes_in_the_forest = class({})
LinkLuaModifier("modifier_imba_treant_eyes_in_the_forest", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_eyes_in_the_forest_passive", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function imba_treant_eyes_in_the_forest:GetIntrinsicModifierName() return "modifier_imba_treant_eyes_in_the_forest_passive" end
function imba_treant_eyes_in_the_forest:IsStealable() return false end
function imba_treant_eyes_in_the_forest:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():HasScepter() then 
       self:SetHidden(false)
	   self:SetStolen(true)
       self:SetLevel(1)
	   local ab = self:GetCaster():FindAbilityByName("treant_eyes_in_the_forest")
	   if ab then
		ab:SetHidden(true)
	   end
    else
			self:SetHidden(true)
			--self:SetLevel(0)
			self:SetStolen(true)
    end
end

function imba_treant_eyes_in_the_forest:OnSpellStart()
	local tar = self:GetCursorTarget()
	local pos = tar:GetAbsOrigin()	
	local caster = self:GetCaster()
	local tree = CreateUnitByName("npc_dota_treant_eyes", pos, false, self:GetCaster(), self:GetCaster(),caster:GetTeamNumber())
	tree:AddNewModifier(self:GetCaster(),self,"modifier_treant_eyes_in_the_forest",{duration = -1 })
	tree:AddNewModifier(self:GetCaster(),self,"modifier_imba_treant_eyes_in_the_forest",{duration = -1 ,pos_x = pos.x,pos_y = pos.y,po_z = pos.z})
	local mod = self:GetCaster():FindModifierByName("modifier_imba_treant_eyes_in_the_forest_passive")
	if mod then
		mod:SetStackCount(mod:GetStackCount() + 1 )
	table.insert(mod.tree,tree)
	local tre = {}
	for _,k in pairs(mod.tree) do
		if not k:IsNull() then
			table.insert(tre,k)
		end
	end
	mod.tree = tre
	if mod:GetStackCount() > self:GetSpecialValueFor("max")  then 
		mod.tree[1]:RemoveModifierByName("modifier_treant_eyes_in_the_forest")
		mod.tree[1]:RemoveModifierByName("modifier_imba_treant_eyes_in_the_forest")
		UTIL_Remove(mod.tree[1])
		mod:SetStackCount(mod:GetStackCount() - 1)
	end
	
	end
end
--树眼unit修饰器
modifier_imba_treant_eyes_in_the_forest = class({})
LinkLuaModifier("modifier_imba_treant_overgrowth_root", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_pa", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_damage", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_treant_eyes_in_the_forest:IsHidden() 			return true end
function modifier_imba_treant_eyes_in_the_forest:IsPurgable() 			return false end
function modifier_imba_treant_eyes_in_the_forest:IsPurgeException() 			return false end
function modifier_imba_treant_eyes_in_the_forest:DeclareFunctions() 	
	return {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL} 
end
function modifier_imba_treant_eyes_in_the_forest:GetBonusDayVision()
    return self:GetCaster():TG_GetTalentValue("special_bonus_imba_treant_7")
end
function modifier_imba_treant_eyes_in_the_forest:GetBonusNightVision() 
    return self:GetCaster():TG_GetTalentValue("special_bonus_imba_treant_7")
end

function modifier_imba_treant_eyes_in_the_forest:GetAbsoluteNoDamagePhysical() 
    return 1 
end

function modifier_imba_treant_eyes_in_the_forest:GetAbsoluteNoDamagePure() 
    return 1 
end
function modifier_imba_treant_eyes_in_the_forest:GetModifierInvisibilityLevel() return 1 end
function modifier_imba_treant_eyes_in_the_forest:CheckState()
	return {
			[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
			[MODIFIER_STATE_INVISIBLE] = true, 
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			}	
end

function modifier_imba_treant_eyes_in_the_forest:OnCreated(parms)
	if not IsServer() then return end
	self.mod = self:GetCaster():FindModifierByName("modifier_imba_treant_eyes_in_the_forest_passive")
	self.caster = self:GetCaster()
	self.pos = Vector(parms.pos_x,parms.pos_y,parms.pos_Z)
	self.duration = self:GetAbility():GetSpecialValueFor("duration_root")
	self.radius = self:GetAbility():GetSpecialValueFor("radius_root")
	if self.pos~=nil then
		self:GetParent():SetAbsOrigin(self.pos)
	end
	local parent = self:GetParent()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, parent, PATTACH_ABSORIGIN, nil, parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("vision_aoe_imba")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_treant_7"),0,0))
		self:AddParticle(self.pfx, false, false, 15, false, false)
	self:StartIntervalThink(0.5)	
end

function modifier_imba_treant_eyes_in_the_forest:OnIntervalThink()
	if not IsServer() then return end
	local tr = GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),40, true) 
	if not tr then
	local enemy_tree = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self:GetParent():GetAbsOrigin(), nil,self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)	
		
		UTIL_Remove(self:GetParent())
		self.mod:SetStackCount(self.mod:GetStackCount() - 1 )
		local ab = self:GetCaster():FindAbilityByName("imba_treant_overgrowth")
		if ab and ab:GetLevel() > 0 then
			for _,enemy in pairs(enemy_tree) do	
				enemy:Stop()
				enemy:AddNewModifier(self:GetCaster(), ab, "modifier_imba_treant_overgrowth_root", {duration = self.duration})	
				enemy:AddNewModifier(self:GetCaster(), ab, "modifier_imba_treant_overgrowth_damage", {duration = self.duration})	
			end
		end
		self.caster:AddNewModifier(self.caster,self:GetAbility(),"modifier_imba_treant_overgrowth_pa",{duration = self.duration})
	end
end
modifier_imba_treant_eyes_in_the_forest_passive = class({})
LinkLuaModifier("modifier_imba_treant_natures_guise_passive_inv", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_treant_eyes_in_the_forest_passive:IsHidden() 			return false end
function modifier_imba_treant_eyes_in_the_forest_passive:IsPurgable() 			return false end
function modifier_imba_treant_eyes_in_the_forest_passive:IsPurgeException() 			return false end
function modifier_imba_treant_eyes_in_the_forest_passive:RemoveOnDeath() 			return false end
function modifier_imba_treant_eyes_in_the_forest_passive:OnCreated()
	self.tree = {}
end
--自然庇护
imba_treant_natures_guise = class({})
LinkLuaModifier("modifier_imba_treant_natures_guise_passive_inv", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_guise_passive", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_guise_flag", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function imba_treant_natures_guise:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_treant_natures_guise_passive_inv") then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE  
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function imba_treant_natures_guise:OnSpellStart()
	for i=0,5 do 
		if self:GetCaster():GetItemInSlot(i) ~= nil then
			if self:GetCaster():HasModifier("modifier_item_radiance_v2") and self:GetCaster():GetItemInSlot(i):GetName() == "item_radiance_v2" then
				self:GetCaster():GetItemInSlot(i):OnToggle()
			end
		end
	end 
	
	if self:GetCaster():HasModifier("modifier_imba_leshrac_pulse_nova") then
		self:GetCaster():RemoveModifierByName("modifier_imba_leshrac_pulse_nova")
	end

	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_treant_natures_guise_flag",{duration = self:GetCooldownTimeRemaining()})
	self:GetCaster():EmitSound("Hero_Treant.NaturesGuise.On")	
end

function imba_treant_natures_guise:GetIntrinsicModifierName() return "modifier_imba_treant_natures_guise_passive" end

function imba_treant_natures_guise:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():Has_Aghanims_Shard() then 
       self:SetHidden(false)
	   self:SetStolen(true)
--	   self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
--			self:SetHidden(false)
			self:SetLevel(0)
			self:SetStolen(true)
    end
end
modifier_imba_treant_natures_guise_flag = class({})
function modifier_imba_treant_natures_guise_flag:IsDebuff()			return false end
function modifier_imba_treant_natures_guise_flag:IsHidden() 			return false end
function modifier_imba_treant_natures_guise_flag:IsPurgable() 			return false end
function modifier_imba_treant_natures_guise_flag:IsPurgeException() 	return false end
function modifier_imba_treant_natures_guise_flag:CheckState() return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true,} end
function modifier_imba_treant_natures_guise_flag:GetEffectName()	return "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf" end

modifier_imba_treant_natures_guise_passive = class({})
LinkLuaModifier("modifier_imba_treant_natures_guise_passive_inv", "ting/hero_treant", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_treant_natures_guise_passive:IsHidden() 			return true end
function modifier_imba_treant_natures_guise_passive:IsPurgable() 			return false end
function modifier_imba_treant_natures_guise_passive:IsPurgeException() 			return false end
function modifier_imba_treant_natures_guise_passive:RemoveOnDeath() 			return false end
function modifier_imba_treant_natures_guise_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_treant_natures_guise_passive:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1)
end
function modifier_imba_treant_natures_guise_passive:OnIntervalThink()
	if not IsServer() then return end
	if self:GetAbility():IsHidden() then
		return 
	end
	if not self:GetParent():IsAlive() then
		return 
	end
	if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),self:GetAbility():GetSpecialValueFor("radius"), true) and self:GetAbility():GetLevel() >0 then
			self:SetStackCount(math.min(self:GetStackCount()+1,2))
			else
			self:SetStackCount(0)
		
	end
	if self:GetStackCount()==2 then  
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_treant_natures_guise_passive_inv",{duration = -1})
		self:SetStackCount(0)
		self:StartIntervalThink(-1)
	end
end
function modifier_imba_treant_natures_guise_passive:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		if self:GetStackCount()~= 2 then 
			self:SetStackCount(0)		
			self:StartIntervalThink(1)
		end
	end
end

function modifier_imba_treant_natures_guise_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and  self:GetAbility():GetLevel() > 0 and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:IsRooted() then
		return self:GetAbility():GetSpecialValueFor("cri")
	end
end
function modifier_imba_treant_natures_guise_passive:OnTakeDamage(keys)
    if not IsServer() then
        return
	end  
	
    if keys.unit == self:GetParent() and self:GetStackCount()~=2 then
		self:SetStackCount(0)
		self:StartIntervalThink(1)
	end 
end  

modifier_imba_treant_natures_guise_passive_inv = class({})
function modifier_imba_treant_natures_guise_passive_inv:IsHidden() 			return false end
function modifier_imba_treant_natures_guise_passive_inv:IsPurgable() 			return false end
function modifier_imba_treant_natures_guise_passive_inv:IsPurgeException() 			return false end

function modifier_imba_treant_natures_guise_passive_inv:CheckState()
	local tab_a = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,}
	
	local tab_b = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		}
	local tab_c = {
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	
		}
	if self:GetParent():HasModifier("modifier_imba_treant_natures_guise_flag") then
			return tab_c 
	end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_treant_1") then
			return tab_b
	end
	return tab_a

end

function modifier_imba_treant_natures_guise_passive_inv:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,} 
end
function modifier_imba_treant_natures_guise_passive_inv:GetDisableAutoAttack() return true end	
function modifier_imba_treant_natures_guise_passive_inv:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_imba_treant_natures_guise_passive_inv:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_treant_natures_guise_passive_inv:GetModifierInvisibilityLevel() 
	return (self:GetParent():HasModifier("modifier_imba_treant_natures_guise_flag") or self:GetCaster():TG_HasTalent("special_bonus_imba_treant_1")) and 1 or 0 
end
function modifier_imba_treant_natures_guise_passive_inv:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_bonus
end


function modifier_imba_treant_natures_guise_passive_inv:GetModifierHealAmplify_PercentageTarget()
	return self.regen_amp
end

function modifier_imba_treant_natures_guise_passive_inv:GetModifierHPRegenAmplify_Percentage()
	return self.regen_amp
end

function modifier_imba_treant_natures_guise_passive_inv:OnCreated()
	self.movement_bonus = self:GetAbility():GetSpecialValueFor("movement_bonus")
	self.regen_amp = self:GetAbility():GetSpecialValueFor("regen_amp")
	if not IsServer() then  return end
	self.mod = self:GetParent():FindModifierByName("modifier_imba_treant_natures_guise_passive")
	self.near_tree = true
	self.caster = self:GetCaster()
	self.caster:EmitSound("Hero_Treant.NaturesGuise.On")
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_naturesguise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	self:StartIntervalThink(0.5)
end

function modifier_imba_treant_natures_guise_passive_inv:OnIntervalThink()
	if not IsServer() then return end
	if not GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),self:GetAbility():GetSpecialValueFor("radius"), true) then
		if self.near_tree then
			self:SetDuration(1, true) 
			self.near_tree = false
		end		
	else
		self:SetDuration(-1, true) 
		self.near_tree = true
	end	
	--天赋视野
	if self.caster:TG_HasTalent("special_bonus_imba_treant_8") then
		local vision = self:GetCaster():TG_GetTalentValue("special_bonus_imba_treant_8")
		AddFOWViewer(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), vision , 1, false)
	end
end

function modifier_imba_treant_natures_guise_passive_inv:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		local stun  = self:GetAbility():GetSpecialValueFor("stun") + keys.attacker:TG_GetTalentValue("special_bonus_imba_treant_5")
		keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_imba_stunned",{duration = stun})
		ApplyDamage({
			victim 			= keys.target,
			damage 			= self:GetAbility():GetSpecialValueFor("damage"),
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetParent(),
			ability 		= self:GetAbility()
		})
		if keys.attacker:TG_HasTalent("special_bonus_imba_treant_3") then
			keys.target:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_rooted",{duration = keys.attacker:TG_GetTalentValue("special_bonus_imba_treant_3")})		
		end
		keys.attacker:RemoveModifierByName("modifier_imba_treant_natures_guise_passive_inv")
	end
end
function modifier_imba_treant_natures_guise_passive_inv:OnDestroy()
	if not IsServer() then return end
	self.caster:RemoveModifierByName("modifier_imba_treant_natures_guise_flag")
	if self.mod  then
		self.caster:EmitSound("Hero_Treant.NaturesGuise.Off")
		self.mod:StartIntervalThink(1.0)
	end
end
--自然延申

modifier_imba_treant_overgrowth_pa = class({})
function modifier_imba_treant_overgrowth_pa:IsDebuff() return false end
function modifier_imba_treant_overgrowth_pa:IsHidden() return false end
function modifier_imba_treant_overgrowth_pa:IsPurgable() return false end
function modifier_imba_treant_overgrowth_pa:IsStunDebuff() return false end
function modifier_imba_treant_overgrowth_pa:IgnoreTenacity() return true end

function modifier_imba_treant_overgrowth_pa:OnCreated()
	if not IsServer() then return end
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_treant_overgrowth_pa:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget()~= nil then
		if self:GetParent():GetAttackTarget():HasModifier("modifier_imba_treant_overgrowth_root") then
			self.ar = 999999
		else
			self.ar = 0
		end
	end
end

function modifier_imba_treant_overgrowth_pa:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,}
	return decFuncs
end



function modifier_imba_treant_overgrowth_pa:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end



function modifier_imba_treant_overgrowth_pa:OnOrder( keys )
	if not IsServer() then return end	
	if keys.unit == self:GetParent() and keys.order_type == 4 then 
		if  keys.target:HasModifier("modifier_imba_treant_overgrowth_root") then
		self.ar = 999999
		end
	end
end