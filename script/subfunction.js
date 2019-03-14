/**
 * các actions tại client khi mở 1 conversion
 * @param fid id của người đang chat
 * @param doNotClearText biến cờ xác định có xoá textbox chat khi mở 1 cuộc hội thoại hay không
 */
function openChatPrepare(fid, doNotClearText) {
    current_connect = fid;
    // mark selected conversion as read
    $('div#user' + fid + ' > span.me').css('color', '#0006');
    var usr_chat = document.getElementById('user' + fid);
    if (!usr_chat) return;
    var findUnread = $(usr_chat.parentElement).find('.unread-txt')
    if (findUnread.length > 0) findUnread.removeClass('unread-txt');
    
    // chat textbox enabled status via status property
    var status = usr_chat.getAttribute('status');
    if (status == '0') {
        chatTB.disabled = true;
        chatTB.value = 'Bạn không thể gửi tin nhắn cho người này';
        $('#sendmessage').addClass('hidden');
    }
    else {
        chatTB.disabled = false;
        if (!doNotClearText) chatTB.value = '';
        chatTB.focus();
        $('#sendmessage').removeClass('hidden');
    }

    $('a#row3').attr('href', 'profile.php?id=' + current_connect);
    $('a#row3').attr('target', '_blank');
    $('a._30yy').css('display', 'inherit')
}
/**
 * load message từ response message trả về
 * @param jsonstr object json server trả về
 */
function loadMessageFromServer(jsonstr) {
    currentConversion.friendName = jsonstr.friendname;
    currentConversion.display_fr = jsonstr.display_fr;
    currentConversion.meName = jsonstr.mename;
    currentConversion.display_me = jsonstr.display_me;
    currentConversion.conversion_color = jsonstr.conversion_color;
    // load những message có trạng thái đã đọc lên trước
    msgPN.innerHTML = jsonstr.readMsg;
    // cuộn xuống dưới cùng
    msgPN.scrollTop = msgPN.scrollHeight;
    // load những message chưa đọc lên sau
    msgPN.innerHTML += jsonstr.unreadMsg;
    // xoá seen icon
    var msgstt = $('._4jzq._jf5:not(:last)');
    if (msgstt.length > 0) msgstt.css('display', 'none');
    // chat textbox enabled status via status property
    changeConversionObjectsColor();
    chatTB.focus();
    $('#chatname').text(currentConversion.display_fr);

    setTitle();
    // xoá avatar friend ở message panel, giữ lại avatar cuối cùng
    var friend_row = $('img.avatar-friend').closest('.message-row');
    friend_row.each(function (index) {
        var avatar_friend = this.querySelector('img.avatar-friend');
        if (index >= friend_row.length - 1)
            return;
        var avatar_next = this.nextElementSibling.querySelector('img.avatar-friend');
        if (avatar_next && avatar_next.src == avatar_friend.src) {
            avatar_friend.style = "display: none";
            var msg = this.querySelector('.user2');
            msg.classList.add('msg-no-avatar');
        }
    });
    
}
/**
 * load kết quả search từ response message trả về
 * @param {*} jsonstr object json server trả về
 */
function searchOnLoad(jsonstr){
    $('div#search-content').html(jsonstr.search);
    setTitle();
}
/**
 * xử lý các sự kiện ở client và response trả về khi người dùng click mở 1 conversion
 * @param {*} jsonstr object json server trả về
 */
function loadMessageOnLoad(jsonstr) {
    if (!jsonstr) return;
    openChatPrepare(+jsonstr.fid, true);
    loadMessageFromServer(jsonstr);
}