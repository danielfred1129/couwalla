<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');

ob_start();

include("dbconnection.php");


if (isset($_REQUEST['data'])) {
    $data = $_REQUEST['data'];
    $data = stripslashes($data);
    $alldata = json_decode($data, true);
    //echo"<pre>";
    //print_r($alldata);

    $firstname = $alldata['firstname'];
    $lastname = $alldata['lastname'];
    $password = $alldata['password'];
    $loginid = $alldata['loginid'];
    $email = $alldata['email'];
    $gender = $alldata['gender'];
    $dob = $alldata['dob'];
    $ethenticity = $alldata['ethenticity'];
    $state = $alldata['state'];
    $zip = $alldata['zip'];

    if ($password != "" && $email != "") {
        
        $query = "SELECT * FROM user_profile WHERE email = '$email'";
        $result = mysql_query($query);
        $count = mysql_num_rows($result);
        
        if($count > 0) {
            
            $arrResponse = array('response' => 'failure', 'message' => 'This user is already registered.');
            //echo json_encode($arrResponse);
			
		} else {
        
            $to = $email;
            $subject = 'Welcome to Couwalla!';
            $message = '<p>Dear Couwalla User,</p><p>Thank you for signing up for couwalla. The only application that brings you a mobile coupons and a digital wallet.</p><p>Please enjoy the offers we currently have and participate in some short surveys.</p><p>Thanks,<br /> The Couwalla Team</p>';

            $headers = "MIME-Version: 1.0" . "\r\n";
            $headers .= "Content-type: text/html; charset=iso-8859-1" . "\r\n";

            //Additional headers
            $headers .= "To: Couwalla User<$to> " . "\r\n";
            $headers .= "From: couwalla  <no-reply@couwalla.com>" . "\r\n";
			
            //mail($to, $subject, $message, $headers);
            
            $query = mysql_query("INSERT INTO user_profile (firstname,lastname,email,loginid,gender,dob,ethenticity,state,zip,password, hasverified) VALUES ('$firstname', '$lastname', '$email', '$email', '$gender', '$dob', '$ethenticity', '$state', '$zip', '$password', '1')") or die("insert err");
            
            $arrResponse = array('response' => 'Success', 'message' => 'Your account has been created with success.');

            include('PHPMailer/class.phpmailer.php');
			$mail = new PHPMailer();
			$mail->IsSMTP(); // enable SMTP
			$mail->SMTPDebug = 0;
			$mail->SMTPAuth = true;
			$mail->SMTPSecure = 'ssl';
			$mail->Host = "smtp.gmail.com";
			$mail->Port = 465;
			$mail->IsHTML(true);
			$mail->Username = "No-reply@couwalla.com";
			$mail->Password = "nrcouwalla1";
			$mail->SetFrom('no-reply@couwalla.com');
			$mail->Subject = 'Thank you for signing up for Couwalla';
			$mail->Body = $message;
			$mail->AddAddress($email);
			$mail->Send();

            //echo json_encode($arrResponse);
        }
        
    } else {

        $arrResponse = array('response' => 'failure', 'message' => 'Insufficient information');
    }
    
} else {

    $arrResponse = array('response' => 'failure', 'message' => 'No data available');
    
}

	$myFile = "test/jayrequest.txt";
	$fh = fopen($myFile, 'a+') or die("can't open file");
	$stringData = "Request: " . serialize($alldata) . "\n\n";
	fwrite($fh, $stringData);
	$stringData = "Response: " . serialize($arrResponse) . "\n\n";
	fwrite($fh, $stringData);
	fclose($fh);

echo json_encode($arrResponse);

?>