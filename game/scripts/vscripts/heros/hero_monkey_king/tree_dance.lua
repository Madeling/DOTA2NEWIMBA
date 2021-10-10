tree_dance=class({})
LinkLuaModifier("modifier_tree_dance_motion", "heros/hero_monkey_king/tree_dance.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_tree_dance_pa", "heros/hero_monkey_king/tree_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tree_dance_height", "heros/hero_monkey_king/tree_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tree_dance_idle", "heros/hero_monkey_king/tree_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tree_dance_startjump", "heros/hero_monkey_king/tree_dance.lua", LUA_MODIFIER_MOTION_NONE)
function tree_dance:IsHiddenWhenStolen()
    return false
end
function tree_dance:IsStealable()
    return true
end
function tree_dance:IsRefreshable()
    return true
end
function tree_dance:Init()
  self.caster=self:GetCaster()
end

function tree_dance:OnAbilityPhaseStart()
    if self.caster:HasModifier("modifier_primal_spring_motion") then
        self.caster:RemoveModifierByName("modifier_primal_spring_motion")
    end
    if self.caster:HasModifier("modifier_tree_dance_idle") then
        self.caster:RemoveModifierByName("modifier_tree_dance_idle")
    end
    return true
end

function tree_dance:OnSpellStart()
    self.caster:MK()
    local target=self:GetCursorTarget()
    local target_pos=target:GetAbsOrigin()
    local caster_pos=self.caster:GetAbsOrigin()
    local dis=TG_Distance(caster_pos,target_pos)+self.caster:GetCastRangeBonus()
    local dir=TG_Direction2(target_pos,caster_pos)
    if  self.caster:TG_HasTalent("special_bonus_monkey_king_3") then
          self.caster:AddNewModifier( self.caster, self, "modifier_invisible", {duration=1})
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_tree_dance_motion", {dir=dir,dis=dis,target=target:entindex()})
    local pp =
    {
        EffectName ="particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf",
        Ability = self,
        vSpawnOrigin =caster_pos,
        vVelocity =self.caster:GetForwardVector(),
        Source = self.caster,
        bHasFrontalCone = true,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_NONE,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile( pp )
end

function tree_dance:GetIntrinsicModifierName()
    return "modifier_tree_dance_pa"
end


modifier_tree_dance_motion=class({})
function modifier_tree_dance_motion:IsDebuff()
	return false
end
function modifier_tree_dance_motion:IsHidden()
	return true
end
function modifier_tree_dance_motion:IsPurgable()
	return false
end
function modifier_tree_dance_motion:IsPurgeException()
	return false
end

function modifier_tree_dance_motion:OnCreated(tg)
    self.interrupted=false
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle2)
    self.TARGET=EntIndexToHScript(tg.target)
    self.DIR=ToVector(tg.dir)
    self.DIS=tg.dis/2
    self.POS=self:GetParent():GetAbsOrigin()
    self.H=0
    self.TPOS=self.TARGET:GetAbsOrigin()
    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "TreeJump.Cast", self:GetParent())
    if self:GetParent():HasModifier("modifier_tree_dance_height") then
        self:GetParent():EmitSound("Hero_MonkeyKing.TreeJump.Tree")
        local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_treelaunch_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(particle3)
    end
	if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController()then
		self:Destroy()
    end
end

function modifier_tree_dance_motion:UpdateVerticalMotion(t, g)
    if not IsServer() then
        return
    end
    local POS1=self:GetParent():GetAbsOrigin()
    if TG_Distance(POS1,self.POS)>= self.DIS then
        self.H=self:GetParent():HasModifier("modifier_tree_dance_height") and self.H-10 or self.H-5
    else
        if self:GetParent():HasModifier("modifier_tree_dance_height") then
            self.H= (self.TARGET:GetAbsOrigin().z-POS1.z)>=256 and self.H+6 or self.H+4
        else
            self.H=self.H+4
        end
    end
        self:GetParent():SetAbsOrigin(POS1+self:GetParent():GetUpVector()*self.H)
end

function modifier_tree_dance_motion:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    local POS1=self:GetParent():GetAbsOrigin()
    local POS2=nil
    if not GridNav:IsNearbyTree(self.TPOS, 1, true) then
        POS2 = self:GetParent():GetAbsOrigin()
    else
        POS2 = self.TARGET:GetAbsOrigin()
    end
    if  TG_Distance(POS1,POS2) <= 50  then
        self:Destroy()
        return
    end
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1600 / (1.0 / g)))
end

function modifier_tree_dance_motion:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self.interrupted=true
    self:Destroy()
end

function modifier_tree_dance_motion:OnVerticalMotionInterrupted()
    if not IsServer() then
        return
    end
    self.interrupted=true
    self:Destroy()
end

function modifier_tree_dance_motion:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():EmitSound("Hero_MonkeyKing.TreeJump.Tree")
        local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        self:AddParticle( particle, false, false, 20, false, false )
        if self:GetParent():GetName()=="npc_dota_hero_monkey_king" then
            self:GetParent():StartGesture(ACT_DOTA_MK_TREE_END)
        end
        if self:GetParent():HasAbility("primal_spring") then
        local AB=self:GetParent():FindAbilityByName("primal_spring")
                AB:SetLevel(self:GetAbility():GetLevel())
                AB:SetActivated(true)
        end
        if self.interrupted==false and  GridNav:IsNearbyTree(self.TPOS, 1, true) then
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tree_dance_idle", {})
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tree_dance_height", {target=self.TARGET:entindex()})
        end
    end
end

function modifier_tree_dance_motion:CheckState()
    return
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end


function modifier_tree_dance_motion:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK
    }
end

function modifier_tree_dance_motion:GetDisableAutoAttack(tg)
    return 1
end


function modifier_tree_dance_motion:GetOverrideAnimation()
    if self:GetParent():GetName()=="npc_dota_hero_monkey_king" then
        return ACT_DOTA_MK_TREE_SOAR
    end
end

function modifier_tree_dance_motion:GetOverrideAnimationWeight()
    return 1
end


modifier_tree_dance_height=class({})
function modifier_tree_dance_height:IsDebuff()
	return false
end

function modifier_tree_dance_height:IsHidden()
	return true
end

function modifier_tree_dance_height:IsPurgable()
	return false
end

function modifier_tree_dance_height:IsPurgeException()
	return false
end

function modifier_tree_dance_height:RemoveOnDeath()
	return true
end

function modifier_tree_dance_height:OnCreated(tg)
    self.rd=self:GetAbility():GetSpecialValueFor("dis")
    self.hp=self:GetAbility():GetSpecialValueFor("hp")
	if not IsServer() then
		return
    end
    self.TARGET=EntIndexToHScript(tg.target)
    self:OnIntervalThink()
    self:StartIntervalThink(0.1)
end

function modifier_tree_dance_height:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_tree_dance_height:OnIntervalThink()
    if not IsServer() or  self:GetParent():HasModifier("modifier_tree_dance_motion")  then
		return
    end
        local pos=self:GetParent():GetAbsOrigin()
        local tree=GridNav:IsNearbyTree(pos, 1, true)
        if not tree or  not self.TARGET  or TG_Distance(pos,self.TARGET:GetAbsOrigin()) >100  then
            self:Destroy()
        elseif  not tree or (self.TARGET  and not  self.TARGET:IsStanding()) then
            GridNav:DestroyTreesAroundPoint(pos,250,false)
            if self:GetParent():TG_HasTalent("special_bonus_monkey_king_4") then
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration=1})
            end
            self:Destroy()
        else
            AddFOWViewer(self:GetParent():GetTeamNumber(), pos, self.rd, 0.2, false)
        end
end

function modifier_tree_dance_height:OnDestroy()
    if  IsServer() then
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
        self:GetAbility():UseResources(false, false, true)
        if  self:GetParent():HasModifier("modifier_tree_dance_idle") then
            self:GetParent():RemoveModifierByName("modifier_tree_dance_idle")
        end
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tree_dance_startjump", {duration=0.5})
    end
end


function modifier_tree_dance_height:CheckState()
        return
        {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
            [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,

        }
end

function modifier_tree_dance_height:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK
    }
end

function modifier_tree_dance_height:GetDisableAutoAttack()
    return 1
end


function modifier_tree_dance_height:GetModifierHPRegenAmplify_Percentage()
    return self.hp
end

function modifier_tree_dance_height:OnOrder(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent()  then
        if  tg.order_type== DOTA_UNIT_ORDER_MOVE_TO_TARGET  or tg.order_type== DOTA_UNIT_ORDER_ATTACK_MOVE or tg.order_type== DOTA_UNIT_ORDER_ATTACK_TARGET then
            self:Destroy()
        end
    end
end

function modifier_tree_dance_height:OnUnitMoved(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent() and  self:GetParent():IsMoving() then
            self:Destroy()
    end
end


function modifier_tree_dance_height:GetVisualZDelta()
    return 256
end



modifier_tree_dance_idle=class({})
function modifier_tree_dance_idle:IsDebuff()
	return false
end

function modifier_tree_dance_idle:IsHidden()
	return true
end

function modifier_tree_dance_idle:IsPurgable()
	return false
end

function modifier_tree_dance_idle:IsPurgeException()
	return false
end

function modifier_tree_dance_idle:RemoveOnDeath()
	return true
end

function modifier_tree_dance_idle:OnCreated()
	if not IsServer() then
		return
    end
    local pp =
    {
        EffectName ="particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf",
        Ability = self:GetAbility(),
        vSpawnOrigin =self:GetParent():GetAbsOrigin(),
        vVelocity =self:GetParent():GetForwardVector(),
        Source = self:GetParent(),
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_NONE,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile( pp )
    local particle2= ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_WORLDORIGIN,self:GetParent(),PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()) )
	ParticleManager:SetParticleControl(particle2, 0,self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(self:GetAbility():GetSpecialValueFor("dis")+self:GetParent():GetCastRangeBonus(), 0, 0))
	ParticleManager:SetParticleControl(particle2, 2, Vector(10, 0, 0))
	ParticleManager:SetParticleControl(particle2, 3, Vector(100, 0, 0))
    ParticleManager:SetParticleControl(particle2, 15, Vector(84, 255, 159))
    self:AddParticle(particle2, false, false, 15, false, false)
end

function modifier_tree_dance_idle:OnRefresh()
    self:OnCreated()
end

function modifier_tree_dance_idle:OnDestroy()
    if  IsServer() then
        if self:GetParent():HasAbility("primal_spring") then
            local AB=self:GetParent():FindAbilityByName("primal_spring")
            AB:SetActivated(false)
        end
    end
end



function modifier_tree_dance_idle:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_CAN_ATTACK_TREES
    }
end


function modifier_tree_dance_idle:GetModifierCanAttackTrees()
    return 1
end

function modifier_tree_dance_idle:GetActivityTranslationModifiers()
    return "perch"
end

function modifier_tree_dance_idle:GetOverrideAnimation()
    if self:GetParent():GetName()=="npc_dota_hero_monkey_king" then
        return ACT_DOTA_MK_TREE_END
    end
end

function modifier_tree_dance_idle:GetOverrideAnimationWeight()
    return 0.5
end


function modifier_tree_dance_idle:GetDisableAutoAttack()
    return 1
 end

modifier_tree_dance_startjump=class({})
function modifier_tree_dance_startjump:IsDebuff()
	return false
end

function modifier_tree_dance_startjump:IsHidden()
	return true
end

function modifier_tree_dance_startjump:IsPurgable()
	return false
end

function modifier_tree_dance_startjump:IsPurgeException()
	return false
end

function modifier_tree_dance_startjump:RemoveOnDeath()
	return true
end

function modifier_tree_dance_startjump:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
    }
end


function modifier_tree_dance_startjump:GetActivityTranslationModifiers()
    return "right_click_jumping"
end

function modifier_tree_dance_startjump:GetOverrideAnimation()
    return ACT_DOTA_IDLE
end

function modifier_tree_dance_startjump:GetOverrideAnimationWeight()
    return 1
end


modifier_tree_dance_pa=class({})
function modifier_tree_dance_pa:IsDebuff()
	return false
end

function modifier_tree_dance_pa:IsHidden()
	return true
end

function modifier_tree_dance_pa:IsPurgable()
	return false
end

function modifier_tree_dance_pa:IsPurgeException()
	return false
end

function modifier_tree_dance_pa:RemoveOnDeath()
	return false
end

function modifier_tree_dance_pa:IsPermanent()
	return true
end

function modifier_tree_dance_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_START
    }
end

function modifier_tree_dance_pa:OnTakeDamage(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent() and (tg.attacker:IsRealHero()or tg.attacker:IsBoss() ) then
        self:GetAbility():UseResources(false, false, true)
    end
end

function modifier_tree_dance_pa:OnAbilityStart(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() then
        local name=tg.ability:GetName()
        if name=="item_blink" or name=="item_force_staff" or name=="item_force_boots"  or name=="item_hurricane_pike"then
            TG_Remove_Modifier(self:GetParent(),"modifier_tree_dance_height",0)
            TG_Remove_Modifier(self:GetParent(),"modifier_tree_dance_idle",0)
            TG_Remove_Modifier(self:GetParent(),"modifier_tree_dance_startjump",0)
            TG_Remove_Modifier(self:GetParent(),"modifier_primal_spring_motion",0)
        end
    end
end