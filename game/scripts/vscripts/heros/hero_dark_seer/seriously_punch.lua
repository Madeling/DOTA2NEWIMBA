seriously_punch=class({})
LinkLuaModifier("modifier_seriously_punch", "heros/hero_dark_seer/seriously_punch.lua", LUA_MODIFIER_MOTION_NONE)

function seriously_punch:IsHiddenWhenStolen() 
    return false 
end

function seriously_punch:IsStealable() 
    return true 
end

function seriously_punch:GetIntrinsicModifierName() 
    return "modifier_seriously_punch" 
end


function seriously_punch:IsRefreshable() 			
    return true 
end

function seriously_punch:OnSpellStart(tg)
    local caster=self:GetCaster() 
    local caster_pos=caster:GetAbsOrigin()
    local target=self:GetCursorTarget() 
    local team=caster:GetTeamNumber()
    if not target and not tg  then  return end 
    if not target  then  target=tg end 
    if not caster:TG_HasTalent("special_bonus_dark_seer_5") then
        if  target:TG_TriggerSpellAbsorb(self)   then
            return
        end    
    end
    local damageTable = {
        attacker = caster,
        damage_type = DAMAGE_TYPE_PURE,
        damage =  self:GetSpecialValueFor("dam"),
        ability = self,
    }
    local Knockback ={
        should_stun = false,
        knockback_duration = 1,
        duration = 1,
        knockback_distance = 10,
        knockback_height = 1000,
    }
    caster:EmitSound("TG.B")
    local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf", PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl(particle, 0,caster_pos)
    ParticleManager:SetParticleControl(particle, 2,caster_pos)
    ParticleManager:ReleaseParticleIndex( particle )
    local enemies = FindUnitsInLine(team, caster_pos,caster_pos+caster:GetForwardVector()*600, caster, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
    if #enemies>0 then
        if caster:TG_HasTalent("special_bonus_dark_seer_6") then
            damageTable.damage=damageTable.damage+#enemies*40
        end 
        for _,target in pairs(enemies) do
            Knockback.center_x = caster:GetAbsOrigin().x
            Knockback.center_y = caster:GetAbsOrigin().y
            Knockback.center_z = caster:GetAbsOrigin().z
            target:AddNewModifier(caster,self, "modifier_knockback", Knockback)
            damageTable.victim = target
            ApplyDamage(damageTable)
        end
    end
      if PseudoRandom:RollPseudoRandom(self, 2) and target:IsRealHero() then
        EmitGlobalSound("TG.punch")
        Notifications:BottomToAll({text = "One Punch", duration = 4.0, style = {["font-size"] = "100px", color = "#CD2626"}})
        local enemies = FindUnitsInLine(team, caster_pos, caster_pos+caster:GetForwardVector()*25000,caster, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		for _,target in pairs(enemies) do
            if target:IsAlive() then 
                TG_Kill(caster,target,self)
            end 
        end
      end
end


modifier_seriously_punch=class({})

function modifier_seriously_punch:IsPassive()
	return true
end

function modifier_seriously_punch:IsPurgable() 			
    return false 
end

function modifier_seriously_punch:IsPurgeException() 	
    return false 
end

function modifier_seriously_punch:IsHidden()				
    return true 
end

function modifier_seriously_punch:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
end

function modifier_seriously_punch:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_seriously_punch:OnAttackLanded(tg)
    if not IsServer() then
        return
	end  
    if tg.attacker == self.parent and self.ability and self.ability:GetAutoCastState() and self.ability:GetLevel()>0 and self.ability:IsOwnersManaEnough() and self.ability:IsCooldownReady() and not tg.target:IsBuilding() then
        self.ability:OnSpellStart(tg.target)
        self.ability:UseResources(true, false, true)
    end
end