<?php

/* Database Connection */
include("dbconnection.php");

$data = $_REQUEST['data'];
$data = stripslashes($data);
$alldata = json_decode($data, true);
$user_id = $alldata['userid'];

$query = "SELECT * FROM user_profile where id = '$user_id' ";
$res = mysql_query($query);
$count = mysql_num_rows($res);

if ($count > 0) {
    $arrResponse = array();

    while ($result = mysql_fetch_assoc($res)) {        
            $user_data[] = array(
                "id" => $result["id"],
                "First Name" => $result["firstname"],
                "Last Name" => $result["lastname"],
                "Email" => $result['email'],
                "Sex" => $result['gender'],
                "DOB" => $result["dob"],
                "Ethnicity" => $result["ethenticity"],
                "Marital Status" => $result["marital_status"],
                "State" => $result["state"],
                "Zip" => $result["zip"],
                "No. of Children" => $result["no_of_childerns"],
                "Have Pets" => $result["have_pets"],
                "Yearly Income" => $result["yearly_income"]
            );
        $arrResponse['data'] = $user_data;
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
}
echo json_encode($arrResponse);
?>