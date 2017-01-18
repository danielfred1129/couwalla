<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Login_Model extends CI_Model {

    function __construct() {
        // Call the Model constructor
        parent::__construct();
//        $this->load->database(); 
    }

    public function loginvalidate($username, $password) {
		
		
		$where = array('username'=>$username,'password'=>$password);
		
	    $query = $this->db->get_where('users', $where);
      

	    if ($query->num_rows == 1) {
			
         // If there is a user, then create session data
            $row = $query->row();
            $data = array(
                'userid' => $row->id,
                'name' => $row->firstname . " " . $row->lastname,
                'email' => $row->email,
                'validated' => true
            );
			
			
            $abc = $this->session->set_userdata($data);
		
            return true;
        }
        // If the previous process did not validate
        // then return false.
        return false;
    }

    public function emailvalidate($email) {

		$where = array('email'=>$email,'enabled'=>1);
	    $query = $this->db->get_where('users', $where);

        if ($query->num_rows == 1) {
		   $row = $query->row();
		  // $pass = $row->password;
           echo  $arrpwd = 1;
            

        $this->send_password($row->password,$email);
            
        } else {
            $arrpwd = 0;
        }
        return $arrpwd;
    }
    
    function send_password($password,$email)
    {
        //send email with password.
        $to      = $email;
        $subject = 'Account on  Couwalla details';
        $message = " Your Password is: ".$password;  

        // To send HTML mail, the Content-type header must be set
        $headers  = "MIME-Version: 1.0" . "\r\n";
        $headers .= "Content-type: text/html; charset=iso-8859-1" . "\r\n";

        // Additional headers
        $headers .= "To: <$email> ". "\r\n";
        $headers .= "From:Couwalla" . "\r\n";

        // Mail it

        if (mail($to, $subject, $message, $headers))
        return 1;

    }


	

}
