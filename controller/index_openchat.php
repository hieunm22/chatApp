<?php
    session_start();
    include('../default.php');
    $user_id = $_SESSION['user']['id'];
    $friend_id = $_REQUEST['id'];
	
    include('../include/index_loadmessage.php');
?>