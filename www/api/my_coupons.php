<?php
/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');
include("dbConnection.php");
   $data = $_REQUEST['data'];
    //$data = stripslashes($data);
    $alldata = json_decode($data, true);
	
	echo"<pre>";
	print_r($alldata);
	exit;
   
     echo $email = $alldata['email'];
	
	
	
	
	    
			if($email != "" )
			{
				
				
				$query1 = "SELECT * FROM coupons WHERE name = '$coupon_name'";
				$result1 = mysql_query($query1);
				$row1 = mysql_fetch_array($result1);
				$coupon_id = $row1['id'];echo "<br>";
				
				$query = mysql_query("SELECT DISTINCT id,FROM mycoupon");
				
				while($res = mysql_fetch_assoc($query);)
				{
				echo $res['id'];
				}
				exit;
				 $arrResponse = array('response' => 'Success', 'message' => 'Coupon Added Successfully');
					
			   }else
			     {
			
			        $arrResponse = array('response' => 'failure', 'message' => 'No data available');
			     }
			
		

echo  json_encode($arrResponse);	

?>