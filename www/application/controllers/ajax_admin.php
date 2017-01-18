<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');
/* Author: Jorge Torres
 * Description: Home controller class
 * This is only viewable to those members that are logged in
 */

class Ajax_admin extends CI_Controller {

    function __construct() {
        parent::__construct();
        //$this->check_isvalidated();
        $this->load->model('admin_model', 'admin');
        $this->load->model('ajax_model', 'ajax');
        $this->id = $this->session->userdata('userid');
    }

    public function index() {
        
    }

    public function get_sub_category() {

        $id = $this->input->post("cid");
        $customerid = $this->input->post("id");

        $data['customers'] = $this->admin->show_customer_profile($customerid);
        $sub_cat_id = explode(",", $data['customers']->sub_categories);
        $data['selectedsubcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);
//        echo '<pre>';print_r($data['selectedsubcategory']);die;

        $data['sub_category'] = $this->admin->get_sub_category($id);
        //exit;
//       echo '<pre>'; print_r($data);die;
        $this->load->view("get_ajax_data", $data);
    }

    public function get_storesub_category() {

        $id = $this->input->post("cid");
        $storeid = $this->input->post("id");
//print_r($storeid);die;
        $data['stores'] = $this->admin->show_store_details($storeid);
        $sub_cat_id = explode(",", $data['stores']->subcategories);
        $data['selectedsubcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);
//        echo '<pre>';print_r($data['selectedsubcategory']);die;

        $data['sub_category'] = $this->admin->get_sub_category($id);
        //exit;
//       echo '<pre>'; print_r($data);die;
        $this->load->view("get_ajax_data", $data);
    }

    public function get_categories() {

        $id = $this->input->post("id");
//        print_r($id);
//        exit;
        $cat = $this->admin->get_categories($id);
        $category = $cat[0]['categories'];
        $cat = explode(",", $category);
        $cat = implode("','", $cat);
        $cat = "'" . $cat . "'";
//        echo $cat;exit;
        $data['category'] = $this->admin->get_cats($cat);
        $this->load->view("get_ajax_data", $data);
    }

    public function get_sub_categories() {

        $id = $this->input->post("id");
//        print_r($id);
//        exit;
        $cat = $this->admin->get_sub_categories($id);
        $category = $cat[0]['sub_categories'];
        $cat = explode(",", $category);
        $cat = implode("','", $cat);
        $cat = "'" . $cat . "'";
//        echo $cat;exit;
        $data['subcategory'] = $this->admin->get_subcategories($cat);

        $this->load->view("get_ajax_data", $data);
    }

    public function get_customersub_category() {

        $id = $this->input->post("cid");

        $data['cust_sub_category'] = $this->admin->get_sub_category($id);

        $this->load->view("get_ajax_data", $data);
    }

    public function get_states() {
        $Country_id = $this->input->post("country_id");
        $data['states'] = $this->admin->get_states_list($Country_id);
        //print_r($data['states']);
        $this->load->view('get_ajax_data', $data);
    }

    public function get_cities() {
        $state_id = $this->input->post("state_id");
        $data['cities'] = $this->admin->get_city_list($state_id);
        $this->load->view('get_ajax_data', $data);
    }

    public function get_latitude() {
//        $state_id = $this->input->post("state_id");
//        $data['info'] = $this->admin->get_info($state_id);
//        echo $data['info'][0]['latitude'];
////$this->load->view('get_ajax_data', $data);

        $add1 = $this->input->post('address');
        $add2 = $this->input->post('address2');
        if (!empty($add1) && !empty($add2)) {
            $address = $add1 . "%" . $add2;
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $address);
            $prepAddr = str_replace(' ', '+', $string);
        } else if (!empty($add1) && empty($add2)) {
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $add1);
            $prepAddr = str_replace(' ', '+', $string);
        } else if (!empty($add2) && empty($add1)) {
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $add2);
            $prepAddr = str_replace(' ', '+', $string);
        } else {
            $prepAddr = "";
        }
//        echo $prepAddr;
//        exit;
        $geocode = file_get_contents('http://maps.google.com/maps/api/geocode/json?address=' . $prepAddr . '&sensor=false');

        $output = json_decode($geocode);
//        echo "lat --->";
//        print_r($output);
//        exit;
        if (($output->status == 'ZERO_RESULTS')) {
            echo $lat = '';
        } else {
            echo $lat = $output->results[0]->geometry->location->lat;
        }
    }

//    public function get_time_zone() {
//        $state_id = $this->input->post("state_id");
//        $data['info'] = $this->admin->get_time_zone($state_id);
//        echo $data['info'][0]['time_zone'];
////$this->load->view('get_ajax_data', $data);
//    }

    public function get_longitude() {
//        $state_id = $this->input->post("state_id");
//        $data['info'] = $this->admin->get_info($state_id);
//        echo $data['info'][0]['longitude'];

        $add1 = $this->input->post('address');
        $add2 = $this->input->post('address2');

        if (!empty($add1) && !empty($add2)) {
            $address = $add1 . "%" . $add2;
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $address);
            $prepAddr = str_replace(' ', '+', $string);
        } else if (!empty($add1) && empty($add2)) {
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $add1);
            $prepAddr = str_replace(' ', '+', $string);
        } else if (!empty($add2) && empty($add1)) {
            $string = preg_replace('/[^A-Za-z0-9\-]/', ' ', $add2);
            $prepAddr = str_replace(' ', '+', $string);
        } else {
            $prepAddr = "";
        }
//        echo $prepAddr;
//        exit;
        $geocode = file_get_contents('http://maps.google.com/maps/api/geocode/json?address=' . $prepAddr . '&sensor=false');

        $output = json_decode($geocode);
//        echo "long --->";
//        print_r($output);
//        exit;

        if ($output->status == 'ZERO_RESULTS') {
            echo $long = '';
        } else {
            echo $long = $output->results[0]->geometry->location->lng;
        }
    }

    public function get_stores() {
        $cust_id = $this->input->post("cust_id");
        $cust = $this->ajax->get_customers($cust_id);
//       print_r($cust);
//       echo $cust[0]['manufacturer'];
//       exit;
        if (!empty($cust)) {
            if ($cust[0]['manufacturer'] == 1) {
                $data['stores'] = $this->ajax->get_coupon_stores(NULL);
                $this->load->view('get_ajax_data', $data);
            } else {
                $data['stores'] = $this->ajax->get_coupon_stores($cust_id);
                $this->load->view('get_ajax_data', $data);
            }
        } else {
            echo "<div class='multiselect'></div>";
        }
        //exit;        
    }

    public function get_ad_coupons() {
        $cust_id = $this->input->post("cust_id");
        $coupons = $this->ajax->get_coupons($cust_id);

        $data['coupons'] = $this->ajax->get_coupons($cust_id);
        $this->load->view('get_ajax_data', $data);
        //exit;        
    }

    public function get_old_password() {
        $old_pwd = $this->input->post("old_pwd");
        $user_id = $this->session->userdata("userid");
        $data['pwd'] = $this->ajax->get_pwd($old_pwd, $user_id);
    }

    public function get_thumb_image() {
        $id = $this->input->post("id");
        $data['thumb_image'] = $this->admin->get_image($id);
//        echo $data['thumb_image'][0]['thumbnailimage'];
        if ($data['thumb_image'][0]['thumbnailimage'] != "") {
            echo $data['thumb_image'][0]['thumbnailimage'];
        } else {
            echo "";
        }


//$this->load->view('get_ajax_data', $data);
    }

    public function get_store_image() {
        $id = $this->input->post("id");
        $data['store_image'] = $this->admin->get_image($id);
        if ($data['store_image'][0]['companyimage'] != "") {
            echo $data['store_image'][0]['companyimage'];
        } else {
            echo "";
        }
//$this->load->view('get_ajax_data', $data);
    }

    /* Function to generate csv -- Starts -- */
}