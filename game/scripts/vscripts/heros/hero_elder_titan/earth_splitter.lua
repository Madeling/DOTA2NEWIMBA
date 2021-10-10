earth_splitter=class({})
LinkLuaModifier("modifier_earth_splitter", "heros/hero_elder_titan/earth_splitter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_splitter_debuff", "heros/hero_elder_titan/earth_splitter.lua", LUA_MODIFIER_MOTION_NONE)
function earth_splitter:IsHiddenWhenStolen()
    return false
end

function earth_splitter:IsStealable()
    return true
end

function earth_splitter:IsRefreshable()
    return true
end

function earth_splitter:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local cur_pos = self:GetCursorPosition()
    local t=self:GetSpecialValueFor("t")
    local wh=self:GetSpecialValueFor("wh")+caster:TG_GetTalentValue("special_bonus_elder_titan_6")
    local dam=self:GetSpecialValueFor("dam")+caster:TG_GetTalentValue("special_bonus_elder_titan_5")
    local stun_dur=self:GetSpecialValueFor("stun_dur")+caster:TG_GetTalentValue("special_bonus_elder_titan_7")
    local knock=self:GetSpecialValueFor("knockback")
    local dis=self:GetSpecialValueFor("dis")*2
    local dir=TG_Direction(cur_pos,caster_pos)
    local pos = caster_pos + dir * dis
    local team=caster:GetTeam()
    local damageTable = {
        attacker = caster,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    }
    local damageTable2 = {
        attacker = caster,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    }
    local Knockback ={
        should_stun = false,
        knockback_duration = 0.2,
        duration = 0.2,
        knockback_distance = knock,
        knockback_height = 300,
    }

    EmitSoundOn( "Hero_ElderTitan.EarthSplitter.Cast", caster )

    local particle= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_2021/elder_titan_2021_earth_splitter.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,caster_pos)
    ParticleManager:SetParticleControl(particle, 1,pos)
    ParticleManager:SetParticleControl(particle, 3,Vector(0,t,0))
    ParticleManager:SetParticleControl(particle, 60,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
    ParticleManager:SetParticleControl(particle, 61,Vector(1,1,1))
     ParticleManager:ReleaseParticleIndex( particle )
    Timers:CreateTimer(t, function()
        EmitSoundOn("Hero_ElderTitan.EarthSplitter.Destroy", caster )
        local heros = FindUnitsInLine(
            team,
            caster_pos,
            pos,
            caster,
            wh,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        for _,hero in pairs(heros) do
            local dam2=hero:GetMaxHealth()*dam*0.01/2
            damageTable.victim = hero
            damageTable.damage = dam2
            ApplyDamage(damageTable)
            damageTable2.victim = hero
            damageTable2.damage = dam2
            ApplyDamage(damageTable2)
            hero:AddNewModifier(caster, self, "modifier_imba_stunned", {duration =stun_dur})
            GridNav:DestroyTreesAroundPoint(cur_pos, 300, false)
            local dir=TG_Direction(hero:GetAbsOrigin(),caster:GetAbsOrigin())
            Knockback.center_x =  hero:GetAbsOrigin().x+dir.x
            Knockback.center_y =  hero:GetAbsOrigin().y+dir.y
            Knockback.center_z =  caster:GetAbsOrigin().z
            hero:AddNewModifier(caster,self, "modifier_knockback", Knockback)
            if caster:Has_Aghanims_Shard() then
                hero:AddNewModifier(caster,self, "modifier_earth_splitter_debuff", {duration=2.5})
            end
        end
        return nil
    end)
end


modifier_earth_splitter_debuff=class({})

function modifier_earth_splitter_debuff:IsDebuff()
	return true
end

function modifier_earth_splitter_debuff:IsHidden()
	return false
end

function modifier_earth_splitter_debuff:IsPurgable()
	return false
end

function modifier_earth_splitter_debuff:IsPurgeException()
	return false
end

function modifier_earth_splitter_debuff:CheckState()
    return
    {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
end