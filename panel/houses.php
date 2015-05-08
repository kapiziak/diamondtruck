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
	<div class="center">
	<h1>Domy</h1><br/>
	<div class="box"><a href="houses.php">Twoje Domy</a> -  <a href="?selling=1">Domy na sprzedaz</a> - <a href="?nospawn=1">Ustaw spawn w bazie</a></div><br/>

	<?
	// SELECT `name` FROM `houses` WHERE `name` LIKE "M%"

	if($_GET['sellhouse'])
	{
	$houseid = $_GET['sellhouse'];
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `houses` WHERE `owner` = '$nick' AND `id` = '$houseid'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);

	//if($num >= 1)
	//{
	//$i=0;
	//while($i < $num)
	//{
	$i=0;
	if($num != 0)
	{
	//$id = mysql_result($res,$i,"id");
	$name = mysql_result($res,$i,"name");
	//$owner = mysql_result($res,$i,"owner");
	$price = mysql_result($res,$i,"price");
	//$sell = mysql_result($res,$i,"sell");

	$cena = $price/2;

	$nick = $_SESSION['login'];
	$query = "UPDATE `users` SET `bank` = `bank` + '$cena' WHERE `nick` = '$nick'";
	mysql_query($query);
	$uidPlaye = $_SESSION['uid'];
	$houseid = $_GET['sellhouse'];
	$querys = "INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('$uidPlaye','1','$cena','Sprzedaz domku $name ($houseid)')";
	mysql_query($querys) or die(mysql_error());

	$houseid = $_GET['sellhouse'];
	$query = "UPDATE `houses` SET `owner` = 'Brak', `spawn` = '0',`sell` = '1' WHERE `id` = '$houseid'";
	mysql_query($query);


	echo '<div class="ok_box">Domek zostal sprzedany! Pieniadze pojawia sie na twoim koncie bankowym!</div>';


	}
	else
	{
		echo '<div class="info_box">Nie jestes wlascicielem tej posiadlosci!</div>';
	}





	}


	if($_GET['nospawn'] == 1)
	{


		$nickowner = $_SESSION['login'];
		$query = "SELECT * FROM `houses` WHERE `owner` = '$nickowner' AND `spawn` = '1'";
		$res = mysql_query($query) or die(mysql_error());


		if(mysql_num_rows($res) != 0)
		{


		//$nickowner = $_SESSION['login'];
			$idhouse = mysql_result($res,0,"id");
			//echo $idhouse;
		$query = "UPDATE `houses` SET `spawn` = '0' WHERE `id` = '$idhouse'";
		echo '<div class="ok_box">Domyslny spawn zostal ustawiony w bazie!</div>';
		//echo $query;
		mysql_query($query) or die(mysql_error());
		}


		

	}


	if($_GET['selling'] == 1)
	{
	echo '<br/>';
	echo '<div class="box"><a href="?search=A">A</a> - <a href="?search=B">B</a> -
	<a href="?search=C">C</a> - <a href="?search=D">D</a> -
	<a href="?search=E">E</a> - <a href="?search=F">F</a> -
	<a href="?search=G">G</a> - <a href="?search=H">H</a> -
	<a href="?search=I">I</a> - <a href="?search=J">J</a> -
	<a href="?search=K">K</a> - <a href="?search=L">L</a> -
	<a href="?search=M">M</a> - <a href="?search=O">O</a> -
	<a href="?search=P">P</a> - <a href="?search=R">R</a> -
	<a href="?search=S">S</a> - <a href="?search=T">T</a> -
	<a href="?search=U">U</a> - <a href="?search=W">W</a> -
	<a href="?search=Y">Y</a> - <a href="?search=Z">Z</a>
	</div>';
	}
	
	if($_GET['search'] != '')
	{

	$litera = $_GET['search'];
	$query = "SELECT * FROM `houses` WHERE `name` LIKE '$litera%'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);

	$i=0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$name = mysql_result($res,$i,"name");
	$owner = mysql_result($res,$i,"owner");
	$price = mysql_result($res,$i,"price");
	$sell = mysql_result($res,$i,"sell");
	
	if($sell == 1)
	{
	$sellstatus = '<a href="?buy='.$id.'">Kup Domek</a>';
	}
	if($sell == 0)
	{
	$sellstatus = '';
	}
	
	echo '<br/><div class="box"><h3>'.$name.' ('.$id.')</h3><li>Cena: $'.$price.'<br/><li>Owner: '.$owner.'<label>'.$sellstatus.'</div><br/><br/>';
	$i++;
	}
	
	
	}
	if($_GET['buy'] != '')
	{
	$id = $_GET['buy'];
	
	$query = "SELECT * FROM `houses` WHERE `id` = '$id' LIMIT 1";
	$res = mysql_query($query);
	
	$sell = mysql_result($res,0,"sell");
	$kosztuje = mysql_result($res,0,"price");
	
	if($sell == 1)
	{
	$nick = $_SESSION['login'];
	
	$query = "SELECT * FROM `users` WHERE `nick` = '$nick' LIMIT 1";
	$res = mysql_query($query);
	
	$kasa = mysql_result($res,0,"bank");
	if($kasa > $kosztuje)
	{
	$id = $_GET['buy'];
	$query = "UPDATE `houses` SET `owner` = '$nick' , `sell` = '0' WHERE `id` = '$id'";
	mysql_query($query);
	
	$query = "UPDATE `users` SET `bank` = `bank` - '$kosztuje' WHERE `nick` = '$nick'";
	mysql_query($query);
	$uidPlaye = $_SESSION['uid'];
	$querys = "INSERT INTO `bank`(`uid`,`uidto`,`price`,`text`) VALUES ('$uidPlaye','1','$kosztuje','Zakup domku $id')";
	mysql_query($querys) or die(mysql_error());

	echo '<div class="ok_box">Dom zostal zakupiony!</div>';
	}
	else
	{
	echo '<div class="info_box">Nie masz odpowiedniej kwoty na zakup tego domku!</div>';
	}
	
	}
	else
	{
	echo '<div class="info_box">Ten domek nie jest na sell!</div>';
	}
	
	
	}
	
	if($_GET['spawn'] != '')
	{
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `houses` WHERE `owner` = '$nick' AND `spawn` = '1'";
	$res = mysql_query($query);
	
	$spawnstary = mysql_result($res,0,"id");
	
	$query = "UPDATE `houses` SET `spawn` = '0' WHERE `id` = '$spawnstary'";
	mysql_query($query) or die ('<div class="info_box">ERROR spawn stary!</div>');
	
	$spawnin = $_GET['spawn'];
	$query = "UPDATE `houses` SET `spawn` = '1' WHERE `id` = '$spawnin'";
	mysql_query($query) or die ('<div class="info_box">ERROR spawn nowy!</div>');
	echo '<div class="ok_box">Spawn ustawiony!</div>';
	}

	if($_GET['buy'] == '' && $_GET['search'] == '' & $_GET['spawn'] == '' && $_GET['selling'] == '')
	{
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `houses` WHERE `owner` = '$nick' AND `spawn` = '1'";
	$res = mysql_query($query);
	
	if(mysql_num_rows($res) >= 1)
	{
	$_SESSION['spawnin'] = mysql_result($res,0,"id");
	}
	else
	{
		$_SESSION['spawnin'] = 0;
	}
	$nick = $_SESSION['login'];
	$query = "SELECT * FROM `houses` WHERE `owner` = '$nick'";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);

	if($num >= 1)
	{
	$i=0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$name = mysql_result($res,$i,"name");
	$owner = mysql_result($res,$i,"owner");
	$price = mysql_result($res,$i,"price");
	$sell = mysql_result($res,$i,"sell");
	$spawn = $_SESSION['spawnin'];
	
	$spawnstat = 'Domyslny spawn ustawiony tutaj!';
	if($id != $spawn)
	{
	$spawnstat = '<a href="?spawn='.$id.'">Ustaw Tutaj Spawn</a>';
	}
	$sellprice = $price/2;
	
	
	echo '<br/><div class="box"><h3>'.$name.' ('.$id.')</h3><li>'.$spawnstat.'<br/><a href="?sellhouse='.$id.'">Sprzedaj dom za $'.$sellprice.'</a></div><br/><br/>';
	$i++;
	}
	}
	}
	
	?>
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>


</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>
