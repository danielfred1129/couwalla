<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');
/* Author: Jorge Torres
 * Description: Home controller class
 * This is only viewable to those members that are logged in
 */

class Admin extends CI_Controller {

    function __construct() {
        parent::__construct();
        $this->check_isvalidated();
        $this->load->model('admin_model', 'admin');

        $this->id = $this->session->userdata('userid');

//        if ($this->uri->segment(2) != "getsubscrstudlist" && $this->uri->segment(2) != "getfeedbacklist" && $this->uri->segment(2) != "getmessages" && $this->uri->segment(2) != "getschedulelist") {
        $this->load->view('header/header');
        $this->load->view('header/side_menu');
//        }
    }

    public function index() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
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
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );



            //$this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('subscriber_dashboard');

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }
    /* Function to Display Subscriber Dashboard --Ends-- */



 /* Function to Display Subscriber Report Page --Start-- */

  public function get_subscriber_report() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );



            //$this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('subscriber_dashboard');

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }

	
 /* Function to Display Subscriber Dashboard --Ends-- */



	  /* Function to Display Coupon Summery Page --Starts-- */
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
    /* Function to Display Coupon Summery Page --Ends-- */





	 /* Function to Display Coupon Summery Report --Starts-- */
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

            $this->load->view('coupon_summary_report',$data);

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }
    /* Function to Display Coupon Summery Report --Ends-- */




 /* Function to Display Coupon Detailed Report Page --Starts-- */
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
  /* Function to Display Coupon Detailed Report Page --Ends-- */


   /* Function to Display Coupon Detailed Report --Starts-- */
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

            $this->load->view('display_coupon_detailed_report',$data);

            $this->load->view('footer/footer');
        } else {
            redirect(base_url());
        }
    }
    /* Function to Display Coupon Detailed Report --Ends-- */


	
	/* Function to display users --Start-- */

	 public function display_users() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displayusers();
     
			
        if ($data != "") {
         
         	// $this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('header/side_menu',$data);
            $this->load->view('users',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }

   /* Function to display Users --End-- */






 /* Function Show User Profile -- Starts -- */

 public function show_user_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_userprofile($data);
       
        if ($data != "") {
    
            $this->load->view('user_profile',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/* Function Show User Profile -- Ends --*/


	/* Function Show Gift Card Details -- Starts -- */

 public function show_giftcard_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_giftcard_details($data);
       
        if ($data != "") {
    
            $this->load->view('giftcard_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/* Function Show Gift Card Details -- Ends --*/



/* Function Show Campaign Details -- Starts -- */

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
    
            $this->load->view('campaign_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/* Function Show Gift Card Details -- Ends --*/





   /* Function To Show Notification Details -- Starts -- */

 public function show_notification_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_notification_details($data);
       
        if ($data != "") {
    
            $this->load->view('notification_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/*Function To Show Notification Details -- Ends --*/





	 /* Function Show Customer Profile -- Starts -- */

 public function show_customer_profile() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_customerprofile($data);
       
        if ($data != "") {
    
            $this->load->view('customer_profile',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/* Function Show Customer Profile -- Ends --*/





/* Function to show store details -- Starts -- */

 public function show_store_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_store_details($data);
       
        if ($data != "") {
    
            $this->load->view('store_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/*Function to show store details -- Ends --*/




	/* Function To Show Advert Details -- Starts -- */

 public function show_advert_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			
         $data['res'] = $this->admin->show_advert_details($data);
       
        if ($data != "") {
    
            $this->load->view('advert_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/*  Function To Show Advert Details-- Ends --*/



	/* Function to show coupon details -- Starts -- */

 public function show_coupon_details() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
			 $data['id'] = $_GET['id'];
			 //exit;
         $data['res'] = $this->admin->show_coupon_details($data);
       
        if ($data != "") {
    
            $this->load->view('coupon_details',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


	/*Function to show coupon details -- Ends --*/










 


	/*Function to display update user page --Start */

public function update_customer()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }

            $data2['res'] = array(

			'id' => $this->input->post('id'),      
			'companyname' => $this->input->post('companyname'),
			'adminusername' => $this->input->post('adminusername'),
			'fullname' => $this->input->post('fullname'),
			'isrealbrand' => $this->input->post('isrealbrand'),
			'thumbnailimage' => $this->input->post('thumbnailimage'),
			'companyimage' => $this->input->post('companyimage'),
			'contactname' => $this->input->post('contactname'),
			'email' => $this->input->post('email'),
			'corporateaddress' => $this->input->post('corporateaddress'),
			'corporateaddress2' => $this->input->post('corporateaddress2'),
			'address' => $this->input->post('address'),
			'zipcode' => $this->input->post('zipcode'),
			'contactno' => $this->input->post('isrealbrand'),
			'legalurl' => $this->input->post('legalurl'),
			'keyword' => $this->input->post('keyword'),

			);


			 $data1['results'] = $this->admin->update_customer($data2);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaycustomers();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

           $this->load->view('customers',$data);
              $this->load->view('footer/footer');
			   }

		}
		

             
        
	}

/*Function to display update user page --Ends */




 /* Function to Delete user --Start--*/

 public function delete_user() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_users($data1);
             
            $data['result'] = $this->admin->displayusers();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('users',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no users in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }

   /* Function to Delete user --End-- */



    /*Function to display add new user page -- Starts--*/
     public function add_user() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_user');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }
	 /*Function to display add new user page --Ends--*/




   /*  Functions to add new users --START--  */
 
	 public function add_new_user() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);
					  if($_POST!= "")
				{
					 $data = array(
						'username' => $this->input->post('username'),
						'password'=> '',
						'firstname' => $this->input->post('firstname'),
						'lastname' => $this->input->post('lastname'),
						'contact_info' => $this->input->post('nontactno'),
						'enabled' => '',
						'role' => '',
						'brand_name' => '',
						'description' => '',
						'logo' => 'logo',
						'laungage_id'=> '',
						'email'  =>$this->input->post('email'),
						'customer' => $this->input->post('customer'),
						'active' => $this->input->post('active'),
					
				      );
				 
				 
				 $result = $this->admin->add_new_user($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displayusers();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('users',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no users in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_user');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

 /* Function to add new users --END-- */





/* Function to update users --Starts-- */

public function update_user()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }

			
            $data = array(

                'id' => $this->input->post('id'),      
				'username' => $this->input->post('username'),
				'firstname' => $this->input->post('firstname'),
				'lastname' => $this->input->post('lastname'),
				'email' => $this->input->post('email'),
				'contactno' => $this->input->post('contactno'),

			);
			//print_r($data);
			//exit;
			
		     $data1['results'] = $this->admin->update_user($data);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displayusers();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('users',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update users --Ends-- */





public function update_user_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }


            $data2['res'] = array(

               'id' => $this->input->post('id'),      
				'username' => $this->input->post('username'),
				'firstname' => $this->input->post('firstname'),
				'lastname' => $this->input->post('lastname'),
				'email' => $this->input->post('email'),
				'contactno' => $this->input->post('contactno'),

			);
			//print_r($data2);
			//exit;

              $this->load->view('update_users',$data2);
              $this->load->view('footer/footer');
        
	}



public function update_campaign_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }


			 

            $data2['res'] = array(

               'id' => $this->input->post('id'),      
				'name' => $this->input->post('name'),
				'description' => $this->input->post('description'),
				'randomize' => $this->input->post('randomize'),
				'validfrom' => $this->input->post('validfrom'),
				'validtill' => $this->input->post('validtill'),
                'starttime' => $this->input->post('starttime'),
				'endtime' => $this->input->post('endtime'),
				'notes' => $this->input->post('notes'),
				'expiry_date' => $this->input->post('expiry_date'),
                'user_id' => $this->input->post('user_id'),
				'active' => $this->input->post('active'),


			);
			//print_r($data2);
			//exit;

              $this->load->view('update_campaigns',$data2);
              $this->load->view('footer/footer');
        
	}


	public function update_advert_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
         
		 

            $data2['res'] = array(

               'id' => $this->input->post('id'),      
				'advert_name' => $this->input->post('advert_name'),
				'description' => $this->input->post('description'),
				'add_text' => $this->input->post('add_text'),
				'valid_from' => $this->input->post('valid_from'),
				'valid_till' => $this->input->post('valid_till'),

				'check_points' => $this->input->post('check_points'),
				'banner_image' => $this->input->post('banner_image'),
				'customer' => $this->input->post('customer'),
				'type' => $this->input->post('type'),
				'campaign' => $this->input->post('campaign'),
				'active' => $this->input->post('active'),

			);
			//print_r($data2);
			//exit;

              $this->load->view('update_advertisements',$data2);
              $this->load->view('footer/footer');
        
	}




	public function update_giftcard_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
        

            $data2['res'] = array(

               'id' => $this->input->post('id'),      
				'displayname' => $this->input->post('displayname'),
				'number' => $this->input->post('number'),
				'security_code' => $this->input->post('security_code'),
				'thumbnailimage' => $this->input->post('thumbnailimage'),
				'fullimage' => $this->input->post('fullimage'),

				'barcodetype' => $this->input->post('barcodetype'),
				'validfrom' => $this->input->post('validfrom'),
				'validtill' => $this->input->post('validtill'),
				'points' => $this->input->post('points'),
				'savings' => $this->input->post('savings'),
				'quantity' => $this->input->post('quantity'),
					'legalurl' => $this->input->post('legalurl'),

			);
			//print_r($data2);
			//exit;

              $this->load->view('update_giftcard',$data2);
              $this->load->view('footer/footer');
        
	}




	public function update_notification_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }




			 //exit;
            $data2['res'] = array(

               'id' => $this->input->post('id'),      
				'notification_name' => $this->input->post('notification_name'),
				'notificationtext' => $this->input->post('notificationtext'),
				'notifyon' => $this->input->post('notifyon'),
				'launch_date' => $this->input->post('launch_date'),
				'launch_time' => $this->input->post('launch_time'),

			);
			//print_r($data2);
			//exit;

              $this->load->view('update_notification',$data2);
              $this->load->view('footer/footer');
        
	}




public function update_store_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }


			//print_r($_POST);
			// echo $username = $this->input->post('username');


			 //exit;
            $data2['res'] = array(

                'id' => $this->input->post('id'),      
				'storename' => $this->input->post('storename'),
				'storenumber' => $this->input->post('storenumber'),
				'customer' => $this->input->post('customer'),
				'description' => $this->input->post('description'),
                  'address' => $this->input->post('address'),
                'checkinpoints' => $this->input->post('checkinpoints'),
				'latitude' => $this->input->post('latitude'),
				'longitude' => $this->input->post('longitude'),
				'timezone' => $this->input->post('timezone'),
                'legalurl' => $this->input->post('legalurl'),
				'thumbnailimage' => $this->input->post('thumbnailimage'),
                'storeimage' => $this->input->post('storeimage'),

			);
		

              $this->load->view('update_stores',$data2);
              $this->load->view('footer/footer');
        
	}




	public function update_customer_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
 
       
            $data2['res'] = array(



					'id' => $this->input->post('id'),      
					'companyname' => $this->input->post('companyname'),
					'adminusername' => $this->input->post('adminusername'),
					'password' => $this->input->post('password'),
					'fullname' => $this->input->post('fullname'),
					'description' => $this->input->post('description'),
					'categories' => $this->input->post('categories'),
					'thumbnailimage' => $this->input->post('thumbnailimage'),
					'companyimage' => $this->input->post('companyimage'),
					'subscribertype' => $this->input->post('subscribertype'),
					'contactname' => $this->input->post('contactname'),
					'corporateaddress' => $this->input->post('corporateaddress'),
					'address' => $this->input->post('address'),
					'zipcode' => $this->input->post('zipcode'),
					'contactno' => $this->input->post('contactno'),
					'url' => $this->input->post('url'),
					
			);
			//print_r($data2);
			//exit;

              $this->load->view('update_customer',$data2);
              $this->load->view('footer/footer');
        
	}



	public function update_coupon_form()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }


            $data2['res'] = array(

					'id' => $this->input->post('id'),      
					'customer_name' => $this->input->post('customer_name'),
					'store_name' => $this->input->post('store_name'),
					'name' => $this->input->post('name'),
					'code_type' => $this->input->post('code_type'),
					'categories' => $this->input->post('categories'),
					'promotextshort' => $this->input->post('promotextshort'),
					'promotextlong' => $this->input->post('promotextlong'),
					'coupon_description' => $this->input->post('coupon_description'),
					'coupon_thumbnail' => $this->input->post('coupon_thumbnail'),
					'coupon_image' => $this->input->post('coupon_image'),
					'launch_date' => $this->input->post('launch_date'),
					'expiry_date' => $this->input->post('expiry_date'),
					'savings' => $this->input->post('savings'),
					'validity' => $this->input->post('validity'),
					'downloads' => $this->input->post('downloads'),
					'rewardpoints_on_redemption' => $this->input->post('rewardpoints_on_redemption'),
			);
			//print_r($data2);
			//exit;

              $this->load->view('update_coupons',$data2);
              $this->load->view('footer/footer');
        
	}




	/* Function to update coupons in db --Starts-- */

public function update_coupons()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
                
					if(!$_FILES)
					{
						$data1= $this->multiple_upload();
						$thumbnailimage = $data1['0']['file_name'];
						$couponimage = $data1['1']['file_name'];
						
                    }else{

                      $thumbnailimage =$this->input->post('thumbnailimage');
					  $couponimage = $this->input->post('couponimage');
					}

				
				
            $data = array(

                'id' => $this->input->post('id'),      
				'customer_name' => $this->input->post('customer_name'),
				'store_name' => $this->input->post('store_name'),
				'name' => $this->input->post('name'),
				'code_type' => $this->input->post('code_type'),
                'promotextshort' => $this->input->post('promotextshort'),
                'promotextlong' => $this->input->post('promotextlong'),
                'launch_date' => $this->input->post('launch_date'),
				'expiry_date' => $this->input->post('expiry_date'),
				'savings' => $this->input->post('savings'),
                'validity' => $this->input->post('validity'),
                'downloads' => $this->input->post('downloads'),
				'rewardpoints_on_redemption' => $this->input->post('rewardpoints_on_redemption'),
				'thumbnailimage'=>$thumbnailimage,
				'couponimage'=>$couponimage
               

			);
				
			
		     $data1['results'] = $this->admin->update_coupons($data);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaycoupons();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('coupons',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update coupons in db --Ends-- */





   

/*
public function updateTeacherDetails() {
        if (empty($_FILES['userfile']['name'])) {
            $img = $this->input->post('photo');
        } else {
//            if ($this->input->post('upload')) {
            $config = array(
                'allowed_types' => 'jpg|jpeg|gif|png',
                'upload_path' => $this->upload1_path,
                'max_size' => 200000,
                'file_name' => date("YmdHis")
            );

            $this->load->library('upload', $config);
            $this->upload->do_upload();
            $image_data = $this->upload->data();
            $img = $image_data['file_name'];
//            }
        }
        $data = array(
            'firstname' => $this->input->post('fname'),
            'lastname' => $this->input->post('lname'),
            'phone_number' => $this->input->post('phno'),
            'display_name' => $this->input->post('displayname'),
            'profile_photo' => $img,
            'description' => $this->input->post('description')
        );

        $this->db->where('id', $this->id);
        $query = $this->db->update('arch_user', $data);
        if ($query) {
            return true;
        }
    }
*/























/* Function to update campaigns in db --Starts-- */

public function update_campaigns()
	{
         if ($this->session->userdata('validated'))
			 {
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
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaycampaigns();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('campaigns',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update coupons in db --Ends-- */











	/* Function to update giftcards in db --Starts-- */

public function update_giftcards()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				'heading2' => 'Dashboard'
				);
             }
                     

				
		
            $data = array(

                'id' => $this->input->post('id'),      
				'displayname' => $this->input->post('displayname'),
				'number' => $this->input->post('number'),
				'security_code' => $this->input->post('security_code'),
				'thumbnailimage' => $this->input->post('thumbnailimage'),
                'fullimage' => $this->input->post('fullimage'),
                'barcodetype' => $this->input->post('barcodetype'),
                'validfrom' => $this->input->post('validfrom'),
				'validtill' => $this->input->post('validtill'),
				'points' => $this->input->post('points'),
                'savings' => $this->input->post('savings'),
                'downloads' => $this->input->post('downloads'),
				'quantity' => $this->input->post('quantity'),
				'legalurl' => $this->input->post('legalurl'),
               

			);
				
			
		     $data1['results'] = $this->admin->update_giftcards($data);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaygiftcards();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('giftcards',$data);
            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update coupons in db --Ends-- */










/* Function to update Advertisements in db --Starts-- */

public function update_advertisements()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
                   
		
            $data = array(

                'id' => $this->input->post('id'),      
				'advert_name' => $this->input->post('advert_name'),
				'description' => $this->input->post('description'),
				'add_text' => $this->input->post('add_text'),
				'valid_from' => $this->input->post('valid_from'),
                'valid_till' => $this->input->post('valid_till'),
                'check_points' => $this->input->post('check_points'),
                'banner_image' => $this->input->post('banner_image'),
				'customer' => $this->input->post('customer'),
				'type' => $this->input->post('type'),
                'campaign' => $this->input->post('campaign'),
                'active' => $this->input->post('active'),
			
			);
				
			
		     $data1['results'] = $this->admin->update_advertisements($data);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displayadverts();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('advertisements',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update coupons in db --Ends-- */




 	/* Function to update Notifications in db --Starts-- */

public function update_notification()
	{
         if ($this->session->userdata('validated'))
			 {
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
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaynotifications();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('notifications',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update Notifications in db --Ends-- */






/* Function to update stors in db --Starts-- */

public function update_stores()
	{
         if ($this->session->userdata('validated'))
			 {
				$breadcrumb = array(
				'title' => 'Dashboard',
				//'heading1' => 'My Heading',
				//'heading1_url' => 'My Message',
				'heading2' => 'Dashboard'
				);
             }
               
            

               if($_FILES != "")
					{
						 $data1= $this->multiple_upload();
						echo $thumbnailimage = $data1['0']['file_name'];
						echo $couponimage = $data1['1']['file_name'];
						
						
                    }else{

                      $thumbnailimage =$this->input->post('thumbnailimage');
					  $couponimage = $this->input->post('storeimage');
					
					}
                



			
            $data = array(

                'id' => $this->input->post('id'),      
				'storename' => $this->input->post('storename'),
				'storenumber' => $this->input->post('storenumber'),
				'customer' => $this->input->post('customer'),
				'description' => $this->input->post('description'),
                'address' => $this->input->post('address'),
              'checkinpoints' => $this->input->post('checkinpoints'),
				'latitude' => $this->input->post('latitude'),
				'longitude' => $this->input->post('longitude'),
				'timezone' => $this->input->post('timezone'),
                'legalurl' => $this->input->post('legalurl'),
                'country' => $this->input->post('country'),
				'state' => $this->input->post('state'),
                'city' => $this->input->post('city'),
                'thumbnailimage' => $thumbnailimage,
                'storeimage' => $couponimage,

			);
			
			
		     $data1['results'] = $this->admin->update_store($data);
               if($data1 != "")
		{
			$data['result'] = $this->admin->displaystores();

			   if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('stores',$data);

            $this->load->view('footer/footer');
			   }

		}
      

	}

 /* Function to update stors in db --Ends-- */








/* Function to display new customers -- Start-- */

 public function display_customers() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displaycustomers();
                 //print_r($result);

			
        if ($data != "") {
    
         	 //$this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('customers',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }



/* Function to display new customers -- End-- */




/* Function to add new customers --Start-- */
public function add_customer() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_customer');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }
/*
   Function to display new customers -- End--
*/





/* Function to display new customers -- Start-- */


public function add_new_customer() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);
				
                 
           error_reporting(0);
			 if($_POST!= "")
				{
					 $data = array(
								'companyname' => $this->input->post('companyname'),
								'adminusername'=> $this->input->post('adminusername'),
								'password'=> '',
								'fullname' => $this->input->post('fullname'),
								'isrealbrand' => $this->input->post('isrealbrand'),
								'description' => $this->input->post('description'),
								'customertypeid' => $this->input->post('customertypeid'),
								'categories' => $this->input->post('categories'),
								'thumbnailimage' => $_FILES['thumbnailimage']['name'],
								'subscribertype' => $this->input->post('subscribertype'),
								'email' => $this->input->post('email'),
								'address' => $this->input->post('addressline1'),
								'countryid' => $this->input->post('countryid'),
								'state' => $this->input->post('categories'),
								'cityid' => $this->input->post('cityid'),
								'zipcode'=> $this->input->post('zip'),
								'contactno'=> $this->input->post('contactno'),
								'url'=> $this->input->post('legalurl'),
								'keyword'=> '',

				      );

			     $thumbnailimage = $_FILES['thumbnailimage']['name'];
                 $thumbnailimage = $_FILES['thumbnailimage']['type'];   
				 $companyimage = $_FILES['companyimage']['name'];
                        
				 if( $thumbnailimage != "")
					{
				       $result = $this->multiple_upload();
					 
				 }
				  
				   
				 $result = $this->admin->add_new_customer($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaycustomers();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('customers',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_user');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/* Function to display new customers -- End-- */



/* Function to delete customers -- Start-- */
public function delete_customer() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_customers($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaycustomers();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('customers',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete customers -- End-- */

    private function check_isvalidated() {
        if (!$this->session->userdata('validated')) {
            redirect('login');
        }
    }


/* Function to display Stores -- Start-- */
 public function display_stores() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displaystores();
         //print_r($data);

			
        if ($data != "") {
    
         	 //$this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('stores',$data);

            $this->load->view('footer/footer');
       } else {
          echo "There are no Stores in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }


/* Function to display Stores -- End-- */




/* Function to Add New Stores --Start-- */
 public function add_store() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_store');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }


/* Function to Add New Stores --End-- */







/* Function to Add New Stores in DB -- Start-- */

public function add_new_store() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
					'title' => 'Dashboard',
	                 // 'heading1_url' => 'My Message',
				     //'heading2' => 'Dashboard'
					);
					//print_r($_POST);
				
				
			  if($_POST!= "")
				{
				   $timezone = $this->input->post('timezone');
				   $long = $this->input->post('longitude');
				   $lat = $this->input->post('latitude');
				   $address = $this->input->post('address');

                 
                     
					!/*if($long =="" || $lat == "" )
					{
						//$result = $this->get_address_coordinates($address);

						//$address = '201 S. Division St., Ann Arbor, MI 48104'; // Google HQ
						$prepAddr = str_replace(' ','+',$address);

						$geocode=file_get_contents('http://maps.google.com/maps/api/geocode/json?address='.$prepAddr.'&sensor=false');

						$output= json_decode($geocode);

						$lat = $output->results[0]->geometry->location->lat;
						$long = $output->results[0]->geometry->location->lng;

						//echo $address.'<br>Lat: '.$lat.'<br>Long: '.$long;
                   
						
					}*/

				
						 
					 $data = array(
						        'customer' => $this->input->post('customer'),
								'categories' => $this->input->post('categories'),
						        'subcategories' => $this->input->post('subcategories'),
						        'checkinpoints' => $this->input->post('checkinpoints'),
								'storename' => $this->input->post('storename'),
								'description'=> $this->input->post('description'),
								'storeimage'=>  $this->input->post('storeimage'),
								'keywords' => $this->input->post('keywords'),
								'storenumber' => $this->input->post('storenumber'),
								'address' => $this->input->post('address'),
								'storeimage' => $this->input->post('storeimage'),
								'country' => $this->input->post('country'),
								'state' => $this->input->post('categories'),
								'city' => $this->input->post('city'),
								'zip'=> $this->input->post('zip'),
								'latitude'=> $lat,
								'longitude'=> $long,
								'timezone'=> $timezone,
								'url'=> $this->input->post('legalurl'),
								//'createddate'=>'',
                                'thumbnailimage'=> $this->input->post('thumbnailimage'),
								

				      );

			     //$storeimage = $_FILES['thumbnailimage']['name'];
               //  $thumbnailimage = $_FILES['thumbnailimage']['type'];   
				// $companyimage = $_FILES['companyimage']['name'];
                        
				 //if( $storeimage != "")
					//{
				     //  $result = $this->multiple_upload();
				// }
				  
				 
				 
				 $result = $this->admin->add_new_store($data);
				}
				
				  echo $result;
				 // exit;
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaystores();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('stores',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no stores in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_store');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/* Function to Add New Stores in db -- End-- */




/* Function to delete customers -- Start-- */
  public function delete_stores() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_stores($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaystores();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('stores',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete customers -- End-- */





/* Function to add campaigns --Start-- */
public function add_campaigns() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );

			 $data['result'] = $this->admin->displaycampaigns();
         //print_r($data);
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('campaigns',$data);
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }
/* Function to add campaigns -- End-- */


/* Function to display add campaign From --Start-- */
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
/* Function  to display add campaign From -- End-- */




/*Function to insert new campaign in db --Start-- */
	public function add_new_campaign() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);
				
                 
         
			 if($_POST!= "")
				{
					 $data = array
						 (
							'name' => $this->input->post('campaignname'),
							
							'validfrom'=> $this->input->post('validfrom'),
							'validtill'=> $this->input->post('validtill'),
							'starttime'=> $this->input->post('starttime'),
							'endtime'=> $this->input->post('endtime'),
							
							'customer'=> $this->input->post('customer'),
							'notes'=> $this->input->post('notes'),
							'active'=> $this->input->post('active'),
							
					    );

			   
				   
				 $result = $this->admin->add_new_campaign($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaycampaigns();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('campaigns',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_giftcard');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }


/* Function to insert new campaign in db -- End -- */



/* Function to delete campaign -- Start-- */
public function delete_campaign() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_campaign($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaycampaigns();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('campaigns',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete campaign -- End-- */















/* Function to add new coupon -- Start -- */

public function add_new_coupon() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
	                    'heading2' => 'Dashboard'
					);

				
			 $data['result'] = $this->admin->get_customers();
					
			//$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_coupons',$data);
            $this->load->view('footer/footer');
           } else {
            redirect(base_url());
        }

			  
				   
			}

/*
Function to add new coupon -- End --
*/





/*Functions to display coupons -- Start--*/

public function add_coupons() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
				 $data['result'] = $this->admin->displaycoupons();
          
         

			 if ($data != "") {
    
         	 //$this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('coupons', $data);
            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }

        } else {
            redirect(base_url());
        }
    }


/*Functions to display coupons -- End-- */



/* Function to add new coupon in db -- Start-- */


public function add_new_coupons() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
             

			   $coupon_thumbnail = $_FILES['couponthumbnailimage']['name'];
			   $coupon_image = $_FILES['couponimage']['name'];
            
		 if($_POST!= "")
				{
                 $cup_ons = $_POST['couponcode1'];
				 if($cup_ons != "")
					{
             
    
                    $data = array
						 (

					
							'customer_name' => $this->input->post('customer'),
							'store_name'=> $this->input->post('storename'),
							'name'=> $this->input->post('couponname'),
							'quantity'=> $this->input->post('quantity'),
							'code_type'=> $this->input->post('codetype'),
							'categories'=> $this->input->post('categories'),
							'couponcode'=> $this->input->post('couponcode1'),
                            'promo_text_short'=> $this->input->post('promotextshort'),
							'promo_text_long'=> $this->input->post('promotextlong'),
							'coupon_description'=> $this->input->post('coupondescription'),
							'coupon_thumbnail'=>$coupon_thumbnail,
                            'coupon_image'=>  $coupon_image,
							'launch_date'=> $this->input->post('launchdate'),
							'expiry_date'=> $this->input->post('expirydate'),
                            'savings'=> $this->input->post('savings'),
							'validity'=> $this->input->post('validityindays'),
                            'downloads'=> $this->input->post('noofdownloads'),
                            'product_url'=> $this->input->post('product_url'),
                            'terms_condition_url'=> $this->input->post('terms_condition_url'),
                            'todaysdeals'=> $this->input->post('todaysdeals'),
							'whatshot_'=> $this->input->post('whatshot_'),
							'isrealbrand'=> $this->input->post('isrealbrand_'),
							'notes'=> $this->input->post('notes')
								 
						 );

					}else{
                        
					
                        $data = array
						 (
							'customer_name' => $this->input->post('customer'),
							'store_name'=> $this->input->post('storename'),
							'name'=> $this->input->post('couponname'),
							'quantity'=> $this->input->post('quantity'),
							'code_type'=> $this->input->post('codetype'),
							'categories'=> $this->input->post('categories'),
							'barcodedata'=> $this->input->post('barcodedata'),
                            'promo_text_short'=> $this->input->post('promotextshort'),
							'promo_text_long'=> $this->input->post('promotextlong'),
							'coupon_description'=> $this->input->post('coupondescription'),
							'coupon_thumbnail'=>$coupon_thumbnail,
                            'coupon_image'=>  $coupon_image,
							'launch_date'=> $this->input->post('launchdate'),
							'expiry_date'=> $this->input->post('expirydate'),
                            'savings'=> $this->input->post('savings'),
							'validity'=> $this->input->post('validityindays'),
                            'downloads'=> $this->input->post('noofdownloads'),
                            'product_url'=> $this->input->post('product_url'),
                            'terms_condition_url'=> $this->input->post('terms_condition_url'),
                            'todaysdeals'=> $this->input->post('todaysdeals'),
							'whatshot_'=> $this->input->post('whatshot_'),
							'isrealbrand'=> $this->input->post('isrealbrand_'),
							'notes'=> $this->input->post('notes')

                              );

					}
                  
			  // print_r($data);
			   
				   
				 $result = $this->admin->add_new_coupons($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaycoupons();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('coupons',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_coupons');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/*Function to add new coupon in db -- End-- */




/* Function to delete coupons -- Start-- */
  public function delete_coupons() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_coupon($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaycoupons();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('coupons',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete coupons -- End-- */










/*
Gift card functions
*/


/* Function to display giftcards --Start-- */

	 public function display_giftcards() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displaygiftcards();
         //print_r($data);

			
        if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('giftcards',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }

   /* Function to display giftcards --End-- */





   /*Functions to display Add Gifts Card Page -- Start--*/

public function add_giftcard() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_giftcard');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }


 /*Functions to display Add Gifts Card Page -- End-- */





 /* Function to add new gift card in db -- Start-- */


public function add_new_giftcard() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);

				
				
                 
         
			 if($_POST!= "")
				{

			    $thumbnailimage = $_FILES['thumbnailimage']['name'];
                $fullimage = $_FILES['fullimage']['name'];

				

				  $this->multiple_upload();
					 $data = array
						 (
							'name' => $this->input->post('name'),
							'thumbnailimage'=> $thumbnailimage,
							'fullimage'=> $fullimage,
							'validfrom'=> $this->input->post('validfrom'),
							'validtill'=> $this->input->post('validtill'),
							'barcodetype'=> $this->input->post('barcodetype'),
							'barcodedata'=> $this->input->post('barcodedata'),
							
							'savings'=> $this->input->post('savings'),
							'quantity'=> $this->input->post('quantity'),
							'points'=> $this->input->post('points'),
							'description'=> $this->input->post('description'),
							'legalurl'=> $this->input->post('legalurl'),
					    );

			   
				   
				 $result = $this->admin->add_new_giftcard($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaygiftcards();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('giftcards',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_giftcard');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/*Function to add new gift card in db -- End-- */



/* Function to delete giftcard -- Start-- */
public function delete_giftcard() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_giftcard($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaygiftcards();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('giftcards',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete giftcard -- End-- */



/* Function to display notifications --Start-- */

	 public function display_notigications() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displaynotifications();
         //print_r($data);

			
        if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('notifications',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }

   /* Function to display notifications --End-- */


   /* Function to display surveys --Start-- */

	 public function display_surveys() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         //$data['result'] = $this->admin->displaynotifications();
         //print_r($data);

			
       // if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('surveys');

            $this->load->view('footer/footer');
       // } else {
         //  echo "There are no users in the DB";
       // }


          
        } else {
            redirect(base_url());
        }
    }

   /* Function to display notifications --End-- */




    /*Functions to display Add Notification Page -- Start--*/

public function add_notification() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            $data['result'] = $this->admin->getcampaigns();
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_notification',$data);
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }


  /*Functions to display Add Notification Page -- Start--*/






   /* Function to add new notification in db -- Start-- */


public function add_new_notificatiopn() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);
				
                 
         
			 if($_POST!= "")
				{
					 $data = array
						 (
							'notification_name' => $this->input->post('notification_name'),
							'notificationtext'=> $this->input->post('notificationtext'),
							'notifyon'=> $this->input->post('notifyon'),
							'launch_date'=> $this->input->post('launch_date'),
							'launch_time'=> $this->input->post('launch_time'),
							'customer'=> $this->input->post('customer'),
						
					    );

			   
				   
				 $result = $this->admin->add_new_notification($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displaynotifications();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('notifications',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_notification');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/*Function to add new notification in db -- End-- */





/* Function to delete notification -- Start-- */
public function delete_notification() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_notification($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displaynotifications();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('notifications',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete giftcard -- End-- */




/* Function to display Advertisements--Start-- */

	 public function display_adverts() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
             
         $data['result'] = $this->admin->displayadverts();
         //print_r($data);

			
        if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

            $this->load->view('advertisements',$data);

            $this->load->view('footer/footer');
        } else {
           echo "There are no users in the DB";
        }


          
        } else {
            redirect(base_url());
        }
    }

   /* Function to display Advertisements --End-- */


     /*Functions to display Add Advertisement Page -- Start--*/

public function add_advertisement() {
        if ($this->session->userdata('validated')) {
            $breadcrumb = array(
                'title' => 'Dashboard',
//               'heading1' => 'My Heading',
//               'heading1_url' => 'My Message',
                 'heading2' => 'Dashboard'
            );
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_advertisements');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }


  /*Functions to display Add Advertisement Page -- Ends--*/







  /* Function to add new Advertisement in db -- Start-- */
public function add_new_Advertisement() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);
					//print_r($_POST);
				
                 
         
			 if($_POST!= "")
				{
					 $data = array
						 (
							'advert_name' => $this->input->post('advert_name'),
							'description'=> $this->input->post('description'),
						    'add_text'=> $this->input->post('add_text'),
							
							'valid_from'=> $this->input->post('valid_from'),
							'valid_till'=> $this->input->post('valid_till'),
							'check_points'=> $this->input->post('check_points'),
						    'banner_image'=> $this->input->post('banner_image'),
						    'customer'=> $this->input->post('customer'),
						    'campaign'=> $this->input->post('campaign'),
						    'active'=> $this->input->post('active'),
						
					    );

			   
				   
				 $result = $this->admin->add_new_advert($data);
				}
				
				  
				  if($result == 1)
					  {

						$data['result'] = $this->admin->displayadverts();

						if ($data != "") 
							{
								//$this->load->view('header/bread_crumb', $breadcrumb);
								$this->load->view('advertisements',$data);
								$this->load->view('footer/footer');
							 } else
								 {
									echo "There are no customers in the DB";
								  }

				
              }else
				  {
					//$this->load->view('header/bread_crumb', $breadcrumb);
					$this->load->view('add_notification');
					$this->load->view('footer/footer');
                 }
        } else {
            redirect(base_url());
        }
			
    }

/*Function to add new Advertisement in db -- End-- */



/* Function to delete Advertisement -- Start-- */
public function delete_advertisement() 
	 {
        if ($this->session->userdata('validated'))
			{
				$breadcrumb = array(
					'title' => 'Dashboard',
	//               'heading1' => 'My Heading',
	//               'heading1_url' => 'My Message',
					 'heading2' => 'Dashboard'
				);
          
		
            $data1['id'] = $this->input->post("id");
            $this->admin->delete_advert($data1);
            // print_r($data1);
            $data['result'] = $this->admin->displayadverts();
            if ($data != "")
				{
    
					//$this->load->view('header/bread_crumb', $breadcrumb);

					$this->load->view('advertisements',$data);

					$this->load->view('footer/footer');
                } else
					{
					 echo "There are no customers in the DB";
				    }
            

        } else
			{
            redirect(base_url());
           }
   }
/* Function to delete Advertisement -- End-- */













  //Upload Image function
 
   function multiple_upload($upload_dir = 'http://couwalla.gripd.com/assets/uploads/', $config = array())
{
    $CI =& get_instance();
    $files = array();
	

    if(empty($config))
    {
        $config['upload_path']   = 'http://couwalla.gripd.com/assets/uploads/';
        $config['allowed_types'] = 'gif|jpg|jpeg|jpe|png';
        $config['max_size']      = '2048';
    }

	//print_r($config);
	//exit;

	
        
        $CI->load->library('upload', $config);
        
        $errors = FALSE;
        
        foreach($_FILES as $key => $value)
        {            
            if( ! empty($value['name']))
            {

			
                if( ! $CI->upload->do_upload($key))
                {      
					
                    $data['upload_message'] = $CI->upload->display_errors(); // ERR_OPEN and ERR_CLOSE are error delimiters defined in a config file
                    $CI->load->vars($data);
                        
                    $errors = TRUE;
                }
                else
                {
					
                    // Build a file array from all uploaded files
                    $files[] = $CI->upload->data();
                }
            }
        }
        
        // There was errors, we have to delete the uploaded files
        if($errors)
        {                    
            foreach($files as $key => $file)
            {
                @unlink($file['full_path']);    
            }                    
        }
        elseif(empty($files) AND empty($data['upload_message']))
        {
            $CI->lang->load('upload');
           // $data['upload_message'] = ERR_OPEN.$CI->lang->line('upload_no_file_selected').ERR_CLOSE;
           // $CI->load->vars($data);
        }
        else
        {
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




   /*Function to generate csv -- Starts -- */

   function create_csv()
	   {
           $this->load->helper('csv_helper');
        

			$quer = $this->db->query('SELECT * FROM coupons');
			
            
            query_to_csv($quer,FALSE,'Coupons_summery_'.'.csv');
			exit;	
            
        }

		 function coupons_detailed_report_csv()
	   {
           $this->load->helper('csv_helper');
        

			$quer = $this->db->query('SELECT * FROM coupons');
			
			
            query_to_csv($quer,FALSE,'Coupons_Detailed_summery_'.'.csv');
			exit;	
            
        }

		   /*Function to generate csv -- Starts -- */






}