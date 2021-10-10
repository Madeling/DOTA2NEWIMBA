
CreateTalents("npc_dota_hero_sand_king", "heros/hero_sand_king/burrowstrike.lua")
burrowstrike=class({})
LinkLuaModifier("modifier_caustic_finale_debuff", "heros/hero_sand_king/caustic_finale.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burrowstrike", "heros/hero_sand_king/burrowstrike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_burrowstrike_2", "heros/hero_sand_king/burrowstrike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function burrowstrike:IsHiddenWhenStolen()
    return false
end

function burrowstrike:IsStealable()
    return true
end

function burrowstrike:IsRefreshable()
    return true
end

function burrowstrike:GetCastRange()
    local caster = self:GetCaster()
    if caster:HasScepter() then
        return self:GetSpecialValueFor("cast_range_scepter")+caster:GetCastRangeBonus()
    end
    return self:GetSpecialValueFor("cast_range")+caster:GetCastRangeBonus()
end

function burrowstrike:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
    local curpos = self:GetCursorPosition()
    local sp =caster:HasScepter() and 5000 or self:GetSpecialValueFor("burrow_speed")
    local dis=TG_Distance(casterpos,curpos)
    local dir=TG_Direction(curpos,casterpos)
    local time=dis/sp
    local dir1,dir2,pos1,pos2,dis1,dis2,t1,t2,null1,null2
    caster.burrowstrike=caster:GetName()
    caster:SetForwardVector(dir)
    if dis>800 or (caster:HasModifier("modifier_sand_storm_inv")) then
        pos1=casterpos+caster:GetRightVector()*700
        pos2=casterpos+caster:GetRightVector()*-700
        null1=CreateUnitByName("npc_sand_king_unit", pos1, true, caster, caster, caster:GetTeamNumber())
        null2=CreateUnitByName("npc_sand_king_unit", pos2, true, caster, caster, caster:GetTeamNumber())
        dir1=TG_Direction(curpos,pos1)
        dir2=TG_Direction(curpos,pos2)
        dis1=TG_Distance(pos1,curpos)
        t1=dis1/sp
        null1:AddNewModifier(caster, self, "modifier_burrowstrike", {duration = t1, dir = dir1,pos=curpos})
        null1:AddNewModifier(caster, self, "modifier_kill", {duration = t1})
        null2:AddNewModifier(caster, self, "modifier_burrowstrike", {duration = t1, dir = dir2,pos=curpos})
        null2:AddNewModifier(caster, self, "modifier_kill", {duration = t1})
    end
    EmitSoundOn( "Ability.SandKing_BurrowStrike", caster )
	caster:AddNewModifier(caster, self, "modifier_burrowstrike", {duration = time, dir = dir,pos=curpos})
end


modifier_burrowstrike=class({})

function modifier_burrowstrike:IsHidden()
    return true
end

function modifier_burrowstrike:IsPurgable()
    return false
end

function modifier_burrowstrike:IsPurgeException()
    return false
end

function modifier_burrowstrike:RemoveOnDeath()
    return false
end

function modifier_burrowstrike:GetMotionPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_burrowstrike:OnCreated(tg)
    if not self:GetAbility() then
        return
    end
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.burrow_speed=self.caster:HasScepter() and 5000 or self.ability:GetSpecialValueFor("burrow_speed")
    self.burrow_duration=self.ability:GetSpecialValueFor("burrow_duration")
    self.burrow_width=self.ability:GetSpecialValueFor("burrow_width")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.target_table={}
    self.h=100
    self.is_sand_king=self.parent:GetName()==self.caster.burrowstrike and true or false
    if not IsServer() then
        return
    end
    self.ab=self.caster:FindAbilityByName("caustic_finale")
    if self.ab and self.ab:GetLevel()>0 then
        self.dur=self.ab:GetSpecialValueFor("caustic_finale_duration")
    end
    self.POS=self.parent:GetAbsOrigin()
    self.DIR=ToVector(tg.dir)
    local fx = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControl(fx, 0, self.POS)
	ParticleManager:SetParticleControl(fx, 1, ToVector(tg.pos))
	ParticleManager:ReleaseParticleIndex(fx)
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_SAND_KING_BURROW_IN,1)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
end

function modifier_burrowstrike:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_burrowstrike:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.parent:IsAlive() then
        local pos=self.parent:GetAbsOrigin()
        self.parent:SetAbsOrigin(pos+self.DIR* (self.burrow_speed / (1.0 / FrameTime())))
        local targets = FindUnitsInRadius(
            self.team,
            pos,
            nil,
            self.burrow_width,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #targets>0 then
            for _, target in pairs(targets) do
                if not Is_DATA_TG(self.target_table,target) then
                    table.insert(self.target_table, target)
                        local damageTable=
                        {
                            victim = target,
                            attacker = self.caster,
                            damage = self.is_sand_king and self.damage or self.damage/2 ,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self.ability,
                        }
                        ApplyDamage(damageTable)
                    local  Knockback ={
                            should_stun = true,
                            knockback_duration = 0.5,
                            duration = 0.5,
                            knockback_distance = 10,
                            knockback_height = self.h,
                            center_x = target:GetAbsOrigin().x,
                            center_y = target:GetAbsOrigin().y,
                            center_z = target:GetAbsOrigin().z
                        }
                        if self.caster:Has_Aghanims_Shard()then
                            target:AddNewModifier(self.caster, self.ab, "modifier_caustic_finale_debuff", {duration=self.dur})
                        end
                        target:AddNewModifier(self.caster,self.ability, "modifier_knockback", Knockback)
                        target:AddNewModifier(self.caster,self.ability, "modifier_imba_stunned", {duration= self.is_sand_king and self.burrow_duration or self.burrow_duration/2})
                        self.h=self.h+60
                end
            end
        end
    end
end

function modifier_burrowstrike:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_burrowstrike:OnDestroy()
    if not IsServer() then
        return
    end
    if self.parent:GetName()=="npc_dota_hero_sand_king" then
        self.parent:RemoveGesture(ACT_DOTA_SAND_KING_BURROW_IN)
        self.parent:StartGestureWithPlaybackRate(ACT_DOTA_SAND_KING_BURROW_OUT,2)
    end
    if self.caster.burrowstrike and self.parent:GetName()==self.caster.burrowstrike and self.ability:GetAutoCastState() and self.caster:TG_HasTalent("special_bonus_sand_king_6") then
        local sp=self.caster:HasScepter() and 5000 or self.ability:GetSpecialValueFor("burrow_speed")
        local dis=TG_Distance(self.POS,self.parent:GetAbsOrigin())
        local time=dis/sp
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_burrowstrike_2", {duration = time, dir = self.DIR*-1,pos=self.POS})
    end
    self.parent:RemoveHorizontalMotionController(self)
end

function modifier_burrowstrike:CheckState()
    return
    {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end


modifier_burrowstrike_2=class({})

function modifier_burrowstrike_2:IsHidden()
    return true
end

function modifier_burrowstrike_2:IsPurgable()
    return false
end

function modifier_burrowstrike_2:IsPurgeException()
    return false
end

function modifier_burrowstrike_2:RemoveOnDeath()
    return false
end

function modifier_burrowstrike_2:GetMotionPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_burrowstrike_2:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.burrow_speed=self.caster:HasScepter() and 5000 or self.ability:GetSpecialValueFor("burrow_speed")
    self.burrow_duration=self.ability:GetSpecialValueFor("burrow_duration")
    self.burrow_width=self.ability:GetSpecialValueFor("burrow_width")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.target_table={}
    self.h=100
    self.is_sand_king=self.parent:GetName()==self.caster.burrowstrike and true or false
    if not IsServer() then
        return
    end
    self.ab=self.caster:FindAbilityByName("caustic_finale")
    if self.ab and self.ab:GetLevel()>0 then
        self.dur=self.ab:GetSpecialValueFor("caustic_finale_duration")
    end
    self.POS=self.parent:GetAbsOrigin()
    self.DIR=ToVector(tg.dir)
    local fx = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControl(fx, 0, self.POS)
	ParticleManager:SetParticleControl(fx, 1, ToVector(tg.pos))
	ParticleManager:ReleaseParticleIndex(fx)
    self.parent:StartGestureWithPlaybackRate(ACT_DOTA_SAND_KING_BURROW_IN,1)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
end

function modifier_burrowstrike_2:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_burrowstrike_2:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.parent:IsAlive() then
        local pos=self.parent:GetAbsOrigin()
        self.parent:SetAbsOrigin(pos+self.DIR* (self.burrow_speed / (1.0 / FrameTime())))
        local targets = FindUnitsInRadius(
            self.team,
            pos,
            nil,
            self.burrow_width,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #targets>0 then
            for _, target in pairs(targets) do
                if not Is_DATA_TG(self.target_table,target) then
                    table.insert(self.target_table, target)
                    local  Knockback ={
                            should_stun = true,
                            knockback_duration = 0.5,
                            duration = 0.5,
                            knockback_distance = 10,
                            knockback_height = self.h,
                            center_x = target:GetAbsOrigin().x,
                            center_y = target:GetAbsOrigin().y,
                            center_z = target:GetAbsOrigin().z
                        }
                        if self.caster:Has_Aghanims_Shard() and self.ab and self.ab:GetLevel()>0 then
                            target:AddNewModifier_RS(self.caster, self.ab, "modifier_caustic_finale_debuff", {duration=self.dur or 7})
                        end
                        target:AddNewModifier_RS(self.caster,self.ability, "modifier_knockback", Knockback)
                        target:AddNewModifier_RS(self.caster,self.ability, "modifier_imba_stunned", {duration= self.is_sand_king and self.burrow_duration or self.burrow_duration/2})
                        local damageTable=
                        {
                            victim = target,
                            attacker = self.caster,
                            damage = self.is_sand_king and self.damage or self.damage/2 ,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self.ability,
                        }
                        ApplyDamage(damageTable)
                        self.h=self.h+100
                end
            end
        end
    end
end

function modifier_burrowstrike_2:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_burrowstrike_2:OnDestroy()
    if not IsServer() then
        return
    end
    if self.parent:GetName()=="npc_dota_hero_sand_king" then
        self.parent:RemoveGesture(ACT_DOTA_SAND_KING_BURROW_IN)
        self.parent:StartGestureWithPlaybackRate(ACT_DOTA_SAND_KING_BURROW_OUT,2)
    end
    self:GetParent():RemoveHorizontalMotionController(self)

end

function modifier_burrowstrike_2:CheckState()
    return
    {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end