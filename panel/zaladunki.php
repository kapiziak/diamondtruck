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
	<h1>Aktualnosci</h1><br/>
	<div class="datagrid">
	<table border="1">
	<tr>
		<td>Nazwa</td>
		<td>Pozycja X</td>
		<td>Pozycja Y</td>
		<td>Pozycja Z</td>
	</tr>
	<?
	$query = "SELECT * FROM `loading`";
	$res = mysql_query($query);
	
	$num = mysql_num_rows($res);
	
	$i=0;
	while($i < $num)
	{
	$name = mysql_result($res,$i,"name");
	$x = mysql_result($res,$i,"x");
	$y = mysql_result($res,$i,"y");
	$z = mysql_result($res,$i,"z");
	
	echo '<tr>';
	echo '<td>'.$name.'</td>';
	echo '<td>'.$x.'</td>';
	echo '<td>'.$y.'</td>';
	echo '<td>'.$z.'</td>';
	echo '</tr>';
	
	
	$i++;
	}
	
	?>
	</table>
	</div>
		
	
	
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