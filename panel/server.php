<? error_reporting(0); session_start();
include ('config.php');

$ip = "91.234.217.6";
$port = "7786";

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
	<h1>Status Servera</h1><br/>
	
	<div class="panel-right">
	<div class="box">
	<div class="hint--right" data-hint="Status Servera">
	<li>Status:
	<?
	require "samp_query.php";
	$ip = "91.234.217.6";
	$port = "7781";


	try
	{
			$query = new QueryServer("$ip", "$port"); // Zmień dane obok! //
			$aInformation = $query->getInfo();
			$aServerRules = $query->getRules();
			$aServerRules  = $query ->GetRules( );
			$aBasicPlayer  = $query ->GetPlayers( );
			$aTotalPlayers = $query ->GetDetailedPlayers( );
			echo '<font size="5"><i class="online online-circle txt-green"></i></font><br/>';
	}
	catch (QueryServerException $pError)
	{
		   echo '<font size="5"><i class="online online-circle txt-red"></font></i><br/>';
	}
	
	?>
	</div>
	<li><div class="hint--right" data-hint="Nazwa"><? echo $aInformation['Hostname']; ?><br/></div>
	<li><div class="hint--right" data-hint="Gracze Online">[<? echo $aInformation['Players']; ?>/<? echo $aInformation['MaxPlayers']; ?>]</div><br/>
	<li><div class="hint--right" data-hint="GameMode"><? echo $aInformation['Gamemode']; ?><br/></div>
	<li><div class="hint--right" data-hint="Mapa Servera"><? echo $aInformation['Map']; ?></div><br/>
	<li><div class="hint--right" data-hint="IP Servera"><? echo $ip.':'.$port; ?></div><br/>
	</div>
	</div>
	<div class="panel-left">
	<div class="box">
	<li>Nick - ID<label>Score - Ping</label><br/><br/>
	<?
	$aPlayers = $query->getDetailedPlayers();

	foreach($aPlayers as $sValue)
	{


	echo '<li>'; 
	?>
	<?= htmlentities($sValue['Nickname']); ?> - <?= $sValue['PlayerID'] ?>
	<label><?= $sValue['Score'] ?> pkt.
	<?= $sValue['Ping'] ?> pingu</label>
	<br/>
	<?php

	}







	if($aInformation[Players] == 0)
	{
	echo 'Nikt nie gra na serverze!';
	}
	?>
	</div>
	</div>
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>