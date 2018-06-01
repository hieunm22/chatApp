<?php
	$query = $con->query("call openChat(".$uid." , ".$fid.")");
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
    $friendname = '';
    $mename = '';
    $display_fr = '';
    $display_me = '';
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
            case 3: $icon = '<span class="_4jzq _jf5"><img class="_jf2 img" alt="Seen by '.$row['alias'].' at 17:27" src="images/'.$fid.'.jpg" title="Seen by '.$row['alias'].' at 17:27"></span>';
                break;
        }
		if (($stt < 3 && $uid != $row['sender_id']) || $stt == 3)
			$icon = '<span class="_4jzq _jf5"><img class="_jf2 img" alt="Seen by '.$row['alias'].' at 17:27" src="images/'.$fid.'.jpg" title="Seen by '.$row['alias'].' at 17:27"></span>';
			
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
			$friendname = $row['alias'];
			$display_fr = $row['display_name'];
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
	$obj->mename = $mename;
	$obj->display_me = $display_me;
	$obj->display_fr = $display_fr;
    echo json_encode($obj);
?>