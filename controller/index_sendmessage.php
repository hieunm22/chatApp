<?php
    include('../default.php');
    session_start();
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['f'];
    $message = $_REQUEST['m'];
    $message = str_replace("'","\\'",$message);
    // kiểm tra cuộc hội thoại đã có trong database chưa, chưa thì insert
    $con = initConnection();
    $con->query("call sendMessage($uid, $fid, '$message')");

    // include search all
    $sql = "call searchUsers($uid)";
    $query = mysqli_query($con, $sql);
    $rowcount = $query->num_rows;
    $unreadCount = 0;

    $html = (include '../include/searchusers.php');

    $obj = new stdClass();
    $obj->html = $html;
    $obj->avatar = $avatar;
    $obj->msgtime = date("H:i");
    echo json_encode($obj);
?>