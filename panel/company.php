<? error_reporting(0); session_start();
include ('config.php');

if($_SESSION['loggined'] != 1)
{
header("Location: login.php?action=dontaccess");
}
	$uid = $_SESSION['clickedcomp'];
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$uid'";
	
	$res = mysql_query($query) or die(mysql_error());
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$rangeplayer = mysql_result($res,0,"range");
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
	<h1>Rynek Pracy</h1><br/>
	
	<?
	
	if($_GET['uid'] == '' && $_GET['podanieadd'] == '' && $_GET['checkapli'] == '' && $_GET['config'] == '' && $_GET['wyplata'] == '' && $_GET['earned'] == '')
	{
	
	$query = "SELECT * FROM `company` ORDER BY `budget` DESC";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	$i = 0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$name = mysql_result($res,$i,"name");
	$budget = mysql_result($res,$i,"budget");
	$color = mysql_result($res,$i,"colorinphp");
	
	
	?>
	<div class="boxer"><li><? echo $name; ?><br><i class="company company-icon" style="color: #<? echo $color; ?>"></i><br>
	<br><a href="company.php?uid=<? echo $id; ?>"><div class="button">ZOBACZ</DIV></A>
	</div>
	<?
	$i++;
	}
	}

	if($_GET['earned'] != '') 
	{
	$company = $_GET['earned'];
	$nick = $_SESSION['login'];
	$comp = $company;
	
	//$idapp = $_GET['podanieaccept'];
	
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");

	//echo 'test';

	if($range >= 3)
	{
		$company = $_GET['earned'];
		$query = "SELECT * FROM `earnedinfo` WHERE `company` = '$company' ORDER BY `id` DESC";
		$res = mysql_query($query) or die(mysql_error());

		$num = mysql_num_rows($res);

		$i=0;
		while($i < $num)
		{
			//echo 'test';
			$uidm = mysql_result($res,$i,"uid");
			$textm = mysql_result($res,$i,"text");
			$datam = mysql_result($res,$i,"data");
			$kwotam = mysql_result($res,$i,"count");

			echo '>> Murzyn '.playername($uidm).' >> Zarobil $'.$kwotam.' '.$textm.' >> Data '.$datam.'<br/>';

			$i++;
		}

		if($num == 0)
		{
			echo 'Twoi murzyni nie pracuja! :(';
		}


	}
	}
	}
	
	if($_GET['uid'] != '')
	{
	$id = $_GET['uid'];
	$_SESSION['clickedcomp'] = $id;
	$query = "SELECT * FROM `company` WHERE `id` = '$id'";
	$res = mysql_query($query);
	
	
	$i = 0;

	$id = mysql_result($res,$i,"id");
	$name = mysql_result($res,$i,"name");
	$budget = mysql_result($res,$i,"budget");
	$color = mysql_result($res,$i,"colorinphp");
	
	
	echo '<h2 style="border-top: 3px solid #'.$color.';">'.$name.'<label><div class="bar" style="width: 50%; background: #3cab2f;"><b>Budzet: $'.$budget.'</b></div></label></h2>';
	
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$id'";
	
	$res = mysql_query($query) or die(mysql_error());
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$rangeplayer = mysql_result($res,0,"range");
	}
	$nick = $_SESSION['login'];
	$id = $_GET['uid'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$id'";
	$res = mysql_query($query) or die(mysql_error());
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	
	$rangeplayer = mysql_result($res,0,"range");
	
	
	if($rangeplayer == 4)
	{
	echo '<h4><div class="hint--top" data-hint="Przegladaj Podania"><a href="company.php?checkapli='.$id.'"><img src="apli_check.png"/>Zobacz podania</a></div> <div class="hint--top" data-hint="Ustawienia"><a href="?config='.$id.'">Ustawienia<img src="comp_config.png"/></div>  <div class="hint--top" data-hint="Kontrola nad murzynami"><a href="?earned='.$id.'">Kontrola murzynów<img src="comp_config.png"/></div><br/></h4><br/>';
	}
	if($rangeplayer == 3)
	{
		echo '<h4><div class="hint--top" data-hint="Przegladaj Podania"><a href="company.php?checkapli='.$id.'"><img src="apli_check.png"/>Zobacz podania</a></div><br/></h4><br/>';
	}
	if($rangeplayer >= 0)
	{
	echo '<h4><div class="hint--top" data-hint="Zwolnij się"><a href="?quitc='.$id.'"><img src="quitcompany.png"/>Zwolnij sie</a></div></h4><br/>';
	}
	}
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick'";
	$res = mysql_query($query);
	$num = mysql_num_rows($res);
	if($num == 0)
	{
	echo '<h4><a href="company.php?podanieadd='.$id.'"><img src="company_podanie_add.png" title="Zloz Podanie"/></a> </h4><br/>';
	}
	echo '<h3 style="border-bottom: 3px solid #'.$color.';">Lista Pracownikow</h3>';
	
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$uid'";
	
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$rangeplayer = mysql_result($res,0,"range");
	}
	
	$id = $_GET['uid'];
	
	
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$uid'";
	
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$rangeplayer = mysql_result($res,0,"range");
	$_SESSION['range'] = $rangeplayer;
	}
	
	$query = "SELECT * FROM `employess` WHERE `company` = '$id' ORDER BY `range` DESC";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);

	$i = 0;
	while($i < $num)
	{
	$name = mysql_result($res,$i,"nick");
	$zarobil = mysql_result($res,$i,"earned");
	$range = mysql_result($res,$i,"range");
	$idpracownik = mysql_result($res,$i,"uid");
	
	if($range == 4)
	{
	$range = '<div class="bar" style="background: #db3000; width: 13%">Prezes</div>';
	}
	else if($range == 3)
	{
	$range = '<div class="bar" style="background: #E0B322; width: 13%">VC Prezes</div>';
	}
	else if($range == 2)
	{
	$range = '<div class="bar" style="background: #8F3CE9; width: 13%">Zawodowiec</div>';
	}
	else if($range == 1)
	{
	$range = '<div class="bar" style="background: #4AE93C; width: 13%">Kierowca</div>';
	}
	else if($range == 0)
	{
	$range = '<div class="bar" style="background: #8d8d8d; width: 13%">Stazysta</div>';
	}
	
	$rangepracownika = mysql_result($res,$i,"range");
	$idfa = $_GET['uid'];
	$nickfa = $_SESSION['login'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nickfa' AND `company` = '$idfa'";
	
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$rangeplayera = mysql_result($res,0,"range");
	}


	
	?>
	
	<div class="box" style="font-size: 15px;">
	<li> <a href="search.php?postac=<? echo $idpracownik; ?>">
	<i class="fa fa-chevron-right fa-4" style="color: #<? echo $color; ?>"></i> <? echo $range; echo $name.'</a>'; 
	if($rangeplayera >= 4 && $name != $_SESSION['login'])
	{ 
	echo ' <a href="company.php?awans='.$name.'"><img src="plus.png" title="Awansuj"></img></a> <a href="company.php?degraguj='.$name.'"><img src="minus.png" title="Degraguj"></img></a>'; 
	}
	else if($rangeplayera == 3 && $name != $_SESSION['login'])
	{
	if($rangepracownika < 2)
	{
	echo ' <a href="company.php?awans='.$name.'"><img src="plus.png" title="Awansuj"></img></a> <a href="company.php?degraguj='.$name.'"><img src="minus.png" title="Degraguj"></img></a>'; 	
	}
	else if($rangepracownika == 2)
	{
		echo '<a href="company.php?degraguj='.$name.'"><img src="minus.png" title="Degraguj"></img></a>';
	}
	}
	?> 
	<label>
	<div class="progress">
	<div class="progress-bar progress-bar-ok" style="width: 100px;">
	Zarobil $<? echo $zarobil; ?>
	</div>
	</div>
	</label>
	
	</div>
	<?
	$query = "SELECT * FROM `employess` WHERE `company` = '$id' ORDER BY `range` DESC";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);

	$i++;
	}
	}
	
	if($_GET['podanieadd'] != '')
	{
	$comp = $_GET['podanieadd'];
	$_SESSION['comp'] = $comp;
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick'";
	$res = mysql_query($query);
	$num = mysql_num_rows($res);
	if($num == 0)
	{
	echo '<form method="POST" action="company.php?sendapli='.$comp.'">';
	echo '<br/><br/><br/><input name="podanie" class="textarena" type="text" placeholder="Tutaj wpisz tresc podania"></input><br/><br/><input class="button" type="submit" value="Wyslij!"/>';
	echo '</form>';
	}
	else
	{
	echo '<div class="info_box">Jestes juz zatrudniony!</div>';
	}
	
	}
	if($_GET['sendapli'] != '')
	{
	$comp = $_GET['sendapli'];
	$text = $_POST['podanie'];
	$text = htmlspecialchars($text);
	$text = addslashes($text);
	
	$nickofplayer = $_SESSION['login'];
	//echo 'Uid'.$nickofplayer;
	$queryd = "SELECT * FROM `applications` WHERE `nick` = '$nickofplayer'";
	$resd = mysql_query($queryd) or die(mysql_error());


	$numd = mysql_num_rows($resd);

	if($numd == 0)
	{


	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `users` WHERE `nick` = '$nick' LIMIT 1";
	$res = mysql_query($query);
	
	$uid = mysql_result($res,0,"id");
	
	$query = "INSERT INTO `applications` (`nick`, `uid`, `company`, `text`) VALUES ('$nick','$uid','$comp','$text')";
	mysql_query($query) or die(mysql_error());
	
	echo '<div class="ok_box">Podanie zostalo wyslane!<br/>Czekaj na akceptacje podania lub jego odrzucenie!</div>';
	}
	else
	{
		echo '<div class="error_box">Wyslales juz podanie!</div>';
	}	
	}
	
	
	if($_GET['awans'] != '')
	{
	$nick = $_SESSION['login'];
	$comp = $_SESSION['clickedcomp'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	if($range >= 3)
	{
	
	$player = $_GET['awans'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$player' AND `company` = '$compwlas'";
	$res = mysql_query($query);
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$emprange = mysql_result($res,0,"range");
	$rangeact = $emprange+1;
	
	if($rangeact >= 5)
	{
	$rangeact = 4;
	}

	if($range == 3 && $rangeact >= 3)
	{
		echo '<div class="info_box">Brak uprawnien!</div>';
	}
	else
	{
	
	$query = "UPDATE `employess` SET `range` = '$rangeact' WHERE `nick` = '$player'";
	mysql_query($query);
	echo '<div class="ok_box">Gracz zostal awansowany!</div>';
	}
	}
	else
	{
	echo '<div class="info_box">Ten gracz nie jest w twojej firmie!</div>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	}
	
	
	
	if($_GET['degraguj'] != '')
	{
	$nick = $_SESSION['login'];
	$comp = $_SESSION['clickedcomp'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	if($range >= 3)
	{
	
	$player = $_GET['degraguj'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$player' AND `company` = '$compwlas'";
	$res = mysql_query($query);
	$num = mysql_num_rows($res);
	if($num >= 1)
	{
	$emprange = mysql_result($res,0,"range");
	$rangeact = $emprange-1;
	

	if($range == 3 && $emprange >= 3)
	{
		echo '<div class="info_box">Brak uprawnien do pracownika!</div>';
	}
	else
	{

	if($rangeact < 0)
	{
	$query = "DELETE FROM `employess` WHERE `nick` = '$player'";
	mysql_query($query);
	echo '<div class="ok_box">Gracz zostal wyrzucony z firmy/frakcji!</div>';
	$player = $_GET['degraguj'];
	$query = "UPDATE `users` SET `team` = '0' WHERE `nick` = '$player'";
	mysql_query($query);
	
	}
	else
	{
	
	$query = "UPDATE `employess` SET `range` = '$rangeact' WHERE `nick` = '$player'";
	mysql_query($query);
	echo '<div class="ok_box">Gracz zostal zdegragowany!</div>';
	}
	}
	
	}
	else
	{
	echo '<div class="info_box">Ten gracz nie jest w twojej firmie!</div>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	}
	
	if($_GET['podanieaccept'] != '' && $_GET['comp'] != '')
	{
	$company = $_GET['comp'];
	$nick = $_SESSION['login'];
	$comp = $company;
	
	$idapp = $_GET['podanieaccept'];
	
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	if($range >= 3)
	{
	
	
	$query = "SELECT * FROM `applications` WHERE `id` = '$idapp' LIMIT 1";
	$res = mysql_query($query);
	
	$uid = mysql_result($res,0,"uid");
	$nick = mysql_result($res,0,"nick");


	$query = "SELECT * FROM `users` WHERE `name` = '$nick' AND `id` = '$uid'";
	$res = mysql_query($query);

	$teamplayerr = mysql_result($res,0,"team");

	if($teamplayerr == 0)
	{
	
	$query = "INSERT INTO `employess` (`nick`, `uid`, `company`, `earned`, `range`) VALUES ('$nick','$uid','$comp','0','0')";
	mysql_query($query) or die(mysql_error());
	$idapp = $_GET['podanieaccept'];
	$query = "DELETE FROM `applications` WHERE `id` = '$idapp'";
	mysql_query($query);
	
	$query = "UPDATE `users` SET `team` = '$comp' WHERE `id` = '$uid'";
	mysql_query($query);
	
	echo '<div class="ok_box">Gracz zostal przyjety!</div>';
	
	}
	else
	{
		echo '<div class="info_box">Gracz juz jestes w jakiejs innej firmie!</div>';
	}
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	}
	

	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	}
	
	
	if($_GET['podanieremove'] != '' && $_GET['comp'] != '')
	{
	$company = $_GET['comp'];
	$nick = $_SESSION['login'];
	$comp = $company;
	
	$idapp = $_GET['comp'];
	
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	if($range >= 3)
	{
	$idapp = $_GET['podanieremove'];

	$query = "DELETE FROM `applications` WHERE `id` = '$idapp'";
	mysql_query($query) or die(mysql_error());
	

	
	echo '<div class="ok_box">Podanie #'.$idapp.'zostalo odrzucone!</div>';
	
	}
	else
	{
	echo '<div class="error_box">Brak uprawnien!</div>';
	}
	
	}
	else
	{
	echo '<div class="error_box">Brak uprawnien!</div>';
	}
	
	}
	
	if($_GET['config'] != '' && $_GET['comp'] == '')
	{
	$comp = $_GET['config'];
	
	$nick = $_SESSION['login'];
	
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	
	if($range >= 4)
	{
	
	
	$query = "SELECT * FROM `employess` WHERE `company` = '$comp'";
	$res = mysql_query($query);
	
	$liczbapracownikow = mysql_num_rows($res);
	
	$query = "SELECT * FROM `company` WHERE `id` = '$comp'";
	$res = mysql_query($query);
	$budget = mysql_result($res,0,"budget");
	
	echo '<br/><br/>';
	echo '<h4>Ustawienia Firmy/Frakcji UID '.$comp.'</h4><br/><br/>';
	echo '<form method="POST" action="?wyplata='.$comp.'">';
	echo '<div class="panel_left">Kwota ktora chcesz przeznaczyc<br/>na wyplaty:<br/><br/><input class="textarena" type="text" name="wyplata" placeholder="W $ na pracownika" onkeyup="calculatePercentage(this.value)"/>
	<br/><br/><b>Jeden pracownik dostanie: </b>$<span id="results">-</span> <br/><b>Podatek</b>: $<span id="results2">-</span>
	<br/><b>Liczba pracownikow:</b> '.$liczbapracownikow.' szt.
	<br/><b>Budzet po wyplacie:</b> $<span id="results3">-</span><br/><b>Aktualny Budzet: </b>$'.$budget.'
	<br/><br/><input class="button" type="submit" value="Wyplac"/>';
	?>
	<script>
	function calculatePercentage (oldval) 
	{
		document.getElementById("results").innerHTML = Math.round(oldval);
		document.getElementById("results2").innerHTML = Math.round(300);
		zaplaci = Math.round(oldval*<? echo $liczbapracownikow; ?>+300);
		document.getElementById("results3").innerHTML = Math.round(<? echo $budget; ?>-zaplaci);
	}
	</script></div></form>
	<?
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	}
	if($_GET['wyplata'] != '')
	{
	$comp = $_GET['wyplata'];
	
	$nick = $_SESSION['login'];
	
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	
	if($range >= 4)
	{
	
	$wyplata = $_POST['wyplata'];
	if($wyplata >= 10) // ++ Wyplata
	{
	$comp = $_GET['wyplata'];
	
	$query = "SELECT * FROM `company` WHERE `id` = '$comp'";
	$res = mysql_query($query) or die(mysql_error());
	
	$budzett = mysql_result($res,0,"budget");
	
	$budgetpo = $budzett-$wyplata;
	if($budgetpo > 10)
	{
	
	
	$comp = $_GET['wyplata'];
	
	
	$query = "SELECT * FROM `employess` WHERE `company` = '$comp'";
	$res = mysql_query($query) or die(mysql_error());
	
	$liczbapracownikow = mysql_num_rows($res);
	
	//echo $liczbapracownikow;
	
	$podatek3 = $liczbapracownikow*$wyplata;
	$podatekpods = 300;
	$podatek = $podatek3+$podatekpods;
	//echo $podatek;
	echo '<!--- Idiots EveryWhere !--->';
	$query = "UPDATE `company` SET `budget` = `budget` - '$podatek' WHERE `id` = '$comp'";
	mysql_query($query) or die(mysql_error());
	
	$query = "UPDATE `employess` SET `earned` = '0' WHERE `company` = '$comp'";
	mysql_query($query) or die(mysql_error());	

	$query = "SELECT * FROM users WHERE team = '$comp'";
	$res = mysql_query($query) or die(mysql_error());

	$num = mysql_num_rows($res);

	$i = 0;
	while($i < $num)
	{
		$uidplayeremp = mysql_result($res,$i,"id");

		$querys = "INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('1','$uidplayeremp','$wyplata','Wyplata z firmy $comp')";
		mysql_query($querys) or die(mysql_error());

		$i++;
	}
	
	$query = "UPDATE `users` SET `bank` = `bank` + '$wyplata' WHERE `team` = '$comp'";
	mysql_query($query) or die(mysql_error());
	echo '<div class="ok_box">Wyplata zostala pomyslnie rozdana dla pracownikow!</div>';
	
	}
	else // ------ Wyplata BLOKADA - Budgetu.
	{
	echo '<div class="info_box">Po wyplacie budzet firmy moze wynosic minimalnie 10 $!</div>';
	}
	
	}
	else // ------ Wyplata.
	{
	echo '<div class="info_box">Wyplata moze maksymalnie wynosic $10!</div>';
	}
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}	
	}
	
	
	if($_GET['checkapli'] != '')
	{
	$nick = $_SESSION['login'];
	$comp = $_GET['checkapli'];
	$query = "SELECT * FROM `employess` WHERE `nick` = '$nick' AND `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	if($num >= 1)
	{
	$range = mysql_result($res,0,"range");
	$compwlas = mysql_result($res,0,"company");
	if($range >= 3)
	{
	
	$query = "SELECT * FROM `applications` WHERE `company` = '$comp'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	$i =0;
	while($i < $num)
	{
	$uidpodania = mysql_result($res,$i,"id");
	$nick = mysql_result($res,$i,"nick");
	$uid = mysql_result($res,$i,"uid"); 
	$text = mysql_result($res,$i,"text"); 	
	
	
	echo '<div class="box">
	<b>'.$nick.'</b><br/><b>Napisal:</b><br/>'.$text.' 
	<a href="?podanieaccept='.$uidpodania.'&comp='.$comp.'"><label><img src="add.png" title="PRZYJMIJ"/></a> </label>
	<a href="?podanieremove='.$uidpodania.'&comp='.$comp.'"><label><img src="remove.png" title="Odrzuc"/>  /  </a></label></div><br/>';
	
	
	$i++;
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Brak uprawnien!</div>';
	}
	
	
	
	}
	if($_GET['quitc'] != '')
	{
	$comp = $_GET['quitc'];
	$login = $_SESSION['login'];
	
	$query = "DELETE FROM `employess` WHERE `nick` = '$login' AND `company` = '$comp'";
	mysql_query($query) or die('<div class="info_box">Error! DELETE</div>');
	
	$query = "UPDATE `users` SET `team` = '0' WHERE `nick` = '$login'";
	mysql_query($query) or die('<div class="info_box">Error! UPDATE</div>');
	}
	
	
	
	?>
	

	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>


<?

    function playername($uid)
    {
    $string = "NULL";
    $queryt = "SELECT * FROM `users` WHERE `id` = '$uid'";
    $rest = mysql_query($queryt);
    
    $numt = mysql_num_rows($rest);
    
    if($numt >= 1)
    {
    $string = mysql_result($rest,0,"nick");
    }
    
    return $string;
    }
?>