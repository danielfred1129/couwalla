<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');

include("dbconnection.php");
$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
//echo"<pre>";
//print_r($alldata);


$password = $alldata['password'];
$loginid = $alldata['loginid'];

if ($loginid != "" && $password != "") {
    $query = "SELECT * FROM user_profile WHERE loginid = '$loginid' AND password = '$password';";
    $result = mysql_query($query);
    $row = mysql_fetch_assoc($result);

    $count = mysql_num_rows($result);
    if ($count > 0) {
        $data = array(
            "id" => $row['id'],
            "name" => $row['firstname'] . " " . $row['lastname'],
            "email" => $row['email'],
            "loginid" => $row['loginid'],
            "points" => $row['points'],
        );
        $arrResponse = array('response' => 'Success', 'message' => 'Authentication Success', "data" => $data);
    } else {
        $arrResponse = array('response' => 'Failure', 'message' => 'Check your login credentials. You may have also forgotten to activate your account.');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Insufficient Information');
}



echo json_encode($arrResponse);
?>