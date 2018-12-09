var unreadCount = 0;
function searchUsersAndLoadMessage(isLoaded) {
    $.ajax({
        url: "controller/index_searchandload.php",
        // data: { t: txt },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            // hiển thị kết quả tìm kiếm
            if (response == '')
                return;
            var json = $.parseJSON(response);
            // load search
            searchOnLoad(json, false);
            if (isLoaded) {
                preOpenChatOnLoad(current_connect);
            }
            // load message
            openChatOnLoad(json.load);
        },
        error: showError
    }); 
}

function searchUsers(isKey) {
	var txt = $('#searchtb').val();
    $.ajax({
        url: "controller/index_search.php",
        data: { t: txt },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			// hiển thị kết quả tìm kiếm
            if (response == '')
                return;
            var json = $.parseJSON(response);
            searchOnLoad(json, isKey);
        },
        error: showError
    });
}

var friendName = '';
var meName = '';
var display_fr = '';
var display_me = '';
var conversion_color = "0084ff";

function openChat(fid, ws) {
    var chat = document.getElementById('chatmessage')
    if (!chat) return;
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
    chat.style.width = (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 480) + 'px';
    if (current_connect != -1) {
        var alias = $('div[id="user' + fid + '"] span.chatname').text();
        $('#chatname').text(alias);
    }
    else {
        $('#chatname').text('');
    }
    $('a#row3').attr('href', 'profile.php?id=' + current_connect);
    $('a#row3').attr('target', '_blank');
    $.ajax({
        url: "controller/index_openchat.php",
        data: { fid: fid, cur: current_connect },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            var json = $.parseJSON(response);
            if (ws && ws.readyState == 1) ws.send(
                JSON.stringify({
                    'type': "open_message",    //'friend action open message',
                    'sender_id': user_id,
                    'txt': "",
                    'msgtime': "",
                    'avatar': ""
                })
            );

            openChatOnLoad(json);
        },
        error: showError
    });
}

function setTitle() {
    if (unreadCount > 0) {
        $('title').text('(' + unreadCount + ') ' + display_fr);
        document.getElementById('appIcon').href = "images/YlPmwLaTSI9.ico";
    }
    else {
        $('title').text(display_fr);
        document.getElementById('appIcon').href = "images/O6n_HQxozp9.ico";
    }
}

function sendMessage(txt, ws) {
    if (!txt) return;
    txt = txt.trim().replaceAll('\n' ,'<br />');
    
    var d = new Date();
    var h = checkTime(d.getHours());
    var m = checkTime(d.getMinutes());
	
	var append = '<div class="message-row"><div class="message-content me"><span class="msg-status"><span class="_2her" style="color:#' + conversion_color + '" title="Sending"></span></span> <span class="user1" style="background-color: #' + conversion_color + '; border-color: #' + conversion_color + '">' + txt + '</span> <span class="tooltiptext me">' + (h + ":" + m) + '</span></div></div>';
    var chatmsg = document.getElementById('chatmessage');
    chatmsg.value = '';
    chatmsg.style.height = '45px';
    // scroll to end
    msgPN.innerHTML += append;
    msgPN.scrollTop = msgPN.scrollHeight;

    $.ajax({
        url: "controller/index_sendmessage.php",
        data: {
            m: decodeURIComponent(txt.replace('\n', '<br />')),
            f: current_connect,
        },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            var json = JSON.parse(response);
			ws.send(
				JSON.stringify({
					'type': 'sent_message',    //'sent_message',
					'sender_id': user_id,
					'txt': txt,
					'msgtime': (h + ":" + m),
					'avatar': json.avatar
				})
			);
            // send xong update lai user list   ('active-msg')
            $('div#search-content').html(json.html);
            // set active cho message vua gui
            $('.lbl.search-result')[0].classList.add('active-msg');
            // sending -> sent
            $('span.msg-status:last').html('<span class="_2her" style="color:#' + conversion_color + '" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>');
        },
        error: showError
    });
}