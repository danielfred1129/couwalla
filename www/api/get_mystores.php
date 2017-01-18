<?php

include("dbconnection.php");

$user_id = safedata($_POST['user_id']);

$mystore_query = "SELECT DISTINCT storeid FROM my_stores where userid = '$user_id';";

$mystore_res = mysql_query($mystore_query);
$count = mysql_num_rows($mystore_res);

$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";

if($count > 0) {

    $arrResponse = array();
	$store_data = array();
	
    while($mystore_row = mysql_fetch_array($mystore_res)) {
        
        $store_id = $mystore_row['storeid'];
        $store_query = "SELECT * FROM stores WHERE id = '$store_id';";
        $store_res = mysql_query($store_query);
		
		if(mysql_num_rows($store_res) > 0) {
	        
	        while($store_result = mysql_fetch_array($store_res)) {
				
	            $cust_result = mysql_query("SELECT companyname FROM customer WHERE id = $store_result[customer]");
	            $cust_row = mysql_fetch_array($cust_result);
	
	            $store_data[] = array(
	                "storeid" => $store_result["id"],
	                "storename" => $store_result["storename"],
	                "customer" => $cust_row["companyname"],
	                "checkinpoints" => $store_result["checkinpoints"],
	                "storenumber" => $store_result["storenumber"],
	                "storephone" => $store_result["store_phone"],
	                "storethumbnail" => $thumb_path . $store_result["thumbnailimage"],
	                "storeimage" => $upload_path . $store_result["storeimage"],
	                "address" => str_replace("%", " ", $store_result["address"]),
	                "qr_code" => "https://api.scandit.com/barcode-generator/v1/qr/$store_result[qr_code]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_",
	                "zip" => $store_result["zip"],
	                "latitude" => $store_result["latitude"],
	                "longitude" => $store_result["longitude"]
	            );
	        }
						
		}
    }
    
    $arrResponse['data'] = $store_data;
    
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>