<?php
    $sql = "call markAsRead(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $sql = "SELECT
    id,
    conversion_id,
    message_content,
    sender_id,
    NAME,
    alias,
    CASE  
    	WHEN datediff = 0 THEN date_format(time, '%H:%i') 
        WHEN datediff = 1 THEN date_format(time, 'Hôm qua, %H:%i')
        WHEN datediff < 7 and datediff > 1 THEN date_format(time, '%W %H:%i')
        WHEN yeardiff = 0 THEN date_format(time, '%d %M %H:%i')
        ELSE date_format(time, '%d %M %Y %H:%i')
	END as time,
    message_color
FROM
(    
    SELECT
            m.id,
            m.conversion_id,
            m.message_content,
            m.sender_id,
            m.time,
            DATEDIFF(NOW(), m.time) datediff,
            YEAR(m.time) - YEAR(now()) as yeardiff,
            u.name,
            u.alias,
            c.message_color
    from (        
        select m.* 
        from message m
        where conversion_id in (
            SELECT conversion_id
            FROM `conversion_users`
            group by conversion_id
            having (group_concat(user_id SEPARATOR '') = concat(".$user_id.", ".$friend_id.")) 
            OR (group_concat(user_id SEPARATOR '') = concat(".$friend_id.", ".$user_id.")) 
        )
    ) as m
    left JOIN users u on m.sender_id=u.id
    left JOIN conversion c on m.conversion_id=c.id
) as conv";
    // $sql = "call displayMessage(".$user_id." , ".$friend_id.")";
	$query = mysqli_query($con, $sql);
    $output = '';
    while ($row = mysqli_fetch_array($query)) {
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