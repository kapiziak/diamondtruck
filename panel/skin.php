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
<title>Diamond Gaming</title>
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
<div class="logo">
<img src="logo.png"/>
</div>
<br/>
<div class="nav">
<?php include ('navup.php'); ?>
</div>
<div class="wrap">
	<div class="left">
	<?php include ('navleft.php'); ?>
	</div>
	<div class="center">
	<h1>Ustaw Skina</h1><br/>
	<br/><br/>Wybierz skina!<br/>

	<?
	
	if($_GET['chose'] == '')
	{
	$login = $_SESSION['login'];
	$query = "SELECT * FROM `users` WHERE `nick` = '$login'";
	$res = mysql_query($query);
	
	$vip = mysql_result($res,0,"vip");
	
	if($vip == 1)
	{
	
	$i=0;
	while($i < 298)
	{
	if($i != 74)
	{
	echo '<a href="?chose='.$i.'"><div class="hint--top" data-hint="Skin numer '.$i.'"><img src="http://gtav.pl/uploads/gtam/GTASA_skins/'.$i.'.png"/></div></a>';
	}
	$i++;
	}
	
	}
	else
	{
	$i=0;
	while($i < 298)
	{
	if($i < 100 && $i != 74)
	{
	echo '<a href="?chose='.$i.'"><div class="hint--top" data-hint="Skin numer '.$i.'"><img src="http://gtav.pl/uploads/gtam/GTASA_skins/'.$i.'.png"/></div></a>';
	}
	else if($i != 74 && $i >= 100)
	{

	echo '<a href="premium.php"><div class="hint--top" data-hint="Aby odblokowac zakup VIPa!"><img style="opacity:0.1;" src="http://gtav.pl/uploads/gtam/GTASA_skins/'.$i.'.png"/></div></a>';

	}
	$i++;
	}
	
	}
	}
	else if($_GET['chose'] != '')
	{
	$skin = $_GET['chose'];
	$login = $_SESSION['login'];
	$query = "UPDATE `users` SET `skin` = '$skin' WHERE `nick` = '$login'";
	mysql_query($query) or die(mysql_error());
	echo '<div class="ok_box">Skin zostal poprawnie zmieniony!</div>';
	}
	?>
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>


</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>