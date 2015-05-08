 <?php
if(!$_SESSION['access'] || !$_SESSION['login'])
{
    header('Location: index.php');
}
include('include/db.php');
if(isset($_POST['loginek']))
{
    if($_POST['loginek'] && $_POST['haslo'] && $_POST['send'])
    {
        $login = strip_tags(htmlspecialchars(mysql_real_escape_string($_POST['loginek'])));
        $haslo = strip_tags(htmlspecialchars(mysql_real_escape_string(md5(sha1($_POST['haslo'])))));
        $haslo1 = strip_tags(htmlspecialchars(mysql_real_escape_string(md5(sha1($_POST['haslo1']))))); 
        $haslo2 = strip_tags(htmlspecialchars(mysql_real_escape_string(md5(sha1($_POST['haslo2'])))));
        $email = strip_tags(htmlspecialchars(mysql_real_escape_string($_POST['email'])));
        $zapytanie = 'SELECT * FROM admin WHERE loginek="'.$login.'" and haslo="'.$haslo.'" LIMIT 1';
        $idzapytania = mysql_query($zapytanie) or die(mysql_error());
        $znajdz = mysql_fetch_array($idzapytania);
    }
}
if(!isset($_POST['loginek']) && empty($_POST['loginek']) && !isset($_POST['email']) && empty($_POST['email']) && !isset($_POST['haslo']) && empty($_POST['haslo']))
{
    echo '<form action="index.php?page=zmien_haslo&wpis=1" method="post">
    <input type="hidden" name="send" value="1">
    <br />Podaj login:<br />
    <input type="text" name="loginek" /><br /><br />
    Podaj email:<br />
    <input type="text" name="email" /><br /><br />
    Podaj hasło:<br />
    <input type="password" name="haslo" /><br /><br />
    <input name="dalej" type="submit" value="Dalej"><br /><br />
    </form><a style="text-decoration: none;" href="index.php?page=paneladmina">Wróć do Panelu Administratora</a><br /><br />';
}
else
{
    if(isset($_POST['loginek']) && !empty($_POST['loginek']) && !empty($_POST['email']) && !empty($_POST['email']) && !empty($_POST['haslo']) && !empty($_POST['haslo']))
    {
        echo '<form action="index.php?page=zmien_haslo&wpis=2" method="post"><br />
        <input type="hidden" name="send" value="2" />
        <input type="hidden" name="login" value="'.$login.'">
        <input type="hidden" name="haslo" value="'.$haslo2.'">
        Podaj stare hasło<br />
        <input type="password" name="haslo" />
        <br /><br />Podaj nowe hasło<br />
        <input type="password" name="haslo1" />
        <br /><br />Powtórz nowe hasło<br />
        <input type="password" name="haslo2" /><br /><br />
        <input name="zapisz" type="submit" value="Zapisz" /></form><br />
        <a style="text-decoration: none;" href="index.php?page=paneladmina">Wróć do Panelu Administratora</a><br /><br />';
    }
}
if(isset($_POST['zapisz']) && !empty($_POST['zapisz']))
{
    $login = mysql_real_escape_string($_POST['login']);
    $haslo2 = strip_tags(htmlspecialchars(mysql_real_escape_string(md5(sha1($_POST['haslo2'])))));
    $zapytanie1 = 'UPDATE `admin` SET `haslo`= "'.$haslo2.'" WHERE `loginek`="'.$login.'"';
    $idzapytania1 = mysql_query($zapytanie1) or die(mysql_error());
}
if(isset($_POST['send']))
{
    if($_POST['send'])
    {
        if(isset($idzapytania1))
        {
            if($idzapytania1 === TRUE)
            {
                echo '<form action="index.php?page=zmien_haslo&wpis=2" method="post"><br />
                <input type="hidden" name="send" value="2" />
                <input type="hidden" name="login" value="'.$login.'">
                <input type="hidden" name="haslo" value="'.$haslo2.'">
                Podaj stare hasło<br />
                <input type="password" name="haslo" />
                <br /><br />Podaj nowe hasło<br />
                <input type="password" name="haslo1" />
                <br /><br />Powtórz nowe hasło<br />
                <input type="password" name="haslo2" /><br /><br />
                <input name="zapisz" type="submit" value="Zapisz" /></form><br />
                <a style="text-decoration: none;" href="index.php?page=paneladmina">Wróć do Panelu Administratora</a><br /><br />';
                echo '<font color="green"><strong>Hasło zostało zmienione.</strong></font><br /><br />';
            }
            else
            {
                echo '<form action="index.php?page=zmien_haslo&wpis=2" method="post"><br />
                <input type="hidden" name="send" value="2" />
                <input type="hidden" name="login" value="'.$login.'">
                <input type="hidden" name="haslo" value="'.$haslo2.'">
                Podaj stare hasło<br />
                <input type="password" name="haslo" />
                <br /><br />Podaj nowe hasło<br />
                <input type="password" name="haslo1" />
                <br /><br />Powtórz nowe hasło<br />
                <input type="password" name="haslo2" /><br /><br />
                <input name="zapisz" type="submit" value="Zapisz" /></form><br />
                <a style="text-decoration: none;" href="index.php?page=paneladmina">Wróć do Panelu Administratora</a><br /><br />';
                echo '<font color="red"><strong>Nie udało się zmienić hasła. Proszę spróbować za jakiś czas!</strong></font><br /><br />';
            }
        }
    }
}
mysql_close($connect);
?> 