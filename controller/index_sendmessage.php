<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
	$last_id = -1;
    $con->query("call createConversion(".$uid.", ".$fid.")");
    // insert list users in conversion
    $con->query("call createConversionUsers(".$uid.", ".$fid.")");  // tạm thời chưa gọi được nhiều câu insert trong 1 store nên phải tách ra 2
    // insert message
	$con->query("call insertMessage(".$uid.", '".$message."', ".$fid.")");

    // include('../include/index_loadmessage.php');
    include('../include/index_searchall.php');
?>