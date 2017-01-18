<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['userid'];
$coupon_id = $alldata['couponid'];

if ($user_id != "" && $coupon_id != "") {
    $insert_query = mysql_query("INSERT INTO planner(coupon_id,user_id) VALUES ('$coupon_id','$user_id')");
    if ($insert_query) {
        $arrResponse = array('response' => 'Success', 'message' => 'Coupon Added to planner Successfully');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>