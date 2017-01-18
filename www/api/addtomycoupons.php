<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['userid'];
$coupon_id = $alldata['couponid'];

if ($user_id != "" && $coupon_id != "") {
    $select_query = mysql_query("SELECT * FROM my_coupons WHERE couponid='$coupon_id' AND userid='$user_id'");
    if(mysql_num_rows($select_query) >= 1) {
        $arrResponse = array('response' => 'failure', 'message' => 'Coupon already added');
    } else {
        $insert_query = mysql_query("INSERT INTO my_coupons(couponid,userid) VALUES ('$coupon_id','$user_id')");
        if ($insert_query) {
            $arrResponse = array('response' => 'Success', 'message' => 'Coupon Added Successfully');
        }
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>