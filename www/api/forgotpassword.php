<?php

/* Database Connection */
//$con = mysql_connect('localhost', 'couwallausr', 'nMKd7iCpz5gMsU') or die ('MySQL Error.');
//mysql_select_db('couwalladb', $con) or die('MySQL Error.');

include("dbconnection.php");

error_reporting(E_ALL);

$email = $_POST['username'];

//echo"<pre>";
//print_r($alldata);

if ($email != "") {
    $query = "SELECT password FROM user_profile WHERE email = '$email'";
    $result = mysql_query($query);
    $row = mysql_fetch_assoc($result);
    $count = mysql_num_rows($result);

    if ($count > 0) {
        $password = $row['password'];

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
		$mail->Subject = 'Your Couwalla Account PIN';
		$mail->Body = "Your Couwalla PIN: <strong>$password</strong>";
		$mail->AddAddress($email);
		$mail->Send();

        
        $arrResponse = array('response' => 'Success', 'message' => 'Email Sended Successfully');
    } else {

        $arrResponse = array('response' => 'Failure', 'message' => 'Check Your Login Credentials');
    }
} else {
    $arrResponse = array('response' => 'failure', 'message' => 'Insufficient Information');
}



echo json_encode($arrResponse);
?>