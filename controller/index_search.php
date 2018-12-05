<?php
	include('../default.php');
	session_start();

    $t = $_REQUEST['t'];
    $t = str_replace("'","\\'",$t);
    // $pattern = '%'.$t.'%';
    $uid = $_SESSION['user']['id'];  // 1
    $unreadCount = 0;
    $search = '';
    $msg = '';
    $con = initConnection();
    if (trim($t)==='') {
        $con->query("call markAsReceived($uid)");
        $sql = "call searchUsers($uid)";
        $query = mysqli_query($con, $sql);
        $rowcount = $query->num_rows;
        if ($rowcount==0) {
            $search = '';
			echo '{ "search": "", "unread": 0 }';
            return;
        }
        $search = (include '../include/searchusers.php');
    }
    else {
        $sql = "call searchUsersText('$t', $uid)";
        $query = mysqli_query($con, $sql);
        while ($row = mysqli_fetch_array($query)) {
            $search .= '<div class="lbl search-result-text" draggable="true">
        <div id="user'.$row["friend_id"].'" class="username-search" status="'.$row["status"].'"><span><img src="'.$row["avatar_url"].'" class="avatar-search-text" /></span><span class="chatname">'.$row["alias"].'</span></div>
            </div>';
        }
    }
	$obj = new stdClass();
	$search = str_replace("\"", "\\\"", $search);
	$search = str_replace("\r", "", $search);
	$search = str_replace("\n", "", $search);
	$search = str_replace("\t", "", $search);
	$obj->search = $search;
	$obj->unread = $unreadCount;
	// echo json_encode($obj);
    echo '{ "search": "'.$search.'", "unread": '.$unreadCount.' }';
?>