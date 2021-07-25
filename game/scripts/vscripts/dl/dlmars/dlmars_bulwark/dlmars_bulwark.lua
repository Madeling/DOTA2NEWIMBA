CreateTalents("npc_dota_hero_mars", "dl/dlmars/dlmars_bulwark/modifier_dlmars_bulwark_mars")
dlmars_bulwark = class({})	--表里技能模式

LinkLuaModifier( "modifier_dlmars_bulwark_mars", "dl/dlmars/dlmars_bulwark/modifier_dlmars_bulwark_mars", LUA_MODIFIER_MOTION_NONE )

--1.npc abilities override里原版技能behavior hidden  2.npc heroes custom 表技能放3槽，里技能随便塞个槽

function dlmars_bulwark:OnToggle()
	-- unit identifier
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName( "modifier_dlmars_bulwark_mars" )
	self.insideab = caster:FindAbilityByName("mars_bulwark")
	self.insideab:ToggleAbility()	--开启里技能
	if not self:GetToggleState() == self.insideab:GetToggleState()	then self.insideab:ToggleAbility() end	--不知道会不会出现状态不一致的情况，加这行保险一下，虽然也不知道这行有没有用

	if self:GetToggleState() then
		if not modifier then
			caster:AddNewModifier(	--添加流弹
				caster, -- player source
				self, -- ability source
				"modifier_dlmars_bulwark_mars", -- modifier name
				{}
			)
		end
	else
		if modifier then
			modifier:Destroy()
		end
	end
end

function dlmars_bulwark:ProcsMagicStick()	--此技能不能触发魔棒
	return false
end

--------------------------------------------------------------------------------
-- Ability Events
function dlmars_bulwark:OnUpgrade()

	local modifier2 = self:GetCaster():FindModifierByName( "modifier_dlmars_bulwark_mars" )

	self:GetCaster():FindAbilityByName("mars_bulwark"):SetLevel(self:GetLevel()) --给里技能加等级

	if modifier2 then	--确保升级后的技能可以得到升级后的special value
		modifier2:ForceRefresh()
	end
end

function dlmars_bulwark:OnProjectileHit(target, location)
	if not target then return end

	local caster = self:GetCaster()

	local damagetable1 = {
		victim = target,
		attacker = caster,
		damage = self.projdamage,
		ability = self,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage( damagetable1 )

	if not caster:TG_HasTalent("special_bonus_dlmars_20r") then return end		--没有天赋就结束，有就继续

	local damagetable2 = {		--天赋附加基础力量值的纯粹伤害
		victim = target,
		attacker = caster,
		damage = caster:GetBaseStrength(),
		ability = self,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,	--不吃技能增强.奇怪，出奥数圣剑伤害依然增加，但是增加较少，不加这行伤害巨幅增加
	}
	ApplyDamage( damagetable2 )

end

function dlmars_bulwark:straybullet(enemy,projname,projdamage,projspeed)
	local caster = self:GetCaster()

	self.projdamage = projdamage

	local info =
	{
		Target = enemy,
		Source = caster,
		Ability = self,
		EffectName = projname,
		iMoveSpeed = projspeed,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,

		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,	--不加isourceattachment观察到黄字报错，尝试从XX模型ATTACK_1上创建投射物
	}

	TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=info})		--0是线性，其他跟踪

end
