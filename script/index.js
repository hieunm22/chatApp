var currentConversion = new Object();
/**
 * load search list và open conversion đã được chọn từ trước
 * @param {*} sendSocketAfterComplete biến cờ xác định có send socket message sang các clients khác không
 */
function searchUsersAndLoadMessage(sendSocketAfterComplete) {
    $.ajax({
        url: "controller/index_searchandload.php",
        // data: { t: txt },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            if (response == '')
                return;
            var json = $.parseJSON(response);
            // load search
            searchOnLoad(json);
            // load message
            loadMessageOnLoad(json.load);
            if (sendSocketAfterComplete) ws.send(
                JSON.stringify({
                    'frommsg': 'search_user',
                    'tomsg': 'set_message_status',  // mark as received/mark as read
                    'sender_id': user_id,
                    'txt': "",
                    'msgtime': "",
                    'avatar': ""
                })
            );
        },
        error: showError
    });

}
/**
 * sự kiện click vào 1 conversion trên search list để mở cuộc hội thoại
 * @param {*} fid id của friend trong cuộc trò chuyện đó
 * @param {*} sendSocketAfterComplete biến cờ xác định có send socket message sang các clients khác không
 */
function openChatClick(fid, sendSocketAfterComplete) { 
    openChatPrepare(fid);
    $.ajax({
        url: "controller/index_openchat.php",
        data: { fid: fid, cur: current_connect },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            var json = $.parseJSON(response);
            loadMessageFromServer(json);
            if (sendSocketAfterComplete) ws.send(
                JSON.stringify({
                    'frommsg': 'search_user',
                    'tomsg': 'set_message_status',  // mark as received/mark as read
                    'sender_id': user_id,
                    'txt': "",
                    'msgtime': "",
                    'avatar': ""
                })
            );
        },
        error: showError
    });
}
/**
 * load search list
 * @param {*} sendSocketAfterComplete biến cờ xác định có send socket message sang các clients khác không
 */
function searchUsers(sendSocketAfterComplete) {
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
            searchOnLoad(json);            
            // gửi socket hành động search list sang các clients khác: mark as received/mark as read
            if (sendSocketAfterComplete) ws.send(
                JSON.stringify({
                    'frommsg': 'search_user',
                    'tomsg': 'set_message_status',  // mark as received/mark as read
                    'sender_id': user_id,
                    'txt': "",
                    'msgtime': "",
                    'avatar': ""
                })
            );
        },
        error: showError
    });
}
/**
 * send message
 * @param {*} sendSocketAfterComplete biến cờ xác định có send socket message sang các clients khác không
 */
function sendMessage(txt, ws) {
    if (!txt) return;
    txt = txt.trim().replaceAll('\n' ,'<br />');
    
    var d = new Date();
    var h = checkTime(d.getHours());
    var m = checkTime(d.getMinutes());

    $.ajax({
        url: "controller/index_sendmessage.php",
        data: {
            m: decodeURIComponent(txt),
            f: current_connect,
        },
        dataType: 'html',
        type: 'GET',
        success: function (response) {
            var json = JSON.parse(response);
            // load search
            searchOnLoad(json);
            // load message
            loadMessageOnLoad(json.load);
            // bắt buộc send để các client update content mới được gửi lên từ client hiện tại
			ws.send(
				JSON.stringify({
                    'frommsg': 'sent_message',
                    'tomsg': 'receive_message',
					'sender_id': user_id,
					'txt': txt,
					'msgtime': (h + ":" + m),
					'avatar': json.avatar
				})
			);
        },
        error: showError
    });
}