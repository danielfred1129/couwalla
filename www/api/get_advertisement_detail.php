
<?php

include("dbconnection.php");
/* Login API 
  Takin input name to fetch data from db
  Created On 12/october/2013
 */
$arrResponse = array();

$banner_image = safedata(str_replace("http://" . $_SERVER['SERVER_NAME'] . "/uploads/", "", $_POST['image_url']));

//$con = mysql_connect('localhost', 'couwallaadmin', 'Sdws!^65') or die ('MySQL Error.');
//mysql_select_db('couwalla', $con) or die('MySQL Error.');
//Run our query
$advrt_result = mysql_query("SELECT * FROM advertisements WHERE banner_image = '$banner_image';");
$count = mysql_num_rows($advrt_result);

//$userRow = mysql_fetch_assoc($result);	
$upload_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/";
//$thumb_path = "http://" . $_SERVER['SERVER_NAME'] . "/uploads/thumb/";
if ($count > 0) {
    while ($advrt_row = mysql_fetch_assoc($advrt_result)) {
        $coupon_result = mysql_query("SELECT name FROM coupons where id = '$advrt_row[coupon]'");
        $coupon_row = mysql_fetch_assoc($coupon_result);
        
        $cust_result = mysql_query("SELECT companyname FROM customer where id = '$advrt_row[customer]'");
        $cust_row = mysql_fetch_assoc($cust_result);
        
        $advert_data[] = array(
            "id" => $advrt_row["id"],
            "advert_name" => $advrt_row["advert_name"],
            "description" => $advrt_row["description"],
            "add_text" => $cust['add_text'],
            "valid_from" => $advrt_row["valid_from"],
            "valid_till" => $advrt_row["valid_till"],
            "banner_image" => $upload_path . $advrt_row["banner_image"],
            "reward_points" => $advrt_row["reward_points"],
            "customer" => $cust_row["companyname"],
            "adv_type" => $advrt_row["adv_type"],
            "hyperlink" => $advrt_row["hyperlink"],
            "coupon" => $coupon_row["name"]
        );
    }
    $arrResponse['data'] = $advert_data;
} else {
    $arrResponse['data'] = array('response' => 'failure', 'message' => 'No data found');
}

echo json_encode($arrResponse);
?>