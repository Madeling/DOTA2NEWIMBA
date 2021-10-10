wukongs_command=class({})
LinkLuaModifier("modifier_wukongs_command_motion", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_wukongs_command_buff", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff2", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff3", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff4", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff5", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff6", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_buff7", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wukongs_command_th", "heros/hero_monkey_king/wukongs_command.lua", LUA_MODIFIER_MOTION_NONE)
function wukongs_command:IsHiddenWhenStolen()
    return false
end

function wukongs_command:IsStealable()
    return true
end

function wukongs_command:IsRefreshable()
    return true
end
function wukongs_command:Init()
       self.caster=self:GetCaster()
end

function wukongs_command:GetIntrinsicModifierName()
    return "modifier_wukongs_command_buff7"
end

function wukongs_command:OnOwnerSpawned()
    if self.caster.mkTalent~=nil and IsValidEntity(self.caster.mkTalent) and self.caster.mkTalent:IsAlive() then
            FindClearSpaceForUnit(self.caster, self.caster.mkTalent:GetAbsOrigin(), true)
            self.caster.mkTalent:Kill(self, self.caster.mkTalent)
            self.caster.mkTalent=nil
    end
end

function wukongs_command:OnSpellStart()
    self.caster:MK()
    self.caster:InterruptMotionControllers(true)
    local target_pos=self:GetCursorPosition()
    local caster_pos=self.caster:GetAbsOrigin()
    local dur=self:GetSpecialValueFor("dur")+self.caster:TG_GetTalentValue("special_bonus_monkey_king_5")
    local dis=TG_Distance(caster_pos,target_pos)
    local dir=TG_Direction2(target_pos,caster_pos)
    dis=dis>800 and 800 or dis
    local time=dis/1500
    self.caster:EmitSound("Hero_MonkeyKing.FurArmy.Channel")
    self.caster:EmitSound("monkey_king_monkey_spawn_01")
    EmitGlobalSound("TG.WK")
  --  caster:EmitSound("TG.WK")
    if self.caster.wukongsMODEL==nil then
        self.caster.wukongsMODEL={
            "models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl",
            "models/items/monkey_king/mk_ti9_immortal_weapon/mk_ti9_immortal_weapon.vmdl",
            "models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_armor.vmdl",
            "models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_shoulders.vmdl"
        }

    end
    if self.caster.wukongsMOD==nil then
        self.caster.wukongsMOD={}
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_wukongs_command_motion", {duration=time,dir=dir})
    self.caster:AddNewModifier(self.caster, self, "modifier_wukongs_command_buff2", {duration=dur})
    self.caster:AddNewModifier(self.caster, self, "modifier_wukongs_command_buff", {duration=dur})
    self.caster:AddNewModifier(self.caster, self, "modifier_wukongs_command_buff3", {duration=dur})

end


modifier_wukongs_command_motion=class({})
function modifier_wukongs_command_motion:IsDebuff()
	return false
end

function modifier_wukongs_command_motion:IsHidden()
	return true
end

function modifier_wukongs_command_motion:IsPurgable()
	return false
end

function modifier_wukongs_command_motion:IsPurgeException()
	return false
end

function modifier_wukongs_command_motion:OnCreated(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle2)
    self.DIR=ToVector(tg.dir)
    self:GetParent():StartGesture(ACT_DOTA_MK_SPRING_SOAR)
    if not self:ApplyHorizontalMotionController() then
		self:Destroy()
    end
end

function modifier_wukongs_command_motion:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1500 / (1.0 / g)))
end


function modifier_wukongs_command_motion:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_wukongs_command_motion:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():FadeGesture(ACT_DOTA_MK_SPRING_SOAR)
        local POS= self:GetParent():GetAbsOrigin()
        local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, POS)
        ParticleManager:SetParticleControl(particle, 1, Vector(800,0,0))
        ParticleManager:SetParticleControl(particle, 3, POS)
        ParticleManager:SetParticleControl(particle, 4, POS)
        ParticleManager:SetParticleControl(particle, 5, POS)
        ParticleManager:ReleaseParticleIndex(particle)
        local particle2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControl(particle2, 0, POS)
        ParticleManager:SetParticleControl(particle2, 1, Vector(800,0,0))
        ParticleManager:SetParticleControl(particle2, 2, Vector(1,1,1))
        ParticleManager:SetParticleControl(particle2, 3,POS)
        ParticleManager:ReleaseParticleIndex(particle2)
        if self:GetParent():HasScepter() then
            local modifier=
            {
                outgoing_damage=-100,
                incoming_damage=0,
                bounty_base=0,
                bounty_growth=0,
                outgoing_damage_structure=0,
                outgoing_damage_roshan=0,
            }
            local dur=self:GetAbility():GetSpecialValueFor("dur")
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wukongs_command_buff4", {duration=dur})
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wukongs_command_buff5", {duration=dur})
            local illusions=CreateIllusions(self:GetParent(), self:GetParent(), modifier, 1, 100, true, true)
            illusions[1]:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_kill", {duration=dur})
        end
        if self:GetParent():TG_HasTalent("special_bonus_monkey_king_8") then
                CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_wukongs_command_th", {duration=6}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
        end
    end
end


modifier_wukongs_command_buff=class({})
function modifier_wukongs_command_buff:IsDebuff()
	return false
end

function modifier_wukongs_command_buff:IsHidden()
	return true
end

function modifier_wukongs_command_buff:IsPurgable()
	return false
end

function modifier_wukongs_command_buff:IsPurgeException()
	return false
end


function modifier_wukongs_command_buff:OnCreated()

    if not IsServer() then
        return
    end
    local model=self:GetParent().wukongsMODEL
    for num=1,#model do
        local mod = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model[num]})
        mod:SetParent(self:GetParent(), nil)
        mod:FollowEntity(self:GetParent(), true)
        table.insert (self:GetCaster().wukongsMOD, mod)
    end

    local head = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(head, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_crownfx", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(head, false, true, 15, true, false)

    local eyes = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/death/mk_arcana_death_eyes.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(eyes, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(eyes, 1, self:GetParent(), PATTACH_EYES_FOLLOW, "attach_eve_r", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(eyes, 2, self:GetParent(), PATTACH_EYES_FOLLOW, "attach_eve_1", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(eyes, false, true, 15, true, false)

    local px1 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/monkey_king_arcana_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(px1, false, true, 15, true, false)

    self:OnIntervalThink()
    self:StartIntervalThink(6)
end


function modifier_wukongs_command_buff:OnIntervalThink()
    if not IsServer() then
        return
    end
    self.particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/monkey_arcana_cloud.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, "attach_cloud", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.particle, 3, Vector(1,1,1))
    ParticleManager:SetParticleControl(self.particle, 4, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(self.particle, 9, Vector(1,1,1))
    self:AddParticle(self.particle, false, true, 15, true, false)
end

function modifier_wukongs_command_buff:OnDestroy()
    if not IsServer() then
        return
    end
    if self.particle~=nil then
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:ReleaseParticleIndex(self.particle)
       end
    if self:GetCaster().wukongsMOD~=nil  and #self:GetCaster().wukongsMOD>0  then
        for num=1,#self:GetCaster().wukongsMOD do
            self:GetCaster().wukongsMOD[num]:RemoveSelf()
        end
        self:GetCaster().wukongsMOD={}
    end
end






modifier_wukongs_command_buff2= class({})

function modifier_wukongs_command_buff2:IsDebuff()
    return false
end

function modifier_wukongs_command_buff2:IsHidden()
    return true
end

function modifier_wukongs_command_buff2:IsPurgable()
    return false
end

function modifier_wukongs_command_buff2:IsPurgeException()
    return false
end

function modifier_wukongs_command_buff2:IsAura()
    return true
end

function modifier_wukongs_command_buff2:GetModifierAura()
    return "modifier_truesight"
end

function modifier_wukongs_command_buff2:GetAuraRadius()
        return 600+self:GetCaster():TG_GetTalentValue("special_bonus_monkey_king_6")
end

function modifier_wukongs_command_buff2:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_wukongs_command_buff2:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_wukongs_command_buff2:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end


modifier_wukongs_command_buff3= class({})

function modifier_wukongs_command_buff3:IsDebuff()
    return false
end

function modifier_wukongs_command_buff3:IsHidden()
    return false
end

function modifier_wukongs_command_buff3:IsPurgable()
    return false
end

function modifier_wukongs_command_buff3:IsPurgeException()
    return false
end

function modifier_wukongs_command_buff3:OnCreated()
   self.ABS=true
   if not IsServer() then
    return
    end
    self.fx = ParticleManager:CreateParticle("particles/prototype_fx/item_linkens_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(self.fx, 1, Vector(50,50,50))
    ParticleManager:SetParticleControl(self.fx, 4, self:GetParent():GetAbsOrigin())
   self:AddParticle(self.fx, true, false, 15, false, false)
end

function modifier_wukongs_command_buff3:OnRefresh()
    self:OnCreated()
 end


function modifier_wukongs_command_buff3:CheckState()
    if self:GetParent():HasModifier("modifier_mischief_buff") then
    return
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
else
    return
    {
        [MODIFIER_STATE_FLYING] = true,
    }
end
end

function modifier_wukongs_command_buff3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ABSORB_SPELL,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_wukongs_command_buff3:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("att")
end

function modifier_wukongs_command_buff3:GetAbsorbSpell(tg)
    if not IsServer() then
        return
    end
    if  Is_Chinese_TG(tg.ability:GetCaster(), self:GetParent()) or  self.ABS==nil or  self.ABS==false then
		return 0
    end
    self.ABS=false
    if self.fx~=nil then
        ParticleManager:DestroyParticle(self.fx, true)
        ParticleManager:ReleaseParticleIndex(self.fx)
        self.fx=nil
    end
	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
	return 1
end



modifier_wukongs_command_buff4= class({})

function modifier_wukongs_command_buff4:IsDebuff()
    return false
end

function modifier_wukongs_command_buff4:IsHidden()
    return true
end

function modifier_wukongs_command_buff4:IsPurgable()
    return false
end

function modifier_wukongs_command_buff4:IsPurgeException()
    return false
end

function modifier_wukongs_command_buff4:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

function modifier_wukongs_command_buff4:GetModifierAttackRangeBonus()
    return 100
end


modifier_wukongs_command_buff5= class({})

function modifier_wukongs_command_buff5:IsDebuff()
    return false
end

function modifier_wukongs_command_buff5:IsHidden()
    return true
end

function modifier_wukongs_command_buff5:IsPurgable()
    return false
end

function modifier_wukongs_command_buff5:IsPurgeException()
    return false
end


modifier_wukongs_command_buff6= class({})

function modifier_wukongs_command_buff6:IsDebuff()
    return false
end

function modifier_wukongs_command_buff6:IsHidden()
    return true
end

function modifier_wukongs_command_buff6:IsPurgable()
    return false
end

function modifier_wukongs_command_buff6:IsPurgeException()
    return false
end


function modifier_wukongs_command_buff6:CheckState()
    return
    {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_wukongs_command_buff6:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MODEL_SCALE,
    }
end

function modifier_wukongs_command_buff6:GetModifierModelScale()
    return -77
end


function modifier_wukongs_command_buff6:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
end

function modifier_wukongs_command_buff6:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end


function modifier_wukongs_command_buff6:OnCreated()
    if not IsServer() then
        return
    end
        local POS=self:GetParent():GetAbsOrigin()
        local fx2 = ParticleManager:CreateParticle("particles/econ/items/earth_spirit/earth_spirit_vanquishingdemons_summons/espirit_stoneremnant_vanquishingdemons.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(fx2, 0, POS)
        ParticleManager:SetParticleControl(fx2, 1, POS)
        self:AddParticle(fx2, false, false, -1, false, false)

end

modifier_wukongs_command_buff7=class({})

function modifier_wukongs_command_buff7:IsHidden()
    return true
end

function modifier_wukongs_command_buff7:IsPurgable()
    return false
end

function modifier_wukongs_command_buff7:IsPurgeException()
    return false
end

function modifier_wukongs_command_buff7:DeclareFunctions()
    return
    {
		MODIFIER_EVENT_ON_DEATH,
    }
end


function modifier_wukongs_command_buff7:OnCreated()
    if IsServer() then
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
    end
end
function modifier_wukongs_command_buff7:OnDeath(tg)
	if IsServer() then
            if tg.unit ==self.parent and not self.parent:IsIllusion() and self.parent:TG_HasTalent("special_bonus_monkey_king_7") and (self.parent.mkTalent==nil or not IsValidEntity(self.parent.mkTalent) or self.parent.mkTalent:IsAlive() ) then
                self.parent.mkTalent=CreateUnitByName("npc_dota_mk", self.parent:GetAbsOrigin(), true, self.parent, self.parent, self.parent:GetTeamNumber())
                self.parent.mkTalent:SetControllableByPlayer(self.parent:GetPlayerOwnerID(), false)
                self.parent.mkTalent:AddNewModifier(self.parent.mkTalent, self.ability, "modifier_no_healthbar",  {})
                self.parent.mkTalent:AddNewModifier(self.parent.mkTalent, self.ability, "modifier_disarmed", {})
                self.parent.mkTalent:FindAbilityByName("tree_dance"):SetLevel(4)
            end
    end
end



modifier_wukongs_command_th=class({})
function modifier_wukongs_command_th:IsHidden()
    return true
end
function modifier_wukongs_command_th:IsPurgable()
    return false
end
function modifier_wukongs_command_th:IsPurgeException()
    return false
end
function modifier_wukongs_command_th:OnCreated()
        if IsServer() then
                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_furarmy_ring.vpcf", PATTACH_CUSTOMORIGIN ,nil)
                ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
                ParticleManager:SetParticleControl(particle, 1, Vector(800,1,1))
                self:AddParticle(particle, true, false, 4, false, false)
                self:StartIntervalThink(1.5)
        end
end
function modifier_wukongs_command_th:OnIntervalThink()
        local heros =FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        800,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,
        false
    )
    if #heros > 0 then
        for _, hero in pairs(heros) do
            local pos=hero:GetAbsOrigin()
            local fx =ParticleManager:CreateParticle('particles/tgp/mk/att_m.vpcf',PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(fx, 0, pos )
                ParticleManager:SetParticleControl(fx, 1, pos )
                ParticleManager:SetParticleControlEnt(fx, 2,  self:GetCaster(), PATTACH_CUSTOMORIGIN, "attach_hitloc", pos, true)
                ParticleManager:ReleaseParticleIndex(fx)
                  self:GetCaster():PerformAttack(hero, false, false, true, false, false, false, true)
        end
    end
end
