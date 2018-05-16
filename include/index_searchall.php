<?php
        $sql = "call searchUsers(".$uid.", 0)";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        $html_search = '';
        while ($row = mysqli_fetch_array($query)) {
            $msg = $row['message_content'];
            if (strlen($msg) > 35) $msg = substr($msg, 0, 35).'...';
            // chỉ bôi đậm khi message status là đã nhận và người gửi cuối không phải là mình
            $isunread = $row["msgstatus"] == 2 && $uid != $row["last_sender_id"];
            if ($isunread) $unreadCount++;
            $txt_unread = $isunread ? ' unread-txt' : '';
            $html_search .= '<div class="lbl search-result" draggable="true">
        <div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["alias"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['date'].'">'.$row['time'].'</span></div>
        <div class="last-message'.$txt_unread.'">'.($uid == $row["last_sender_id"] ? 'You: ' : '').$msg.'</div>
            </div>';
        }
        echo $html_search;
?>