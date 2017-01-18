<?php

/* Database Connection */
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$user_id = $alldata['userid'];
$category_id = $alldata['category_id'];

$query = "SELECT DISTINCT couponid FROM my_coupons where userid = '$user_id'";
$mycoupon_res = mysql_query($query);
$count = mysql_num_rows($mycoupon_res);

$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
$coupon_data = array();
if ($count > 0) {
    $arrResponse = array();

    while ($mycoupon_row = mysql_fetch_assoc($mycoupon_res)) {
        if (!empty($category_id)) {
            $coupon_id = $mycoupon_row['couponid'];
            $query = "SELECT * FROM coupons WHERE id = '$coupon_id'";
            $coupon_res1 = mysql_query($query);
            while ($coupon_result = mysql_fetch_array($coupon_res1)) {
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
						$coupon_expire_time = strtotime($coupon_result['expiry_date']);
						if($coupon_expire_time > time()) {
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
	                            "terms_conditions" => $coupon_result["terms_conditions"],
	                            "type" => $coupon_result["type"]
	                        );														
						}
                    }
                }
            }
            $arrResponse['data'] = $coupon_data;
        } else {
            $coupon_id = $mycoupon_row['couponid'];
            $query = "SELECT * FROM coupons WHERE id = '$coupon_id'";
            $res1 = mysql_query($query);
            while ($result = mysql_fetch_array($res1)) {
                $str1 = array();
                $store = mysql_query("SELECT storename FROM stores where id in ($result[store_name])");

                while ($str = mysql_fetch_assoc($store)) {
                    $str1[] = $str['storename'];
                }
                $customer = mysql_query("SELECT companyname FROM customer where id = $result[customer_name]");
                $cust = mysql_fetch_assoc($customer);


                $barcode_image = "";
                if ($result['code_type'] == "barcode") {
                    if ($result['bar_type'] != "qr") {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                    } else if ($result['bar_type'] != 'code128') {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                    } else if ($result['bar_type'] != 'code39') {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                    } else if ($result['bar_type'] != 'itf') {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                    } else if ($result['bar_type'] != 'ean8') {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                    } else if ($result['bar_type'] != 'ean13') {
                        $barcode_image = "https://api.scandit.com/barcode-generator/v1/$result[bar_type]/$result[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200";
                    }
                }
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
                    "type" => $result["type"],
                    "barcode_image" => $barcode_image
                );
                //print_r($arrResponse);			
            }
        }

        $arrResponse['data'] = $coupon_data;
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>