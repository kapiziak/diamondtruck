<? session_start();
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
	<h1>Top 20</h1>
	<br/>
<div class="circle"><a href="top.php">← Wróc</a></div>
	
	<h5>Towary LegaLne!</h5>
<!-- LEGALNE !-->
	<br/><br/>
			<div class="box">
	<div class="table_reczna">
	<!-- <div class="row_wi"><strong>Nick</strong></div> <div class="row_wi"><strong>Kasa</strong></div> !-->
	<!--<div class="table_space">!-->
	<strong>Nick</strong><label><strong>Towary Legalne</strong></label>
	<!--</div>!-->
	
	</div>
	
	<div class="top">
	
	<?
	$query = "SELECT * FROM `users` ORDER BY `legal` DESC LIMIT 20";
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
	
	
	
	
	
	
	
	
	</div>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

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