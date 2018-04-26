var xmlhttp = new XMLHttpRequest();
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
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            switch (+this.responseText) {
                case 0:
                    window.location.href = "/chatApp";
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
        }
    };
    xmlhttp.open("GET", "controller/register_register.php?u=" + $('input#usr').val() + '&p=' + $('input#pwd').val() + '&a=' + $('input#alias').val() + '&e=' + $('input#email').val() + '&f=' + $('input#phone').val(), true);
    xmlhttp.send();
}

function save() {
    if ($('input#pwd').val() != $('input#pwd2').val()) {
        blinkText('div.login-message', 'Xác nhận mật khẩu không đúng');
        return;
    }    
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
			if (this.responseText==='0') {
				blinkText('div.login-message', 'Mật khẩu cũ không đúng');
				return;
			}
            window.location.href = "/chatApp";
        }
    };
    xmlhttp.open("GET", "controller/usercp_save.php?e=" + $('input#email').val() + '&a=' + $('input#alias').val() + '&f=' + $('input#phone').val() + '&o=' + $('input#oldpwd').val() + '&p=' + $('input#pwd').val(), true);
    xmlhttp.send();
}