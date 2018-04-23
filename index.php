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
			if (!isset($_SESSION['user'])) {
				include('include/index_loginform.php');
				include('include/index_script.php');
				include('include/close_tag.php');
				return;
			}
			else {
				include('include/welcome.php');
				include('include/navigation.php');
			}
		?>


		<div id="search-list">
			<div id="searchbox">
				<input type="text" id="searchtb" placeholder="Tìm kiếm thành viên" autofocus="true" />
			</div>
			<div id="search-content"></div>
		</div>
		<div id="chatmain">
            <div id="messagePanel"></div>
            <input type="text" id="chatmessage" placeholder="Nhập tin nhắn..." disabled />
            <input type="button" id="sendmessage" value="Gửi" />
        </div>

        <?php include('include/index_script.php'); ?>
	</body>
</html>