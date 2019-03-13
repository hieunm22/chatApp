function flogin() {
    if ($('input#usr').val() == '') {
        document.getElementById("usr").focus();
        blinkText('div.login-message', 'Chưa nhập tên người dùng', document.getElementsByClassName("login"));
        return;
    }
    if ($('input#pwd').val() == '') {
        document.getElementById("pwd").focus();
        blinkText('div.login-message', 'Chưa nhập mật khẩu');
        return;
    }
}

function enterPwd(_this) {
	if (_this.value == "") {
		_this.setCustomValidity('Hãy điền mật khẩu');
	}
	else {
		_this.setCustomValidity('');
	}
}

function register() {
    if ($('input#usr').val() == '') {
        document.getElementById("usr").focus();
        blinkText('div.login-message', 'Chưa nhập tên người dùng');
        return;
    }
    if ($('input#pwd').val() == '') {
        document.getElementById("pwd").focus();
        blinkText('div.login-message', 'Chưa nhập mật khẩu');
        return;
    }
    if ($('input#pwd').val() != $('input#pwd2').val()) {
        blinkText('div.login-message', 'Xác nhận mật khẩu không đúng');
        return;
    }
    if ($('select#gen').val() == -1) {
        blinkText('div.login-message', 'Chưa chọn giới tính');
        return;
    }
    $.ajax({
        url: "controller/register_register.php",
        data: {
            u: $('input#usr').val(),
            p: $('input#pwd').val(),
            a: $('input#alias').val(),
            e: $('input#email').val(),
            g: $('select#gen').val(),
            f: $('input#phone').val()
        },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            switch (+response) {
                case 0:
                    window.location.href = ".";
                    break;
                case 1:
                    blinkText('div.login-message', 'User đã tồn tại');
					$('input#usr')[0].style.boxShadow='0 0 5px red';
					$('input#usr')[0].focus();
                    break;
                case 2:
                    blinkText('div.login-message', 'Email đã được dùng để đăng ký');
                    break;
            }
        },
        error: function(data) {
            console.log('error');
        }
    });
}

function save() {
    if ($('input#oldpwd').val() == '' && ($('input#pwd').val() != '' || $('input#pwd2').val() != '')) {
        blinkText('div.login-message', 'Chưa nhập mật khẩu cũ');
		$('input#oldpwd').focus();
        return;
    }
    if ($('input#pwd').val() != $('input#pwd2').val()) {
        blinkText('div.login-message', 'Xác nhận mật khẩu không đúng');
        return;
    }
    if ($('input#oldpwd').val() == "" && $('input#pwd').val() != "") {
        blinkText('div.login-message', 'Chưa nhập mật khẩu cũ');
        return;
    }
    $.ajax({
        url: "controller/usercp_save.php",
        data: {
            u: $('span#usr').text(),
            e: $('input#email').val(),
            a: $('input#alias').val(),
            f: $('input#phone').val(),
            o: $('input#oldpwd').val(),
            p: $('input#pwd').val()
        },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			if (response==0) {
				blinkText('div.login-message', 'Mật khẩu cũ không đúng');
				return;
			}
            window.location.href = ".";
        },
        error: function(data) {
            console.log('error');
        }
    });
}