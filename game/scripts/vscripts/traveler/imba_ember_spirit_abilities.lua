CreateTalents("npc_dota_hero_ember_spirit","traveler/ember_spirit_abilities.lua")
--------------------------------------------------------------------
-- 灰烬之灵
--------------------------------------------------------------------
    LinkLuaModifier("modifier_imba_ember_spirit_inheritance_of_Fire", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)



    LinkLuaModifier("modifier_imba_ember_spirit_searing_chains", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_searing_chains_pull", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_HORIZONTAL)



    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist_damage", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist_armor", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist_marker", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist_disarmed", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_sleight_of_fist_invulnerability", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)


    LinkLuaModifier("modifier_imba_ember_spirit_flame_guard", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)


    LinkLuaModifier("modifier_imba_ember_spirit_activate_fire_remnant", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
    LinkLuaModifier("modifier_imba_ember_spirit_activate_fire_remnant_damage", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)


    LinkLuaModifier("modifier_imba_ember_spirit_fire_remnant_burn", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_fire_remnant_burn_aura", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_fire_remnant", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_imba_ember_spirit_fire_remnant_timer", "traveler/ember_spirit_abilities.lua", LUA_MODIFIER_MOTION_NONE)

    

    imba_ember_spirit_inheritance_of_Fire = class({})
    imba_ember_spirit_searing_chains = class({})
    imba_ember_spirit_sleight_of_fist = class({})
    imba_ember_spirit_flame_guard = class({})
    imba_ember_spirit_activate_fire_remnant = class({})
    imba_ember_spirit_fire_remnant = class({})
    imba_ember_spirit_sleight_of_fist_charge = class({})
    imba_ember_spirit_fire_remnant_charge = class({})


    modifier_imba_ember_spirit_inheritance_of_Fire = class({})

    
    modifier_imba_ember_spirit_searing_chains = class({})
    modifier_imba_ember_spirit_searing_chains_pull = class({})

    modifier_imba_ember_spirit_sleight_of_fist = class({})
    modifier_imba_ember_spirit_sleight_of_fist_damage = class({})
    modifier_imba_ember_spirit_sleight_of_fist_armor = class({})
    modifier_imba_ember_spirit_sleight_of_fist_marker = class({})
    modifier_imba_ember_spirit_sleight_of_fist_invulnerability = class({})
    modifier_imba_ember_spirit_sleight_of_fist_disarmed = class({})


    modifier_imba_ember_spirit_flame_guard = class({})


    modifier_imba_ember_spirit_activate_fire_remnant = class({})
    modifier_imba_ember_spirit_activate_fire_remnant_damage = class({})


    modifier_imba_ember_spirit_fire_remnant = class({})
    modifier_imba_ember_spirit_fire_remnant_timer = class({})
    modifier_imba_ember_spirit_fire_remnant_burn = class({})
    modifier_imba_ember_spirit_fire_remnant_burn_aura = class({})


    --------------------------------------------------------------------
    --音效
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    -- 

    --------------------------------------------------------------------
    --台词
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    -- 

    --------------------------------------------------------------------
    --特效
    --------------------------------------------------------------------
    -- 
    -- 
    -- 
    -- 
    -- 
    --
    -- 
    -- 
    -- 
    -- 
    -- 
    --  
    
    --------------------------------------------------------------------
    -- 火之传承
    --------------------------------------------------------------------
        function imba_ember_spirit_inheritance_of_Fire:IsBuildinAbility()    return true end
        function imba_ember_spirit_inheritance_of_Fire:GetIntrinsicModifierName() return "modifier_imba_ember_spirit_inheritance_of_Fire" end
        --------------------------------------------------------------------
        -- 火之传承被动
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_inheritance_of_Fire:IsDebuff() return false end
        function modifier_imba_ember_spirit_inheritance_of_Fire:IsHidden() return false end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:IsPurgable() return false end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:DeclareFunctions() 
            return {
                MODIFIER_EVENT_ON_HERO_KILLED,
                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
                MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
            } 
        end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:OnHeroKilled(keys)
            if not IsServer() then return end
            if keys.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and keys.target:IsRealHero() and not keys.target:IsTempestDouble() then
                if keys.attacker == self:GetParent() or keys.target:HasModifier("modifier_imba_ember_spirit_searing_chains")
                    or keys.target:HasModifier("modifier_imba_ember_spirit_fire_remnant_burn") then
                    self:SetStackCount(self:GetStackCount() + self.killed_stack)
                    local flesh_heap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
                    ParticleManager:ReleaseParticleIndex(flesh_heap_pfx)
                end
            end
        end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:OnCreated()
            self.killed_stack = self:GetAbility():GetSpecialValueFor("killed_stack")
            self.stat_per_stack = self:GetAbility():GetSpecialValueFor("stat_per_stack")
            local caster = self:GetCaster()
            caster.chains_targets = false
            caster.chains_immune = false
            caster.chains_pull = false

            caster.fist_mkb = false
            caster.fist_dodge = false
            caster.fist_armor = false

            caster.guard_ms = false
            caster.guard_cd = false
            caster.guard_armor = false

            caster.remnant_cr = false
            caster.remnant_heal = false
            caster.remnant_dmg = false 
        end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:GetModifierBonusStats_Strength() 
            return self:GetStackCount() * self.stat_per_stack
        end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:GetModifierBonusStats_Agility()
            return self:GetStackCount() * self.stat_per_stack
        end
        function modifier_imba_ember_spirit_inheritance_of_Fire:GetModifierBonusStats_Intellect()
            return self:GetStackCount() * self.stat_per_stack
        end 
        function modifier_imba_ember_spirit_inheritance_of_Fire:OnStackCountChanged()
            local caster = self:GetCaster()
            local ability = self:GetAbility()
            local count = self:GetStackCount()

            local chains_targets_effect_stack = ability:GetSpecialValueFor("chains_targets_effect_stack")
            if count >= chains_targets_effect_stack and caster.chains_targets == false then
                caster.chains_targets = true
            end
            local chains_immune_effect_stack = ability:GetSpecialValueFor("chains_immune_effect_stack")
            if count >= chains_immune_effect_stack and caster.chains_immune == false then
                caster.chains_immune = true
            end
            local chains_pull_effect_stack = ability:GetSpecialValueFor("chains_pull_effect_stack")
            if count >= chains_pull_effect_stack and caster.chains_pull == false then
                caster.chains_pull = true
            end

            local fist_mkb_effect_stack = ability:GetSpecialValueFor("fist_mkb_effect_stack")
            if count >= fist_mkb_effect_stack and caster.fist_mkb == false then
                caster.fist_mkb = true
            end
            local fist_dodge_effect_stack = ability:GetSpecialValueFor("fist_dodge_effect_stack")
            if count >= fist_dodge_effect_stack and caster.fist_dodge == false then
                caster.fist_dodge = true
            end
            local fist_armor_effect_stack = ability:GetSpecialValueFor("fist_armor_effect_stack")
            if count >= fist_armor_effect_stack and caster.fist_armor == false then
                caster.fist_armor = true
            end

            local guard_ms_effect_stack = ability:GetSpecialValueFor("guard_ms_effect_stack")
            if count >= guard_ms_effect_stack and caster.guard_ms == false then
                caster.guard_ms = true
            end
            local guard_cd_effect_stack = ability:GetSpecialValueFor("guard_cd_effect_stack")
            if count >= guard_cd_effect_stack and caster.guard_cd == false then
                caster.guard_cd = true
            end
            local guard_armor_effect_stack = ability:GetSpecialValueFor("guard_armor_effect_stack")
            if count >= guard_armor_effect_stack and caster.guard_armor == false then
                caster.guard_armor = true
            end


            local remnant_dmg_effect_stack = ability:GetSpecialValueFor("remnant_dmg_effect_stack")
            if count >= remnant_dmg_effect_stack and caster.remnant_dmg == false then
                caster.remnant_dmg = true
            end
            local remnant_cr_effect_stack = ability:GetSpecialValueFor("remnant_cr_effect_stack")
            if count >= remnant_cr_effect_stack and caster.remnant_cr == false then
                caster.remnant_cr = true
            end
            local remnant_heal_effect_stack = ability:GetSpecialValueFor("remnant_heal_effect_stack")
            if count >= remnant_heal_effect_stack and caster.remnant_heal == false then
                caster.remnant_heal = true
            end

        end

    --------------------------------------------------------------------
    -- 炎阳索  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_searing_chains:IsHiddenWhenStolen()  return false end
        function imba_ember_spirit_searing_chains:IsRefreshable() return true end
        function imba_ember_spirit_searing_chains:IsStealable() return true end
        function imba_ember_spirit_searing_chains:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = caster:GetAbsOrigin()
            caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    caster:EmitSound("ember_spirit_embr_searingchains_0"..math.random(1,6))
                end
            end
            local radius = self:GetSpecialValueFor("radius")
            local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlForward(pfx, 0, caster:GetForwardVector())
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
            ParticleManager:ReleaseParticleIndex(pfx)            
            local duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_1")
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            if caster.chains_immune then
                flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
            end
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                flags, FIND_ANY_ORDER, false)
            local unit_count = self:GetSpecialValueFor("unit_count")
            if caster.chains_targets then
                unit_count = unit_count + self:GetSpecialValueFor("chains_targets")
            end
            local i = 0
            local effectname2 = "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf"
            for _,enemy in pairs( enemies ) do
                enemy:Stop()
                enemy:EmitSound("Hero_EmberSpirit.SearingChains.Target")
                enemy:AddNewModifier_Debuff( caster, self, "modifier_imba_ember_spirit_searing_chains", {duration = duration})
                if caster.chains_pull then
                    enemy:AddNewModifier_Debuff( caster, self, "modifier_imba_ember_spirit_searing_chains_pull", {duration = duration})
                end
                local pfx2 = ParticleManager:CreateParticle(effectname2, PATTACH_CUSTOMORIGIN, caster)
                ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(pfx2, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(pfx2)
                i = i + 1
                if i >= unit_count then
                    break
                end
            end
        end
        --------------------------------------------------------------------
        -- 炎阳索-缠绕
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_searing_chains:IsHidden() return false end
        function modifier_imba_ember_spirit_searing_chains:IsDebuff() return true end
        function modifier_imba_ember_spirit_searing_chains:IsPurgable() return false end
        function modifier_imba_ember_spirit_searing_chains:GetEffectName() return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf" end
        function modifier_imba_ember_spirit_searing_chains:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
        function modifier_imba_ember_spirit_searing_chains:OnCreated()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local duration = ability:GetSpecialValueFor("duration")
            local tick_interval = ability:GetSpecialValueFor("tick_interval")
            local total_damage = ability:GetSpecialValueFor("total_damage")
            self.damage_tick = (total_damage/duration)*tick_interval
            if IsServer() then
                self:StartIntervalThink( tick_interval )
                parent:AddNewModifier( caster, ability, "modifier_truesight", { duration = self:GetDuration()})
                AddFOWViewer( caster:GetTeamNumber(), parent:GetAbsOrigin(), 200, duration, false )
            end
        end
        function modifier_imba_ember_spirit_searing_chains:OnRefresh()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local duration = ability:GetSpecialValueFor("duration")
            local tick_interval = ability:GetSpecialValueFor("tick_interval")
            local total_damage = ability:GetSpecialValueFor("total_damage")
            self.damage_tick = (total_damage/duration)*tick_interval
        end
        function modifier_imba_ember_spirit_searing_chains:OnIntervalThink()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = self.damage_tick, damage_type = ability:GetAbilityDamageType()})
        end
        function modifier_imba_ember_spirit_searing_chains:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
        --------------------------------------------------------------------
        -- 炎阳索-牵引
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_searing_chains_pull:IsHidden() return true end
        function modifier_imba_ember_spirit_searing_chains_pull:IsDebuff() return true end
        function modifier_imba_ember_spirit_searing_chains_pull:IsPurgable() return true end
        function modifier_imba_ember_spirit_searing_chains_pull:OnCreated()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if IsServer() then
                self.chains_pull = ability:GetSpecialValueFor("chains_pull")
                if self:ApplyHorizontalMotionController() then
                    self.center = caster:GetAbsOrigin()
                else
                    self:Destroy()
                end
            end
        end
        function modifier_imba_ember_spirit_searing_chains_pull:OnDestroy()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if IsServer() then
                parent:RemoveHorizontalMotionController(self)
            end
        end
        function modifier_imba_ember_spirit_searing_chains_pull:OnHorizontalMotionInterrupted() self:Destroy() end
        function modifier_imba_ember_spirit_searing_chains_pull:UpdateHorizontalMotion( parent, dt )
            if IsServer() then
                local center = self.center
                local pos = parent:GetAbsOrigin()
                local direction = ( center - pos ):Normalized()
                direction.z = 0
                local speed = self.chains_pull * dt
                local distance = ( center - pos ):Length2D()
                if distance >= speed then
                    parent:SetAbsOrigin( pos + direction*speed )
                else
                    parent:SetAbsOrigin( center )
                end
            end
        end
    --------------------------------------------------------------------
    -- 无影拳  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_sleight_of_fist:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_sleight_of_fist:IsStealable() return true end
        function imba_ember_spirit_sleight_of_fist:IsRefreshable() return true end
        function imba_ember_spirit_sleight_of_fist:GetAOERadius() return self:GetSpecialValueFor("radius") end
        function imba_ember_spirit_sleight_of_fist:OnInventoryContentsChanged()
            if IsServer() then
                local caster = self:GetCaster()
                if caster:HasScepterShard() and not self.bSwap then
                    caster:SwapAbilities( "imba_ember_spirit_sleight_of_fist", "imba_ember_spirit_sleight_of_fist_charge", false, true )
                    self.bSwap = true
                end
            end
        end
        function imba_ember_spirit_sleight_of_fist:OnAbilityPhaseStart()
            local caster = self:GetCaster()
            if caster:HasModifier("modifier_imba_ember_spirit_activate_fire_remnant") then --无影拳不能中断激活残焰
                return false
            end
            return true
        end
        function imba_ember_spirit_sleight_of_fist:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            local radius = self:GetAOERadius()
            caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,28)
                    if i < 10 then
                        caster:EmitSound("ember_spirit_embr_sleightoffist_0"..i)
                    else
                        caster:EmitSound("ember_spirit_embr_sleightoffist_"..i)
                    end
                end
            end
            local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, pos)
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
            ParticleManager:ReleaseParticleIndex(pfx)
            caster:InterruptMotionControllers(true)
            caster:AddNewModifier(caster, self, "modifier_imba_ember_spirit_sleight_of_fist", { x=pos.x, y=pos.y, z=pos.z })
        end
        --------------------------------------------------------------------
        -- 无影拳-斩击
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist:IsHidden() return false end
        function modifier_imba_ember_spirit_sleight_of_fist:IsDebuff() return false end
        function modifier_imba_ember_spirit_sleight_of_fist:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist:OnCreated(keys)
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if not IsServer() then return end
            local attack_interval = ability:GetSpecialValueFor("attack_interval")
            local radius = ability:GetAOERadius()
            local pos = Vector( keys.x, keys.y, keys.z )
            self.caster_pos = caster:GetAbsOrigin()
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
            self.enemies = enemies
            if #enemies > 0 then
                local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf"
                local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, self.caster_pos)
                ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.caster_pos, true)
                ParticleManager:SetParticleControlForward(pfx, 1, parent:GetForwardVector())
                self:AddParticle(pfx, false, false, -1, false, false)
                ability:SetActivated(false)
                parent:AddNoDraw()
                if caster.fist_dodge then
                    ProjectileManager:ProjectileDodge( parent )
                end
                parent:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_disarmed", {} )
                parent:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_invulnerability", {} )
                for _,enemy in pairs( enemies ) do
                    enemy:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_marker", {} )
                end
                self:OnIntervalThink()
                self:StartIntervalThink( attack_interval )
            else
                self:Destroy()
            end
        end
        function modifier_imba_ember_spirit_sleight_of_fist:OnIntervalThink()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local target = nil
            for i=#self.enemies,1,-1 do  
                local enemy = self.enemies[i]
                table.remove(self.enemies, i)
                enemy:RemoveModifierByName("modifier_imba_ember_spirit_sleight_of_fist_marker")
                if UnitFilter(enemy, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, caster:GetTeamNumber()) == UF_SUCCESS then
                    target = enemy
                    break
                end
            end
            if target == nil then self:Destroy() return end
            local start_pos = parent:GetAbsOrigin()
            local target_pos = target:GetAbsOrigin()
            local direction = ( self.caster_pos - target_pos ):Normalized()
            direction.z = 0
            local pos = target_pos + direction*50
            parent:SetAbsOrigin( pos )
            local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, start_pos)
            ParticleManager:SetParticleControl(pfx, 1, pos)
            ParticleManager:ReleaseParticleIndex(pfx)
            parent:RemoveModifierByName( "modifier_imba_ember_spirit_sleight_of_fist_disarmed" )
            if not parent:IsDisarmed() then
                parent:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_damage", { target = target:entindex() })
                if caster.fist_armor then
                    target:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_armor", {} )
                end
                parent:PerformAttack( target, true, true, true, false, false, false, caster.fist_mkb )
                target:RemoveModifierByName( "modifier_imba_ember_spirit_sleight_of_fist_armor" )
                parent:RemoveModifierByName( "modifier_imba_ember_spirit_sleight_of_fist_damage" )
            end
            parent:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_sleight_of_fist_disarmed", {} )
            target:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")
            local effectname2 = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
            local pfx2 = ParticleManager:CreateParticle(effectname2, PATTACH_CUSTOMORIGIN, target)
            ParticleManager:SetParticleControlEnt(pfx2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(pfx2)
        end
        function modifier_imba_ember_spirit_sleight_of_fist:OnDestroy()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if IsServer() then
                local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
                local pfx = ParticleManager:CreateParticle(effectname, PATTACH_WORLDORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, self.caster_pos)
                ParticleManager:SetParticleControl(pfx, 1, parent:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(pfx)
                if #self.enemies <= 0 then -- 激活残焰时，灰烬之灵无需返回原位置
                    FindClearSpaceForUnit(parent, self.caster_pos, true)
                end
                ability:SetActivated(true)
                parent:RemoveNoDraw()
                parent:RemoveModifierByName("modifier_imba_ember_spirit_sleight_of_fist_disarmed")
                parent:RemoveModifierByName("modifier_imba_ember_spirit_sleight_of_fist_invulnerability")
                for i=#self.enemies,1,-1 do  
                    local enemy = self.enemies[i]
                    table.remove(self.enemies, i)
                    enemy:RemoveModifierByName("modifier_imba_ember_spirit_sleight_of_fist_marker")
                end
            end
        end
        --------------------------------------------------------------------
        -- 无影拳-缴械
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist_disarmed:IsHidden() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_disarmed:IsDebuff() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_disarmed:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_disarmed:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
        --------------------------------------------------------------------
        -- 无影拳-无敌
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist_invulnerability:IsDebuff() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_invulnerability:IsHidden() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_invulnerability:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_invulnerability:CheckState()
            return {
                [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                [MODIFIER_STATE_INVULNERABLE] = true,
                [MODIFIER_STATE_UNSELECTABLE] = true,
                [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                [MODIFIER_STATE_NO_HEALTH_BAR] = true
            }
        end
        --------------------------------------------------------------------
        -- 无影拳-攻击伤害
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist_damage:IsDebuff() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:IsHidden() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:OnCreated( keys )
            if IsServer() then
                local caster = self:GetCaster()
                local parent = self:GetParent()
                local ability = self:GetAbility()
                local target = EntIndexToHScript( keys.target )
                self.bHero = target:IsHero()
                self.bonus_hero_damage = ability:GetSpecialValueFor("bonus_hero_damage") + caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_2")
                self.creep_damage_penalty = ability:GetSpecialValueFor("creep_damage_penalty")
            end
        end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:DeclareFunctions()
            return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
        end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:GetModifierPreAttack_BonusDamage()
            if IsServer() and self.bHero then
                return self.bonus_hero_damage
            end
        end
        function modifier_imba_ember_spirit_sleight_of_fist_damage:GetModifierDamageOutgoing_Percentage()
            if IsServer() and not self.bHero then
                return self.creep_damage_penalty
            end
        end
        --------------------------------------------------------------------
        -- 无影拳-无视护甲
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist_armor:IsDebuff() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_armor:IsHidden() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_armor:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_armor:OnCreated()
            local ability = self:GetAbility()
            self.fist_armor = -ability:GetSpecialValueFor("fist_armor")
        end
        function modifier_imba_ember_spirit_sleight_of_fist_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
        function modifier_imba_ember_spirit_sleight_of_fist_armor:GetModifierPhysicalArmorBonus() return IsServer() and self.fist_armor or nil end
        --------------------------------------------------------------------
        -- 无影拳-标记
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_sleight_of_fist_marker:IsDebuff() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_marker:IsPurgable() return false end
        function modifier_imba_ember_spirit_sleight_of_fist_marker:IsHidden() return true end
        function modifier_imba_ember_spirit_sleight_of_fist_marker:GetEffectName() return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf" end
        function modifier_imba_ember_spirit_sleight_of_fist_marker:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
    --------------------------------------------------------------------
    -- 无影拳-充能  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_sleight_of_fist_charge:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_sleight_of_fist_charge:IsStealable() return true end
        function imba_ember_spirit_sleight_of_fist_charge:IsRefreshable() return true end
        function imba_ember_spirit_sleight_of_fist_charge:GetAOERadius() return self:GetSpecialValueFor("radius") end
        function imba_ember_spirit_sleight_of_fist_charge:OnAbilityPhaseStart()
            local caster = self:GetCaster()
            if caster:HasModifier("modifier_imba_ember_spirit_activate_fire_remnant") then --无影拳不能中断激活残焰
                return false
            end
            return true
        end
        function imba_ember_spirit_sleight_of_fist_charge:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            local radius = self:GetAOERadius()
            caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,28)
                    if i < 10 then
                        caster:EmitSound("ember_spirit_embr_sleightoffist_0"..i)
                    else
                        caster:EmitSound("ember_spirit_embr_sleightoffist_"..i)
                    end
                end
            end
            local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
            local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pfx, 0, pos)
            ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
            ParticleManager:ReleaseParticleIndex(pfx)
            caster:InterruptMotionControllers(true)
            caster:AddNewModifier(caster, self, "modifier_imba_ember_spirit_sleight_of_fist", { x=pos.x, y=pos.y, z=pos.z })
        end
    --------------------------------------------------------------------
    -- 烈火罩  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_flame_guard:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_flame_guard:IsStealable() return true end
        function imba_ember_spirit_flame_guard:IsRefreshable() return true end
        function imba_ember_spirit_flame_guard:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
        function imba_ember_spirit_flame_guard:GetCooldown(lv) 
            local caster = self:GetCaster()
            if caster.guard_cd then
                return self.BaseClass.GetCooldown(self, lv) - self:GetSpecialValueFor("guard_cd")
            else
                return self.BaseClass.GetCooldown(self, lv) 
            end
        end
        function imba_ember_spirit_flame_guard:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local duration = self:GetSpecialValueFor("duration")
            caster:RemoveModifierByName("modifier_imba_ember_spirit_flame_guard")
            caster:AddNewModifier( caster, self, "modifier_imba_ember_spirit_flame_guard", {duration = duration})
            caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,5)
                    caster:EmitSound("ember_spirit_embr_flameguard_0"..i)
                end
            end
        end
        --------------------------------------------------------------------
        -- 烈火罩
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_flame_guard:IsHidden() return false end
        function modifier_imba_ember_spirit_flame_guard:IsPurgable() return true end
        function modifier_imba_ember_spirit_flame_guard:IsDebuff() return false end
        function modifier_imba_ember_spirit_flame_guard:OnCreated()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            self.guard_ms = caster.guard_ms and ability:GetSpecialValueFor("guard_ms") or 0
            self.guard_armor = caster.guard_armor and ability:GetSpecialValueFor("guard_armor") or 0
            if IsServer() then
                parent:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")
                local absorb_amount = ability:GetSpecialValueFor("absorb_amount")
                local tick_interval = ability:GetSpecialValueFor("tick_interval")
                local damage_per_second = ability:GetSpecialValueFor("damage_per_second")
                if caster:HasScepter() then
                    local scepter_absorb_amount_increase_pct = ability:GetSpecialValueFor("scepter_absorb_amount_increase_pct")
                    local stats = caster:GetAgility() + caster:GetIntellect() + caster:GetStrength()
                    absorb_amount = absorb_amount + stats * scepter_absorb_amount_increase_pct/100
                    damage_per_second = damage_per_second + ability:GetSpecialValueFor("scepter_damage_per_second_increase")
                end
                self.absorb_amount = absorb_amount
                self:SetStackCount( absorb_amount )
                self.radius = ability:GetSpecialValueFor("radius")
                self.damage_tick = damage_per_second * tick_interval
                self:StartIntervalThink( tick_interval )
                local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
                local pfx = ParticleManager:CreateParticle( effectname, PATTACH_ABSORIGIN_FOLLOW, parent)
                ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius, 0, 0))
                ParticleManager:SetParticleControl(pfx, 3, Vector(parent:GetModelRadius(), 0, 0))
                self:AddParticle(pfx, false, false, -1, false, false)
                if caster:TG_HasTalent("special_bonus_imba_ember_spirit_3") then
                    parent:Purge( false, true, false, false, false )
                end
            end
        end
        function modifier_imba_ember_spirit_flame_guard:DeclareFunctions() 
            return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK} 
        end
        function modifier_imba_ember_spirit_flame_guard:GetModifierMagical_ConstantBlock( keys )
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if not parent:IsMagicImmune() and keys.damage > 0 then
                local block = self:GetStackCount()
                local absorb_amount = block - keys.damage
                if absorb_amount > 0 then
                    self:SetStackCount( absorb_amount )
                else
                    self:Destroy()
                end
                return block 
            end 
        end
        function modifier_imba_ember_spirit_flame_guard:GetModifierMoveSpeedBonus_Percentage() return self.guard_ms end
        function modifier_imba_ember_spirit_flame_guard:GetModifierPhysicalArmorBonus() return self.guard_armor end
        function modifier_imba_ember_spirit_flame_guard:OnIntervalThink()
            if not IsServer then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            local enemies = FindUnitsInRadius( parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _, enemy in pairs(enemies) do
                ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage_type = ability:GetAbilityDamageType(), damage = self.damage_tick})
            end
        end
        function modifier_imba_ember_spirit_flame_guard:OnDestroy()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            parent:StopSound("Hero_EmberSpirit.FlameGuard.Loop")
            if caster:HasScepter() then
                local scepter_explosion_damage_pct = ability:GetSpecialValueFor("scepter_explosion_damage_pct")
                local damage = self.absorb_amount * scepter_explosion_damage_pct/100
                local enemies = FindUnitsInRadius( parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                for _, enemy in pairs(enemies) do
                    ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage_type = ability:GetAbilityDamageType(), damage = damage})
                end
            end
        end
    --------------------------------------------------------------------
    -- 天赋6
    --------------------------------------------------------------------
       --[[ function modifier_special_bonus_imba_ember_spirit_6:OnCreated()
            if IsServer() then
                local parent = self:GetParent()
                parent:SwapAbilities( "imba_ember_spirit_fire_remnant", "imba_ember_spirit_fire_remnant_charge", false, true )
            end
        end]]
    --------------------------------------------------------------------
    -- 残焰  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_fire_remnant:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_fire_remnant:IsStealable() return true end
        function imba_ember_spirit_fire_remnant:IsRefreshable() return true end
        function imba_ember_spirit_fire_remnant:OnUpgrade()
            if IsServer() then 
                local caster = self:GetCaster()
                local ability = caster:FindAbilityByName("imba_ember_spirit_activate_fire_remnant")
                if ability and ability:GetLevel() ~= self:GetLevel() then
                    ability:SetLevel(self:GetLevel())
                end
            end
        end
        function imba_ember_spirit_fire_remnant:GetCastRange(location , target)
            local  caster = self:GetCaster()
            if caster.remnant_cr then
                return self.BaseClass.GetCastRange(self, location , target) * self:GetSpecialValueFor("remnant_cr")
            else
                return self.BaseClass.GetCastRange(self, location , target)
            end
        end
        function imba_ember_spirit_fire_remnant:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,7)
                    caster:EmitSound("ember_spirit_embr_fireremsend_0"..i)
                end
            end
            self:CastFireRemnant( pos )
        end
        function imba_ember_spirit_fire_remnant:OnHeroDiedNearby( unit, attacker, keys )
            if not IsServer() then return end
            local caster = self:GetCaster()
            if caster:TG_HasTalent("special_bonus_imba_ember_spirit_5") then
                local distance = caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_5")
                if unit:GetTeamNumber() ~= caster:GetTeamNumber() and (unit:IsRealHero() or unit:IsClone()) and ((attacker == caster) or (CalcDistanceBetweenEntityOBB(caster,unit) <= distance)) then 
                    self:CastFireRemnant( unit:GetAbsOrigin() )
                    return
                end
            end
        end
        function imba_ember_spirit_fire_remnant:CastFireRemnant( pos )
            local caster = self:GetCaster()
            local duration = self:GetSpecialValueFor("duration")
            local fire_remnant = CreateUnitByName("npc_dota_ember_spirit_remnant", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
            fire_remnant:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant", {} )
            fire_remnant:AddNewModifier( caster, self, "modifier_kill", {duration = duration}) 
            fire_remnant:SetDayTimeVisionRange( caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_7") )
            fire_remnant:SetNightTimeVisionRange( caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_7") )
            if caster:TG_HasTalent("special_bonus_imba_ember_spirit_4") then --灼烧
                fire_remnant:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant_burn_aura", {})
            end
            local mod = caster:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant_timer", {duration = duration})
            mod.fire_remnant = fire_remnant
            local start_pos = caster:GetAbsOrigin()
            local distance = ( start_pos - pos ):Length2D()
            local direction = ( pos - start_pos ):Normalized()
            direction.z = 0
            local speed_multiplier = self:GetSpecialValueFor("speed_multiplier")
            if caster.remnant_cr then
                speed_multiplier = speed_multiplier*self:GetSpecialValueFor("remnant_ms")
            end
            local speed = caster:GetMoveSpeedModifier( caster:GetBaseMoveSpeed(), false ) * speed_multiplier/100
            local velocity = speed * direction
            local info  = {
                Ability = self,
                EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
                vSpawnOrigin = start_pos,
                fDistance = distance,
                fStartRadius = 0,
                fEndRadius = 0,
                Source = caster,
                bHasFrontalCone = false,
                bReplaceExisting = false,
                iUnitTargetTeam = 0,
                iUnitTargetFlags = 0,
                iUnitTargetType = 0,
                bDeleteOnHit = false,
                vVelocity = velocity,
                bProvidesVision = false,
                ExtraData = {fire_remnant = fire_remnant:entindex()}
            }
            fire_remnant.proj = ProjectileManager:CreateLinearProjectile(info)
        end
        function imba_ember_spirit_fire_remnant:OnProjectileThink_ExtraData(pos, keys)
            if IsServer() and keys.fire_remnant and EntIndexToHScript(keys.fire_remnant) then
                EntIndexToHScript(keys.fire_remnant):SetAbsOrigin( pos )
            end
        end
        function imba_ember_spirit_fire_remnant:OnProjectileHit_ExtraData(target, pos, keys)
            if IsServer() and keys.fire_remnant and EntIndexToHScript(keys.fire_remnant) then
                local fire_remnant = EntIndexToHScript(keys.fire_remnant)
                if fire_remnant:IsAlive() then
                    fire_remnant:SetAbsOrigin( GetGroundPosition(pos, nil) )
                    fire_remnant:FindModifierByName("modifier_imba_ember_spirit_fire_remnant"):OnFireRemnantLanded()
                end
            end
        end
        --------------------------------------------------------------------
        -- 残焰-状态
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_fire_remnant:IsDebuff() return false end
        function modifier_imba_ember_spirit_fire_remnant:IsPurgable() return false end
        function modifier_imba_ember_spirit_fire_remnant:IsHidden() return true end
        function modifier_imba_ember_spirit_fire_remnant:OnFireRemnantLanded()
            if not IsServer() then return end
            local parent = self:GetParent()
            local caster = self:GetCaster()
            local ability = self:GetAbility()
            parent:EmitSound("Hero_EmberSpirit.Remnant.Appear")
            local i = RandomInt( 81, 83 )
            local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf"
            local pfx = ParticleManager:CreateParticle( effectname, PATTACH_CUSTOMORIGIN, parent)
            ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
            ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) --克隆英雄
            ParticleManager:SetParticleControl(pfx, 2, Vector( i, 0, 0) )
            self:AddParticle(pfx, false, false, -1, false, false)    
            parent.landed = true       
        end
        function modifier_imba_ember_spirit_fire_remnant:CheckState()
            return {
                [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                [MODIFIER_STATE_INVULNERABLE] = true,
                [MODIFIER_STATE_OUT_OF_GAME] = true,
                [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                [MODIFIER_STATE_UNSELECTABLE] = true,
                [MODIFIER_STATE_UNTARGETABLE] = true,
            }
        end
        --------------------------------------------------------------------
        -- 残焰-计时器
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_fire_remnant_timer:IsHidden() return false end
        function modifier_imba_ember_spirit_fire_remnant_timer:IsDebuff() return false end
        function modifier_imba_ember_spirit_fire_remnant_timer:IsPurgable() return false end
        function modifier_imba_ember_spirit_fire_remnant_timer:RemoveOnDeath() return false end
        function modifier_imba_ember_spirit_fire_remnant_timer:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
        --------------------------------------------------------------------
        -- 残焰-灼烧光环
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:IsDebuff() return false end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:IsHidden() return true end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:IsPurgable() return false end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:IsAura() return true end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:GetAuraRadius() return self.radius end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:GetModifierAura() return "modifier_imba_ember_spirit_fire_remnant_burn" end
        function modifier_imba_ember_spirit_fire_remnant_burn_aura:OnCreated()
            self.radius = self:GetCaster():TG_GetTalentValue("special_bonus_imba_ember_spirit_4", "range")
        end 
        --------------------------------------------------------------------
        -- 残焰-灼烧光环效果
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_fire_remnant_burn:IsHidden() return false end
        function modifier_imba_ember_spirit_fire_remnant_burn:IsDebuff() return true end
        function modifier_imba_ember_spirit_fire_remnant_burn:IsPurgable() return true end
        function modifier_imba_ember_spirit_fire_remnant_burn:OnCreated()
            if IsServer() then
                local caster = self:GetCaster()
                local ability = self:GetAbility()
                local interval = 0.5
                local damage = caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_4", "damage")
                self.damage = damage*interval
                self:StartIntervalThink( interval )
            end
        end
        function modifier_imba_ember_spirit_fire_remnant_burn:OnIntervalThink()
            if IsServer() then
                local caster = self:GetCaster()
                local parent = self:GetParent()
                local ability = self:GetAbility()
                ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = self.damage, damage_type = ability:GetAbilityDamageType()})
            end
        end
    --------------------------------------------------------------------
    -- 激活残焰  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_activate_fire_remnant:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_activate_fire_remnant:IsRefreshable() return true end
        function imba_ember_spirit_activate_fire_remnant:IsStealable() return false end
        function imba_ember_spirit_activate_fire_remnant:GetManaCost(i)
            local caster = self:GetCaster()
            if caster:TG_HasTalent("special_bonus_imba_ember_spirit_6") then
                return caster:TG_GetTalentValue( "special_bonus_imba_ember_spirit_6", "manacost" )
            else
                return self.BaseClass.GetManaCost(self, i)
            end
        end
        function imba_ember_spirit_activate_fire_remnant:CastFilterResultLocation(location)
            if IsServer() then
                local caster = self:GetCaster()
                if not caster:HasModifier("modifier_imba_ember_spirit_fire_remnant_timer") then
                    return UF_FAIL_CUSTOM
                end
                return UF_SUCCESS
            end
        end
        function imba_ember_spirit_activate_fire_remnant:GetCustomCastErrorLocation() return "#no fire remnant was found" end
        function imba_ember_spirit_activate_fire_remnant:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            local autoCast = self:GetAutoCastState() and 1 or 0
            caster:RemoveModifierByName( "modifier_imba_ember_spirit_sleight_of_fist" )
            caster:AddNewModifier( caster, self, "modifier_imba_ember_spirit_activate_fire_remnant", { autoCast = autoCast, x=pos.x, y=pos.y, z=pos.z })
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,20)
                    if i < 10 then
                        caster:EmitSound("ember_spirit_embr_fireremrun_0"..i)
                    else
                        caster:EmitSound("ember_spirit_embr_fireremrun_"..i)
                    end
                end
            end
        end
        --------------------------------------------------------------------
        -- 激活残焰-冲刺
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_activate_fire_remnant:IsHidden() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant:IsDebuff() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant:IsPurgable() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant:OnCreated( keys )
            local caster = self:GetCaster()
            local ability = self:GetAbility()
            if IsServer() then
                if self:ApplyHorizontalMotionController() then
                    self.start_pos = Vector( keys.x, keys.y, keys.z )
                    self.timer_mods = caster:FindAllModifiersByName("modifier_imba_ember_spirit_fire_remnant_timer")
                    if keys.autoCast == 1 then
                        self.count = 1 --激活次数
                    else 
                        self.count = #self.timer_mods
                    end
                    local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
                    local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, caster)
                    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                    self:AddParticle(pfx, false, false, -1, false, false)
                else
                    self:Destroy()
                end
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:CheckState() 
            return {
                [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
                [MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
                [MODIFIER_STATE_INVULNERABLE] = true, 
                [MODIFIER_STATE_UNSELECTABLE] = true, 
            } 
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:GetPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
        function modifier_imba_ember_spirit_activate_fire_remnant:UpdateHorizontalMotion( parent, dt )
            if IsServer() then
                if self.count <= 0 then self:Destroy() return end
                if self.target == nil then
                    self.target = self:LockFireRemnant( self.count )
                    if self.target == nil then self:Destroy() return end --应该不会有这种情况
                    self.speed = self:SetActivateSpeed( self.target )
                end
                local target_pos = self.target:GetAbsOrigin()
                local pos = parent:GetAbsOrigin()
                local direction = ( target_pos - pos ):Normalized()
                direction.z = 0
                local speed = self.speed * dt
                local distance = ( target_pos - pos ):Length2D()
                if distance >= speed then
                    parent:SetAbsOrigin( pos + direction*speed )
                else
                    parent:SetAbsOrigin( target_pos )
                    self:ActivateFireRemnant( self.target )   
                end
                GridNav:DestroyTreesAroundPoint( parent:GetAbsOrigin(), 200, false )
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:OnHorizontalMotionInterrupted() self:Destroy() end
        function modifier_imba_ember_spirit_activate_fire_remnant:OnDestroy()
            local caster = self:GetCaster()
            local parent = self:GetParent()
            local ability = self:GetAbility()
            if IsServer() then
                parent:RemoveHorizontalMotionController(self)
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:LockFireRemnant( count )
            if not IsServer() then return end
            local caster = self:GetCaster()
            local target = nil
            if count <= 0 then
                return target
            elseif count == 1 then -- 冲刺最近的残焰
                local distance = 999999 
                local mods = self.timer_mods
                for _,mod in pairs( mods ) do
                    if mod.fire_remnant ~= nil then
                        local dis = ( self.start_pos - mod.fire_remnant:GetAbsOrigin() ):Length2D()
                        if dis < distance then
                            distance = dis
                            target = mod.fire_remnant
                        end
                    end
                end
                return target
            else -- 冲刺最远的残焰
                local distance = 0
                local mods = self.timer_mods
                for _,mod in pairs( mods ) do
                    if mod.fire_remnant ~= nil then
                        local dis = ( self.start_pos - mod.fire_remnant:GetAbsOrigin() ):Length2D()
                        if dis > distance then
                            distance = dis
                            target = mod.fire_remnant
                        end
                    end
                end
                return target
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:SetActivateSpeed( target )
            if not IsServer() then return end
            local caster = self:GetCaster()
            local ability = self:GetAbility()
            local speed = ability:GetSpecialValueFor("speed")
            local distance = CalcDistanceBetweenEntityOBB( caster, target )
            speed = math.max( speed, distance/0.4 )
            return speed
        end
        function modifier_imba_ember_spirit_activate_fire_remnant:ActivateFireRemnant( target )
            if not IsServer() then return end
            local caster = self:GetCaster()
            local ability = self:GetAbility()    
            EmitSoundOnLocationWithCaster( target:GetAbsOrigin(), "Hero_EmberSpirit.FireRemnant.Explode", caster )
            if not target.landed then -- 残焰还没到达终点
                ProjectileManager:DestroyLinearProjectile( target.proj )
                local effectname = "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf"
                local pfx = ParticleManager:CreateParticle(effectname, PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(pfx)
            end     
            local radius = ability:GetSpecialValueFor("radius")
            local damage = ability:GetSpecialValueFor("damage")
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _,enemy in pairs( enemies ) do
                ApplyDamage({victim = enemy, attacker = caster, damage = damage, ability = ability, damage_type = ability:GetAbilityDamageType()})
            end
            if caster:HasScepter() then
                local flame_guard = caster:FindAbilityByName("imba_ember_spirit_flame_guard")
                if flame_guard and flame_guard:IsTrained() then
                    local duration = flame_guard:GetSpecialValueFor("duration")
                    caster:RemoveModifierByName("modifier_imba_ember_spirit_flame_guard")
                    caster:AddNewModifier( caster, flame_guard, "modifier_imba_ember_spirit_flame_guard", {duration = duration})
                end
            end
            if caster.remnant_heal then
                local remnant_heal = ability:GetSpecialValueFor("remnant_heal")
                local heal = damage * remnant_heal/100
                local allies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
                for _,ally in pairs( allies ) do
                    ally:Heal( heal, ability )
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal, nil)
                end
            end
            if caster.remnant_dmg then
                local duration = ability:GetSpecialValueFor("remnant_dmg_duration")
                caster:AddNewModifier( caster, ability, "modifier_imba_ember_spirit_activate_fire_remnant_damage", { duration = duration })
            end
            local mods = caster:FindAllModifiersByName("modifier_imba_ember_spirit_fire_remnant_timer")
            for _,mod in pairs( mods ) do
                if mod.fire_remnant == target then
                    mod:Destroy()
                    break
                end
            end
            for i=#self.timer_mods, 1, -1 do
                local mod = self.timer_mods[i]
                if mod.fire_remnant == target then
                    table.remove( self.timer_mods, i )
                    break
                end
            end
            self.count = self.count - 1      
            self.target = nil 
            target:ForceKill( false )
        end  
        --------------------------------------------------------------------
        -- 激活残焰-攻击力
        --------------------------------------------------------------------
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:IsHidden() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:IsDebuff() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:IsPurgable() return false end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:OnCreated()  
            if IsServer() then
                local ability = self:GetAbility()
                local remnant_dmg = ability:GetSpecialValueFor("remnant_dmg")
                local duration = self:GetDuration()
                local time = GameRules:GetGameTime() + duration -- 到期时间
                self.table = {}
                table.insert(self.table, { time = time, interval = duration, damage = remnant_dmg })
                self:SetStackCount( remnant_dmg )
                self:StartIntervalThink( duration )
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:OnRefresh() 
            if IsServer() then
                local ability = self:GetAbility()
                local remnant_dmg = ability:GetSpecialValueFor("remnant_dmg")
                local duration = self:GetDuration()
                local time = GameRules:GetGameTime() + duration
                local interval = time - self.table[#self.table].time
                table.insert(self.table, { time = time, interval = interval, damage = remnant_dmg })
                self:SetStackCount( self:GetStackCount() + remnant_dmg )
            end
        end

        function modifier_imba_ember_spirit_activate_fire_remnant_damage:OnIntervalThink()
            if IsServer() then
                local time = GameRules:GetGameTime()
                local damage = 0
                for i = #self.table, 1, -1 do 
                    if time >= self.table[i].time then
                        damage = damage + self.table[i].damage
                        table.remove(self.table, i)  
                    end
                end
                self:SetStackCount( self:GetStackCount() - damage )
                if #self.table > 0 then
                    local interval = self.table[1].interval
                    self:StartIntervalThink( interval )
                end
            end
        end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
        function modifier_imba_ember_spirit_activate_fire_remnant_damage:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end
    --------------------------------------------------------------------
    -- 残焰-充能  DeepPrintTable
    --------------------------------------------------------------------
        function imba_ember_spirit_fire_remnant_charge:IsHiddenWhenStolen() return false end
        function imba_ember_spirit_fire_remnant_charge:IsStealable() return true end
        function imba_ember_spirit_fire_remnant_charge:IsRefreshable() return true end
        function imba_ember_spirit_fire_remnant_charge:GetCastRange(location , target)
            local  caster = self:GetCaster()
            if caster.remnant_cr then
                return self.BaseClass.GetCastRange(self, location , target) * self:GetSpecialValueFor("remnant_cr")
            else
                return self.BaseClass.GetCastRange(self, location , target)
            end
        end
        function imba_ember_spirit_fire_remnant_charge:OnSpellStart()
            if not IsServer() then return end
            local caster = self:GetCaster()
            local pos = self:GetCursorPosition()
            caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
            if caster:GetName() == "npc_dota_hero_ember_spirit" then
                if RandomInt(1, 100) <= 40 then
                    local i = math.random(1,7)
                    caster:EmitSound("ember_spirit_embr_fireremsend_0"..i)
                end
            end
            self:CastFireRemnant( pos )
        end
        function imba_ember_spirit_fire_remnant_charge:CastFireRemnant( pos )
            local caster = self:GetCaster()
            local duration = self:GetSpecialValueFor("duration")
            local fire_remnant = CreateUnitByName("npc_dota_ember_spirit_remnant", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
            fire_remnant:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant", {} )
            fire_remnant:AddNewModifier( caster, self, "modifier_kill", {duration = duration}) 
            fire_remnant:SetDayTimeVisionRange( caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_7") )
            fire_remnant:SetNightTimeVisionRange( caster:TG_GetTalentValue("special_bonus_imba_ember_spirit_7") )
            if caster:TG_HasTalent("special_bonus_imba_ember_spirit_4") then --灼烧
                fire_remnant:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant_burn_aura", {})
            end
            local mod = caster:AddNewModifier( caster, self, "modifier_imba_ember_spirit_fire_remnant_timer", {duration = duration})
            mod.fire_remnant = fire_remnant
            local start_pos = caster:GetAbsOrigin()
            local distance = ( start_pos - pos ):Length2D()
            local direction = ( pos - start_pos ):Normalized()
            direction.z = 0
            local speed_multiplier = self:GetSpecialValueFor("speed_multiplier")
            if caster.remnant_cr then
                speed_multiplier = speed_multiplier*self:GetSpecialValueFor("remnant_ms")
            end
            local speed = caster:GetMoveSpeedModifier( caster:GetBaseMoveSpeed(), false ) * speed_multiplier/100
            local velocity = speed * direction
            local info  = {
                Ability = self,
                EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
                vSpawnOrigin = start_pos,
                fDistance = distance,
                fStartRadius = 0,
                fEndRadius = 0,
                Source = caster,
                bHasFrontalCone = false,
                bReplaceExisting = false,
                iUnitTargetTeam = 0,
                iUnitTargetFlags = 0,
                iUnitTargetType = 0,
                bDeleteOnHit = false,
                vVelocity = velocity,
                bProvidesVision = false,
                ExtraData = {fire_remnant = fire_remnant:entindex()}
            }
            fire_remnant.proj = ProjectileManager:CreateLinearProjectile(info)
        end
        function imba_ember_spirit_fire_remnant_charge:OnProjectileThink_ExtraData(pos, keys)
            if IsServer() and keys.fire_remnant and EntIndexToHScript(keys.fire_remnant) then
                EntIndexToHScript(keys.fire_remnant):SetAbsOrigin( pos )
            end
        end
        function imba_ember_spirit_fire_remnant_charge:OnProjectileHit_ExtraData(target, pos, keys)
            if IsServer() and keys.fire_remnant and EntIndexToHScript(keys.fire_remnant) then
                local fire_remnant = EntIndexToHScript(keys.fire_remnant)
                if fire_remnant:IsAlive() then
                    fire_remnant:SetAbsOrigin( GetGroundPosition(pos, nil) )
                    fire_remnant:FindModifierByName("modifier_imba_ember_spirit_fire_remnant"):OnFireRemnantLanded()
                end
            end
        end