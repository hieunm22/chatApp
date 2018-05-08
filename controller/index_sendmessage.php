<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
	$last_id = -1;
    $sql = "call createConversion(".$uid.", ".$fid.")";	// ok
    $query = mysqli_query($con, $sql);
    // insert list users in conversion
    $sql = "insert into conversion_users(conversion_id, user_id)
select * from
(
	SELECT max(`id`), ".$uid." as user_id from conversion
	union
	SELECT max(`id`), ".$fid." as user_id from conversion
) as tmp
where not exists (
    SELECT 1
    FROM conversion_users
    where user_id in (".$uid.", ".$fid.")
    group by `conversion_id`
    having count(`user_id`)=2
)"; // tạm thời chưa gọi được nhiều câu insert trong 1 store nên phải tách ra 2
    $query = mysqli_query($con, $sql);
    // insert message
    $sql = "call insertMessage(".$uid.", '".$message."', ".$fid.")";
	$query = mysqli_query($con, $sql);

    include('../include/index_loadmessage.php');
?>