<script type="text/javascript">
				var currentLoaded = 0;
				var user_id = <?php echo $_SESSION["user"]["id"] ?>;
				var ws = new WebSocket("ws://localhost:8080/");
				$(document).ready(function(){
					// document.cookie = 'conversion_color=0084ff';
					ws.onopen = function(e) {
				};
				ws.onerror = function(e) {
					// Errorhandling
				}
				ws.onmessage = function(e)
				{
					// nhận message ở đây
					var json = JSON.parse(e.data);
					if (json.sender_id != user_id) {
						// load message here
						$('#messagePanel').append('<div class="message-row"><div class="message-content friend"><span class="msg-status"><span class="_4jzq _jf5" style="display: none;"><img class="_jf2 img" src="' + json.avatar + '"></span></span> <img class="avatar-friend" src="' + json.avatar + '" width="30px" height="30px"><span class="user2">' + json.txt + '</span> <span class="tooltiptext friend">' + json.msgtime + '</span></div></div>');
						var div = document.getElementById("messagePanel");
						div.scrollTop = div.scrollHeight;
					}
					else {						
						// sending -> sent
						$('span.msg-status:last').html('<span class="_2her" style="color:#' + conversion_color + '" title="Sent"><i aria-label="Sent" aria-roledescription="Status icon" class="_57e_" role="img"></i></span>');
					}
					searchList();
				}
				// Events
				$('title').text('Home');
				$(window).resize(resizeWindow);
                searchList(0);
				$('input#searchtb').on('keyup', function(e) {
					searchList();
				});
				$('#chatmessage').on('keyup', function(e) {
					if (e.keyCode == 13) {
						var txt = $('#chatmessage').val();
						sendMessage(txt, ws);
					}
				});
				// $('#chatmessage').bind('input propertychange', function() {
					// $('textarea').height(Math.min(this.scrollHeight, 120));
				// });
				$('input#sendmessage').on('click', function(e) {
					var txt = $('#chatmessage').val();
					sendMessage(txt, ws);
				});
				$('div#search-content').delegate('div.lbl.search-result, div.lbl.search-result-text', 'click', function() {
					$('div.lbl.search-result').removeClass('active-msg');
					$('div.lbl.search-result-text').removeClass('active-msg');
					this.classList.add('active-msg');
					var id = this.querySelector('div.username-search').id.substr(4);
					openChat(+id, ws);
				});
                $('div#search-content').scroll(function() {
                    if (this.scrollTop == this.scrollHeight - this.clientHeight) {
                        loadMoreMsg();
                    }
                });
                $('td.dot').on('click', changeConversionColor);
				$('#myModal1').on('show.bs.modal', function () {
					checkConversionColor();
				});
				$('#myModal2').on('show.bs.modal', function () {
					loadNickNames();
				});
				$('a._30yy').on('click', function () {
					showDropDown();
				});
				$('a#save-nickname').on('click', function () {
					changeNickNames();
				});
				$('input[type="text"]#nickname1, input[type="text"]#nickname2').on('click', editnickname);
			});
            // setInterval(function() {
                // searchList();
                // var currentFocus = $('.active-msg > div.username-search').attr('id');
                // if (currentFocus && currentFocus.substr(4) == friend_id) {
                    // openChat(friend_id, true);
                // }
            // }, 1500);
		</script>