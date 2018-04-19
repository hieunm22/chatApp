<?php
    $sql = "call displayMessage(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $output = '';
    // while ($row = mysqli_fetch_array($query)) {
        // $classname = ($user_id == $row['sender_id'] ? 'user1' : 'user2');
        // $output .= '<div class="message-row"><span class="message-content '.$classname.'">'.$row["message_content"].'</span> <span class="tooltiptext message-time">'.$row['time'].'</span></div>';
    // }
    while ($row = mysqli_fetch_array($query)) {
		if ($user_id == $row['sender_id']) {
			$output .= '<div class="message-row"><span class="message-content user1">'.$row["message_content"].'</span> <span class="tooltiptext" style="float:right;">'.$row['time'].'</span></div>';
		}
		else {
			$output .= '<div class="message-row"><span class="message-content user2">'.$row["message_content"].'</span> <span class="tooltiptext" style="float:left;">'.$row['time'].'</span></div>';
		}
    }
    echo $output;
?>