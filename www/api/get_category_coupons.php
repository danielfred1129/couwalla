<?php

/* Database Connection */
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$category_id = $alldata['category_id'];

$couponquery = "SELECT * FROM coupons";
$couponres = mysql_query($couponquery);
$count = mysql_num_rows($couponres);

$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
//$coupon_data = array();
if ($count > 0) {
    $arrResponse = array();

    while ($coupon_result = mysql_fetch_array($couponres)) {
        $category = explode(",", $coupon_result['category']);

        foreach ($category as $cat) {
            if ($cat == $category_id) {
                $store = mysql_query("SELECT storename FROM stores where id in ($coupon_result[store_name])") or die('store err');
                $str1 = array();
                while ($str = mysql_fetch_assoc($store)) {
                    $str1[] = $str['storename'];
                }
                $customer = mysql_query("SELECT companyname FROM customer where id = $coupon_result[customer_name]") or die('cust err');
                $cust = mysql_fetch_assoc($customer);

                $coupon_data[] = array(
                    "id" => $coupon_result["id"],
                    "name" => $coupon_result["name"],
                    "category" => $coupon_result["category"],
                    "description" => $coupon_result["description"],
                    "customer_name" => $cust['companyname'],
                    "store_name" => $str1,
                    "code_type" => $coupon_result["code_type"],
                    "coupon_description" => $coupon_result["coupon_description"],
                    "coupon_thumbnail" => $thumb_path . $coupon_result["coupon_thumbnail"],
                    "coupon_image" => $upload_path . $coupon_result["coupon_image"],
                    "promo_text_short" => $coupon_result["promo_text_short"],
                    "promo_text_long" => $coupon_result["promo_text_long"],
                    "launch_date" => $coupon_result["launch_date"],
                    "expiry_date" => $coupon_result["expiry_date"],
                    "savings" => $coupon_result["savings"],
                    "downloads" => $coupon_result["downloads"],
                    "limit" => $coupon_result["limit"],
                    "type" => $coupon_result["type"]
                );
            }
        }			
    }
    $arrResponse['data'] = $coupon_data;
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>