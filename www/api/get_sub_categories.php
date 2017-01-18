<?php

error_reporting(E_ALL);
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);

$category_id = $alldata['category_id'];

if ($category_id != "") {
    $query = "SELECT id, category_name FROM category where status = '1' AND parent_id='$category_id'";
    $res = mysql_query($query);
    $count = mysql_num_rows($res);

    if ($count > 0) {
        while ($row = mysql_fetch_assoc($res)) {
            $subcategory_data[] = array(
                "id" => $row["id"],
                "category_name" => $row["category_name"]
            );
            $arrResponse["data"] = $subcategory_data;
        }
    } else {
        $arrResponse = array('response' => 'failure', 'message' => 'No data available');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid Data passed');
}
echo json_encode($arrResponse);
?>