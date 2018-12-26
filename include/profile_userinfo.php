    <h2 class="header">Thông tin cá nhân</h2>
    <table>
        <tr>
			<td class="avatar" rowspan="5"><img src="<?php echo $profile['avatar_url']?>" width="100px" height="100px" /></td>
            <td class="lbl register">Tên đăng nhập</td>
            <td class="userinfo"><strong><?php echo $profile['name']?></strong></td>
        </tr>
        <tr>
            <td class="lbl register">Họ tên</td>
            <td class="userinfo"><?php echo $profile['alias']?></td>
        </tr>
        <tr>
            <td class="lbl register">Email</td>
            <td class="userinfo"><?php echo $profile['email']?></td>
        </tr>
        <tr>
            <td class="lbl register">Số điện thoại</td>
            <td class="userinfo"><?php echo $profile['phone']?></td>
        </tr>
<?php
    if ($_GET['id'] == $_SESSION['user']['id']) {
        echo '        <tr>
        <td class="lbl register" colspan="2">
            <form method="post" action="profile.php" enctype="multipart/form-data">
                <input type="file" name="avatar"/>
                <input type="submit" id="change-avatar" name="uploadclick" value="Upload"/>
            </form>
        </td>
    </tr>';
    }
?>
    </table>
