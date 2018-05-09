<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
	$last_id = -1;
    $sql = "call createConversion(".$uid.", ".$fid.")";	// ok
    $query = mysqli_query($con, $sql);
    // insert list users in conversion
    $sql = "call createConversionUsers(".$uid.", ".$fid.")"; // tạm thời chưa gọi được nhiều câu insert trong 1 store nên phải tách ra 2
    $query = mysqli_query($con, $sql);
    // insert message
    $sql = "call insertMessage(".$uid.", '".$message."', ".$fid.")";
	$query = mysqli_query($con, $sql);

    include('../include/index_loadmessage.php');
?>