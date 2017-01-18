<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');

include("dbconnection.php");


if (isset($_REQUEST['data'])) {
    $data = $_REQUEST['data'];
    $data = stripslashes($data);
    $alldata = json_decode($data, true);

    
    $email = $alldata['username'];
    $google_id = $alldata['password'];

    if ($google_id != "" && $email != "") {
        $query = "SELECT * FROM user_profile WHERE google_id = '$google_id'";
        $result = mysql_query($query);
		$row = mysql_fetch_assoc($result);
		
        $count = mysql_num_rows($result);
        if ($count > 0) {
            $data = array(
                "id" => $row['id'],
                "name" => $row['firstname'] . " " . $row['lastname'],
                "email" => $row['email']
            );
            $arrResponse = array('response' => 'Success', 'message' => 'Authentication Success', "data" => $data);
            //$arrResponse = array('response' => 'failure', 'message' => 'User All-ready Exists');
        } else {
            $query = mysql_query("INSERT INTO user_profile (email,google_id) VALUES ('$email','$google_id')");
            $arrResponse = array('response' => 'Success', 'message' => 'Your Account Created Successfully please login To Continue');
        }
    } else {
        $arrResponse = array('response' => 'failure', 'message' => 'Insufficiant information');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}

echo json_encode($arrResponse);
?>