<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin_Model extends CI_Model {

   function __construct() {
        // Call the Model constructor
        parent::__construct();
         $this->load->database(); 
    }


	 public function displayusers() {
		$this->load->database();
		$query = $this->db->get('users');
		//$query = $this->db->query('select * from users');
		//print_r($query);
        return $query->result_array();
      
    }


	 public function add_new_user($data) {
	    $this->load->database();
	    $res = $this->db->insert('users', $data); 
		return 1;
        }

     public function add_new_customer($data) {
	    $this->load->database();
	    $res = $this->db->insert('customer', $data); 
		return 1;
        }

     public function displaycustomers() {
		$this->load->database();
		$query = $this->db->get('customer');
		//$query = $this->db->query('select * from users');
		//print_r($query);
        return $query->result_array();
      
    }

	 public function delete_users($data1) {
	    $this->load->database();
		$id = $data1['id'];
		echo "$id";
		  $this->db->delete('users', array('id' => $id));
		  return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
		   
		   }

		public function delete_customers($data1) {
	    $this->load->database();
		$id = $data1['id'];
		$this->db->delete('customer', array('id' => $id));
		return ($this->db->affected_rows() > 0) ? TRUE : FALSE;

		}

		public function displaystores() {
		$this->load->database();
		
		$query = $this->db->get('stores');
		//$query = $this->db->query('select * from users');
		//print_r($query);
		
        return $query->result_array();
      
        }

		public function add_new_store($data) {
	    $this->load->database();
	    $res = $this->db->insert('stores', $data); 
		return ($this->db->affected_rows() > 0) ? true : false;
		//return 1;
        }

		public function delete_stores($data1) {
	    $this->load->database();
		echo $id = $data1['id'];
		$this->db->delete('stores', array('id' => $id));
		return ($this->db->affected_rows() > 0) ? TRUE : FALSE;

		}


		public function show_userprofile($data) 
			{
				$this->load->database();
			    $id = $data['id'];
				$query = $this->db->query('select * from users where id = '.$data['id'].'');
				$res = $query->result_array();
				return $res;
				//print_r($res);
				exit;
                return $query;

            }


			public function update_user($data) 
			{

				//print_r($data);
				$id = $data['id'];
				$data1 = array(
				'username' => $data['username'],
				'firstname' => $data['firstname'],
				'lastname' => $data['lastname'],
				'email' => $data['email'],
				'contact_info' => $data['contactno'],
				
				);
				
				$this->load->database();
                $res = $this->db->where('id', $id);
                $res =  $this->db->update('users', $data1); 
				return $res;
				//print_r($res);
				//exit;

				//return $query;

            }


	
		


    }


