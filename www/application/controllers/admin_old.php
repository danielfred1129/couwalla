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
         //print_r($data);

			
        if ($data != "") {
    
         	// $this->load->view('header/bread_crumb', $breadcrumb);

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






 /* Show User Profile -- Starts -- */

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


	/*Show User Profile -- Ends --*/



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
			
		     $data['results'] = $this->admin->update_user($data);
            exit;
			//print_r($data);
			

	}

 /* Function to update users --Ends-- */





/*
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
 

              $this->load->view('update_users',$data);
              $this->load->view('footer/footer');
        
	}



*/



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
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_campaigns');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }
/* Function to add campaigns -- End-- */




/*Function to insert new campaign in db --Start-- */
public function add_new_campaign() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
					'title' => 'Dashboard',
	                 // 'heading1_url' => 'My Message',
				     //'heading2' => 'Dashboard'
					);
				
			}

      if(!$_POST)
	  {

         echo'<pre>';
		 print_r($_POST);
		  echo'</pre>';

	  }
	  else{
          echo"novalue";
	  }
}

/* Function to insert new campaign in db -- End -- */






/* Function to add new coupon -- Start -- */

public function add_new_coupon() {
        if ($this->session->userdata('validated'))
			{
					$breadcrumb = array(
						'title' => 'Dashboard',
		//               'heading1' => 'My Heading',
		//               'heading1_url' => 'My Message',
						 'heading2' => 'Dashboard'
					);

					//echo $url = site_url().'/assects/'.'uploads';
					
			//$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('add_coupons');
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
            
            
            //$this->load->view('header/bread_crumb', $breadcrumb);
            $this->load->view('coupons');
            $this->load->view('footer/footer');

        } else {
            redirect(base_url());
        }
    }


/*Functions to display coupons -- End-- */



  //Upload Image function
 
   function multiple_upload($upload_dir = 'F:\xampp\htdocs\couwalla\assets\uploads', $config = array())
{
    $CI =& get_instance();
    $files = array();

    if(empty($config))
    {
        $config['upload_path']   = realpath($upload_dir);
        $config['allowed_types'] = 'gif|jpg|jpeg|jpe|png';
        $config['max_size']      = '2048';
    }
        
        $CI->load->library('upload', $config);
        
        $errors = FALSE;
        
        foreach($_FILES as $key => $value)
        {            
            if( ! empty($value['name']))
            {
                if( ! $CI->upload->do_upload($key))
                {                                           
                    $data['upload_message'] = $CI->upload->display_errors(ERR_OPEN, ERR_CLOSE); // ERR_OPEN and ERR_CLOSE are error delimiters defined in a config file
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
            $data['upload_message'] = ERR_OPEN.$CI->lang->line('upload_no_file_selected').ERR_CLOSE;
            $CI->load->vars($data);
        }
        else
        {
            return $files;
        }
    }  





}