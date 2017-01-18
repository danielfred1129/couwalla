
<?php
include("dbconnection.php");
/* Login API 
  Takin input name to fetch data from db
  Created On 12/october/2013
 */
$arrResponse = array();

//$con = mysql_connect('localhost', 'couwallaadmin', 'Sdws!^65') or die ('MySQL Error.');
//mysql_select_db('couwalla', $con) or die('MySQL Error.');

$data = $_REQUEST['data'];
if (isset($data)) {
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
    $zip = $alldata['zip'];
//Run our query
    $result = mysql_query("SELECT * FROM coupons WHERE customer_name IN ( SELECT id FROM customer where zipcode = '$zip')");
    $count = mysql_num_rows($result);

    //$userRow = mysql_fetch_assoc($result);	
    $upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
    $thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
    if ($count > 0) {
        while ($row = mysql_fetch_assoc($result)) {
            $str1 = array();
            /* $stor = explode(",", $row['store_name']);
              $st = implode(",", $stor); */

            $store = mysql_query("SELECT storename,latitude,longitude,address,description,thumbnailimage FROM stores where id in ($row[store_name])");

            while ($str = mysql_fetch_assoc($store)) {
                $str1[] = array(
                    "storename" => $str['storename'],
                    "latitude" => $str['latitude'],
                    "description" => $str['description'],
                    "storethumbnail" => $thumb_path . $str['thumbnailimage'],
                    "address" => str_replace("+", " ", str_replace("%", ", ", $str['address'])),
                    "longitude" => $str['longitude']
                );
            }
            $customer = mysql_query("SELECT companyname FROM customer where id = $row[customer_name]");
            $cust = mysql_fetch_assoc($customer);
            $barcode_image = "";
            if ($row['code_type'] == "barcode") {
                if ($row['bar_type'] != "qr") {                    
                   $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                 } else if ($row['bar_type'] != 'code128') { 
                     $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                 } else if ($row['bar_type'] != 'code39') { 
                     $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                 } else if ($row['bar_type'] != 'itf') { 
                     $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                 } else if ($row['bar_type'] != 'ean8') { 
                     $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                 } else if ($row['bar_type'] != 'ean13') { 
                     $barcode_image =  "https://api.scandit.com/barcode-generator/v1/$row[bar_type]/$row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200";
                }
            }

            $Data[] = array(
                "id" => $row["id"],
                "name" => $row["name"],
                "description" => $row["description"],
                "customer_name" => $cust['companyname'],
                "stores" => $str1,
                "code_type" => $row["code_type"],
                "coupon_description" => $row["coupon_description"],
                "coupon_thumbnail" => $thumb_path . $row["coupon_thumbnail"],
                "coupon_image" => $upload_path . $row["coupon_image"],
                "promo_text_short" => $row["promo_text_short"],
                "promo_text_long" => $row["promo_text_long"],
                "launch_date" => $row["launch_date"],
                "expiry_date" => $row["expiry_date"],
                "savings" => $row["savings"],
                "downloads" => $row["downloads"],
                "limit" => $row["limit"],
                "type" => $row["type"],
                "barcode_image" => $barcode_image
            );
        }
        $arrResponse['data'] = $Data;
    } else {
        $arrResponse['data'] = array('response' => 'failure', 'message' => 'No data found');
    }
}
echo json_encode($arrResponse);
?>