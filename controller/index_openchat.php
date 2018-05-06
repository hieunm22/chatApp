<?php
    session_start();
    include('../default.php');
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['id'];
	
    include('../include/index_loadmessage.php');
?>