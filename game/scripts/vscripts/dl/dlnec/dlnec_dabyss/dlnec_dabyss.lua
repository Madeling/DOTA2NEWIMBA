CreateTalents("npc_dota_hero_necrolyte", "dl/dlnec/dlnec_dabyss/modifier_dlnec_dabyss_nec")
dlnec_dabyss = class({})    --加1层的检测在大招里，所以不学大招斩死人不加层，只有伤害

LinkLuaModifier("modifier_dlnec_dabyss_nec", "dl/dlnec/dlnec_dabyss/modifier_dlnec_dabyss_nec", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dlnec_dabyss_thinker", "dl/dlnec/dlnec_dabyss/modifier_dlnec_dabyss_thinker", LUA_MODIFIER_MOTION_NONE)

function dlnec_dabyss:IsHiddenWhenStolen() 	return false end
function dlnec_dabyss:IsRefreshable() 		return false end
function dlnec_dabyss:IsStealable() 		return false end
function dlnec_dabyss:ProcsMagicStick()     return false end
function dlnec_dabyss:ResetToggleOnRespawn()    return false end

function dlnec_dabyss:OnToggle()
    local caster = self:GetCaster()
    local nec = "modifier_dlnec_dabyss_nec"
    --local permanent = "modifier_dlnec_reaper_permanent"   --基本打不到人，每次自己加一层太蠢了

    if self:GetToggleState() then
        if not caster:FindModifierByName(nec) then
            caster:AddNewModifier(caster, self, nec, {})
           --caster:AddNewModifier(caster, self, permanent, {})
        end
    else
        if caster:FindModifierByName(nec) then
            caster:RemoveModifierByName(nec)
        end
    end
end

function dlnec_dabyss:OnOwnerDied()     --死亡自动关闭技能导致ondeath检测不到nec自己死亡，加了这个竟然能了

    self:ToggleAbility()

end

function dlnec_dabyss:OnInventoryContentsChanged()  --有A技能出现，无A技能消失
    local caster=self:GetCaster()
    if caster:HasScepter() then
        TG_Set_Scepter(caster,false,1,"dlnec_dabyss")
    else
        TG_Set_Scepter(caster,true,1,"dlnec_dabyss")
        if caster:FindModifierByName("modifier_dlnec_dabyss_nec") or self:GetToggleState() then
            caster:RemoveModifierByName("modifier_dlnec_dabyss_nec")
            self:ToggleAbility()
        end
    end
end
