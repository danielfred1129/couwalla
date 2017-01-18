	
<!-- 		<input type="button" value="reward" id="test" onclick="executeapi()" />
		 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>  -->
 <script>
    
             /*  $('#test').click(function(){

               

                // colect data
                var data = {"platformname": "Q2Intel","platformkey": "/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU="};

                // this line just for testing
                alert(' will send : ' + $.param( data ) );   

                // do JSONP request
                $.ajax({
                   type: "GET",
                   url: "https://api.tangocard.com/raas/v1/rewards",
                   dataType: "json",
                   data: $.param(data),
					success: function(data) {
						alert("AdfasfSA");
						alert(data);
					}
                });
            }); */ 
/* 
            $('#test').click(function() {
			//alert("asdfswer");
                    $.ajax({
                        type: "GET", 
                        url: "https://api.tangocard.com/raas/v1/accounts/amit/amit123",
                        dataType: "json",
                        success: function(response) { alert(response); },
                        error: function(xhr, ajaxOptions, thrownError) { alert(xhr.responseText); }
                    });
                });
			 */
			/* function executeapi()
			{
				//alert("asdfas");
			  var url = "https://api.tangocard.com/raas/v1/accounts/amit/amit123";
			   //alert(url);
			   var req = new XMLHttpRequest();			   
				req.open('GET', url , true);
				req.setRequestHeader("Content-type","application/json");
				req.setRequestHeader("Accept","*"); 
				req.setRequestHeader("platformname","Q2Intel");
				req.setRequestHeader("platformkey","/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU=");
				req.onreadystatechange = function () 
				{					
					if (req.readyState == 4) 
					{
					   alert(req.responseText);
						//JQuerygetuserdetails(req.responseText)
					}
				};
				req.send(null);
			}  */ 

 </script>
<?php
			 /* $request = array(
                'Platform_Name'  => "Q2Intel",
                'Platform_Key'  => "/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU="
            ); */
			$request = array(
                'Platform_Name'  => "amittest",
                'Platform_Key'  => "1AiptEtn5shtt53pK5q3I2RZjbH8Z+mBD+16KU2UHAEoBr089Kl192Wf02Q="
            );
            //print_r($request);
			//exit;
            // encode the request as a JSON object
            $requestJsonEncoded = json_encode($request);
			
$caCertPath = __DIR__ . "/ssl/cacert.pem";
//echo $caCertPath;
//exit;
			//exit;
				$cred = base64_encode('Q2Intel:/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU=');
				
				$ch = curl_init();
                curl_setopt($ch, CURLOPT_URL            , 'https://api.tangocard.com/raas/v1/rewards');
                curl_setopt($ch, CURLOPT_PORT           , 443);
                curl_setopt($ch, CURLOPT_VERBOSE        , 0);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER , 1);
                curl_setopt($ch, CURLOPT_HTTPGET           , true);
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST     , 'GET');
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST , 2);
                curl_setopt($ch, CURLOPT_CAINFO         , $caCertPath);
				curl_setopt($ch, CURLOPT_HTTPHEADER     , array('Authorization: Basic '.$cred,'Content-Type: application/json; charset=utf-8'));
                
                // make the request and get the response
                $responseJsonEncoded = curl_exec($ch);
                //echo $responseJsonEncoded;
				$res = json_decode($responseJsonEncoded);
				echo "<pre>";
				print_r($res);
				echo "</pre>";
				//echo $res->success;
                exit;
				echo "<pre>";
				foreach($res->brands as $r){
					
					print_r($r);					
					//echo "<br>".$r->description;
				}
				echo "</pre>";



/* 
		 $ch = curl_init();		
				
		curl_setopt_array($ch, array(
			 CURLOPT_HTTPHEADER => array('app_username="Q2Intel", app_password="/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU="'), 
			CURLINFO_HEADER_OUT    => true,
			CURLOPT_SSL_VERIFYPEER => true,
			CURLOPT_HTTPGET => true,
			CURLOPT_CUSTOMREQUEST => 'GET',						
			CURLOPT_VERBOSE => true, 
			CURLOPT_CAINFO =>  __DIR__ . '/ssl/cacert.pem',
			CURLOPT_URL => 'https://api.tangocard.com/raas/v1/accounts/amit/amit123?username="Q2Intel"&password="/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU="'
		));
		$res = curl_exec($ch); */
		
		//print_r($res);
		//if (false === curl_exec($ch)) {
		//	echo "Error while loading page: ", curl_error($ch), "\n";
		//}  
		
		
	
?>