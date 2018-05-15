var unreadCount = 0;
function searchList(loaded) {
	var text = $('#searchtb').val();
    $.ajax({
        url: "controller/index_search.php",
        data: { t: text, l: (loaded | 0) },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            // while (response.indexOf('\r') > 0) response=response.replace('\r','');
            // while (response.indexOf('\n') > 0) response=response.replace('\n','');
			// console.log(this.responseText);
			// hiển thị kết quả tìm kiếm
            if (response == '') 
                return;
            var json = $.parseJSON(response);
			if (loaded != undefined) {
				$('div#search-content').append(json.html);
                unreadCount += json.unread;
            }
			else
				$('div#search-content').html(json.html);
			if (unreadCount)
				$('title').text('(' + unreadCount + ') Home');
			else
				$('title').text('Home');
            
            // var sl = $('div#search-list').height();
            // var sb = $('div#searchbox').height();
			// $('div#search-content').css('height', sl - sb);
			// nếu đã chọn 1 conversion thì vẫn focus conversion đó
			if (friend_id != -1) {
				$('div.lbl.search-result').removeClass('active-msg');
				$('div#user' + friend_id).parent('div.lbl.search-result').addClass('active-msg');
			}
            resizeWindow();
        },
        error: showError
    });
}

var friend_id = -1;
var conversion_color = "0084ff";
function openChat(id) {
    var chat = document.getElementById('chatmessage')
    if (chat) {
        chat.disabled = false;
        chat.focus();
        friend_id = id;
		// mark as read message
		$('div#user' + id + ' > span.chatname').removeClass('unread-txt');
		$('div#user' + id + ' > span.me').css('color', '#0006');
		$('div#user' + id).parent().children('div.last-message.unread-txt').removeClass('unread-txt');
		var status = $('div#user' + id).attr('status');
        var tb = $('input#chatmessage');
        if (status == '0') {
            tb.attr('disabled', true);
            tb.val('Bạn không thể gửi tin nhắn cho người này');
            tb.attr('style', 'border: 0px none; background-color: transparent');
        }
        else {
            tb.attr('disabled', false);
            tb.val('');
            tb.attr('style', 'display: inherit');            
        }
        $('#chatmessage').css('width', (Math.max(document.documentElement.clientWidth, window.innerWidth || 0) - 510) + 'px');
        if (friend_id != -1) {
            var alias = $('div[id="user' + id + '"] span.chatname').text();
            $('#chatname').text(alias);
        }
        else {
            $('#chatname').text('');
        }
		$('button.jscolor').attr('disabled', friend_id == -1);
        $.ajax({
            url: "controller/index_openchat.php",
            data: { id: id },
            dataType: 'html',
            type: 'GET',
            success: function (response) {
                conversion_color = getCookie('conversion_color');
                $('button.jscolor').css('background-color', '#' + conversion_color);
                var json = $.parseJSON(response);
                $('div#messagePanel').html(json.readMsg);
                var div = document.getElementById("messagePanel");
                if (div) div.scrollTop = div.scrollHeight;
                $('div#messagePanel').append(json.unreadMsg);
            },
            error: showError
        });
    }
}

function sendMessage(txt) {
    var d = new Date();
    var h = checkTime(d.getHours());
    var m = checkTime(d.getMinutes());
    
    if (txt.trim().length > 0) 
        $('div#messagePanel').append('<div class="message-row"><div class="message-content me"><span class="user1" style="background-color: #' + conversion_color + '; border-color: #' + conversion_color + '">' + txt + '</span> <span class="tooltiptext me">' + (h + ":" + m) + '</span></div></div>');
    $('#chatmessage').val('');
	if (txt.trim() == '') return;
    
    $.ajax({
        url: "controller/index_sendmessage.php",
        data: { 
            m: decodeURIComponent(txt.trim().replace('\n', '<br />')),
            f: friend_id,
        },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            // scroll to end
            var div = document.getElementById("messagePanel");
            div.scrollTop = div.scrollHeight;
            // send xong update lai user list
            // searchList();
        },
        error: showError
    });
}

function loadMoreMsg() {
    var count = $('div#search-content').children().length;
    // var count = $('div.lbl.search-result').length;
    if (count < 10) return;
    searchList(count);
}

function changeConversionColor() {
    var cl = $('button.jscolor').css('background-color');
    var cl_int = convertColor(cl);
    $.ajax({
        url: "controller/index_changecolor.php",
        data: { id: friend_id, c: cl_int },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            $('span.user' + response).attr('style', 'background-color: ' + cl + '; border-color: ' + cl);
            // console.log(response);
        },
        error: showError
    });
}