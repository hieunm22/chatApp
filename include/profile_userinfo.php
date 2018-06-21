    <h2 class="header">Thông tin cá nhân</h2>
    <table>
        <tr>
			<td class="avatar" rowspan="4"><img src="<?php echo $profile['avatar_url']?>" width="100px" height="100px" /></td>
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
    </table>
