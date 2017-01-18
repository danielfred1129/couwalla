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
	<!-- END GLOBAL MANDATORY STYLES -->
	<!-- BEGIN PAGE LEVEL STYLES -->
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
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
						<!--<div class="color-panel hidden-phone">
							<div class="color-mode-icons icon-color"></div>
							<div class="color-mode-icons icon-color-close"></div>
							<div class="color-mode">
								<p>THEME COLOR</p>
								<ul class="inline">
									<li class="color-black current color-default" data-style="default"></li>
									<li class="color-blue" data-style="blue"></li>
									<li class="color-brown" data-style="brown"></li>
									<li class="color-purple" data-style="purple"></li>
									<li class="color-grey" data-style="grey"></li>
									<li class="color-white color-light" data-style="light"></li>
								</ul>
								<label>
									<span>Layout</span>
									<select class="layout-option m-wrap small">
										<option value="fluid" selected>Fluid</option>
										<option value="boxed">Boxed</option>
									</select>
								</label>
								<label>
									<span>Header</span>
									<select class="header-option m-wrap small">
										<option value="fixed" selected>Fixed</option>
										<option value="default">Default</option>
									</select>
								</label>
								<label>
									<span>Sidebar</span>
									<select class="sidebar-option m-wrap small">
										<option value="fixed">Fixed</option>
										<option value="default" selected>Default</option>
									</select>
								</label>
								<label>
									<span>Footer</span>
									<select class="footer-option m-wrap small">
										<option value="fixed">Fixed</option>
										<option value="default" selected>Default</option>
									</select>
								</label>
							</div>
						</div>-->
						<!-- END BEGIN STYLE CUSTOMIZER -->    
						<!-- BEGIN PAGE TITLE & BREADCRUMB-->
						<h3 class="page-title">
							Dashboard <small>statistics and more</small>
						</h3>
						<ul class="breadcrumb">
							<li>
								<i class="icon-home"></i>
								<a href="<?php echo site_url('Admin');?>">Home</a> 
								<i class="icon-angle-right"></i>
							</li>
							<li><a href="#">Dashboard</a></li>
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
								<div class="caption">Add User</div>
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
								<form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/add_new_user" method="post">
								<!--<form  class="form-horizontal"  id="form_sample_2" action="#" method="post">-->
								
									<div class="alert alert-error hide">
										<button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
									</div>
									
									<div class="alert alert-success hide">
										<button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
									</div>
									<div class="control-group">
										<label class="control-label">UserName<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="username" data-required="1" class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">FirstName<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="firstname" data-required="1" class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">LastName<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="lastname" data-required="1" class="span6 m-wrap"/>
										</div>
									</div>

									

									<div class="control-group">
										<label class="control-label">Email<span class="required">*</span></label>
										<div class="controls">
											<input name="email" type="text" class="span6 m-wrap"/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">Customer<span class="required">*</span></label>
										<div class="controls">
											<select class="span6 m-wrap" name="customer">
												<option value="">Select...</option>
												<option value="Category 1">Category 1</option>
												<option value="Category 2">Category 2</option>
												<option value="Category 3">Category 3</option>
												
											</select>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">ContactNo<span class="required">*</span></label>
										<div class="controls">
											<input type="text" name="contactno" data-required="1" class="span6 m-wrap"/>
										</div>
									</div>


									<div class="control-group">
										<label class="control-label">Active<span class="required">*</span></label>
										<div class="controls">
											<select class="span6 m-wrap" name="active">
												<option value="">Select...</option>
												<option value="Category 1">Active</option>
												<option value="Category 2">Inactive</option>
												
												
											</select>
										</div>
									</div>

								
								
									<div class="form-actions">
										<button type="submit" class="btn green">Add</button>
									<!--	<button type="button" class="btn">Cancel</button>-->
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

	
	<!-- BEGIN PAGE LEVEL STYLES -->
	<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
	<!-- END PAGE LEVEL STYLES --> 
	
	
	<!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>