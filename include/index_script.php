<?php
	if (!isset($_SESSION['user'])) {
		// include('include/index_loginjs.html');
	}
	else {
		$user = $_SESSION['user'] === null ? $_SESSION['user']['name'] : $_SESSION['user']['alias'];
		include('include/index_homejs.php');
	}
?>


