<?php
    session_start();
    unset($_SESSION['user']);
    echo 'unset';
    // echo session_destroy();
    // if (isset($_SESSION['username'])) {
        // echo $_SESSION['username'];
    // }
    // else {
        // echo 'Session cleared';
    // }
?>