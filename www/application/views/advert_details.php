

<!-- END PAGE HEADER-->

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Advertisement Details</div>
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
            <form  class="form-horizontal" name="add_advertisement_form"  id="add_advertisement_form" action="<?php echo site_url(); ?>/admin/edit_advertisement_form" method="post" enctype="multipart/form-data">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>
                <?php
                $start_date = explode(" ", $advertisement->valid_from);
                $end_date = explode(" ", $advertisement->valid_till);
                //print_r($start_date);
                ////print_r($advertisement);exit; 
                ?>
                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Customer Name<span class="required">*</span></label>
                            <div class="controls">
                                <input type="hidden" name="advert_id" data-required="1" value="<?php echo $advertisement->id; ?>" />
                                <select class="span12 m-wrap" name="customer" disabled>
                                    <?php foreach ($customer as $customer1) { ?>
                                        <option value="<?php echo $customer1['id']; ?>" > <?php echo $customer1['companyname']; ?></option>
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
                                <select class="span12 m-wrap" name="type" id="type" disabled>
                                    <?php if ($advertisement->adv_type == 'hyperlink') { ?>
                                        <option value="hyperlink" selected="selected" >Hyperlink</option>
                                    <?php } else { ?>
                                        <option value="coupon" selected="selected" >Static Or Coupon</option>
                                    <?php } ?>
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
                                    <span class="add-on"><i class="icon-calendar"></i></span><input type="text" readonly value="<?php echo $start_date[0] . " to " . $end_date[0]; ?>" class="m-wrap date-range" name="advertisement_date"  />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Show : Hyperlink </label>
                            <div class="controls">
                                <input type="text" name="hyperlink" id="hyperlink" class="span12 m-wrap" readonly value="<?php echo $advertisement->hyperlink; ?>"/>
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
                                    <input type="text" class="span5 m-wrap m-ctrl-small timepicker-24" name="start_time" readonly value="<?php echo $start_date[1]; ?>" />
                                    <span class="add-on"><i class="icon-time"></i></span>

                                    <div class="input-append bootstrap-timepicker-component"> 
                                        <input type="text" class="span7 m-wrap m-ctrl-small timepicker-24" name="end_time" readonly style="margin-left: 10px;" value="<?php echo $start_date[1]; ?>" />
                                        <span class="add-on"><i class="icon-time"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Show : Coupon </label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="coupon" id="coupon" disabled >
                                    <?php foreach ($coupon as $coupon1) { ?>
                                        <option value="<?php echo $coupon1['id']; ?>">
                                            <?php echo $coupon1['name']; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Ad Text</label>
                            <div class="controls">
                                <input type="text" name="add_text" class="span12 m-wrap" readonly value="<?php echo $advertisement->add_text; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Notes</label>
                            <div class="controls">
                                <textarea  name="notes" class="span12 m-wrap" value="" readonly > <?php echo $advertisement->description; ?></textarea>
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
                                <input type="text" name="reward_points" data-required="1" readonly value="<?php echo $advertisement->reward_points; ?>" class="span6 m-wrap"  />
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
                                        <?php if (isset($advertisement->banner_image)) { ?>
                                            <img src="<?php echo base_url() ?>uploads/<?php echo $advertisement->banner_image; ?>" alt="" />
                                        <?php } else { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <!--                                                    <div>
                                                                                            <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                                                                                <span class="fileupload-exists">Change</span>
                                                                                                <input type="file" name="banner_image" id="banner_image" class="default" /></span>
                                                                                            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                                                                        </div>-->
                                </div>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green">Edit</button>
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->         

<!-- END CONTAINER -->

<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/js/jquery.toggle.buttons.js"></script>

<!-- BEGIN PAGE LEVEL STYLES -->

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