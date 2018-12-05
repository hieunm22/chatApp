<?php
    session_start();
    include('../default.php');
    $uid = $_SESSION['user']['id'];
    $fid = $_REQUEST['fid'];
    $cur = $_REQUEST['cur'];

    $loadmsg = include('../include/index_openchatincl.php');
    echo $loadmsg;
?>