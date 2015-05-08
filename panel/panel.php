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
	<?
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `users` WHERE `nick` = '$nick'";
	$res = mysql_query($query) or die(mysql_error());
	
	$online = mysql_result($res,0,"online");
	
	?>
	<div class="center">
	<h1>Panel Gracza</h1>
	<div class="panel-left"><font size="6"><div class="hint--right" data-hint="Status"><? echo $_SESSION['login']; if($online == 1) { echo '<i class="online online-circle txt-green">'; } else { echo '<i class="online online-circle txt-greey">'; }	?></i></div></font>
	<div class="box">
	<?

	
	$uid = mysql_result($res,0,"id");
	$money = mysql_result($res,0,"money");
	$score  = mysql_result($res,0,"score");
	$legalnea = mysql_result($res,0,"legal");
	$nielegalnea = mysql_result($res,0,"nolegal");
	$osiag1 = mysql_result($res,0,"osiag1");
	$osiag2 = mysql_result($res,0,"osiag2");
	$osiag3 = mysql_result($res,0,"osiag3");
	$osiag4 = mysql_result($res,0,"osiag4");
	$skin = mysql_result($res,0,"skin");
	$vipto = mysql_result($res,0,"vipto");
	
	$_SESSION['uid'] = $uid;
	
	$admin = mysql_result($res,0,"leveladmin");
	
	$_SESSION['leveladmin'] = $admin;
	
	
	$datea = date('Y-m-d');
	//echo 'Data.'.$datea;

	
	if($datea > $vipto)
	{
	$query = "UPDATE `users` SET `vip` = '0' WHERE `id` = '$uid'";
	mysql_query($query) or die(mysql_error());
	$vip = 0;
	}
	$vip = mysql_result($res,0,"vip");
	if($vip == 1)
	{
	$vipstatus = "Posiadasz";
	}
	else
	{
	$vipstatus = "Nie aktywne";
	}
	
	
	?>
	
	<li><b>UID:</b> <? echo $uid; ?><br/>
	<li><b>Pieniadze:</b> $<? echo $money; ?><br/>
	<li><b>Punkty:</b> <? echo $score; ?> pkt.<br/>
	<li><b>Konto Premium:</b> <? echo $vipstatus; ?><br/>
        <li><b>Towary Legalne</b> <? echo $legalnea; ?> szt.<br/>
	<li><b>Towary Nielegalne</b> <? echo $nielegalnea; ?> szt.<br/>
	<?
	if($admin >= 1)
	{
	echo '<li><b>Poziom Admina</b> '.$admin.' lvl.<br/>';
	}
	?>
	<li><b>Skin:</b> <br/><div class="skin"><div class="hint--left" data-hint="Zmien Skina" ><a href="skin.php"><img height="80" width="80"
	 src="http://gtav.pl/uploads/gtam/GTASA_skins/<? echo $skin; ?>.png" /></a></div><br/><br/></div><br/>
	
	</div>
	</div><br/><br/><br/>
	<div class="panel-right">
	<div class="box">
	
	<li><b>Osiagniecia:</b><br/><br/>
	
	<? if($osiag1 == 1)
	{
	?>
	<div class="hint--left" data-hint="Rozladuj swoj 1 towar!"><img src="1osiag.png"/></div>
	<?
	}
	else if($osiag1 == 0)
	{
	?>
	<div class="osiag_niezaliczone">
	<div class="hint--left" data-hint="Rozladuj swoj 1 towar!"><img src="1osiag.png"/></div>
	</div>
	<?
	}
	?>
	<? if($osiag2 == 1)
	{
	?>

	<div class="hint--left" data-hint="Zdobadz $100.000!"><img src="2osiag.png"/></div>

	<?
	}
	else if($osiag2 == 0)
	{
	?>
	<div class="osiag_niezaliczone">
	<div class="hint--left" data-hint="Zdobadz $100.000!"><img src="2osiag.png"/></div>
	</div>
	<?
	}
	?>
	<? if($osiag3 == 1)
	{
	?>

	<div class="hint--left" data-hint="Przegraj na serverze 1 godzine!"><img src="3osiag.png"/></div>

	<?
	}
	else if($osiag3 == 0)
	{
	?>
	<div class="osiag_niezaliczone">
	<div class="hint--left" data-hint="Przegraj na serverze 1 godzine!"><img src="3osiag.png"/></div>
	</div>
	<?
	}
	?>
	<? if($osiag4 == 1)
	{
	?>

	<div class="hint--left" data-hint="Rozladuj towar o przebiegu dluzszym niz 100km!"><img src="4osiag.png"/></div>

	<?
	}
	else if($osiag4 == 0)
	{
	?>
	<div class="osiag_niezaliczone">
	<div class="hint--left" data-hint="Rozladuj towar o przebiegu dluzszym niz 100km!"><img src="4osiag.png"/></div>
	</div>
	<?
	}
	?>
	
	
	
	
	
	</div>
	</div>
	<br/>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<div class="panel-left">
	<font size="6">Postepy w punktach score...</font>
	<div class="progress">
	
	<div class="progress-bar progress-bar-score hint--right" style="width: <? $scpx = $score/2/2/2/2/2/2; echo $scpx; ?>%;" data-hint="<? $scpx = $score/2/2/2/2/2/2; echo $scpx; ?>%">
	</div>
	</div>
	<font size="6">Postepy w osiagnieciach...</font>
	<div class="progress">
	
	<?
	$osiag = $osiag1+$osiag2+$osiag3+$osiag4;
	?>
	<div class="progress-bar progress-bar-ok hint--right" style="width: <? $scpx = $osiag*25; echo $scpx; ?>%;" data-hint="<? $scpx = $osiag*25; echo $scpx; ?>%">
	</div>

	
	</div>
	</div><br/><br/><br/>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<br/><br/>
	
	<h3><font size="6">Wirtualna spedycja..</font></h3>
	<div class="box">
	<div class="table_reczna">
	
	<div class="table_space">
	<b>Zlecenie numer</b>
	</div>
	
	<div class="table_space">
	<b>Stan</b>
	</div>
	
	<div class="table_space">
	<b>Nazwa</b>
	</div>
	
	<div class="table_space">
	<b>Dystans</b>
	</div>
	
	<br/>
	</div>
	<?
	$uidplayer = $_SESSION['uid'];
	$query = "SELECT * FROM `orders` WHERE `playeruid` = '$uidplayer' ORDER BY `id` DESC LIMIT 10";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i=0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$stan = mysql_result($res,$i,"status");
	$cargo = mysql_result($res,$i,"cargo");
	$kilometers = mysql_result($res,$i,"kilometers");
	
	
	$cargo = CheckCargoName($cargo);
	
	if($stan == 1)
	{
	$stan = '<i class="fa fa-check txt-green fa-2x" title="Rozladowany"> </i>';
	}
	else
	{
	$stan = '<i class="fa fa-times txt-red fa-2x" title="W drodze!"></i>';
	}
	
	echo '
	<li>
	
	<div class="table_space">'.$id.'</div>
	<div class="table_space">'.$stan.'</div>
	<div class="table_space">'.$cargo.'</div>
	<div class="table_space">'.$kilometers.' km</div>
	
	<br/>
	';
	
	$i++;
	}

	?>
	</div>
	
	
	</div>

<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/>
</div>
<br/><br/>
<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/><br/>
</body>


</html>