<?php
	include('../default.php');
	session_start();
	$con = initConnection();
	$uid = $_SESSION['user']['id'];
	$current_connect = $_SESSION['current_connect'];
    $unreadCount = 0;
    $search = '';
    $msg = '';
	$con->query("call markAsReceived($uid)");
	$sql = "call searchUsers($uid)";
	$query = mysqli_query($con, $sql);
	// $rowcount = $query->num_rows;
	// if ($rowcount==0) {
	// 	$search = '';
	// 	echo '{ "search": "", "unread": 0 }';
	// 	return;
	// }
	$search = (include '../include/searchusers.php');

	$search = str_replace("\"", "\\\"", $search);
	$search = str_replace("\r", "", $search);
	$search = str_replace("\n", "", $search);
	$search = str_replace("\t", "", $search);

	$fid = $current_connect;
	$load = (include '../include/index_openchatincl.php');
    echo '{ "search": "'.$search.'", "load": '.$load.', "unread": '.$unreadCount.' }';
?>