sprout=class({})

LinkLuaModifier("modifier_sprout", "heros/hero_furion/sprout.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sprout_tree", "heros/hero_furion/sprout.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sprout_tree_p", "heros/hero_furion/sprout.lua", LUA_MODIFIER_MOTION_NONE)
function sprout:IsHiddenWhenStolen() 
    return false 
end

function sprout:IsStealable() 
    return true 
end


function sprout:IsRefreshable() 			
    return true 
end


function sprout:OnSpellStart()
    local caster=self:GetCaster() 
    local team=caster:GetTeamNumber()
    local pos=self:GetCursorPosition() 
    local target=self:GetCursorTarget() 
    local duration=self:GetSpecialValueFor("duration")
    local vision_range=self:GetSpecialValueFor("vision_range")
    local num=0
    local num1=-400
    EmitSoundOn("Hero_Furion.Sprout", caster)
    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil) 
    ParticleManager:SetParticleControl(pf, 0, pos)
    ParticleManager:ReleaseParticleIndex( pf )
    AddFOWViewer(team, pos, vision_range, duration, false)
    if target~=nil and (target:GetClassname()=="dota_temp_tree" or  target:GetClassname()=="ent_dota_tree")  then   
        CreateModifierThinker(caster, self, "modifier_sprout_tree_p",{duration=duration}, pos, team, false)
    end 
        CreateModifierThinker(caster, self, "modifier_sprout_tree",{duration=duration}, pos, team, false)
        for a=1,8 do 
            CreateTempTree(RotatePosition(pos, QAngle(0, num, 0), pos+caster:GetForwardVector() * 160), duration)
            num=num+45
        end 
        if caster:Has_Aghanims_Shard() then
            local heros = FindUnitsInRadius(team, pos, nil,400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            if #heros>0 then 
                for _,hero in pairs(heros) do
                    if not hero:IsMagicImmune() then    
                       FindClearSpaceForUnit(hero, pos, false)
                    end
                end
            end
        end
end

function sprout:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
    caster:PerformAttack(target, true, true, true, false, false, false, false)
end

modifier_sprout_tree_p=class({})

function modifier_sprout_tree_p:IsPurgable() 			
    return false 
end

function modifier_sprout_tree_p:IsPurgeException() 	
    return false 
end

function modifier_sprout_tree_p:IsHidden()				
    return true 
end

function modifier_sprout_tree_p:OnCreated(tg)	
    self.ability=self:GetAbility()	
    self.caster=self:GetCaster()	
    self.parent=self:GetParent()	
    self.team=self.caster:GetTeamNumber()		
    if IsServer() then
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end 
end

function modifier_sprout_tree_p:OnIntervalThink()				
    local heros = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil,700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #heros>0 then 
        for _,hero in pairs(heros) do
            local P = 
            {
                Target = hero,
                Source = self.parent,
                Ability = self.ability,	
                EffectName = "particles/units/heroes/hero_rubick/rubick_tree_proj.vpcf",
                iMoveSpeed = 1200,
                vSourceLoc = self.parent:GetAbsOrigin(),
                bDrawsOnMinimap = false,
                bDodgeable = false,
                bIsAttack = false,
                bVisibleToEnemies = true,
                bReplaceExisting = false,
                bProvidesVision = false,
            }
            ProjectileManager:CreateTrackingProjectile(P)
        end
    end
end

modifier_sprout_tree=class({})

function modifier_sprout_tree:IsPurgable() 			
    return false 
end

function modifier_sprout_tree:IsPurgeException() 	
    return false 
end

function modifier_sprout_tree:IsHidden()				
    return true 
end

function modifier_sprout_tree:OnCreated(tg)	
    self.ability=self:GetAbility()	
    self.caster=self:GetCaster()	
    self.parent=self:GetParent()	
    self.team=self.caster:GetTeamNumber()		
    if IsServer() then
        self:OnIntervalThink()
        self:StartIntervalThink(0.5)
    end 
end

function modifier_sprout_tree:OnIntervalThink()				
    local heros = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil,300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #heros>0 then 
        for _,target in pairs(heros) do
            target:AddNewModifier(self.caster, self.ability, "modifier_sprout", {duration=0.6})
        end
    end
end

modifier_sprout=class({})

function modifier_sprout:IsPurgable() 			
    return false 
end

function modifier_sprout:IsPurgeException() 	
    return false 
end

function modifier_sprout:IsHidden()				
    return true 
end

function modifier_sprout:CheckState() 
	return 
	{
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true, 
	} 
end