<?php
/* Database Connection */
/* $con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
mysql_select_db('couwalladb', $con) or die('MySQL Error.'); */
include("dbconnection.php");
   $data = $_REQUEST['data'];
      if( isset($data) )
	  {
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
	//echo"<pre>";
	//print_r($alldata);
	
	
		
	    $userid= $alldata['userid'];
	    $gift_cardid= $alldata['gift_cardid'];
	    $couponid = $alldata['couponid'];
		
		
	//echo "INSERT INTO my_gift_cards(userid,gift_cardid,couponid) VALUES ('$userid','$gift_cardid','$couponid')";
	
			$insert_query = mysql_query("INSERT INTO my_gift_cards(userid,gift_cardid,couponid) VALUES ('$userid','$gift_cardid','$couponid')");
			$arrResponse = array('response' => 'Success', 'message' => 'Gift Card Added Successfully');
					
			 
			}else
			{
			
			$arrResponse = array('response' => 'Failure', 'message' => 'No Data Available');
			
			}
		

echo  json_encode($arrResponse);	

?>