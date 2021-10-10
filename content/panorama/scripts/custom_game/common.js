"use strict";
var CustomUIConfig = GameUI.CustomUIConfig();
// string.js
var print = $.Msg;
var sprintf = CustomUIConfig.sprintf;
var DoUniqueString = CustomUIConfig.DoUniqueString;
String.prototype.replaceAll = function (s1, s2) {
	return this.replace(new RegExp(s1, "gm"), s2);
};
String.prototype.toTitleCase = function () {
	return this.slice(0, 1).toUpperCase() + this.slice(1).toLowerCase();
};
// position.js
var ScreenPos2ScenePos = CustomUIConfig.ScreenPos2ScenePos;
var WorldPos2ScenePos = CustomUIConfig.WorldPos2ScenePos;
var getPanelOrigin = CustomUIConfig.getPanelOrigin;
var isScreenPos = CustomUIConfig.isScreenPos;
var isVector = CustomUIConfig.isVector;
// number.js
var formatNumByLanguage = CustomUIConfig.formatNumByLanguage;
// timer.js
var Timer = CustomUIConfig.StartTimer;

var Address = "pay.eomgames.net/pay";

var STEAM_WEB_KEY = "D34B40626FBA6E482A7653E4FB8A80CB";
Game.tSteamID2Name = [];

var REQUEST_TIME_OUT = 30;

var FX_Border = [
	"border_6",
	"border_7",
	"border_8",
	"border_11",
	"border_12",
	"border_13",
	"border_14",
	"border_16",
	"border_17",
	"border_18",
	"border_20",
];

var Decomposition_Courier_Count = [
	2,
	7,
	24,
	80,
];

// 一周年bp任务奖励任务卡数量
var plusTaskCards = 12;
var taskCards = 8;

// 当前的天梯赛季
const CURRENT_SCORE_RANK_SEASON = 19;
$.GetContextPanel().SetDialogVariableInt("score_rank_season", CURRENT_SCORE_RANK_SEASON);
// 当前的肉山竞速榜赛季
const CURRENT_ROSHAN_RANK_SEASON = 6;
// 当前的battlepass赛季
const CURRENT_BATTLEPASS_SEASON = 7;

CustomUIConfig.SubscribeNetTableListener = function (tableName, callback) {
	GameEvents.Subscribe("settablevalue_nil", (tEvents) => {
		if (tEvents.table_name == tableName) {
			if (typeof callback == "function") {
				callback(tableName, tEvents.key_name, undefined);
			}
		}
	});

	return CustomNetTables.SubscribeNetTableListener(tableName, callback);
};

$.RandomInt = function (n, m) {
	var random = RemapValClamped(Math.random(), 0, 1, n, m);
	return Math.floor(random);
};

$.RandomFloat = function (n, m) {
	var random = RemapValClamped(Math.random(), 0, 1, n, m);
	return random;
};

var NonNanNum = (num) => {
	return (isNaN(num)) ? 0 : num;
};

function Round(fNumber, prec = 0) {
	let i = Math.pow(10, prec);
	return Math.round(fNumber * i) / i;
}

function Clamp(num, min, max) {
	return num <= min ? min : (num >= max ? max : num);
}

function Lerp(percent, a, b) {
	return a + percent * (b - a);
}

function RemapVal(num, a, b, c, d) {
	if (a == b)
		return c;

	var percent = (num - a) / (b - a);
	return Lerp(percent, c, d);
}

function RemapValClamped(num, a, b, c, d) {
	if (a == b)
		return c;

	var percent = (num - a) / (b - a);
	percent = Clamp(percent, 0.0, 1.0);

	return Lerp(percent, c, d);
}

function Float(f) {
	return Math.round(f * 10000) / 10000;
}

function FindKey(o, v) {
	for (var k in o) {
		if (o[k] == v)
			return k;
	}
}

function GetSpecialNames(sAbilityName) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];

	if (tAbilityKeyValues) {
		var tSpecials = tAbilityKeyValues.AbilitySpecial;
		if (tSpecials) {
			var aSpecials = [];
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				for (var sName in tData) {
					if (sName != "var_type" &&
						sName != "LinkedSpecialBonus" &&
						sName != "LinkedSpecialBonusField" &&
						sName != "LinkedSpecialBonusOperation" &&
						sName != "RequiresScepter" &&
						sName != "CalculateSpellDamageTooltip" &&
						sName != "levelkey") {
						aSpecials.push(sName);
						break;
					}
				}
			}
			return aSpecials;
		}
	}

	return [];
}

function GetSpecialValueForLevel(sAbilityName, sName, iLevel) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];

	if (tAbilityKeyValues) {
		var tSpecials = tAbilityKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName]) {
					var sType = tData.var_type;
					var sValues = tData[sName].toString();
					var aValues = sValues.split(" ");
					if (aValues[iLevel - 1]) {
						var value = Number(aValues[iLevel - 1]);
						if (sType == "FIELD_INTEGER") {
							return parseInt(value);
						} else if (sType == "FIELD_FLOAT") {
							return parseFloat(value.toFixed(6));
						}
					}
				}
			}
		}
	}

	return 0;
}

function GetSpecialValues(sAbilityName, sName) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];

	if (tAbilityKeyValues) {
		var tSpecials = tAbilityKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName]) {
					var sType = tData.var_type;
					var sValues = tData[sName].toString();
					var aValues = sValues.split(" ");
					for (var i = 0; i < aValues.length; i++) {
						var value = Number(aValues[i]);
						if (sType == "FIELD_INTEGER") {
							aValues[i] = parseInt(value);
						} else if (sType == "FIELD_FLOAT") {
							aValues[i] = parseFloat(value.toFixed(6));
						}
					}
					return aValues;
				}
			}
		}
	}
	return [];
}

function GetUnitAbilities(sUnitNmae) {
	var tUnitKeyValues = CustomUIConfig.UnitsKv[sUnitNmae];

	var aAbilities = [];

	if (tUnitKeyValues) {
		for (var i = 0; i < 32; i++) {
			var sKey = "Ability" + (i + 1).toString();
			if (tUnitKeyValues[sKey] && tUnitKeyValues[sKey] != "") {
				aAbilities.push(tUnitKeyValues[sKey]);
			}
		}
	}

	return aAbilities;
}

function GetQualificationAbility(sCardName) {
	for (var sAbilityName in CustomUIConfig.QualificationAbilitiesKv) {
		var tData = CustomUIConfig.QualificationAbilitiesKv[sAbilityName];
		if (tData == null) {
			continue;
		}
		if (tData.ShowUI != 1)
			continue;
		if (tData.UnitName == sCardName) {
			return sAbilityName;
		}
	}
}

function GetCardNameByQualificationAbility(sQualificationAbility) {
	var tData = CustomUIConfig.QualificationAbilitiesKv[sQualificationAbility];
	if (tData) {
		return tData.UnitName;
	}
}

function GetCourierRarity(sCourierName) {
	if (!IsNull(CustomUIConfig.CourierKv[sCourierName])) {
		return CustomUIConfig.CourierKv[sCourierName].Raity.toUpperCase() || "N";
	} else {
		return "WRONG";
	}
}

function GetCourierItemDef(sCourierName) {
	return IsNull(CustomUIConfig.CourierKv[sCourierName]) ? "" : (CustomUIConfig.CourierKv[sCourierName].ItemDef);
}

function GetCourierItemStyle(sCourierName) {
	return IsNull(CustomUIConfig.CourierKv[sCourierName]) ? "" : (CustomUIConfig.CourierKv[sCourierName].ItemStyle || 0);
}

function GetCourierRarityIndex(sCourierName) {
	var sRarity = GetCourierRarity(sCourierName);
	switch (sRarity) {
		case "R":
			return 1;
		case "SR":
			return 2;
		case "SSR":
			return 3;
		default:
			return 0;
	}
}

function GetCourierAbility(sCourierName) {
	return IsNull(CustomUIConfig.CourierKv[sCourierName]) ? "" : (CustomUIConfig.CourierKv[sCourierName].Ability1 || "");
}

function GetCourierIcon(sCourierName) {
	return "file://{images}/custom_game/courier/icons/" + sCourierName + ".png";
}

function GetCardItemImage(sCardName) {
	var sAbilityName = CardNameToAbilityName(sCardName);
	return "file://{images}/items/heroes/" + (sAbilityName).replace("item_", "") + ".png";
}

function GetCardImage(sCardName) {
	return "file://{images}/custom_game/card/units/" + sCardName + ".png";
}

function GetCardIcon(sCardName) {
	return "file://{images}/custom_game/card/units/icon/" + sCardName + ".png";
}

function GetRarityImage(sRarity) {
	return "file://{images}/custom_game/rare_" + sRarity + ".png";
}

function GetHeroIcon(sHeroName) {
	return "file://{images}/items/heroes/" + sHeroName.replace("_custom", "") + ".png";
}

function GetAttributePrimaryIcon(iAttributePrimary) {
	switch (iAttributePrimary) {
		case Attributes.DOTA_ATTRIBUTE_STRENGTH:
			return "file://{images}/primary_attribute_icons/primary_attribute_icon_strength.png";
		case Attributes.DOTA_ATTRIBUTE_AGILITY:
			return "file://{images}/primary_attribute_icons/primary_attribute_icon_agility.png";
		case Attributes.DOTA_ATTRIBUTE_INTELLECT:
			return "file://{images}/primary_attribute_icons/primary_attribute_icon_intelligence.png";
		default:
			return "";
	}
}

var tSpecialModifiers = {};
for (const sModifierName in CustomUIConfig.PermanentModifiersKv) {
	const tData = CustomUIConfig.PermanentModifiersKv[sModifierName];
	tSpecialModifiers[sModifierName] = {
		sFilePath: tData.path || "",
		bIsDebuff: tData.IsDebuff || 0,
	};
}

function GetSpecialModifierPath(sModifierName) {
	if (tSpecialModifiers[sModifierName])
		return tSpecialModifiers[sModifierName].sFilePath || "";
	return "";
}

function IsSpecialModifierDebuff(sModifierName) {
	if (tSpecialModifiers[sModifierName])
		return tSpecialModifiers[sModifierName].bIsDebuff == 1;
	return false;
}

function IsBuilding(iUnitEntIndex) {
	return Entities.HasBuff(iUnitEntIndex, "modifier_building") ||
		Entities.HasBuff(iUnitEntIndex, "modifier_spectre_3_illusion") ||
		Entities.HasBuff(iUnitEntIndex, "modifier_lycan_1_summon") ||
		Entities.HasBuff(iUnitEntIndex, "modifier_venomancer_2_ward") ||
		Entities.HasBuff(iUnitEntIndex, "modifier_undying_4_zombie_lifetime");
}

Entities.HasBuff = function (unitEntIndex, buffName) {
	for (var index = 0; index < Entities.GetNumBuffs(unitEntIndex); index++) {
		var buff = Entities.GetBuff(unitEntIndex, index);
		if (Buffs.GetName(unitEntIndex, buff) == buffName)
			return true;
	}
	return false;
};

Entities.FindBuffByName = function (unitEntIndex, buffName) {
	for (var index = 0; index < Entities.GetNumBuffs(unitEntIndex); index++) {
		var buff = Entities.GetBuff(unitEntIndex, index);
		if (Buffs.GetName(unitEntIndex, buff) == buffName)
			return buff;
	}
	return -1;
};

Entities.GetStar = function (iEntityIndex) {
	var modifier = Entities.FindBuffByName(iEntityIndex, "modifier_qualification_level");
	if (modifier == -1) return 3;
	return Math.max(3, Math.min(Buffs.GetStackCount(iEntityIndex, modifier), 7)) - 2;
};

Entities.GetAbilitiesData = function (iEntityIndex) {
	return CustomNetTables.GetTableValue("abilities", iEntityIndex.toString());
};

Entities.GetBuildingData = function (iEntityIndex) {
	return CustomNetTables.GetTableValue("buildings", iEntityIndex.toString());
};

Entities.GetStatusResistanceFactor = function (iEntityIndex) {
	return 1 - Entities.GetStatusResistance(iEntityIndex) * 0.01;
};

Entities.GetEvasion = function (iEntityIndex) {
	var value = 1;
	if (Entities.HasBuff(iEntityIndex, "modifier_stinky"))
		value = value * 0.9;
	if (Entities.HasBuff(iEntityIndex, "modifier_dexterous"))
		value = value * 0.65;
	if (Entities.HasBuff(iEntityIndex, "modifier_unreal"))
		value = value * 0.5;
	if (Entities.HasBuff(iEntityIndex, "modifier_sky_light_buff"))
		value = value * 0;

	return 1 - value;
};

GameUI.UnitState = [];
Entities._updateUnitState = (iUnitEntIndex) => {
	let iAbilityEntIndex = Entities.GetAbilityByName(iUnitEntIndex, "unit_state");
	if (iAbilityEntIndex != -1) {
		let json = Abilities.GetAbilityTextureName(iAbilityEntIndex);
		if (json != "") {
			let aData = JSON.parse(json);
			GameUI.UnitState[iUnitEntIndex] = aData;
		}
	}
};

Entities.GetAverageAttackDamage = (iUnitEntIndex) => {
	return (Entities.GetDamageMin(iUnitEntIndex) + Entities.GetDamageMax(iUnitEntIndex)) / 2 + Entities.GetDamageBonus(iUnitEntIndex);
};

Entities.GetAttackSpeedPercent = (iUnitEntIndex) => {
	return Entities.GetAttackSpeed(iUnitEntIndex) * 100;
};

Entities.GetMoveSpeed = (iUnitEntIndex) => {
	return Entities.GetMoveSpeedModifier(iUnitEntIndex, Entities.GetBaseMoveSpeed(iUnitEntIndex));
};

Entities.GetBasePhysicalArmor = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][0];
	}
	return 0;
};
Entities.GetPhysicalArmor = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][1];
	}
	return 0;
};
Entities.GetBaseMagicalArmor = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][2];
	}
	return 0;
};
Entities.GetMagicalArmor = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][3];
	}
	return 0;
};
Entities.GetBaseSpellAmplify = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][4];
	}
	return 0;
};
Entities.GetSpellAmplify = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][5];
	}
	return 0;
};
Entities.GetHealthRegen = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][6];
	}
	return 0;
};
Entities.GetManaRegen = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][7];
	}
	return 0;
};
Entities.GetStatusResistance = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][8];
	}
	return 0;
};
Entities.GetEvasion = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][9];
	}
	return 0;
};
Entities.GetCooldownReduction = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][10];
	}
	return 0;
};
Entities.GetOutgoingDamagePercent = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][11];
	}
	return 0;
};
Entities.GetOutgoingPhysicalDamagePercent = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][12];
	}
	return 0;
};
Entities.GetOutgoingMagicalDamagePercent = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][13];
	}
	return 0;
};
Entities.GetOutgoingPureDamagePercent = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][14];
	}
	return 0;
};
Entities.GetIgnorePhysicalArmorPercentage = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][15];
	}
	return 0;
};
Entities.GetIgnoreMagicalArmorPercentage = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][16];
	}
	return 0;
};
Entities.GetManaFixed = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][17];
	}
	return 0;
};
Entities.GetMaxManaFixed = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][18];
	}
	return 0;
};
Entities.HasHeroAttribute = (iUnitEntIndex) => {
	if (GameUI.UnitState[iUnitEntIndex]) {
		return GameUI.UnitState[iUnitEntIndex][19] == 1;
	}
	return false;
};
Entities.GetBaseStrength = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][20];
	}
	return 0;
};
Entities.GetStrength = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][21];
	}
	return 0;
};
Entities.GetBaseAgility = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][22];
	}
	return 0;
};
Entities.GetAgility = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][23];
	}
	return 0;
};
Entities.GetBaseIntellect = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][24];
	}
	return 0;
};
Entities.GetIntellect = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return GameUI.UnitState[iUnitEntIndex][25];
	}
	return 0;
};
Entities.GetAllStats = (iUnitEntIndex) => {
	return Entities.GetStrength(iUnitEntIndex) + Entities.GetAgility(iUnitEntIndex) + Entities.GetIntellect(iUnitEntIndex);
};
Entities.GetBaseAllStats = (iUnitEntIndex) => {
	return Entities.GetBaseStrength(iUnitEntIndex) + Entities.GetBaseAgility(iUnitEntIndex) + Entities.GetBaseIntellect(iUnitEntIndex);
};
Entities.GetPrimaryAttribute = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		let iBuffIndex = Entities.FindBuffByName(iUnitEntIndex, "modifier_hero_attribute");
		if (iBuffIndex == -1) return -1;
		return Buffs.GetStackCount(iUnitEntIndex, iBuffIndex);
	}
};

GameUI.PopupClicked = function (sPopupID, sAction) {
	GameEvents.SendEventClientSide("custom_popup_clicked", {
		popup_id: sPopupID,
		action: sAction,
	});
};
GameUI.GetHUDSeed = function () {
	return 1080 / Game.GetScreenHeight();
};
GameUI.CorrectPositionValue = function (value) {
	return GameUI.GetHUDSeed() * value;
};
GameUI.GetCursorEntity = function () {
	var targets = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
	var targets1 = targets.filter(function (e) {
		return e.accurateCollision;
	});
	var targets2 = targets.filter(function (e) {
		return !e.accurateCollision;
	});
	targets = targets1;
	if (targets1.length == 0) {
		targets = targets2;
	}
	if (targets.length == 0) {
		return -1;
	}
	return targets[0].entityIndex;
};

function alertObj(obj, name, str) {
	var output = "";
	if (name == null) {
		name = toString(obj);
	}
	if (str == null) {
		str = "";
	}
	$.Msg(str + name + "\n" + str + "{");
	for (var i in obj) {
		var property = obj[i];
		if (typeof (property) == "object") {
			alertObj(property, i, str + "\t");
		} else {
			output = i + " = " + property + "\t(" + typeof (property) + ")";
			$.Msg(str + "\t" + output);
		}
	}
	$.Msg(str + "}");
}

function DeepPrint(obj) {
	return alertObj(obj);
}

function polygonArray(polygon) {
	var p = [];
	for (var k in polygon) {
		p.push(polygon[k]);
	}
	return p;
}

function IsPointInPolygon(point, polygon) {
	var j = polygon.length - 1;
	var bool = 0;
	for (var i = 0; i < polygon.length; i++) {
		var polygonPoint1 = polygon[i];
		var polygonPoint2 = polygon[j];
		if (((polygonPoint2.y < point[1] && polygonPoint1.y >= point[1]) || (polygonPoint1.y < point[1] && polygonPoint2.y >= point[1])) && (polygonPoint2.x <= point[0] || polygonPoint1.x <= point[0])) {
			bool = bool ^ (((polygonPoint2.x + (point[1] - polygonPoint2.y) / (polygonPoint1.y - polygonPoint2.y) * (polygonPoint1.x - polygonPoint2.x)) < point[0]) ? 1 : 0);
		}
		j = i;
	}
	return bool == 1;
}

function ErrorMessage(msg, sound) {
	sound = sound || "General.CastFail_Custom";
	GameUI.SendCustomHUDError(msg, sound);
}

function OnErrorMessage(data) {
	ErrorMessage(data.message, data.sound);
}

function intToARGB(i) {
	return ('00' + (i & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 8) & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 16) & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 24) & 0xFF).toString(16)).substr(-2);
}

var waveInfo = {};
for (const sUnitName in CustomUIConfig.NpcEnemyKv) {
	if (sUnitName == "Version") continue;
	const tData = CustomUIConfig.NpcEnemyKv[sUnitName];
	if (typeof (tData) != "object") continue;
	waveInfo[sUnitName] = {
		StatusHealth: tData.StatusHealth,
		MagicalResistance: tData.MagicalResistance,
		ArmorPhysical: tData.ArmorPhysical,
		MovementSpeed: tData.MovementSpeed,
		Ability1: tData.Ability1,
		Ability2: tData.Ability2,
	};
}

function GetWaveInfo(sUnitName) {
	return waveInfo[sUnitName];
}

var abilitiesRequires = {};
for (const sAbilityName in CustomUIConfig.AbilitiesKv) {
	if (sAbilityName == "Version") continue;
	const tAbilityData = CustomUIConfig.AbilitiesKv[sAbilityName];
	if (typeof (tAbilityData) != "object") continue;
	if (tAbilityData.Requires) {
		abilitiesRequires[sAbilityName] = [];
		for (const k in tAbilityData.Requires) {
			const tRequire = tAbilityData.Requires[k];
			abilitiesRequires[sAbilityName].push(tRequire.UnitName);
		}
	}
}

function GetAbilityRequires(sAbilityName) {
	return abilitiesRequires[sAbilityName];
}

function GetItemRarity(sItemName) {
	for (var sRarity in CustomUIConfig.ItemsRarityKv) {
		var tList = CustomUIConfig.ItemsRarityKv[sRarity];
		for (var _ in tList) {
			if (tList[_] == sItemName)
				return parseInt(sRarity);
		}
	}
	return 0;
}

var CardList = {};
for (const sRarity in CustomUIConfig.CardTypeKv) {
	const tCards = CustomUIConfig.CardTypeKv[sRarity];
	for (const sCardName in tCards) {
		const sAbilityName = tCards[sCardName];

		let tData = {
			ability_name: sAbilityName,
			abilities: [],
		};
		if (sRarity.indexOf("summon_") != -1) {
			tData.rarity = sRarity.substring(7);
			tData.b_summon = true; // 召唤的卡
		} else {
			tData.rarity = sRarity;
		}
		if (CustomUIConfig.UnitsKv[sCardName]) {
			let tUnitData = CustomUIConfig.UnitsKv[sCardName];
			tData.attack_range = tUnitData.AttackRange;
			tData.attribute_primary = tUnitData.AttributePrimary;
			tData.carry = tUnitData.Carry || 0;
			tData.farmer = tUnitData.Farmer || 0;
			tData.support = tUnitData.Support || 0;
			tData.disabler = tUnitData.Disabler || 0;
			for (let index = 1; index <= 32; index++) {
				let sKey = "Ability" + index;
				let sAbName = tUnitData[sKey];
				if (sAbName && sAbName.indexOf("empty_") == -1 && sAbName.indexOf("hidden_") == -1) {
					let tAbilityData = CustomUIConfig.AbilitiesKv[sAbName];
					if (tAbilityData && !(tAbilityData.AbilityBehavior && tAbilityData.AbilityBehavior.indexOf("DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES") != -1)) {
						if (tAbilityData.AbilityType && tAbilityData.AbilityType.indexOf("DOTA_ABILITY_TYPE_ATTRIBUTES") != -1) {
							if (!tData.talents) tData.talents = [];
							tData.talents.push(sAbName);
						} else {
							tData.abilities.push(sAbName);
						}
					}
				}
			}
		}
		CardList[sCardName] = tData;
	}
}

function IsCardAbility(sAbilityName) {
	for (var sCardName in CardList) {
		var tData = CardList[sCardName];
		if (tData.ability_name == sAbilityName)
			return true;
	}
	return false;
}

function GetCardRarity(sCardName) {
	return CardList[sCardName].rarity;
}

function GetCardRole(sCardName, sRoleName) {
	return CardList[sCardName][sRoleName.toLowerCase()];
}

function IsSumonCard(sCardName) {
	if (!IsNull(CardList[sCardName]) && CardList[sCardName].b_summon == true) {
		return true;
	}
	return false;
}

function GetCardAbilities(sCardName) {
	return CardList[sCardName].abilities;
}

function GetCardAttributePrimary(sCardName) {
	return Attributes[CardList[sCardName].attribute_primary];
}

function GetCardAttackRange(sCardName) {
	return CardList[sCardName].attack_range;
}

function CardNameToAbilityName(sCardName) {
	return CardList[sCardName].ability_name;
}

function AbilityNameToCardName(sAbilityName) {
	for (var sCardName in CardList) {
		var tData = CardList[sCardName];
		if (tData.ability_name == sAbilityName)
			return sCardName;
	}
}

var tSkinNameToUnitName = {};
for (const sSkinName in CustomUIConfig.AssetModifiersKv) {
	const tAssetModifiers = CustomUIConfig.AssetModifiersKv[sSkinName];
	for (const _ in tAssetModifiers) {
		const tAssetModifier = tAssetModifiers[_];
		if (tAssetModifier.type == "name") {
			tSkinNameToUnitName[sSkinName] = tAssetModifier.asset;
		}
	}
}

function SkinNameToUnitName(sSkinName) {
	return tSkinNameToUnitName[sSkinName];
}

function GetHeroID(sHeroName) {
	return CustomUIConfig.HeroIDKv[sHeroName];
}

function GetHeroNameByID(sHeroID) {
	for (var sHeroName in CustomUIConfig.HeroIDKv) {
		if (CustomUIConfig.HeroIDKv[sHeroName] == sHeroID)
			return sHeroName;
	}
	return;
}


var DefaultSkin = {};
for (var k in CustomUIConfig.HeroIDKv) {
	DefaultSkin[CustomUIConfig.HeroIDKv[k]] = k;
};
var ITEM_CATEGORY_HERO_SKIN = 1; // 英雄皮肤
var ITEM_CATEGORY_COURIER = 2.1; // 信使
var ITEM_CATEGORY_COURIER_FX = 2.2; // 信使特效
var ITEM_CATEGORY_PROPS_FUNCTIONAL = 3.1; // 功能道具
var ITEM_CATEGORY_PROPS_OTHER = 3.2; // 其他道具
var ITEM_CATEGORY_PROPS_STAR_STONE = 3.3; // 星石道具
var ITEM_CATEGORY_PROPS_BP = 3.4; // battlepass 经验
var ITEM_CATEGORY_WIDGETS_BORDER = 4.1; // 边框挂件
var ITEM_CATEGORY_WIDGETS_EMBLEM = 4.2; // 勋章挂件
var ITEM_CATEGORY_WIDGETS_DESIGNATION = 4.3; // 称号挂件
var ITEM_CATEGORY_FRAGMENT = 5.1; // 碎片商店可购买的物品
function GetItemCategory(sItemName) {
	var sUnitName = SkinNameToUnitName(sItemName);
	if (!IsNull(sUnitName)) //皮肤
		return ITEM_CATEGORY_HERO_SKIN;
	else if (IsNull(sItemName))
		return ITEM_CATEGORY_PROPS_OTHER;
	else if (FindKey(DefaultSkin, sItemName) != undefined) //默认皮肤
		return ITEM_CATEGORY_HERO_SKIN;
	else if (sItemName.indexOf("courier_fx") != -1)
		return ITEM_CATEGORY_COURIER_FX;
	else if (sItemName.indexOf("courier") != -1)
		return ITEM_CATEGORY_COURIER;
	else if (sItemName.indexOf("item_") != -1 || sItemName == "hero_card")
		return ITEM_CATEGORY_PROPS_FUNCTIONAL;
	else if (sItemName.indexOf("stars_stone") != -1)
		return ITEM_CATEGORY_PROPS_STAR_STONE;
	else if (sItemName.indexOf("battle_exp") != -1)
		return ITEM_CATEGORY_PROPS_BP;
	else if (sItemName.indexOf("battlepass") != -1)
		return ITEM_CATEGORY_PROPS_BP;
	else if (sItemName.indexOf("border_") != -1)
		return ITEM_CATEGORY_WIDGETS_BORDER;
	else if (sItemName.indexOf("emblem_") != -1)
		return ITEM_CATEGORY_WIDGETS_EMBLEM;
	else if (sItemName.indexOf("designation_") != -1)
		return ITEM_CATEGORY_WIDGETS_DESIGNATION;
	else
		return ITEM_CATEGORY_PROPS_OTHER;
}

function ShowMsgPopup(sMsg, iDelay) {
	if (IsNull(sMsg) || sMsg == "") {
		return;
	}
	iDelay = iDelay || 0;
	OpenPopup("common_popup", {
		msg: sMsg,
		delay: iDelay,
	});
}

/**
 * 打开指定popup_id的popup
 * popup的文件格式请通用为
 * file://{resources}/layout/custom_game/popups/popup_id/popup_id.xml
 * NOTE:新增的popup请在toolmode.js的DebugCompilePopups函数里新增一行用于debug的编译功能
 * @param popup_id:
 * @param data: 格式示例 { msg: "xxx", delay: 1 }
 */
function OpenPopup(popup_id, data) {
	function readData(data) {
		var retStr = "";
		for (var key in data) {
			retStr += key + "=" + data[key] + "&";
		}
		return retStr;
	}
	$.Msg("open popup:" + popup_id);

	switch (popup_id) {
		case "ItemDetail":
			GameUI.GoodPanelCreated = true;
			break;
		default:
			break;
	}
	print("popup_id:", popup_id);
	let sParams = IsNull(data) ? '' : readData(data);
	$.DispatchEvent(
		"UIShowCustomLayoutPopupParameters",
		popup_id,
		"file://{resources}/layout/custom_game/popups/" + popup_id + "/" + popup_id + ".xml",
		sParams);
}

GameUI.CustomUIConfig()._Request_QueueIndex = GameUI.CustomUIConfig()._Request_QueueIndex || 0;
GameUI.CustomUIConfig()._Request_Table = GameUI.CustomUIConfig()._Request_Table || {};

function Request(event, data, func, timeout) {
	let index = "-1";
	if (typeof func === "function") {
		index = (GameUI.CustomUIConfig()._Request_QueueIndex++).toString();
		GameUI.CustomUIConfig()._Request_Table[index] = func;
	}
	GameEvents.SendCustomGameEventToServer("service_events_req", {
		event: event,
		data: JSON.stringify(data),
		queueIndex: index
	});
	timeout = timeout || REQUEST_TIME_OUT;
	$.Schedule(timeout, function () {
		delete GameUI.CustomUIConfig()._Request_Table[index];
	});
}
GameEvents.Subscribe("service_events_res", function (data) {
	let index = data.queueIndex || "";
	let func = GameUI.CustomUIConfig()._Request_Table[index];
	if (!func) return;
	delete GameUI.CustomUIConfig()._Request_Table[index];
	if (func) {
		func(JSON.parse(data.result));
	};
});

function GetLocalPlayerTicket() {
	var table = CustomNetTables.GetTableValue("service", "player_data");
	var playerData = table[Players.GetLocalPlayer().toString()];
	return playerData.ticket_num;
}

function GetLocalPlayerStar() {
	var table = CustomNetTables.GetTableValue("service", "player_data");
	var playerData = table[Players.GetLocalPlayer().toString()];
	return playerData.star_num;
}
function GetLocalPlayerFragment() {
	var table = CustomNetTables.GetTableValue("service", "player_data");
	var playerData = table[Players.GetLocalPlayer().toString()];
	return playerData.fragment;
}

/**
 * 获取游戏是团队还是个人模式
 * @return: 0:团队，1:个人
 */
Game.GetCountingMode = function () {
	var table = CustomNetTables.GetTableValue("common", "game_mode_info");
	return table.counting_mode;
};
Game.GetDifficulty = function () {
	var slocalPlayerID = Players.GetLocalPlayer().toString();
	var table = CustomNetTables.GetTableValue("common", "game_mode_info");
	return table.difficulty[slocalPlayerID];
};

// 获取ParentPanel当前选中的button
function GetPanelSelectedButton(ParentPanel) {
	var selectedButton = null;
	for (var i = 0; i < ParentPanel.GetChildCount(); i++) {
		selectedButton = ParentPanel.GetChild(i).GetSelectedButton();
		if (!IsNull(selectedButton)) {
			break;
		}
	}
	return selectedButton;
}
// 将parent当前选中的切换为child，如果child为null则只取消当前选中
function SwitchSelected(parent, child) {
	var SelectedButton = GetPanelSelectedButton(parent);
	if (SelectedButton)
		$.DispatchEvent("SetPanelSelected", SelectedButton, false);
	if (!IsNull(child)) {
		$.DispatchEvent("SetPanelSelected", child, true);
	}
}

function IsNull(variable) {
	return variable == null || variable == undefined || (typeof (variable) == "number" && isNaN(variable));
}

/**
 * 判断任意数量变量是否为空
 * @params any
 * @return 如果任一变量为空返回true，否则返回false
 */
function AnyNull() {
	let res = IsNull(arguments[0]);
	for (let index = 1; ((index < arguments.length) && !res); index++) {
		res = res || IsNull(arguments[index]);
	}
	return res;
}

/**
 * 判断任意数量panel是否存在
 * @params panel
 * @return 如果任一panel不存在返回false，否则返回true
 */
function IsValidPanel() {
	function _IsValidPanel(panel) {
		return panel != null && panel != undefined && typeof (panel.IsValid) == "function" && panel.IsValid();
	}
	let res = _IsValidPanel(arguments[0]);
	for (let index = 1; ((index < arguments.length) && res); index++) {
		const ag = arguments[index];
		res = res && _IsValidPanel(ag);
	}
	return res;
}

//段位相关
var iShowLocalRank = 2000; //排名小于x的时候显示本地玩家具体排名
var rankNumInfo = [1, 2, 3, 4, 9, 100]; //前x名的段位划分
var rankInfo = [3, 10, 15, 30, 45, 65, 100]; //前x%的段位划分
function GetRankLevel(iRank, iRankPercent) {
	for (var i in rankNumInfo) {
		if (iRank <= rankNumInfo[i])
			return i;
	}
	for (var j in rankInfo) {
		if (iRankPercent <= rankInfo[j])
			return parseInt(i) + parseInt(j) + 1;
	}
	return rankNumInfo.length + rankInfo.length - 1;
}

function SwitchBorder(RootPanel, FxBorder, sBorderName) {
	if (RootPanel && FxBorder && sBorderName) {
		if (FX_Border.indexOf(RootPanel.border) != -1)
			FxBorder.FireEntityInput(RootPanel.border, "DestroyImmediately", "1");
		RootPanel.SwitchClass("Border", sBorderName);
		RootPanel.border = sBorderName;
		if (FX_Border.indexOf(RootPanel.border) != -1)
			FxBorder.FireEntityInput(RootPanel.border, "Start", "1");
	}
}

function FireBorderFx(RootPanel, FxBorder) {
	if (RootPanel && RootPanel.border && FxBorder) {
		FxBorder.FireEntityInput(RootPanel.border, "Start", "1");
	}
}

function LuaTable2JsArr(table) {
	var arr = [];
	for (var i in table) {
		arr.push(table[i]);
	}
	return arr;
}

function GetNameBySteamID(sSteamID) {
	return CustomUIConfig.tSteamID2Name[sSteamID];
}

function RequestSteamID2Name(tSteamIDs, fCallBack) {
	var tRequestSteamIDs = [];
	// 仅请求还未获取的steamid
	for (var i in tSteamIDs) {
		if (IsNull(CustomUIConfig.tSteamID2Name[tSteamIDs[i]])) {
			tRequestSteamIDs.push(tSteamIDs[i]);
		}
	}
	if (tRequestSteamIDs.length < 1) {
		if (typeof (fCallBack) == "function") {
			fCallBack();
		}
		return;
	}

	let url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" + STEAM_WEB_KEY + "&steamids=" + tRequestSteamIDs.join(',');
	$.AsyncWebRequest(url, {
		type: 'GET',
		timeout: 6000,
		success: function (tData, b, c) {
			for (var i in tData.response.players) {
				CustomUIConfig.tSteamID2Name[tData.response.players[i].steamid] = tData.response.players[i].personaname;
			}
			if (typeof (fCallBack) == "function") {
				fCallBack();
			}
		},
		error: function (a) {
			$.Msg("RequestSteamID2Name fail");
		},
	});
}

// 返回可试用的物品类型
function getPreviewItemType(sItemName) {
	if (sItemName.indexOf("courier_fx") != -1)
		return "courier_fx";
	else if (sItemName.indexOf("courier") != -1)
		return "courier";
	else if (sItemName.indexOf("border_") != -1)
		return "border";
	else if (sItemName.indexOf("emblem_") != -1)
		return "emblem";
	else if (sItemName.indexOf("designation_") != -1)
		return "designation";
	else
		return "invalid";
}

function SetDialogVariableFromKV(Panel, KV) {
	for (const key in KV) {
		const value = KV[key];
		Panel.SetDialogVariable(key, value);
	}
}
function SetDialogVariableIntFromKV(Panel, KV) {
	for (const key in KV) {
		const value = KV[key];
		Panel.SetDialogVariableInt(key, value);
	}
}

(function () {
	GameEvents.Subscribe("error_message", OnErrorMessage);
	Players.GetLocalPlayerTicket = GetLocalPlayerTicket;
	Players.GetLocalPlayerStar = GetLocalPlayerStar;
	Players.GetLocalPlayerFragment = GetLocalPlayerFragment;
})();