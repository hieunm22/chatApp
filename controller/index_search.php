<?php
	include('../default.php');
	session_start();

    $t = $_REQUEST['t'];
    $t = str_replace("'","\\'",$t);
    // $pattern = '%'.$t.'%';
    $id = $_SESSION['user']['id'];

    $sql = sprintf("call searchUsers(%u)", $id);
	$query = mysqli_query($con, $sql);
	$rowcount = mysqli_num_rows($query);
    if ($rowcount==0) {
        echo '<span style="color:#4ebf82;margin-left:10px;">Không tìm thấy kết quả</span>';
        return;
    }
	while ($row = mysqli_fetch_array($query)) {
		$msg = $row['message_content'];
		if (strlen($msg) > 45) $msg = substr($msg, 0, 45).'...';
		echo sprintf('<div class="lbl search-result" draggable="true">
	<div id="user%u" class="username-search"><span class="chatname">%s</span> <span class="u1" style="color: #0006;" title="%s">%s</span></div>
	<div>%s%s</div>
		</div>', $row["id"], $row["alias"], $row['date'], $row['time'], ($id == $row["last_sender_id"] ? 'You: ' : ''), $msg);
	}
?>