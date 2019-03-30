<?php
set_time_limit(0);

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;
// require_once 'c:/xampp/vendor/autoload.php';	// windows
require_once '/opt/lampp/vendor/autoload.php';	// ubuntu, linux

class Chat implements MessageComponentInterface {
	protected $clients;
	protected $users;

	public function __construct() {
		$this->clients = new \SplObjectStorage;
	}

	public function onOpen(ConnectionInterface $conn) {
		$this->clients->attach($conn);
		// $this->users[$conn->resourceId] = $conn;
	}

	public function onClose(ConnectionInterface $conn) {
		$this->clients->detach($conn);
		// unset($this->users[$conn->resourceId]);
	}

	public function onMessage(ConnectionInterface $from,  $data) {
		$from_id = $from->resourceId;
		$data = json_decode($data);
		$frommsg = $data->frommsg;
		$tomsg = $data->tomsg;
		$sender_id = $data->sender_id;
		$txt = $data->txt;
		$msgtime = $data->msgtime;
		$avatar = $data->avatar;
		// Output
		$from->send(json_encode(array("txt"=>$txt,"sender_id"=>$sender_id,"msgtime"=>$msgtime,"avatar"=>$avatar,"frommsg"=>$frommsg,"tomsg"=>$tomsg)));
		foreach($this->clients as $client)
		{
			// send to clients
			if($from!=$client)
			{
				$client->send(json_encode(array("txt"=>$txt,"sender_id"=>$sender_id,"msgtime"=>$msgtime,"avatar"=>$avatar,"frommsg"=>$frommsg,"tomsg"=>$tomsg)));
			}
		}
	}

	public function onError(ConnectionInterface $conn, \Exception $e) {
		$conn->close();
	}
}
$server = IoServer::factory(
	new HttpServer(new WsServer(new Chat())),
	8080
);
$server->run();
?>
