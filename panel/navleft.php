<h1>INFORMACJE</h1>
<a href="index.php"><div class="menu"><img src="news.png">AKTUALNOSCI</div></a>
<div class="menu"><a href="http://forum.pwtruck.pl"><img src="forum.png">FORUM</a></div>
<div class="menu"><a href="cargos.php"><img src="towary.png">TOWARY</a></div>
<div class="menu"><a href="faq.php"><img src="faq.png">FAQ</a></div>
<div class="menu"><a href="server.php"><img src="ss.png">STATUS SERWERA</a></div>
<div class="menu"><a href="top.php"><img src="top15.png">TOP 15</a></div>
<? if($_SESSION['loggined'] == 1)
{
?>
<br/>
<h1>KONTO</h1>
<div class="menu"><a href="panel.php"><img src="user.png">POSTAC</a></div>
<div class="menu"><a href="bank.php"><img src="vip.png">BANK NARODOWY</a></div>
<div class="menu"><a href="vehicles.php"><img src="car.png">POJAZDY</a></div>
<div class="menu"><a href="houses.php"><img src="domki.png">PRYWATNE DOMY</a></div>
<div class="menu"><a href="premium.php"><img src="vip.png">STREFA PREMIUM</a></div>
<div class="menu"><a href="company.php"><img src="firmy.png">RYNEK PRACY</a></div>
<div class="menu"><a href="logout.php"><img src="loguot.png">WYLOGUJ SIE</a></div>
<!--
<ul id="menu">
<li><a href="" title="">Informacje</a> 
 
<ul> 
 
<li><a href="" title="">O mnie</a></li> 
 
<li><a href="" title="">Aktualności</a></li> 
 
</ul>

</ul> 
!-->

<?

}
?>
<br/>
<h1>Znajdz Nas!</h1>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</i></a><a href="http://www.youtube.com/channel/UCUwwgidZ3R9kiJXyyb1r3yA"><img src="youtube.png"></a>&nbsp<a href="http://facebook.com/polishcompanytruck"><img src="facebook.png"></a>
<?

if($_SESSION['leveladmin'] >= 1 && $_SESSION['loggined'] == 1)
{
?>
<br/>
<h1>ADMINISTRACJA</h1>
<div class="menu"><a href="acp.php">>ACP</a></div>


<?
}

	function time_elapsed_string($datetime, $full = false) 
	{
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $diff->w = floor($diff->d / 7);
    $diff->d -= $diff->w * 7;

    $string = array(
        'y' => 'lata',
        'm' => 'miesiecy',
        'w' => 'tygodni',
        'd' => 'dni',
        'h' => 'godzin',
        'i' => 'minut',
        's' => 'sekund',
    );
    foreach ($string as $k => &$v) {
        if ($diff->$k) {
            $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? '' : '');
        } else {
            unset($string[$k]);
        }
    }

    if (!$full) $string = array_slice($string, 0, 1);
    return $string ? implode(', ', $string) . ' temu' : 'Brak Logowania';
	}
	
	
	function time_elapsed_string_za_ile($datetime, $full = false) 
	{
    $now = new DateTime;
    $ago = new DateTime($datetime);
    $diff = $now->diff($ago);

    $diff->w = floor($diff->d / 7);
    $diff->d -= $diff->w * 7;

    $string = array(
        'y' => 'lata',
        'm' => 'miesiecy',
        'w' => 'tygodni',
        'd' => 'dni',
        'h' => 'godzin',
        'i' => 'minut',
        's' => 'sekund',
    );
    foreach ($string as $k => &$v) {
        if ($diff->$k) {
            $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? '' : '');
        } else {
            unset($string[$k]);
        }
    }

    if (!$full) $string = array_slice($string, 0, 1);
    return $string ? implode(', ', $string) . '.' : 'Brak Daty';
	}
	
	function CheckTeamName($teamid)
	{
	$string = "Bezrobotny";
	$queryt = "SELECT * FROM `company` WHERE `id` = '$teamid'";
	$rest = mysql_query($queryt);
	
	$numt = mysql_num_rows($rest);
	
	if($numt >= 1)
	{
	$string = mysql_result($rest,0,"name");
	}
	
	return $string;
	}


	
	function CheckCargoName($cargo)
	{
	$string = "Nie Znaleziono";
	$queryta = "SELECT * FROM `cargos` WHERE `id` = '$cargo'";
	$resta = mysql_query($queryta);
	
	$numt = mysql_num_rows($resta);
	
	if($numt >= 1)
	{
	$string = mysql_result($resta,0,"name");
	}
	
	return $string;
	}
