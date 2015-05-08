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
	<h1>Top 15</h1>
	<br/>
	<br/>
	<?
	$mr = 0;
	$sr = 0;
	$lgr = 0;
	$nlgr = 0;
	$towaryr = 0;
	$vipr = 0;
	$odwiedzono = 0;
	
	$query = "SELECT * FROM `users`";
	$res = mysql_query($query);
	
	$kontrazem = mysql_num_rows($res);
	
	$i = 0;
	while($i < $kontrazem)
	{
	
	$money = mysql_result($res,$i,"money");
	$mr = $mr+$money;
	
	$score = mysql_result($res,$i,"score");
	$sr = $sr+$score;
	
	$lg = mysql_result($res,$i,"legal");
	$lgr = $lgr+$lg;
	
	$nlg = mysql_result($res,$i,"nolegal");
	$nlgr = $nlgr+$nlg;
	
		
	$vip = mysql_result($res,$i,"vip");
	$vipr = $vipr+$vip;
	
	
	$towaryr = $towaryr + $nlg + $lg;
	
	$i++;
	}
	
	$query = "SELECT * FROM `loginlogs`";
	$res = mysql_query($query);
	
	$odwiedzono = mysql_num_rows($res);
	?>
	<div class="table-green">
	<li><b>Zarejestrowanych kont:</b> <? echo $kontrazem; ?> szt.
	<li><b>Razem pieniedzy:</b> $<? echo $mr; ?>
	<li><b>Razem punktów:</b> <? echo $sr; ?> pkt.
	<li><b>Towary Nielegalne rozladowane:</b> <? echo $nlgr; ?> szt.
	<li><b>Towary Legalne rozladowane:</b> <? echo $lgr; ?> szt.
	<li><b>Wszystkie Towary rozladowane:</b> <? echo $towaryr; ?> szt.
	<li><b>Kont Premium:</b> <? echo $vipr; ?> szt.
	<li><b>Nasz server odwiedzono:</b> <? echo $odwiedzono; ?> razy
	
	</div>
	<br/>
	<!-- SCORE !-->
	<div class="box">
	
	<div class="table_reczna">
	<!-- <div class="row_wi"><strong>Nick</strong></div> <div class="row_wi"><strong>Kasa</strong></div> !-->
	<!--<div class="table_space">!-->
	<strong>Nick</strong><label><strong>Score</strong></label>
	<!--</div>!-->
	<br/>
	</div>
	
	<div class="top">
	
	<?
	$query = "SELECT * FROM `users` ORDER BY `score` DESC LIMIT 15";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i = 0;
	while($i < $num)
	{
	$nick = mysql_result($res,$i,"nick");
	$score = mysql_result($res,$i,"score");
	
	$ia = $i+1;
	echo '<li><i class="top-before"></i> '.$ia.'. '.$nick.'<label>'.$score.' pkt.</label>';
	$i++;
	}
	
	?>
	
	<!--<li><i class="top-before"></i> 1. Test<label>test</label>!-->
	
	</div>
	
	</div>
	
	<!-- MONEY !-->
	<br/><br/>
	<div class="box">
	
	<div class="table_reczna">
	<!-- <div class="row_wi"><strong>Nick</strong></div> <div class="row_wi"><strong>Kasa</strong></div> !-->
	<!--<div class="table_space">!-->
	<strong>Nick</strong><label><strong>Pieniadze</strong></label>
	<!--</div>!-->
	<br/>
	</div>
	
	<div class="top">
	
	<?
	$query = "SELECT * FROM `users` ORDER BY `money` DESC LIMIT 15";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i = 0;
	while($i < $num)
	{
	$nick = mysql_result($res,$i,"nick");
	$money = mysql_result($res,$i,"money");
	
	$ia = $i+1;
	echo '<li><i class="top-before"></i> '.$ia.'. '.$nick.'<label>$'.$money.'</label>';
	$i++;
	}
	
	?>
	
	<!--<li><i class="top-before"></i> 1. Test<label>test</label>!-->
	
	</div>
	
	</div>
	
	<!-- LEGALNE !-->
	<br/><br/>
			<div class="box">
	<div class="table_reczna">
	<!-- <div class="row_wi"><strong>Nick</strong></div> <div class="row_wi"><strong>Kasa</strong></div> !-->
	<!--<div class="table_space">!-->
	<strong>Nick</strong><label><strong>Towary Legalne</strong></label>
	<!--</div>!-->
	<br/>
	</div>
	
	<div class="top">
	
	<?
	$query = "SELECT * FROM `users` ORDER BY `legal` DESC LIMIT 15";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i = 0;
	while($i < $num)
	{
	$nick = mysql_result($res,$i,"nick");
	$legal = mysql_result($res,$i,"legal");
	
	$ia = $i+1;
	echo '<li><i class="top-before"></i> '.$ia.'. '.$nick.'<label>'.$legal.' towarów</label>';
	$i++;
	}
	
	?>
	
	<!--<li><i class="top-before"></i> 1. Test<label>test</label>!-->
	
	</div>
	
	</div>
	
	
	<!-- NieLEGALNE !-->
	<br/><br/>
	<div class="box">
	<div class="table_reczna">
	<!-- <div class="row_wi"><strong>Nick</strong></div> <div class="row_wi"><strong>Kasa</strong></div> !-->
	<!--<div class="table_space">!-->
	<strong>Nick</strong><label><strong>Towary Nielegalne</strong></label>
	<!--</div>!-->
	<br/>
	</div>
	
	<div class="top">
	
	<?
	$query = "SELECT * FROM `users` ORDER BY `nolegal` DESC LIMIT 15";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i = 0;
	while($i < $num)
	{
	$nick = mysql_result($res,$i,"nick");
	$nolegal = mysql_result($res,$i,"nolegal");
	
	$ia = $i+1;
	echo '<li><i class="top-before"></i> '.$ia.'. '.$nick.'<label>'.$nolegal.' towarów</label>';
	$i++;
	}
	
	?>
	
	<!--<li><i class="top-before"></i> 1. Test<label>test</label>!-->
	
	</div>
	
	</div>
	
	
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>