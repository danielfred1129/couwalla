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
						
						</h3>
						<ul class="breadcrumb">
							<li>
								<i class="icon-home"></i>
								<a href="index.html">Home</a> 
								<i class="icon-angle-right"></i>
							</li>
							<li><a href="#">Add Notification</a></li>
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
								<div class="caption">Update Notification</div>
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
								<form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/update_notification_form" method="post">
									<!--<form  class="form-horizontal" name="adduserform"  id="adduserform" action="#" method="post">-->
								<!--<form  class="form-horizontal"  id="form_sample_2" action="#" method="post">-->
								
									<div class="alert alert-error hide">
										<button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
									</div>
									
									<div class="alert alert-success hide">
										<button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
									</div>
                                  
                            
                                  <?php foreach($res as $r){?>


								
									
									
                                  <input type="hidden" name="id" value="<?php echo $r['id']; ?>" class="span6 m-wrap" readonly/>


									<div class="control-group">
										<label class="control-label">Notification Name</label>
										<div class="controls">
											<input type="text" name="notification_name" value="<?php echo $r['notification_name']; ?>" class="span6 m-wrap" readonly/>
										</div>
									</div>


									<div class="control-group">
										<label class="control-label">Notification Text</label>
										<div class="controls">
									<input type="text" name="notificationtext" value="<?php echo $r['notificationtext']; ?>" class="span6 m-wrap" readonly/>
										</div>
									</div>

									<div class="control-group">
										<label class="control-label">Notify On</label>
										<div class="controls">
											<input type="text" name="notifyon"  value="<?php echo $r['notifyon']; ?>" class="span6 m-wrap" readonly/>
										</div>
									</div>
                                     
									 <div class="control-group">
										<label class="control-label">Launch Date</label>
										<div class="controls">
											<input type="text" name="launch_date"  value="<?php echo $r['launch_date']; ?>" class="span6 m-wrap" readonly/>
										</div>
									</div>
									

									<div class="control-group">
										<label class="control-label">Launch Time</label>
										<div class="controls">
											<input type="text" name="launch_time"  value="<?php echo $r['launch_time']; ?>" class="span6 m-wrap" readonly/>
										</div>
									</div>

								
												
  <?php }?>
								
								
									<div class="form-actions">
										<button type="submit" class="btn green">Edit</button>
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
	
    <!-- END PAGE LEVEL STYLES --> 



		<script>
			    
			function saveChanges()
				{ 
						var username = $("#gid").val();
						//alert( $( "#gid" ).val());
						$.ajax({
							type: "POST",
							url: 'http://localhost/couwalla/index.php/ajax/username_taken',
							data: 'username=' + username,
							error: function(e){
							alert(e);
						},

						success: function(response)
							{
							// A response to say if it's updated or not
							alert(response);
					}
				});   
			}
		</script>	

		
		<!--<script>
		$(document).ready(function() {



  $('#username').change(function() {

    var username = $("#username").val();
 //var dataString = 'username=' + username;
 alert( $( "#username" ).val());
  
 
  
 $.ajax({
  type: "POST",
  url: "http://localhost/couwalla/index.php/ajax/username_taken",
  data: username ="+ discuss_text,
  success: function(msg) 
        {
   $("#status").html(msg);
  }
  });
  });  

});
  
  </script>-->

	<!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>