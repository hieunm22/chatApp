<?php
	include('../default.php');
	session_start();
	
    $fid = $_REQUEST['fid'];
    $nick1 = $_REQUEST['nick1'];
    $nick2 = $_REQUEST['nick2'];
    $con->query("call setNickNames(".$_SESSION['user']['id'].", ".$fid.", '".$nick1."', '".$nick2."')");
    // echo "call setNickNames(".$_SESSION['user']['id'].", ".$fid.", '".$nick1."', '".$nick2."')";
?>