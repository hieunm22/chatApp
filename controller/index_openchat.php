<?php
    session_start();
    include('../default.php');
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['fid'];
    $cur = $_REQUEST['cur'];

	//$query = $con->query("call getFriendInfo(".$uid.", ".$fid.")");
	$query = $con->query("select u.*, cu.display_name 
	from conversion_users cu 
	inner join users u on cu.user_id = u.id
	where u.id=".$fid."
	and cu.conversion_id = getConversionID(".$uid.", ".$fid.")");
	$row = mysqli_fetch_array($query);
    $friendname = $row['alias'];
    $display_fr = $row['display_name'];
    $avatar_fr = $row['avatar_url'];	// bien luu avatar cua friend

	$query = $con->query("call openChat($uid , $fid, $cur)");
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
    $mename = '';
	$display_me = '';
	$previous_sid = -1;
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
				$check_sid = $previous_sid != $row['sender_id'];
				$message_content = $row["message_content"];
				$sent_time = $row['sent_time'];
				if ($uid == $row['sender_id']) {
					$mename = $row['alias'];
					$display_me = $row['display_name'];					
					$msgrow = "<div class=\"message-row\"><div class=\"message-content me\"><span class=\"msg-status\">$icon</span> <span class=\"user1\" style=\"background-color: #$color; border-color: #$color\">$message_content</span> <span class=\"tooltiptext me\">$sent_time</span></div></div>";
					setcookie('conversion_color', $color, time() + 86400, "/");
					// mình đã là người gửi thì message đó phải đánh dấu là đã đọc
					$readMsg .= $msgrow;
				}
				else {
					$msgrow = "<div class=\"message-row\"><div class=\"message-content friend\"><span class=\"msg-status\">$icon</span> ".($check_sid ? "<img class=\"avatar-friend\" src=\"$avatar_fr\" width=\"30px\" height=\"30px\" > <span class=\"user2\">$message_content</span>" : "<span class=\"user2 msg-no-avatar\">$message_content</span>")." <span class=\"tooltiptext friend\">$sent_time</span></div></div>";
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
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['sent_time'].'">Bạn đã đổi nicknames</div></div>';
				}
				else {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['sent_time'].'">'.$friendname.' đã đổi nicknames</div></div>';
				}
				break;
			case 2:
				if ($uid == $row['sender_id']) {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['sent_time'].'">Bạn đã đổi màu cuộc hội thoại</div></div>';
				}
				else {
					$readMsg .= '<div class="message-row"><div class="message-alert" title="'.$row['sent_time'].'">'.$friendname.' đã đổi màu cuộc hội thoại</div></div>';
				}
				break;
		}
		$previous_sid = $row['sender_id'];
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