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
				$('input#usr, input#pwd').on('keyup', function(e) {
					$('div.login-message').text('');
					if (e.keyCode == 13) {
						flogin();
					}
				});
				$('input#searchtb').on('keyup', function(e) {
					$('div.login-message').text('');
					if (e.keyCode == 13) {
						searchList();
					}
				});
				$('textarea#chatmessage').on('keyup', function(e) {
					$('div.login-message').text('');
					if (e.keyCode == 13) {
						sendMessage();
					}
				});
			});
		</script>
