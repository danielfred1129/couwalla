<?php
		
	    $message = '<p>You have successfully signed up for Couwalla; to confirm your account please <a href="http://54.213.185.193/api/verifyuser.php?id='.$loginid.'">click here</a></p>';	

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
		$mail->Subject = 'Couwalla Account Confirmation';
		$mail->Body = $message;
		$mail->AddAddress('');
		$mail->Send();	

?>