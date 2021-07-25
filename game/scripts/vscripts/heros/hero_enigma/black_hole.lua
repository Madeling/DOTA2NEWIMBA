black_hole=class({})
LinkLuaModifier("modifier_black_hole_singularity", "heros/hero_enigma/black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_hole_buff", "heros/hero_enigma/black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_hole_debuff", "heros/hero_enigma/black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_black_hole_debuff2", "heros/hero_enigma/black_hole.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_midnight_pulse_debuff2", "heros/hero_enigma/black_hole.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bkb_buff", "items/item_bkb.lua", LUA_MODIFIER_MOTION_NONE)
function black_hole:IsHiddenWhenStolen()
    return false
end

function black_hole:IsStealable()
    return true
end

function black_hole:IsRefreshable()
    return true
end

function black_hole:GetAOERadius()
    return self:GetSpecialValueFor("pull_radius")
end

function black_hole:OnOwnerSpawned()
    self:GetCaster():StopSound("Hero_Enigma.Black_Hole")
end

function black_hole:OnOwnerDied()
    self:GetCaster():StopSound("Hero_Enigma.Black_Hole")
end

function black_hole:GetIntrinsicModifierName()
    return "modifier_black_hole_singularity"
end


function black_hole:OnSpellStart()
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    local team =caster:GetTeamNumber()
    local duration =self:GetSpecialValueFor("duration")
    local radius =self:GetSpecialValueFor("pull_radius")
    local vision_radius =self:GetSpecialValueFor("vision_radius")
    caster.black_holestart=true
    caster:StopSound("Hero_Enigma.Black_Hole")
    caster:EmitSound("Hero_Enigma.BlackHole.Cast")
    GridNav:DestroyTreesAroundPoint(cur_pos, radius, false)
    if caster:HasScepter() then
        caster:EmitSound("Hero_Enigma.Midnight_Pulse")
        CreateModifierThinker(caster, self, "modifier_midnight_pulse_debuff2", {duration=duration,radius=1000,damage_percent=self:GetSpecialValueFor("damage_percent")}, cur_pos, team, false)
    end
    if caster:Has_Aghanims_Shard() then
        caster:AddNewModifier(caster, self, "modifier_item_bkb_buff", {duration=1.5})
    end
    caster:AddNewModifier(caster, self, "modifier_black_hole_buff", {duration=duration})
    AddFOWViewer(team, cur_pos, vision_radius, duration, true)
    caster.black_holeent=CreateModifierThinker(caster, self, "modifier_black_hole_debuff", {duration=duration,radius=radius}, cur_pos, team, false)
    local ab=caster:FindAbilityByName("midnight_pulse")
    --[[if ab and ab:GetAutoCastState() and ab:GetLevel()>0 and ab:IsOwnersManaEnough() and ab:IsCooldownReady() then
        ab:OnSpellStart()
        ab:UseResources(true, false, true)
    end]]
end

function black_hole:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()
    if  bInterrupted then
        local modifier=caster.black_holeent:FindModifierByName("modifier_black_hole_debuff")
        if modifier then
            modifier:SetDuration(0, true)
        end
    end
    caster:StopSound("Hero_Enigma.Black_Hole")
end

modifier_black_hole_debuff= class({})


function modifier_black_hole_debuff:IsHidden()
    return true
end

function modifier_black_hole_debuff:IsPurgable()
    return false
end

function modifier_black_hole_debuff:IsPurgeException()
    return false
end



function modifier_black_hole_debuff:OnCreated(tg)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.damage= self.ability:GetSpecialValueFor("damage")/2
    if  IsServer() then
    self.radius=tg.radius
    self.pos=self.parent:GetAbsOrigin()
    local fx= ParticleManager:CreateParticle(
        "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf",
        PATTACH_CUSTOMORIGIN,
        nil)
    ParticleManager:SetParticleControl(fx, 0,  self.pos+self.parent:GetUpVector()*100)
    ParticleManager:SetParticleControl(fx, 3,  self.pos)
    self:AddParticle(fx, false, false, -1, false, false)
    self.mod=self.caster:FindModifierByName("modifier_black_hole_singularity")
    if self.mod then
    local heros = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.pos,
        nil,
        self.radius+self.mod:GetStackCount()*15,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)
        if #heros>0 then
            self.mod:SetStackCount(self.mod:GetStackCount()+#heros)
        end
        self.radius=self.radius+self.mod:GetStackCount()*15
        if RollPseudoRandomPercentage(2,0,self.parent) then
            self.radius=25000
            self.parent:EmitSound("Hero_Enigma.BlackHole.Cast.Chasm")
        end
    end
    self:OnIntervalThink()
    self:StartIntervalThink(0.5)
    end
end

function modifier_black_hole_debuff:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if hero~=nil and hero:IsAlive() and not hero:HasModifier("modifier_fountain_aura_buff") then
                    local damageTable = {
                        attacker = self.caster,
                        damage =  self.damage,
                        victim = hero,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self.ability,
                        }
                        ApplyDamage(damageTable)
                if not hero:HasModifier("modifier_black_hole_debuff2") and hero:IsAlive()  then
                    hero:AddNewModifier(self.caster, self.ability, "modifier_black_hole_debuff2", {pos=self.pos,sp=800})
                end
            end
        end
    end
end

function modifier_black_hole_debuff:OnDestroy()
    if  IsServer() then
        self.caster.black_holestart=false
        if self.caster:HasModifier("modifier_black_hole_buff") then
            self.caster:RemoveModifierByName("modifier_black_hole_buff")
        end
    end
end

modifier_black_hole_debuff2= class({})

function modifier_black_hole_debuff2:IsDebuff()
    return true
end

function modifier_black_hole_debuff2:IsHidden()
    return false
end

function modifier_black_hole_debuff2:IsPurgable()
    return false
end

function modifier_black_hole_debuff2:IsPurgeException()
    return false
end

function modifier_black_hole_debuff2:RemoveOnDeath()
	return false
end

function modifier_black_hole_debuff2:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_black_hole_debuff2:OnCreated(tg)
    if not IsServer() then
        return
    end

    self.POS=self:GetParent():GetAbsOrigin()
    self.CENTER= ToVector(tg.pos)
    self.DIR= TG_Direction2(self.CENTER,self.POS)
    self.ST = GameRules:GetGameTime()
    self:GetParent():SetForwardVector(self.DIR)
    self.ROT=true
    self.SP=tg.sp
    local fx= ParticleManager:CreateParticleForPlayer(
        "particles/tgp/enigma/screen_black_hole0.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetParent(),self:GetParent():GetPlayerOwner())
    ParticleManager:SetParticleControl(fx, 0,  self.POS)
    self:AddParticle(fx, false, false, -1, false, false)
        if not self:ApplyHorizontalMotionController() then
            self:Destroy()
        end
end


function modifier_black_hole_debuff2:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    if  self:GetCaster().black_holestart==false or not self:GetParent():IsAlive() then
        self:Destroy()
    else
        local dis=TG_Distance(self:GetParent():GetAbsOrigin(), self.CENTER)
        if  dis>100 and self.ROT then
            self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR*( self.SP/(1/g)))
        else
                self.ROT=false
                local p=((GameRules:GetGameTime()-self.ST)/2)* 14
                self:GetParent():SetAbsOrigin(self.CENTER+ self:GetParent():GetRightVector()* (math.sin( p ) *80) + self.DIR * (-math.cos( p )*80))
        end
    end
end


function modifier_black_hole_debuff2:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
        if  self:GetParent():IsAlive() then
            self:GetParent():SetAngles(0, 0, 0)
            FindClearSpaceForUnit( self:GetParent(),  self:GetParent():GetAbsOrigin(), true)
        end
    end
end

function modifier_black_hole_debuff2:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end


function modifier_black_hole_debuff2:DeclareFunctions()
	return
		{
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION
		}
end

function modifier_black_hole_debuff2:GetOverrideAnimation()
    return ACT_DOTA_FLAIL
end

function modifier_black_hole_debuff2:CheckState()
    return
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end


modifier_black_hole_buff=class({})

function modifier_black_hole_buff:IsHidden()
    return true
end

function modifier_black_hole_buff:IsPurgable()
    return false
end

function modifier_black_hole_buff:IsPurgeException()
    return false
end

function modifier_black_hole_buff:RemoveOnDeath()
    return true
end

function modifier_black_hole_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound("Hero_Enigma.Black_Hole")
end
function modifier_black_hole_buff:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():StopSound("Hero_Enigma.Black_Hole")
    self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
end



modifier_midnight_pulse_debuff2= class({})

function modifier_midnight_pulse_debuff2:IsDebuff()
    return true
end

function modifier_midnight_pulse_debuff2:IsHidden()
    return true
end

function modifier_midnight_pulse_debuff2:IsPurgable()
    return false
end

function modifier_midnight_pulse_debuff2:IsPurgeException()
    return false
end

function modifier_midnight_pulse_debuff2:OnCreated(tg)
    self.damageTable = {
        attacker = self:GetCaster(),
        damage_type =DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self:GetAbility(),
        }
    if not IsServer() then
        return
    end
    self.radius=tg.radius
    self.damage_percent=tg.damage_percent
    self.pos=self:GetParent():GetAbsOrigin()
    local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(fx, 0,  self.pos)
    ParticleManager:SetParticleControl(fx, 1, Vector(self.radius,self.radius,self.radius))
    self:AddParticle(fx, false, false, 20, false, false)
    self:StartIntervalThink(1)
end

function modifier_midnight_pulse_debuff2:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self.pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,
        false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if not Is_Chinese_TG( self:GetParent(),hero) and  not hero:IsBoss() then
                    self.damageTable.damage = hero:GetMaxHealth()*self.damage_percent*0.01
                    self.damageTable.victim = hero
                    ApplyDamage(self.damageTable)
            end
        end
    end
end


modifier_black_hole_singularity=class({})

function modifier_midnight_pulse_debuff2:IsHidden()
    return false
end

function modifier_midnight_pulse_debuff2:IsPurgable()
    return false
end

function modifier_midnight_pulse_debuff2:IsPurgeException()
    return false
end


function modifier_midnight_pulse_debuff2:RemoveOnDeath()
    return false
end

function modifier_midnight_pulse_debuff2:IsPermanent()
    return true
end