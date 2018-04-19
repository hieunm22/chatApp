<?php 
    $sql = "select u.* from users u, user_friends f where u.id=f.friendid and `userid`='".$_SESSION['user']['id']."' order by f.friendid";
	$query = mysqli_query($con, $sql);
    echo '<ul>';
	while ($row = mysqli_fetch_array($query)) {
        echo '<li><a href="profile.php?id='.$row['id'].'">'.$row['alias'].'</li>';
	}
    echo '</ul>';
?>