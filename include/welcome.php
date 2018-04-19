<?php 
	// $welcome = '<div id="welcome">Welcome to chat App, <a href="usercp.php"><strong>'.$_SESSION['user']["alias"].'</a></strong>';
	$welcome = '<div id="welcome">Welcome to chat App, <strong><a href="profile.php?id='.$_SESSION["user"]["id"].'">'.$_SESSION['user']["alias"].'</a></strong>';
	if ($path!='usercp') {
		$welcome .= ' | <a href="usercp.php">Cài đặt</a>';
	}
	$welcome .= ' | <a href="javascript:logout()">Đăng xuất</a></div>';
	$welcome .= '
        <hr />';
	echo $welcome;
?>