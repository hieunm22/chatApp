<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
    // $sql = "call createConversion(".$uid.", ".$fid.")";	// stored procedure chạy không đúng
    $sql = "INSERT INTO `conversion`(`user1_id`, `user2_id`) 
SELECT * FROM (SELECT ".$uid.", ".$fid.") AS tmp
WHERE NOT EXISTS (
    SELECT * FROM conversion WHERE list_users = concat(".$uid.",',',".$fid.") or list_users = concat(".$fid.",',',".$uid.")
) LIMIT 1";
    $query = mysqli_query($con, $sql);
    // insert message
    $sql = "call insertMessage(".$uid.", '".$message."', ".$fid.")";
	$query = mysqli_query($con, $sql);
    
    include('../include/index_loadmessage.php');
?>