
<?php

include("dbconnection.php");

//Run our query
if ($_REQUEST['data']) {
    $data = $_REQUEST['data'];
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
    $user_id = $alldata['userid'];

    if ($user_id != "") {
        $user_result = mysql_query("SELECT id,latitude,longitude FROM user_profile WHERE id = '$user_id'");
        $user_row = mysql_fetch_assoc($user_result);

        $lat = $user_row['latitude'];
        $long = $user_row['longitude'];

        $store_result = mysql_query("SELECT * , SQRT(POW(69.1 * (latitude - $lat), 2) + POW(69.1 * ($long - longitude) * COS(latitude / 57.3), 2)) AS distance FROM stores HAVING distance < 5 ORDER BY distance") or die("sql error");
        $count = mysql_num_rows($store_result);

        $upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
        $thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
        $coupon_data = array();
        if ($count > 0) {
            while ($store_row = mysql_fetch_assoc($store_result)) {
                $coupon_result = mysql_query("SELECT * FROM coupons WHERE store_name like '%$store_row[id]%' AND customer_name = '$store_row[customer]' ");
                while ($coupon_row = mysql_fetch_assoc($coupon_result)) {
                    $str1 = array();
                    $store = mysql_query("SELECT storename,latitude,longitude,address,description,thumbnailimage FROM stores where id in ($coupon_row[store_name])");

                    while ($str = mysql_fetch_assoc($store)) {
                        $str1[] = array(
                            "storename" => $str['storename'],
                            "latitude" => $str['latitude'],
                            "description" => $str['description'],
                            "storethumbnail" => $thumb_path . $str['thumbnailimage'],
                            "address" => str_replace("+", " ", str_replace("%", ",", $str['address'])),
                            "longitude" => $str['longitude']
                        );
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
            }
            $arrResponse['data'] = $coupon_data;
        } else {
            $arrResponse['data'] = array('response' => 'failure', 'message' => 'No data Available');
        }
    } else {
        $arrResponse['data'] = array('response' => 'failure', 'message' => 'Invalid Data');
    }
} else {
    $arrResponse['data'] = array('response' => 'failure', 'message' => 'Invalid Request');
}

echo json_encode($arrResponse);
?>