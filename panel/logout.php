<?php session_start();
include('config.php');


$_SESSION['loggined'] = 0;


session_destroy();
header("Location: index.php");
?>