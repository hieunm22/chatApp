<?php
	include('../default.php');
	session_start();

    $t = $_REQUEST['t'];
    $t = str_replace("'","\\'",$t);
    // $pattern = '%'.$t.'%';
    $id = $_SESSION['user']['id'];

    $l = $_REQUEST['l'];    // limit
    $unreadCount = 0;
    $html = '';
    
    if (trim($t)==='') {
        $con->query("call markAsReceived($id)");
        $sql = sprintf("call searchUsers(%u, %u)", $id, $l);
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount==0) {
            if ($l == 0)
                $html =  '<span style="color:#4ebf82;margin-left:10px;">Không tìm thấy kết quả</span>';
            else
                $html = '';
            return;
        }
        while ($row = mysqli_fetch_array($query)) {
            $msg = $row['message_content'];
            if (strlen($msg) > 35) $msg = substr($msg, 0, 35).'...';
            // chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
            $isunread = $row["msgstatus"] == 2 && $id != $row["last_sender_id"];
            if ($isunread) $unreadCount++;
            $txt_unread = $isunread ? ' unread-txt' : '';
            $html .= '<div class="lbl search-result" draggable="true">
		<div class="avatar-img"><img src="images\\\\'.($row["gender"] == 1 ? '2Q==.jpg' : '9k=.jpg').'" style="width: 50px; height: 50px;"></div>
        <div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["display_name"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').'; margin-right: 17px;" title="'.$row['date'].'">'.$row['time'].'</span></div>
        <div class="last-message'.$txt_unread.'">'.($id == $row["last_sender_id"] ? 'You: ' : '').$msg.'</div>
            </div>';
        }
    }
    else {
        $sql = sprintf("call searchUsersText('%s')", $t);
        $query = mysqli_query($con, $sql);
        while ($row = mysqli_fetch_array($query)) {
            $html .= '<div class="lbl search-result-text" draggable="true">
        <div id="user'.$row["id"].'" class="username-search"><span class="chatname">'.$row["alias"].'</span></div>
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