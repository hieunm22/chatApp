<!DOCTYPE HTML>
<html>
	<head>
		<title>Login</title>
		<link rel="stylesheet" type="text/css" href="style/animate.css" />
		<link rel="stylesheet" type="text/css" href="style/home.css" />
		<link rel="Shortcut Icon" href="images/O6n_HQxozp9.ico" type="image/x-icon" />

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<script type="text/javascript" src="script/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="script/login.js"></script>
		<script type="text/javascript" src="script/index.js"></script>
	</head>
	<body>
		<?php
			include('default.php');
			session_start();
            // echo $_SERVER['REQUEST_METHOD'];
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
				// include('include/close_tag.php');
            }
		?>
	</body>
</html>