<?php
    include('default.php');
    $userid = $_GET["id"];

    $sql = "select * from users where `id`=".$userid;
	$query = mysqli_query($con, $sql);
    $user = mysqli_fetch_array($query);
?>

    <h2 class="header">Thông tin cá nhân</h2>
    <table>
        <tr>
            <td class="lbl register">Tên đăng nhập</td>
            <td class="userinfo"><strong><?php echo $user['name']?></strong></td>
        </tr>
        <tr>
            <td class="lbl register">Họ tên</td>
            <td class="userinfo"><?php echo $user['alias']?></td>
        </tr>
        <tr>
            <td class="lbl register">Email</td>
            <td class="userinfo"><?php echo $user['email']?></td>
        </tr>
        <tr>
            <td class="lbl register">Số điện thoại</td>
            <td class="userinfo"><?php echo $user['phone']?></td>
        </tr>
    </table>
