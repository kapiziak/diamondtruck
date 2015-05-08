<? error_reporting(0); session_start();
include ('config.php');

if($_SESSION['loggined'] != 1 || $_SESSION['leveladmin'] != 6)
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
<? if($_GET['send'] != 'server' && $_SESSION['autorefresh'] == 1)
{
?>
<meta http-equiv="refresh" content="3">
<?
}
?>

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
	<h1>Administracja</h1>
	<br/><br/>
	<h5>Aktywne Bany</h5><br/>
	
	<?
	if($_GET['deleteban'] != '')
	{
	if($_SESSION['leveladmin'] >= 4)
	{
	$banid = $_GET['deleteban'];
	
	$query = "DELETE FROM `bans` WHERE `id` = '$banid'";
	mysql_query($query) or die(mysql_error());
	
	echo '<div class="ok_box">Ban zostal zdjety pomyslnie!</div>';
	
	}
	else
	{
	echo '<div class="info_box"> Potrzebujesz wyzszego levela admina!</div>';
	}
	
	}
	else
	{
	echo '<div class="box">';
	$query = "SELECT * FROM `bans` ORDER BY `id` DESC";
	$res = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($res);
	
	$i=0;
	while($i < $num)
	{
	$id = mysql_result($res,$i,"id");
	$nick = mysql_result($res,$i,"nick");
	$admin = mysql_result($res,$i,"admin");
	$reason = mysql_result($res,$i,"reason");
	$banto = mysql_result($res,$i,"banto");

	

	
	

	
	if($_SESSION['leveladmin'] >= 4)
	{
	$stat = '<a href="?deleteban='.$id.'"><div class="hint--left" data-hint="Usun Bana koniec '.$banto.'"><img  src="ban_remove.png" /></a></div>';
	}
	else
	{
	$stat = '';
	}
	
	echo '<li>'.$nick.' - '.$reason.' <label>Banujacy: '.$admin.' '.$stat.' </label>';
	
	
	$i++;
	}
	
	if($num == 0)
	{
	echo '<br/>Brak banow w bazie danych!!!<br/><br/>';
	}
	
	echo '</div>';
	}
	?>
	
	
	
	</div>
	
	<!--<div class="right">
	<h1>Test</h1>
	</div>!-->
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>

</div>

<br/><br/>

<div class="header">
<font color="white"><b>pwTRUCK <? echo $VERSION; ?> || Wszelkie prawa zastrzezone &copy 2014 || Autor: <a href="gg:39831273">KapiziaK</a></font></b>
</div>
<br/><br/>
</body>


</html>
<?

/*function get_friendly_time_ago($distant_timestamp, $max_units = 3) {
    $i = 0;
    $time = $distant_timestamp - time(); // to get the time since that moment
    $tokens = array (
        31536000 => 'year',
        2592000 => 'month',
        604800 => 'week',
        86400 => 'day',
        3600 => 'hour',
        60 => 'minute',
        1 => 'second'
    );

    //$responses;
    while ($i < $max_units) {
        foreach ($tokens as $unit => $text) {
            if ($time < $unit) {
                continue;
            }
            $i++;
            $numberOfUnits = floor($time / $unit);

            $responses[] = $numberOfUnits . ' ' . $text . (($numberOfUnits > 1) ? 's' : '');
            $time -= ($unit * $numberOfUnits);
            break;
        }
    }

    if (!empty($responses)) {
        return implode(', ', $responses) . ' ago';
    }

    return 'Just now';
}*/


?>