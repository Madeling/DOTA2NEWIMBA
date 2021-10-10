modifier_gold=class({})
function modifier_gold:IsDebuff()
    return false
end
function modifier_gold:IsHidden()
    return true
end
function modifier_gold:IsPurgable()
    return false
end
function modifier_gold:IsPurgeException()
    return false
end
function modifier_gold:RemoveOnDeath()
    return false
end
function modifier_gold:IsPermanent()
    return true
end
function modifier_gold:OnCreated()
      if IsServer() then
            self:GetParent():StartGesture(ACT_DOTA_IDLE)
            Timers:CreateTimer(60, function()
                    self:SpawnGoldEntity( Vector(0,0,0)+RandomVector(400) )
            return 60
            end)
            self:StartIntervalThink(1.5)
      end
end
function modifier_gold:OnIntervalThink()
			GetAllHero(function(hero)
				if hero  then
                    local level=hero:GetLevel()
                    local xp=0
                        if TG_Distance(hero:GetAbsOrigin(), Vector(0,0,0))<=1500 then
                                local xp=math.floor(10+GameRules:GetDOTATime(false, false)/100*40)
                                PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),3,false,DOTA_ModifyGold_Unspecified)
                                hero:AddExperience(xp, DOTA_ModifyXP_Unspecified, false, true)
                        else
                                local xp=math.floor(5+GameRules:GetDOTATime(false, false)/100*10)
                                PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),1,false,DOTA_ModifyGold_Unspecified)
                                hero:AddExperience(xp, DOTA_ModifyXP_Unspecified, false, true)
                        end
				end
			end)
end

function modifier_gold:SpawnGoldEntity( spawnPoint )
	EmitGlobalSound("Item.PickUpGemWorld")
	local nFXIndex = ParticleManager:CreateParticle( "particles/tgp/medical_m.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0,Vector(0,0,0))
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 400, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, spawnPoint  )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 20 )
end


function modifier_gold:KillLoot( item, drop )
	if drop:IsNull() then
		return
	end
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitGlobalSound("Item.PickUpWorld")
	UTIL_Remove( item )
	UTIL_Remove( drop )
end