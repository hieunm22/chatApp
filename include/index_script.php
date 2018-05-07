<?php
	if (!isset($_SESSION['user'])) {
		echo "
		<script type=\"text/javascript\">
			$(document).ready(function(){
				$(window).resize(resizeWindow);
				$('input#usr, input#pwd').on('keyup', function(e) {
					$('div.login-message').text('');
				});
			});
		</script>";
	}
	else {
		$user = $_SESSION['user'] === null ? $_SESSION['user']['name'] : $_SESSION['user']['alias'];
		echo "
		<script type=\"text/javascript\">
            var currentLoaded = 0;
			$(document).ready(function(){
                // document.cookie = 'conversion_color=#0084ff';
				$('title').text('Home');
				$(window).resize(resizeWindow);
                searchList();
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
				$('div#search-content').delegate('div.lbl.search-result', 'click', function() {
					$('div.lbl.search-result').removeClass('active-msg');
					this.classList.add('active-msg');
					var id = this.querySelector('div').id.substr(4);
					openChat(+id);
				});
                $('div#search-content').scroll(function() {
                    if (this.scrollTop == this.scrollHeight - this.clientHeight) {
                        loadMoreMsg();
                    }
                });
			});
		</script>
		";	
	}
?>


