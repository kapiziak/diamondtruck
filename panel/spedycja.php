<? session_start();
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
<script language="JavaScript">
</script>
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
	<h1>Spedycja</h1>
	<div class="box"><a href="cargos.php">Towary</a> | <a href="zaladunki.php">Zaladunki</a></div>
	
	<h3><font size="5">Wirtualna spedycja..</font></h3>
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
	<!-- TESTY 
	<a href="#gowno">HeHE</a>
	<div id="gowno">
	Tajemnicze Gowno
	</div>!-->
	
	</div>

<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/>
			</div>

					<hr class="hidden" />
				

				<br />




		</div>
		

<div id="footer" class="hidden-phone">
<div id="footer-pattern">

<div class="main-width" style="padding-left: 25px;">

	<div class="footer-links footer-links-first">

                <h1>Polecamy</h1>

		<ul>
			<li><a href="http://forum.party-sound.pl">Forum party-sound</a></li>			
			<li><a href="http://zarabiara.pl">Zarabiara</a></li>
			<li><a href="http://pwtruck.pl">pwTRUCK</a></li>
			<li><a href="http://forum.e-player.xaa.pl">Forum ePlayer</a></li>
		</ul>

	</div>

	<div class="footer-links">

                <h1><center>pwTRUCK</center></h1>

		<ul>
		    Aktualizacja 1.6!			
			
		</ul>

	</div>


	<div class="footer-links">

                <h1><center>Autorzy:</center></h1>

		<ul>
			<li><a href="GG:39831273">KapiziaK</a></li>			
			<li><a href="GG:40666789">DanieL</a></li>
			<li><a href="GG:46414347">Cruzzer</a></li>	
			<li><a href="GG:44644148">AiR Design</a></li>		
		</ul>

	</div>


	<div class="footer-links">

                <h1>Reklamy </h1>

		<ul>
			<li><a href="GG:46414347">Twoja reklama!</a></li>			
			<li><a href="GG:46414347">Twoja reklama!</a></li>
			<li><a href="GG:46414347">Twoja reklama!</a></li>
			<li><a href="GG:46414347">Twoja reklama!</a></li>
		</ul>

	</div>

</div>

</div>
</div>


	<div id="bottom-bar">

	<div class="main-width">

		

			<div class="logo">
				<a href="http://pwtruck.pl">
					<center><img src="images/gamurs/logo.png" alt="Wszelkie prawa zastrzezone!" title="Wszelkie prawa zastrzezone!" />
				</a>                               
			</div>
		
	</div> 

	</div>



<script src="images/gamurs/indexjs.js"></script>
<script src="images/gamurs/customjs.js"></script>
</div>
<br/><br/>
</body>


</html>