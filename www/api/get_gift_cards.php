<?php

/* Database Connection */
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$user_id = $alldata['user_id'];


if ($user_id != "") {
    $arrResponse = array();
    $giftcard_data = array();
    $user_query = "SELECT * FROM user_profile WHERE id = '$user_id'";
    $user_res = mysql_query($user_query);
    $count = mysql_num_rows($user_res);
    $user_result = mysql_fetch_assoc($user_res);
    

    $giftcard_query = mysql_query("SELECT * FROM gift_cards WHERE reward_points <= $user_result[points]");
    
    while ($giftcard_result= mysql_fetch_array($giftcard_query)) {
        $giftcard_data[] = array(
            "id" => $giftcard_result["id"],
            "card_name" => $giftcard_result["card_name"],
            "description" => $giftcard_result["description"],
            "image_url" => $giftcard_result["image_url"],
            "reward_points" => $giftcard_result["reward_points"],
            "reward_price" => $giftcard_result["reward_price"],
            "reward_min_price" => $giftcard_result["reward_min_price"],
            "reward_max_price" => $giftcard_result["reward_max_price"],
        );        
    }
    $arrResponse['data'] = $giftcard_data;
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid data Provided');
}
echo json_encode($arrResponse);
?>