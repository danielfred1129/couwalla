
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
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
        <link rel="stylesheet" href="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.css" />
        <!-- END PAGE LEVEL STYLES -->
<!--        <script src="<?php echo base_url(); ?>assets/scripts/jquery.min.js"></script>-->
        <link rel="shortcut icon" href="favicon.ico" />
<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <div class="span12">
        <!-- BEGIN EXAMPLE TABLE PORTLET-->
        <form name="display_users" method="post" action="<?php echo site_url(); ?>/admin/delete_staff">
            <div class="portlet box light-grey">
                <div class="portlet-title">
                    <div class="caption"><i class="icon-user"></i>Manage Staff</div>
                    <!--<div class="tools">
                            <a href="javascript:;" class="collapse"></a>
                            <a href="#portlet-config" data-toggle="modal" class="config"></a>
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="remove"></a>
                    </div>-->
                </div>
                <div class="portlet-body">
                    <div class="table-toolbar">
                        <div class="btn-group">
                            <a href="<?php echo site_url('admin/add_staff'); ?>" class="btn green">Add Staff</a>
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn green" id="delete">
                                Delete Staff
                            </button>
                        </div>
                    </div>
                    <span for="user_id" class="err" style="color:red; font-size: 15px;"></span>
                    <table class="table table-striped table-bordered table-hover" id="sample_2">
                        <thead>
                            <tr>
                                <th style="width:8px;"><input type="checkbox" class="group-checkable" data-set="#sample_2 .checkboxes" /></th>
<!--                                                <th>User Name</th>-->
                                <th class="hidden-480">First Name</th>
                                <th class="hidden-480">last Name</th>
                                <th class="hidden-480">Email</th>
                                <th class="hidden-480">Contact Number</th>
                                <!--<th class="hidden-480">Status</th>-->
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($result as $r) { ?>
                                <tr class="odd gradeX">
                                    <td><input type="checkbox" name="user_id[]" class="checkboxes users"  value="<?php echo $r['id']; ?>" /></td>
    <!--                                                    <td><a href="<?php echo site_url(); ?>/admin/show_user_profile?id='<?php echo $r['id']; ?>'"><?php echo $r['username']; ?></a></td>-->
                                    <td class="hidden-480"><a href="<?php echo site_url(); ?>/admin/staff_profile?id=<?php echo $r['id']; ?>"><?php echo $r['firstname']; ?></a></td>
                                    <td class="hidden-480"><?php echo $r['lastname']; ?></td>
                                    <td class="center hidden-480"><?php echo $r['email']; ?></td>
                                    <td class="center hidden-480"><?php echo $r['contact_info']; ?></td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- END EXAMPLE TABLE PORTLET-->
        </form>
        <script>
            $("#delete").click(function(){
                var cat_id  = new Array();
                var i=0;
                $(".users").each(function() {
                    //alert("sdfs");
                    if ($(this).is(':checked')) {
                        cat_id[i] = $(this).val();
                        //alert(cat_id);
                        i++;
                    }
                }); 
                if(cat_id == ""){
                    //alert(cat_id);
                    $("span.err").text("Please select Atleast One Staff");
                    return false;
                }else{
                    if (confirm("Are you sure you want to Delete Staff?") == true) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }                
            }); 
        </script>
    </div>
</div>

<!-- END PAGE CONTENT-->

 <!-- END FOOTER -->
        <!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
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
        <!-- BEGIN PAGE LEVEL PLUGINS -->
        <script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/select2/select2.min.js"></script>
        <script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/data-tables/jquery.dataTables.js"></script>
        <script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.js"></script>
        <!-- END PAGE LEVEL PLUGINS -->
        <!-- BEGIN PAGE LEVEL SCRIPTS -->
        <script src="<?php echo base_url(); ?>assets/scripts/app.js"></script>
        <script src="<?php echo base_url(); ?>assets/scripts/table-managed.js"></script>     
        <script>
            jQuery(document).ready(function() { 
                App.init();
                TableManaged.init();
            });
        </script>