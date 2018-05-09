<?php
    function toColor($n) {
        return(substr("000000".dechex($n),-6));
    }
	// thiết lập vùng giờ mặc định
	date_default_timezone_set('Asia/Ho_Chi_Minh');

	// $con=mysqli_connect('localhost', 'id5383375_hieunm22', 'quynhhoa', 'id5383375_chatapp');
	$con=mysqli_connect('localhost', 'root', '', 'chatapp');

    mysqli_query($con, "SET NAMES utf8");
?>