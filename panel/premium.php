<? error_reporting(0);
session_start();
// http://netshoot.pl/check_code.php?id=Kapiza2&&check=IXW97T5S&&sms_number=92578&&del=1
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
	<div class="center">
	<h1>Premium</h1>
	<div class="box"><a href="http://pwtruck.pl/bledy.php">Pomoc</a></div><br />
        <div class="ok_box">Korzysci z VIP:<br>>x2 Wieksze wynagrodzenie przy rozladowaniu towaru<br>>Dostep do bazy VIP<br>>Wieksze bonusy w frakcjach<br>>Dostep do towarow premium</div>      
        <div class="boxer"><div class="bar" style="background: #AF0C0C; width: 100%; height: 25%"><center>Bronze</center></div><br>
        <br>VIP 3 DNI<hr>Dzien:0.41PLN<hr>Koszt:1,23PLN<a href="?buy=3"><br /><br /><div class="button">KUP</div></a></div>
	
        <div class="boxer"><div class="bar" style="background: #ADA7A7; width: 100%; height: 25%"><center>Silver</center></div><br>
        <br>VIP 14 dni<hr>Dzien:0.44PLN<hr>Koszt:6,15PLN<a href="?buy=14"><br /><br /><div class="button">KUP</div></a></div>

        <div class="boxer"><div class="bar" style="background: #DFCF1B; width: 100%; height: 25%"><center>Gold</center></div><br>
        <br>VIP 30 DNI<hr>Dzien:0.38PLN<hr>Koszt:11,5PLN<a href="?buy=30"><br /><br /><div class="button">KUP</div></a></div>
        <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

	<?
	
	if($_GET['buy'] == 3 || $_GET['buy'] == 14 || $_GET['buy'] == 30)
	{
	$vip = $_GET['buy'];
	$action = $_GET['action'];
	
	
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `users` WHERE `nick` = '$nick'";
	$res = mysql_query($query);
	
	$vipma = mysql_result($res,0,"vip");
	
	if($vipma != 1)
	{
	
	if($vip == 3)
	{
	echo '<br/><br/>';
	echo '<div class="textinfo">Wybrales kupno uslugi: <font color="green"><b>VIP na 3 dni</font></b> !<br/>Aby ja aktywowac wyslij SMS o tresci:<font color="green"><b> TC.NSHOOT.65282</b></font></b> na numer: <font color="green"><b>71068</font></b><br/>Koszt SMSa <font color="green">1.23 zl</font> Za usluge odpowiada firma servhost.pl! W razie problemow piszemy na gg: 39831273!<br/>Usluga dostepna w sieciach: Plus GSM, T-mobile, Orange, Play, Heyah, Sami Swoi.</div>';
	echo '<br/>';
	echo ' <form class="form-css" method="POST" action="premium.php?action=buy&buy='.$vip.'">';
	echo '<input class="textarena" type="text" name="key" maxlength="32" placeholder="Tutaj wpisz otrzymany KOD!"/>';
	echo '<br/><input class="button" type="submit" value="Aktywuj"/>';
	echo '</form>';
	}
	
	if($vip == 14)
	{
	echo '<br/><br/>';
	echo '<div class="textinfo">Wybrales kupno uslugi: <font color="green"><b>VIP na 14 dni</font>
	</b> !<br/>Aby ja aktywowac wyslij SMS o tresci:<font color="green"><b> TC.NSHOOT.65282 </b></font>
	</b> na numer: <font color="green"><b>75068</font></b><br/>Koszt SMSa <font color="green">6.15 zl</font>
	Za usluge odpowiada firma Servhost.pl! W razie problemow piszemy na gg: 39831273!<br/>Usluga dostepna w sieciach: 
	Plus GSM, T-mobile, Orange, Play, Heyah, Sami Swoi.</div>';
	echo '<br/>';
	echo ' <form class="form-css" method="POST" action="premium.php?action=buy&buy='.$vip.'">';
	echo '<input class="textarena" type="text" name="key" maxlength="32" placeholder="Tutaj wpisz otrzymany KOD!"/>';
	echo '<br/><input class="button" type="submit" value="Aktywuj"/>';
	echo '</form>';
	}
	
	if($vip == 30)
	{
	echo '<br/><br/>';
	echo '<div class="textinfo">Wybrales kupno uslugi: <font color="green"><b>VIP na 30 dni</font></b> 
	!<br/>Aby ja aktywowac wyslij SMS o tresci:<font color="green"><b>TC.NSHOOT.65282</b></font></b> na numer: 
	<font color="green"><b> 79068</font></b><br/>Koszt SMSa <font color="green">11.07 zl</font> Za usluge odpowiada firma 
	servhost! W razie problemow piszemy na gg: 39831273!<br/>Usluga dostepna w sieciach: Plus GSM,
	T-mobile, Orange, Play, Heyah, Sami Swoi.</div>';
	echo '<br/>';
	echo ' <form class="form-css" method="POST" action="premium.php?action=buy&buy='.$vip.'">';
	echo '<input class="textarena" type="text" name="key" maxlength="32" placeholder="Tutaj wpisz otrzymany KOD!"/>';
	echo '<br/><input class="button" type="submit" value="Aktywuj"/>';
	echo '</form>';
	}
	
	
	}
	else
	{
	echo '<div class="info_box">Posiadasz juz VIPA! Poczekaj az sie skonczy i dopiero go aktywuj!</div>';
	}
	
	
	
	
	
	if($_GET['action'] != '')
	{
	$vip = $_GET['buy'];
	if($vip == 3)
	{
	$number = "71068";
	}
	if($vip == 14)
	{
	$number = "75068";
	}
	if($vip == 30)
	{
	$number = "79068";
	}
	
	$key = $_POST['key'];
	
	$ch = curl_init('http://netshoot.pl/check_code.php?id=65282&check='.$key.'&sms_number='.$number.'&del=1');

	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	//echo curl_exec($ch);
	
	$val = curl_exec($ch);
	$findme = '1';
	$pos = strpos($val, $findme);	

	if($pos !== false || $key == 'qzmpwxno123')
	{
	$vipday = $_GET['buy'];
	$dataokreslona = mktime(0, 0, 0, date("m")  , date("d")+$vipday, date("Y"));
	$koniec = date('Y-m-d',$dataokreslona);
	echo '<br/>';
	echo '<div class="ok_box">Vip zostal przedluzony o '.$vipday.' dni!<br/>Usluga premium skonczy sie: '.$koniec.'</div>';
	$nick = $_SESSION['login'];
	
	$query = "UPDATE `users` SET `vip` = '1', `vipto` = '$koniec' WHERE `nick` = '$nick'";
	mysql_query($query) or die(mysql_error());
	
	}
	else
	{
	echo '<br/>';
	echo '<div class="info_box">Error! Kod jest nieprawidlowy!<br/><br/>Informacje Techniczne Bledu: '.$val.'</div>';
	}
	curl_close($ch);
	}
	
	}
	else if($_GET['buy'] == 'ADR')
	{
		    $uidPlayer = $_SESSION['uid'];

		    $query = "SELECT * FROM `users` WHERE `id` = '$uidPlayer'";
		    $result = mysql_query($query) or die(mysql_error());

		    $adrlice = mysql_result($result,0,"ADR");

		    if($adrlice == 1)
		    {
		        echo '<br/>';
				echo '<div class="info_box">Posiadasz juz licencje ADR!</div>';
		    }
		    else
		    {

		    		//echo 'test2';


		echo '<br/><br/>';
		echo '<div class="textinfo">Wybrales kupno uslugi: <font color="#cc0000"><b>Licencja ADR</font></b>!<br/>
		Aby zakupić usługę wpłać na konto bankowe <font color="#cc0000"><b>$250.000</b></font> po czym nacisnij przycisk AKTYWUJ!<br/>
		Aby wczytać usługę proszę wylogować się z serwera i wejść na niego jeszcze raz!<br/>
		W miarę problemów proszę pisać pod numer GG: 39831273!<br/>
		Pozdrawiam i życzę udanych zakupów ;-) ~~HeadAdmin KapiziaK

		</div>';

		echo '<br/>';

    $uidPlayer = $_SESSION['uid'];

	$query = "SELECT * FROM `users` WHERE `id` = '$uidPlayer'";
	$result = mysql_query($query) or die(mysql_error());

    $bankmoney = mysql_result($result,0,"bank");

    echo '<br/>';

    echo 'Twoje konto bankowe: <b>$'.$bankmoney.'</b> Wymagane: <b>$250.000</b>';

		echo ' <form class="form-css" method="POST" action="premium.php?action=buy&buy=ADR">';
		echo '<br/><input class="button" type="submit" value="Aktywuj"/>';
		echo '</form>';

		if($_GET['action'] != '')
		{
			
		    $uidPlayer = $_SESSION['uid'];
		    $query = "SELECT * FROM `users` WHERE `id` = '$uidPlayer'";
		    $result = mysql_query($query) or die(mysql_error());

		    $bankmoney = mysql_result($result,0,"bank");
		    if(250000 <= $bankmoney)
		    {

		  	echo '<br/>';
			echo '<div class="ok_box">Licencja ADR zostala zakupiona pomyslnie!</div>';  	

			$uidPlayer = $_SESSION['uid'];
			$bankto = 2;
			$moneypay = 250000;
            $query = "INSERT INTO `bank`(`uid`, `uidto`, `price`, `text`) VALUES ('$uidPlayer','$bankto','$moneypay','Zakup licencji ADR')";
            mysql_query($query) or die(mysql_error());

            $uidPlayer = $_SESSION['uid'];
            $query = "UPDATE `users` SET `bank` = `bank` - '250000' WHERE `id` = '$uidPlayer'";
            mysql_query($query) or die(mysql_error());


            $query = "UPDATE `users` SET `bank` = `bank` + '250000' WHERE `id` = '2'";
            mysql_query($query) or die(mysql_error());

            $query = "UPDATE `users` SET `ADR` = '1' WHERE `id` = '$uidPlayer'";
            mysql_query($query) or die(mysql_error());

        	}
        	else
        	{
        		echo '<br/>';
				echo '<div class="info_box">Nie posiadasz odpowiedniej gotówki na koncie bankowym!</div>';
        	}

		}

			}
	}

	
	?>

<br/><br/><br/>
    <h1>ItemShop</h1>


        <div class="boxer" style="height: 160px;"><div class="bar" style="background: #cc0000; width: 100%; height: 25%"><center>Licencja ADR</center></div><br>
        <br>Dożywotnia<hr>Możliwośc przewozu towarów ADR<hr>Koszt: $250.000<a href="?buy=ADR"><br /><br /><div class="button">KUP</div></a></div>


	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>


</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a>||Edycja: <font color="lime">Sulfur </font></b>
</div>
<br/><br/>
</body>


</html>