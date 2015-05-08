#include <a_samp>
#include <kolory>
/*
NFUNK BY NICKK888
Przydatne Funkcje do SAMP'a.
Wersja 1.0 Beta

Funkcje:

//Beta 1.0
GetPlayerFPS(playerid);
ExRandom(Minnumber,Maxnumber);
ExBan(playerid);
ExKick(playerid);
ChangeHostName(String[]);
AntiSpawnKill(playerid, Time); 
GetVehicleSpeed(vehicleid);  
IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY);
IsVehicleInArea(vehicleid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY);
IsVehicleInUse(vehicleid);
ClearPlayerChat(playerid);
ClearGlobalChat();
ExGivePlayerMoney(playerid, amount);
SendPMtoPlayer(senderid, targetid, message[]),
PayMoneyFromPlayerToPlayer(playerid, targetid, amount);
GetPlayerDistanceToPlayer(playerid, targetid);
GetVehicleIDModelName(vehicleid);
GMRestartEx(Time);
GMRestart();

//Beta 2.0
GetPlayerIDFromName(name[]);
IsVehicleABike(vehicleid);
IsVehicleARC(vehicleid);
IsVehicleABoat(vehicleid);
IsVehicleAAirplane(vehicleid);
IsVehicleAHelicopter(vehicleid);
PlayerName(playerid);

SetStringToFile(file[], string[], 1 = Listmode 0 = Normalmode); //USUNIETE !
IsStringInFile(file[], string[]); //USUNIETE !
GetLinesFromFile(file[], target[]); //USUNIETE !
FreezePlayer(playerid, time); //USUNIETE !

//Beta 2.1
SetVehicleSpeed(vehicleid, Float:predkosc);

//Beta 3.0
KEY_AIM - Definicja Prawego przycisku myszy
GetOnFootSpeed(playerid); 
IsDateUpToDate(Day, Month, Year);
GetWeekDayNum(Day, Month, Year);
IsNumeric(string[]);
IsPlayerInInterior(playerid);
IsPlayerInVirtualWorld(playerid);
IsPlayerInRangeOfPlayer(playerid, playerid2, Float:range);
IsVehicleInRangeOfPlayer(vehicleid, playerid, Float:range);
GetConnectedPlayers();
GetConnectedAdmins();
GetFrontXYFromVehicle(vehicleid, Float:range, & Float:X2, & Float:Y2);
GetBackXYFromVehicle(vehicleid, Float:range, & Float:X2, & Float:Y2);
GetFrontXYFromPlayer(playerid, Float:range, & Float:X2, & Float:Y2);
GetBackXYFromPlayer(playerid, Float:range, & Float:X2, & Float:Y2);
IsPlayerVehicleDriver(playerid);
IsPlayerVehiclePassenger(playerid);
IsPlayerPassengerInVehicle(playerid, vehicleid);
IsPlayerOnFoot(playerid);
SetPlayerMoneyEx(playerid, money);
SetPlayerWeapon(playerid, weaponid);
GivePlayerScore(playerid, score);
GetVehicleDriverID(vehicleid);
GetVehicleDriverName(vehicleid);
ConvertMStoSeconds(miliseconds);
ConvertMStoMinutes(miliseconds);
ConvertMStoHours(miliseconds);
MovePlayerCamera(playerid, Float:FromX, Float:FromY, Float:FromZ, Float:ToX, Float:ToY, Float:ToZ, Float:FromXR, Float:FromYR, Float:FromZR, Float:ToXR, Float:ToYR, Float:ToZR, time);
CreateVehiclesFromPoint(Float:X, Float:Y, Float:Z, Float:ZRot, amount, Float:range, modelid, color1, color2, respawndelay);

//Beta 3.6
GetWeaponSlot(weaponid);
GetTimestamp(minutes, hours, days, weeks, months, years);
GetDateFromDays(days, &day, &month, &year);
ConvertSecondstoMS(seconds);
ConvertMinutestoMS(minutes);
ConvertHourstoMS(hours);

//Beta 4.1
IsPlayerStayAim(playerid)
IsPlayerSwim(playerid)
IsPlayerJump(playerid)
IsPlayerParaFall(playerid)
IsPlayerParaGlide(playerid)
IsPlayerFall(playerid)

*/
#define KEY_AIM KEY_HANDBRAKE

new BannerTimer[MAX_PLAYERS];
new KickerTimer[MAX_PLAYERS];
new ASKTimer[MAX_PLAYERS];

new ASKTime[MAX_PLAYERS];
new GMXTime;

new VehicleNames[][] = {
"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Fireguard", "Trashmaster", "Strech", "Manana",
"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
"Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife",
"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo",
"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito",
"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring",
"Sandking", "Blista Compact", "PoliceMaverick", "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "MountainBike", "Beagle", "Cropduster","Stunt",  "Baker",
"Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "CementCar", "Tow Truck", "Fortune",
"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Fel tzer", "Remington", "Slamvan", "BLADe", "Freight", "Streak",
"Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Straz Pozarna LA", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
"Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance",
"RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
"Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer 3", "Emperor", "Wayfarer", "Euros", "Hotdog",
"Club", "Freight Carriage", "Trailer 4", "Andromada", "Dodo", "RC Cam", "Launch", "PoliceCar (LSPD)", "PoliceCar (SFPD)",
"PoliceCar (LVPD)", "Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A",
"Luggage Trailer B", "Stairs", "Boxville", "Tiller", "Utility Trailer" };

stock PlayerName(playerid)
{
	new Gname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Gname, sizeof(Gname));
	return Gname;
}

stock bool:IsVehicleABike(vehicleid) //By Nickk888
{
	new mid = GetVehicleModel(vehicleid);
	if(mid == 509 || mid == 481 || mid == 510) return true;
	return false;
}

stock bool:IsVehicleARC(vehicleid) //By Nickk888
{
	new mid = GetVehicleModel(vehicleid);
	if(mid == 441 || mid == 464 || mid == 465 || mid == 501 || mid == 564 || mid == 594) return true;
	return false;
}

stock bool:IsVehicleABoat(vehicleid) //By Nickk888
{
	new mid = GetVehicleModel(vehicleid);
	if(mid == 472 || mid == 473 || mid == 493 || mid == 595 || mid == 484 || mid == 430 || mid == 453 || mid == 452 || mid == 446 || mid == 454) return true;
	return false;
}

stock bool:IsVehicleAAirplane(vehicleid) //By Nickk888
{
	new mid = GetVehicleModel(vehicleid);
	if(mid == 460 || mid == 476 || mid == 511 || mid == 512 || mid == 513 || mid == 519 || mid == 520 || mid == 553 || mid == 577 || mid == 592 || mid == 593)return true;
	return false;
}

stock bool:IsVehicleAHelicopter(vehicleid) //By Nickk888
{
	new mid = GetVehicleModel(vehicleid);
	if(mid == 469 || mid == 487 || mid == 488 || mid == 497 || mid == 548 || mid == 563 || mid == 417 || mid == 425 || mid == 447) return true;
	return false;
}

stock GetPlayerIDFromName(name[]) //By Correlli
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			new playername2[MAX_PLAYER_NAME];
			GetPlayerName(i, playername2, sizeof(playername2));
			if(strcmp(playername2, name, true, strlen(name)) == 0) return i;
		}
	}
	return INVALID_PLAYER_ID;
}

stock GMRestart() //By Nickk888
{
	SendRconCommand("GMX");
	return 1;
}

stock GMRestartEx(time) //By Nickk888
{
	GMXTime = time;
	SetTimer("GMX", 1000, true);
	return 1;
}

stock GetVehicleIDModelName(vehicleid) //By Nickk888
{
	new vname[100];
	format(vname,sizeof(vname),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400][0]);
	return vname;
}

stock GetPlayerDistanceToPlayer(playerid, targetid) //By Nickk888
{
	new Float:x, Float:y, Float:z, Float:Distance;
	GetPlayerPos(targetid, x, y, z);
	Distance = GetPlayerDistanceFromPoint(playerid, x, y, z);
	return floatround(Distance, floatround_round);
}

stock GetPlayerDistanceToPoint(playerid, Float:X, Float:Y, Float:Z) //By Nickk888
{
	new Float:Distance;
	Distance = GetPlayerDistanceFromPoint(playerid, X, Y, Z);
	return floatround(Distance, floatround_round);
}

stock PayMoneyFromPlayerToPlayer(playerid, targetid, amount) //By Nickk888
{
	ExGivePlayerMoney(playerid, - amount);
	ExGivePlayerMoney(targetid, + amount);
	return 1;
}

stock SendPMtoPlayer(playerid, targetid, message[]) //By Nickk888
{
	new string[300];
	new Gname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, Gname, sizeof(Gname));
	format(string, sizeof(string), "<<< %s: %s",Gname,message);
	SendClientMessage(targetid,COLOR_YELLOW, string);
	GetPlayerName(targetid, Gname, sizeof(Gname));
	format(string, sizeof(string), ">>> %s: %s",Gname,message);
	SendClientMessage(playerid,COLOR_YELLOW, string);
	return 1;
}

stock ExGivePlayerMoney(playerid, amount) //By Nickk888
{
	new string[50];
	GivePlayerMoney(playerid, amount);
	if(amount >= 0)
	{
		format(string, sizeof(string), "~g~+%i $",amount);
		GameTextForPlayer(playerid, string, 5000,1);
	}
	if(amount < 0)
	{
		format(string, sizeof(string), "~r~%i $",amount);
		GameTextForPlayer(playerid, string, 5000,1);
	}
	return 1;
}

stock ClearPlayerChat(playerid) //By Nickk888
{
	for(new i; i < 50; i++)
	{
		SendClientMessage(playerid, COLOR_RED, " ");
	}
	return 1;
}

stock ClearGlobalChat() //By Nickk888
{
	for(new i; i < 50; i++)
	{
		SendClientMessageToAll(COLOR_RED, " ");
	}
	return 1;
}

stock bool:IsVehicleInUse(vehicleid) //By Nickk888
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
		{
			if(GetPlayerVehicleID(i) == vehicleid) return true;
		}
	}
	return false;
}

stock bool:IsVehicleInArea(vehicleid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY) //By Nickk888
{
	new Float:X, Float:Y, Float:Z;
	GetVehiclePos(vehicleid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) return true;
	return false;
}

stock bool:IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY) //By Nickk888
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) return true;
	return false;
}

stock GetVehicleSpeed(vehicleid) //By Nickk888
{
	new Float:predx;
	new Float:predy;
	new Float:predz;
	new Float:pred_a;
	new pred_b;
	GetVehicleVelocity(vehicleid, predx, predy, predz);
	pred_a = floatsqroot(((predx*predx)+(predy*predy))+(predz*predz)) * 195.199999;
	pred_b = floatround(pred_a);
	return pred_b;
}

stock AntiSpawnKill(playerid, time) //By Nickk888
{
	SetPlayerHealth(playerid, 99999);
	ASKTime[playerid] = time;
	ASKTimer[playerid] = SetTimerEx("ASK",1000,true,"i",playerid);
	return 1;
}

stock GivePlayerScore(playerid, score) //By Nickk888
{
	SetPlayerScore(playerid, GetPlayerScore(playerid) + score);
	return 1;
}

stock GetTimestamp(minutes, hours, days, weeks, months, years) //By Nickk888
{
	new ts;
	if(minutes > 0) ts += (60 * minutes);
	if(hours > 0) ts += (60 * (60 * hours));
	if(days > 0) ts += (60 * 60 * (24 * days));
	if(weeks > 0) ts += (60 * 60 * 24 * (7 * weeks));
	if(months > 0) ts += (60 * 60 * 24 * (30 * months));
	if(years > 0) ts += (60 * 60 * 24 * (365 * years));
	return ts;
}

stock GetDateFromDays(days, &day, &month, &year) //By Nickk888
{
	new tempday, tempmonth, tempyear;
	getdate(tempyear, tempmonth, tempday);
	for(new i; i < days; i++)
	{
		if(tempmonth == 1) //January
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 2) //February
		{
			//Year leap checker by Nickk888
			new ylc = 1;new yl = 2013;
			new yld = tempyear - yl;
			new lday;
			if(yld > 0)
			{
				for(new id; id < yld; id++){
					if(ylc < 4) ylc++;
					else ylc = 1;}
			}
			if(yld == 0 || ylc >= 1 && ylc < 4) lday = 28;
			else lday = 29;
			////////////////////////
			if(tempday < lday) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 3) //March
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 4) //April
		{
			if(tempday < 30) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 5) //May
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 6) //June
		{
			if(tempday < 30) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 7) //July
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 8) //August
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 9) //September
		{
			if(tempday < 30) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 10) //October
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 11) //November
		{
			if(tempday < 30) tempday++;
			else{
				tempmonth++;
				tempday = 0;}
		}
		if(tempmonth == 12) //December
		{
			if(tempday < 31) tempday++;
			else{
				tempmonth = 1;
				if(days == i) tempday = 1;
				else tempday = 0;
				tempyear++;}
		}
	}
	day = tempday;
	month = tempmonth;
	year = tempyear;
	return 1;
}

stock GetPlayerFPS(playerid) //By ipsBruno
{
    SetPVarInt(playerid, "DrunkL", GetPlayerDrunkLevel(playerid));
    if(GetPVarInt(playerid, "DrunkL") < 100) SetPlayerDrunkLevel(playerid, 2000);
        else{
            if(GetPVarInt(playerid, "LDrunkL") != GetPVarInt(playerid, "DrunkL"))
            {
                SetPVarInt(playerid, "FPS", (GetPVarInt(playerid, "LDrunkL") - GetPVarInt(playerid, "DrunkL")));
                SetPVarInt(playerid, "LDrunkL", GetPVarInt(playerid, "DrunkL"));
                if((GetPVarInt(playerid, "FPS") > 0) && (GetPVarInt(playerid, "FPS") < 256))
                {
                    return GetPVarInt(playerid, "FPS") - 1;
                }
            }
        }
    return 0;
}

stock IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

stock bool:IsPlayerInInterior(playerid) //By Nickk888
{
	if(GetPlayerInterior(playerid) == 0) return false;
	return true;
}

stock bool:IsPlayerInVirtualWorld(playerid) //By Nickk888
{
	if(GetPlayerVirtualWorld(playerid) == 0) return false;
	return true;
}

stock bool:IsPlayerInRangeOfPlayer(playerid, playerid2, Float:range) //By Nickk888
{
	new Float:dist, Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid2, X, Y, Z);
	if(IsPlayerInRangeOfPoint(playerid, range, X, Y, Z)) return true;
	return false;
}

stock bool:IsVehicleInRangeOfPlayer(vehicleid, playerid, Float:range) //By Nickk888
{
	new Float:dist, Float:X, Float:Y, Float:Z;
	GetVehiclePos(vehicleid, X, Y, Z);
	if(IsPlayerInRangeOfPoint(playerid, range, X, Y, Z)) return true;
	return false;
}

stock GetConnectedPlayers() //By Nickk888
{
	new players;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i)) players++;
	}
	return players
}

stock GetConnectedAdmins() //By Nickk888
{
	new players;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && IsPlayerAdmin(i)) players++;
	}
	return players
}

stock GetFrontXYFromVehicle(vehicleid, Float:range, & Float:X2, & Float:Y2) //By Nickk888
{
	new Float:R;
	GetVehicleZAngle(vehicleid, R);
	X2 += (range * floatsin(-R, degrees));
	Y2 += (range * floatcos(-R, degrees));
	return 1;
}

stock GetBackXYFromVehicle(vehicleid, Float:range, & Float:X2, & Float:Y2) //By Nickk888
{
	new Float:R;
	GetVehicleZAngle(vehicleid, R);
	X2 -= (range * floatsin(-R, degrees));
	Y2 -= (range * floatcos(-R, degrees));
	return 1;
}

stock GetFrontXYFromPlayer(playerid, Float:range, & Float:X2, & Float:Y2) //By Nickk888
{
	new Float:R;
	GetPlayerFacingAngle(playerid, R);
	X2 += (range * floatsin(-R, degrees));
	Y2 += (range * floatcos(-R, degrees));
	return 1;
}

stock GetBackXYFromPlayer(playerid, Float:range, & Float:X2, & Float:Y2) //By Nickk888
{
	new Float:R;
	GetPlayerFacingAngle(playerid, R);
	X2 -= (range * floatsin(-R, degrees));
	Y2 -= (range * floatcos(-R, degrees));
	return 1;
}

stock bool:IsPlayerVehicleDriver(playerid) //By Nickk888
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return true;
	return false;
}

stock bool:IsPlayerVehiclePassenger(playerid) //By Nickk888
{
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return true;
	return false;
}

stock bool:IsPlayerOnFoot(playerid) //By Nickk888
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return true;
	return false;
}

stock SetPlayerWeapon(playerid, weaponid) //By Nickk888
{
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, weaponid);
	return 1;
}

stock GetVehicleDriverID(vehicleid) //By Nickk888
{
	new id = -1;
	for(new i; i < MAX_PLAYERS; i++)
	{
		new vid = GetPlayerVehicleID(i);
		if(vid == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
	}
	return id;
}
stock bool:IsPlayerPassengerInVehicle(playerid, vehicleid) //By Nickk888
{
	new vid = GetPlayerVehicleID(playerid);
	if(vid == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return true;
	return false;
}

stock GetVehicleDriverName(vehicleid) //By Nickk888
{
	new name[100];
	for(new i; i < MAX_PLAYERS; i++)
	{
		new vid = GetPlayerVehicleID(i);
		if(vid == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER)
		{
			GetPlayerName(i, name, sizeof(name));
			return name;
		}
	}
	return name;
}

stock bool:IsPlayerStayAim(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 1167 || aid == 1160 || aid == 1161 || aid == 1162 || aid == 1163) return true;
	return false;
}

stock bool:IsPlayerSwim(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 1541 || aid == 1538 || aid == 1539 || aid == 1544) return true;
	return false;
}

stock bool:IsPlayerJump(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 1195 || aid == 1198) return true;
	return false;
}

stock bool:IsPlayerParaFall(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 958 || aid == 1134 || aid == 959 || aid == 962 || aid == 961) return true;
	return false;
}

stock bool:IsPlayerParaGlide(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 971 || aid == 965 || aid == 978 || aid == 976 || aid == 963) return true;
	return false;
}

stock bool:IsPlayerFall(playerid) //By Nickk888
{
	new aid = GetPlayerAnimationIndex(playerid);
	if(aid == 1130) return true;
	return false;
}

stock ConvertSecondstoMS(seconds) //By Nickk888
{
	return seconds * 1000;
}

stock ConvertMinutestoMS(minutes) //By Nickk888
{
	return minutes * 1000 * 60;
}

stock ConvertHourstoMS(hours) //By Nickk888
{
	return hours * 1000 * 60 * 60;
}

stock GetVehiclePassengerID(vehicleid, seatid) //By Nickk888
{
	new id = -1;
	for(new i; i < MAX_PLAYERS; i++)
	{
		new vid = GetPlayerVehicleID(i);
		if(vid == vehicleid && GetPlayerVehicleSeat(i) == seatid) return i;
	}
	return id;
}

stock GetWeaponSlot(wid)
{
	if(wid==1) return 0;
	if(wid==2||wid==3||wid==4||wid==5||wid==6||wid==7||wid==8||wid==9) return 1;
	if(wid==10||wid==11||wid==12||wid==13||wid==14||wid==15) return 10;
	if(wid==16||wid==17||wid==18||wid==39) return 8;
	if(wid==22||wid==23||wid==24) return 2;
	if(wid==25||wid==26||wid==27) return 3;
	if(wid==28||wid==29||wid==32) return 4;
	if(wid==30||wid==31) return 5;
	if(wid==33||wid==34) return 6;
	if(wid==35||wid==36||wid==37||wid==38) return 7;
	if(wid==40) return 12;
	if(wid==41||wid==42||wid==43) return 9;
	if(wid==44||wid==45||wid==46) return 11;
	return -1;
}

stock ExRandom(min, max) //By y_less  
{     
    new rand = random(max-min)+min;    
    return rand;
}

stock ExBan(playerid) //By Nickk888
{
	BannerTimer[playerid] = SetTimerEx("Banner", 100, false, "i", playerid);
	return 1;
}

stock ExKick(playerid) //By Nickk888
{
	KickerTimer[playerid] = SetTimerEx("Kicker", 100, false, "i", playerid);
	return 1;
}

stock ChangeHostName(name[]) //By Nickk888
{
	new string[200];
	format(string, sizeof(string), "hostname %s",name);
	SendRconCommand(string)
	return 1;
}

stock SetVehicleSpeed(vehicleid, Float:speed) //By AustinJ | Optimized for GetVehicleSpeed by Nickk888
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:a;
    GetVehicleVelocity(vehicleid, x1, y1, z1);
    GetVehiclePos(vehicleid, x2, y2, z2);
    GetVehicleZAngle(vehicleid, a); a = 360 - a;
    x1 = (floatsin(a, degrees) * ((speed)/200) + floatcos(a, degrees) * 0 + x2) - x2;
    y1 = (floatcos(a, degrees) * ((speed)/200) + floatsin(a, degrees) * 0 + y2) - y2;
    SetVehicleVelocity(vehicleid, x1, y1, z1);
}

stock GetOnFootSpeed(playerid) //By Nickk888
{
	new Float:predx;
	new Float:predy;
	new Float:predz;
	new Float:pred_a;
	new pred_b;
	GetPlayerVelocity(playerid, predx, predy, predz);
	pred_a = floatsqroot(((predx*predx)+(predy*predy))+(predz*predz)) * 80;
	pred_b = floatround(pred_a);
	return pred_b;
}

stock IsDateUpToDate(date1a, date1b, date1c) //By Nickk888
{
	new date2a, date2b, date2c;
	getdate(date2c, date2b, date2a);
	if(date2b >= date1b || date2c > date1c)
	{
		if(date2a >= date1a) return true;
		else if(date2b != date1b || date2c != date1c) return true;
	}
	return false;
}

stock CreateVehiclesFromPoint(Float:X, Float:Y, Float:Z, Float:ZRot, amount, Float:range, modelid, color1, color2, respawndelay) //By Nickk888
{
	new Float:TempX, Float:TempY;
	TempX = X, TempY = Y;
	for(new i; i < amount; i++)
	{
		CreateVehicle(modelid, TempX, TempY, Z, ZRot, color1, color2, respawndelay);
		TempX += (range * floatsin(-ZRot, degrees));
		TempY += (range * floatcos(-ZRot, degrees));
	}
	return 1;
}

stock GetWeekDayNum(d,m,y) //by d.wine edit by Nickk888
{
	m-=2;
	if(m<=0){
		y--;
		m+=12;}
	new cen = y / 100;
	new diva = y / 100;
	new lefta = y - 100*diva;
	y = lefta;
	new w = d + ((13 * m - 1) / 5) + y + (y / 4) + (cen / 4) - 2 * cen;
	new div = w / 7;
	new left = w - 7 * div;
	w = left;
	if (w == 0) w = 7;
	return w - 1;
}

stock MovePlayerCamera(playerid, Float:FromX, Float:FromY, Float:FromZ, Float:ToX, Float:ToY, Float:ToZ, Float:FromXR, Float:FromYR, Float:FromZR, Float:ToXR, Float:ToYR, Float:ToZR, time) //By Nickk888
{
	InterpolateCameraPos(playerid, FromX, FromY, FromZ, ToX, ToY, ToZ, time, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, FromXR, FromYR, FromZR, ToXR, ToYR, ToZR, time, CAMERA_MOVE);
	return 1;
}

stock SetPlayerMoneyEx(playerid, money) //By Nickk888
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, money);
	return 1;
}

forward ASK(playerid);
public ASK(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(ASKTime[playerid] > 0)
		{
			ASKTime[playerid]--;
		}
		else
		{
			ASKTime[playerid] = 0;
			KillTimer(ASKTimer[playerid]);
			SetPlayerHealth(playerid, 100);
		}
	}
	else
	{
		KillTimer(ASKTimer[playerid]);
	}
	return 1;
}

forward Banner(playerid);
public Banner(playerid)
{
	return Ban(playerid);
}

forward Kicker(playerid);
public Kicker(playerid)
{
	return Kick(playerid);
}

forward GMX();
public GMX()
{
	if(GMXTime > 0)
	{
		new string[100];
		format(string, sizeof(string), "~r~GMX~n~~w~%i",GMXTime);
		GameTextForAll(string, 1500, 6);
		GMXTime--;
	}
	else
	{
		SendRconCommand("GMX");
	}
	return 1;
}
