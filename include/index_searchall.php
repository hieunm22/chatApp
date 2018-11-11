<?php
        $id = $_SESSION['user']['id'];
        $sql = "call searchUsers(".$uid.", 0)";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        $unreadCount = 0;

		$row = mysqli_fetch_array($query);
		$msg = $row['message_content'];
		if (strlen($msg) > 35) $msg = mb_substr($msg, 0, 35, "utf-8").'...';
		// chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
		$isunread = $row["msgstatus"] == 2 && $uid != $row["last_sender_id"];
		if ($isunread) $unreadCount++;
		$txt_unread = $isunread ? ' unread-txt' : '';
		$avatar = '';
		if ($row['avatar_url'] == null) 
			$avatar = $row["gender"] == 1 ? 'images\\\\2Q==.jpg' : 'images\\\\9k=.jpg';
		else
			$avatar = $row["avatar_url"];
        // khi send message thì conversion với friend đó sẽ lên đầu -> focus vào conversion đó luôn
		echo '<div class="lbl search-result active-msg" draggable="true">
		<div class="avatar-img"><img class="img-search" src="'.($avatar).'"></div>
        <div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["alias"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['date'].'">'.$row['time'].'</span></div>
        <div class="last-msg-row"><div class="last-message'.$txt_unread.'">'.($uid == $row["last_sender_id"] ? 'You: ' : '').$msg.'</div></div>
            </div>';

        while ($row = mysqli_fetch_array($query)) {
            switch ($row['message_type']) {
                case 0:
                    $msg = $row['message_content'];
                    if (strlen($msg) > 25) $msg = mb_substr($msg, 0, 25, "utf-8").'...';
                    break;
                case 1:
                    if ($id == $row["last_sender_id"]) {
                        $msg = 'You changed the nicknames';
                    }
                    else {
                        $msg = $row['display_name'].' changed the nicknames';
                    }
                    if (strlen($msg) > 32) $msg = mb_substr($msg, 0, 32, "utf-8").'...';
                    break;
            }
            
            // chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
            $isunread = $row["msgstatus"] == 2 && $uid != $row["last_sender_id"];
            if ($isunread) $unreadCount++;
            $txt_unread = $isunread ? ' unread-txt' : '';
            if ($row['avatar_url'] == null) 
                $avatar = $row["gender"] == 1 ? 'images\\\\2Q==.jpg' : 'images\\\\9k=.jpg';
            else
                $avatar = $row["avatar_url"];
            echo '<div class="lbl search-result" draggable="true">
            <div class="avatar-img"><img class="img-search" src="'.($avatar).'"></div>
            <div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["alias"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['date'].'">'.$row['time'].'</span></div>
            <div class="last-msg-row"><div class="last-message'.$txt_unread.'">'.($uid == $row["last_sender_id"] ? 'You: ' : '').$msg.'</div></div>
                </div>';
        }
?>