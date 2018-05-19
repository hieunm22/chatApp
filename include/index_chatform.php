
		<div id="search-list">
			<div id="searchbox">
				<input type="text" id="searchtb" placeholder="Tìm kiếm thành viên" autofocus="true" />
			</div>
			<div id="search-content"></div>
		</div>
		<div id="chatmain">
            <div id="conversionName">
                <table border="0" width="100%">
                    <tr>
                        <td id="none" width="33%"></td>
                        <td id="chatname" width="33%" align="center"></td>
                        <td id="colorpicker" width="33%" align="right">
                            <input type="button" data-toggle="modal" data-target="#myModal" style="width: 72px;height: 20px;" disabled ></input>
                            <?php include('include/index_modalbox.php'); ?>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="messagePanel"></div>
            <input type="text" id="chatmessage" placeholder="Nhập tin nhắn..." disabled />
            <input type="button" id="sendmessage" value="Gửi" />
        </div>

        <?php include('include/index_script.php'); ?>
		