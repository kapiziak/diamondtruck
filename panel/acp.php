<? error_reporting(0); session_start();
include ('config.php');

if($_SESSION['loggined'] != 1 || $_SESSION['leveladmin'] == 0)
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
<? if($_GET['send'] != 'server' && $_SESSION['autorefresh'] == 1)
{
?>
<meta http-equiv="refresh" content="3">
<?
}
?>

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
	<h1>Administracja</h1>
	<div class="box"><center><a href="admin.php">Bany</a>||<a href="carprice.php">Cennik pojazdow</a>||<a href="carcolor.php">ID kolorow pojazdow</a>||<a href="carsid.php">ID pojazdow</a></center></div>
	
	<br/>
	<?

	if($_SESSION['leveladmin'] >= 6)
	{
		$query = "SELECT * FROM `logs` ORDER BY `id` DESC LIMIT 50";
		$res = mysql_query($query) or die(mysql_error());

		echo '<h1>Logi</h1><br/>';
		$num = mysql_num_rows($res);
		echo '<h3>Nowe</h3>';
		$i=0;
		while($i < $num)
		{
			$nick = mysql_result($res,$i,"nick");
			$value = mysql_result($res,$i,"value");
			$date = mysql_result($res,$i,"date");


			echo ' >> '.$date.' >> '.$nick.' >> '.$value.'<br/>';

			$i++;
		}

		echo '<h3>Stare</h3>';
	}

	?>
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>


</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a>||Edycja: <font color="lime">Sulfur </font></b>
</div>
<br/><br/>
</body>


</html>