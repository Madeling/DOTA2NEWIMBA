CreateTalents("npc_dota_hero_windrunner", "heros/hero_windrunner/shackleshot.lua")
shackleshot=shackleshot or class({})
LinkLuaModifier("modifier_shackleshot_tree", "heros/hero_windrunner/shackleshot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shackleshot_buff", "heros/hero_windrunner/shackleshot.lua", LUA_MODIFIER_MOTION_NONE)

function shackleshot:IsHiddenWhenStolen()
    return false
end

function shackleshot:IsStealable()
    return true
end

function shackleshot:IsRefreshable()
    return true
end


function shackleshot:OnSpellStart()
    local caster=self:GetCaster()
    local team=caster:GetTeamNumber()
    local casterpos=caster:GetAbsOrigin()
    local dis=self:GetSpecialValueFor("dis")
    self.curpos=self:GetCursorPosition()
    self.right=caster:GetRightVector()*(dis/2)
    self.left=caster:GetRightVector()*-(dis/2)
    EmitSoundOn("Hero_Windrunner.ShackleshotCast", caster)
    AddFOWViewer(caster:GetTeamNumber(),self.curpos, 1000, 3, false)
    local NULL1=CreateUnitByName("npc_dummy_unit", self.curpos+self.right, false, nil, nil, team)
    local NULL2=CreateUnitByName("npc_dummy_unit", self.curpos+self.left, false, nil, nil, team)

    local projectileTable1 =
	{
		Target = NULL1,
		Source = caster,
		Ability = self,
		EffectName = "particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc = casterpos,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
	}
    ProjectileManager:CreateTrackingProjectile(projectileTable1)

    local projectileTable2 =
	{
		Target = NULL2,
		Source = caster,
		Ability = self,
		EffectName = "particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc =casterpos,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
	}
    ProjectileManager:CreateTrackingProjectile(projectileTable2)
end


function shackleshot:OnProjectileHit(target, location)
    local caster=self:GetCaster()
    local  tl=self.curpos+self.right
    local  tr=self.curpos+self.left
    local dur=self:GetSpecialValueFor("treedur")
    if self.TREETABLE==nil then
        self.TREETABLE=
    {
        "models/props_tree/newbloom_tree.vmdl",
        "models/props_tree/frostivus_tree.vmdl",
        "models/props_tree/tree_pine_04.vmdl",
    }
    end
    local treemodel=self.TREETABLE[RandomInt(1, #self.TREETABLE)]
    local tree1=CreateTempTreeWithModel(tl,dur,treemodel)
    local tree2=CreateTempTreeWithModel( tr,dur,treemodel)
    local ct1=tree1:GetAbsOrigin() + tree1:GetUpVector()*150
    local ct2=tree2:GetAbsOrigin() + tree2:GetUpVector()*150
    local spdur=self:GetSpecialValueFor("spdur")
    local stun=self:GetSpecialValueFor("stun")
    local time=0
    Timers:CreateTimer({
		useGameTime = false,
		endTime =0,
		callback = function()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0,ct1)
    ParticleManager:SetParticleControl(pfx, 1,ct2)
    ParticleManager:SetParticleControl(pfx, 2, Vector(dur,0,0))
    local Knockback ={}
            Timers:CreateTimer(0, function()
                local enemies1 = FindUnitsInLine(caster:GetTeam(),  ct1, ct2, caster, self:GetSpecialValueFor("wh"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
                if #enemies1>0 then
                    for _,tar in pairs(enemies1) do
                            Knockback ={
                                should_stun = false,
                                knockback_duration = 0.5,
                                duration = 0.5,
                                knockback_distance = 200,
                                knockback_height = 300,
                                center_x =  tar:GetAbsOrigin().x+tar:GetForwardVector(),
                                center_y =  tar:GetAbsOrigin().y+tar:GetRightVector(),
                                center_z =  tar:GetAbsOrigin().z
                            }
                            tar:AddNewModifier(caster, self, "modifier_shackleshot_tree", {duration=spdur})
                            tar:AddNewModifier(caster, self, "modifier_shackleshot_buff", {duration=spdur})
                        if not tar:HasModifier("modifier_knockback") then
                            tar:AddNewModifier_RS(tar,self, "modifier_knockback", Knockback)
                        end
                    end
                end
                  if time>=dur then
                     ParticleManager:DestroyParticle(pfx, true)
                     ParticleManager:ReleaseParticleIndex(pfx)
                     pfx=nil
                     return nil
                else
                    time=time+0.1
                    return 0.1
                end
            end)



    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(),nil,self:GetSpecialValueFor("stunrd"),DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
    for _,tar in pairs(enemies) do
           pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, nil)
           ParticleManager:SetParticleControlEnt(pfx, 0, tar, PATTACH_POINT, "attach_hitloc", tar:GetAbsOrigin(), true)
           ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + target:GetUpVector()*150)
           ParticleManager:SetParticleControl(pfx, 2, Vector(stun,0,0))
           EmitSoundOn("Hero_Windrunner.ShackleshotBind", target)
           tar:AddNewModifier(caster, self, "modifier_stunned", {duration=stun})
        end
    end
})
end


modifier_shackleshot_tree=modifier_shackleshot_tree or class({})

function modifier_shackleshot_tree:IsDebuff()
    return true
end
function modifier_shackleshot_tree:IsPurgable()
    return true
end
function modifier_shackleshot_tree:IsPurgeException()
    return true
end
function modifier_shackleshot_tree:IsHidden()
    return false
end

function modifier_shackleshot_tree:RemoveOnDeath()
	return true
end

function modifier_shackleshot_tree:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

	}

end
function modifier_shackleshot_tree:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("sp")

end




modifier_shackleshot_buff=modifier_shackleshot_buff or class({})


function modifier_shackleshot_buff:IsPurgable()
    return false
end
function modifier_shackleshot_buff:IsPurgeException()
    return false
end
function modifier_shackleshot_buff:IsHidden()
    return true
end

function modifier_shackleshot_buff:RemoveOnDeath()
	return true
end

function modifier_shackleshot_buff:RemoveOnDeath()
	return true
end

function modifier_shackleshot_buff:CheckState()
    return
     {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

end