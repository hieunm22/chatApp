<?php
    $sql = "select * from `users`";
    $query = mysqli_query($con, $sql);
    while ($row = mysqli_fetch_array($query)) {
        if (!file_exists('users/'.$row["id"])) {
            mkdir('users/'.$row["id"], 0777, true);
            $myfile = fopen("users/".$row['id'].'/index.php', "w") or die("Unable to open file!");
            $txt = "
<html>
    <head>
        <title>".$row['alias']."</title>
    </head>
    <body>
    </body>
</html>";
            fwrite($myfile, $txt);
            fclose($myfile);
        }
    }
?>