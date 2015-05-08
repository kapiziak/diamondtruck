<? session_start();
include ('config.php');

if($_SESSION['loggined'] != 1)
{
header("Location: login.php?action=dontaccess");
}


$query="SELECT * FROM `users` WHERE name='$name'";
$result=mysql_query($query);

{
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
	<h1>Logi</h1><br/> 
	<?
	$query = "SELECT * FROM logsp ORDER BY date DESC LIMIT 15";
	$result = mysql_query($query) or die(mysql_error());
	
	$num = mysql_num_rows($result);
	
	$i=0;
	while($i < $num)
	{
	$nick = mysql_result($result,$i,"playername");
	$date = mysql_result($result,$i,"date");
	$ip = mysql_result($result,$i,"ip");
	$desc = mysql_result($result,$i,"desc");


	
	echo '<div class="box">Czynność: ' .$desc.'<br/>Nick: '.$nick. '<br/>Data: '.$date.' <label>IP '.$ip.'</label></div><br/>';
	
	$i++;
	
	}
	?>
</div>
</body>

<?
}

?>
</div>

</html>