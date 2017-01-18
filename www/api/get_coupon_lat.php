<?php
	
	include("dbconnection.php");
	$coupon_id = safedata($_GET['couponid']);
	
	$query = "SELECT * FROM coupons WHERE id = '$coupon_id'";
	$coupon_res1 = mysql_query($query);
	while($coupon_result = mysql_fetch_array($coupon_res1)) {
		$storeID = $coupon_result['store_name'];
		$storeDetailSQL = "SELECT storename,latitude,longitude,address FROM stores WHERE id IN($coupon_result[store_name]);";
		$storeDetailResult = mysql_query($storeDetailSQL);
		while($store_result = mysql_fetch_array($storeDetailResult)) {
			die(json_encode(array('store_name' => $store_result['storename'], 'lat' => $store_result['latitude'], 'lng' => $store_result['longitude'], 'address' => $store_result['address'])));
		}
	}

?>