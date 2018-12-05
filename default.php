<?php
    function toColor($n) {
        return(substr("000000".dechex($n),-6));
    }
	// thiết lập vùng giờ mặc định
	date_default_timezone_set('Asia/Ho_Chi_Minh');

    function initConnection(){
        // $conn=mysqli_connect('localhost', 'id5383375_hieunm22', 'quynhhoa', 'id5383375_chatapp');
        $conn=new mysqli('localhost', 'root', 'admin', 'chatapp');

        mysqli_query($conn, "SET NAMES utf8");
        return $conn;
    }
?>