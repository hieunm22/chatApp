function blinkText(selector, txt, sender) {
    if (typeof sender != 'undefined') {
        document.getElementsByClassName("login").disabled = true;
    }
    $(selector).text(txt);
    $(selector).addClass('ios-shake-incorrect-passcode');
    setTimeout(function () {
        $(selector).removeClass("ios-shake-incorrect-passcode");
        if (typeof sender != 'undefined') {
            document.getElementsByClassName("login").disabled = false;
        }
    }, 450);
}

function searchList() {
	var text = $('#searchtb').val();
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
			// console.log(this.responseText);
			// hiển thị kết quả tìm kiếm
			$('div#search-content').html(this.responseText);
            // var sl = $('div#search-list').height();
            // var sb = $('div#searchbox').height();
			// $('div#search-content').css('height', sl - sb);
			// nếu đã chọn 1 conversion thì vẫn focus conversion đó
			if (friend_id != -1) {
				$('div.lbl.search-result').removeClass('active-msg');
				$('div#user' + friend_id).parent('div.lbl.search-result').addClass('active-msg');
			}
            resizeWindow();
        }
    };
    xmlhttp.open("GET", "controller/index_search.php?t=" + text, true);
    xmlhttp.send();
}

function resizeWindow() {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    $('div#search-list').css('height', (h - 120) + 'px');
    $('div#chatmain').css('width', (w - 360) + 'px');
    $('div#chatmain').css('height', (h - 120) + 'px');
    $('div#messagePanel').css('height', (h - 210) + 'px');
    $('#chatmessage').css('width', (w - 510) + 'px');
}

var friend_id = -1;
var conversion_color = "#0084ff";
function openChat(id) {
    var chat = document.getElementById('chatmessage')
    if (chat) {
        chat.disabled = false;
        chat.focus();
        friend_id = id;
        if (friend_id != -1) {
            var alias = $('div[id="user' + id + '"] span.chatname').text();
            $('title').text(alias);
        }
        else {
            $('title').text("Home");
        }
        xmlhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                conversion_color = getCookie('conversion_color');
                // console.log(this.responseText);
                $('div#messagePanel').html(this.responseText);
                var div = document.getElementById("messagePanel");
                if (div) div.scrollTop = div.scrollHeight;
            }
        };
        xmlhttp.open("GET", "controller/index_openchat.php?id=" + id, true);
        xmlhttp.send();
    }
}

function getHexColor(number){
    return "#"+((number)>>>0).toString(16).padStart(6, "0");
}

function checkTime(i) {
    return i < 10 ? "0" + i : i;
}

function getCookie_temp(name) {
    var value = "; " + document.cookie;
    var parts = value.split("; " + name + "=");
    if (parts.length == 2) return parts.pop().split(";").shift();
}

function getCookie(name) {
    var parts = document.cookie.split("; ");
    var filter = parts.filter(function(v) { return v.startsWith("conversion_color="); });
    return filter[filter.length - 1].substr(17);
}

function sendMessage(txt) {
    var d = new Date();
    var h = checkTime(d.getHours());
    var m = checkTime(d.getMinutes());

    $('div#messagePanel').append('<div class="message-row"><div class="message-content u1"><span class="user1" style="background-color: #' + conversion_color + '; border-color: #' + conversion_color + '">' + txt + '</span> <span class="tooltiptext u1">' + (h + ":" + m) + '</span></div></div>');
    $('#chatmessage').val('');
	if (txt.trim() == '') return;
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
			// $('div#messagePanel').html(this.responseText);
            // scroll to end
            var div = document.getElementById("messagePanel");
            div.scrollTop = div.scrollHeight;
            // send xong update lai user list
            searchList();
        }
    };
    xmlhttp.open("GET", "controller/index_sendmessage.php?m="
        + txt.trim().replace('\n', '<br />').replace('&', '%26')
        + "&f=" + friend_id, true);
    xmlhttp.send();
}

