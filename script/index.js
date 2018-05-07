function searchList(loaded) {
	var text = $('#searchtb').val();
    $.ajax({
        url: "controller/index_search.php",
        data: { t: text, l: (loaded | 0) },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			// console.log(this.responseText);
			// hiển thị kết quả tìm kiếm
			if (loaded)
				$('div#search-content').append(response);
			else
				$('div#search-content').html(response);
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
		$('div#user' + id + ' > span.u1').css('color', '#0006');
		$('div#user' + id).parent().children('div.last-message.unread-txt').removeClass('unread-txt');

        if (friend_id != -1) {
            var alias = $('div[id="user' + id + '"] span.chatname').text();
            $('center').text(alias);
        }
        else {
            $('center').text('');
        }
        $.ajax({
            url: "controller/index_openchat.php",
            data: { id: id },
            dataType: 'html',
            type: 'GET',
            success: function (response) {
                conversion_color = getCookie('conversion_color');
                $('div#messagePanel').html(response);
                var div = document.getElementById("messagePanel");
                if (div) div.scrollTop = div.scrollHeight;
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
        $('div#messagePanel').append('<div class="message-row"><div class="message-content u1"><span class="user1" style="background-color: #' + conversion_color + '; border-color: #' + conversion_color + '">' + txt + '</span> <span class="tooltiptext u1">' + (h + ":" + m) + '</span></div></div>');
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
            searchList();
        },
        error: showError
    });
}

function loadMoreMsg() {
    var count = $('div#search-content').children().length;
    // var count = $('div.lbl.search-result').length;
    if (count < 15) return;
    console.log('loadMoreMsg');  //searchList(count);
}