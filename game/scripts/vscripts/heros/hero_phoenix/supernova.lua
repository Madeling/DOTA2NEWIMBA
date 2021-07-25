supernova=class({})
LinkLuaModifier("modifier_supernova_buff", "heros/hero_phoenix/supernova.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_supernova_buff2", "heros/hero_phoenix/supernova.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_supernova_buff3", "heros/hero_phoenix/supernova.lua", LUA_MODIFIER_MOTION_NONE)
function supernova:IsHiddenWhenStolen()
    return false
end

function supernova:IsStealable()
    return true
end

function supernova:IsRefreshable()
    return true
end


function supernova:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local dur=self:GetSpecialValueFor( "dur" )
    caster:EmitSound("Hero_Phoenix.SuperNova.Begin")
    caster:EmitSound("Hero_Phoenix.SuperNova.Cast")
    TG_Remove_Modifier(caster,"modifier_icarus_dive_move",0)
    TG_Remove_Modifier(caster,"modifier_icarus_dive_move2",0)
    local null = CreateUnitByName(
        "npc_dota_phoenix_egg",
         caster_pos,
         true,
         caster,
         caster,
         caster:GetTeamNumber())
    null.phoenix=caster
	null:StartGestureWithPlaybackRate(ACT_DOTA_IDLE , 6 / dur)
    caster:AddNewModifier(caster, self, "modifier_supernova_buff", {duration=dur})
    null:AddNewModifier(caster, self, "modifier_kill", {duration=dur })
    null:AddNewModifier(caster, self, "modifier_supernova_buff2", {duration=dur})


end

modifier_supernova_buff=class({})

function modifier_supernova_buff:IsHidden()
    return true
end

function modifier_supernova_buff:IsPurgable()
    return false
end

function modifier_supernova_buff:IsPurgeException()
    return false
end

function modifier_supernova_buff:OnCreated()
    local tick=self:GetAbility():GetSpecialValueFor( "tick" )
   self.dam=self:GetAbility():GetSpecialValueFor( "dam" )
    if not IsServer() then
        return
    end
     self.pos={}
     self.h=1500
    local caster=self:GetParent()
    local caster_pos=caster:GetAbsOrigin()
    caster:AddNoDraw()
    self.pos[1]= Vector(caster_pos.x+500,caster_pos.y,caster_pos.z+150)
    self.pos[2]= Vector(caster_pos.x-500,caster_pos.y,caster_pos.z+150)
    self.pos[3]= Vector(caster_pos.x,caster_pos.y-500,caster_pos.z+150)
    self.pos[4]= Vector(caster_pos.x,caster_pos.y+500,caster_pos.z+150)
    if  caster:Has_Aghanims_Shard() then
        self.h=150
        self.pos[1]= Vector(caster_pos.x+2000,caster_pos.y,caster_pos.z+100)
        self.pos[2]= Vector(caster_pos.x-2000,caster_pos.y,caster_pos.z+100)
        self.pos[3]= Vector(caster_pos.x,caster_pos.y-2000,caster_pos.z+100)
        self.pos[4]= Vector(caster_pos.x,caster_pos.y+2000,caster_pos.z+100)
    end
    for num=1,#self.pos do
        local fx = ParticleManager:CreateParticle( "particles/heros/phoenix/phoenix_sunray_solar_forge.vpcf", PATTACH_WORLDORIGIN, nil )
        ParticleManager:SetParticleControl(fx, 0, caster_pos+caster:GetUpVector()*self.h)
        ParticleManager:SetParticleControl(fx, 1,self.pos[num])
        ParticleManager:SetParticleControl(fx, 2,self.pos[num])
        ParticleManager:SetParticleControl(fx, 3,self.pos[num])
        ParticleManager:SetParticleControl(fx, 9,self.pos[num])
        self:AddParticle(fx, false, false, 20, false, false)
        AddFOWViewer(caster:GetTeamNumber(),self.pos[num], 300, 5, false)
    end
    self:StartIntervalThink(tick)
end

function modifier_supernova_buff:OnIntervalThink()
    for num=1,#self.pos do
        local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self.pos[num],
            nil,
            150+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_5"),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false )
        for _, hero in pairs(heros) do
            local damageTable = {
                victim = hero,
                attacker = self:GetParent(),
                damage = self.dam,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
            }
            ApplyDamage(damageTable)
        end
    end
end

function modifier_supernova_buff:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveNoDraw()
end

function modifier_supernova_buff:CheckState()
    return
    {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

modifier_supernova_buff2=class({})
function modifier_supernova_buff2:IsBuff()
    return true
end

function modifier_supernova_buff2:IsHidden()
    return false
end

function modifier_supernova_buff2:IsPurgable()
    return false
end

function modifier_supernova_buff2:IsPurgeException()
    return false
end

function modifier_supernova_buff2:OnCreated()
    local att_num=self:GetAbility():GetSpecialValueFor( "att_num" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_8")
    local tick=self:GetAbility():GetSpecialValueFor( "tick" )
    self.DAM=self:GetAbility():GetSpecialValueFor( "dam" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_6")
    self.HP_MAX=self:GetAbility():GetSpecialValueFor( "hpmax" )
    self.HPMAX=0
    if not IsServer() then
        return
    end
    self:GetParent():SetBaseMaxHealth(att_num)
    self:GetParent():SetMaxHealth(att_num)
    self:GetParent():SetHealth(att_num)
    local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( fx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControl(fx, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx, 61, Vector(1,1,1))
    self:AddParticle(fx, false, false, -1, false, false)
    self:StartIntervalThink(tick)
end

function modifier_supernova_buff2:OnIntervalThink()
	if not IsServer() then
		return
	end
	local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
		nil,
		1200,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false )
    for _, hero in pairs(heros) do
        if hero:IsRealHero() then
            self.HPMAX=self.HPMAX+hero:GetMaxHealth()*0.01*self.HP_MAX
        end
		local damageTable = {
			victim = hero,
			attacker = self:GetParent().phoenix,
			damage = self.DAM,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
		ApplyDamage(damageTable)
	end
end

function modifier_supernova_buff2:OnDestroy()
    if  IsServer() then
        if self:GetParent():GetHealth()>0 then
            local caster=self:GetParent().phoenix
            local caster_pos=caster:GetAbsOrigin()
            local stun=self:GetAbility():GetSpecialValueFor( "stun" )
            local rd=self:GetAbility():GetSpecialValueFor( "rd" )+caster:GetCastRangeBonus()
            caster:StopSound("Hero_Phoenix.SuperNova.Cast")
            caster:StopSound("Hero_Phoenix.SuperNova.Begin")
            caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
            local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
            ParticleManager:SetParticleControl( fx, 0, caster_pos )
            ParticleManager:SetParticleControl( fx, 1, Vector(1.5,1.5,1.5) )
            ParticleManager:SetParticleControl( fx, 3,caster_pos )
            ParticleManager:ReleaseParticleIndex(fx)
            GridNav:DestroyTreesAroundPoint(caster_pos ,rd , false)
            caster:Purge( true, true, true, true, true )
            caster:SetHealth( caster:GetMaxHealth())
            caster:SetMana(caster:GetMaxMana())
            if caster:HasScepter() then
                caster:AddNewModifier(caster, self:GetAbility(), "modifier_supernova_buff3", {hp= self.HPMAX})
            end
            for i=0,10 do
                local ab = caster:GetAbilityByIndex(i)
                ab:RefreshCharges()
                if ab~=nil and ab:GetName()~="supernova" then
                    ab:EndCooldown()
                end
            end

            local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster_pos,
            nil,
            rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false )
        for _, hero in pairs(heros) do
            hero:AddNewModifier_RS(caster, self:GetAbility(), "modifier_stunned", {duration=stun})
        end
        end
    end
end

function modifier_supernova_buff2:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_supernova_buff2:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_supernova_buff2:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if  tg.target == self:GetParent() and not tg.attacker:IsBuilding() and not tg.attacker:IsCreep() and not tg.attacker:IsNeutralUnitType() then
        if self:GetParent():GetHealth()>0 then
            self:GetParent():SetHealth(self:GetParent():GetHealth() - 1)
        elseif self:GetParent():GetHealth()<=0 then
            self:GetParent():Kill(self:GetAbility(), tg.attacker)
        end
	end
end

function modifier_supernova_buff2:OnDeath(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent() then
        local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_WORLDORIGIN, nil)
        local attach_hitloc = self:GetParent().phoenix:ScriptLookupAttachment( "attach_hitloc" )
        ParticleManager:SetParticleControl( fx, 0,  self:GetParent().phoenix:GetAttachmentOrigin(attach_hitloc) )
        ParticleManager:SetParticleControl( fx, 1,  self:GetParent().phoenix:GetAttachmentOrigin(attach_hitloc) )
        ParticleManager:SetParticleControl( fx, 3,  self:GetParent().phoenix:GetAttachmentOrigin(attach_hitloc) )
        ParticleManager:ReleaseParticleIndex(fx)
        self:GetParent().phoenix:RemoveModifierByName("modifier_supernova_buff3")
        self:GetParent().phoenix:Kill(self:GetAbility(), tg.attacker)
    end
end

function modifier_supernova_buff2:GetDisableHealing()
    return 1
end

function modifier_supernova_buff2:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_supernova_buff2:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_supernova_buff2:GetAbsoluteNoDamagePure()
    return 1
end

modifier_supernova_buff3=class({})

function modifier_supernova_buff3:IsHidden()
    return false
end

function modifier_supernova_buff3:IsPurgable()
    return false
end

function modifier_supernova_buff3:IsPurgeException()
    return false
end

function modifier_supernova_buff3:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(self:GetStackCount()+tg.hp)
end

function modifier_supernova_buff3:OnRefresh(tg)
    self:OnCreated(tg)
end


function modifier_supernova_buff3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_supernova_buff3:GetModifierExtraHealthBonus()
    return self:GetStackCount()
end