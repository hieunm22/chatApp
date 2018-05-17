<?php
    $con->query("call markAsRead(".$uid.", ".$fid.")");
    $sql = "call displayMessage(".$uid." , ".$fid.")";
	$query = $con->query($sql);
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
    while ($row = mysqli_fetch_array($query)) {
		if ($uid == $row['sender_id']) {
            $color = toColor($row["message_color"]);
			$msgrow = sprintf('<div class="message-row"><div class="message-content me"><span class="msg-status">'.$row['status'].'</span> <span class="user1" style="background-color: #%s; border-color: #%s">%s</span> <span class="tooltiptext me">%s</span></div></div>', $color, $color, $row["message_content"], $row['time']);
            setcookie('conversion_color', $color, time() + 86400, "/");
			// mình đã là người gửi thì message đó phải đánh dấu là đã đọc
			$readMsg .= $msgrow;
		}
		else {
			$msgrow = sprintf('<div class="message-row"><div class="message-content friend"><span class="user2">%s</span> <span class="tooltiptext friend">%s</span></div></div>', $row["message_content"], $row['time']);
			if ($row['status'] == 3)
				$readMsg .= $msgrow;
			else
				$unreadMsg .= $msgrow;
		}
    }
	$obj = new stdClass();
	$obj->readMsg = $readMsg;
	$obj->unreadMsg = $unreadMsg;
    echo json_encode($obj);
?>