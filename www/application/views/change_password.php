<!DOCTYPE html>

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Change Password</div>
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


            <form  class="form-horizontal" name="change_password"  id="change_password" action="<?php echo site_url(); ?>admin/update_password" method="post">

                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>
                <span for="store_id" class="err" style="color:red; font-size: 15px;"><?php if(isset($msg)) { echo $msg; } ?></span>
                <div class="control-group">
                    <label class="control-label">Old Password <span class="required">*</span></label>
                    <div class="controls">
                        <input type="hidden" name="user_id" id="user_id"  value="<?php echo $this->session->userdata('userid'); ?>" data-required="1" class="span6 m-wrap" />
                        <input type="text" name="old_pwd" id="old_pwd" value="" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">New Password <span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="new_pwd" id="new_pwd"  value="" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Confirm New Password <span class="required">*</span></label>
                    <div class="controls">
                        <input name="confirm_new_pwd" type="text"  value="" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green" id="sub" name="sub">Update</button>
                    <!--<button type="button" class="btn">Cancel</button>-->
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->
    <script >
//        $("#sub").click(function(){
//            //alert("asdfsa");
//            var old_pwd  =  $("#old_pwd").val();
//            //var user_id  =  $("#user_id").val();
//            //alert(user_id);
//            //alert(old_pwd);
//            $.ajax({
//                type: "POST",
//                url: "<?php echo site_url() ?>ajax_admin/get_old_password",
//                data: {'old_pwd': old_pwd},
//                success: function(data) {
//                    alert(data);
//                    if(data == '1'){
//                         $("span.err").text("");
//                        return true;
//                    }else{
//                        $("span.err").text("");
//                        $("span.err").text("Please Enter Correct Old Password");
//                        return true;
//                    }
//                }
//                
//            });
//            //alert("asdfdasf");
//            //return false;
//        });
    </script>
</div>
<!-- END PAGE CONTENT-->         

<!-- BEGIN PAGE LEVEL STYLES -->
<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE LEVEL STYLES --> 
<!-- Js For Form Component-->
<script src="<?php echo base_url(); ?>assets/plugins/jquery-1.10.1.min.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>assets/scripts/table-managed.js"></script>
<script src="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>assets/plugins/data-tables/jquery.dataTables.js" type="text/javascript"></script>
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
<!--<script src="<?php echo base_url(); ?>assets/plugins/bootstrap/js/bootstrap-multiselect.js" type="text/javascript" ></script> -->
<!--Js For Form Component -->


<!-- BEGIN PAGE LEVEL SCRIPTS -->
<script src="<?php echo base_url(); ?>assets/scripts/app.js"></script>
<script src="<?php echo base_url(); ?>assets/scripts/form-components.js"></script>    