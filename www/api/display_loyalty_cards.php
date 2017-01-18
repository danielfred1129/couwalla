<?php
/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');
include("dbconnection.php");
   $data = $_REQUEST['data'];
      if( isset($data))
	  {
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
	//echo"<pre>";
	//print_r($alldata);
	
		$userid= $alldata['userid'];
		$cardid= $alldata['cardid'];
		
		$query = "SELECT gift_cards.name, gift_cards.fullimage,gift_cards.validtill FROM gift_cards , my_gift_cards WHERE gift_cards.id = my_gift_cards.gift_cardid  AND userid = $userid";
		$res = mysql_query($query);
		$count = mysql_num_rows($res);
		//$result = mysql_fetch_array($res);

           while($result = mysql_fetch_assoc($res))
            {
			$name = $result['name'];
			$fullimage = $result['fullimage'];
			$validtill = $result['validtill'];
			
			$Data[] = array(
			'gift_card_name'=>$name,
			'fullimage'=>$fullimage,
			'validtill'=>$validtill
			
			);
			 
			$arrResponse = $Data;
			echo  json_encode($arrResponse);
                    }		   
					 
			}else
			{
			
			$arrResponse = array('response' => 'Failure', 'message' => 'No Data Available');
			echo  json_encode($arrResponse);
			}
		

	

?>