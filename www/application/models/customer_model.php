<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Customer_Model extends CI_Model {

    function __construct() {
        // Call the Model constructor
        parent::__construct();
//        $this->load->database(); 
    }

  public function displaycustomer() {
		$this->load->database();
		$query = $this->db->get('customers');
		//$query = $this->db->query('select * from customers');
		//print_r($query);
        return $query->result_array();
      
    }


	 public function add_new_customer($data) {
		//print_r($data);
		$this->load->database();
	    $res = $this->db->insert('users', $data); 
		return 1;
        }




  

	
}

