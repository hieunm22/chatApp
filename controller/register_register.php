<?php
    include('../default.php');
    session_start();

    $usr = $_REQUEST['u'];
    $usr = str_replace("'","\\'",$usr);
    $eml = $_REQUEST['e'];
    $eml = str_replace("'","\\'",$eml);
    // $sql = "SELECT * FROM users where name='".$usr."' or (email='".$eml."' and '".$eml."'!='')'";
    $sql = "SELECT * FROM users where name='".$usr."'";
    if ($eml !== '') {
        $sql .= " or email='".$eml."'";
    }
	$query = mysqli_query($con, $sql);
	$rowcount = mysqli_num_rows($query);
    if ($rowcount == 0) {
        $ali = $_REQUEST['a'];
        $ali = str_replace("'","\\'",$ali);
        $pho = $_REQUEST['f'];
        $pho = str_replace("'","\\'",$pho);
        $pwd = $_REQUEST['p'];
        $pwd = str_replace("'","\\'",$pwd);

        // $sql = "Call insertUser('".$usr."', '".md5($pwd)."', '".$eml."', '".$ali."', '".$pho."')";
        $sql = "Call insertUser('".$usr."', '".md5($pwd)."'";
        if (!isset($eml) || trim($eml)==='') {
            $sql .= ", null";
        }
        else {
            $sql .= ", '".$eml."'";
        }
        if (!isset($ali) || trim($ali)==='') {
            $sql .= ", null";
        }
        else {
            $sql .= ", '".$ali."'";
        }
        if (!isset($pho) || trim($pho)==='') {
            $sql .= ", null";
        }
        else {
            $sql .= ", '".$pho."'";
        }
        $sql .= ")";
        $query = mysqli_query($con, $sql);

        $sql = "select * from `users` where `name`='".$usr."'";
        $query = mysqli_query($con, $sql);
		$row = mysqli_fetch_array($query);
        $_SESSION['user'] = $row;
        if (!file_exists('../users/'.$row["name"])) {
            mkdir('../users/'.$row["name"], 0777, true);
            $myfile = fopen("../users/".$row['name'].'/index.php', "w") or die("Unable to open file!");
            $txt = "<html>
    <head>
        <title>".$row['alias']."</title>
    </head>
    <body>
    </body>
</html>";
            fwrite($myfile, $txt);
            fclose($myfile);
        }
        echo 0; // đăng ký thành cmn công
    }
    else {
        $sql = "SELECT * FROM users where name='".$usr."'";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount == 1) {
            echo 1; // trùng username
            return;
        }
        $sql = "SELECT * FROM users where email='".$eml."'";
        $query = mysqli_query($con, $sql);
        $rowcount = mysqli_num_rows($query);
        if ($rowcount == 1) {
            echo 2; // trùng email
        }
    }
?>