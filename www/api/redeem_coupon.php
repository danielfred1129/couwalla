<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['userid'];
$coupon_id = $alldata['couponid'];
$date = date("Y-m-d");

if ($user_id != "" && $coupon_id != "") {
    $coupon_result = mysql_query("SELECT reward_points,expiry_date FROM coupons where id = '$coupon_id'") or die('coupon err');
    $coupon_row = mysql_fetch_assoc($coupon_result);

    $user_result = mysql_query("SELECT points FROM user_profile where id = '$user_id'") or die('user err');
    $user_row = mysql_fetch_assoc($user_result);

    if ($coupon_row['expiry_date'] < $date) {
        $arrResponse = array('response' => 'failure', 'message' => 'Coupon Expired');
    } else {
        $sel_query = mysql_query("SELECT * FROM points_transactions WHERE user_id='$user_id' AND coupon_id = '$coupon_id'");

        if (mysql_num_rows($sel_query) > 0) {
            $arrResponse = array('response' => 'failure', 'message' => 'Coupon already redeemed');
        } else {
            $insert_query = mysql_query("INSERT INTO points_transactions(coupon_id,user_id,point_added, created_date) VALUES ('$coupon_id','$user_id','$coupon_row[reward_points]', '$date' )");
            if ($insert_query) {
                $total_points = $user_row['points'] + $coupon_row['reward_points'];
                $update_query = mysql_query("UPDATE user_profile SET points = '$total_points' WHERE id= '$user_id'") or die('user err');
                $delete_query = mysql_query("DELETE FROM my_coupons WHERE userid='$user_id' AND couponid = '$coupon_id'") or die('my coupon err');
                $arrResponse = array('response' => 'Success', 'message' => 'Coupon Redeemed Successfully');
            }
        }
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid Data');
}
echo json_encode($arrResponse);
?>