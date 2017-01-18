<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$user_id = $alldata['userid'];

if ($user_id != "") {
    $query = "SELECT DISTINCT coupon_id FROM planner where user_id = '$user_id' ";
    $res = mysql_query($query);
    $count = mysql_num_rows($res);

    $upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
    $thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";

//    $coupon_data = array();

    if ($count > 0) {
//        $arrResponse = array();
        while ($row = mysql_fetch_assoc($res)) {
            $couponid = $row['coupon_id'];
            $query = "SELECT * FROM coupons WHERE id = '$couponid'";
            $res1 = mysql_query($query);
            while ($result = mysql_fetch_array($res1)) {
                $str1 = array();
                $store = mysql_query("SELECT storename FROM stores where id in ($result[store_name])");

                while ($str = mysql_fetch_assoc($store)) {
                    $str1[] = $str['storename'];
                }
                $customer = mysql_query("SELECT companyname FROM customer where id = $result[customer_name]");
                $cust = mysql_fetch_assoc($customer);

                $coupon_data[] = array(
                    "id" => $result["id"],
                    "name" => $result["name"],
                    "description" => $result["description"],
                    "customer_name" => $cust['companyname'],
                    "store_name" => $str1,
                    "code_type" => $result["code_type"],
                    "coupon_description" => $result["coupon_description"],
                    "coupon_thumbnail" => $thumb_path . $result["coupon_thumbnail"],
                    "coupon_image" => $upload_path . $result["coupon_image"],
                    "promo_text_short" => $result["promo_text_short"],
                    "promo_text_long" => $result["promo_text_long"],
                    "launch_date" => $result["launch_date"],
                    "expiry_date" => $result["expiry_date"],
                    "savings" => $result["savings"],
                    "downloads" => $result["downloads"],
                    "limit" => $result["limit"],
                    "type" => $result["type"]
                );
                //print_r($arrResponse);			
            }

            $arrResponse["data"] = $coupon_data;
        }
    } else {
        $arrResponse = array('response' => 'failure', 'message' => 'No data available');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid Data passed');
}
echo json_encode($arrResponse);
?>