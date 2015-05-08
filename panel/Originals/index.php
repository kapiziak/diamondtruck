<?php
ob_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pl">
<head>
      <title>Strona serwera Minecraft </title>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2" />
<link rel="stylesheet" href="styles.php" type="text/css">
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
	<script type="text/javascript"> 
		$(function (){
			//facebook widget
			$(".facebook").toggle(function(){
				$(".facebook").stop(true, false).animate({right:"0"},"medium");
			},function(){
				$(".facebook").stop(true, false).animate({right:"-205"},"medium");
			},500);
		});
	</script> 
</head>
<body>

<?php
session_start();
require 'config.php';
require_once 'user.class.php';
?>
<?php
include("header.php");
?>
<br>

<div id="lini_menu">
	<div id="user_navigation">
	<b>
	<?php
	include("menu.php");
	?>
		<span class="right">
		<?php
if (user::isLogged()) {
    // Widok dla uşytkownika zalogowanego
    
    // Pobierz dane o uşytkowniku i zapisz je do zmiennej $user
    $user = user::getData('', '');
    
    echo '<a class="right">Witaj '.$user['login'].'!</a>';
    echo '<a href="dodaj.php">Dodaj newsa</a><a href="profile.php?id='.$user['id'].'">Profil</a><a href="logout.php" class="right">Wyloguj</a>';
}
else {
    // Widok dla uşytkownika niezalogowanego
    
}
?>

		</b>
		</span>
	</div>
</div>
<br>
<div id="wysrodkowanie">
<?php
include("notice.php");
?>
<br />
<?php
include("partnerzy.php");
?>
	<div id="wysrodkowanie_lewo">
<?php
include("config.php");
$query = mysql_query("select * from news order by id desc limit 0,5");
while($rekord = mysql_fetch_array($query))
{
echo '
<div id="content">
<h1>'.$rekord[1].'</h1><br/>
<p>'.$rekord[4].'</p><br /><br />
<autor>Napisa�: '.$rekord[3].'<br /> Data: '.$rekord[2].'</autor></div>';
}
?>
	</div>

<?php
include("sidebox.php");
?>
</div>

</body>
<?php
ob_end_flush();
?>