<!DOCTYPE HTML>
<html>
	<head>
		<title>chatApp</title>
		<link rel="stylesheet" type="text/css" href="style/profile.css" />
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
            if (!isset($_SESSION['user'])) {
                include('include/non_authorize.php');
                include('include/close_tag.php');
                return;
            }
            include('include/welcome.php');
            if (!isset($_GET['id'])) {
                echo '
                <script>(function redirect() { window.location.href="users/'.$_SESSION['user']['name'].'"; })();</script>';
            }
            $sql = "SELECT * FROM users where `id`='".$_GET['id']."'";
            $query = mysqli_query($con, $sql);
            $profile = mysqli_fetch_array($query);
            echo '
        <script id="temp">(function changeTitle() { $("title").text("'.$profile['alias'].'"); $("script#temp").remove(); })();</script>';
            include('include/navigation.php');
            if ($profile == null) {
                echo '<div class="required"><strong>User không tồn tại.</strong></div>';
            }
            include('include/profile_userinfo.php');
        ?>
	</body>
</html>