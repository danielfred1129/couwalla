<?php
/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');
include("dbConnection.php");
   $data = $_REQUEST['data'];
      if( isset($data) )
	  {
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
	//echo"<pre>";
	//print_r($alldata);
	
	
		$couponid = $alldata['couponid'];
		$userid= $alldata['userid'];
		$cardid= $alldata['cardid'];
		$card_name = $alldata['card_name'];
	
	
			$insert_query = mysql_query("INSERT INTO my_loyalty_cards(couponid,userid,cardid,card_name) VALUES ('$couponid','$userid','$cardid','$card_name')");
			$arrResponse = array('response' => 'Success', 'message' => 'Loyalty Card Added Successfully');
					
			 
			}else
			{
			
			$arrResponse = array('response' => 'Failure', 'message' => 'No Data Available');
			
			}
		

echo  json_encode($arrResponse);	

?>