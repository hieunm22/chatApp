<?php
	if (!isset($_SESSION['user'])) {
		include('include/index_loginjs.php');
	}
	else {
		$user = $_SESSION['user'] === null ? $_SESSION['user']['name'] : $_SESSION['user']['alias'];
		include('include/index_homejs.php');
	}
?>


