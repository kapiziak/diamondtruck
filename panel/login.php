<? session_start();
include ('config.php');

if($_SESSION['zalogowany'] == 1)
{
header("Location: panel.php");
}



if($_GET['action'] == 'check')
{
$login = $_POST['login'];
$haslo = $_POST['haslo'];
$haslo = addslashes($haslo);
$login = addslashes($login);
$login = htmlspecialchars($login);

$haslo = MD5($haslo);


if ($_GET['login'] != '') { //jezeli ktos przez adres probuje kombinowac
header("Location: login.php?nieudane=1");
exit;
}
if ($_GET['haslo'] != '') { //jezeli ktos przez adres probuje kombinowac
header("Location: login.php?nieudane=1");
exit;
}


    if (!$login OR empty($login)) {
include("head2.php");
echo '<p class="alert">Wypełnij pole z loginem!</p>';
header("Location: login.php?nieudane=1");
include("foot.php");
exit;
}
    if (!$haslo OR empty($haslo)) {
include("head2.php");
echo '<p class="alert">Wypełnij pole z hasłem!</p>';
header("Location: login.php?nieudane=1");
include("foot.php");
exit;
}
$istnick = mysql_fetch_array(mysql_query("SELECT COUNT(*) FROM `users` WHERE `nick` = '$login' AND `password` = '$haslo'")); // sprawdzenie czy istnieje uzytkownik o takim nicku i hasle
    if ($istnick[0] == 0) {
header("Location: login.php?nieudane=1");
    } else {


$_SESSION['haslo'] = $haslo;
$_SESSION['login'] = $login;
$_SESSION['loggined'] = 1;


header("Location: panel.php");

}
}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pl" lang="pl">
<head>
<title>Diamond Gaming</title>
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
	<h1>Logowanie</h1><?

if($_GET['nieudane'] == 1)
{
echo '<div class="info_box">Podane dane nie istnieja w bazie danych!</div>';
}
else if($_GET['action'] == 'dontaccess')
{
echo '<div class="info_box">Zaloguj się! Aby uzyskać dostep do strony!</div>';
}
else if($_GET['nieudane'] != 1)
{
echo '<div class="ok_box">Aby sie zalogowac wpisz w ponizsze pola, login oraz haslo z gry!</div>';
}
?>

	
	<form class="form-css" method="POST" action="login.php?action=check">
	<tr><td><br></td></tr>
	<tr><td width="50">Login:</td><td><input class="textarena" type="text" name="login" maxlength="32"></td></tr>
	<tr><td width="50">Haslo:</td><td><input class="textarena" type="password" name="haslo" maxlength="32"></td></tr>
	<tr><td align="center" colspan="2"><input class="button" type="submit" value="Zaloguj"><br></td></tr>
	</form>
	</div><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	
</div>

<br/><br/>

<div class="header">
<font color="white"><b>Diamond Gaming Panel <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>