fire_spirits = class({})
LinkLuaModifier("modifier_fire_spirits", "heros/hero_phoenix/fire_spirits.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function fire_spirits:IsHiddenWhenStolen() 
    return false 
end

function fire_spirits:IsStealable() 
    return true 
end


function fire_spirits:IsRefreshable() 			
    return true 
end

function fire_spirits:GetAssociatedSecondaryAbilities() 
    return "launch_fire_spirit" 
end

function fire_spirits:GetCooldown(tg) 
    if self:GetCaster():HasModifier("modifier_icarus_dive_move") or self:GetCaster():HasModifier("modifier_icarus_dive_move2") then 
        return self:GetSpecialValueFor( "cd" ) 
    else
        return self.BaseClass.GetCooldown(self, tg)
    end 
   
end

function fire_spirits:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local cur_pos=self:GetCursorPosition()
    local dis=TG_Distance(caster_pos,cur_pos)
    local dir=TG_Direction(cur_pos,caster_pos)
    local num=self:GetSpecialValueFor( "num" )+caster:TG_GetTalentValue("special_bonus_phoenix_2")
    caster:EmitSound("Hero_Phoenix.FireSpirits.Cast")
    if caster:GetHealth()>=10 then 
    caster:SetHealth( caster:GetHealth() * ( 100 - self:GetSpecialValueFor( "hp" ) ) / 100 )
end
	caster:AddNewModifier(caster, self, "modifier_fire_spirits", {duration=self:GetSpecialValueFor( "dur" )})
	caster.fire_spiritsfx=ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
 --   ParticleManager:SetParticleControl( caster.fire_spiritsfx, 0, caster_pos )
    ParticleManager:SetParticleControl( caster.fire_spiritsfx, 1, Vector( num, 0, 0 ) )
    ParticleManager:SetParticleControl( caster.fire_spiritsfx, 6, Vector( num, 0, 0 ) )
	for i=1,num do
		ParticleManager:SetParticleControl( caster.fire_spiritsfx, 8+i, Vector(1, 0, 0 ) )
    end
    caster:SwapAbilities( "fire_spirits", "launch_fire_spirit", false, true )
    local ab= caster:FindAbilityByName("launch_fire_spirit")
    if ab~=nil then ab:SetLevel(self:GetLevel()) end 
end

modifier_fire_spirits=class({})

function modifier_fire_spirits:IsHidden() 			
    return false 
end

function modifier_fire_spirits:IsPurgable() 			
    return false 
end

function modifier_fire_spirits:IsPurgeException() 	
    return false 
end

function modifier_fire_spirits:OnCreated() 	
    if not IsServer() then
        return
    end 
    self:SetStackCount(4+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_2"))
    self:GetParent():EmitSound("Hero_Phoenix.FireSpirits.Loop")
end

function modifier_fire_spirits:OnDestroy() 	
    if not IsServer() then
        return
    end 	
    self:GetParent():StopSound( "Hero_Phoenix.FireSpirits.Loop")
    if self:GetCaster().fire_spiritsfx~=nil then	
        ParticleManager:DestroyParticle(self:GetCaster().fire_spiritsfx, true )
        ParticleManager:ReleaseParticleIndex(self:GetCaster().fire_spiritsfx )
    end
    self:GetParent():SwapAbilities( "fire_spirits", "launch_fire_spirit", true, false )
end