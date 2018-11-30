var unreadCount = 0;
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
            $('div#search-content').html(json.html);
            $('.lbl.search-result').removeClass('active-msg');
            if (current_connect != -1 && !isKey) {
                $('#user' + current_connect).parent().addClass('active-msg');
                openChat(current_connect, ws);
            }
            unreadCount = 0;
            unreadCount += json.unread;
            var title = display_fr || "Home";
			if (unreadCount > 0)
				$('title').text('(' + unreadCount + ') ' + title);
			else
				$('title').text(title);

            var sl = $('div#search-list').height();
            var sb = $('div#searchbox').height();
			$('div#search-content').css('height', sl - sb);
			// nếu đã chọn 1 conversion thì vẫn focus conversion đó
			// if (current_connect != -1) {
				// $('div.lbl.search-result').removeClass('active-msg');
				// $('div#user' + current_connect).parent('div.lbl.search-result').addClass('active-msg');
			// }
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
            $('a._30yy').css('display', 'inline');
            conversion_color = getCookie('conversion_color');
            changeConversionObjectsColor();
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

            var div = document.getElementById("messagePanel");
            // load những message có trạng thái đã đọc lên trước
            div.innerHTML = json.readMsg;
            // load những message chưa đọc lên sau
            div.innerHTML += json.unreadMsg;
            // cuộn xuống dưới cùng
            div.scrollTop = div.scrollHeight;
            friendName = json.friendname;
            display_fr = json.display_fr;
            meName = json.mename;
            display_me = json.display_me;
            var msgstt = $('._4jzq._jf5:not(:last)');
            if (msgstt.length > 0) msgstt.css('display', 'none');
            var frName = (json.friendname || $('.active-msg').find('.chatname').text());
            if (unreadCount > 0)
                $('title').text('(' + unreadCount + ') ' + display_fr);
            else
                $('title').text(display_fr);
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
        },
        error: showError
    });
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
    var div = document.getElementById("messagePanel");
    div.innerHTML += append;
    div.scrollTop = div.scrollHeight;

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