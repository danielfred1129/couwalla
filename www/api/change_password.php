<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');

include("dbconnection.php");

error_reporting(E_ALL);

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
//echo"<pre>";
//print_r($alldata);

$userid = $alldata['userid'];
$old_pwd = $alldata['oldPassword'];
$new_pwd = $alldata['newPassword'];
$arrResponse = array();
if ($userid != "" && $old_pwd != "" && $new_pwd != "") {
    $query = "SELECT password FROM user_profile WHERE id = '$userid'";
    $result = mysql_query($query);
    $row = mysql_fetch_assoc($result);
    

    if ($row['password'] == $old_pwd) {
       
        $update_query = mysql_query("update user_profile SET password ='$new_pwd' WHERE id=$userid") or die("error");
        
        if($update_query){
            $arrResponse = array('response' => 'Success', 'message' => 'Password Changed Successfully');
        }
    } else {
        $arrResponse = array('response' => 'Failure', 'message' => 'Old password Not Matching');
    }
} else {
    $arrResponse = array('response' => 'Failure', 'message' => 'Insufficiant Information');
}

echo json_encode($arrResponse);
?>