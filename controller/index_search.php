<?php
	include('../default.php');
	session_start();

    $t = $_REQUEST['t'];
    $t = str_replace("'","\\'",$t);
    // $pattern = '%'.$t.'%';
    $uid = $_SESSION['user']['id'];  // 1
    $unreadCount = 0;
    $html = '';
    $msg = '';
    if (trim($t)==='') {
        $con->query("call markAsReceived($uid)");
        $sql = "call searchUsers($uid)";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount==0) {
            $html = '';
			echo '{ "html": "", "unread": 0 }';
            return;
        }
        $html = (include '../include/searchusers.php');
    }
    else {
        $sql = "call searchUsersText('$t', $uid)";
        $query = mysqli_query($con, $sql);
        while ($row = mysqli_fetch_array($query)) {
            $html .= '<div class="lbl search-result-text" draggable="true">
        <div id="user'.$row["friend_id"].'" class="username-search" status="'.$row["status"].'"><span><img src="'.$row["avatar_url"].'" class="avatar-search-text" /></span><span class="chatname">'.$row["alias"].'</span></div>
            </div>';
        }
    }
	$obj = new stdClass();
	$html = str_replace("\"", "\\\"", $html);
	$html = str_replace("\r", "", $html);
	$html = str_replace("\n", "", $html);
	$html = str_replace("\t", "", $html);
	$obj->html = $html;
	$obj->unread = $unreadCount;
	// echo json_encode($obj);
    echo '{ "html": "'.$html.'", "unread": '.$unreadCount.' }';
?>