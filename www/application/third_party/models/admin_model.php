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
        $this->db->order_by("id", "desc");
        $query = $this->db->get('user_profile');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function displaystaff() {
        $this->load->database();
        $this->db->order_by("id", "desc");
        $query = $this->db->get_where("users", array('role' => 'staff'));
        //$query = $this->db->get('users');
        return $query->result_array();
    }

    public function delete_staff($id) {
        $this->db->delete('users', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function show_staffprofile($id) {
        $query = $this->db->get_where("users", array('id' => $id));
        $res = $query->row();
        return $res;
    }

    public function update_staff($data, $id) {
        $this->db->where("id", $id);
        $query = $this->db->update("users", $data);
        if ($query) {
            return 1;
        }
    }

    public function add_new_staff($data) {
        $this->load->database();
        $res = $this->db->insert('users', $data);
        return 1;
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
        $this->db->order_by("id", "desc");
        $query = $this->db->get('customer');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function delete_users($id) {
        $this->db->delete('user_profile', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function delete_customers($id) {
        $this->db->delete('customer', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function displaystores() {
        $this->load->database();
        $this->db->order_by("createdate", "desc");
        $query = $this->db->get('stores');
        //$query = $this->db->query('select * from users');
        //print_r($query);

        return $query->result_array();
    }

    public function add_new_store($data) {
        $this->load->database();
        $res = $this->db->insert('stores', $data);
        $this->db->select_max('id');
        $query = $this->db->get('stores');
        return $query->row();
        //return 1;
    }

    public function delete_stores($id) {
        $this->db->delete('stores', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function show_userprofile($id) {
        $query = $this->db->get_where("user_profile", array('id' => $id));
        $res = $query->row();
        return $res;
    }

    public function show_myprofile($id) {
        $this->load->database();
        //$id = $data['id'];
        $query = $this->db->query("select * from users where id = $id ");
        $res = $query->row();
        return $res;
    }

    public function update_password($new_pwd, $user_id) {
        $old_pwd = $this->input->post("old_pwd");
        $msg = $this->check_old_pwd($old_pwd, $user_id);
        if (isset($msg)) {
            return $msg;
        } else {
//            $this->db->where('id', $this->session->userdata('userid'));
//            $query = $this->db->get('users');
//            $row = $query->row();
            $data = array(
                'password' => $new_pwd
            );
            $this->db->where('id', $user_id);
            $this->db->update('users', $data);
            $data = "Password Successfully Updated";
            return $data;
        }
    }

    public function check_old_pwd($old_pwd, $user_id) {
        $this->db->where('id', $user_id);
        $query = $this->db->get('users');
        $row = $query->row();
        if ($old_pwd != $row->password) {
            $msg = "You Entered Wrong Old Password";
            return $msg;
        }
    }

    public function show_campaign_details($data) {
        $this->load->database();
        $id = $data['id'];
        $query = $this->db->query('select * from ad_campaigns where id = ' . $data['id'] . '');
        $res = $query->result_array();
        return $res;
        //print_r($res);

        return $query;
    }

    public function show_giftcard_details($data) {
        $this->load->database();
        $id = $data['id'];
        $query = $this->db->query('select * from gift_cards where id = ' . $data['id'] . '');
        $res = $query->result_array();
        return $res;
        //print_r($res);

        return $query;
    }

    public function show_customer_profile($id) {
        $this->db->where('id', $id);
        $query = $this->db->get('customer');
        $row = $query->row();
        return $row;
    }

    public function show_store_details($id) {
        //echo $id;
        //exit;
        $this->db->where('id', $id);
        $query = $this->db->get('stores');
        $row = $query->row();
        return $row;
    }

    public function show_coupon_details($id) {
        $this->db->where('id', $id);
        $query = $this->db->get('coupons');
        $row = $query->row();
        return $row;
    }

    public function show_notification_details($data) {
        $this->load->database();
        $id = $data['id'];
        $query = $this->db->query('select * from notifications where id = ' . $data['id'] . '');
        $res = $query->result_array();
        return $res;
        //print_r($res);

        return $query;
    }

    public function show_advert_details($id) {
        $this->db->where('id', $id);
        $query = $this->db->get('advertisements');
        $row = $query->row();
        return $row;
    }

    public function update_user($data, $id) {
        $this->db->where("id", $id);
        $query = $this->db->update("user_profile", $data);
        if ($query) {
            return 1;
        }
    }

    public function update_my_profile($data, $id) {
        $this->db->where("id", $id);
        $this->db->update("users", $data);
        return 1;
    }

    public function update_notifications($data) {

        $id = $data['id'];
        $notification_name = $data['notification_name'];
        $notificationtext = $data['notificationtext'];
        $notifyon = $data['notifyon'];
        $launch_date = $data['launch_date'];
        $launch_time = $data['launch_time'];


        $this->load->database();
        // $query1 = $this->db->where('id', $id);
        //$query = $this->db->update('users', $data1); 
        $query = $this->db->query("update notifications set notification_name='$notification_name', notificationtext='$notificationtext', notifyon='$notifyon', launch_date='$launch_date' ,launch_time='$launch_time' WHERE id='$id' ");

        return $query;

        exit;

        //return $query;
    }

    public function update_advertisements($data, $id) {

        $this->db->where('id', $id);
        if ($this->db->update("advertisements", $data)) {
            return true;
        }


//        $id = $data['id'];
//        $advert_name = $data['advert_name'];
//        $description = $data['description'];
//        $add_text = $data['add_text'];
//        $valid_from = $data['valid_from'];
//        $valid_till = $data['valid_till'];
//
//        $check_points = $data['check_points'];
//        $banner_image = $data['banner_image'];
//        $customer = $data['customer'];
//        $type = $data['type'];
//        $campaign = $data['campaign'];
//        $active = $data['active'];
//        $this->load->database();
        // $query1 = $this->db->where('id', $id);
        //$query = $this->db->update('users', $data1); 
//        $query = $this->db->query("update advertisements set 
//			 advert_name='$advert_name',
//			 description='$description',
//			 add_text='$add_text',
//			 valid_from='$valid_from' ,
//			 valid_till='$valid_till',
//
//			  check_points='$check_points',
//			 banner_image='$banner_image',
//			 customer='$customer' ,
//			 type='$type',
//			  campaign='$campaign',
//			 active='$active' 
//			
//			 WHERE id='$id' ");
//
//        return $query;
//
//        exit;
        //return $query;
    }

    public function update_customer($data, $id) {
        $this->db->where('id', $id);
        if ($this->db->update("customer", $data)) {
            return true;
        }

//        $companyname = $data['res']['companyname'];
//        $adminusername = $data['res']['adminusername'];
//        $fullname = $data['res']['fullname'];
//        $isrealbrand = $data['res']['isrealbrand'];
//        $thumbnailimage = $data['res']['thumbnailimage'];
//
//        $contactname = $data['res']['contactname'];
//        $email = $data['res']['email'];
//        $corporateaddress = $data['res']['corporateaddress'];
//        $corporateaddress2 = $data['res']['corporateaddress2'];
//        $address = $data['res']['address'];
//        $zipcode = $data['res']['zipcode'];
//
//        $contactno = $data['res']['contactno'];
//        $legalurl = $data['res']['legalurl'];
//        $keyword = $data['res']['keyword'];
//
//        $this->load->database();
//        // $query1 = $this->db->where('id', $id);
//        //$query = $this->db->update('users', $data1); 
//
//        $query = $this->db->query("update customer set 
//			 companyname='$companyname',
//			 adminusername='$adminusername',
//			 fullname='$fullname',
//			 isrealbrand='$isrealbrand' ,
//			 thumbnailimage='$thumbnailimage',
//             contactname='$contactname',
//			 email='$email',
//			 corporateaddress='$corporateaddress' ,
//			 corporateaddress2='$corporateaddress2',
//			 address='$address',
//			 zipcode='$zipcode' ,
//             contactno='$contactno',
//			 url='$legalurl',
//			 keyword='$keyword' 
//			
//			 WHERE id='$id' ");
//
//        return $query;
//        exit;
        //return $query;
    }

    public function update_campaigns($data) {
        echo $id = $data['id'];
        $name = $data['name'];
        $description = $data['description'];
        $validfrom = $data['validfrom'];
        $validtill = $data['validtill'];
        $starttime = $data['starttime'];
        $expiry_date = $data['expiry_date'];
        $user_id = $data['user_id'];
        $active = $data['active'];



        $this->load->database();

        $query = $this->db->query("update ad_campaigns set  name='$name', description='$description', validfrom='$validfrom' ,validtill='$validtill',
             starttime='$starttime',expiry_date='$expiry_date',user_id='$user_id',active='$active' WHERE id='$id' ");

        return $query;



        //return $query;
    }

    public function update_giftcards($data) {



        $id = $data['id'];
        $displayname = $data['displayname'];
        $number = $data['number'];
        $security_code = $data['security_code'];
        $thumbnailimage = $data['thumbnailimage'];
        $fullimage = $data['fullimage'];

        $barcodetype = $data['barcodetype'];
        $validfrom = $data['validfrom'];
        $validtill = $data['validtill'];
        $points = $data['points'];
        $savings = $data['savings'];
        $quantity = $data['quantity'];
        $legalurl = $data['legalurl'];


        $this->load->database();
        // $query1 = $this->db->where('id', $id);
        //$query = $this->db->update('users', $data1); 
        $query = $this->db->query("update gift_cards set 
			 name='$displayname',
			 number='$number',
			 security_code='$security_code',
			 thumbnailimage='$thumbnailimage' ,
			 fullimage='$fullimage',

			  barcodetype='$barcodetype',
			 validfrom='$validfrom',
			 validtill='$validtill' ,
			 points='$points',
			  savings='$savings',
			 quantity='$quantity' ,
			  legalurl='$legalurl' 
			
			 WHERE id='$id' ");

        return $query;

        exit;

        //return $query;
    }

    public function update_store($data, $id) {

//        $id = $data['id'];
//        $storename = $data['storename'];
//        $storenumber = $data['storenumber'];
//        $customer = $data['customer'];
//        $description = $data['description'];
//        $address = $data['address'];
//        $checkinpoints = $data['checkinpoints'];
//        $latitude = $data['latitude'];
//        $longitude = $data['longitude'];
//        $timezone = $data['timezone'];
//        $legalurl = $data['legalurl'];
//        $country = $data['country'];
//        $state = $data['state'];
//        $city = $data['city'];
//        $thumbnailimage = $data['thumbnailimage'];
//        $storeimage = $data['storeimage'];
        $this->db->where('id', $id);
        if ($this->db->update("stores", $data)) {
            return true;
        }

//        $this->load->database();
//        // $query1 = $this->db->where('id', $id);
//        //$query = $this->db->update('users', $data1); 
//        $query = $this->db->query("update stores set storename = '$storename' , customer = '$customer',description = '$description',address ='$address',checkinpoints = '$checkinpoints', latitude = '$latitude',longitude = '$longitude',timezone='$timezone',url='$legalurl',country='$country',state='$state',
//			  city='$city',
//			   thumbnailimage='$thumbnailimage',
//			    storeimage='$storeimage'
//			  
//			  
//			  WHERE id='$id' ");
//        return $query;
        //exit;
        //return $query;
    }

    public function update_coupons($data, $id) {


        $this->db->where('id', $id);
        if ($this->db->update("coupons", $data)) {
            return true;
        }

//        $id = $data['id'];
//        $customer_name = $data['customer_name'];
//        $store_name = $data['store_name'];
//        $name = $data['name'];
//        $code_type = $data['code_type'];
//        $promotextshort = $data['promotextshort'];
//        $promotextlong = $data['promotextlong'];
//        //$coupon_description = $data['coupon_description'];
//        $launch_date = $data['launch_date'];
//        $expiry_date = $data['expiry_date'];
//        $savings = $data['savings'];
//        $validity = $data['validity'];
//        $downloads = $data['downloads'];
//        $rewardpoints_on_redemption = $data['rewardpoints_on_redemption'];
//
//        $couponimage = $data['couponimage'];
//        $this->load->database();
//        // $query1 = $this->db->where('id', $id);
//        //$query = $this->db->update('users', $data1); 
//        $query = $this->db->query("update coupons set
// customer_name = '$customer_name' ,
//						  store_name = '$store_name',
//						  name = '$name',
//						  code_type ='$code_type',
//						  promo_text_short = '$promotextshort', 
//						  promo_text_long = '$promotextlong',
//						 
//						  launch_date='$launch_date',
//						  expiry_date ='$expiry_date',
//						  savings='$savings',
//						  validity='$validity',
//						  downloads='$downloads',
//						
//						  coupon_image='$couponimage',
//						    rewardpoints_on_redemption='$rewardpoints_on_redemption'
//
//
//						  WHERE id='$id' ");
//
//        return $query;
//
//        exit;
        //return $query;
    }

    public function displaygiftcards() {
        $this->load->database();
        $query = $this->db->get('gift_cards');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function add_new_giftcard($data) {
        $this->load->database();
        $res = $this->db->insert('gift_cards', $data);
        return 1;
    }

    public function delete_giftcard($data1) {
        $this->load->database();
        $id = $data1['id'];
        $this->db->delete('gift_cards', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function displaycampaigns() {
        $this->load->database();
        $query = $this->db->get('ad_campaigns');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function add_new_campaign($data) {
        $this->load->database();
        $res = $this->db->insert('ad_campaigns', $data);
        return 1;
    }

    public function delete_campaign($data1) {
        $this->load->database();
        $id = $data1['id'];
        $this->db->delete('ad_campaigns', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function displaynotifications() {
        $this->load->database();
        $query = $this->db->get('notifications');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function add_new_notification($data) {
        $this->load->database();
        $res = $this->db->insert('notifications', $data);
        return 1;
    }

    public function delete_notification($data1) {
        $this->load->database();
        $id = $data1['id'];
        $this->db->delete('notifications', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function displayadverts() {
        $this->load->database();
         $this->db->order_by("id", "desc");
        $query = $this->db->get('advertisements');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function add_new_advert($data) {
        $this->load->database();
        $res = $this->db->insert('advertisements', $data);
        return 1;
    }

    public function delete_advert($id) {
        $this->db->delete('advertisements', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function displaycoupons() {
        $this->load->database();
        $query = $this->db->get('coupons');
        return $query->result_array();
    }

    public function filtercoupons($data) {
        $this->load->database();
        $sql = "SELECT * FROM (`coupons`) WHERE `name` LIKE '%$data[search]%'";
        if ($data['from'] != "" && $data['to']) {
            $sql.="AND expiry_date between '$data[from]]' And '$data[to]]'";
        }
        $query = $this->db->query($sql);
//          echo $this->db->last_query();die;
        return $query->result_array();
    }

    public function coupon_details_for_update($id) {
        $this->load->database();
        $query = $this->db->get('coupons');
        //$query = $this->db->query('select * from users where id = '$id'');
        //print_r($query);
        return $query->result_array();
    }

    public function add_new_coupons($data) {
        $res = $this->db->insert('coupons', $data);
        $this->db->select_max('id');
        $query = $this->db->get('coupons');
        return $query->row();
        //return 1;
    }

    public function get_zip_from_customer($customer) {
        echo $customer;
        $this->load->database();
        $query = $this->db->query("select * from customer where fullname = '$customer' ");
        // print_r($query);
        //$res = $this->db->insert('coupons', $data); 
        //return 1;
        return $query->result_array();
    }

    public function delete_coupon($id) {
        $this->db->delete('coupons', array('id' => $id));
        return ($this->db->affected_rows() > 0) ? TRUE : FALSE;
    }

    public function getcampaigns() {
        $this->load->database();
        $query = $this->db->get('ad_campaigns');
        //$query = $this->db->query('select * from users');
        //print_r($query);
        return $query->result_array();
    }

    public function get_coupon_summary_report($data) {
        $this->load->database();

        //print_r($data);
        $customer_name = $data['res']['customer_name'];
        $data['res']['start_date'];
        $data['res']['end_date'];
        //exit;
        $query = $this->db->get('coupons');

        //$query = $this->db->query('select * from coupons where customer_name = '.$data['customer_name'].');
        return $query->result_array();
    }

    public function display_coupon_detailed_report($data) {
        $this->load->database();

        //print_r($data);
        $data['res']['start_date'];
        $data['res']['end_date'];
        //exit;
        $query = $this->db->get('coupons');

        //$query = $this->db->query('select * from coupons where customer_name = '.$data['customer_name'].');
        return $query->result_array();
    }

    public function get_stores($id= NULL) {
        $this->load->database();

        if (isset($id)) {
            $this->db->where_in('id', $id);
        }
        $query = $this->db->get('stores');
        return $query->result_array();
    }

    public function get_customers($id = NULL) {
        $this->load->database();
        if (isset($id)) {
            $this->db->where('id', $id);
        }
        $query = $this->db->get('customer');
        //          echo $this->db->last_query();
        return $query->result_array();
    }

    public function get_coupons($id=NULL) {

        if (isset($id)) {
            //echo $id;
            $this->db->where('id', $id);
        }
        $query = $this->db->get('coupons');
        return $query->result_array();
    }

    public function get_category($id=NULL) {
//echo $id;
        //exit;        
        $this->db->where('status', '0');
        if (isset($id)) {
            $this->db->where_in('id', $id);
        }
        $query = $this->db->get('category');

        //print_r($query->result());
        return $query->result_array();
    }

    public function get_cats($id=NULL) {
//echo $id;

        if (isset($id)) {
            $query = $this->db->query("SELECT * FROM (`category`) WHERE `status` = '0' AND `id` IN ($id) ");
//          echo $this->db->last_query();
            return $query->result_array();
        }
    }

    public function get_subcategories($id=NULL) {
//echo $id;

        if (isset($id)) {
            $query = $this->db->query("SELECT * FROM category WHERE `status` = '1' AND `id` IN ($id) ");
//          echo $this->db->last_query();
            return $query->result_array();
        }
    }

    public function get_categories($id=NULL) {
        $query = $this->db->query("SELECT categories FROM customer where id='$id'");
        return $query->result_array();
    }

    public function get_sub_categories($id=NULL) {
        $query = $this->db->query("SELECT sub_categories FROM customer where id='$id'");
        return $query->result_array();
    }

    public function get_cat($id=NULL) {
        $query = $this->db->query("SELECT * FROM customer where id='$id'");
        return $query->result_array();
    }

    public function get_customer_types($id = NULL) {
        if (isset($id)) {
            $this->db->where('id', $id);
        }
        $query = $this->db->get('customer_type');
        return $query->result_array();
    }

    public function get_sub_category($id=NULL, $sub_id = NULL) {

        $this->db->where('status', '1');
        if (isset($id)) {
            $this->db->where_in('parent_id', $id);
        } else if (isset($sub_id)) {
            $this->db->where_in('id', $sub_id);
        }
        $query = $this->db->get('category');
        //exit;
        return $query->result_array();
    }

    public function get_country_list($id =NULL) {
        $this->load->database();
        if (isset($id)) {
            $this->db->where('id', $id);
        }
        $query = $this->db->get('country');
        $res = $query->result_array();
        return $res;
        //print_r($res);
        //return $query;
    }

    public function get_city_list($id=NULL, $city_id = NULL) {
        $this->load->database();
        if (isset($id)) {
            $this->db->where('stateid', $id);
        } else if (isset($city_id)) {
            $this->db->where('cityid', $city_id);
        }

        $query = $this->db->get('cities');
        return $query->result_array();
    }

    public function get_states_list($id=NULL, $st_id = NULL) {
        $this->load->database();
        if (isset($id)) {
            $this->db->where('countryID', $id);
        } else if (isset($st_id)) {
            $this->db->where('stateID', $st_id);
        }

        $query = $this->db->get('states');
//        print_r($query->result_array());
//       exit;
        return $query->result_array();
        //print_r($res);
        //return $query;
    }

    public function get_info($id=NULL) {
        $this->load->database();
        $this->db->where('stateid', $id);
        $query = $this->db->get('states');
        return $query->result_array();
    }

    public function get_image($id=NULL) {
        $query = $this->db->query("SELECT * FROM customer where id='$id'");
        return $query->result_array();
    }

    public function get_longitude($id=NULL) {
        $this->load->database();
        $this->db->where('stateid', $id);
        $query = $this->db->get('states');
        return $query->result_array();
    }

    public function get_time_zone($id=NULL) {
        $this->load->database();
        $this->db->where('stateid', $id);
        $query = $this->db->get('states');
        return $query->result_array();
    }

}

