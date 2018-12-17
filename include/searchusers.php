<?php
    $html_return = '';
    $avatar = '';
    $current_connect = $_SESSION['current_connect'];
    $ii = 0;
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
            $avatar_for = $row["gender"] == 1 ? 'images\\\\2Q==.jpg' : 'images\\\\9k=.jpg';
        else
            $avatar_for = $row["avatar_friend"];
        if ($ii == 0) $avatar = $avatar_for;
        $html_return .= '<div class="lbl search-result'.($current_connect == $row['friend_id'] ? ' active-msg' : '').'" draggable="true">
        <div class="avatar-img"><img class="img-search" src="'.$avatar_for.'"></div>
        <div id="user'.$row["friend_id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["display_name"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['sent_date'].'">'.$row['sent_time'].'</span></div>
        <div class="last-msg-row">';
        if ($uid == $row["last_sender_id"]) {
            $html_return .= '<span class="last-message'.$txt_unread.'">'.($row['message_type'] == 0 ? 'Bạn: ' : '').$msg.'</span>';
            switch ($row["msgstatus"]) {
                case 1:
                    $html_return .= '<span class="_2her reh" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                    break;
                case 2:
                    $html_return .= '<span class="_2her _9ah reh" title="Delivered"><i aria-label="Delivered" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                    break;
                case 3:
                    $html_return .= '<span class="me"><img class="_jf2 img" src="'.$row["avatar_friend"].'" /></span>';
                    break;
            }
        }
        else {
            $html_return .= '<span class="last-message'.$txt_unread.'">'.$msg.'</span>';
        }
        $html_return .= '
    </div>
</div>';
        $ii++;
    }
    return $html_return;
?>