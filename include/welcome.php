<?php 
	// $welcome = '<div id="welcome">Welcome to chat App, <a href="usercp.php"><strong>'.$_SESSION['user']["alias"].'</a></strong>';
	$welcome = '<div id="welcome">Welcome to chat App, <strong><a href="profile.php?id='.$_SESSION["user"]["id"].'">'.$_SESSION['user']["alias"].'</a></strong>';
	if (basename($_SERVER['SCRIPT_FILENAME']) != 'usercp.php') {
		$welcome .= ' | <a href="usercp.php">Cài đặt</a>';
	}
	$welcome .= ' | <a href="javascript:logout()">Đăng xuất</a></div>';
	$welcome .= '
        <hr />';
	echo $welcome;
?>

        <script>
            function logout() {
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        window.location.href = "/chatApp";
                    }
                };
                xmlhttp.open("GET", "controller/index_logout.php", true);
                xmlhttp.send();
            }
        </script>