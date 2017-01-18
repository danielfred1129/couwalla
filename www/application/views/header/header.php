
<!DOCTYPE html>
<head>
    <meta charset="utf-8" />
    <title>Couwalla | Admin </title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    <!-- BEGIN GLOBAL MANDATORY STYLES -->        
    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/css/style-metro.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/css/style.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/css/style-responsive.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color"/>
    <link href="<?php echo base_url(); ?>assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css"/>
    <!-- END GLOBAL MANDATORY STYLES -->
    <!-- BEGIN PAGE LEVEL PLUGIN STYLES --> 
    <link type="text/css" rel="stylesheet" href="<?php echo base_url(); ?>assets/plugins/bootstrap-modal/css/bootstrap-modal.css">
    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap-fileupload/bootstrap-fileupload.css" type="text/css" rel="stylesheet">
    <!--<link href="<?php echo base_url(); ?>assets/plugins/gritter/css/jquery.gritter.css" rel="stylesheet" type="text/css"/>-->
    <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-datepicker/css/datepicker.css" />
    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url(); ?>assets/plugins/fullcalendar/fullcalendar/fullcalendar.css" rel="stylesheet" type="text/css"/>
    <link href="<?php echo base_url(); ?>assets/plugins/jqvmap/jqvmap/jqvmap.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="<?php echo base_url(); ?>assets/plugins/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" rel="stylesheet" type="text/css" media="screen"/>
<!--    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap-multiselect.css" rel="stylesheet" type="text/css" media="screen"/>-->
    <link href="<?php echo base_url(); ?>assets/plugins/bootstrap-fileupload/bootstrap-fileupload.css" type="text/css" rel="stylesheet">
    <!-- END PAGE LEVEL PLUGIN STYLES -->


<!--<link href="http://192.168.1.155/drcollege/assets/plugins/data-tables/DT_bootstrap.css" rel="stylesheet">-->




    <!-- BEGIN PAGE LEVEL STYLES --> 
    <link href="<?php echo base_url(); ?>assets/css/pages/tasks.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="<?php echo base_url(); ?>assets/css/popup.css" rel="stylesheet" type="text/css" media="screen"/>
    <!-- END PAGE LEVEL STYLES -->
    <link rel="shortcut icon" href="favicon.ico" />
    <script src="<?php echo base_url(); ?>assets/plugins/jquery-1.10.1.min.js" type="text/javascript"></script>
	<script src="<?php echo base_url(); ?>assets/resize.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("textarea").keyup(function(e) {
				while($(this).outerHeight() < this.scrollHeight + parseFloat($(this).css("borderTopWidth")) + parseFloat($(this).css("borderBottomWidth"))) {
					$(this).height($(this).height()+1);
				};
			});
			$("textarea").each(function(){
				$(this).height($(this)[0].scrollHeight);
				$(this).trigger('mouseenter');
		    });
		});
	</script>
     
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body class="page-header-fixed">
    <!-- BEGIN HEADER -->   
    <div class="header navbar navbar-inverse navbar-fixed-top">
        <!-- BEGIN TOP NAVIGATION BAR -->
        <div class="navbar-inner">
            <div class="container-fluid">
                <!-- BEGIN LOGO -->
                <a class="brand" href="#">
                    <img src="<?php echo base_url(); ?>assets/img/logo-main.png" alt="" width="86" height="14"/>
                </a>
                <!-- END LOGO -->
                <!-- BEGIN RESPONSIVE MENU TOGGLER -->
                <a href="javascript:;" class="btn-navbar collapsed" data-toggle="collapse" data-target=".nav-collapse">
                    <img src="<?php echo base_url(); ?>assets/img/menu-toggler.png" alt="" />
                </a>          
                <!-- END RESPONSIVE MENU TOGGLER -->            
                <!-- BEGIN TOP NAVIGATION MENU -->              
                <ul class="nav pull-right">

                    <!-- END TODO DROPDOWN -->               
                    <!-- BEGIN USER LOGIN DROPDOWN -->
                    <li class="dropdown user">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
                            <img alt="" src="<?php echo base_url(); ?>uploads/<?php echo $this->session->userdata('user_image'); ?>" />
                            <span class="username"><?php echo ucwords($this->session->userdata('name')); ?></span>
                            <i class="icon-angle-down"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="<?php echo site_url(); ?>admin/show_my_profile"><i class="icon-user"></i> My Profile</a></li>
                            <li><a href="<?php echo site_url(); ?>admin/change_password"><i class="icon-key"></i> Change Password</a></li>
                            <li class="divider"></li>

                            <li><a href="<?php echo site_url(); ?>login/do_logout"><i class="icon-key"></i> Log Out</a></li>
                        </ul>
                    </li>
                    <!-- END USER LOGIN DROPDOWN -->
                    <!-- END USER LOGIN DROPDOWN -->
                </ul>
                <!-- END TOP NAVIGATION MENU --> 
            </div>
        </div>
        <!-- END TOP NAVIGATION BAR -->
    </div>
    <!-- END HEADER -->
    <!-- BEGIN CONTAINER -->
    <div class="page-container row-fluid">

