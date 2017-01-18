<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');
include("dbconnection.php");


if (isset($_REQUEST['data'])) {
    $data = $_REQUEST['data'];
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
    //echo"<pre>";
    //print_r($alldata);

    $firstname = isset($alldata['First Name']) ? $alldata['First Name'] : '';
    $lastname = isset($alldata['Last Name']) ? $alldata['Last Name'] : '';
    $email = isset($alldata['Email']) ? $alldata['Email'] : '';
    $gender = isset($alldata['Sex']) ? $alldata['Sex'] : '';
    $dob = isset($alldata['DOB']) ? $alldata['DOB'] : '';
    $ethenticity = isset($alldata['Ethnicity']) ? $alldata['Ethnicity'] : '';
    $state = isset($alldata['State']) ? $alldata['State'] : '';
    $zip = isset($alldata['Zip']) ? $alldata['Zip'] : '';
    
    $noofchild = isset($alldata['No. of Children']) ? $alldata['No. of Children'] : '';
    $havepet = isset($alldata['Have Pets']) ? $alldata['Have Pets'] : '';
    $yearlyincome = isset($alldata['Yearly Income']) ? $alldata['Yearly Income'] : '';
    $maritalstatus = isset($alldata['Marital Status']) ? $alldata['Marital Status'] : '';
    $userid = isset($alldata['userid']) ? $alldata['userid'] : '';
    
    if ($userid != "") {
        
        //echo "UPDATE user_profile SET firstname=$firstname,lastname=$lastname,password=$password,email = $email,gender=$gender,dob=$dob,ethenticity=$ethenticity,state=$state,zip=$zip WHERE  id = $id;";
        $sqlQuery = " UPDATE user_profile SET ";

        $sqlQuery .=" firstname= '$firstname' ";

        if ($lastname) {
            $sqlQuery .=", lastname='$lastname' ";
        }
        if ($gender) {
            $sqlQuery .=", gender='$gender' ";
        }
        if ($ethenticity) {
            $sqlQuery .=", ethenticity='$ethenticity' ";
        }
        if ($zip) {
            $sqlQuery .=", zip='$zip' ";
        }
        if ($state) {
            $sqlQuery .=", state='$state' ";
        }
       if ($noofchild) {
           $sqlQuery .=", no_of_childerns='$noofchild' ";
       }
       if ($havepet) {
           $sqlQuery .=", have_pets='$havepet' ";
       }
       if ($yearlyincome) {
           $sqlQuery .=", yearly_income='$yearlyincome' ";
       }

       if ($maritalstatus) {
           $sqlQuery .=", marital_status='$maritalstatus' ";
       }
       if ($email) {
           $sqlQuery .=", email='$email' ";
       }
       if ($dob) {
           $sqlQuery .=", dob='$dob' ";
       }
        $sqlQuery .=" WHERE id=$userid";
        $query = mysql_query($sqlQuery) or die('update error');

        $arrResponse = array('response' => 'success', 'message' => 'User Updated Successfully');
    } else {
        $arrResponse = array('response' => 'failure', 'message' => 'Invalid data send');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Invalid request');
}
echo json_encode($arrResponse);
?>