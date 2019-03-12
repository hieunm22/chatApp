<form action="" method="post">
	<div class="cont">
		<center><h3 class="login-title">chatApp Login</h3></center>
		<hr class="seperator" />
		<div class="login-info">
			<svg class="login__icon name svg-icon" viewBox="0 0 20 20">
				<path d="M0,20 a10,8 0 0,1 20,0z M10,0 a4,4 0 0,1 0,8 a4,4 0 0,1 0,-8"></path>
			</svg>
			<input type="text" name="username" id="usr-login" placeholder="User name, email hoặc số điện thoại" required autofocus="true" />
		</div>
		<div class="login-info">
			<svg class="login__icon pass svg-icon" viewBox="0 0 20 20">
				<path d="M0,20 20,20 20,8 0,8z M10,13 10,16z M4,8 a6,8 0 0,1 12,0"></path>
			</svg>
			<input type="password" name="password" id="pwd-login" placeholder="Mật khẩu" required oninvalid="enterPwd(this)"/>
		</div>
		<div class="login-info login-message ios-shake-incorrect-passcode">Username hoặc mật khẩu không đúng</div>
		<div class="login-info">
			<center>
				<input type="submit" name="login" class="login-btn" value="Đăng nhập" />
				<p>Chưa có tài khoản? <a class="register-link" href="register.php">Đăng ký ngay</a></p>
			</center>
		</div>
	</div>
		</form>
<?php include('include/index_script.php'); ?>