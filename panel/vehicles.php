<? error_reporting(0); session_start();
include ('config.php');

if($_SESSION['loggined'] != 1)
{
header("Location: login.php?action=dontaccess");
}


?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pl" lang="pl">
<head>
<title>pwTRUCK</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<meta name="keywords"
	content="panel gracza, serwer, samp, truck, multiplayer, gta, rpg, download, games" />
<meta name="description" content="DG " />
<meta name="Author" content="KapiziaK" />
<meta name="distribution" content="global" />
<meta name="robots" content="index,follow,all" />
<meta name="revisit-after" content="2 days" />
<meta name="copyright" content="&copy; DG" />
<meta name="classification" content="" />
<meta name="publisher" content="dg" />
<meta name="rating" content="general" />

<link rel="stylesheet" href="css.css" type="text/css" />

</head>
<body>
<div class="nav">
<?php include ('navup.php'); ?>
</div>
<div class="logo">
<img src="logo.png"/>
</div>
<br/>
<div class="wrap">
	<div class="left">
	<?php include ('navleft.php'); ?>
	</div>
	<div class="center">
	<h1>Twoje pojazdy</h1><br/>
	
	<?
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `vehicles` WHERE `owner` = '$nick'";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i=0;
	while($i < $num)
	{
	$uid = mysql_result($res,$i,"id");
	$model = mysql_result($res,$i,"model");
	$paliwo = mysql_result($res,$i,"paliwo");
	$przebieg = mysql_result($res,$i,"przebieg");
	
	$type = $model;
	
	if($type == 411)
	{
	$type = 'Infernus';
	}
	else if($tyoe == 500)
	{
	$type = 'Woz Afrykanski';
	}
	else if($type == 400)
	{
	$type = 'Landstalker';
	}
	else if($type == 401)
	{
	$type = 'Bravura';
	}
	else if($type == 402)
	{
	$type = 'Bufallo';
	}
	else if($type == 403)
	{
	$type = 'Linderunner';
	}
	else if($type == 404)
	{
	$type = 'Perenniel';
	}
	else if($type == 405)
	{
	$type = 'Sentinel';
	}
	else if($type == 406)
	{
	$type = 'Dumper';
	}
	else if($type == 407)
	{
	$type = 'Fire Truck';
	}
	else if($type == 408)
	{
	$type = 'Smieciara MAN 589P';
	}
	else if($type == 409)
	{
	$type = 'Limuzyna Mercedes';
	}
	else if($type == 410)
	{
	$type = 'Manana';
	}
	else if($type == 412)
	{
	$type = 'Voodoo';
	}
	else if($type == 413)
	{
	$type = 'Pony';
	}
	else if($type == 414)
	{
	$type = 'Mule';
	}
	else if($type == 415)
	{
	$type = 'Cheetah';
	}
	else if($type == 416)
	{
	$type = 'Ambulans';
	}
	else if($type == 417)
	{
	$type = 'Lewiatan ( Leviathan )';
	}
	else if($type == 418)
	{
	$type = 'Moonbeam';
	}
	else if($type == 419)
	{
	$type = 'Esperanto';
	}
	else if($type == 420)
	{
	$type = 'Taxi z Taxi 4';
	}
	else if($type == 421)
	{
	$type = 'Washington';
	}
	else if($type == 422)
	{
	$type = 'BobCat';
	}
	else if($type == 423)
	{
	$type = 'Woz Pana Lodzika';
	}
	else if($type == 424)
	{
	$type = 'BF Injection';
	}
	else if($type == 425)
	{
	$type = 'Hunter';
	}
	else if($type == 426)
	{
	$type = 'Premier Woz Premiera';
	}
	else if($type == 427)
	{
	$type = 'Enforcer';
	}
	else if($type == 428)
	{
	$type = 'Securicar';
	}
	else if($type == 429)
	{
	$type = 'Banshee';
	}
	else if($type == 430)
	{
	$type = 'Predator Police';
	}
	else if($type == 431)
	{
	$type = 'Bus';
	}
	else if($type == 432)
	{
	$type = 'Czolg Rhino';
	}
	else if($type == 433)
	{
	$type = 'Barracks';
	}
	else if($type == 434)
	{
	$type = 'Hotknife';
	}
	else if($type == 435)
	{
	$type = 'Article Trailer';
	}
	else if($type == 436)
	{
	$type = 'Previon';
	}
	else if($type == 437)
	{
	$type = 'Coach';
	}
	else if($type == 438)
	{
	$type = 'Cabbie';
	}
	else if($type == 439)
	{
	$type = 'Stallion';
	}
	else if($type == 440)
	{
	$type = 'Rumpo';
	}
	else if($type == 441)
	{
	$type = 'RC Bandit Zabawka MasterGreey';
	}
	else if($type == 442)
	{
	$type = 'Romero';
	}
	else if($type == 443)
	{
	$type = 'Packer';
	}
	else if($type == 444)
	{
	$type = 'Monster';
	}
	else if($type == 445)
	{
	$type = 'Admiral Fiat 125p';
	}
	else if($type == 446)
	{
	$type = 'Squallo';
	}
	else if($type == 447)
	{
	$type = 'Seasparrow';
	}
	else if($type == 448)
	{
	$type = 'Pizzaboy';
	}
	else if($type == 449)
	{
	$type = 'Tram';
	}
	else if($type == 450)
	{
	$type = 'Article Trailer 2';
	}
	else if($type == 451)
	{
	$type = 'Turismo';
	}
	else if($type == 452)
	{
	$type = 'Speeeeeeeeeeeder';
	}
	else if($type == 453)
	{
	$type = 'Reefer';
	}
	else if($type == 454)
	{
	$type = 'Tropic';
	}
	else if($type == 455)
	{
	$type = 'Flatbed';
	}
	else if($type == 456)
	{
	$type = 'Yankee';
	}
	else if($type == 457)
	{
	$type = 'Caddy';
	}
	else if($type == 458)
	{
	$type = 'Solair';
	}
	else if($type == 459)
	{
	$type = 'Topfun Van';
	}
	else if($type == 460)
	{
	$type = 'Skimmer';
	}
	else if($type == 461)
	{
	$type = 'PCJ-600';
	}
	else if($type == 462)
	{
	$type = 'Faggio';
	}
	else if($type == 463)
	{
	$type = 'Freeway';
	}
	else if($type == 464)
	{
	$type = 'RC Baron Zabawka KapiziaK';
	}
	else if($type == 465)
	{
	$type = 'RC Raider';
	}
	else if($type == 465)
	{
	$type = 'Glendale';
	}
	else if($type == 466)
	{
	$type = 'Ocenanic';
	}
	else if($type == 467)
	{
	$type = 'Sanchez';
	}
	else if($type == 468)
	{
	$type = 'Sparrow';
	}
	else if($type == 469)
	{
	$type = 'Patriot';
	}
	else if($type == 470)
	{
	$type = 'Quad';
	}
	else if($type == 471)
	{
	$type = 'Coastguard';
	}
	else if($type == 472)
	{
	$type = 'Dinghy';
	}
	else if($type == 472)
	{
	$type = 'Hermes';
	}
	else if($type == 473)
	{
	$type = 'Sabre';
	}
	else if($type == 474)
	{
	$type = 'Rustler';
	}
	else if($type == 476)
	{
	$type = 'ZR-350';
	}
	else if($type == 478)
	{
	$type = 'Walton';
	}
	else if($type == 479)
	{
	$type = 'Regina';
	}
	else if($type == 476)
	{
	$type = 'Combet';
	}
		else if($type == 477)
	{
	$type = 'BMX';
	}
		else if($type == 478)
	{
	$type = 'Burrito';
	}
		else if($type == 479)
	{
	$type = 'Camper';
	}
		else if($type == 480)
	{
	$type = 'Marquis';
	}	else if($type == 481)
	{
	$type = 'Baggage';
	}
		else if($type == 482)
	{
	$type = 'Dozer';
	}
		else if($type == 483)
	{
	$type = 'Maverick';
	}
		else if($type == 484)
	{
	$type = 'SanNewsHeli';
	}
		else if($type == 485)
	{
	$type = 'Rancher';
	}
		else if($type == 490)
	{
	$type = 'FBI Rancher';
	}
		else if($type == 491)
	{
	$type = 'Virgo';
	}
		else if($type == 493)
	{
	$type = 'Greenwood';
	}
		else if($type == 494)
	{
	$type = 'Jetmax';
	}
		else if($type == 495)
	{
	$type = 'HotringRacer';
	}
		else if($type == 496)
	{
	$type = 'Sandking';
	}
		else if($type == 497)
	{
	$type = 'Blista Compact';
	}
		else if($type == 498)
	{
	$type = 'PoliceMaverick';
	}
		else if($type == 499)
	{
	$type = 'Benson';
	}
		else if($type == 500)
	{
	$type = 'Mesa';
	}
		else if($type == 501)
	{
	$type = 'RC Goblin';
	}
		else if($type == 502)
	{
	$type = 'HotringRacer';
	}
		else if($type == 503)
	{
	$type = 'HotringRacer';
	}
		else if($type == 504)
	{
	$type = 'BloodringBanger';
	}
		else if($type == 505)
	{
	$type = 'Rancher';
	}
		else if($type == 506)
	{
	$type = 'SuperGT';
	}
		else if($type == 507)
	{
	$type = 'Elegant';
	}
		else if($type == 508)
	{
	$type = 'Journey';
	}
		else if($type == 509)
	{
	$type = 'Bike';
	}
		else if($type == 510)
	{
	$type = 'MountainBike';
	}
		else if($type == 511)
	{
	$type = 'Beagle';
	}
		else if($type == 512)
	{
	$type = 'Cropduster';
	}
	else if($type == 513)
	{
	$type = 'StuntPlane';
	}
	else if($type == 514)
	{
	$type = 'Tanker';
	}
	else if($type == 515)
	{
	$type = 'RoadTrain';
	}
	else if($type == 516)
	{
	$type = 'Nebula';
	}
	else if($type == 517)
	{
	$type = 'Majestic';
	}
	else if($type == 518)
	{
	$type = 'Buccaneer';
	}
	else if($type == 519)
	{
	$type = 'Shamal';
	}
	else if($type == 520)
	{
	$type = 'Hyda F16';
	}
	else if($type == 521)
	{
	$type = 'FCT-900';
	}
	else if($type == 522)
	{
	$type = 'NRG-500';
	}
	
	else if($type == 523)
	{
	$type = 'HPV1000';
	}
	else if($type == 524)
	{
	$type = 'Cement Truck';
	}
	else if($type == 525)
	{
	$type = 'TowTruck';
	}
	else if($type == 526)
	{
	$type = 'Fortune';
	}
	else if($type == 527)
	{
	$type = 'Cadrona';
	}
	else if($type == 528)
	{
	$type = 'FBI Truck';
	}
	
		else if($type == 529)
	{
	$type = 'Willard';
	}
	else if($type == 530)
	{
	$type = 'Forkift';
	}
	else if($type == 531)
	{
	$type = 'Tractor';
	}
	else if($type == 532)
	{
	$type = 'Kombajn';
	}
	else if($type == 534)
	{
	$type = 'Feltzer';
	}
	else if($type == 535)
	{
	$type = 'Remington';
	}
	else if($type == 536)
	{
	$type = 'Slamvan';
	}
	else if($type == 537)
	{
	$type = 'Blade';
	}
	else if($type == 538)
	{
	$type = 'Pociong-Freight';
	}
	else if($type == 539)
	{
	$type = 'Pociong-Brown';
	}
	else if($type == 540)
	{
	$type = 'Vincent';
	}
	else if($type == 541)
	{
	$type = 'Bullet';
	}
	else if($type == 542)
	{
	$type = 'Clover';
	}
	else if($type == 543)
	{
	$type = 'Sadler';
	}

	else if($type == 544)
	{
	$type = 'Firetruck LA';
	}
	else if($type == 545)
	{
	$type = 'Hustler';
	}
	else if($type == 546)
	{
	$type = 'Intruder';
	}
	else if($type == 547)
	{
	$type = 'Primo';
	}

	else if($type == 548)
	{
	$type = 'Cargobob';
	}
	else if($type == 549)
	{
	$type = 'Trampa';
	}
	else if($type == 550)
	{
	$type = 'Sunrise';
	}
	else if($type == 551)
	{
	$type = 'Merit';
	}

	else if($type == 552)
	{
	$type = 'Utillity Van';
	}
	else if($type == 553)
	{
	$type = 'Nevada';
	}
	else if($type == 554)
	{
	$type = 'Yosemite';
	}
	else if($type == 555)
	{
	$type = 'Windsor';
	}

	else if($type == 556)
	{
	$type = 'Monster "A"';
	}
	else if($type == 557)
	{
	$type = 'Monster "B"';
	}
	else if($type == 558)
	{
	$type = 'Uranus';
	}
	else if($type == 559)
	{
	$type = 'Jester';
	}

	else if($type == 560)
	{
	$type = 'NewsVan';
	}
	else if($type == 561)
	{
	$type = 'Stratum';
	}
	else if($type == 562)
	{
	$type = 'Elegy';
	}
	else if($type == 563)
	{
	$type = 'Raindance';
	}

	else if($type == 564)
	{
	$type = 'RC Tiger';
	}
	else if($type == 565)
	{
	$type = 'Flash';
	}
	else if($type == 566)
	{
	$type = 'Tahoma';
	}
	else if($type == 567)
	{
	$type = 'Savanna';
	}

	else if($type == 568)
	{
	$type = 'Bandito';
	}
	else if($type == 569)
	{
	$type = 'Ciuchcia';
	}
	else if($type == 570)
	{
	$type = 'Ciuchcia';
	}
	else if($type == 571)
	{
	$type = 'Kart';
	}

	else if($type == 572)
	{
	$type = 'Kosiarka';
	}
	else if($type == 573)
	{
	$type = 'Dune';
	}
	else if($type == 574)
	{
	$type = 'Sweeper';
	}
	else if($type == 575)
	{
	$type = 'Tornado';
	}

	else if($type == 576)
	{
	$type = 'AT400';
	}
	else if($type == 577)
	{
	$type = 'DFT-30';
	}
	else if($type == 578)
	{
	$type = 'Huntley';
	}
	else if($type == 579)
	{
	$type = 'Stafford';
	}
	else if($type == 580)
	{
	$type = 'BF-400';
	}
	else if($type == 581)
	{
	$type = 'NewsVan';
	}
	else if($type == 582)
	{
	$type = 'Cysterna';
	}
	else if($type == 583)
	{
	$type = 'Emperor';
	}
	else if($type == 584)
	{
	$type = 'Wayfarer';
	}
	else if($type == 585)
	{
	$type = 'Euros';
	}
	else if($type == 586)
	{
	$type = 'Hotdog';
	}
	else if($type == 587)
	{
	$type = 'Club';
	}
	else if($type == 588)
	{
	$type = 'Freight Box Trailer Train';
	}
	else if($type == 589)
	{
	$type = 'Naczepa 3';
	}
	else if($type == 590)
	{
	$type = 'Andromada';
	}
	else if($type == 591)
	{
	$type = 'Dodo';
	}
	else if($type == 592)
	{
	$type = 'RC Cam';
	}
	else if($type == 593)
	{
	$type = 'Launch';
	}
	else if($type == 596)
	{
	$type = 'Police Car LSPD';
	}
	else if($type == 597)
	{
	$type = 'Police Car SFPD';
	}
	else if($type == 598)
	{
	$type = 'Police Car LVPD';
	}
	else if($type == 599)
	{
	$type = 'Police Ranger';
	}
	else if($type == 600)
	{
	$type = 'Picador';
	}
	else if($type == 601)
	{
	$type = 'S.W.A.T';
	}
	else if($type == 602)
	{
	$type = 'Alpha';
	}
	else if($type == 603)
	{
	$type = 'Phoneix';
	}
	
	else if($type == 604)
	{
	$type = 'Glendale Shit';
	}
	else if($type == 605)
	{
	$type = 'Sadler Shit';
	}
	else if($type == 606)
	{
	$type = 'Baggage Trailer "A"';
	}
	else if($type == 607)
	{
	$type = 'Baggage Trailer B';
	}
	else if($type == 608)
	{
	$type = 'Tug Stairs Trailer';
	}
	else if($type == 609)
	{
	$type = 'Boxville';
	}
	else if($type == 510)
	{
	$type = 'Farm Trailer';
	}
	else if($type == 511)
	{
	$type = 'Utilly Trailer';
	}

	
	// TYPY ZROBIŁ KAPIZIAK! BY TYLKO ON!!!
	
	


	
	
	
	
	
	?>
	<div class="box">
	
	<li><b>Unikalny Indefikator Danych:</b> <? echo $uid; ?><br/>
	<li><b>Nazwa:</b> <? echo $type.'('.$model.')'; ?><br/>
	<li><b>Paliwo:</b> <? echo $paliwo; ?>l.<br/>
	<li><b>Przebieg:</b> <? echo $przebieg; ?> km.<br/>
	
	</div>
	<br/>
	
	<?
	
	$i++;
	}
	
	?>
	
	
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>


</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>