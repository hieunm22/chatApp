<?php
    include('../default.php');
    session_start();
    $user_id = $_SESSION['user']['id'];
    $friend_id = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
    // $sql = "call createConversion(".$user_id.", ".$friend_id.")";	// stored procedure chạy không đúng
    $sql = "INSERT INTO `conversion`(`user1_id`, `user2_id`) 
SELECT * FROM (SELECT ".$user_id.", ".$friend_id.") AS tmp
WHERE NOT EXISTS (
    SELECT * FROM conversion WHERE (user1_id=".$user_id." AND user2_id=".$friend_id.") or (user1_id=".$friend_id." AND user2_id=".$user_id.")
) LIMIT 1";
    $query = mysqli_query($con, $sql);
    // insert message
    $sql = "call insertMessage(".$user_id.", '".$message."', ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    
    include('../include/index_loadmessage.php');
?>