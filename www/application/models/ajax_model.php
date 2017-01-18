<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Ajax_Model extends CI_Model {

    function __construct() {
        // Call the Model constructor
        parent::__construct();
        $this->load->database();
    }

    public function get_customers($id = NULL) {
        if (isset($id)) {
            $this->db->where('id', $id);
        }
        $query = $this->db->get('customer');
        return $query->result_array();
    }

    public function get_coupon_stores($cust_id = NULL) {
        if (isset($cust_id)) {
            $this->db->where('customer', $cust_id);
        }
        $query = $this->db->get('stores');
//        print_r($query->result());
//        exit;
        return $query->result_array();
    }

    public function get_coupons($cust_id = NULL) {
        if (isset($cust_id)) {
            $this->db->where('customer_name', $cust_id);
        }
        $query = $this->db->get('coupons');
//        print_r($query->result());
//        exit;
        return $query->result_array();
    }

    public function get_pwd($old_pwd,$user_id) {
        $this->db->where('password', $old_pwd);
        $this->db->where('id', $user_id);
        $query = $this->db->get('users');
        
        //exit;
        if($query->num_rows == 1){
           echo $query->num_rows;
        }else{
            echo $query->num_rows;
        }
    }

}

