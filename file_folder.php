<?php
    $sql = "select * from `users`";
    $query = mysqli_query($con, $sql);
    while ($row = mysqli_fetch_array($query)) {
        $myfile = fopen("users/".$row['name'].'/index.php', "w") or die("Unable to open file!");
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
?>