ghostship_storm=class({})
LinkLuaModifier("modifier_ghostship_storm", "heros/hero_kunkka/ghostship_storm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghostship_storm_buff", "heros/hero_kunkka/ghostship_storm.lua", LUA_MODIFIER_MOTION_NONE)

function ghostship_storm:IsHiddenWhenStolen()
    return false
end

function ghostship_storm:IsStealable()
    return true
end

function ghostship_storm:IsRefreshable()
    return true
end

function ghostship_storm:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:HasScepter() then
		self:SetLevel(1)
        self:SetHidden(false)
    else
        self:SetLevel(1)
        self:SetHidden(true)
    end
end


function ghostship_storm:OnSpellStart()
    local caster=self:GetCaster()
    local cur_pos=self:GetCursorPosition()
    local num=0
    EmitSoundOn("kunkka_kunk_ability_ghostshp_01", caster)
    EmitSoundOn("Ability.Ghostship", caster)
    Timers:CreateTimer(0, function()
        num=num+1
        local POS=Vector(cur_pos.x+math.random(-600,600),cur_pos.y+math.random(-600,600),cur_pos.z)
        local DIR=TG_Direction(POS,Vector(cur_pos.x+math.random(-1500,1500),cur_pos.y+math.random(-1500,1500),cur_pos.z))
        local projectile = {
            Ability = self,
            EffectName = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf",
            vSpawnOrigin =POS,
            fDistance = 2000,
            fStartRadius = 350,
            fEndRadius = 350,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            bProvidesVision = true,
            iVisionRadius = 500,
            iVisionTeamNumber = caster:GetTeamNumber(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            vVelocity = DIR*1000,
        }
        ProjectileManager:CreateLinearProjectile(projectile)
        if num==(6+self:GetCaster():TG_GetTalentValue("special_bonus_kunkka_5")) then
            return nil
        end
    return 0.25
end)
end

function ghostship_storm:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
    if hTarget==nil then
        return
    end
   if not Is_Chinese_TG(hTarget,self:GetCaster()) then
    if not hTarget:IsMagicImmune() then
        hTarget:AddNewModifier_RS(self:GetCaster(),self,"modifier_stunned",{duration=1})
        local damageTable = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage =150,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
            }
        ApplyDamage(damageTable)
    end
   end
end