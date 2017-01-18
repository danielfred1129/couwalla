<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Update My Profile</div>
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
            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/update_my_profile" method="post">
                <!--<form  class="form-horizontal"  id="form_sample_2" action="#" method="post">-->
                <input type="hidden" name="id" value="<?php echo $my_profile['id']; ?>" class="span6 m-wrap"/>
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
                        <input type="text" name="username" data-required="1" value="<?php echo $my_profile['username']; ?>" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">FirstName<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="firstname" value="<?php echo $my_profile['firstname']; ?>" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">LastName<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="lastname"  value="<?php echo $my_profile['lastname']; ?>" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Email<span class="required">*</span></label>
                    <div class="controls">
                        <input name="email" type="text" value="<?php echo $my_profile['email']; ?>" class="span6 m-wrap"/>
                    </div>
                </div>

<!--                <div class="control-group">
                    <label class="control-label">Customer<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="customer">
                            <option value="">Select...</option>
                            <?php foreach($customer_type as $customer){ ?>
                            <option value="<?php echo $customer['id']; ?>" <?php if($my_profile['customer'] == $customer['id']){ echo "selected =selected"; } ?> > <?php echo $customer['type_name']; ?></option>
                            <?php }?>
                        </select>
                    </div>
                </div>-->

                <div class="control-group">
                    <label class="control-label">ContactNo<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="contactno"  value="<?php echo $my_profile['contactno']; ?>" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


<!--                <div class="control-group">
                    <label class="control-label">Active<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="active">
                            <option value="">Select...</option>
                            <option value="Category 1">Active</option>
                            <option value="Category 2">Inactive</option>


                        </select>
                    </div>
                </div>-->
                <div class="form-actions">
                    <button type="submit" class="btn green">Update</button>
                    <!--	<button type="button" class="btn">Cancel</button>-->
                </div>
            </form>

            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->         

<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->


<!-- BEGIN PAGE LEVEL STYLES -->
<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE LEVEL STYLES --> 


<!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>