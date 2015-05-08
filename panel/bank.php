<? error_reporting(0); session_start();
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
  <h1>Bank</h1>
    
    <?

    $nick = $_SESSION['login'];
    $query = "SELECT * FROM `users` WHERE `nick` = '$nick'";
    $res = mysql_query($query) or die(mysql_error());

    $uid = mysql_result($res,0,"id");

    $_SESSION['uid'] = $uid;

    $uidPlayer = $_SESSION['uid'];
    $query = "SELECT * FROM users WHERE id = $uidPlayer";
    $result = mysql_query($query) or die(mysql_error());

    $bankmoney = mysql_result($result,0,"bank");

    echo '<div class="boxer">Stan konta bankowego<br/><b>$'.$bankmoney.'.00</b><br/><br/>Typ konta bankowego<br/><b>PWT BANK</b></div>';
    echo '<div class="right"><div class="boxer">Witamy w twoim koncie bankowym!<br/><br/>UID twojego konta bankowego:<br/><b>'.$uidPlayer.'</b></div>';
    echo '<div class="right"><a href="bank.php"><div class="button">Strona Banku</div></a></div><br/>';
    echo '<div class="right"><a href="?action=newtransfer"><div class="button">Nowy Przelew</div></a></div>';


    echo '<br/><br/><br/><br/><br/>';


    if($_GET['action'] == 'newtransfer')
    {
      echo '<h1>Nowy Przelew</h1>';


      if(isset($_POST['buttonsubmit']))
      {
        

        if($_POST['money'] >= 100)
        {

          if($_POST['money'] > $bankmoney)
          {
          echo '<div class="error_box">Nie posiadasz odpowiedniej gotowki!</div>';
          }
          else
          {

          if($_POST['to'] >= 1)
          {
              $bankto = $_POST['to'];
              $query = "SELECT * FROM `users` WHERE `id` = '$bankto'";
              $res = mysql_query($query);

              if(mysql_num_rows($res) != 0)
              {
                $uidPlayer = $_SESSION['uid'];
                $bankto = $_POST['to'];
                $moneypay = $_POST['money'];
                $textpay = $_POST['textpay'];
                $query = "INSERT INTO `bank`(`uid`, `uidto`, `price`, `text`) VALUES ('$uidPlayer','$bankto','$moneypay','Przelew od $uidPlayer: $textpay')";
                mysql_query($query) or die(mysql_error());

                $query = "UPDATE `users` SET `bank` = `bank` + '$moneypay' WHERE `id` = '$bankto'";
                mysql_query($query) or die(mysql_error());


                $uidPlayer = $_SESSION['uid'];
                $query = "UPDATE `users` SET `bank` = `bank` - '$moneypay' WHERE `id` = '$uidPlayer'";
                mysql_query($query) or die(mysql_error());


                echo '<div class="ok_box">Przelew zostal wykonany pomyslnie do bankID '.$bankto.'!</div>';

              }
              else
              {
                echo '<br/><div class="error_box">Podany UID nie istnieje!</div><br/>';
              }
          }
          else
          {
            echo '<br/><div class="error_box">Podany UID jest niepoprawny!</div><br/>';
          }
          }

        }
        else
        {
          echo '<br/><div class="error_box">Minimalna kwota przelewu wynosi 100$!</div><br/>';
        }
      }


      echo '<form method="POST">';
      echo '<br/>';

      echo 'Kwota przelewu (w $ np. 699): <input name="money" class="textarena" type="text" pattern="([1-9])+(?:-?\d){0,}" title="Cyfry od 1-9" maxlength="7"/>';

      echo '<br/><br/>uID konta bankowego odbiorcy: <input name="to" class="textarena" type="text" pattern="([1-9])+(?:-?\d){0,}" title="Cyfry od 1-9" maxlength="7"/>';

      echo '<br/><br/>Nazwa przelewu: <input name="textpay" class="textarena" type="text" maxlength="30"/>';


      echo '<div class="right">
      <br/><input name="buttonsubmit" class="button" type="submit" value="Wyslij"/>
      </div>';
      echo '</form>';

      echo '<br/>';
    }


    echo '<br/><br/><h1>Przelewy</h1><br/>';

    echo '<div class="box">';

    $query = "SELECT * FROM `bank` WHERE `uid` = '$uidPlayer' OR `uidto` = '$uidPlayer' ORDER BY `id` DESC LIMIT 5";
    $result = mysql_query($query) or die(mysql_error());

    $num = mysql_num_rows($result);
    //echo $uidPlayer;
    $i=0;
    while($i < $num)
    {
      $uidd = mysql_result($result,$i,"uid");
       $to = mysql_result($result,$i,"uidto");
        $price = mysql_result($result,$i,"price");
         $text = mysql_result($result,$i,"text");

         $uidPlayer = $_SESSION['uid'];

      if($uidd == $_SESSION['uid'])
      {
        echo '<li><p color="red">Do uID '.$to.' -> '.$text.' <label>-$'.$price.'</p>';
      }
      //$uidPlayer = $_SESSION['uid'];
      //echo $uidPlayer;
      else if($to == $_SESSION['uid'])
      {
        echo '<li><p color="green">Od uID '.$uid.' -> '.$text.' <label>+$'.$price.'</p>';
      }

      $i++;
    }


    echo '</div>';


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