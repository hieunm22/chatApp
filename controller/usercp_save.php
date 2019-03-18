<?php
    include('../default.php');
    session_start();
    $id = $_SESSION["user"]["id"];

    $old = $_REQUEST['o'];
    $old = str_replace("'","\\'",$old);

    $con = initConnection();
	$sql = "select * from `users` where `id`=".$id." and `password`=md5('".$old."')";
    $query = mysqli_query($con, $sql);
    // có nhập mật khẩu cũ nhưng không đúng
	if ($query->num_rows==0 && $old !== '') {
        echo 0;
		return;
	}

    $usr = $_REQUEST['u'];
    $usr = str_replace("'","\\'",$usr);
    $ali = $_REQUEST['a'];
    $ali = str_replace("'","\\'",$ali);
    $eml = $_REQUEST['e'];
    $eml = str_replace("'","\\'",$eml);
    $pho = $_REQUEST['f'];
    $pho = str_replace("'","\\'",$pho);
    $pwd = $_REQUEST['p'];
    $pwd = str_replace("'","\\'",$pwd);
    $chp = $_REQUEST['c'];

    if ($chp === 'true')
        $sql = "Call updateUser('".$usr."'";
    else
        $sql = "Call updateUserInfo('".$usr."'";
    if (!isset($pwd) || trim($pwd)==='') {
        $sql .= ", null";
    }
    else {
        $sql .= ", '".md5($pwd)."'";
    }
    if (!isset($eml) || trim($eml)==='') {
        $sql .= ", null";
    }
    if (!isset($eml) || trim($eml)==='') {
        $sql .= ", null";
    }
    else {
        $sql .= ", '".$eml."'";
    }
    if (!isset($ali) || trim($ali)==='') {
        $sql .= ", null";
    }
    else {
        $sql .= ", '".$ali."'";
    }
    if (!isset($pho) || trim($pho)==='') {
        $sql .= ", null";
    }
    else {
        $sql .= ", '".$pho."'";
    }
    $sql .= ", ".$id.")";
    $query = mysqli_query($con, $sql);
    $sql = "SELECT * FROM users where `id`=".$id;
	$query = mysqli_query($con, $sql);
    $row = mysqli_fetch_array($query);
    $_SESSION["user"] = $row;
	echo 1;
?>