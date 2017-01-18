<?php
	
	include("dbconnection.php");
	$coupon_id = safedata($_GET['couponid']);
	
	$query = "SELECT * FROM coupons WHERE id = '$coupon_id'";
	$coupon_res1 = mysql_query($query);
	while($coupon_result = mysql_fetch_array($coupon_res1)) {
		die($coupon_result['terms_conditions']);
	}

?>