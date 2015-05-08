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
	<h1>Towary</h1>
	<br/>
	<? 
	if($_GET['action'] == '' && $_GET['cargo'] == '' && $_GET['remc'] == '')
	{
	?>
	<br/><? if($_SESSION['leveladmin'] >= 5) { echo '<a href="?action=addc"><img src="plus.png" title="Dodaj Towar"></a></img>'; } ?> <br/>
<div class="datagrid">
<table border="1">
<tr>
  <td>Nazwa</td>
  <td>Min. Legalne</td>
  <td>Min. Nielegalne</td>
  <td>Legalny</td>
  <td>Nielegalny</td>
  <td>V.I.P</td>
  <td>Score</td>
  <td>Pieniadze</td>
  <? if($_SESSION['leveladmin'] >= 5) { echo '<td>Akcja</td>'; } ?>
</tr>
<tr>
<?

$query = "SELECT * FROM cargos";
$result = mysql_query($query) or die(mysql_error());

$num = mysql_num_rows($result);
$i=0;
while($i < $num)
{
$id = mysql_result($result,$i,"id");
$name = mysql_result($result,$i,"name");
$minl = mysql_result($result,$i,"minlegal");
$minnl = mysql_result($result,$i,"minnielegal");
$lgl = mysql_result($result,$i,"legal");
$nlgl = mysql_result($result,$i,"NoLegal");
$vip = mysql_result($result,$i,"vip");
$score = mysql_result($result,$i,"score");
$dolary = mysql_result($result,$i,"money");

echo '<td>'.$name.'</td>';
echo '<td>'.$minl.'</td>';
echo '<td>'.$minnl.'</td>';
if($lgl == 1)
{
$lgl = 'Tak';
}
else
{
$lgl = 'Nie';
}
if($nlgl == 1)
{
$nlgl = 'Tak';
}
else
{
$nlgl = 'Nie';
}
echo '<td>'.$lgl.'</td>';
echo '<td>'.$nlgl.'</td>';
if($vip == 1)
{
$vip = 'Tak';
}
else 
{
$vip = 'Nie';
}
echo '<td>'.$vip.'</td>';
echo '<td>'.$score.'</td>';
echo '<td>'.$dolary.'</td>';
if($_SESSION['leveladmin'] >= 5)
{
echo '<td><a href="?action=cargos&cargo='.$id.'"><img src="edit.png"/></a> <a href="?action=remc&uid='.$id.'"><img src="delete.png"/></a></td>';
}
echo '</tr>';


$i++;
}
echo '</table>';
echo '</div>';
echo '<br/><br/><br/>';

}
if($_GET['cargo'] != '' && $_SESSION['leveladmin'] >= 5)
{
?>
<br/><br/><h1>Towary...</h1><br/><br/>
<div class="datagrid">
<table border="1">
<tr>
  <td>Nazwa</td>
  <td>Min. Legalne</td>
  <td>Min. Nielegalne</td>
  <td>Legalny</td>
  <td>Nielegalny</td>
  <td>V.I.P</td>
  <td>Score</td>
  <td>Pieniadze</td>
  <? if($_SESSION['leveladmin'] >= 5) { echo '<td>Akcja</td>'; } ?>
</tr>
<tr>
<?

$query = "SELECT * FROM cargos";
$result = mysql_query($query) or die(mysql_error());

$num = mysql_num_rows($result);
$i=0;
while($i < $num)
{
$id = mysql_result($result,$i,"id");
$name = mysql_result($result,$i,"name");
$minl = mysql_result($result,$i,"minlegal");
$minnl = mysql_result($result,$i,"minnielegal");
$lgl = mysql_result($result,$i,"legal");
$nlgl = mysql_result($result,$i,"NoLegal");
$vip = mysql_result($result,$i,"vip");
$score = mysql_result($result,$i,"score");
$dolary = mysql_result($result,$i,"money");

echo '<td>'.$name.'</td>';
echo '<td>'.$minl.'</td>';
echo '<td>'.$minnl.'</td>';
if($lgl == 1)
{
$lgl = 'Tak';
}
else
{
$lgl = 'Nie';
}
if($nlgl == 1)
{
$nlgl = 'Tak';
}
else
{
$nlgl = 'Nie';
}
echo '<td>'.$lgl.'</td>';
echo '<td>'.$nlgl.'</td>';
if($vip == 1)
{
$vip = 'Tak';
}
else 
{
$vip = 'Nie';
}
echo '<td>'.$vip.'</td>';
echo '<td>'.$score.'</td>';
echo '<td>'.$dolary.'</td>';
if($_SESSION['leveladmin'] >= 5)
{
echo '<td><a href="?action=cargos&cargo='.$id.'"><img src="edit.png"/></a> <a href="?action=remc&uid='.$id.'"><img src="delete.png"/></a></td>';
}
echo '</tr>';


$i++;
}
echo '</table>';
echo '</div>';
echo '<br/><br/><br/>';

$uidtowar = $_GET['cargo'];
$query = "SELECT * FROM cargos WHERE id='$uidtowar' LIMIT 1";
$result = mysql_query($query) or die(mysql_error());

$i=0;
$name = mysql_result($result,$i,"name");
$minl = mysql_result($result,$i,"minlegal");
$minnl = mysql_result($result,$i,"minnielegal");
$lgl = mysql_result($result,$i,"legal");
$nlgl = mysql_result($result,$i,"NoLegal");
$vip = mysql_result($result,$i,"vip");
$score = mysql_result($result,$i,"score");
$dolary = mysql_result($result,$i,"money");

//   										`name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`


?>
Edytor towaru <? echo $name; ?>
<form action="?action=setcargos&uid=<? echo $uidtowar; ?>" method="POST"><br/>Nazwa
<input class="textarena" name="cargo" type="text" value="<? echo $name; ?>"/><br/><br/>
Min l.<input class="textarena" name="minl" type="text" value="<? echo $minl; ?>"/><br/><br/>
Min nl.<input class="textarena" name="minnlg" type="text" value="<? echo $minnl; ?>"/><br/><br/>
LG.<input class="textarena" name="lgl" type="text" value="<? echo $lgl; ?>"/><br/><br/>
NLG.<input class="textarena" name="nlgl" type="text" value="<? echo $nlgl; ?>"/><br/><br/>
VIP<input class="textarena" name="vip" type="text" value="<? echo $vip; ?>"/><br/><br/>
SCORE<input class="textarena" name="score" type="text" value="<? echo $score; ?>"/><br/><br/>
KASA<input class="textarena" name="dolary" type="text" value="<? echo $dolary; ?>"/><br/><br/>
<br/><br/><br/>

<input class="button" type="submit" value="Zapisz"/><br/><br/><br/>

</form>
</div>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

<br/><br/><br/><br/><br/>
<?
}
if($_GET['action'] == 'setcargos' && $_GET['uid'] != '' && $_SESSION['leveladmin'] >= 5)
{
// `name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`

$name = $_POST['cargo'];
$minl = $_POST['minl'];
$minnl = $_POST['minnlg'];
$lgl = $_POST['lgl'];
$nlgl = $_POST['nlgl'];
$vip = $_POST['vip'];
$score = $_POST['score'];
$dolary = $_POST['dolary'];
$uid = $_GET['uid'];

$query = "UPDATE `cargos` SET `name` = '$name', `minlegal` = '$minl', `minnielegal` = '$minnl', `Legal` = '$lgl', `NoLegal` = '$nlgl', `vip` = '$vip', `score` = '$score', `money` = '$dolary' WHERE `id` ='$uid'";
mysql_query($query) or die(mysql_error());
echo '<br/><br/><a href="statystyki.php?action=cargos">Kliknij tutaj</a>';



}

if($_GET['action'] == 'remc' && $_SESSION['leveladmin'] >= 5)
{
// `name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`

$uid = $_GET['uid'];

$query = "DELETE FROM `cargos` WHERE `id` = '$uid'";
mysql_query($query) or die(mysql_error());
echo '<br/><br/><a href="statystyki.php?action=cargos">Kliknij tutaj Akcja wykonana!</a>';
}


if($_GET['action'] == 'addc' && $_SESSION['leveladmin'] >= 5)
{
?>

<div class="datagrid">
<table border="1">
<tr>
  <td>Nazwa</td>
  <td>Min. Legalne</td>
  <td>Min. Nielegalne</td>
  <td>Legalny</td>
  <td>Nielegalny</td>
  <td>V.I.P</td>
  <td>Score</td>
  <td>Pieniadze</td>
  <? if($_SESSION['leveladmin'] >= 5) { echo '<td>Akcja</td>'; } ?>
</tr>
<tr>
<?

$query = "SELECT * FROM cargos";
$result = mysql_query($query) or die(mysql_error());

$num = mysql_num_rows($result);
$i=0;
while($i < $num)
{
$id = mysql_result($result,$i,"id");
$name = mysql_result($result,$i,"name");
$minl = mysql_result($result,$i,"minlegal");
$minnl = mysql_result($result,$i,"minnielegal");
$lgl = mysql_result($result,$i,"legal");
$nlgl = mysql_result($result,$i,"NoLegal");
$vip = mysql_result($result,$i,"vip");
$score = mysql_result($result,$i,"score");
$dolary = mysql_result($result,$i,"money");

echo '<td>'.$name.'</td>';
echo '<td>'.$minl.'</td>';
echo '<td>'.$minnl.'</td>';
if($lgl == 1)
{
$lgl = 'Tak';
}
else
{
$lgl = 'Nie';
}
if($nlgl == 1)
{
$nlgl = 'Tak';
}
else
{
$nlgl = 'Nie';
}
echo '<td>'.$lgl.'</td>';
echo '<td>'.$nlgl.'</td>';
if($vip == 1)
{
$vip = 'Tak';
}
else 
{
$vip = 'Nie';
}
echo '<td>'.$vip.'</td>';
echo '<td>'.$score.'</td>';
echo '<td>'.$dolary.'</td>';
if($_SESSION['leveladmin'] >= 5)
{
echo '<td><a href="?action=cargos&cargo='.$id.'"><img src="edit.png"/></a> <a href="?action=remc&uid='.$id.'"><img src="delete.png"/></a></td>';
}
echo '</tr>';


$i++;
}
echo '</table>';
echo '</div>';
echo '<br/><br/><br/>';


$name = 'Podaj';
$minl = 'Podaj';
$minnl = 'Podaj';
$lgl = 'Podaj 0/1';
$nlgl = 'Podaj 0/1';
$vip = 'Podaj 0/1';
$score = 'Podaj';
$dolary = 'Podaj';

//   										`name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`


?>
Dodawanie Towaru
<form action="?action=dodajc" method="POST"><br/>Nazwa
<input class="textarena" name="cargo" type="text" value="<? echo $name; ?>"/><br/><br/>
Min l.<input class="textarena" name="minl" type="text" value="<? echo $minl; ?>"/><br/><br/>
Min nl.<input class="textarena" name="minnlg" type="text" value="<? echo $minnl; ?>"/><br/><br/>
LG.<input class="textarena" name="lgl" type="text" value="<? echo $lgl; ?>"/><br/><br/>
NLG.<input class="textarena" name="nlgl" type="text" value="<? echo $nlgl; ?>"/><br/><br/>
VIP<input class="textarena" name="vip" type="text" value="<? echo $vip; ?>"/><br/><br/>
SCORE<input class="textarena" name="score" type="text" value="<? echo $score; ?>"/><br/><br/>
KASA<input class="textarena" name="dolary" type="text" value="<? echo $dolary; ?>"/><br/><br/>
<br/><br/><br/>

<input class="button" type="submit" value="Dodaj towar..."/>

</form>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

<?
}

if($_GET['action'] == 'dodajc' && $_SESSION['leveladmin'] >= 5)
{
$name = $_POST['cargo'];
$minl = $_POST['minl'];
$minnl = $_POST['minnlg'];
$lgl = $_POST['lgl'];
$nlgl = $_POST['nlgl'];
$vip = $_POST['vip'];
$score = $_POST['score'];
$dolary = $_POST['dolary'];


$query = "INSERT INTO `cargos` (`name`, `minlegal`, `minnielegal`, `Legal`, `NoLegal`, `vip`, `score`, `money`) VALUES ('$name','$minl','$minnl','$lgl','$nlgl','$vip','$score','$dolary')";
mysql_query($query) or die(mysql_error());
echo '<br/><br/><div class="ok_box"><a href="cargos.php">Kliknij tutaj towar dodany!</a></div>';
echo '</div>';
echo '<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>';
}
?>
	
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	

</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>