<?php
    // $sql = "call markAsRead(".$uid." , ".$fid.")";
    // $con->query($sql);
	// $query = mysqli_query($con, $sql);
    $sql = "call displayMessage(".$uid." , ".$fid.", ".$stt.")";
	$query = mysqli_query($con, $sql);
    $output = '';
    while ($row = mysqli_fetch_array($query)) {
		if ($uid == $row['sender_id']) {
            $color = toColor($row["message_color"]);
			$output .= sprintf('<div class="message-row"><div class="message-content me"><span class="user1" style="background-color: #%s; border-color: #%s">%s</span> <span class="tooltiptext me">%s</span></div></div>', $color, $color, $row["message_content"], $row['time']);
            setcookie('conversion_color', $color, time() + 86400, "/");
		}
		else {
			$output .= sprintf('<div class="message-row"><div class="message-content friend"><span class="user2">%s</span> <span class="tooltiptext friend">%s</span></div></div>', $row["message_content"], $row['time']);
		}
    }
    echo $output;
?>