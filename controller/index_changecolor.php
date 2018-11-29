<?php
	include('../default.php');
	session_start();

    $c = $_REQUEST['c'];    // color
    $sql = 'call setConversionColor('.$_SESSION['user']['id'].', '.$_REQUEST['fid'].', '.$c.')';
    $con->query($sql);
	setcookie('conversion_color', toColor($c), time() + 86400, "/");
    echo $_SESSION['user']['id'];
?>