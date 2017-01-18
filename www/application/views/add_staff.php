
<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add New Staff</div>
        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="addstaffform"  id="addstaffform" action="<?php echo site_url(); ?>admin/add_staff" method="post">

                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>

                <div class="control-group">
                    <label class="control-label">First Name<span class="required">*</span></label>
                    <div class="controls">
                        
                        <input type="text" name="firstname"  data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Last Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="lastname"  data-required="1" class="span6 m-wrap" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Username<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="username"  data-required="1" class="span6 m-wrap" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Password<span class="required">*</span></label>
                    <div class="controls">
                        <input type="password" name="password" id="pwd"  data-required="1" class="span6 m-wrap" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Confirm Password<span class="required">*</span></label>
                    <div class="controls">
                        <input type="password" name="confirmpassword" id="confirm_pwd"  data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Email<span class="required">*</span></label>
                    <div class="controls">
                        <input name="email" type="text" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Contact Number<span class="required">*</span></label>
                    <div class="controls">
                        <input name="contactno" type="text"  class="span6 m-wrap" />
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn green">Submit</button>
                    <!--<button type="button" class="btn">Cancel</button>-->
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE CONTENT-->         
