

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add Notification</div>

        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="addnotificationform"  id="addnotificationform" action="<?php echo site_url(); ?>admin/add_new_notification" method="post">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>


                <div class="control-group">
                    <label class="control-label">Campaigns<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="customer" id="gid" onchange="saveChanges((this.options[this.selectedIndex].value))">
                            <option value="">Select...</option>
                            <?php foreach ($result as $r) {
                                ?>
                                <option value="<?php echo $r['name']; ?>"><?php echo $r['name']; ?></option>
                            <?php } ?>

                        </select>
                    </div>
                </div>

                <div id="result"></div>








                <div class="control-group">
                    <label class="control-label">Notification Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="notification_name" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Notification Text<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="notificationtext" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Notify On<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="notifyon" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Launch Date<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="launch_date" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Launch Time<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="username" id="username" class="span6 m-wrap"/>
                    </div>
                </div>


                <div id="status"></div>



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

<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE LEVEL STYLES -->



<script>


    function saveChanges(name1){
        //alert(name1);
        //$('#customer').change(function(){
        campaign_name  = $('#gid').val();
        //alert(campaign_name);
        //$.post('http://localhost/couwalla/notification_ajax.php',{campaign:campaign_name},function(res){

        $.post('http://<?php echo $_SERVER['SERVER_NAME']; ?>/notification_ajax.php',{campaign:campaign_name},function(res){
				
            $("#result").html(res);
        });
				
        //});
    }
</script>	


