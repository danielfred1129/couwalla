<?php

error_reporting(E_ALL);
include("dbconnection.php");


$query = "SELECT id, category_name FROM category where status = '0' ";
$res = mysql_query($query);
$count = mysql_num_rows($res);

if ($count > 0) {
    while ($row = mysql_fetch_assoc($res)) {
        $sub_query = "SELECT id, category_name FROM category where status = '1' AND parent_id='$row[id]'";
        $sub_res = mysql_query($sub_query);
        $subcategory_data = array();
        while ($result = mysql_fetch_assoc($sub_res)) {
            $subcategory_data[] = array(
                "id" => $result["id"],
                "name" => $result["category_name"]
            );
        }
        array_unshift($subcategory_data, array(
            "id" => $row["id"],
            "name" => "All ". $row["category_name"])
        );
        $category_data[] = array(
//            "id" => $row["id"],
            "name" => $row["category_name"],
            "children" => $subcategory_data
        );
    }
    $arrResponse = $category_data;
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>