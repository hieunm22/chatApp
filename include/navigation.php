
<?php
	$strNav = '';
    $path = basename($_SERVER['SCRIPT_FILENAME']);
	if ($path == 'index.php') {
		$strNav = '         Trang chủ';
	}
	else {
		$strNav = '
        <a href="/chatApp">Trang chủ</a>';
		switch ($path) {
			case 'register.php': $strNav .= ' > Đăng ký';
				break;
			case 'usercp.php': $strNav .= ' > Đổi thông tin cá nhân';
				break;
			case 'profile.php': 
                if ($profile !== null) 
                    $strNav .= ' > '.$profile['alias'];               
				break;
		}
	}
	echo $strNav;
?>


