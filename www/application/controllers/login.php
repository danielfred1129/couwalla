<?php
ini_set('error_reporting', E_ALL);
error_reporting(E_ALL);
ini_set('display_errors', 1);
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Login extends CI_Controller {

    function __construct() {
        parent::__construct();
//        $this->load->database(); 
        $this->load->model('login_model', 'loginmodel');
    }

    public function index($msg = NULL) {
        $data['msg'] = $msg;

        $this->load->view('login', $data);
		
		
    }

    public function processlogin() {
        // echo "in controller";
        $username = $this->input->post('username');
        //$password = md5($this->input->post('password'));
        $password = $this->input->post('password');
        $result = $this->loginmodel->loginvalidate($username, $password);
        if (!$result) {
            $msg = 'Invalid username and/or password.';
            $this->index($msg);
        } else {
            
            redirect('admin');
        }
    }

    public function forgotpwd(){
          $email = $this->input->post('email');
        $data['result'] = $this->loginmodel->emailvalidate($email);
            $this->load->view('ajxForgotPwd', $data);
        
    }
    
    public function do_logout() {
        $array_items = array('user_id' => '', 'username' => '', 'validated' => FALSE);
        $this->session->unset_userdata($array_items);
        $this->session->unset_userdata();
        $this->session->sess_destroy();
        redirect('login');
    }

}
