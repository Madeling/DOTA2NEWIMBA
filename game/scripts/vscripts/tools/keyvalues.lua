
 -- Change to false to skip loading the base files
LOAD_BASE_FILES = false

if not KeyValues then
	KeyValues = {}
end

local split = function(inputstr, sep)
	if sep == nil then sep = "%s" end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- Load all the necessary key value files
function LoadGameKeyValues()
	local scriptPath ="scripts/npc/"
	local scriptPath1 ="scripts/npc/original"
--	local override = LoadKeyValues(scriptPath.."npc_abilities_override.txt")
	local files = {
		AbilityKV = {base="npc_abilities",custom="npc_abilities_custom"},
		AbilityKV2 = {base="",custom="npc_abilities"},
		ItemKV = {base="items",custom="npc_items_custom"},
		UnitKV = {base="npc_units",custom="npc_units_custom"}, -- npc_units_custom
		HeroKV = {base="npc_heroes",custom="npc_heroes_custom"},
		--HeroKV2 = {base="",custom="npc_heroes"}
	}

	-- Load and validate the files
	for k,v in pairs(files) do
		local file = {}
		if LOAD_BASE_FILES then
			file = LoadKeyValues(scriptPath1..v.base..".txt")
		end

		-- Replace main game keys by any match on the override file
--		for k,v in pairs(override) do
--			if file[k] then
--				file[k] = v
--			end
--		end

		local custom_file = LoadKeyValues(scriptPath..v.custom..".txt")
		if custom_file then
			for k,v in pairs(custom_file) do
				file[k] = v
			end
		else
--			print("[KeyValues] Critical Error on "..v.custom..".txt")
			return
		end

		GameRules[k] = file --backwards compatibility
		KeyValues[k] = file
	end

	-- Merge All KVs
	KeyValues.All = {}
	for name,path in pairs(files) do
		for key,value in pairs(KeyValues[name]) do
			if not KeyValues.All[key] then
				KeyValues.All[key] = value
			end
		end
	end

	-- Merge units and heroes (due to them sharing the same class CDOTA_BaseNPC)
	for key,value in pairs(KeyValues.HeroKV) do
		if KeyValues.UnitKV[key] ~= key then
			KeyValues.UnitKV[key] = value
		else
			if type(KeyValues.All[key]) == "table" then
--				print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
			end
		end
	end

--[[	for key,value in pairs(KeyValues.HeroKV2) do
		if KeyValues.UnitKV[key] ~= key then
			KeyValues.UnitKV[key] = value
		else
			if type(KeyValues.All[key]) == "table" then
--				print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
			end
		end
	end]]

	for key,value in pairs(KeyValues.AbilityKV2) do
		if not KeyValues.AbilityKV[key] then
			KeyValues.AbilityKV[key] = value
		else
			if type(KeyValues.All[key]) == "table" then
--				print("[KeyValues] Warning: Duplicated unit/hero entry for "..key)
			end
		end
	end
end



function GetAbilitySpecial(name, key, level)
	local t = KeyValues.All[name]
	if key and t then
		local tspecial = t["AbilitySpecial"]
		if tspecial then
			-- Find the key we are looking for
			for _,values in pairs(tspecial) do
				if values[key] then
					if not level then return values[key]
					else
						local s = split(values[key])
						if s[level] then return tonumber(s[level]) -- If we match the level, return that one
						else return tonumber(s[#s]) end -- Otherwise, return the max
					end
					break
				end
			end
		end
	else return t end
end

LoadGameKeyValues()