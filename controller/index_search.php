<?php
	include('../default.php');
	session_start();

    $t = $_REQUEST['t'];
    $t = str_replace("'","\\'",$t);
    // $pattern = '%'.$t.'%';
    $id = $_SESSION['user']['id'];

    $sql = "call searchUsers(".$id.", '".$t."')";
	$query = mysqli_query($con, $sql);
	$rowcount = mysqli_num_rows($query);
    if ($rowcount==0) {
        echo '<span style="color:#4ebf82;margin-left:10px;">Không tìm thấy kết quả</span>';
        return;
    }
	echo '<ol>';
	while ($row = mysqli_fetch_array($query)) {
		echo '<li><span class="lbl search-result"><a href="profile.php?id='.$row["user_id"].'" id="id'.$row["user_id"].'">'.$row["alias"].'</a></span> <span class="lbl search-chat"><a href="javascript:openChat('.$row['user_id'].')">Chat</a></span></li>';
	}
	echo '</ol>';
?>