<?php
        $sql = sprintf("call searchUsers(%u, %u)", $id, $l);
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount==0) {
            if ($l == 0)
                $html =  '<span style="color:#4ebf82;margin-left:10px;">Kh�ng t�m th?y k?t qu?</span>';
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
        <div id="user'.$row["id"].'" class="username-search" status="'.$row["usrstatus"].'"><span class="chatname'.$txt_unread.'">'.$row["alias"].'</span> <span class="me" style="color: '.($isunread ? '#0084ff' : '#0006').';" title="'.$row['date'].'">'.$row['time'].'</span></div>
        <div class="last-message'.$txt_unread.'">'.($id == $row["last_sender_id"] ? 'You: ' : '').$msg.'</div>
            </div>';
        }
?>