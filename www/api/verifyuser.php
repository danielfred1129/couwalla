<?php
	
	include("dbconnection.php");
	
	$loginid = $_GET['id'];
	
    $query = "SELECT * FROM user_profile WHERE loginid = '$loginid';";
    $result = mysql_query($query);
    if(mysql_num_rows($result) > 0) {
		$updateSQL = "UPDATE user_profile
		SET hasverified = '1'
		WHERE loginid = '$loginid';";
		$updateResult = mysql_query($updateSQL);
		die('Your account has been verified with success. You may now use Couwalla.');
    } else {
        die('This account could not be found.');
    }	

?>