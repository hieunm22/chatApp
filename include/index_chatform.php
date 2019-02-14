
		<div id="search-list">
         <input type="text" id="searchtb" placeholder="Tìm kiếm" />
         <span id="clear-text" class="hidden"></span>
			<div id="search-content"></div>
		</div>
		<div id="chatmain">
            <div id="conversionName">
				<?php include('include/index_conversioninfo.php'); ?>
            </div>
            <div id="messagePanel"></div>
            <textarea id="chatmessage" placeholder="Nhập tin nhắn..." disabled autofocus="true"></textarea>
            <!-- <img src="images/send-icon.png" alt="Send message" id="sendmessage" /> -->
            <a href="#" id="sendmessage">Gửi</a>
         </div>

   <?php include('include/index_script.php'); ?>
