<?php
    $con->query("call markAsRead(".$uid.", ".$fid.")");
	$query = $con->query("call displayMessage(".$uid." , ".$fid.")");
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
    $friendname = '';
    while ($row = mysqli_fetch_array($query)) {
        $color = toColor($row["message_color"]);
        $stt = $row['status'];
        $icon = '';
        switch ($stt) {
            case 0: $icon = '<span class="_2her" style="color:#'.$color.'" title="Sending"></span>';
                break;
            case 1: $icon = '<span class="_2her" style="color:#'.$color.'" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                break;
            case 2: $icon = '<span class="_2her _9ah" style="color:#'.$color.'" title="Delivered"><i aria-label="Delivered" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                break;
            // case 3: $icon = '<span class="_2her _9ah" style="color:#'.$color.'" title="Seen"></span>';
                // break;
        }
		if ($uid == $row['sender_id']) {
			$msgrow = sprintf('<div class="message-row"><div class="message-content me"><span class="msg-status">%s</span> <span class="user1" style="background-color: #%s; border-color: #%s">%s</span> <span class="tooltiptext me">%s</span></div></div>', $icon, $color, $color, $row["message_content"], $row['time']);
            setcookie('conversion_color', $color, time() + 86400, "/");
			// mình đã là người gửi thì message đó phải đánh dấu là đã đọc
			$readMsg .= $msgrow;
		}
		else {
			$msgrow = sprintf('<div class="message-row"><div class="message-content friend"><span class="user2">%s</span> <span class="tooltiptext friend">%s</span></div></div>', $row["message_content"], $row['time']);
			$friendname = $row['alias'];
			// $readMsg .= $msgrow;
			// tạm thời bỏ
			if ($row['status'] == 3)
				$readMsg .= $msgrow;
			else
				$unreadMsg .= $msgrow;
		}
    }
	$obj = new stdClass();
	$obj->readMsg = $readMsg;
	$obj->unreadMsg = $unreadMsg;
	$obj->friendname = $friendname;
    echo json_encode($obj);
?>