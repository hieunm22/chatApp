<?php
    $html_return = '';
    $avatar_first = '';
    $current_connect = $_SESSION['current_connect'];

    while ($row = mysqli_fetch_array($query)) {
        switch ($row['message_type']) {
            case 0:
                $msg = $row['message_content'];
                if (strlen($msg) > 25) $msg = mb_substr($msg, 0, 25, "utf-8").'...';
                break;
            case 1:
                if ($uid == $row["last_sender_id"]) {
                    $msg = 'Bạn đã đổi nicknames';
                }
                else {
                    $msg = $row['display_name'].' đã đổi nicknames';
                }
                if (strlen($msg) > 32) $msg = mb_substr($msg, 0, 32, "utf-8").'...';
                break;
        }
        
        // chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
        $isunread = $row["msgstatus"] == 2 && $uid != $row["last_sender_id"];
        if ($isunread) $unreadCount++;
        $txt_unread = $isunread ? ' unread-txt' : '';
        if ($row['avatar_friend'] == null) 
            $avatar = $row["gender"] == 1 ? 'images\\\\2Q==.jpg' : 'images\\\\9k=.jpg';
        else
            $avatar = $row["avatar_friend"];
        $html_return .= '<div class="lbl search-result'.($current_connect == $row['friend_id'] ? ' active-msg' : '').'" draggable="true">
        <div class="avatar-img"><img class="img-search" src="'.($avatar).'"></div>
        <div id="user'.$row["friend_id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["display_name"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['sent_date'].'">'.$row['sent_time'].'</span></div>
        <div class="last-msg-row">';
        if ($uid == $row["last_sender_id"]) {
            $html_return .= '<span class="last-message'.$txt_unread.'">'.($row['message_type'] == 0 ? 'Bạn: ' : '').$msg.'</span>';
            if ($row["msgstatus"] == 3) {
                $html_return .= '<span class="me"><img class="_jf2 img" src="'.$row["avatar_friend"].'" /></span>';
            }
        }
        else {
            $html_return .= '<span class="last-message'.$txt_unread.'">'.$msg.'</span>';
        }
        $html_return .= '
    </div>
</div>';
    }
    return $html_return;
?>