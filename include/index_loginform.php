	<div class="login-info"><span class="lbl login">User name </span><input type="text" name="username" id="usr" placeholder="User name, email hoặc số điện thoại" required autofocus="true" /></div>
	<div class="login-info"><span class="lbl login">Password </span><input type="password" name="password" id="pwd" placeholder="Mật khẩu" required /></div>
	<div class="login-info login-message"></div>
	<div class="login-info">
		<center>
			<input type="button" name="login" class="login" value="Đăng nhập" />
            <a class="register" href="register.php">Đăng ký</a>
		</center>
	</div>
    <?php include('include/index_script.php'); ?>