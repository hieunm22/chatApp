var xmlhttp = new XMLHttpRequest();
function flogin() {
    if ($('input#usr').val() == '') {
        document.getElementById("usr").focus();
        $('div.login-message').text('Chưa nhập tên người dùng');
        blinkText('div.login-message', document.getElementsByClassName("login"));
        return;
    }
    if ($('input#pwd').val() == '') {
        document.getElementById("pwd").focus();
        $('div.login-message').text('Chưa nhập mật khẩu');
        blinkText('div.login-message');
        return;
    }
    $.ajax({
        url: "controller/index_login.php",
        data: { u: $('input#usr').val(), p: $('input#pwd').val() },
        type: "post",
        dataType: "json",
        success: function (result) {
            if (result == 1) {
                location.reload();
            }
            else {
                $('div.login-message').text('User hoặc password không đúng');
				blinkText('div.login-message');
            }
        },
        error: function (data) {
            console.log('error');
        },
    });
}

function register() {
    if ($('input#usr').val() == '') {
        document.getElementById("usr").focus();
        $('div.login-message').text('Chưa nhập tên người dùng');
        blinkText('div.login-message');
        return;
    }
    if ($('input#pwd').val() == '') {
        document.getElementById("pwd").focus();
        $('div.login-message').text('Chưa nhập mật khẩu');
        blinkText('div.login-message');
        return;
    }
    if ($('input#pwd').val() != $('input#pwd2').val()) {
        $('div.login-message').text('Xác nhận mật khẩu không đúng');
        blinkText('div.login-message');
        return;
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            switch (+this.responseText) {
                case 0:
                    window.location.href = "index.php";
                    break;
                case 1:
                    $('div.login-message').text('User đã tồn tại');
                    blinkText('div.login-message');
					$('input#usr')[0].style.boxShadow='0 0 5px red';
					$('input#usr')[0].focus();
                    break;
                case 2:
                    $('div.login-message').text('Email đã được dùng để đăng ký');
                    blinkText('div.login-message');
                    break;
            }
        }
    };
    xmlhttp.open("GET", "controller/register_register.php?u=" + $('input#usr').val() + '&p=' + $('input#pwd').val() + '&a=' + $('input#alias').val() + '&e=' + $('input#email').val() + '&f=' + $('input#phone').val(), true);
    xmlhttp.send();
}

function save() {
    if ($('input#pwd').val() != $('input#pwd2').val()) {
        $('div.login-message').text('Xác nhận mật khẩu không đúng');
        blinkText('div.login-message');
        return;
    }    
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
			if (this.responseText==='0') {
				$('div.login-message').text('Mật khẩu cũ không đúng');
				blinkText('div.login-message');
				return;
			}
            window.location.href = "index.php";
        }
    };
    xmlhttp.open("GET", "controller/usercp_save.php?e=" + $('input#email').val() + '&a=' + $('input#alias').val() + '&f=' + $('input#phone').val() + '&o=' + $('input#oldpwd').val() + '&p=' + $('input#pwd').val(), true);
    xmlhttp.send();
}