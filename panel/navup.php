<? session_start();

if($_SESSION['loggined'] != 1)
{
?>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<a href="login.php">> Logowanie</a>
<?
}
else
{
?>
<!--<marquee onmouseout="This:start()" onmouseover="This:stop()" behavior="alternate">Hehe
</marquee>!-->

<li><a href="search.php">> Znajdz gracza</a><a href="logout.php"> > Wyloguj sie</a>
</div>

<?
}
?>

