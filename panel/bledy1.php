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
	<h1>Formularz pomocy</h1>
	<div class="box"><a href="http://pwtruck.pl/premium.php">Wroc</a></div><br />
<?php
if(empty($_POST['temat'])&&empty($_POST['tresc'])){
?>
<form action="bledy1.php" method="post">
<center><b>Temat:</b></center>  <center><input class="textarena" type="text" value="" name="temat" /></center><br />
<center><b>Twoj nick:</b></center>  <center><input class="textarena" type="text" value="" name="mail" /></center> <br />
<center><b>Tresc</b></center> <center><textarea class="textarena" name="tresc"></textarea></center> <br />
<input type="checkbox" onclick="this.form.elements['osw'].disabled = !this.checked" id="zaznacz">
<label for="zaznacz">Klikajac oswiadczasz ze to nie jest spam, obrazliwy tekst lub link.</label> <br>
<center><input class="button" type="submit" name="osw" disabled="disabled" value="Wyslij" /></center><br />
</form>

<?php
//  dane z formularza 
}else{
$temat = $_POST['temat'];
$temat = addslashes($temat); 
$tresc = $_POST['tresc'];
$tresc = addslashes($tresc);
$adresod = $_POST['mail'];
$adresod = addslashes($adresod);

$adresdo = 'daniel172@onet.pl';
// wysyla email
mail($adresdo, $temat, $tresc, $adresod);
echo "Wiadomosc zostala pomyslnie wyslana.";
}
?>


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