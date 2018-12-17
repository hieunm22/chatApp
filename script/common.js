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

function getHexColor(number){
    return ((number)>>>0).toString(16).padStart(6, "0");
}

function convertColor(color){
    var cl = color.substring(4, color.indexOf(')'));
    var rgb = cl.split(', ');
    var ret = 0;
	var mul = 65536;
    rgb.forEach(function(item) {
        ret += (+item) * mul;
		mul /= 256;
    });
    return ret;
}

function checkTime(i) {
    return i < 10 ? "0" + i : i;
}

function resizeWindow() {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    //$('div#search-list').css('height', (h - 100) + 'px');
    $('div#search-content').height(h - 120);
    $('div#chatmain').width(w - 360);
    $('div#chatmain').height(h - 92);
    $('div#messagePanel').width(w - 390);
    $('div#messagePanel').height(h - 220);
    $('#chatmessage').width(w - 480);
    $('#chatmessage').height(45);
}

function showError(data) {
    console.log(data.responseText);
}

function changeConversionObjectsColor() {
	$('svg').css('stroke', '#' + conversion_color);
	$('polygon').css('fill', '#' + conversion_color);
	$('circle').css('fill', '#' + conversion_color);
	$('path').css('stroke', '#' + conversion_color);
}

function showDropDown() {
    document.getElementById("myDropdown").classList.toggle("show");
	// $('.dropdown-row:hover').attr('style', 'background-color: #' + conversion_color);
}

function changeConversionColor(e) {
	// var _colorIndex = e.target.id.substr(5) - 1;
	var _intValue = convertColor(e.target.style.backgroundColor || e.target.parentElement.style.backgroundColor);
	conversion_color = getHexColor(_intValue);
	$('span.user1').attr('style', 'background-color: #' + conversion_color + '; border-color: #' + conversion_color);
	$('span._2her').css('color', '#' + conversion_color);
	changeConversionObjectsColor();
    $.ajax({
        url: "controller/index_changecolor.php",
        data: { fid: current_connect, c: _intValue },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			// close modal dialog
			$('#myModal1').modal('toggle');
        },
        error: showError
    });
}

function checkConversionColor() {
	$('td.dot').html('');
	$('td.dot[style="background-color: #' + conversion_color + '"]').html('<i class="_gs2 img sp_tRueZ17UPsM sx_4affb5" alt=""></i>');
}

function editnickname(e) {
	if (e.currentTarget.style.cursor != "text") {
		$('input[id^="nickname"]').attr('style', '');
		e.currentTarget.style.cursor = "text";
		e.currentTarget.style.border = "1px solid #d0c9c9";
		e.currentTarget.readOnly = false;
	}
}

function loadNickNames() {
	var meElem = document.getElementById('nickname1');
	meElem.value = display_me;
	meElem.placeholder = meName;
	var friendElem = document.getElementById('nickname2');
	var nameInSearch = $('.active-msg > .username-search > .chatname').text();
	friendElem.value = nameInSearch;
	friendElem.placeholder = friendName;
	$('input[id^="nickname"]').attr('style', '');
}

function saveNickNames() {
	var me = $('input#nickname1').val() || $('input#nickname1').attr('placeholder');
	var fr = $('input#nickname2').val() || $('input#nickname2').attr('placeholder');
    $.ajax({
        url: "controller/index_changenicknames.php",
        data: { fid: current_connect, nick1: me, nick2: fr },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            $('input#nickname2').val(fr);
			// close modal dialog
			// $('#myModal2').modal('toggle');
			$('td#chatname').text(fr);
            $('div#user' + current_connect + ' > span.chatname').text(fr);
            $('title').text(fr);
            $('div#messagePanel').append('<div class="message-row message-alert">Bạn đã đổi nicknames</div>');
            $('#search-content').html(response);
        },
        error: showError
    });
}

window.onclick = function(e) {
	if ($(e.target).parents('._30yy').length == 0) {
		var dropdowns = document.getElementsByClassName("dropdown-content");
		var i;
		for (i = 0; i < dropdowns.length; i++) {
			var openDropdown = dropdowns[i];
			if (openDropdown.classList.contains('show')) {
				openDropdown.classList.remove('show');
			}
		}
	}
}

function wsReceivedMessage(e)
{
    var json = JSON.parse(e.data);
    if (json.sender_id == user_id) return;
    switch (json.type) {
        case "sent_message":
            if (json.sender_id != current_connect) {	// message từ người bạn mà máy mình đang không focus vào
                // reload lại search users
                searchUsers();
            }
            else 								        // message từ người bạn mà máy mình đang focus vào
            {
                searchUsersAndLoadMessage(false);
                msgPN.scrollTop = msgPN.scrollHeight;
                // reload lại search users và load lại message của conversion đó
            }
            break;
        case "open_message":
            openChat(current_connect);
            break;
    }
}

function preOpenChatOnLoad(fid) {
    var chat = document.getElementById('chatmessage')
    chat.disabled = false;
    chat.focus();
    current_connect = fid;

    if ($('div#user' + fid + ' > span.chatname').hasClass('unread-txt')) unreadCount--;
    // mark as read message
    $('div#user' + fid + ' > span.me').css('color', '#0006');
    var usr_chat = document.getElementById('user' + fid);
    var parent = usr_chat.parentElement;
    var findUnread = $(parent).find('.unread-txt')
    if (findUnread.length > 0) findUnread.removeClass('unread-txt');

    $('textarea').height(45);

    var status = usr_chat.getAttribute('status');
    if (status == '0') {
        chat.disabled = true;
        chat.value = 'Bạn không thể gửi tin nhắn cho người này';
        chat.style.border = '0px none';
        chat.style.backgroundColor = 'transparent';
    }
    else {
        chat.disabled = false;
        chat.value = '';
        chat.style.display = 'inherit';
    }
    setTitle();
    chat.style.width = (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 480) + 'px';
    if (current_connect != -1) {
        var alias = $('div[id="user' + fid + '"] span.chatname').text();
        $('#chatname').text(alias);
    }
    else {
        $('#chatname').text('');
    }
    ws.send(
        JSON.stringify({
            'type': "open_message",    //'friend action open message',
            'sender_id': user_id,
            'txt': "",
            'msgtime': "",
            'avatar': ""
        })
    );
}

function openChatOnLoad(jsonstr) {
    $('a._30yy').css('display', 'inline');
    conversion_color = jsonstr.conversion_color;
    changeConversionObjectsColor();
    // load những message có trạng thái đã đọc lên trước
    msgPN.innerHTML = jsonstr.readMsg;
    // load những message chưa đọc lên sau
    msgPN.innerHTML += jsonstr.unreadMsg;
    // cuộn xuống dưới cùng
    msgPN.scrollTop = msgPN.scrollHeight;
    friendName = jsonstr.friendname;
    display_fr = jsonstr.display_fr;
    meName = jsonstr.mename;
    display_me = jsonstr.display_me;
    // xoá seen icon
    var msgstt = $('._4jzq._jf5:not(:last)');
    if (msgstt.length > 0) msgstt.css('display', 'none');
    setTitle();
    // xoá avatar friend ở message panel, giữ lại avatar cuối cùng
    var friend_row = $('img.avatar-friend').closest('.message-row');
    friend_row.each(function(index) {
        var avatar_friend = this.querySelector('img.avatar-friend');
        if (index < friend_row.length - 1) {
            var avatar_next = this.nextElementSibling.querySelector('img.avatar-friend');
            if (avatar_next && avatar_next.src == avatar_friend.src) {
                avatar_friend.style = "display: none";
                var msg = this.querySelector('.user2');
                msg.classList.add('msg-no-avatar');
            }
        }
    });
}

function searchOnLoad(jsonstr, isKey) {
    $('div#search-content').html(jsonstr.search);
    unreadCount = 0;
    unreadCount += jsonstr.unread;
    setTitle();

    var sl = $('div#search-list').height();
    var sb = $('div#searchbox').height();
    $('div#search-content').css('height', sl - sb);
    // mark as received
    if (ws && ws.readyState) ws.send(
        JSON.stringify({
            'type': "open_message",    //'friend action open message',
            'sender_id': user_id,
            'txt': "",
            'msgtime': "",
            'avatar': ""
        })
    );

    // nếu đã chọn 1 conversion thì vẫn focus conversion đó
    // if (current_connect != -1) {
        // $('div.lbl.search-result').removeClass('active-msg');
        // $('div#user' + current_connect).parent('div.lbl.search-result').addClass('active-msg');
    // }
}

String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
