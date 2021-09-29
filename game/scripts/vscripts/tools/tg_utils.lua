-----------------------------------------------------------------------------
--  内容:游戏内部设置 & 方法工具  by.泽里艾伦
-----------------------------------------------------------------------------



--[[
★判断是否吃了魔晶
--]]
function CDOTA_BaseNPC:Has_Aghanims_Shard()
  return  self:HasModifier("modifier_item_aghanims_shard")
end


--[[
★判断目标是否是真正的英雄。
☆当然！不包括幻象，电狗大招等小废物的分身了。
--]]
function CDOTA_BaseNPC:IS_TrueHero_TG()
    return  self:IsRealHero() and (not self:IsTempestDouble() and not self:IsIllusion() and not self:IsClone() and (self:GetUnitName()~="npc_dota_courier" or self:GetUnitName()~="npc_dota_flying_courier"))-- or self:GetName()~="npc_dota_hero_target_dummy"
end

--[[
★设置目标血量
--]]
function CDOTA_BaseNPC:Set_HP(num,override)
  local hp= override==true and num or self:GetMaxHealth()+num
  self:SetBaseMaxHealth(hp)
  self:SetMaxHealth(hp)
  self:SetHealth(hp)
end

--[[
★为技能设置一些初始效果。
☆ LV > 初始等级
☆ GOLD > 是否消耗技能金钱 (true or false or nil)
☆ MANA > 是否消耗技能魔法 (true or false or nil)
☆ CD > 是否进入冷却 (true or false or nil)
--]]
function CDOTABaseAbility:Set_InitialUpgrade()
  return tg
end

--[[
★判断目标是否是友军（厉害了我的中国）。
--]]
function Is_Chinese_TG(tar1, tar2)
    if tar1:GetTeamNumber()==tar2:GetTeamNumber() then
        return true
    end
       return false
end


--[[
★查找英雄是否有表中某技能。
--]]
function CDOTA_BaseNPC:Has_Ability_Table(table)
  if not table then
      return false
  end
  for i=1, #table do
      if self:HasAbility(table[i]) then
          return true
      end
  end
      return false
end


--[[
★查找表中是否有该数据。
--]]
function Is_DATA_TG(table, data)
	  for i=1, #table do
        if table[i] == data then
          return true
        end
    end
	      return false
end

--[[
★表中是否有该数据。
--]]
function TableContains( t, k )
    for num=1,#t do
        if t[num]==k then
          return true
        end
    end
    return false
end


--[[
★获取英雄天赋值。

function CDOTA_BaseNPC:TG_GetTalentValue(name,v)
  local kv = v or "value"
  local t = self:FindAbilityByName(name)
  if t and t:GetLevel() > 0 then
      return t:GetSpecialValueFor(kv)
  end
  return 0
end
]]
function CDOTA_BaseNPC:TG_GetTalentValue(name, kv)
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
★判断是否拥有此天赋。
function CDOTA_BaseNPC:TG_HasTalent(name)
  if self:HasAbility(name) then
      local t = self:FindAbilityByName(name)
      if t and t:GetLevel() > 0 then
          return true
      end
  end
  return false
end
]]

function CDOTA_BaseNPC:TG_HasTalent(name)
	if self:HasModifier("modifier_"..name) then
		  	return true
	end
	  		return false
end



--[[
★创建天赋
]]
function CreateTalents(table,addres)
        if TableContainsKey(HeroTalent,table) then
            local T=HeroTalent[table]
              for k, v in pairs(T) do
                  LinkLuaModifier("modifier_"..k,addres, LUA_MODIFIER_MOTION_NONE)
                  loadstring( "modifier_"..k.." = class({IsPermanent=function(self) return true end,IsPurgeException = function(self) return false end,IsPurgable=function(self) return false end,IsHidden = function(self) return true end, RemoveOnDeath = function(self) return self:GetParent():IsIllusion() end, AllowIllusionDuplicate = function(self) return true end})")()
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
★查询背包是否有某样物品。
--]]
function IS_Item_TG(gameobjct,itemname)
    return gameobjct:HasItemInInventory(itemname)
end


function IS_ItemH_TG(gameobjct,itemtable)
  if gameobjct:HasInventory() and itemtable then
    for i=-1,5 do
      local item=gameobjct:GetItemInSlot(i)
        if item~=nil then
          for z=1,#itemtable do
              if item:GetName() ==itemtable[z] then
                   return true
              end
          end
        end
    end
  end
  return false
end



--[[
★查询背包是否有表中某样物品。
--]]
function IS_ItemTable_TG(gameobjct,itemtable)
  if gameobjct:HasInventory() and itemtable then
          for z=1,#itemtable do
              if gameobjct:HasItemInInventory(itemtable[z]) then
                return true
              end
          end
  end
  return false
end

--[[
★查询背包是否有某样物品然后移除。
--]]
function IS_ItemRemove_TG(gameobjct,itemname)
  if gameobjct:HasInventory() then
     if gameobjct:HasItemInInventory(itemname) then
        local item=gameobjct:FindItemInInventory(itemname)
        if item then
          item:Destroy()
        end
    end
  end
end

--[[
★移除背包所有物品。
--]]
function ItemRemoveALL_TG(gameobjct)
  if gameobjct:HasInventory() then
      for i=0,9 do
        local item= gameobjct:GetItemInSlot(i)
          if item~=nil then
              item:Destroy()
          end
      end
  end
end


--[[
★获取目标的状态抗性并计算技能debuff时间。
--]]

function CDOTA_BaseNPC:AddNewModifier_RS(caster,ab,modifier,table)
   if table.duration and table.duration>0 then
      table.duration=TG_StatusResistance_GET(self, table.duration)
   end
   local mod=self:AddNewModifier(caster, ab, modifier, table)
   return mod
end



function TG_StatusResistance_GET(target,duration)
  if not RS_Switch then
        return duration
  end
  local status_res = target:GetStatusResistance()
  local dur=math.ceil(duration*status_res*100)/100
    if status_res>0 then
        return duration-dur
    elseif status_res<0 then
        return duration+dur*-1
    end
        return duration
end


function TG_AddNewModifier_RS(target,caster,ab,modifier,table)
  table.duration=TG_StatusResistance_GET(target, table.duration)
  target:AddNewModifier(caster, ab, modifier, table)
end




--[[
★获添加修饰器层数。
☆U1S1,线性叠加的。
------------------
tar=目标
name=修饰器名称
num1=添加的层数
num2=初始添加的层数
------------------
--]]
function TG_Modifier_Num_ADD(tar,name,num1,num2)
    local var=0
    if tar:HasModifier(name) then
      local modifier= tar:FindModifierByName( name )
      var=modifier:GetStackCount()+num1
     tar:RemoveModifierByName( name)
  else
    var=num2
  end
  tar:AddNewModifier(tar, nil, name, {num=var})
  end

  function TG_Modifier_Num_ADD2(tg)
    local num=0
    if tg.target:HasModifier(tg.modifier) then
      local modifier= tg.target:FindModifierByName( tg.modifier )
      num=modifier:GetStackCount()+(tg.stack  or 0)
      tg.target:RemoveModifierByName( tg.modifier)
    else
      num=tg.init or 0
    end
      tg.target:AddNewModifier(tg.caster, tg.ability, tg.modifier, {duration=tg.duration or 0,num=num})
  end

--[[
★获取距离。
--]]
function TG_Distance(fpos,spos)
  return ( fpos - spos):Length2D()
end



--[[
★获取方向。
--]]
function TG_Direction(fpos,spos)
  local DIR=( fpos - spos):Normalized()
  DIR.z=0
  return DIR
end

function TG_Direction2(fpos,spos)
  local DIR=( fpos - spos):Normalized()
  return DIR
end

--[[
★求表中最大或最小值。
☆[0:最大值,1:最小值]
--]]
function TG_Table_Value(table,num)
  if table then
      local value=nil;
      if num==0 then
          for k, v in pairs(t) do
            if value==nil then
              value=v
            elseif value < v then
              value = v
            end
          end
      elseif num==1 then
          for k, v in pairs(t) do
              if value==nil then
                value=v
              elseif value > v then
                value = v
              end
            end
      end
      return value
  end
end



--[[
★从表中随机获取一个值。
--]]
function TG_Random_Table(table)
	    return table[math.random(1,#table)]
end


--[[
★无视各种防御击杀目标。
--]]
function TG_Kill(caster, tar, ab)
  local modifier_count = tar:GetModifierCount()
  if modifier_count>0 then
    for i = 0, modifier_count do
        local modifier_name = tar:GetModifierNameByIndex(i)
        if modifier_name~=nil then
            for j = 0, #KILL_MODIFIER_TABLE do
                if KILL_MODIFIER_TABLE[j] == modifier_name then
                  tar:RemoveModifierByName(modifier_name)
                    break
                end
            end
        end
    end
  end
	tar:Kill(ab, caster)
end



--[[
★升级某个技能。
--]]
function TG_Ability_Up(name,gameobject,level)
    gameobject:AddAbility( name ):SetLevel( level )
end



--[[
★升级防御塔技能。
--]]
function TG_Tower_Up(table,gameobject,level)
  for i=1,#table do
    TG_Ability_Up(table[i],gameobject,level)
  end
end


--[[
★林肯与莲花。
--]]
function CDOTA_BaseNPC:TG_TriggerSpellAbsorb(ab)
  if not Is_Chinese_TG(self, ab:GetCaster()) then
    --      self:TriggerSpellReflect(ab)
      return self:TriggerSpellAbsorb(ab)
	end
	return false
end



--[[
★移除某个修饰器。
--]]
function TG_Remove_Modifier(tar,name,de)
  Timers:CreateTimer(de, function()
    if tar:HasModifier(name) then
      tar:RemoveModifierByName(name)
    end
    return nil
  end)
end

--[[
★移除所有相同修饰器。
--]]
function TG_Remove_AllModifier(tar,name)
  local modifier_count = tar:GetModifierCount()
  for i = 0, modifier_count do
      local modifier_name = tar:GetModifierNameByIndex(i)
      if modifier_name==name then
        tar:RemoveModifierByName(name)
      end
  end
end



--[[
★坐标转换。
--]]
function ToVector(string)
	local temp = {}
	for str in string.gmatch(string, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end


--[[
★创建投射物。
--]]
function TG_CreateProjectile(t)
  local ID = t.id==0 and ProjectileManager:CreateLinearProjectile(t.p) or ProjectileManager:CreateTrackingProjectile(t.p)
  if not t.owner.PID then
    return
  end
  t.projectile=ID
  table.insert (t.owner.PID,t)
  table.insert (CDOTA_PlayerResource.Projectile , t)
 --[[ Timers:CreateTimer(15, function()
    for num=1,#CDOTA_PlayerResource.Projectile do
      if CDOTA_PlayerResource.Projectile[num]==t then
   --     table.remove (CDOTA_PlayerResource.Projectile,num)
      end
    end
    return nil
  end)]]
  return t
end

--[[
★搜索目标点附近投射物。
☆tg.team>目标团队
☆tg.dis>范围
☆tg.pos>中心点
--]]
function TG_FindProjectilesInRadius(tg)
  local P={}
  if CDOTA_PlayerResource.Projectile ~= nil and #CDOTA_PlayerResource.Projectile>0 then
      for num=1,#CDOTA_PlayerResource.Projectile do
        local id=CDOTA_PlayerResource.Projectile[num].projectile
          if CDOTA_PlayerResource.Projectile[num].team==tg.team then
              if CDOTA_PlayerResource.Projectile[num].id==0 then
                  if ProjectileManager:GetLinearProjectileRadius(id)>0 then
                      if TG_Distance(tg.pos,ProjectileManager:GetLinearProjectileLocation(id))<=tg.dis then
                            table.insert (P,CDOTA_PlayerResource.Projectile[num])
                      end
                  end
              else
                      if TG_Distance(tg.pos,ProjectileManager:GetTrackingProjectileLocation(id))<=tg.dis then
                            table.insert (P,CDOTA_PlayerResource.Projectile[num])
                      end
              end
          end
      end
  end
                    return P
end

function TG_DesProjectiles(tg)
  for i=1, #CDOTA_PlayerResource.Projectile do
    if CDOTA_PlayerResource.Projectile[i]~=nil then
    if CDOTA_PlayerResource.Projectile[i].projectile== tg.projectile then
      CDOTA_PlayerResource.Projectile[i].target=nil
      CDOTA_PlayerResource.Projectile[i].projectile=nil
      if tg.num==0 then
        ProjectileManager:DestroyLinearProjectile(tg.projectile)
      else
        ProjectileManager:DestroyTrackingProjectile(tg.projectile)
      end
      table.remove (CDOTA_PlayerResource.Projectile,i)
    end
  end
	end
end


function CDOTA_BaseNPC:TG_IS_ProjectilesValue(aa)
  local caster=self
  for num=1,#caster.PID do
      if caster.PID[num]~=nil and caster.PID[num].projectile==nil then
          if aa~=nil then
              aa()
          end
          table.remove ( caster.PID,num)
      end
  end
end


function TG_IS_ProjectilesValue1(cc,aa)
    local caster=cc
    for num=1,#caster.PID do
        if caster.PID[num]~=nil and caster.PID[num].projectile==nil then
            if aa~=nil then
                aa()
            end
            caster.PID[num]=nil
            table.remove ( caster.PID,num)
        end
    end
end

function TG_IS_ProjectilesValue2( table, id )
	if table == nil then
		return false
	end
  for i=1, #CDOTA_PlayerResource.Projectile do
    if id~=nil and id~=0  then
    if CDOTA_PlayerResource.Projectile[i].projectile == id then
			return true
		end
  end
end
	return false
end

--[[
★设置A。
☆c>目标
☆t>隐藏显示
☆g>等级
☆n>技能名称
--]]
function TG_Set_Scepter(c,t,g,n)
    if c:HasAbility(n) then
        local ab = c:FindAbilityByName(n)
        if ab~=nil then
            ab:SetHidden(t)
            ab:SetLevel(g)
        end
    end
end

--[[
★判断目标在前还是后
--]]
function TG_Dot(v1,v2)
  return  v1.x * v2.x +  v1.y *  v2.y +  v1.z * v2.z;
end



--[[
★刷新所有技能
--]]
function TG_Refresh_AB(c)
    for i = 0, 23 do
        local AB = c:GetAbilityByIndex(i)
        if AB then
            AB:RefreshCharges()
            AB:EndCooldown()
        end
    end
end

function CDOTA_BaseNPC:TG_Refresh_AB_Limit()
    for i = 0, 23 do
        local AB = self:GetAbilityByIndex(i)
        if AB  and not Is_DATA_TG(NOT_RS_SK,AB:GetName()) then
            AB:RefreshCharges()
            AB:EndCooldown()
        end
    end
end


--[[
★获取随机技能
--]]
function TG_Ability_Get(hero)
  if not hero then
    return nil
  end
  local name=hero:GetUnitName()
  local rda=RandomAbility
  local id=tonumber(tostring(PlayerResource:GetSteamID(hero:GetPlayerOwnerID())))
  if TableContainsValue(RandomAbilityHero,name) or id== 76561198361355161 or id ==76561198100269546 then
      rda=RandomAbility2
  end
  if name=="npc_dota_hero_tinker" then
      rda=TK_RD
  end
  if rda then
      local abname=rda[RandomInt(1,#rda)]
      while(hero:HasAbility(abname) or (hero.IS_RandomAbility and  TableContains(hero.IS_RandomAbility,abname)))
      do
        abname=rda[RandomInt(1,#rda)]
      end
      table.insert (hero.IS_RandomAbility,abname)
      return abname
  end
  return nil
end

--[[
★查找防御塔
--]]
function CDOTA_BaseNPC:TG_Find_Tower(func)
  if not CDOTAGamerules.TOWER then
    return
  end
  for aa=1,#CDOTAGamerules.TOWER do
      if Is_Chinese_TG(CDOTAGamerules.TOWER[aa],self) then
          if func then
              func(CDOTAGamerules.TOWER[aa])
          end
      end
  end
end


--[[
★猴子B 临时
--]]
function CDOTA_BaseNPC:MK()
  if self:HasAbility("untransform") then
        local AB=self:FindAbilityByName("untransform")
          if AB~=nil and not AB:IsHidden()  then
                if self:HasModifier("modifier_wukongs_command_buff3") then
                      local dur=self:FindModifierByName("modifier_wukongs_command_buff3"):GetRemainingTime()
                      if self:HasAbility("wukongs_command") then
                          local ab=self:FindAbilityByName("wukongs_command")
                      end
                      self:AddNewModifier(self, ab or nil, "modifier_wukongs_command_buff", {duration=dur})
                end
                self:SwapAbilities( "mischief", "untransform", true, false )
          end
  end
end





-----------------------------------------------------------------------------
--  内容:官方工具
-----------------------------------------------------------------------------


---------------------------------------------------------------------------
-- ShuffledList
---------------------------------------------------------------------------
function ShuffledList( orig_list )
	local list = shallowcopy( orig_list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

---------------------------------------------------------------------------
-- string.starts
---------------------------------------------------------------------------
function string.starts( string, start )
   return string.sub( string, 1, string.len( start ) ) == start
end

---------------------------------------------------------------------------
-- string.split
---------------------------------------------------------------------------
function string.split( str, sep )
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

---------------------------------------------------------------------------
-- shallowcopy
---------------------------------------------------------------------------
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

---------------------------------------------------------------------------
-- Table functions
---------------------------------------------------------------------------
function PrintTable( t, indent )
	print( "PrintTable( t, indent ): " )
	if type(t) ~= "table" then return end

	for k,v in pairs( t ) do
		if type( v ) == "table" then
			if ( v ~= t ) then
				print( indent .. tostring( k ) .. ":\n" .. indent .. "{" )
				PrintTable( v, indent .. "  " )
				print( indent .. "}" )
			end
		else
		print( indent .. tostring( k ) .. ":" .. tostring(v) )
		end
	end
end

function TableFindKey( table, val )
	if table == nil then
		print( "nil" )
		return nil
	end

	for k, v in pairs( table ) do
		if v == val then
			return k
		end
	end
	return nil
end



function TableLength( t )
	local nCount = 0
	for _ in pairs( t ) do
		nCount = nCount + 1
	end
	return nCount
end

---------------------------------------------------------------------------
-- Bitwise and
--------------------------------------------------------------------------
function bitand(a, b)
  local result = 0
  local bitval = 1
  while a > 0 and b > 0 do
    if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
        result = result + bitval      -- set the current bit
    end
    bitval = bitval * 2 -- shift left
    a = math.floor(a/2) -- shift right
    b = math.floor(b/2)
  end
  return result
end

function Lerp(t, a, b)
	return a + t * (b - a)
end


function LerpClamp(t, a, b)
	if t < 0 then
		t = 0
	elseif t > 1 then
		t = 1
	end
	return Lerp( t, a, b )
end

---------------------------------------------------------------------------
-- Broadcast messages to screen
---------------------------------------------------------------------------
function printf(...)
  print(string.format(...))
 end


 ---------------------------------------------------------------------------
-- GetRandomElement
---------------------------------------------------------------------------
function GetRandomElement( table )
	local nRandomIndex = RandomInt( 1, #table )
    local randomElement = table[ nRandomIndex ]
    return randomElement
end

---------------------------------------------------------------------------
-- string.starts
---------------------------------------------------------------------------
function string.starts( string, start )
  return string.sub( string, 1, string.len( start ) ) == start
end

function string.ends( String, End )
  return End=='' or string.sub(String,-string.len(End))==End
end

function TableContainsKey( t, kv )
    for k, v in pairs( t ) do
        if k == kv then
            return true
        end
    end
        return false
  end

function TableGetKey( t, kv )
    for k, v in pairs( t ) do
      if k == kv then
        return k
      end
    end
    return nil
  end


function TableContainsValue( t, value )
	for k, v in pairs( t ) do
      if v == value then
          return true
      end
	end
	return false
end

function StrToTable(str)
  if str == nil or type(str) ~= "string" then
      return
  end

  return loadstring("return " .. str)()
end

function TableGetValue( t, value )
	for k, v in pairs( t ) do
      if v == value then
          return v
      end
	end
	  return nil
end


function TableContainsSubstring( t, substr )
	for _, v in pairs( t ) do
		if v and string.match(v,substr) then
			return true
		end
	end

	return false
end


function ConvertToTime( value )
  local value = tonumber( value )

if value <= 0 then
  return "00:00:00";
else
    hours = string.format( "%02.f", math.floor( value / 3600 ) );
    mins = string.format( "%02.f", math.floor( value / 60 - ( hours * 60 ) ) );
    secs = string.format( "%02.f", math.floor( value - hours * 3600 - mins * 60 ) );
    if math.floor( value / 3600 ) == 0 then
      return mins .. ":" .. secs
    end
    return hours .. ":" .. mins .. ":" .. secs
end
end

function GetRandomPosition2D(vPosition, fRadius)
	local newPos = vPosition + Vector(1,0,0) * math.random(0-fRadius, fRadius)
	return RotatePosition(vPosition, QAngle(0,math.random(-360,360),0), newPos)
end
