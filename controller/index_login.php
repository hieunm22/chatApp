<?php
    include('../default.php');
    session_start();
    
    $usr = $_REQUEST['u'];
    $usr = str_replace("'","\\'",$usr);
    $pwd = $_REQUEST['p'];
    $pwd = str_replace("'","\\'",$pwd);
    $sql = "SELECT * FROM users where (`name` like '%".$usr."%' or `email` like '%".$usr."%' or `phone`='".$usr."') and `password`='".md5($pwd)."'";
	$query = mysqli_query($con, $sql);
	$rowcount = mysqli_num_rows($query);
    if ($rowcount==1) {
		$row = mysqli_fetch_array($query); 
        $_SESSION['user'] = $row;
        // update trang thai toan bo cac message trong cac conversion cua minh thanh 2       
        $s = "UPDATE `message`
set `status`=2 where `status`<2
where conversion_id in 
(
	select id from conversion
    where user1_id=1 or user2_id=1    
)";
        $q = mysqli_query($con, $s);
        echo 1;
    }
    else {
        echo 0;
    }
?>