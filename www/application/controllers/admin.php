<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Admin extends CI_Controller {

    function __construct() {
        parent::__construct();
        $this->check_isvalidated();
		
        $this->load->model('admin_model', 'admin');
        $this->upload1_path = realpath(APPPATH . '../uploads');
        $this->upload_path_url = base_url() . 'uploads';
        $this->id = $this->session->userdata('userid');
        $this->load->library('upload');

//        if ($this->uri->segment(2) != "getsubscrstudlist" && $this->uri->segment(2) != "getfeedbacklist" && $this->uri->segment(2) != "getmessages" && $this->uri->segment(2) != "getschedulelist") {
        $this->load->view('header/header');
        $this->load->view('header/side_menu');
//        }
    }

    public function index() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Admin Panel',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Welcome To Admin Panel'
            );
            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('dashboard');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    /* Function to Display Subscriber Dashboard --Starts-- */

    public function subscriber_dashboard() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Subscriber Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => ''
            );
            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('subscriber_dashboard');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    //staff adding, deleting, viewing
    public function display_staff() {

        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Staff',
                'heading1' => 'Manage Staff',
                'heading1_url' => 'display_staff',
                'heading2' => 'Staff Details'
            );

            $data['result'] = $this->admin->displaystaff();
//echo '<pre>';print_r($data['result']);die;

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('display_staff', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no staff in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_staff() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Staff',
                'heading1' => 'Manage Staff',
                'heading1_url' => 'display_staff',
                'heading2' => 'Add New Staff'
            );
            if ($_POST) {
                $data = array(
                    'username' => $this->input->post('username'),
                    'firstname' => $this->input->post('firstname'),
                    'lastname' => $this->input->post('lastname'),
                    'email' => $this->input->post('email'),
                    'contact_info' => $this->input->post('contactno'),
                    'password' => $this->input->post('password'),
                    'role' => 'staff',
                    'enabled' => '1'
                );
                $result = $this->admin->add_new_staff($data);
                redirect("admin/display_staff");
            }

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_staff');

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function staff_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Staff',
                'heading1' => 'Manage Staff',
                'heading1_url' => 'display_staff',
                'heading2' => 'Staff Profile'
            );

            $id = $_GET['id'];
            $data['result'] = $this->admin->show_staffprofile($id);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('staff_profile', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no staff in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function update_staff() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Staff',
                'heading1' => 'Manage Staff',
                'heading1_url' => 'display_staff',
                'heading2' => 'Edit Staff Profile'
            );
        }

        $id = $this->input->post('user_id');
        $data['result'] = $this->admin->show_staffprofile($id);
        $data = array(
            'firstname' => $this->input->post('firstname'),
            'lastname' => $this->input->post('lastname'),
            'email' => $this->input->post('email'),
            'password' => $this->input->post('password'),
            'contact_info' => $this->input->post('contactno'),
        );

        $data1['results'] = $this->admin->update_staff($data, $id);
        if ($data1 != "") {
            redirect("admin/display_staff");
        }
    }

    public function delete_staff() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data = $this->input->post("user_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_staff($id);
                }
            }
            redirect('/admin/display_staff');
        } else {
            redirect(base_url());
        }
    }

//end staff adding, deleting, viewing  



    /* Function users --Start-- */

    public function display_users() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Users',
                'heading1' => 'Users',
                'heading1_url' => 'display_users',
                'heading2' => 'User Details'
            );

            $data['result'] = $this->admin->displayusers();

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('users', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_user_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Users',
                'heading1' => 'Users',
                'heading1_url' => 'display_users',
                'heading2' => 'User Profile'
            );

            $id = $_GET['id'];
            $data['result'] = $this->admin->show_userprofile($id);

            $data['country'] = $this->admin->get_country_list($data['result']->country);
            $data['state'] = $this->admin->get_states_list(NULL, $data['result']->state);
            $data['city'] = $this->admin->get_city_list(NULL, $data['result']->city);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('user_profile', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function delete_user() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
                //'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );


            $data = $this->input->post("user_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_users($id);
                }
            }
            redirect('/admin/display_users');
        } else {
            redirect(base_url());
        }
    }

    //admin User Profile
    public function show_my_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Profile',
                'heading1' => 'Profile',
                'heading1_url' => 'show_my_profile',
                'heading2' => 'My Profile'
            );

            $id = $this->session->userdata('userid');
            $data['result'] = $this->admin->show_myprofile($id);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('my_profile', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function edit_my_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Profile',
                'heading1' => 'Profile',
                'heading1_url' => 'show_my_profile',
                'heading2' => 'Edit Profile'
            );
        }
        $id = $this->input->post('id');

        $data['my_profile'] = array(
            'id' => $id,
            'username' => $this->input->post('username'),
            'firstname' => $this->input->post('firstname'),
            'lastname' => $this->input->post('lastname'),
            'email' => $this->input->post('email'),
            'contactno' => $this->input->post('contactno')
        );
//        $data['customer_type'] = $this->admin->get_customer_types(NULL);

        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_my_profile', $data);
        $this->load->view('footer/footer');
    }

    public function update_my_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
                //'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }

        $id = $this->input->post('id');
        $data = array(
            'username' => $this->input->post('username'),
            'firstname' => $this->input->post('firstname'),
            'lastname' => $this->input->post('lastname'),
            'email' => $this->input->post('email'),
            'customer' => $this->input->post('customer'),
            'contact_info' => $this->input->post('contactno')
        );

        $data1['my_profile'] = $this->admin->update_my_profile($data, $id);
        if ($data1 != "") {
            $data = array(
                'userid' => $this->input->post('id'),
                'name' => $this->input->post('firstname') . " " . $this->input->post('lastname'),
                'email' => $this->input->post('email'),
                'validated' => true
            );
            $abc = $this->session->set_userdata($data);
            redirect("admin/display_users");
        }
    }

    public function change_password() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage User',
                'heading1' => 'Users',
                'heading1_url' => 'display_user',
                'heading2' => 'Change Password'
            );
            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view("change_password");
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function update_password() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage User',
                'heading1' => 'Users',
                'heading1_url' => 'display_user',
                'heading2' => 'Change Password'
            );

            $user_id = $this->session->userdata("userid");
            $new_pwd = $this->input->post("new_pwd");

            $data['msg'] = $this->admin->update_password($new_pwd, $user_id);

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('change_password', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    /* Function User -- Ends -- */



    /* Function Show Customer Profile -- Starts -- */

    public function display_customers() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Client',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'List Clients'
            );

            $data['result'] = $this->admin->displaycustomers();
//print_r($data['result']);


            if ($data != "") {

                $this->load->view('header/bread_crumb', $breadcrumb);

                $this->load->view('customers', $data);

                $this->load->view('footer/footer');
            } else {
                echo "There are no clients in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_customer_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Client',
                'heading1' => 'Customer Details',
                'heading1_url' => 'display_customers',
                'heading2' => 'View Customer Details'
            );

            $id = $_GET['id'];
            $data['customers'] = $this->admin->show_customer_profile($id);
            $cat_id = explode(",", $data['customers']->categories);
            $sub_cat_id = explode(",", $data['customers']->sub_categories);
            $data['country'] = $this->admin->get_country_list($data['customers']->countryid);
            $data['state'] = $this->admin->get_states_list(NULL, $data['customers']->state);
            $data['city'] = $this->admin->get_city_list(NULL, $data['customers']->city);
            $data['category'] = $this->admin->get_category($cat_id);
            $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);
            $data['customer_types'] = $this->admin->get_customer_types($data['customers']->customertype);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('customer_profile', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no clients in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_customer() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Client',
                'heading1' => 'Client',
                'heading1_url' => 'Clients',
                'heading2' => 'Add New Client'
            );
            $data['category'] = $this->admin->get_category();
            $data['customer_types'] = $this->admin->get_customer_types();
            $this->load->view('header/bread_crumb', $breadcrumb);
            $data['countries'] = $this->admin->get_country_list();
            $this->load->view('add_customer', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function save_new_customer() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $categories = $this->input->post('category');
            if ($categories != "") {

                $category = implode(",", $categories);
            } else {
                $category = "";
            }
            $sub_categories = $this->input->post('sub_category');
            if ($sub_categories != "") {

                $sub_category = implode(",", $sub_categories);
            } else {
                $sub_category = "";
            }
            $keywords = $this->input->post('keywords');
            if ($keywords != "") {

                $key = implode("\n", $keywords);
            }

            if ($_POST != "") {

                $data = array(
                    'companyname' => $this->input->post('client_name'),
                    'corporateaddress' => $this->input->post('address1'),
                    'corporateaddress2' => $this->input->post('address2'),
                    'adminusername' => $this->input->post('admin_username'),
                    'password' => $this->input->post('password'),
                    'fullname' => $this->input->post('full_name'),
                    'retailer' => $this->input->post('retailer'),
                    'national_brand' => $this->input->post('national_brand'),
                    'manufacturer' => $this->input->post('manufacturer'),
                    'singal_store' => $this->input->post('singal_store'),
                    'description' => $this->input->post('description'),
                    'customertype' => $this->input->post('clienttype'),
                    'categories' => $category,
                    'sub_categories' => $sub_category,
                    'email' => $this->input->post('email'),
                    'countryid' => $this->input->post('country'),
                    'state' => $this->input->post('state'),
                    'city' => $this->input->post('city'),
                    'zipcode' => $this->input->post('zip'),
                    'contactno' => $this->input->post('contact_no'),
                    'alt_contactno' => $this->input->post('alt_contact_no'),
                    'url' => $this->input->post('legal_url'),
                    'keyword' => $key
                );
                $result = $this->admin->add_new_customer($data);

                if (!empty($_FILES['thumb_image']['name'])) {
                    $thumb_image = $_FILES['thumb_image']['name'];
                    $upload_thumb = $this->uploadThumbFile($thumb_image, 'thumb_image');

                    if ($upload_thumb) {
                        $data = array(
                            'thumbnailimage' => $upload_thumb['file_name'],
                        );
                        $data1['results'] = $this->admin->update_customer($data, $result->id);
                    }
                }
                if (!empty($_FILES['company_image']['name'])) {
                    $company_image = $_FILES['company_image']['name'];
                    $upload_data = $this->uploadFile($company_image, 'company_image');
                    if ($upload_data) {
                        $data = array(
                            'companyimage' => $upload_data['file_name'],
                        );
                        $data1['results'] = $this->admin->update_customer($data, $result->id);
                    }
                }
            }
            redirect("admin/display_customers");
        } else {
            redirect(base_url());
        }
    }

    public function edit_customer_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Client',
                'heading1' => 'Customer Details',
                'heading1_url' => 'display_customers',
                'heading2' => 'Edit Customer Details'
            );
        }

        $id = $this->input->post('customer_id');
        $data['id'] = $this->input->post('customer_id');
        $data['customers'] = $this->admin->show_customer_profile($id);
        $cat_id = explode(",", $data['customers']->categories);
        $data['catid'] = $this->admin->get_category();

        $sub_cat_id = explode(",", $data['customers']->sub_categories);
        $data['countries'] = $this->admin->get_country_list(NULL);
        $data['state'] = $this->admin->get_states_list(NULL, $data['customers']->state);
        $data['city'] = $this->admin->get_city_list(NULL, $data['customers']->city);
        $data['category'] = $this->admin->get_category($cat_id);

        $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);

        $data['customer_types'] = $this->admin->get_customer_types();

        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_customer', $data);
        $this->load->view('footer/footer');
    }

    public function update_customer() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }
        $id = $this->input->post('customer_id');
        $categories = $this->input->post('category');
        $sub_categories = $this->input->post('sub_category');
        $keywords = $this->input->post('keywords');

        if (isset($categories)) {
            $category = implode(",", $categories);
        } else {
            $category = "";
        }

        if (isset($sub_categories)) {
            $sub_category = implode(",", $sub_categories);
        } else {
            $sub_category = "";
        }

        if (isset($keywords)) {
            $key = implode(",", $keywords);
        } else {
            $key = "";
        }

        if ($_POST != "") {

            $data = array(
                'companyname' => $this->input->post('client_name'),
                'corporateaddress' => $this->input->post('address1'),
                'corporateaddress2' => $this->input->post('address2'),
                'adminusername' => $this->input->post('admin_username'),
                'password' => $this->input->post('password'),
                'fullname' => $this->input->post('full_name'),
                'retailer' => $this->input->post('retailer'),
                'national_brand' => $this->input->post('national_brand'),
                'manufacturer' => $this->input->post('manufacturer'),
                'singal_store' => $this->input->post('singal_store'),
                'description' => $this->input->post('description'),
                'customertype' => $this->input->post('clienttype'),
                'categories' => $category,
                'sub_categories' => $sub_category,
                'email' => $this->input->post('email'),
                'countryid' => $this->input->post('country'),
                'state' => $this->input->post('state'),
                'city' => $this->input->post('city'),
                'zipcode' => $this->input->post('zip'),
                'contactno' => $this->input->post('contact_no'),
                'alt_contactno' => $this->input->post('alt_contact_no'),
                'url' => $this->input->post('legal_url'),
                'keyword' => $key
            );
        }
        $data1['results'] = $this->admin->update_customer($data, $id);

        if (!empty($_FILES['thumb_image']['name'])) {
            $thumb_image = $_FILES['thumb_image']['name'];
            $upload_thumb = $this->uploadThumbFile($thumb_image, 'thumb_image');

            if ($upload_thumb) {
                $data = array(
                    'thumbnailimage' => $upload_thumb['file_name'],
                );
                $data1['results'] = $this->admin->update_customer($data, $id);
            }
        }
        if (!empty($_FILES['company_image']['name'])) {
            $company_image = $_FILES['company_image']['name'];
            $upload_data = $this->uploadFile($company_image, 'company_image');

            if ($upload_data) {
                $data = array(
                    'companyimage' => $upload_data['file_name'],
                );
                $data1['results'] = $this->admin->update_customer($data, $id);
            }
        }
        redirect("admin/display_customers");
    }

    public function delete_customer() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data = $this->input->post("cust_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_customers($id);
                }
            }
            redirect('/admin/display_customers');
        } else {
            redirect(base_url());
        }
    }

    /* Function Show Customer Profile -- Ends -- */


    /* Function to show coupon details -- Starts -- */

    public function add_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'List Coupons'
            );

            $data['result'] = $this->admin->displaycoupons();
            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('coupons', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no coupons in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_new_coupon() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
                'heading1' => 'Coupons',
                'heading1_url' => 'add_coupons',
                'heading2' => 'Add New Coupon'
            );

            $data['customers'] = $this->admin->get_customers();
            $data['category'] = $this->admin->get_category();

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_coupons', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function add_new_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
                'heading2' => 'Add New coupon'
            );

            $coupon_date = $this->input->post('coupon_date');
            list($launch_date, $expiry_date) = explode('to', $coupon_date);
            $launch_date = date('Y-m-d', strtotime($launch_date));
            $expiry_date = date('Y-m-d', strtotime($expiry_date));

            if (isset($_POST['store_list'])) {
                $store_list = $this->input->post('store_list');
                $store_list = implode(",", $store_list);
            } else {
                $store_list = '';
            }
            if (isset($_POST['category'])) {
                $categories = $this->input->post('category');
                $category = implode(",", $categories);
            }
            if (isset($_POST['sub_category'])) {
                $sub_categories = $this->input->post('sub_category');
                $sub_category = implode(",", $sub_categories);
            } else {
                $sub_category = '';
            }
            $keywords = $this->input->post('keywords');
            $key = implode("\n", $keywords);

            if ($_POST != "") {
                $customer = $this->input->post('client');
                $cup_ons = $this->input->post('coupon_code');
                $barcode = $this->input->post('barcode_text');
                if ($cup_ons != "") {
                    $data = array
                        (
                        'customer_name' => $this->input->post('client'),
                        'store_name' => $store_list,
                        'name' => $this->input->post('coupon_name'),
                        'quantity' => $this->input->post('quantity'),
                        'code_type' => $this->input->post('codetype'),
                        'category' => $category,
                        'sub_category' => $sub_category,
                        'couponcode' => $this->input->post('coupon_code'),
                        'promo_text_short' => $this->input->post('promotext_short'),
                        'coupon_description' => $this->input->post('coupon_description'),
                        'launch_date' => $launch_date,
                        'expiry_date' => $expiry_date,
                        'downloads' => $this->input->post('no_of_downloads'),
                        'terms_conditions' => $this->input->post('terms_conditions'),
                        'whats_hot' => $this->input->post('whats_hot'),
                        'national_coupon' => $this->input->post('national_coupon'),
                        'legal_url' => $this->input->post('legal_url'),
                        'reward_points' => $this->input->post('reward_points'),
                        'keywords' => $key
                    );
                } else if ($barcode != "") {

                    $barcode_type = $this->input->post('barcode_type');
                    $barcode_text = $this->input->post('barcode_text');
                    if ($barcode_type == 'qr') {
                        $barcode = implode("qr", $barcode_text);
                    } else if ($barcode_type == 'code128') {
                        $barcode = implode("cd128", $barcode_text);
                    } else if ($barcode_type == 'code39') {
                        $barcode = implode("%", $barcode_text);
                    } else if ($barcode_type == 'itf') {
                        $barcode = implode("", $barcode_text);
                        ;
                    } else if ($barcode_type == 'ean8') {
                        $barcode = implode("", $barcode_text);
                        ;
                    } else if ($barcode_type == 'ean13') {
                        $barcode = implode("", $barcode_text);
                        ;
                    } else {
                        $barcode = implode("", $barcode_text);
                    }

                    $data = array
                        (
                        'customer_name' => $this->input->post('client'),
                        'store_name' => $store_list,
                        'name' => $this->input->post('coupon_name'),
                        'quantity' => $this->input->post('quantity'),
                        'code_type' => $this->input->post('codetype'),
                        'category' => $category,
                        'sub_category' => $sub_category,
                        'barcodedata' => $barcode,
                        'bar_type' => $this->input->post('barcode_type'),
                        'promo_text_short' => $this->input->post('promotext_short'),
                        'coupon_description' => $this->input->post('coupon_description'),
                        'launch_date' => $launch_date,
                        'expiry_date' => $expiry_date,
                        'downloads' => $this->input->post('no_of_downloads'),
                        'terms_conditions' => $this->input->post('terms_conditions'),
                        'whats_hot' => $this->input->post('whats_hot'),
                        'national_coupon' => $this->input->post('national_coupon'),
                        'legal_url' => $this->input->post('legal_url'),
                        'reward_points' => $this->input->post('reward_points'),
                        'keywords' => $key
                    );
                }
                $result = $this->admin->add_new_coupons($data);

                if (!empty($_FILES['coupon_thumbnail']['name'])) {
                    $coupon_thumbnail = $_FILES['coupon_thumbnail']['name'];

                    $upload_thumbnail = $this->uploadThumbFile($coupon_thumbnail, 'coupon_thumbnail');
                    if ($upload_thumbnail) {
                        $data = array(
                            'coupon_thumbnail' => $upload_thumbnail['file_name'],
                        );
                        $data1['results'] = $this->admin->update_coupons($data, $result->id);
                    }
                }
                if (!empty($_FILES['coupon_image']['name'])) {
                    $coupon_image = $_FILES['coupon_image']['name'];
                    $upload_data = $this->uploadFile($coupon_image, 'coupon_image');

                    if ($upload_data) {
                        $data = array(
                            'coupon_image' => $upload_data['file_name'],
                        );
                        $data1['results'] = $this->admin->update_coupons($data, $result->id);
                    }
                }
            }
            redirect('admin/add_coupons');
        } else {
            redirect(base_url());
        }
    }

    public function filter_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'List Coupons'
            );
            $data['search'] = $this->input->post("search");

            if ($this->input->post("from") != "") {
                $data['from'] = date("Y-m-d", strtotime($this->input->post("from")));
            } else {
                $data['from'] = "";
            }
            if ($this->input->post("to") != "") {
                $data['to'] = date("Y-m-d", strtotime($this->input->post("to")));
            } else {
                $data['to'] = "";
            }

            $data['result'] = $this->admin->filtercoupons($data);
            if ($data['result'] != "") {

                $this->load->view('header/bread_crumb', $breadcrumb);

                $this->load->view('coupons', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no coupons in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_coupon_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
                'heading1' => 'Coupon Details',
                'heading1_url' => 'display_coupons',
                'heading2' => 'View Coupon Details'
            );
            $id = $_GET['id'];
            $data['coupons'] = $this->admin->show_coupon_details($id);
            $cat_id = explode(",", $data['coupons']->category);
            $sub_cat_id = explode(",", $data['coupons']->sub_category);
            $store_name = explode(",", $data['coupons']->store_name);
            $data['customer'] = $this->admin->get_customers($data['coupons']->customer_name);
            $data['store'] = $this->admin->get_stores($store_name);
            $data['category'] = $this->admin->get_category($cat_id);
            $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);


            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('coupon_details', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function edit_coupon() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
                'heading1' => 'Coupon Details',
                'heading1_url' => 'display_coupons',
                'heading2' => 'Edit Coupon Details'
            );
        }


        $id = $this->input->post('coupon_id');
        $data['coupons'] = $this->admin->show_coupon_details($id);
        $cat_id = explode(",", $data['coupons']->category);
        $sub_cat_id = explode(",", $data['coupons']->sub_category);
        $store_name = explode(",", $data['coupons']->store_name);
        $data['customer'] = $this->admin->get_customers(NULL);
        $data['store'] = $this->admin->get_stores($store_name);
        $data['category'] = $this->admin->get_category($cat_id);
        $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);

        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_coupons', $data);
        $this->load->view('footer/footer');
    }

    public function update_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                // 'heading1' => 'My Heading',
// 'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }

        $coupon_date = $this->input->post('coupon_date');
        list($launch_date, $expiry_date) = explode('to', $coupon_date);
        $launch_date = date('Y-m-d', strtotime($launch_date));
        $expiry_date = date('Y-m-d', strtotime($expiry_date));

        $store_list = $this->input->post('store_list');


        $categories = $this->input->post('category');
        $sub_categories = $this->input->post('sub_category');
        $keywords = $this->input->post('keywords');

        if (isset($categories)) {
            $category = implode(",", $categories);
        }
        if (isset($sub_categories)) {
            $sub_category = implode(",", $sub_categories);
        }
        if (isset($keywords)) {
            $key = implode(",", $keywords);
        }
        if (isset($store_list)) {
            $store_list = implode(",", $store_list);
        }

        $id = $this->input->post('coupon_id');
        if ($_POST != "") {
            $code_type = $this->input->post('codetype');
            $customer = $this->input->post('client');
            $cup_ons = $this->input->post('coupon_code');
            $barcode = $this->input->post('barcode_text');

            if ($code_type == "couponcode" && $cup_ons != "") {
                $data = array
                    (
                    'customer_name' => $this->input->post('client'),
                    'store_name' => $store_list,
                    'name' => $this->input->post('coupon_name'),
                    'quantity' => $this->input->post('quantity'),
                    'code_type' => $this->input->post('codetype'),
                    'category' => $category,
                    'sub_category' => $sub_category,
                    'couponcode' => $this->input->post('coupon_code'),
                    'promo_text_short' => $this->input->post('promotext_short'),
                    'coupon_description' => $this->input->post('coupon_description'),
                    'launch_date' => $launch_date,
                    'expiry_date' => $expiry_date,
                    'downloads' => $this->input->post('no_of_downloads'),
                    'terms_conditions' => $this->input->post('terms_conditions'),
                    'whats_hot' => $this->input->post('whats_hot'),
                    'national_coupon' => $this->input->post('national_coupon'),
                    'legal_url' => $this->input->post('legal_url'),
                    'reward_points' => $this->input->post('reward_points'),
                    'keywords' => $key
                );
                $data1['results'] = $this->admin->update_coupons($data, $id);
            } else if ($code_type == "barcode" && $barcode != "") {
                $barcode_type = $this->input->post('barcode_type');
                $barcode_text = $this->input->post('barcode_text');

                $data = array
                    (
                    'customer_name' => $this->input->post('client'),
                    'store_name' => $store_list,
                    'name' => $this->input->post('coupon_name'),
                    'quantity' => $this->input->post('quantity'),
                    'code_type' => $this->input->post('codetype'),
                    'category' => $category,
                    'sub_category' => $sub_category,
                    'barcodedata' => $barcode_text,
                    'bar_type' => $this->input->post('barcode_type'),
                    'promo_text_short' => $this->input->post('promotext_short'),
                    'coupon_description' => $this->input->post('coupon_description'),
                    'launch_date' => $launch_date,
                    'expiry_date' => $expiry_date,
                    'downloads' => $this->input->post('no_of_downloads'),
                    'terms_conditions' => $this->input->post('terms_conditions'),
                    'whats_hot' => $this->input->post('whats_hot'),
                    'national_coupon' => $this->input->post('national_coupon'),
                    'legal_url' => $this->input->post('legal_url'),
                    'reward_points' => $this->input->post('reward_points'),
                    'keywords' => $key
                );
                $data1['results'] = $this->admin->update_coupons($data, $id);
            }
            if (!empty($_FILES['coupon_thumbnail']['name'])) {
                $coupon_thumbnail = $_FILES['coupon_thumbnail']['name'];
                $upload_thumbnail = $this->uploadThumbFile($coupon_thumbnail, 'coupon_thumbnail');

                if ($upload_thumbnail) {
                    $data = array(
                        'coupon_thumbnail' => $upload_thumbnail['file_name']
                    );
                    $data1['results'] = $this->admin->update_coupons($data, $id);
                }
            }
            if (!empty($_FILES['coupon_image']['name'])) {
                $coupon_image = $_FILES['coupon_image']['name'];
                $upload_data = $this->uploadFile($coupon_image, 'coupon_image');

                if ($upload_data) {
                    $data = array(
                        'coupon_image' => $upload_data['file_name']
                    );
                    $data1['results'] = $this->admin->update_coupons($data, $id);
                }
            }
        }
        redirect('/admin/add_coupons');
    }

    public function delete_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data = $this->input->post("coupon_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_coupon($id);
                }
            }
            redirect('/admin/add_coupons');
        } else {
            redirect(base_url());
        }
    }

    /* Function to show coupon details -- Ends -- */




    /* Function to display Advertisements--Start-- */

    public function display_adverts() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Advertisements',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Advertisements Listing'
            );

            $data['result'] = $this->admin->displayadverts();

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('advertisements', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_advertisement() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Advertisement',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Add New Advertisement'
            );

            $data['customers'] = $this->admin->get_customers();
            $data['coupons'] = $this->admin->displaycoupons();
            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_advertisements', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function save_new_advertisement() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $advertisement_date = $this->input->post('advertisement_date');
            $start_time = $this->input->post('start_time');
            $end_time = $this->input->post('end_time');
            list($launch_date, $expiry_date) = explode('to', $advertisement_date);
            $launch_date = date('Y-m-d H:i:s', strtotime($launch_date . " " . $start_time));
            $expiry_date = date('Y-m-d H:i:s', strtotime($expiry_date . " " . $end_time));

            if ($_POST != "") {
                $data = array
                    (
//                    'advert_name' => $this->input->post('advert_name'),
                    'description' => $this->input->post('notes'),
                    'adv_type' => $this->input->post('type'),
                    'add_text' => $this->input->post('add_text'),
                    'hyperlink' => $this->input->post('hyperlink'),
                    'coupon' => $this->input->post('coupon'),
                    'valid_from' => $launch_date,
                    'valid_till' => $expiry_date,
                    'reward_points' => $this->input->post('reward_points'),
                    'customer' => $this->input->post('customer')
                );
                $result = $this->admin->add_new_advert($data);

                if (!empty($_FILES['banner_image']['name'])) {
                    $banner_image = $_FILES['banner_image']['name'];
                    $upload_data = $this->uploadFile($banner_image, 'banner_image');

                    if ($upload_data) {
                        $data = array(
                            'banner_image' => $upload_data['file_name']
                        );
                        $data1['results'] = $this->admin->update_advertisements($data, $result->id);
                    }
                }
            }
            redirect("admin/display_adverts");
        } else {
            redirect(base_url());
        }
    }

    public function show_advert_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Advertisement',
                'heading1' => 'Advertisement Details',
                'heading1_url' => 'display_advert',
                'heading2' => 'View Advertisement Details'
            );

            $id = $_GET['id'];
            $data['advertisement'] = $this->admin->show_advert_details($id);
            $data['coupon'] = $this->admin->get_coupons($data['advertisement']->coupon);
            $data['customer'] = $this->admin->get_customers($data['advertisement']->customer);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('advert_details', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function edit_advertisement_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Advertisements',
                'heading1' => 'Advertisement',
                'heading1_url' => 'display_advert',
                'heading2' => 'Edit Advertisement'
            );
        }
        $id = $this->input->post('advert_id');
        $data['advertisement'] = $this->admin->show_advert_details($id);
        $data['coupons'] = $this->admin->get_coupons(NULL);
        $data['customers'] = $this->admin->get_customers();

        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_advertisements', $data);
        $this->load->view('footer/footer');
    }

    public function update_advertisement() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }
        $id = $this->input->post('advert_id');
        $advertisement_date = $this->input->post('advertisement_date');
        $start_time = $this->input->post('start_time');
        $end_time = $this->input->post('end_time');
        list($launch_date, $expiry_date) = explode('to', $advertisement_date);
        $launch_date = date('Y-m-d H:i:s', strtotime($launch_date . " " . $start_time));
        $expiry_date = date('Y-m-d H:i:s', strtotime($expiry_date . " " . $end_time));


        if ($_POST != "") {
            $data = array
                (
//                    'advert_name' => $this->input->post('advert_name'),
                'description' => $this->input->post('notes'),
                'adv_type' => $this->input->post('type'),
                'add_text' => $this->input->post('add_text'),
                'hyperlink' => $this->input->post('hyperlink'),
                'coupon' => $this->input->post('coupon'),
                'valid_from' => $launch_date,
                'valid_till' => $expiry_date,
                'reward_points' => $this->input->post('reward_points'),
                'customer' => $this->input->post('customer')
            );
            $data['results'] = $this->admin->update_advertisements($data, $id);
            if (!empty($_FILES['banner_image']['name'])) {
                $banner_image = $_FILES['banner_image']['name'];
                $upload_data = $this->uploadFile($banner_image, 'banner_image');
                if ($upload_data) {
                    $data = array(
                        'banner_image' => $upload_data['file_name'],
                    );
                    $data['results'] = $this->admin->update_advertisements($data, $id);
                }
            }
        }
        $this->display_adverts();
    }

    public function delete_advertisement() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
            $data = $this->input->post("advt_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_advert($id);
                }
            }
            redirect('/admin/display_adverts');
        } else {
            redirect(base_url());
        }
    }

    /* Function to delete Advertisement -- End-- */





    /* Function to show store details -- Starts -- */

    public function display_stores() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Stores',
                //'heading1' => 'Stores',
                //'heading1_url' => 'display_stores',
                'heading2' => 'Stores'
            );

            $data['result'] = $this->admin->displaystores();
            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('stores', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no Stores in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_store() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Store',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Add New Store'
            );

            $data['countries'] = $this->admin->get_country_list();
            $data['timezones'] = $this->admin->get_timezones();
            $data['customers'] = $this->admin->get_customers();

            $data['category'] = $this->admin->get_category();

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_store', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function save_new_store() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                    // 'heading1_url' => 'My Message',
//'heading2' => 'Dashboard'
            );

            if ($_POST != "") {
                $timezone = $this->input->post('time_zone');
                $categories = $this->input->post('category');
                $sub_categories = $this->input->post('sub_category');
                $keywords = $this->input->post('keywords');
                $qr_text = str_replace(" ", "", $this->input->post('store_name')) . rand();
                if (isset($categories)) {
                    $category = implode(",", $categories);
                }
                if (isset($sub_categories)) {
                    $sub_category = implode(",", $sub_categories);
                }
                if (array_filter($keywords)) {
                    $key = implode(",", $keywords);
                    $key = rtrim($key, ",");
                } else {
                    $key = '';
                }
                $address = $this->input->post('address') . "%" . $this->input->post('address2');
				
				$this->load->library('geocoder');
				$address_details = $this->geocoder->geocode($address . ', ' . $this->input->post('city') . ' ' . $this->input->post('state') . ' ' . $this->input->post('zip'));
                $prepAddr = str_replace(' ', '+', $address);

                $data = array(
                    'customer' => $this->input->post('client'),
                    'categories' => $category,
                    'subcategories' => $sub_category,
                    'checkinpoints' => $this->input->post('checkin_points'),
                    'storename' => $this->input->post('store_name'),
                    'store_phone' => $this->input->post('store_phone'),
                    'description' => $this->input->post('description'),
                    'storenumber' => $this->input->post('store_number'),
                    'address' => $address_details['address'],
                    'country' => $this->input->post('country'),
                    'state' => $this->input->post('state'),
                    'city' => $address_details['city'],
                    'zip' => $address_details['zip_code'],
                    'latitude' => $address_details['lat'],
                    'longitude' => $address_details['lng'],
                    'timezone' => $this->input->post('time_zone'),
                    'url' => $this->input->post('legalurl'),
                    'keywords' => $key,
                    'qr_code' => $qr_text
                );
                $result = $this->admin->add_new_store($data);
                $hidden_thumb = $this->input->post('hidden_store_thumbnail');
                $hidden_image = $this->input->post('hidden_store_image');

                //Store Image
                if (!empty($_FILES['store_thumbnail']['name'])) {
                    $store_thumbnail = $_FILES['store_thumbnail']['name'];
                    $upload_thumb = $this->uploadThumbFile($store_thumbnail, 'store_thumbnail');
                    if ($upload_thumb) {
                        $data = array(
                            'thumbnailimage' => $upload_thumb['file_name']
                        );
                        $data1['results'] = $this->admin->update_store($data, $result->id);
                    }
                } else if (!empty($hidden_thumb)) {
                    $data = array(
                        'thumbnailimage' => $this->input->post('hidden_store_thumbnail')
                    );
                    $data1['results'] = $this->admin->update_store($data, $result->id);
                } else {
                    $data = array(
                        'thumbnailimage' => ""
                    );
                    $data1['results'] = $this->admin->update_store($data, $result->id);
                }

                //Store Image
                if (!empty($_FILES['store_image']['name'])) {
                    $store_image = $_FILES['store_image']['name'];
                    $upload_data = $this->uploadFile($store_image, 'store_image');
                    if ($upload_data) {
                        $data = array(
                            'storeimage' => $upload_data['file_name'],
                        );
                        $data1['results'] = $this->admin->update_store($data, $result->id);
                    }
                } else if (!empty($hidden_image)) {
                    $data = array(
                        'storeimage' => $this->input->post('hidden_store_image')
                    );
                    $data1['results'] = $this->admin->update_store($data, $result->id);
                } else {
                    $data = array(
                        'storeimage' => ""
                    );
                    $data1['results'] = $this->admin->update_store($data, $result->id);
                }
            }

            $this->display_stores();
        } else {
            redirect(base_url());
        }
    }

    public function show_store_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Store',
                'heading1' => 'Store details',
                'heading1_url' => 'display_stores',
                'heading2' => 'View Store Details'
            );

            $id = $_GET['id'];
            $data['id'] = $_GET['id'];
            $data['stores'] = $this->admin->show_store_details($id);
            $cat_id = explode(",", $data['stores']->categories);
            $sub_cat_id = explode(",", $data['stores']->subcategories);
            $data['country'] = $this->admin->get_country_list($data['stores']->country);
            $data['state'] = $this->admin->get_states_list(NULL, $data['stores']->state);
            $data['city'] = $this->admin->get_city_list(NULL, $data['stores']->city);
            $data['customer'] = $this->admin->get_customers($data['stores']->customer);
            $data['category'] = $this->admin->get_category($cat_id);
            $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('store_details', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no stores in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function edit_store_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Stores',
                'heading1' => 'Edit Store',
                'heading1_url' => 'display_stores',
                'heading2' => 'Edit Store'
            );
        }
        $id = $this->input->post('store_id');
        $data['id'] = $id;
        $data['stores'] = $this->admin->show_store_details($id);
        $cat_id = explode(",", $data['stores']->categories);
        $sub_cat_id = explode(",", $data['stores']->subcategories);
        $data['countries'] = $this->admin->get_country_list(NULL);
        $data['timezones'] = $this->admin->get_timezones(NULL);
        $data['state'] = $this->admin->get_states_list(NULL, $data['stores']->state);
        $data['city'] = $this->admin->get_city_list(NULL, $data['stores']->city);
        $data['customers'] = $this->admin->get_customers();
        $data['category'] = $this->admin->get_category($cat_id);
        $data['subcategory'] = $this->admin->get_sub_category(NULL, $sub_cat_id);
        $data['catid'] = $this->admin->get_category();

        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_stores', $data);
        $this->load->view('footer/footer');
    }

    public function update_store() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }
        if ($_POST != "") {
            $id = $this->input->post('store_id');
            $timezone = $this->input->post('time_zone');
            $longitude = $this->input->post('longitude');
            $lattitude = $this->input->post('lattitude');
            $categories = $this->input->post('category');
            $sub_categories = $this->input->post('sub_category');
            $keywords = $this->input->post('keywords');
            if (isset($categories)) {
                $category = implode(",", $categories);
            }
            if (isset($sub_categories)) {
                $sub_category = implode(",", $sub_categories);
            }
            if (array_filter($keywords)) {
                $key = implode(",", $keywords);
                $key = rtrim($key, ",");
            } else {
                $key = '';
            }

            $hidden_thumb = $this->input->post('hidden_store_thumbnail');
            $hidden_image = $this->input->post('hidden_store_image');

            if (!empty($_FILES['store_thumbnail']['name'])) {
                $store_thumbnail = $_FILES['store_thumbnail']['name'];
                $upload_thumb = $this->uploadThumbFile($store_thumbnail, 'store_thumbnail');
                if ($upload_thumb) {
                    $data = array(
                        'thumbnailimage' => $upload_thumb['file_name'],
                    );
                    $data1['results'] = $this->admin->update_store($data, $id);
                }
            } else if (!empty($hidden_thumb)) {
                $data = array(
                    'thumbnailimage' => $this->input->post('hidden_store_thumbnail')
                );
                $data1['results'] = $this->admin->update_store($data, $id);
            } else {
                $data = array(
                    'thumbnailimage' => ""
                );
                $data1['results'] = $this->admin->update_store($data, $id);
            }



            if (!empty($_FILES['store_image']['name'])) {
                $store_image = $_FILES['store_image']['name'];

                $upload_data = $this->uploadFile($store_image, 'store_image');
                if ($upload_data) {
                    $data = array(
                        'storeimage' => $upload_data['file_name'],
                    );
                    $data1['results'] = $this->admin->update_store($data, $id);
                }
            } else if (!empty($hidden_image)) {
                $data = array(
                    'storeimage' => $this->input->post('hidden_store_image')
                );
                $data1['results'] = $this->admin->update_store($data, $id);
            } else {
                $data = array(
                    'storeimage' => ""
                );
                $data1['results'] = $this->admin->update_store($data, $id);
            }

            $data = array(
                'customer' => $this->input->post('client'),
                'categories' => $category,
                'subcategories' => $sub_category,
                'checkinpoints' => $this->input->post('checkin_points'),
                'storename' => $this->input->post('store_name'),
                'store_phone' => $this->input->post('store_phone'),
                'description' => $this->input->post('description'),
                'storenumber' => $this->input->post('store_number'),
                'address' => $this->input->post('address') . "%" . $this->input->post('address2'),
                'country' => $this->input->post('country'),
                'state' => $this->input->post('state'),
                'city' => $this->input->post('city'),
                'zip' => $this->input->post('zip'),
                'latitude' => $lattitude,
                'longitude' => $longitude,
                'timezone' => $timezone,
                'url' => $this->input->post('legalurl'),
                'keywords' => $key
            );
            $data1['results'] = $this->admin->update_store($data, $id);
        }
        redirect("admin/display_stores");
    }

    public function delete_stores() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data = $this->input->post("store_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_stores($id);
                }
            }
            redirect('/admin/display_stores');
        } else {
            redirect(base_url());
        }
    }

    /* Function to show store details -- Ends -- */



    /* Function to display surveys --Start-- */

    public function display_surveys() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Survey',
                'heading1' => 'Survey Details',
                'heading1_url' => 'display_surveys',
                'heading2' => ''
            );

            $data['result'] = $this->admin->get_surveylist();

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('display_survey', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function get_surveys() {
        $params = array('key' => 'kjbjfhtsqey9npwd3kq7djch', 'token' => 'UFHR1aBDl2QjFoOzyDhoj91aM1Q3Atp-HtOvcI8kBk.HIBEdrGLtGKLnbSmHGcE-W1gRHlpGDjjzfvEGvP5aYBSeJFxrC85U1KiJOhE4-68=');
        $this->load->library('survey_monkey', $params);
        $result = $this->survey_monkey->getSurveyList(
                array(
                    "fields" => array(
                        "title",
                        "analysis_url",
                        "date_created",
                        "date_modified",
                        "question_count",
                        "num_responses",
                        "language_id",
                        "survey_id"
                    )
                )
        );
        if ($result["success"]) {
            //print_r($result["data"]);
            foreach ($result["data"]["surveys"] as $survey) {
                $id = $survey["survey_id"];
                $data = array(
                    "survey_id" => $survey["survey_id"],
                    "title" => $survey["title"],
                    "analysis_url" => $survey["analysis_url"],
                    "date_created" => $survey["date_created"],
                    "date_modified" => $survey["date_modified"],
                    "question_count" => $survey["question_count"],
                    "num_responses" => $survey["num_responses"],
                    "language_id" => $survey["language_id"]
                );
                $this->admin->insert_surveylist($data, $id);
            }
        }

        redirect("admin/display_surveys");
    }

    /* Function to Survey --End-- */


    /* Function to Display Reports --Start-- */

    public function get_subscriber_report() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('subscriber_dashboard');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function get_coupon_summary() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $active = true;
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('get_coupon_summary');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function get_coupon_summary_report() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                'heading2' => 'Dashboard'
            );

            $data['res'] = array(
                'customer_name' => $this->input->post('customer_name'),
                'start_date' => $this->input->post('start_date'),
                'end_date' => $this->input->post('end_date'),
            );

            //$this->load->view('header/bread_crumb', $breadcrumb);
            $data['result'] = $this->admin->get_coupon_summary_report($data);
            $this->load->view('coupon_summary_report', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function coupon_detailed_report() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $this->load->view('header/side_menu');
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('coupon_detailed_report');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function display_coupon_detailed_report() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                'heading2' => 'Dashboard'
            );

            $data['res'] = array(
                'start_date' => $this->input->post('start_date'),
                'end_date' => $this->input->post('end_date'),
            );

            //$this->load->view('header/bread_crumb', $breadcrumb);
            $data['result'] = $this->admin->display_coupon_detailed_report($data);
            $this->load->view('display_coupon_detailed_report', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    /* Function to Display Reports --Ends-- */




    /* Function Show Gift Card Details -- Starts -- */

    public function display_giftcards() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Gift Cards',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Advertisement Listing'
            );


//            $caCertPath = __DIR__ . "/ssl/cacert.pem";
//            $cred = base64_encode('Q2Intel:/D68OARykc7RPWHrwDag7BAkswPJpTivjTXKLANj+Z3Gjry7W8pJxxwcVpU=');
//
//            $ch = curl_init();
//            curl_setopt($ch, CURLOPT_URL, 'https://api.tangocard.com/raas/v1/rewards');
//            curl_setopt($ch, CURLOPT_PORT, 443);
//            curl_setopt($ch, CURLOPT_VERBOSE, 0);
//            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
//            curl_setopt($ch, CURLOPT_HTTPGET, true);
//            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');
//            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
//            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
//            curl_setopt($ch, CURLOPT_CAINFO, $caCertPath);
//            curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Basic ' . $cred, 'Content-Type: application/json; charset=utf-8'));
//
//            $responseJsonEncoded = curl_exec($ch);
//            $response = json_decode($responseJsonEncoded);
//
//            foreach ($response->brands as $card) {
//                foreach ($card->rewards as $rewards) {
//                    if(empty($rewards->min_price)){
//                       $rewards->min_price = "";
//                    }
//                    if(empty($rewards->max_price)){
//                       $rewards->max_price = "";
//                    }
//                    $data = array(
//                        "card_name" => $card->description,
//                        "description" => $rewards->description,
//                        "image_url" => $card->image_url,
//                        "reward_price" => $rewards->unit_price,
//                        "reward_min_price" => $rewards->min_price,
//                        "reward_max_price" => $rewards->max_price
//                    );
//                    
////                    $get_data = $this->display_giftcards($card->description);
////                    if ($get_data == 0) {
//                        $this->admin->insert_giftcards($data);
////                    }
//                }
//            }

            $data['result'] = $this->admin->display_giftcards(NULL);
            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('gift_cards', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_giftcard_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Gift Cards',
                'heading1' => 'Gift Card',
                'heading1_url' => 'display_giftcards',
                'heading2' => 'View Gift Card'
            );

            $id = $_GET['id'];
//exit;
            $data['cards'] = $this->admin->show_giftcard_details($id);

            if ($data != "") {
                $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('giftcard_details', $data);

                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function edit_giftcard() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Gift Card',
                'heading1' => 'Gift Cards',
                'heading1_url' => 'display_giftcards',
                'heading2' => 'Edit Gift Card'
            );
        }

        $id = $this->input->post('card_id');
        $data['card'] = $this->admin->get_giftcard_details($id);
        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_giftcard', $data);
        $this->load->view('footer/footer');
    }

    public function update_giftcard() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                'heading2' => 'Dashboard'
            );
        }
        $id = $this->input->post('card_id');
        $data = array(
            'card_name' => $this->input->post('card_name'),
            'reward_points' => $this->input->post('reward_points'),
            'description' => $this->input->post('description')
        );

        $data = $this->admin->update_giftcard($data, $id);
        if (!empty($data)) {
            redirect("admin/display_giftcards");
        }
    }

    public function delete_giftcard() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );


            $data1['id'] = $this->input->post("id");
            $this->admin->delete_giftcard($data1);
            $data['result'] = $this->admin->displaygiftcards();
            if ($data != "") {
                //$this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('giftcards', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no customers in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    /* Function Gift Card Details -- Ends -- */





    /* Function to display notifications --Start-- */

    public function display_notifications() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Notifications',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'List Notifications'
            );

            $data['result'] = $this->admin->displaynotifications();
//print_r($data);


            if ($data != "") {

                $this->load->view('header/bread_crumb', $breadcrumb);

                $this->load->view('notifications', $data);

                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function add_notification() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Notification',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Add Notification'
            );

            $data['result'] = $this->admin->getcampaigns();
            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_notification', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function add_new_notification() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            if ($_POST != "") {
                $data = array
                    (
                    'notification_name' => $this->input->post('notification_name'),
                    'notificationtext' => $this->input->post('notificationtext'),
                    'notifyon' => $this->input->post('notifyon'),
                    'launch_date' => $this->input->post('launch_date'),
                    'launch_time' => $this->input->post('launch_time'),
                    'customer' => $this->input->post('customer'),
                );
                $result = $this->admin->add_new_notification($data);
            }
            if ($result == 1) {
                redirect("admin/display_notifications");
            } else {
//$this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('add_notification');
                $this->load->view('footer/footer');
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_notification_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data['id'] = $_GET['id'];
            $data['res'] = $this->admin->show_notification_details($data);
            if ($data != "") {
                $this->load->view('notification_details', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function update_notification_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }

        $data2['res'] = array(
            'id' => $this->input->post('id'),
            'notification_name' => $this->input->post('notification_name'),
            'notificationtext' => $this->input->post('notificationtext'),
            'notifyon' => $this->input->post('notifyon'),
            'launch_date' => $this->input->post('launch_date'),
            'launch_time' => $this->input->post('launch_time'),
        );

        $this->load->view('update_notification', $data2);
        $this->load->view('footer/footer');
    }

    public function update_notification() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }

        $data = array(
            'id' => $this->input->post('id'),
            'notification_name' => $this->input->post('notification_name'),
            'notificationtext' => $this->input->post('notificationtext'),
            'notifyon' => $this->input->post('notifyon'),
            'launch_date' => $this->input->post('launch_date'),
            'launch_time' => $this->input->post('launch_time'),
        );

        $data1['results'] = $this->admin->update_notifications($data);
        if ($data1 != "") {
            $data['result'] = $this->admin->displaynotifications();

            if ($data != "") {
		// $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('notifications', $data);
                $this->load->view('footer/footer');
            }
        }
    }

    public function delete_notification() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
//            $data1['id'] = $this->input->post("id");
//            $this->admin->delete_notification($data1);
//            $data['result'] = $this->admin->displaynotifications();
//            if ($data != "") {
////$this->load->view('header/bread_crumb', $breadcrumb);
//                $this->load->view('notifications', $data);
//                $this->load->view('footer/footer');
//            } else {
//                echo "There are no customers in the DB";
//            }
            $data = $this->input->post("notify_id");
            if ($data != NULL) {
                foreach ($data as $value => $id) {
                    $res_data = $this->admin->delete_notification($id);
                }
            }
            redirect('/admin/display_notifications');
        } else {
            redirect(base_url());
        }
    }

    /* Function to display notifications --End-- */




    /* Function Show Campaign Details -- Starts -- */

    public function add_campaigns() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data['result'] = $this->admin->displaycampaigns();
//$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('campaigns', $data);
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function add_campaign_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );



//$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_campaigns');
            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    public function add_new_campaign() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
            if ($_POST != "") {
                $data = array
                    (
                    'name' => $this->input->post('campaignname'),
                    'validfrom' => $this->input->post('validfrom'),
                    'validtill' => $this->input->post('validtill'),
                    'starttime' => $this->input->post('starttime'),
                    'endtime' => $this->input->post('endtime'),
                    'customer' => $this->input->post('customer'),
                    'notes' => $this->input->post('notes'),
                    'active' => $this->input->post('active'),
                );



                $result = $this->admin->add_new_campaign($data);
            }


            if ($result == 1) {

                $data['result'] = $this->admin->displaycampaigns();

                if ($data != "") {
//$this->load->view('header/bread_crumb', $breadcrumb);
                    $this->load->view('campaigns', $data);
                    $this->load->view('footer/footer');
                } else {
                    echo "There are no customers in the DB";
                }
            } else {
//$this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('add_giftcard');
                $this->load->view('footer/footer');
            }
        } else {
            redirect(base_url());
        }
    }

    public function show_campaign_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data['id'] = $_GET['id'];
//exit;
            $data['res'] = $this->admin->show_campaign_details($data);
            if ($data != "") {
                $this->load->view('campaign_details', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no users in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    public function update_campaign_form() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }

//        $data2['res'] = array(
//            'id' => $this->input->post('id'),
//            'name' => $this->input->post('name'),
//            'description' => $this->input->post('description'),
//            'randomize' => $this->input->post('randomize'),
//            'validfrom' => $this->input->post('validfrom'),
//            'validtill' => $this->input->post('validtill'),
//            'starttime' => $this->input->post('starttime'),
//            'endtime' => $this->input->post('endtime'),
//            'notes' => $this->input->post('notes'),
//            'expiry_date' => $this->input->post('expiry_date'),
//            'user_id' => $this->input->post('user_id'),
//            'active' => $this->input->post('active'),
//        );
//        //print_r($data2);
//        //exit;
        $this->load->view('header/bread_crumb', $breadcrumb);
        $this->load->view('update_campaigns', $data2);
        $this->load->view('footer/footer');
    }

    /* Function to update campaigns in db --Starts-- */

    public function update_campaigns() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //'heading1' => 'My Heading',
//'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );
        }
        $data = array(
            'id' => $this->input->post('id'),
            'name' => $this->input->post('name'),
            'description' => $this->input->post('description'),
            'randomize' => $this->input->post('randomize'),
            'validfrom' => $this->input->post('validfrom'),
            'validtill' => $this->input->post('validtill'),
            'starttime' => $this->input->post('starttime'),
            'endtime' => $this->input->post('endtime'),
            'expiry_date' => $this->input->post('expiry_date'),
            'user_id' => $this->input->post('user_id'),
            'validity' => $this->input->post('validity'),
            'active' => $this->input->post('active'),
        );

        $data1['results'] = $this->admin->update_campaigns($data);
        if ($data1 != "") {
            $data['result'] = $this->admin->displaycampaigns();

            if ($data != "") {
// $this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('campaigns', $data);
                $this->load->view('footer/footer');
            }
        }
    }

    public function delete_campaign() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
                //               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );

            $data1['id'] = $this->input->post("id");
            $this->admin->delete_campaign($data1);
            $data['result'] = $this->admin->displaycampaigns();
            if ($data != "") {
//$this->load->view('header/bread_crumb', $breadcrumb);
                $this->load->view('campaigns', $data);
                $this->load->view('footer/footer');
            } else {
                echo "There are no customers in the DB";
            }
        } else {
            redirect(base_url());
        }
    }

    /* Function Show Campaign Details -- Ends -- */

    private function check_isvalidated() {
        if (!$this->session->userdata('validated')) {
            redirect('login');
        }
    }

    public function get_sub_category() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Manage Coupons',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'List Coupons'
            );
            $id = $this->input->post("cid");
            $data['sub_category'] = $this->admin->get_sub_category($id);

            $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view("get_ajax_data", $data);
        } else {
            redirect(base_url());
        }
    }

    /* Image upload   */

    public function uploadFile($image_name, $element_name) {
        $this->load->helper('form');
        
        $file_name = $this->file_name($image_name);
        $extension = $this->file_extension($image_name);

        $config['upload_path'] = 'uploads/';
        $config['allowed_types'] = 'gif|jpg|png';
        $config['file_name'] = $file_name . "_" . time() . "." . $extension;
        
       // $this->load->library('upload');
        $this->upload->initialize($config);

        if (!$this->upload->do_upload($element_name)) {
//echo $data['msg'] = "Error in uploading File";
//echo $msg;
//$this->load->view('profile', $data);
        } else {
            $data = $this->upload->data();
            $up_data = array(
                'file_name' => $data['file_name'],
                'file_type' => $data['file_type']
            );
            return $up_data;
        }
    }

    public function uploadThumbFile($image_name, $element_name) {
        $this->load->helper('form');

        $file_name = $this->file_name($image_name);
        $extension = $this->file_extension($image_name);
        $config['upload_path'] = 'uploads/thumb';
        $config['allowed_types'] = 'gif|jpg|png';
        $config['file_name'] = $file_name . "_thumb_" . time() . "." . $extension;

//        $this->load->library('upload', $config);
        $this->upload->initialize($config);
        if (!$this->upload->do_upload($element_name)) {
//echo $data['msg'] = "Error in uploading File";
//echo $msg;
//$this->load->view('profile', $data);
        } else {
            $data = $this->upload->data();
            $thumb_data = array(
                'file_name' => $data['file_name'],
                'file_type' => $data['file_type']
            );

            return $thumb_data;
        }
    }

    function file_name($file_name) {
        $exploded = explode('.', $file_name);

        // if no extension
        if (count($exploded) == 1) {
            return $file_name;
        }

        // remove extension
        array_pop($exploded);

        return implode('.', $exploded);
    }

    function file_extension($path) {
        $extension = substr(strrchr($path, '.'), 1);
        return $extension;
    }

    /* Image upload */

//Upload Image function

    function multiple_upload($upload_dir = 'http://couwalla.gripd.com/uploads/', $config = array()) {
        $CI = & get_instance();
        $files = array();


        if (empty($config)) {
            $config['upload_path'] = 'http://couwalla.gripd.com/uploads/';
            $config['allowed_types'] = 'gif|jpg|jpeg|jpe|png';
            $config['max_size'] = '2048';
        }


        $CI->load->library('upload', $config);

        $errors = FALSE;

        foreach ($_FILES as $key => $value) {
            if (!empty($value['name'])) {


                if (!$CI->upload->do_upload($key)) {

                    $data['upload_message'] = $CI->upload->display_errors(); // ERR_OPEN and ERR_CLOSE are error delimiters defined in a config file
                    $CI->load->vars($data);

                    $errors = TRUE;
                } else {

// Build a file array from all uploaded files
                    $files[] = $CI->upload->data();
                }
            }
        }

// There was errors, we have to delete the uploaded files
        if ($errors) {
            foreach ($files as $key => $file) {
                @unlink($file['full_path']);
            }
        } elseif (empty($files) AND empty($data['upload_message'])) {
            $CI->lang->load('upload');
// $data['upload_message'] = ERR_OPEN.$CI->lang->line('upload_no_file_selected').ERR_CLOSE;
// $CI->load->vars($data);
        } else {
            return $files;
        }
    }

    /* test Function Delete after use */

    public function date_t() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                'heading2' => 'Dashboard'
            );



// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('data_t');

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

    /*  test Function Delete after use --End-- */




    /* Function to generate csv -- Starts -- */

    function create_csv() {
        $this->load->helper('csv_helper');


        $quer = $this->db->query('SELECT * FROM coupons');


        query_to_csv($quer, FALSE, 'Coupons_summery_' . '.csv');
        exit;
    }

    function coupons_detailed_report_csv() {
        $this->load->helper('csv_helper');


        $quer = $this->db->query('SELECT * FROM coupons');


        query_to_csv($quer, FALSE, 'Coupons_Detailed_summery_' . '.csv');
        exit;
    }

    /* Function to generate csv -- Starts -- */
}
