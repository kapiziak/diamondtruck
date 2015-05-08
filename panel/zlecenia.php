<? error_reporting(0); session_start();
include ('config.php');
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
	<h1>Spedycja</h1>
	
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
	<li><br/><br/>
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