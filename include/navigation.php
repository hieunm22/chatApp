<?php
	$strNav = '';
	if ($path == 'index') {
		$strNav = 'Trang chủ';
	}
	else {
		$strNav = '
        <a href="/chatApp">Trang chủ</a>';
		switch ($path) {
			case 'register': $strNav .= ' > Đăng ký';
				break;
			case 'usercp': $strNav .= ' > Đổi thông tin cá nhân';
				break;
			case 'profile': 
                if ($profile !== null) 
                    $strNav .= ' > '.$profile['alias'];               
				break;
		}
	}
	echo $strNav;
?>
