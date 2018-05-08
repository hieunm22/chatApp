<?php
    include('../default.php');
    session_start();
    $id = $_SESSION["user"]["id"];
    $old = $_REQUEST['o'];
    $old = str_replace("'","\\'",$old);
    if ($old !== '') {
        $sql = "select * from `users` where `id`=".$id." and `password`='".md5($old)."'";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount==0) {
            echo '0';
            return;
        }
    }

    $ali = $_REQUEST['a'];
    $ali = str_replace("'","\\'",$ali);
    $eml = $_REQUEST['e'];
    $eml = str_replace("'","\\'",$eml);
    $pho = $_REQUEST['f'];
    $pho = str_replace("'","\\'",$pho);
    $pwd = $_REQUEST['p'];
    $pwd = str_replace("'","\\'",$pwd);

    $sql = "update `users` set `alias`='".$ali."', `email`='".$eml."', `phone`='".$pho."'";
	if (strlen($old) > 0 && strlen($pwd) > 0) {
		$sql .= ", `password`='".md5($pwd)."'";
	}
    $sql .= " where `id`='".$id."'";
	$query = mysqli_query($con, $sql);
    $sql = "SELECT * FROM users where `id`='".$id."'";
	$query = mysqli_query($con, $sql);
    $row = mysqli_fetch_array($query);
    $_SESSION["user"] = $row;
    echo '1';
?>