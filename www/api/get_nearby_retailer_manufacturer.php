
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


        $cust_result = mysql_query("SELECT id,companyname FROM customer WHERE manufacturer = 1 OR retailer = '1'");
        $count = mysql_num_rows($cust_result);


        $upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
        $thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
        $store_data = array();
        if ($count > 0) {
            while ($cust_row = mysql_fetch_assoc($cust_result)) {
                $custid = $cust_row['id'];

                $store_result = mysql_query("SELECT * , SQRT(POW(69.1 * (latitude - $lat), 2) + POW(69.1 * ($long - longitude) * COS(latitude / 57.3), 2)) AS distance FROM stores WHERE customer = $custid HAVING distance < 5 ORDER BY distance") or die("sql error");

                while ($store_row = mysql_fetch_assoc($store_result)) {
                    $store_data[] = array(
						"storeid" => $store_row["id"],
                        "storename" => $store_row["storename"],
                        "customer" => $cust_row["companyname"],
                        "checkinpoints" => $store_row["checkinpoints"],
                        "storenumber" => $store_row["storenumber"],
                        "storephone" => $store_row["store_phone"],
                        "storethumbnail" => $thumb_path . $store_row["thumbnailimage"],
                        "storeimage" => $upload_path . $store_row["storeimage"],
                        "address" => str_replace("%", " ", $store_row["address"]),
                        "qr_code" => "https://api.scandit.com/barcode-generator/v1/qr/$store_row[qr_code]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_",
                        "zip" => $store_row["zip"],
                        "latitude" => $store_row["latitude"],
                        "longitude" => $store_row["longitude"]
                    );
                }
            }
            $arrResponse['data'] = $store_data;
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