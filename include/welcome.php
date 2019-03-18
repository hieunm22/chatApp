<?php
	$welcome = sprintf('<div id="welcome">Welcome to chat App, <strong><a href="profile.php?id=%s">%s</a></strong>', $_SESSION["user"]["id"], $_SESSION['user']["alias"]);
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
                $.ajax({
                    url: 'controller/index_logout.php',
                    data: {  },
                    // dataType: 'json',
                    type: 'GET',
                    success: function (response) {
                        window.location.href = ".";
                    },
                    error: function(data) {
                        console.log('error');
                    }
                });
            }
        </script>