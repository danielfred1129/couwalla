
<?php

include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$qrtext = $alldata['qrtext'];


//Run our query
$store_result = mysql_query("SELECT * FROM stores WHERE qr_code = '$qrtext'");
$count = mysql_num_rows($store_result);


$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";

if ($count > 0) {
    while ($store_row = mysql_fetch_assoc($store_result)) {
        $result = mysql_query("SELECT companyname FROM customer WHERE id = $store_row[customer]");

        $row = mysql_fetch_assoc($result);
        $Data[] = array(
            "storeid" => $store_row["id"],
            "storename" => $store_row["storename"],
            "customer" => $row["companyname"],
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
    $arrResponse['data'] = $Data;
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data found');
}
echo json_encode($arrResponse);
?>