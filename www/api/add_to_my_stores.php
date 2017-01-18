<?php

include("dbconnection.php");
$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
//echo"<pre>";
//print_r($alldata);


$storeid = $alldata['storeid'];
$userid = $alldata['userid'];

if ($storeid != "" && $userid != "") {
    $insert_query = mysql_query("INSERT INTO my_stores(storeid,userid) VALUES ('$storeid','$userid')");
    $arrResponse = array('response' => 'Success', 'message' => 'Store Added Successfully');
} else {

    $arrResponse = array('response' => 'Failure', 'message' => 'No Data Available');
}

echo json_encode($arrResponse);
?>