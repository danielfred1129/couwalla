<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['userid'];
$coupon_id = $alldata['couponid'];

if ($user_id != "" && $coupon_id != "") {
    $delete_planner_query = mysql_query("DELETE FROM planner WHERE coupon_id='$coupon_id' AND user_id='$user_id'");
    if ($delete_planner_query) {		
        $arrResponse = array('response' => 'Success', 'message' => 'Coupon Removed Successfully');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid Data');
}
echo json_encode($arrResponse);
?>