<?php
	$query = $con->query("select u.*, cu.display_name from users u inner join conversion_users cu on u.id=cu.user_id where u.id=".$fid);
	$row = mysqli_fetch_array($query);
    $friendname = $row['alias'];
    $display_fr = $row['display_name'];
    $avatar_fr = $row['avatar_url'];	// bien luu avatar cua friend

	$query = $con->query("call openChat(".$uid." , ".$fid.")");
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
    $mename = '';
    $display_me = '';
    while ($row = mysqli_fetch_array($query)) {
		$message_type = $row['message_type'];
        $color = toColor($row["message_color"]);
        $stt = $row['status'];
        $rdt = $row['read_time'];
        $icon = '';

        switch ($stt) {
            case 0: $icon = '<span class="_2her" style="color:#'.$color.'" title="Sending"></span>';
                break;
            case 1: $icon = '<span class="_2her" style="color:#'.$color.'" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                break;
            case 2: $icon = '<span class="_2her _9ah" style="color:#'.$color.'" title="Delivered"><i aria-label="Delivered" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>';
                break;
        }
		if (($stt < 3 && $uid != $row['sender_id']) || $stt == 3)
			$icon = '<span class="_4jzq _jf5"><img class="_jf2 img" alt="Seen by '.$friendname.' at 17:27" src="'.$avatar_fr.'" title="Seen by '.$friendname.' at '.$rdt.'"></span>';
		switch ($message_type) {
			case 0:
				if ($uid == $row['sender_id']) {
					$mename = $row['alias'];
					$display_me = $row['display_name'];
					$msgrow = sprintf('<div class="message-row"><div class="message-content me"><span class="msg-status">%s</span> <span class="user1" style="background-color: #%s; border-color: #%s">%s</span> <span class="tooltiptext me">%s</span></div></div>', $icon, $color, $color, $row["message_content"], $row['time']);
					setcookie('conversion_color', $color, time() + 86400, "/");
					// mình đã là người gửi thì message đó phải đánh dấu là đã đọc
					$readMsg .= $msgrow;
				}
				else {
					$msgrow = sprintf('<div class="message-row"><div class="message-content friend"><span class="msg-status">%s</span> <span class="user2">%s</span> <span class="tooltiptext friend">%s</span></div></div>', $icon, $row["message_content"], $row['time']);
					// $readMsg .= $msgrow;
					// tạm thời bỏ
					if ($row['status'] == 3)
						$readMsg .= $msgrow;
					else
						$unreadMsg .= $msgrow;
				}
				break;
			case 1:
				if ($uid == $row['sender_id']) {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['time'].'">You changed the nicknames</div></div>';
				}
				else {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['time'].'">'.$friendname.' changed the nicknames</div></div>';
				}
				break;
			case 2:
				if ($uid == $row['sender_id']) {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['time'].'">You changed the chat colours</div></div>';
				}
				else {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['time'].'">'.$friendname.' changed the chat colours</div></div>';
				}
				break;
		}
    }
	$obj = new stdClass();
	$obj->readMsg = $readMsg;
	$obj->unreadMsg = $unreadMsg;
	$obj->friendname = $friendname;
	$obj->mename = $mename;
	$obj->display_me = $display_me;
	$obj->display_fr = $display_fr;
    echo json_encode($obj);
?>