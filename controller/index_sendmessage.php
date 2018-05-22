<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
	$last_id = -1;
    $con->query("call sendMessage(".$uid.", ".$fid.", '".$message."')");

    // include('../include/index_loadmessage.php');
    include('../include/index_searchall.php');
?>