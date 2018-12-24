<script type="text/javascript">
				const user_id = <?php echo $_SESSION["user"]["id"] ?>;
				var current_connect = <?php echo ($_SESSION['current_connect'] != null ? $_SESSION['current_connect'] : -1); ?>;
				var msgPN = document.getElementById('messagePanel');
				var chatTB = document.getElementById('chatmessage');
				var ws = new WebSocket("ws://localhost:8080");
				ws.onopen = function(e) {
				};
				ws.onerror = function(e) {
					// Errorhandling
				}
				// msgPN.onclick = function(e) {
				// 	// get current chat friend id
				// 	var active_id = $('.active-msg').find('[id*=user]').attr('id').substr(4);
				// 	if (current_connect == active_id) {
				// 		preOpenChatOnLoad(current_connect, false);
				// 	}
				// }
				ws.onmessage = wsReceivedMessage;
				$(document).ready(function(){
					resizeWindow();
					$(window).resize(resizeWindow);
					searchUsersAndLoadMessage();
					$('input#searchtb').on('keyup', function(e) {
						searchUsers(true);
					});
					$('div#search-content').delegate('div.lbl.search-result, div.lbl.search-result-text', 'click', function() {
						$('div.lbl.search-result').removeClass('active-msg');
						$('div.lbl.search-result-text').removeClass('active-msg');
						this.classList.add('active-msg');
						var fid = this.querySelector('div.username-search').id.substr(4);
						openChatClick(+fid, ws);
					});
					$('#chatmessage').on('keyup', function(e) {
						if (e.keyCode == 13) {
							sendMessage(e.currentTarget.value, ws);
						}
					});
					// $('#chatmessage').bind('input propertychange', function() {
						// $('textarea').height(Math.min(this.scrollHeight, 120));
					// });
					$('#sendmessage').on('click', function(e) {
						var txt = chatTB.value;
						sendMessage(txt, ws);
					});

					$('td.dot').on('click', changeConversionColor);
					$('#myModal1').on('show.bs.modal', checkConversionColor);
					$('#myModal2').on('show.bs.modal', loadNickNames);
					$('a._30yy').on('click', showDropDown);
					$('a#save-nickname').on('click', saveNickNames);
					$('input[type="text"]#nickname1, input[type="text"]#nickname2').on('click', editnickname);
				});
		</script>