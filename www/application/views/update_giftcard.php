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

    <!-- BEGIN PAGE CONTENT-->
    <div class="row-fluid">
        <!-- BEGIN VALIDATION STATES-->
        <div class="portlet box green">
            <div class="portlet-title">
                <div class="caption">Edit Gift Card</div>
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
                <form  class="form-horizontal" name="giftcard"  id="giftcard" action="<?php echo site_url(); ?>/admin/update_giftcard" method="post" enctype="multipart/form-data">


                    <div class="alert alert-error hide">
                        <button class="close" data-dismiss="alert"></button>
                        You have some form errors. Please check below.
                    </div>

                    <div class="alert alert-success hide">
                        <button class="close" data-dismiss="alert"></button>
                        Your form validation is successful!
                    </div>
                    <input type="hidden" name="card_id" value="<?php echo $card->id; ?>"  class="span6 m-wrap" readonly/>
                    <div class="control-group">
                        <label class="control-label">Card Name</label>
                        <div class="controls">
                            <input type="text" name="card_name" value="<?php echo $card->card_name; ?>"  class="span6 m-wrap" />
                        </div>
                    </div>
                    <div class="control-group">
                            <label class="control-label">Rewards Description</label>
                            <div class="controls">
                                <input type="text" name="description" value="<?php echo $card->description; ?>"  class="span6 m-wrap" />
                            </div>
                        </div>
                    <div class="control-group">
                        <label class="control-label">Card Image<span class="required">*</span></label>
                        <div class="controls">
                            <img src="<?php echo $card->image_url; ?>" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Reward Points<span class="required">*</span></label>
                        <div class="controls">
                            <input type="text" name="reward_points" value="<?php echo $card->reward_points; ?>" class="span6 m-wrap" />
                        </div>
                    </div>
                    <div class="control-group">
                            <label class="control-label">Reward Price<span class="required">*</span></label>
                            <div class="controls">
                                <input type="textarea" name="reward_points" value="<?php if($card->reward_price != -1){echo "$". $card->reward_price / 100;} else{ echo "Price Variable"; } ?>" class="span6 m-wrap" readonly />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Reward Minimum Price<span class="required">*</span></label>
                            <div class="controls">
                                <input type="textarea" name="reward_points" value="<?php if($card->reward_min_price != 0 ){echo "$". $card->reward_min_price / 100;} else{ echo $card->reward_min_price; } ?>" class="span6 m-wrap" readonly />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Reward Maximum Price<span class="required">*</span></label>
                            <div class="controls">
                                <input type="textarea" name="reward_points" value="<?php if($card->reward_max_price != 0 ){echo "$". $card->reward_max_price / 100;} else{ echo $card->reward_max_price; } ?>" class="span6 m-wrap" readonly />
                            </div>
                        </div>

                    <div class="form-actions">
                        <button type="submit" class="btn green">Update</button>
<!--                        <button type="button" class="btn">Cancel</button>-->
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