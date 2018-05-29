var unreadCount = 0;
function searchList(loaded) {
	var text = $('#searchtb').val();
    $.ajax({
        url: "controller/index_search.php",
        data: { t: text, l: (loaded | 0) },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			// hiển thị kết quả tìm kiếm
            if (response == '')
                return;
            var json = $.parseJSON(response);
			if (loaded != undefined) {
				$('div#search-content').append(json.html);
            }
			else {
				$('div#search-content').html(json.html);
				unreadCount = 0;
			}
			unreadCount += json.unread;
			if (unreadCount > 0)
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
var friendName = '';
var meName = '';
var disFr = '';
var disMe = '';
var conversion_color = "0084ff";
function openChat(id) {
    var chat = document.getElementById('chatmessage')
    if (chat) {
        chat.disabled = false;
        chat.focus();
        friend_id = id;

		if ($('div#user' + id + ' > span.chatname').hasClass('unread-txt')) unreadCount--;
		if (unreadCount > 0)
			$('title').text('(' + unreadCount + ') Home');
		else
			$('title').text('Home');
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
		$('a#row3').attr('href', 'profile.php?id=' + friend_id);
		$('a#row3').attr('target', '_blank');
        $.ajax({
            url: "controller/index_openchat.php",
            data: { id: id },
            dataType: 'html',
            type: 'GET',
            success: function (response) {
                conversion_color = getCookie('conversion_color');
				$('a._30yy').css('display', 'inline');
				changeConversionObjectsColor();
                var json = $.parseJSON(response);
                $('div#messagePanel').html(json.readMsg);
                var div = document.getElementById("messagePanel");
                if (div) div.scrollTop = div.scrollHeight;
                $('div#messagePanel').append(json.unreadMsg);
				friendName = json.friendname;
				disFr = json.display_fr;
				meName = json.mename;
				disMe = json.display_me;
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
        $('div#messagePanel').append('<div class="message-row"><div class="message-content me"><span class="msg-status"><span class="_2her" style="color:#' + conversion_color + '" title="Sending"></span></span> <span class="user1" style="background-color: #' + conversion_color + '; border-color: #' + conversion_color + '">' + txt + '</span> <span class="tooltiptext me">' + (h + ":" + m) + '</span></div></div>');
    $('#chatmessage').val('');
    // scroll to end
    var div = document.getElementById("messagePanel");
    div.scrollTop = div.scrollHeight;
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
            // sending -> sent
            $('span.msg-status:last').html('<span class="_2her" style="color:#' + conversion_color + '" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>');
            // send xong update lai user list
            $('div#search-content').html(response);
        },
        error: showError
    });
}

function loadMoreMsg() {
    var count = $('div#search-content').children().length;
    // var count = $('div.lbl.search-result').length;
    if (count < 15 || $('input#searchtb').val() != '') return;
    searchList(count);
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
        data: { id: friend_id, c: _intValue },
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
	meElem.value = disMe;
	meElem.placeholder = meName;
	var friendElem = document.getElementById('nickname2');
	// var friendname = $('.active-msg > .username-search > .chatname').text();
	friendElem.value = disFr;
	friendElem.placeholder = friendName;
	$('input[id^="nickname"]').attr('style', '');
}

function changeNickNames() {
	var me = $('input#nickname1').val() || $('input#nickname1').attr('placeholder');
	var fr = $('input#nickname2').val() || $('input#nickname2').attr('placeholder');
    $.ajax({
        url: "controller/index_changenicknames.php",
        data: { fid: friend_id, nick1: me, nick2: fr },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
			// close modal dialog
			// $('#myModal2').modal('toggle');
			$('td#chatname').text(fr);
			$('div#user' + friend_id + ' > span.chatname').text(fr);
			// console.log(response);
        },
        error: showError
    });
}
