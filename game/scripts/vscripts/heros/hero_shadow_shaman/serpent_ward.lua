    serpent_ward=serpent_ward or class({})
LinkLuaModifier("modifier_serpent_ward_base", "heros/hero_shadow_shaman/serpent_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_serpent_ward_a", "heros/hero_shadow_shaman/serpent_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_serpent_ward_eat", "heros/hero_shadow_shaman/serpent_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_serpent_ward_debuff", "heros/hero_shadow_shaman/serpent_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_serpent_ward_pos", "heros/hero_shadow_shaman/serpent_ward.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function serpent_ward:IsHiddenWhenStolen()
    return false
end

function serpent_ward:IsStealable()
    return true
end


function serpent_ward:IsRefreshable()
    return true
end


function serpent_ward:OnSpellStart()
    local caster=self:GetCaster()
    local curpos=self:GetCursorPosition()
    local dur=self:GetSpecialValueFor("dur")
    local team = caster:GetTeamNumber()
    caster:EmitSound("Hero_ShadowShaman.SerpentWard")
   local NPC={}
    NPC[1]=CreateUnitByName("npc_dota_shadow_shaman_ward_1", Vector(curpos.x+150,curpos.y,curpos.z),false,caster,caster,team)
    NPC[2]=CreateUnitByName("npc_dota_shadow_shaman_ward_2", Vector(curpos.x-150,curpos.y,curpos.z),false,caster,caster,team)
    NPC[3]=CreateUnitByName("npc_dota_shadow_shaman_ward_1", Vector(curpos.x,curpos.y+150,curpos.z),false,caster,caster,team)
    NPC[4]=CreateUnitByName("npc_dota_shadow_shaman_ward_3", Vector(curpos.x,curpos.y-150,curpos.z),false,caster,caster,team)
    NPC[5]=CreateUnitByName("npc_dota_shadow_shaman_ward_3", Vector(curpos.x,curpos.y,curpos.z),false,caster,caster,team)
    NPC[5].serpent_ward5=true
    for _,target in pairs(NPC) do
        target:AddNewModifier(caster, self, "modifier_kill", {duration =dur})
        target:AddNewModifier(caster, self, "modifier_serpent_ward_base", {duration =dur})
        target:AddNewModifier(caster, self, "modifier_serpent_ward_eat", {duration =dur,pos=curpos})
        target:AddNewModifier(caster, self, "modifier_serpent_ward_a", {duration =dur})
    end

end


modifier_serpent_ward_base=class({})

function modifier_serpent_ward_base:IsHidden()
	return true
end

function modifier_serpent_ward_base:IsPurgable()
	return false
end

function modifier_serpent_ward_base:IsPurgeException()
	return false
end

function modifier_serpent_ward_base:OnCreated()
    local hp=self:GetAbility():GetSpecialValueFor("hp")
    local att=self:GetAbility():GetSpecialValueFor( "att")
    local atti= self:GetAbility():GetSpecialValueFor( "atti")+self:GetCaster():TG_GetTalentValue("special_bonus_shadow_shaman_6")
    local attrg= self:GetAbility():GetSpecialValueFor( "attrg")
    if IsServer() then
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ward_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
            ParticleManager:SetParticleControlEnt( particle, 0,  self:GetParent(), PATTACH_ROOTBONE_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true )
            ParticleManager:ReleaseParticleIndex(particle)
    self:GetParent():SetForwardVector( TG_Direction(self:GetParent():GetAbsOrigin(),self:GetCaster():GetAbsOrigin()))
    self:GetParent():SetOwner(self:GetAbility():GetCaster())
    self:GetParent():SetControllableByPlayer(self:GetAbility():GetCaster():GetPlayerOwnerID(), false)
    self:GetParent():SetMaxHealth(hp)
    self:GetParent():SetBaseMaxHealth(hp)
    self:GetParent():SetHealth(hp)
    self:GetParent():SetBaseDamageMin(att)
    self:GetParent():SetBaseDamageMax(att)
    self:GetParent():SetBaseMagicalResistanceValue(100)
    self:GetParent():SetBaseAttackTime(atti)
        if self:GetCaster():Has_Aghanims_Shard() then
            self:GetParent():SetBaseDamageMin(att+100)
            self:GetParent():SetBaseDamageMax(att+100)
        end
    end
end

function modifier_serpent_ward_base:OnAttackLanded(tg)
    if not IsServer() then
        return
    end

    if  tg.target == self:GetParent() and  tg.attacker ~= self:GetParent()  then
        local hp=self:GetParent():GetHealth()
        if hp>0 then
            self:GetParent():SetHealth(hp - 1)
            if hp<=0 then
                self:GetParent():Kill(self:GetAbility(), tg.attacker)
            end
        end
    end
end

function modifier_serpent_ward_base:OnDestroy()
    if  IsServer() then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ward_death.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
        ParticleManager:SetParticleControlEnt( particle, 0,  self:GetParent(), PATTACH_ROOTBONE_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true )
        ParticleManager:ReleaseParticleIndex(particle)
    end
end

function modifier_serpent_ward_base:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_serpent_ward_base:DeclareFunctions() return
     {
         MODIFIER_EVENT_ON_ATTACK_LANDED,
         MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
         MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
         MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
         MODIFIER_PROPERTY_DISABLE_HEALING,
         MODIFIER_PROPERTY_MODEL_SCALE,
         MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_serpent_ward_base:GetDisableHealing()
    return 1
end

function modifier_serpent_ward_base:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_serpent_ward_base:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_serpent_ward_base:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_serpent_ward_base:GetModifierModelScale()
    return 30
end

function modifier_serpent_ward_base:GetModifierAttackSpeedBonus_Constant()
    if self:GetParent():HasModifier("modifier_shock_dam") then
            return self:GetAbility():GetSpecialValueFor("attsp")
    end
    return 0
end

modifier_serpent_ward_eat=class({})

function modifier_serpent_ward_eat:IsHidden()
	return true
end

function modifier_serpent_ward_eat:IsPurgable()
	return false
end

function modifier_serpent_ward_eat:IsPurgeException()
	return false
end

function modifier_serpent_ward_eat:OnCreated(tg)
    self.huntrd=self:GetAbility():GetSpecialValueFor("huntrd")
    local hunti=self:GetAbility():GetSpecialValueFor( "hunti")
    if IsServer() then
        self.POS=self:GetParent():GetAbsOrigin()
        self.POS2=ToVector(tg.pos)
        if self:GetParent().serpent_ward5~=nil and self:GetParent().serpent_ward5 then
            local particle = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
            ParticleManager:SetParticleControl(particle, 1, Vector(self.huntrd, 0, 0))
            ParticleManager:SetParticleControl(particle, 2, Vector(10, 0, 0))
            ParticleManager:SetParticleControl(particle, 3, Vector(100, 0, 0))
            ParticleManager:SetParticleControl(particle, 15, Vector(255, 160, 0))
            self:AddParticle(particle, false, false, 10, false, false)
        end
        self:StartIntervalThink(hunti)
    end
end

function modifier_serpent_ward_eat:OnIntervalThink()
    if self:GetParent():GetHealth()>0 then
        local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self.POS2, nil,  self.huntrd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #enemies>0 then
            local unit=enemies[RandomInt(1,#enemies)]
            if not unit:IsMagicImmune() then
                if  unit:HasModifier("modifier_serpent_ward_pos")  or  unit:HasModifier("modifier_serpent_ward_debuff")   then
                    return
                end
                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
                ParticleManager:SetParticleControl(particle, 0,  self.POS)
                ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
                ParticleManager:ReleaseParticleIndex(particle)
                unit:EmitSound("Hero_ShadowShaman.SerpentWard")
                unit:AddNewModifier_RS(self:GetParent(),self:GetAbility(),"modifier_serpent_ward_debuff",{duration=self:GetAbility():GetSpecialValueFor("huntdur")})
                unit:AddNewModifier_RS(self:GetParent(),self:GetAbility(),"modifier_serpent_ward_pos",{duration=1,dir=TG_Direction( self.POS,unit:GetAbsOrigin()),c=self:GetParent():entindex()})
            end
        end
    end
end



modifier_serpent_ward_debuff=class({})

function modifier_serpent_ward_debuff:IsDebuff()
	return true
end

function modifier_serpent_ward_debuff:IsHidden()
	return false
end

function modifier_serpent_ward_debuff:IsPurgable()
	return false
end

function modifier_serpent_ward_debuff:IsPurgeException()
	return false
end

function modifier_serpent_ward_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
end

function modifier_serpent_ward_debuff:DeclareFunctions()
	return
		{
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION
		}
end



function modifier_serpent_ward_debuff:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

modifier_serpent_ward_pos=class({})

function modifier_serpent_ward_pos:IsHidden()
	return false
end

function modifier_serpent_ward_pos:IsPurgable()
	return false
end

function modifier_serpent_ward_pos:IsPurgeException()
	return false
end

function modifier_serpent_ward_pos:RemoveOnDeath()
	return false
end

function modifier_serpent_ward_pos:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW
end

function modifier_serpent_ward_pos:OnCreated(tg)
    if not IsServer() then
        return
    end
    self.DIR=ToVector(tg.dir)
    self.CASTER=EntIndexToHScript(tg.c)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_serpent_ward_pos:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.CASTER~=nil and  self.CASTER:IsAlive() then
        self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (300 / (1.0 / FrameTime())))
    end

end

function modifier_serpent_ward_pos:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
	self:Destroy()
end


function modifier_serpent_ward_pos:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

function modifier_serpent_ward_pos:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
    }
end

function modifier_serpent_ward_pos:DeclareFunctions()
	return
		{
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION
		}
end

function modifier_serpent_ward_pos:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

modifier_serpent_ward_a=class({})

function modifier_serpent_ward_a:IsHidden()
	return true
end

function modifier_serpent_ward_a:IsPurgable()
	return false
end

function modifier_serpent_ward_a:IsPurgeException()
	return false
end

function modifier_serpent_ward_a:OnCreated()
    self.dur=self:GetAbility():GetSpecialValueFor("dur")
end


function modifier_serpent_ward_a:OnDeath(tg)
    if not IsServer() then
        return
    end
    if  tg.attacker == self:GetParent() and tg.unit ~= self:GetParent() then
        local caster=self:GetCaster()
        if caster:HasScepter() then
            local ward=CreateUnitByName("npc_dota_ward_s", tg.unit:GetAbsOrigin(),false,caster,caster,caster:GetTeamNumber())
            ward:AddNewModifier(caster, self:GetAbility(), "modifier_kill", {duration = self.dur})
            ward:AddNewModifier(caster, self:GetAbility(), "modifier_serpent_ward_base", {duration = self.dur})
        end
	end
end


function modifier_serpent_ward_a:DeclareFunctions() return
     {
         MODIFIER_EVENT_ON_DEATH
    }
end