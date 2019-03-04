<div id="none"></div>
<div id="chatname"></div>
<div id="empty"></div>
<div id="colorpicker">
	<a class="_30yy" style="display:none">
		<div style="height: 32px; width: 32px;">
			<svg viewBox="0 0 64 64" style="stroke: #0084ff;">
				<g>
					<polygon points="34,44 34,29 34,28 30,28 28,28 28,29 30,29 30,44 28,44 28,45 30,45 34,45 36,45 36,44" style="fill: #0084ff;"></polygon>
					<circle cx="32" cy="22" r="3" style="fill: #0084ff;"></circle>
				</g>
				<path d="M32,11c11.6,0,21,9.4,21,21s-9.4,21-21,21s-21-9.4-21-21S20.4,11,32,11z" style="fill: none; stroke: #0084ff; stroke-miterlimit: 10; stroke-width: 2;"></path>
			</svg>
		</div>
	</a>
</div>
	<?php
		include('include/index_modalbox.php');
		include('include/index_editnickname.php');
	?>
	<div id="myDropdown" class="dropdown-content">
		<a class="dropdown-row" id="row1" aria-label="Conversation color" role="button" aria-expanded="true" data-testid="info_panel_button" data-toggle="modal" data-target="#myModal1">Đổi màu cuộc hội thoại</a>
		<a class="dropdown-row" id="row2" aria-label="Edit nick names" role="button" aria-expanded="true" data-testid="info_panel_button" data-toggle="modal" data-target="#myModal2">Đổi nick name</a>
		<a class="dropdown-row" id="row3">Xem trang cá nhân</a>
	</div>