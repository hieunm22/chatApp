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
	while ($row = mysqli_fetch_array($query)) {
		echo '<div class="lbl search-result">
	<div id="user'.$row["id"].'">'.$row["alias"].'</div>
	<div>'.$row['message_content'].'</div>
		</div>';
	}
?>