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
/**
 * set title trên trình duyệt
 */
function setTitle() {
    let unreadCount = $('span.chatname.unread-txt').length;
    if (unreadCount > 0) {
        $('title').text('(' + unreadCount + ') ' + (currentConversion.display_fr || "Home"));
        document.getElementById('appIcon').href = "images/YlPmwLaTSI9.ico";
    }
    else {
        $('title').text(currentConversion.display_fr || "Home");
        document.getElementById('appIcon').href = "images/O6n_HQxozp9.ico";
    }
}

function getHexColor(number) {
    return ((number) >>> 0).toString(16).padStart(6, "0");
}

function convertColor(color) {
    var cl = color.substring(4, color.indexOf(')'));
    var rgb = cl.split(', ');
    var ret = 0;
    var mul = 65536;
    rgb.forEach(function (item) {
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
    $('svg').css('stroke', '#' + currentConversion.conversion_color);
    $('polygon').css('fill', '#' + currentConversion.conversion_color);
    $('circle').css('fill', '#' + currentConversion.conversion_color);
    $('path').css('stroke', '#' + currentConversion.conversion_color);
}

function showDropDown() {
    document.getElementById("myDropdown").classList.toggle("show");
    // $('.dropdown-row:hover').attr('style', 'background-color: #' + conversion_color);
}

function changeConversionColor(e) {
    // var _colorIndex = e.target.id.substr(5) - 1;
    var _intValue = convertColor(e.target.style.backgroundColor || e.target.parentElement.style.backgroundColor);
    currentConversion.conversion_color = getHexColor(_intValue);
    $('span.user1').attr('style', 'background-color: #' + currentConversion.conversion_color + '; border-color: #' + currentConversion.conversion_color);
    $('span._2her').css('color', '#' + currentConversion.conversion_color);
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
    $('td.dot[style="background-color: #' + currentConversion.conversion_color + '"]').html('<i class="_gs2 img sp_tRueZ17UPsM sx_4affb5" alt=""></i>');
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
            (response);
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

function wsReceivedMessage(e) {
    var json = JSON.parse(e.data);
    if (json.sender_id == user_id) return;
    // socket message từ các client khác
    var sendSocket = json.tomsg == "receive_message";
    if (json.sender_id != current_connect) {	// message từ người bạn mà máy mình đang không focus vào
        // reload lại search users
        searchUsers(sendSocket);
    }
    else								        // message từ người bạn mà máy mình đang focus vào
    {
        // reload lại search users và load lại message của conversion đó
        searchUsersAndLoadMessage(sendSocket);
    }
}

String.prototype.replaceAll = function (search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
