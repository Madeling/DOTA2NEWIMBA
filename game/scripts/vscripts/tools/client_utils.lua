
--[[
★判断是否拥有此天赋。
--]]
function C_DOTA_BaseNPC:TG_HasTalent(name)
	if self:HasModifier("modifier_"..name) then
		  	return true 
	end
	  		return false
end


--[[
★获取英雄天赋值。
--]]
function C_DOTA_BaseNPC:TG_GetTalentValue(name, kv)
	if self:HasModifier("modifier_"..name) then
		local value_name = kv or "value"
		local specialVal = AbilityKV[name]["AbilitySpecial"]
		for k,v in pairs(specialVal) do
				if v[value_name] then
					return v[value_name]
				end
		end
	end    
			return 0
end



--[[
★创建天赋
]]
function CreateTalents(table,addres)
	if TableContainsKey(HeroTalent,table) then 
		local T=HeroTalent[table]
			for k, v in pairs(T) do
			  LinkLuaModifier("modifier_"..k,addres, LUA_MODIFIER_MOTION_NONE) 
			  loadstring( "modifier_"..k.." = class({IsHidden = function(self) return true end, RemoveOnDeath = function(self) return self:GetParent():IsIllusion() end, AllowIllusionDuplicate = function(self) return true end})")()
				if  v~=nil then  
					for k2, v2 in pairs(v) do
						if v2~=nil then 
						LinkLuaModifier(v2["modifier_name"],v2["link_address"], tonumber(v2["modifier_motion"] or 0))
						end
					end
				end
			end
	  end
end



  function GetALLTalents(name)
    return HeroTalent[name]
end



--[[
★判断目标是否是友军（厉害了我的中国）。
--]]
function Is_Chinese_TG(tar1, tar2)
    if tar1:GetTeamNumber()==tar2:GetTeamNumber() then
        return true
    else
      return false
    end
end


function TableContainsKey( t, kv )
    for k, v in pairs( t ) do
        if k == kv then
            return true
        end
    end
        return false
  end




  --OLD IMBA

  function IsNearEnemyFountain(location, team, distance)

	local fountain_loc
	if team == DOTA_TEAM_GOODGUYS then
		fountain_loc = Vector(7472, 6912, 512)
	else
		fountain_loc = Vector(-7456, -6938, 528)
	end

	local dis = math.sqrt((fountain_loc.x - location.x) ^ 2 + (fountain_loc.y - location.y) ^ 2)

	if dis <= distance then
		return true
	end

	return false
end


function IsEnemy(unit1, unit2)
	if unit1:GetTeamNumber() == unit2:GetTeamNumber() then
		return false
	else
		return true
	end
end

function C_DOTABaseAbility:GetAbilityCurrentKV()
	local name = self:GetName()
	local kv_to_return = {}
	local level = self:GetLevel()
	if level <= 0 or (not AbilityKV[name] and ItemKV[name]) then
		return nil
	end
	local kv = AbilityKV[name] and AbilityKV[name]["AbilitySpecial"] or ItemKV[name]["AbilitySpecial"]
	for k, v in pairs(kv) do
		for a, b in pairs(v) do
			for str in string.gmatch(b, "%S+") do
				if tonumber(str) then
					local lv = 0
					for s in string.gmatch(b, "%S+") do
						lv = lv + 1
						if lv <= level then
							kv_to_return[a] = tonumber(s)
						else
							break
						end
					end
					break
				end
			end
		end
	end
	return kv_to_return
end

function C_DOTA_Modifier_Lua:SetAbilityKV()
	self.kv = self:GetAbility():GetAbilityCurrentKV()
	return self.kv
end

function C_DOTA_Modifier_Lua:GetAbilityKV(sKeyname)
	return self.kv and (self.kv[sKeyname] or 0) or 0
end

function IsInTable(value, table)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end


function C_DOTA_Ability_Lua:SetAbilityIcon(iIcon_Num)
	local info = CustomNetTables:GetTableValue("imba_ability_icon", tostring(iIcon_Num))
	if self.GetAbilityTextureName ~= self.BaseClass.GetAbilityTextureName then
		return
	end
	self.imba_ability_icon = info["1"]
	self.GetAbilityTextureName = function() return self.imba_ability_icon end
end

function C_DOTA_BaseNPC:IsTrueHero()
	return (not self:HasModifier("modifier_arc_warden_tempest_double") and self:IsRealHero() and not self:HasModifier("modifier_imba_meepo_clone_controller"))
end

function C_DOTA_Ability_Lua:SetAbilityIcon(iIcon_Num)
	local info = CustomNetTables:GetTableValue("imba_ability_icon", tostring(iIcon_Num))
	if self.GetAbilityTextureName ~= self.BaseClass.GetAbilityTextureName then
		return
	end
	self.imba_ability_icon = info["1"]
	self.GetAbilityTextureName = function() return self.imba_ability_icon end
end

function SplitString(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
		if not nFindLastIndex then  
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
			break  
		end  
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
		nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end

function HEXConvertToRGB(hex)
    hex = hex:gsub("#","")
    return {tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))}
end

function RGBConvertToHSV(colorRGB)
	local r,g,b = colorRGB[1], colorRGB[2], colorRGB[3]
	local h,s,v = 0,0,0

	local max1 = math.max(r, math.max(g,b))
	local min1 = math.min(r, math.min(g,b))

	if max1 == min1 then
		h=0;
	else
		if r == max1 then
			if g >= b then
				h = 60 * (g-b) / (max1-min1)
			else
				h = 60 * (g-b) / (max1-min1) + 360
			end
		end
		if g == max1 then
			h = 60 * (b-r)/(max1-min1) + 120
		end
		if b == max1 then
			h = 60 * (r-g)/(max1-min1) + 240;
		end
	end    
	
	if max1 == 0 then
		s = 0
	else
		s = (1- min1 / max1) * 255
	end
	
	v = max1
	
	return {h, s, v}
end


function StringToVector(sString)
	--Input: "123 123 123"
	local temp = {}
	for str in string.gmatch(sString, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end


function C_DOTA_BaseNPC:GetCastRangeBonus()
	local range = self:GetModifierStackCount("modifier_imba_talent_modifier_adder", nil)
	return range
end


function C_DOTA_BaseNPC:HasTalent(sTalentName)
	if self:HasModifier("modifier_"..sTalentName) then
		return true 
	end

	return false
end

function C_DOTA_BaseNPC:GetTalentValue(sTalentName, key)
	if self:HasModifier("modifier_"..sTalentName) then  
		local value_name = key or "value"
		local specialVal = AbilityKV[sTalentName]["AbilitySpecial"]
		for k,v in pairs(specialVal) do
			if v[value_name] then
				return v[value_name]
			end
		end
	end    
	return 0
end


function C_DOTA_BaseNPC:IsUnit()
	return self:IsHero() or self:IsCreep() or self:IsBoss()
end


function C_DOTA_Ability_Lua:HasFireSoulActive()
	return self:GetCaster():HasModifier("modifier_imba_fiery_soul_active")
end

function C_DOTA_BaseNPC:Has_Aghanims_Shard()
	return  self:HasModifier("modifier_item_aghanims_shard")
  end


  function Stack_RetATValue(t, counterSwap)
    local j, n = 1, #t;

    for i=1,n do
        if (counterSwap(i, j)) then
            -- Swap i's (duration/counter) value to j's position
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil; 
            end
            j = j + 1; -- Increment position of j.
        else
            t[i] = nil;
        end
    end

    return t;
end