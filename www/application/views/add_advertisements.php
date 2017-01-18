<!-- Css For Form Component -->
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-fileupload/bootstrap-fileupload.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/gritter/css/jquery.gritter.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/clockface/css/clockface.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />

<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-timepicker/compiled/timepicker.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-colorpicker/css/colorpicker.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/stylesheets/bootstrap-toggle-buttons.css" />

<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-datetimepicker/css/datetimepicker.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/jquery-multi-select/css/multi-select-metro.css" />
<link href="<?php echo base_url(); ?>assets/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
<link href="<?php echo base_url(); ?>assets/plugins/bootstrap-switch/static/stylesheets/bootstrap-switch-metro.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/jquery-tags-input/jquery.tagsinput.css" />
<!-- Css For Form Component -->

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add Advertisement</div>
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
            <form  class="form-horizontal" name="add_advertisement_form"  id="add_advertisement_form" action="<?php echo site_url(); ?>/admin/save_new_advertisement" method="post" enctype="multipart/form-data">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Client Name<span class="required">*</span></label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="customer" id="customer">
                                    <option value="">Select...</option>
                                    <?php foreach ($customers as $customer) { ?>
                                        <option value="<?php echo $customer['id']; ?>">
                                            <?php echo $customer['companyname']; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Type<span class="required">*</span></label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="type" id="type">
                                    <option value="">Select...</option>
                                    <option value="hyperlink">Hyperlink</option>
                                    <option value="coupon">Static Or Coupon</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Start & End Date <span class="required">*</span></label>
                            <div class="controls">
                                <div class="input-prepend" >
                                    <span class="add-on"><i class="icon-calendar"></i></span><input type="text" class="m-wrap date-range" name="advertisement_date"  />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Show : Hyperlink </label>
                            <div class="controls">
                                <input type="text" name="hyperlink" id="hyperlink" class="span12 m-wrap" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Start & End Time <span class="required">*</span></label>
                            <div class="controls">
                                <div class="input-append bootstrap-timepicker-component">
                                    <input type="text" class="span5 m-wrap m-ctrl-small timepicker-24" name="start_time" >
                                    <span class="add-on"><i class="icon-time"></i></span>
                                    
                                    <div class="input-append bootstrap-timepicker-component"> 
                                        <input type="text" class="span7 m-wrap m-ctrl-small timepicker-24" name="end_time" style="margin-left: 10px;" >
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>

<!--                            <div class="controls">
                                <div class="input-append bootstrap-timepicker-component">
                                    <input type="text" class="span5 m-wrap m-ctrl-small timepicker-default" name="start_time" />
                                    <span class="add-on"><i class="icon-time"></i></span>

                                    <div class="input-append bootstrap-timepicker-component">
                                        <input type="text" class="span7 m-wrap m-ctrl-small timepicker-default" name="end_time" style="margin-left: 10px;"/>
                                        <span class="add-on"><i class="icon-time"></i></span>&nbsp;
                                    </div>
                                </div>
                            </div>-->
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Show : Coupon </label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="coupon" id="coupon">
                                    <option value="" selected ="selected">Select Coupon...</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Ad Text </label>
                            <div class="controls">
                                <input type="text" name="add_text" class="span12 m-wrap" value="" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Notes</label>
                            <div class="controls">
                                <textarea  name="notes" class="span12 m-wrap" value=""></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Reward Points<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="reward_points" data-required="1" class="span6 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="bannerimage" style="display:block;">
                            <label class="control-label">Banner Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="banner_image" id="banner_image" class="default" /></span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green">Add</button>
                    <button type="button" class="btn">Cancel</button>
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>

<script type="text/javascript">
    $("#type").change(function(){
        //alert("asdfas");
        if($("#type").val() == "hyperlink"){
            $("#hyperlink").removeAttr("disabled");
            $("#coupon").prop('disabled', 'disabled');
            $("#coupon").val('');
        }else if($("#type").val() == "coupon"){
            $("#hyperlink").prop('disabled', 'disabled');
            $("#coupon").removeAttr("disabled"); 
            $("#hyperlink").val('');
        }else{
            $("#hyperlink").prop('disabled', 'disabled');
            $("#coupon").prop('disabled', 'disabled');
            $("#hyperlink").val('');
            $("#coupon").val('');
        }
    });
    
    $("#customer").change(function(){
        //alert("asdfa");
        //alert(getvalues());
        var cust_id = $("#customer").val();
        
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_ad_coupons",
            data: {'cust_id': cust_id},
            success: function(data) {
               // alert(data);
                $('#coupon').html(data);
            }
        });
    });
</script>
<!-- END PAGE CONTENT-->         
<!-- Js For Form Component-->

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
<!-- END PAGE LEVEL SCRIPTS -->