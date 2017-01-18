
<?php

include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$retailer_id = $alldata['retailer_id'];
//Run our query
$retailer_result = mysql_query("SELECT customer FROM stores  WHERE id = '$retailer_id'");
$retailer_row = mysql_fetch_assoc($retailer_result);

$coupon_result = mysql_query("SELECT * FROM coupons WHERE store_name like '%$retailer_id%' AND customer_name = '$retailer_row[customer]' ");
$count = mysql_num_rows($coupon_result);


$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";

if ($count > 0) {
    $coupon_data = array();
    while ($coupon_row = mysql_fetch_assoc($coupon_result)) {
        $str1 = array();
        $store = mysql_query("SELECT storename FROM stores where id IN ($coupon_row[store_name])");

        while ($str = mysql_fetch_assoc($store)) {
            $str1[] = $str['storename'];
        }
        $customer = mysql_query("SELECT companyname FROM customer where id = $coupon_row[customer_name]");
        $cust = mysql_fetch_assoc($customer);

        $coupon_data[] = array(
            "id" => $coupon_row["id"],
            "name" => $coupon_row["name"],
            "description" => $coupon_row["description"],
            "customer_name" => $cust['companyname'],
            "store_name" => $str1,
            "code_type" => $coupon_row["code_type"],
            "coupon_description" => $coupon_row["coupon_description"],
            "coupon_thumbnail" => $thumb_path . $coupon_row["coupon_thumbnail"],
            "coupon_image" => $upload_path . $coupon_row["coupon_image"],
            "promo_text_short" => $coupon_row["promo_text_short"],
            "promo_text_long" => $coupon_row["promo_text_long"],
            "launch_date" => $coupon_row["launch_date"],
            "expiry_date" => $coupon_row["expiry_date"],
            "savings" => $coupon_row["savings"],
            "downloads" => $coupon_row["downloads"],
            "limit" => $coupon_row["limit"],
            "type" => $coupon_row["type"]
        );
    }

    $arrResponse['data'] = $coupon_data;
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data found');
}
echo json_encode($arrResponse);
?>