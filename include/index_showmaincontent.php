<?php
            if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                $usr = $_POST['username'];
                $usr = str_replace("'","\\'",$usr);
                $pwd = $_POST['password'];
                $pwd = str_replace("'","\\'",$pwd);
                $sql = "SELECT * FROM users where (`name` like '%".$usr."%' or `email` like '%".$usr."%' or `phone`='".$usr."') and `password`='".md5($pwd)."'";
                $query = mysqli_query($con, $sql);
                $rowcount = mysqli_num_rows($query);
                if ($rowcount==1) {
                    $_SESSION['user'] = mysqli_fetch_array($query);
                    // update trang thai toan bo cac message trong cac conversion cua minh thanh 2
                    $s = sprintf("CALL markAsReceived(%u)", $_SESSION['user']['id']);
                    $q = mysqli_query($con, $s);
                    include('include/welcome.php');
                    include('include/navigation.php');
                    include('include/index_chatform.php');
                }
                else {
                    include('include/index_loginform_error.php');
                }
            }
            else {
                if (isset($_SESSION['user'])) {
                    include('include/welcome.php');
                    include('include/navigation.php');
                    include('include/index_chatform.php');
                    return;
                }
				include('include/index_loginform.php');
            }
?>