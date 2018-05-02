<?php
    $sql = "call markAsRead(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $sql = "call displayMessage(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $output = '';
    while ($row = mysqli_fetch_array($query)) {
        // echo row["message_color"];
		if ($user_id == $row['sender_id']) {
            $color = toColor($row["message_color"]);
			$output .= sprintf('<div class="message-row"><div class="message-content u1"><span class="user1" style="background-color: #%s; border-color: #%s">%s</span> <span class="tooltiptext u1">%s</span></div></div>', $color, $color, $row["message_content"], $row['time']);
            setcookie('conversion_color', $color, time() + 86400, "/");
		}
		else {
			$output .= sprintf('<div class="message-row"><div class="message-content u2"><span class="user2">%s</span> <span class="tooltiptext u2">%s</span></div></div>', $row["message_content"], $row['time']);
		}
    }
    echo $output;
?>