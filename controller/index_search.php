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
			echo '{ "html": "", "unread": 0 }';
            return;
        }
        while ($row = mysqli_fetch_array($query)) {
            $msg = $row['message_content'];
            if (strlen($msg) > 25) $msg = substr($msg, 0, 25).'...';
            // chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
            $isunread = $row["msgstatus"] == 2 && $id != $row["last_sender_id"];
            if ($isunread) $unreadCount++;
            $txt_unread = $isunread ? ' unread-txt' : '';
			$avatar = '';
			if ($row['avatar_url'] == null)
				$avatar = $row["gender"] == 1 ? 'images\\\\2Q==.jpg' : 'images\\\\9k=.jpg';
			else
				$avatar = $row["avatar_url"];
            $html .= '<div class="lbl search-result" draggable="true">
		<div class="avatar-img"><img class="img-search" src="'.$avatar.'"></div>
		<div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'">
			<span class="chatname'.$txt_unread.'">'.$row["display_name"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').'; margin-right: 17px;" title="'.$row['date'].'">'.$row['time'].'</span>
		</div>
        <div class="last-msg-row">
			';
			if ($id == $row["last_sender_id"]) {
				$html .= '<span class="last-message'.$txt_unread.'">You: '.$msg.'</span>';
				if ($row["msgstatus"] == 3) {
					$html .= '<span class="me" style="margin-right: 17px;"><img class="_jf2 img" src="'.$row["avatar_url"].'" /></span>';
				}
			}
			else {
				$html .= '<span class="last-message'.$txt_unread.'">'.$msg.'</span>';
			}
			$html .= '
		</div>
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