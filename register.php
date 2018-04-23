<!DOCTYPE HTML>
<html>
	<head>
		<title>Đăng ký</title>
		<link rel="stylesheet" type="text/css" href="style/animate.css" />
		<link rel="stylesheet" type="text/css" href="style/home.css" />
		<link rel="Shortcut Icon" href="images/O6n_HQxozp9.ico" type="image/x-icon" />

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<script type="text/javascript" src="script/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="script/login.js"></script>
		<script type="text/javascript" src="script/index.js"></script>
		<script type="text/javascript">
            $(document).ready(function() {
                $('input#usr').on('change', function() {
                    $('input#alias').val($('input#usr').val());
				});
            });
        </script>
	</head>
	<body>
		<?php 
			include('include/navigation.php');
			echo '<hr />';
		?>
        <div class="register-info"><span class="lbl register">Tên đăng nhập <span class="required">*</span></span><input type="text" name="username" id="usr" placeholder="Tên đăng nhập" onkeyup="this.style.boxShadow=''" autofocus="true" required /></div>
        <div class="register-info"><span class="lbl register">Password <span class="required">*</span></span></span><input type="password" name="password" id="pwd" placeholder="Mật khẩu" required /></div>
        <div class="register-info"><span class="lbl register">Confirm Password <span class="required">*</span></span></span><input type="password" name="password" id="pwd2" placeholder="Xác nhận lại mật khẩu" required /></div>
        <div class="register-info"><span class="lbl register">Họ tên </span><input type="text" name="alias" id="alias" placeholder="Tên hiển thị"/></div>
        <div class="register-info"><span class="lbl register">Email </span><input type="text" name="email" id="email" placeholder="Email đăng ký"/></div>
        <div class="register-info"><span class="lbl register">Số điện thoại </span><input type="text" name="phone" id="phone" placeholder="Số điện thoại"/></div>
        <div class="login-info login-message"></div>
        <div class="login-info">
            <center>
                <input type="button" name="register" class="register" value="Đăng ký" onclick="register()" />
            </center>
        </div>
	</body>
</html>