<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['user_id'];
$giftcard_id = $alldata['giftcard_id'];
$date = date("Y-m-d");

if ($user_id != "" && $giftcard_id != "") {
    $giftcard_result = mysql_query("SELECT reward_points FROM gift_cards where id = '$giftcard_id'") or die('coupon err');
    $giftcard_row = mysql_fetch_assoc($giftcard_result);

    $user_result = mysql_query("SELECT points FROM user_profile where id = '$user_id'") or die('user err');
    $user_row = mysql_fetch_assoc($user_result);


//    $sel_query = mysql_query("SELECT * FROM points_transactions WHERE user_id='$user_id' AND giftcard_id = '$giftcard_id'");
//
//    if (mysql_num_rows($sel_query) > 0) {
//        $arrResponse = array('response' => 'failure', 'message' => 'Giftcard already redeemed');
//    } else {
    
    $insert_query = mysql_query("INSERT INTO points_transactions(giftcard_id,user_id,point_removed, created_date) VALUES ('$giftcard_id','$user_id','$giftcard_row[reward_points]', '$date' )");
    if ($insert_query) {
        $total_points = $user_row['points'] - $giftcard_row['reward_points'];
        $update_query = mysql_query("UPDATE user_profile SET points = '$total_points' WHERE id= '$user_id'") or die('user err');
        //$delete_query = mysql_query("DELETE FROM my_coupons WHERE userid='$user_id' AND couponid = '$giftcard_id'") or die('my coupon err');
        $arrResponse = array('response' => 'Success', 'message' => 'Gift Card Redeemed Successfully');
    }
    
//    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid Data');
}
echo json_encode($arrResponse);
?>