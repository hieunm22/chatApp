		<script type="text/javascript">
			$(document).ready(function(){
				$(window).resize(resizeWindow);
				$('input#usr, input#pwd').on('keyup', function(e) {
					$('div.login-message').text('');
				});
			});
		</script>