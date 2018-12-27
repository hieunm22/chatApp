<!DOCTYPE HTML>
<html>
	<head>
		<title>chatApp</title>
        <?php include('include/header.html');?>
		<script type="text/javascript">
			$(document).ready(function(){
				$(window).resize(resizeWindow);
				// $('#change-avatar').on('click', uploadavatar);
			});
		</script>
	</head>
	<body>
		<?php
			include('default.php');
            session_start();
            $con = initConnection();
            if (!isset($_SESSION['user'])) {
                include('include/non_authorize.html');
                return;
            }
            include('include/welcome.php');
            if ($_SERVER['REQUEST_METHOD'] == 'GET' && !isset($_GET['id'])) {
                echo '
                <script>(function redirect() { window.location.href="profile.php?id='.$_SESSION['user']['id'].'"; })();</script>';
                return;
            }
            
            if ($_SERVER['REQUEST_METHOD'] == 'GET') {
                $sql = "SELECT * FROM users where `id`='".$_GET['id']."' and status=1";
                $query = mysqli_query($con, $sql);
                $profile = mysqli_fetch_array($query);
                echo '
            <script id="temp">(function changeTitle() { $("title").text("'.$profile['alias'].'"); $("script#temp").remove(); })();</script>';
                include('include/navigation.php');
                if ($profile == null) {
                    echo '<div class="required"><strong>User không tồn tại.</strong></div>';
                }
                else {
                    include('include/profile_userinfo.php');
                }
            }
            else {  // REQUEST_METHOD = 'POST'
                $sql = "SELECT * FROM users where `id`=".$_SESSION['user']['id']." and status=1";
                $query = mysqli_query($con, $sql);
                $profile = mysqli_fetch_array($query);
                echo '
            <script id="temp">(function changeTitle() { $("title").text("'.$profile['alias'].'"); $("script#temp").remove(); })();</script>';
                include('include/navigation.php');
                // Nếu người dùng có chọn file để upload
                
                if ($_FILES['avatar']['error'] == 0)
                {
                    // Upload file
                    move_uploaded_file($_FILES['avatar']['tmp_name'], './images/'.$_SESSION['user']['id'].'.jpg');
                    include('include/profile_userinfo.php');
                }
                else if ($_FILES['avatar']['error'] == 4) 
                {
                    include('include/profile_userinfo.php');
                    echo '<div class="login-message ios-shake-incorrect-passcode">Bạn chưa chọn file upload</div>';
                }
            }

        ?>
	</body>
</html>