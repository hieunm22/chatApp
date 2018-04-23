<?php
    $sql = "call displayMessage(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $output = '';
    while ($row = mysqli_fetch_array($query)) {
		if ($user_id == $row['sender_id']) {
			$output .= '<div class="message-row"><div class="message-content u1"><span class="user1">'.$row["message_content"].'</span> <span class="tooltiptext u1">'.$row['time'].'</span></div></div>';
		}
		else {
			$output .= '<div class="message-row"><div class="message-content u2"><span class="user2">'.$row["message_content"].'</span> <span class="tooltiptext u2">'.$row['time'].'</span></div></div>';
		}
    }
    echo $output;
?>