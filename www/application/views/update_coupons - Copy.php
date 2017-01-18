<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
	<meta charset="utf-8" />
	
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
	<!-- BEGIN GLOBAL MANDATORY STYLES -->
	<!--<link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/css/style-metro.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/css/style.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/css/style-responsive.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color"/>
	<link href="<?php echo base_url(); ?>assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css"/>-->
    <!--<link href="<?php echo base_url(); ?>assets/css/toggle_style.css" rel="stylesheet" type="text/css" id="style_color"/>-->
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-datetimepicker/css/datetimepicker.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/jquery-multi-select/css/multi-select-metro.css" />
	<link href="<?php echo base_url(); ?>assets/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
	<link href="<?php echo base_url(); ?>assets/plugins/bootstrap-switch/static/stylesheets/bootstrap-switch-metro.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/jquery-tags-input/jquery.tagsinput.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/stylesheets/bootstrap-toggle-buttons.css" />
	<!-- END GLOBAL MANDATORY STYLES -->
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/stylesheets/bootstrap-toggle-buttons.css" />
	<!-- BEGIN PAGE LEVEL STYLES -->
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
	 <style>  
       .feed {padding: 5px 0}  
    </style>  
	<!-- END PAGE LEVEL STYLES -->
	<link rel="shortcut icon" href="favicon.ico" />
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body class="page-header-fixed">
	
	<!-- BEGIN CONTAINER -->
	
		
		<!-- BEGIN PAGE -->  
		<div class="page-content">
			<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<div id="portlet-config" class="modal hide">
				<div class="modal-header">
					<button data-dismiss="modal" class="close" type="button"></button>
					<h3>portlet Settings</h3>
				</div>
				<div class="modal-body">
					<p>Here will be a configuration form</p>
				</div>
			</div>
			<!-- END SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<!-- BEGIN PAGE CONTAINER-->
			<div class="container-fluid">



			                     <!-- BEGIN PAGE HEADER-->
				<div class="row-fluid">
					<div class="span12">
						<!-- BEGIN STYLE CUSTOMIZER -->
						
						<!-- END BEGIN STYLE CUSTOMIZER -->    
						<!-- BEGIN PAGE TITLE & BREADCRUMB-->
						<h3 class="page-title">
							
						</h3>
						<ul class="breadcrumb">
							<li>
								<i class="icon-home"></i>
								<a href="index.html">Home</a> 
								<i class="icon-angle-right"></i>
							</li>
							<li><a href="#">Update Coupons</a></li>
							<li class="pull-right no-text-shadow">
								<!--<div id="dashboard-report-range" class="dashboard-date-range tooltips no-tooltip-on-touch-device responsive" data-tablet="" data-desktop="tooltips" data-placement="top" data-original-title="Change dashboard date range">
									<i class="icon-calendar"></i>
									<span></span>
									<i class="icon-angle-down"></i>
								</div>-->
							</li>
						</ul>
						<!-- END PAGE TITLE & BREADCRUMB-->
					</div>
				</div>
				<!-- END PAGE HEADER-->
		
				<!-- BEGIN PAGE CONTENT-->
				       <div class="row-fluid">
					    <!-- BEGIN VALIDATION STATES-->
						<div class="portlet box green">
							<div class="portlet-title">
								<div class="caption">Update Coupons</div>
								<!--<div class="tools">
									<a href="javascript:;" class="collapse"></a>
									<a href="#portlet-config" data-toggle="modal" class="config"></a>
									<a href="javascript:;" class="reload"></a>
									<a href="javascript:;" class="remove"></a>
								</div>-->
							</div>
							<div class="portlet-body form">
								<!-- BEGIN FORM-->
								<h3></h3>
					<form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/update_coupons" method="post" enctype="multipart/form-data">
								
								
									<div class="alert alert-error hide">
										<button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
									</div>
									
									<div class="alert alert-success hide">
										<button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
									</div>

	                        
									<input type="hidden" name="id" value="<?php echo $res['id'];?>"  class="span6 m-wrap" />
     
									<!--<div class="control-group">
										<label class="control-label">Customer Name<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="customer_name" value="<?php echo $res['customer_name'];?>" class="span6 m-wrap"/>
										</div>
									</div>-->

									<div class="control-group">
										<label class="control-label">Store Name<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="store_name" value="<?php echo $res['store_name'];?>" class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">Coupon Name<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="name"  value="<?php echo $res['name'];?>" class="span6 m-wrap"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">Quantity<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="quantity" data-required="1" value="<?php echo $res['quantity'];?>" class="span6 m-wrap"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">Reward Points on redemption
										<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="rewardpoints_on_redemption" value="<?php echo $res['rewardpoints_on_redemption'];?>"  data-required="1" class="span6 m-wrap"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">Category
										<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="rewardpoints_on_redemption" value="<?php echo $res['category'];?>"  data-required="1" class="span6 m-wrap"/>
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">Sub Category
										<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="rewardpoints_on_redemption" value="<?php echo $res['sub_category'];?>"  data-required="1" class="span6 m-wrap"/>
										</div>
									</div>
									
									


									<div class="control-group">
										<label class="control-label">Code Type<span class="required">*</span></label>
										<div class="controls">
											<select class="span6 m-wrap" value="<?php echo $res['code_type'];?>" name="codetype">
												<option value="">Select...</option>
												<option value="Coupon Code">Coupon Code</option>
												<option value="Bar Code">Barcode</option>
											</select>
										</div>
									</div>


									<!--<div class="control-group">
										<label class="control-label">Categories<span class="required">*</span></label>
										<div class="controls">
											<select class="span6 m-wrap" name="categories">
												<option value="">Select...</option>
												<option value="Coupon Code">Category1</option>
												<option value="Bar Code">Category2</option>
												<option value="Bar Code">Category3</option>
											</select>
										</div>
									</div>-->

									<div class="control-group">
										<label class="control-label">Promo Text Short<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="promotextshort" value="<?php echo $res['promo_text_short'];?>" data-required="1" class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">Promo Text long<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="promotextlong" value="<?php echo $res['promo_text_long'];?>"  class="span6 m-wrap"/>
										</div>
									</div>

									<!--<div class="control-group">
										<label class="control-label">Coupon Description<span class="required">*</span></label>
										<div class="controls">
											
											<textarea  name="description" value="<?php echo $res['description'];?>"  class="span6 m-wrap"></textarea>
										</div>
									</div>-->

									<!--<div class="control-group">
										<label class="control-label"> Coupon Thumbnail Image</label>
										<div class="controls">
											<input type="file" name="couponthumbnailimage"><lable><?php echo $res['coupon_thumbnail'];?></lable>
											 <input type="hidden" name="thumbnailimage1" value="<?php echo $res['coupon_thumbnail'];?>"  class="span6 m-wrap"/>
										</div>
									</div>-->


									<div class="control-group">
										<label class="control-label">Coupon Image</label>
										<div class="controls">
											<input type="file" name="couponimage"><lable><?php echo $res['coupon_image'];?></lable>
											 <input type="hidden" name="coupon_image" value="<?php echo $res['coupon_image'];?>"  class="span6 m-wrap"/>
                                           
										</div>
									</div>
									
									
									
									
									

									
									<div class="control-group">
										<label class="control-label">Coupon Description</label>
										<div class="controls">
							<input type="text" name="coupon_description"  value="<?php echo $res['coupon_description'];?>" class="span6 m-wrap"  />
											
										</div>
									</div>
									
							
									
				 <div class="control-group">
					  <label class="control-label">Launch Date</label>
						<div class="controls">
							<div class="input-append date date-picker" data-date="12-02-2012" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
								<input class="m-wrap m-ctrl-medium date-picker" value="<?php echo $res['launch_date'];?>" name="launch_date" id="launch_date" readonly size="16" type="text" value="" /><span class="add-on"><i class="icon-calendar"></i></span>
							</div>
						</div>
					</div>


										
									
									
				<div class="control-group">
					  <label class="control-label">Expiry Date</label>
						<div class="controls">
							<div class="input-append date date-picker" data-date="12-02-2012" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
								<input class="m-wrap m-ctrl-medium date-picker" value="<?php echo $res['expiry_date'];?>" name="expirydate" id="expirydate" readonly size="16" type="text" value="" /><span class="add-on"><i class="icon-calendar"></i></span>
							</div>
						</div>
					</div>


									<div class="control-group">
										<label class="control-label">Savings<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="savings" value="<?php echo $res['savings'];?>"  class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">Validity (in days)<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="validity" value="<?php echo $res['validity'];?>"  class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">No of downloads per subscriber<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="downloads" value="<?php echo $res['downloads'];?>"  class="span6 m-wrap"/>
										</div>
									</div>

										<div class="control-group">
										<label class="control-label">Reward Points on redemption<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="rewardpoints_on_redemption" value="<?php echo $res['rewardpoints_on_redemption'];?>"  class="span6 m-wrap"/>
										</div>
									</div>
									
									
									
					  <div class="control-group">
							<label class="control-label">Zip</label>
							<div class="controls">
		<input type="text" name="zipcode" value="<?php echo $res['zipcode'];?>" class="span6 m-wrap" value="" />

							</div>
						</div>
									
									
									<div class="control-group">
										<label class="control-label">Product Url<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="product_url" value="<?php echo $res['product_url'];?>"  class="span6 m-wrap"/>
										</div>
									</div>
									
									 <div class="control-group">
										<label class="control-label">Legal Url<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="legal_url" value="<?php echo $res['legal_url'];?>"  class="span6 m-wrap"/>
										</div>
									</div>
									
									


									<div class="control-group">
										<label class="control-label">Terms & Conditions<span class="required">*</span></label>
										<div class="controls">
											<!--<input type="text" name="terms_condition_url"  class="span6 m-wrap"/>-->
											<input type="text" name="terms_condition_url" value="<?php echo $res['terms_condition_url'];?>"  class="span6 m-wrap"/>
											
										</div>
									</div>
									
									<div class="control-group">
										<label class="control-label">Keywords<span class="required">*</span></label>
										<div class="controls">
											<!--<input type="text" name="terms_condition_url"  class="span6 m-wrap"/>-->
											<input type="text" name="keywords" value="<?php echo $res['keywords'];?>"  class="span6 m-wrap"/>
											
										</div>
									</div>
									



									<!--<div class="control-group">
										<label class="control-label">Todays Deals<span class="required">*</span></label>
										<div class="controls">
											<input type="checkbox" name="todaysdeals" class="checkboxes" value="" />
										</div>

									</div>-->


                                   <!-- <div class="control-group">
									<label class="control-label">What's Hot<span class="required">*</span></label>
										<div class="controls">
											<input type="checkbox" name="whatshot " class="checkboxes" value="" />
										</div>
                                     </div>-->


									<!--<div class="control-group">
										<label class="control-label">National Coupon<span class="required">*</span></label>
										<div class="controls">
											<input type="checkbox" name="isrealbrand " class="checkboxes" value="" />
										</div>
                                     </div>-->





									<!--<div class="control-group">
										<label class="control-label">Notes<span class="required">*</span></label>
										<div class="controls">
										
											<textarea name="notes" class="span6 m-wrap" value=""></textarea>
										</div>
									</div>-->




                                      


									<!--<div class="control-group">
										<label class="control-label">Countery<span class="required">*</span></label>
										<div class="controls">
											<select class="span6 m-wrap" name="country">
												<option value="">Select...</option>
												<option value="Category 1">United States</option>
												<option value="Category 2">Category 2</option>
												<option value="Category 3">Category 3</option>
												
											</select>
										</div>
									</div>-->



								





									<!--<div class="control-group">
										<label class="control-label">Keywords<span class="required">*</span></label>

										<div class="controls" id="newlink">-->
											<!--<input type="text" name="keywords" data-required="1" class="span6 m-wrap"/>-->
											<!--<div id="newlink" > --> 
                                                 <!-- <input type="text" name="keywords[]" class="span6 m-wrap" >  
													<p id="addnew">  
													<a href="javascript:add_feed()">Add New </a>  
													</p>  -->
											<!--</div>  -->
										</div>
									</div>

					
							<!-- Template. This whole data will be added directly to working form above -->  
							<div id="newlinktpl" style="display:none">  
							<div class="feed">  
							<input type="text" name="keywords[]"  class="span6 m-wrap" >  
							</div>  
							</div>  

									


								
									<div class="form-actions">
										<button type="submit" class="btn green">Update</button>
										<!--<button type="button" class="btn">Cancel</button>-->
									</div>
								</form>
								<!-- END FORM-->
							</div>
						</div>
						<!-- END VALIDATION STATES-->

				</div>
				<!-- END PAGE CONTENT-->         
			</div>
			<!-- END PAGE CONTAINER-->
		</div>
		<!-- END PAGE -->  

	<!-- END CONTAINER -->
	
	<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
 <script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/js/jquery.toggle.buttons.js"></script>
	
	<!-- BEGIN PAGE LEVEL STYLES -->
	<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
	<!-- END PAGE LEVEL STYLES --> 


<!-- New Java Scripts-->

	<!-- BEGIN CORE PLUGINS -->  
	<script src="<?php echo base_url(); ?>assets/plugins/jquery-1.10.1.min.js" type="text/javascript"></script>
	<script src="<?php echo base_url(); ?>assets/plugins/jquery-migrate-1.2.1.min.js" type="text/javascript"></script>
	<!-- IMPORTANT! Load jquery-ui-1.10.1.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
	<script src="<?php echo base_url(); ?>assets/plugins/jquery-ui/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>      
	<script src="<?php echo base_url(); ?>assets/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="<?php echo base_url(); ?>assets/plugins/bootstrap-hover-dropdown/twitter-bootstrap-hover-dropdown.min.js" type="text/javascript" ></script>
	<!--[if lt IE 9]>
	<script src="assets/plugins/excanvas.min.js"></script>
	<script src="assets/plugins/respond.min.js"></script>  
	<![endif]-->   
	<script src="<?php echo base_url(); ?>assets/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
	<script src="<?php echo base_url(); ?>assets/plugins/jquery.blockui.min.js" type="text/javascript"></script>  
	<script src="<?php echo base_url(); ?>assets/plugins/jquery.cookie.min.js" type="text/javascript"></script>
	<script src="<?php echo base_url(); ?>assets/plugins/uniform/jquery.uniform.min.js" type="text/javascript" ></script>
	<!-- END CORE PLUGINS -->
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-fileupload/bootstrap-fileupload.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/clockface/js/clockface.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>  
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/jquery-inputmask/jquery.inputmask.bundle.min.js"></script>   
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/jquery.input-ip-address-control-1.0.min.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/jquery-multi-select/js/jquery.multi-select.js"></script>   
	<script src="<?php echo base_url(); ?>assets/plugins/bootstrap-modal/js/bootstrap-modal.js" type="text/javascript" ></script>
	<script src="<?php echo base_url(); ?>assets/plugins/bootstrap-modal/js/bootstrap-modalmanager.js" type="text/javascript" ></script> 
	<script src="<?php echo base_url(); ?>assets/plugins/jquery.pwstrength.bootstrap/src/pwstrength.js" type="text/javascript" ></script>
	<script src="<?php echo base_url(); ?>assets/plugins/bootstrap-switch/static/js/bootstrap-switch.js" type="text/javascript" ></script>
	<script src="<?php echo base_url(); ?>assets/plugins/jquery-tags-input/jquery.tagsinput.min.js" type="text/javascript" ></script>

<!-- New Java Scripts -- Ends-- -->





	
	
	<!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>