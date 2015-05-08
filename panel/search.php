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

	<h1>Wyszukiwanie Gracza</h1><br/><br/>
	
	<div class="textinfo">Wpisz nazwe gracza, ktorego chcesz wyszukac!</div><br/>
	<form action="?serach=nick">
	<input class="textarena" type="text" name="nicks" placeholder="Nick gracza" maxlength="50"></input><br/><br/><input class="button" type="submit" value="Szukaj"/>
	</form>
	
	<? 
	if($_GET['nicks'] != '' && $_GET['postac'] == '')
	{
	$nick = $_GET['nicks'];
	$query = "SELECT * FROM `users` WHERE `nick` LIKE '$nick%'";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	echo '';
	echo '<br/><div class="table-green"><b>Liczba wyszukanych uzytkownikow o podobiznie '.$nick.': </b> '.$num.'<br/></div>';
	
	echo '<br/><br/><div class="box">';
	echo '<div class="table_reczna"><div class="table_space">UID</div><div class="table_space">Nick</div><div class="table_space">Skin</div><br/></div>';
	
	$i = 0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$nick = mysql_result($res,$i,"nick");
	$skin = mysql_result($res,$i,"skin");
	echo '<li><div class="table_space">'.$id.'</div><div class="table_space"><a href="?postac='.$id.'">'.$nick.'</a></div><div class="table_space"><img src="http://gtav.pl/uploads/gtam/GTASA_skins/'.$skin.'.png" width="14" /></div><br/>';
	$i++;
	}
	
	
	
	
	echo '</div>';
	
	}
	
	if($_GET['postac'] != '' && $_GET['nicks'] == '')
	{
	echo '<br/><br/>';
	$uids = $_GET['postac'];
	

	
	$query = "SELECT * FROM `users` WHERE `id` = '$uids'";
	$res = mysql_query($query) or die(mysql_error());
	
	$nick = mysql_result($res,0,"nick");
	$skin = mysql_result($res,0,"skin");
	$money = mysql_result($res,0,"money");
	$admin = mysql_result($res,0,"leveladmin");
	$vip = mysql_result($res,0,"vip");
	$score = mysql_result($res,0,"score");
	$legal = mysql_result($res,0,"legal");
	$nolegal = mysql_result($res,0,"nolegal");
	$osiag1 = mysql_result($res,0,"osiag1");
	$osiag2 = mysql_result($res,0,"osiag2");
	$osiag3 = mysql_result($res,0,"osiag3");
	$osiag4 = mysql_result($res,0,"osiag4");
	$online = mysql_result($res,0,"online");
	$team = mysql_result($res,0,"team");
	

	
	
	
	//echo time_elapsed_string('2013-05-01 00:22:35');
	
	
	
	$query = "SELECT * FROM `loginlogs` WHERE `nick` = '$nick' ORDER BY `id` DESC LIMIT 1";
	$resulcik = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($resulcik);
	
	if($num >= 1)
	{
	$lastlogin = mysql_result($resulcik,0,"date");
	}
	//echo '<i class="txt-red fa fa-star fa-3x"></i>';
	echo '<img src="http://gtav.pl/uploads/gtam/GTASA_skins/'.$skin.'.png"/><br/><h3>'.$nick.'</h3>';
	?>


	<?
	echo '<div class="panel-left">';
	echo '<div class="box">';
	if($online == 1)
	{
	$online = '<i class="fa fa-cloud txt-blue fa-lg"></i> OnLINE';
	}
	else
	{
	$online = '<i class="fa fa-cloud txt-red fa-lg"></i> OffLINE';
	}
	echo '<li><b>Status:</b> '.$online;
	
	if($online == 1)
	{
	$lastlogin = "Teraz ON-Line";
	}

	//echo $team;
	echo '<li><b>Ostatnie Logowanie:</b> '.$lastlogin.' <i class="fa fa-clock-o"></i>';
	echo '<li><b>Zatrudniony w:</b> '.CheckTeamName($team);
	echo '<li><b>Pieniadze:</b> $'.$money;
	echo '<li><b>Doświadczenie:</b> '.$score.' pkt.';
	



	if($vip == 1)
	{
	echo '<li><b>Konto Premium:</b> <i class="txt-yellow fa fa-star fa-lg fa-spin"></i>';
	}
	else
	{
	echo '<li><b>Konto Premium:</b> <i class="txt-grey fa fa-star fa-lg"></i>';
	}
	
	if($admin >= 1)
	{
	echo '<li><b>Administrator:</b> ';
	$i = 0;
	while($i < $admin)
	{
	echo ' <i class="txt-red fa fa-star fa-spin fa-lg"></i> ';
	$i++;
	}
	}
	
	echo '<li><b>Towary Legalne:</b> '.$legal;
	echo '<li><b>Towary Nielegalne:</b> '.$nolegal;
	
	echo '</div>';
	echo '</div>';
	
	echo '<div class="panel-right">';
	echo '<h3>Osiagniecia</h3>';
	echo '<div class="box">';
	
	if($osiag1 == 1)
	{
	$osiag1 = '<i class="txt-green fa fa-check fa-lg"></i>';
	}
	else
	{
	$osiag1 = '<i class="txt-red fa fa-times fa-lg"></i>';
	}
	
	
	if($osiag2 == 1)
	{
	$osiag2 = '<i class="txt-green fa fa-check fa-lg"></i>';
	}
	else
	{
	$osiag2 = '<i class="txt-red fa fa-times fa-lg"></i>';
	}
	
	
	if($osiag3 == 1)
	{
	$osiag3 = '<i class="txt-green fa fa-check fa-lg"></i>';
	}
	else
	{
	$osiag3 = '<i class="txt-red fa fa-times fa-lg"></i>';
	}
	
	
	if($osiag4 == 1)
	{
	$osiag4 = '<i class="txt-green fa fa-check fa-lg"></i>';
	}
	else
	{
	$osiag4 = '<i class="txt-red fa fa-times fa-lg"></i>';
	}
	
	
	echo '<li><b>Pierwszy Towar</b>: '.$osiag1;
	echo '<li><b>Bogacz $100.000+</b>: '.$osiag2;
	echo '<li><b>Pro Gracz</b>: '.$osiag3;
	echo '<li><b>No-Life z towarem</b>: '.$osiag4;
	
	echo '</div></div>';
	}
	
	?>
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
<?
function humanTiming ($time)
{

    $time = time() - $time; // to get the time since that moment

    $tokens = array (
        31536000 => 'year',
        2592000 => 'month',
        604800 => 'week',
        86400 => 'day',
        3600 => 'hour',
        60 => 'minute',
        1 => 'second'
    );

    foreach ($tokens as $unit => $text) {
        if ($time < $unit) continue;
        $numberOfUnits = floor($time / $unit);
        return $numberOfUnits.' '.$text.(($numberOfUnits>1)?'s':'');
    }

}
?>