<?php
/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');
include("dbconnection.php");

   $data = $_REQUEST['data'];
   if(isset($data))
   {
   // $data = stripslashes($data);
    $alldata = json_decode($data, true);
	//echo"<pre>";
	//print_r($alldata);
	
	 $userid= $alldata['userid'];
	 
	 
	
	$query = "SELECT stores.storename, my_stores.storeid FROM stores  LEFT JOIN my_stores ON stores.id = my_stores.storeid  WHERE userid = $userid";
	$res = mysql_query($query);
	$Data = array();
	while($row = mysql_fetch_array($res))
	{
	 $storename = $row['storename'];
	$storeid = $row['storeid'];
	  $Data[] = array(
						'storeid'=>$storeid,
	                   'storename'=>$storename
                     );
	
	}
	
	 $arrResponse['data'] = $Data;
	
}else
{
 $arrResponse['data'] = array('response'=>'failure','message'=>'No data found');
}	

	
	         if( $storeid !="" && $userid != "" )
	
	       {
	
				 $insert_query = mysql_query("INSERT INTO my_stores(storeid,userid) VALUES ('$storeid','$userid')");
				
				 $arrResponse = array('response' => 'Success', 'message' => 'Store Added Successfully');
					
			 
			}else
			{
			
			$arrResponse = array('response' => 'Failure', 'message' => 'No Data Available');
			
			}
		

echo  json_encode($arrResponse);	

?>