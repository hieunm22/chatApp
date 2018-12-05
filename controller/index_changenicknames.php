<?php
	include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['fid'];
    $nick1 = $_REQUEST['nick1'];
    $nick2 = $_REQUEST['nick2'];
    // insert vao table message ve hanh dong doi nick name
	$con = initConnection();
    $con->query("call setConversionAction(1, $uid, $fid)");
    $con->query("call setNickNames($uid, $fid, '$nick1', '$nick2')");
    $query = mysqli_query($con, "call searchUsers($uid)");
    echo (include '../include/searchusers.php');
?>