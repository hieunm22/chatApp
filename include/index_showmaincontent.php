<?php
	$con = initConnection();
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        # code dang nhap o day
		$usr = $_POST['username'];
		$usr = str_replace("'","\\'",$usr);
		$pwd = $_POST['password'];
		$pwd = str_replace("'","\\'",$pwd);
		$sql = "call loginVertification($usr, $pwd)";
		$query = mysqli_query($con, $sql);
		$rowcount = $query->num_rows;
		if ($rowcount == 1) {
			$_SESSION['user'] = mysqli_fetch_array($query);
			$_SESSION['current_connect'] = $_SESSION['user']['current_connect'];
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
			// CALL markAsReceived
			$s = sprintf("CALL markAsReceived(%u)", $_SESSION['user']['id']);
			$q = mysqli_query($con, $s);
			
			include('include/welcome.php');
			include('include/navigation.php');
			include('include/index_chatform.php');
		}
		else {
			include('include/index_loginform.html');
			include('include/index_script.php');
		}
    }
?>