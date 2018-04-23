<script type="text/javascript">
			$(document).ready(function(){
				var usrname = '<?php
                    if (!isset($_SESSION['user'])) {
                        echo '';
                    }
                    else {
                        echo ($_SESSION['user'] === null ? $_SESSION['user']['alias'] : $_SESSION['user']['name']);
                    }
                ?>';
                resizeWindow();
                searchList();
				if (usrname !== '') {
					$('title').text('Home');
				}
				$(window).resize(resizeWindow);
				$('input#usr, input#pwd').on('keyup', function(e) {
					$('div.login-message').text('');
					if (e.keyCode == 13) {
						flogin();
					}
				});
				$('input.login').on('click', function(e) {
					flogin();
				});
				$('input#searchtb').on('keyup', function(e) {
					if (e.keyCode == 13) {
						searchList();
					}
				});
				$('input#searchbt').on('click', function(e) {
					searchList();
				});
				$('input#chatmessage').on('keyup', function(e) {
					if (e.keyCode == 13) {
						sendMessage($('#chatmessage').val());
					}
				});
				$('input#sendmessage').on('click', function(e) {
					sendMessage($('#chatmessage').val());
				});
			});
            
            // setInterval(function() { 
                // openChat(friend_id);
            // }, 1000);
		</script>
