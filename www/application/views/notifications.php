<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
<link rel="stylesheet" href="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.css" />
<div class="row-fluid">
    <div class="span12">
        <!-- BEGIN EXAMPLE TABLE PORTLET-->
        <form name="display_users" method="post" action="<?php echo site_url(); ?>admin/delete_notification">
            <div class="portlet box light-grey">
                <div class="portlet-title">
                    <div class="caption"><i class="icon-bullhorn"></i>Manage Notifications</div>

                </div>
                <div class="portlet-body">
                    <div class="table-toolbar">
                        <div class="btn-group">
                            <!--<button type="submit" class="btn green">
                                                                                Add New <i class="icon-plus"></i>
                                                                                </button>-->
                            <a href="<?php echo site_url('admin/add_notification'); ?>" class="btn green">Add Notification</a>


                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn green" id="delete">
                                Delete Notification
                            </button>


                                                                                <!--<a href="<?php echo site_url('Admin/delete_user'); ?>" class="btn green">Delete User</a>-->

                        </div>

                    </div>
                    <table class="table table-striped table-bordered table-hover" id="sample_2">
                        <thead>
                            <tr>
                                <th style="width:8px;"><input type="checkbox" class="group-checkable" data-set="#sample_2 .checkboxes" /></th>
                                <th>Notification Name</th>
                                <th class="hidden-480">Notification Text(Message)</th>
                                <th class="hidden-480">Notify On</th>


                            </tr>
                        </thead>
                        <tbody>

                            <?php foreach ($result as $r) {
                                ?>


                                <tr class="odd gradeX">
                                    <td><input type="checkbox" name="notify_id[]" class="checkboxes notification" value="<?php echo $r['id']; ?>" /></td>
                                    <td><a href="<?php echo site_url(); ?>/admin/show_notification_details?id='<?php echo $r['id']; ?>'"><?php echo $r['notification_name']; ?></a></td>
                                    <td class="hidden-480"><?php echo $r['notificationtext']; ?></td>
                                    <td class="hidden-480"><?php echo $r['notifyon']; ?></td>

                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- END EXAMPLE TABLE PORTLET-->
        </form>
    </div>
</div>
<script>
    $("#delete").click(function(){
        var cat_id  = new Array();
        var i=0;
        $(".notification").each(function() {
            if ($(this).is(':checked')) {
                cat_id[i] = $(this).val();
                i++;
            }
        }); 
        if(cat_id == ""){
            $("span.err").text("Please select Atleast One Notification");
            return false;
        }else{
            $("span.err").text("");
            if (confirm("Are you sure you want to Delete Notification?") == true) {
                return true;
            }
            else {
                return false;
            }
        }                
    }); 
</script>


<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script> 
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
