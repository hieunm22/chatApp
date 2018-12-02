
		<div id="search-list">
			<input type="text" id="searchtb" placeholder="Tìm kiếm" autofocus="true" />
			<div id="search-content"></div>
		</div>
		<div id="chatmain">
            <div id="conversionName">
				<?php include('include/index_conversioninfo.php'); ?>
            </div>
            <div id="messagePanel"></div>
            <textarea id="chatmessage" placeholder="Nhập tin nhắn..." disabled></textarea>
            <input type="button" id="sendmessage" value="Gửi" />
        </div>

        <?php include('include/index_script.php'); ?>
