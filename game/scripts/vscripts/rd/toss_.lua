toss_=class({})

function toss_:IsHiddenWhenStolen() 
    return false 
end

function toss_:IsStealable() 
    return true 
end


function toss_:IsRefreshable() 			
    return true 
end

function toss_:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
end



function toss_:OnSpellStart()
    local cur_tar=self:GetCursorTarget()
    local caster=self:GetCaster() 
    local pos=caster:GetAbsOrigin()
    local pos1=cur_tar:GetAbsOrigin()
    local dir=TG_Direction(pos1,pos)
    EmitSoundOn("TG.jump", caster)
    local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", PATTACH_OVERHEAD_FOLLOW,caster)
    ParticleManager:SetParticleControl(fx, 0, pos)
    ParticleManager:ReleaseParticleIndex(fx)
    caster:AddNewModifier(caster,self, "modifier_invulnerable", {duration=1})
    if self.rdbuff==nil then   
        self.rdbuff={
            "modifier_rune_doubledamage_tg",
            "modifier_rune_flying_haste",
            "modifier_rune_super_invis",
            "modifier_rune_super_regen",
        }
    end 
    local  Knockback ={
        should_stun = false,
        knockback_duration = 1,
        duration = 1,
        knockback_distance = TG_Distance(pos,pos1),
        knockback_height = 300,
        center_x =  pos.x-dir.x,
        center_y =  pos.y-dir.y,
        center_z =  pos.z
    }
    caster:AddNewModifier(caster,self, "modifier_knockback", Knockback)
    caster:AddNewModifier(caster,self, self.rdbuff[math.random(1, #self.rdbuff)], {duration=self:GetSpecialValueFor("rune")})
end