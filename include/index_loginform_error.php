<form action="index.php" method="post">
	<div class="login-info"><span class="lbl login">User name </span><input type="text" name="username" id="usr" placeholder="User name, email hoặc số điện thoại" required autofocus="true" value="<?php echo $_POST['username']; ?>" /></div>
	<div class="login-info"><span class="lbl login">Password </span><input type="password" name="password" id="pwd" placeholder="Mật khẩu" required /></div>
	<div class="login-info login-message ios-shake-incorrect-passcode">Username hoặc mật khẩu không đúng</div>
	<div class="login-info">
		<center>
			<input type="submit" name="login" class="login" value="Đăng nhập" />
            <a class="register" href="register.php">Đăng ký</a>
		</center>
	</div>
</form>
    <?php include('include/index_script.php'); ?>