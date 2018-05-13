<?php
    session_start();
    include('../default.php');
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['id'];
    $stt = $_REQUEST['stt'];

    include('../include/index_loadmessage.php');
?>