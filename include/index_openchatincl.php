<?php
	//$query = $con->query("call getFriendInfo(".$uid.", ".$fid.")");

	if ($fid == null) {
		return 'false';
	}

	$con = initConnection();
	$query = mysqli_query($con, "select u.*, cu.display_name 
	from conversion_users cu 
	inner join users u on cu.user_id = u.id
	where u.id=".$fid."
	and cu.conversion_id = getConversionID($uid, $fid)");
	// chưa có conversion giữa 2 người dùng này thì set mặc định cho các field object rồi return
	if ($query->num_rows == 0) {
		$con = initConnection();
		$query = mysqli_query($con, "select alias from users where id=$fid");
		$row = mysqli_fetch_array($query);
		$obj = new stdClass();
		$obj->fid = $fid;
		$obj->readMsg = "";
		$obj->conversion_color = "0084ff";
		$obj->unreadMsg = "";
		$obj->mename = $_SESSION['user']['alias'];
		$obj->display_me = $_SESSION['user']['alias'];
		$obj->friendname = $row['alias'];
		$obj->display_fr = $row['alias'];
		return json_encode($obj);
	}
	$row = mysqli_fetch_array($query);
    $friendname = $row['alias'];
    $display_fr = $row['display_name'];
    $avatar_fr = $row['avatar_url'];	// bien luu avatar cua friend

	// $con = initConnection();
	$query = mysqli_query($con, "select u.*, cu.display_name 
	from conversion_users cu 
	inner join users u on cu.user_id = u.id
	where u.id=".$uid."
	and cu.conversion_id = getConversionID($uid, $fid)");
	$row = mysqli_fetch_array($query);
	$mename = $row['alias'];
    $display_me = $row['display_name'];

	$_SESSION['current_connect'] = $fid;
	$con = initConnection();
	$query = mysqli_query($con, "call openChat($uid , $fid)");
    $msgrow = '';
    $readMsg = '';
    $unreadMsg = '';
	$color = '';
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
				$message_content = $row["message_content"];
				$sent_time = $row['sent_time'];
				if ($uid == $row['sender_id']) {				
					$msgrow = "<div class=\"message-row\"><div class=\"message-content me\"><span class=\"msg-status\">$icon</span> <span class=\"user1\" style=\"background-color: #$color; border-color: #$color\">$message_content</span> <span class=\"tooltiptext me\">$sent_time</span></div></div>";
					// mình đã là người gửi thì message đó phải đánh dấu là đã đọc
					$readMsg .= $msgrow;
				}
				else {
					$msgrow = "<div class=\"message-row\"><div class=\"message-content friend\"><span class=\"msg-status\">$icon</span> <img class=\"avatar-friend\" src=\"$avatar_fr\" width=\"30px\" height=\"30px\" > <span class=\"user2\">$message_content</span> <span class=\"tooltiptext friend\">$sent_time</span></div></div>";
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
    }
	$obj = new stdClass();
	$obj->fid = $fid;
	$obj->readMsg = $readMsg;
	$obj->conversion_color = $color;
	$obj->unreadMsg = $unreadMsg;
	$obj->friendname = $friendname;
	$obj->mename = $mename;
	$obj->display_me = $display_me;
	$obj->display_fr = $display_fr;
    return json_encode($obj);
?>