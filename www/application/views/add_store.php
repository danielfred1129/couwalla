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

<style type="text/css">
    .multiselect {
        width:26em;
        height:8em;
        border:solid 1px #c0c0c0;
        overflow:auto;
    }

    .multiselect label {
        display:block;
    }

    .multiselect-on {
        color:#ffffff;
        background-color:#000099;
    }
</style>

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add Store</div>

        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="add_store_form"  id="add_store_form" action="<?php echo site_url(); ?>admin/save_new_store" method="post" enctype="multipart/form-data">

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
                            <label class="control-label">Client<span class="required">*</span></label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="client" id="client">
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
                            <label class="control-label">Store Address<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="address" id="address" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label"> Store Name<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="store_name" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Address 2</label>
                            <div class="controls">
                                <input type="text" name="address2" id="address2" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Number<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="store_number" class="span3 m-wrap"  />
                            </div>
                        </div>

                    </div>
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Phone Number</label>
                            <div class="controls">
                                <input type="text" name="store_phone" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">

                        <div class="control-group">
                            <label class="control-label">Check In Points<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="checkin_points" data-required="1" class="span3 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Country<span class="required">*</span></label>
                            <div class="controls">
                                <select name="country" class="span12 m-wrap" id="country">
                                    <option value="">Select Country.......</option>
                                    <?php foreach ($countries as $country) { ?>
                                        <option value="<?php echo $country['countryID']; ?>">
                                            <?php echo $country['countryName']; ?></option>
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
                            <label class="control-label">Description<span class="required">*</span></label>
                            <div class="controls">
                                <textarea  name="description" class="span12 m-wrap" value=""></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">State<span class="required">*</span></label>
                            <div class="controls" id="state_container">
                                <select name="state" class="span12 m-wrap" id="state">
                                    <option value="">Select State.......</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Categories<span class="required">*</span></label>
                            <div class="controls">
                                <div class="multiselect" id="category">

                                </div>
                                <div id="form_2_service_error"></div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">City<span class="required">*</span></label>
                            <div class="controls">
								<input type="text" name="city" id="city" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" >
                            <label class="control-label">Sub Category<span class="required">*</span></label>
                            <div class="controls" >
<!--                                <select class="span12 m-wrap" name="sub_category[]" multiple="multiple" >
                                    <option value="">Select...</option>
                                </select>-->
                                <div class="multiselect" id="sub_category">
<!--                                    <label><input type="checkbox" name="sub_category[]"  value="" />Select Sub Category</label>-->
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Zip Code<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="zip" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Keywords</label>

                            <div class="controls" id="newlink_keyword">
                                <div id="newlinktpl_keyword">  
                                    <div class="feed">  
                                        <input type="text" name="keywords[]" class="span12 m-wrap" style="margin-top: 5px;" />  
                                    </div>  
                                </div>
                            </div>
                            <div class="controls" id="newlink" >
                                <p id="addnew">  
                                    <a href="javascript:add_feed()" >Add New </a>  
                                </p>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <!--
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Latitude <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="latitude" data-required="1" id="latitude" class="span12 m-wrap" readonly />
                            </div>
                        </div>
                    </div>
                    -->
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="couponthumb" style="display:block;">
                            <label class="control-label">Store Thumbnail</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;" >
                                        <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" id="thumb"/>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="store_thumbnail" id="store_thumbnail" class="default" value=""/>
                                            <input type="hidden" name="hidden_store_thumbnail" id="hidden_store_thumbnail" class="default" value=""/>
                                        </span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload" >Remove</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <!--
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Longitude <span class="required">*</span></label>
                            <div class="controls" >
                                <input type="text" name="longitude" id="longitude" data-required="1" class="span12 m-wrap" readonly />
                            </div>
                        </div>
                    </div>
                    -->
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="storeimage" style="display:block;">
                            <label class="control-label">Store Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;" id="store_input">
                                        <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" id="store"/>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="store_image" id="store_image" class="default" />
                                            <input type="hidden" name="hidden_store_image" id="hidden_store_image" class="default" value=""/>
                                        </span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Time Zone(in GMT) <span class="required">*</span></label>
                            <div class="controls" >
                                <select name="time_zone" id="time_zone" class="span12 m-wrap">
                                    <option value=""></option>
                                     <?php foreach ($timezones as $timezone) { ?>
                                        <option value="<?php echo $timezone['gmt']; ?>">
                                            <?php echo $timezone['timezone_location']. "&nbsp;&nbsp;&nbsp;&nbsp;" . $timezone['gmt']; ?></option>
                                    <?php } ?>
                                </select>
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
<!-- END PAGE CONTENT-->         

<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE LEVEL STYLES --> 
<script type="text/javascript">
    //    $(".category").click(function(){
    //        //alert("asdfa");
    //        //alert(getvalues());
    //        var cat_id  = new Array();
    //        var i=0;
    //        $(".category").each(function() {
    //            //alert("sdfs");
    //            if ($(this).is(':checked')) {
    //                cat_id[i] = $(this).val();
    //                //alert(cat_id);
    //                i++;
    //            }
    //        });
    //        $.ajax({
    //            type: "POST",
    //            url: "<?php echo site_url() ?>ajax_admin/get_sub_category",
    //            data: {'cid': cat_id},
    //            success: function(data) {
    //                $('#sub_category').html(data);
    //            }
    //        });
    //    });

    $("#client").change(function(){
        var client_id = jQuery('#client option:selected').val();
        //         alert(client_id);
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_categories",
            data: {'id': client_id},
            success: function(data) {
                $('#category').html(data);
            }
        });
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_sub_categories",
            data: {'id': client_id},
            success: function(data) {                
                $('#sub_category').html(data);
            }
        });
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_thumb_image",
            data: {'id': client_id},
            success: function(data) {
                if(data != ""){
                    var  url = "<?php echo base_url(); ?>uploads/thumb/"+data;
                    $('#thumb').attr("src", url);
                    $('#hidden_store_thumbnail').val(data);
                }else{
                    $('#thumb').attr("src", " http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image");
                    $('#hidden_store_thumbnail').val("");
                }
                               
            }
        });
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_store_image",
            data: {'id': client_id},
            success: function(data) {
                if(data != ""){
                    var  url = "<?php echo base_url(); ?>uploads/"+data;
                    $('#store').attr("src", url);
                    $('#hidden_store_image').val(data);
                }else{
                    $('#store').attr("src", " http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image");
                    $('#hidden_store_image').val("");
                }
            }
        });
    });
    
    $("#store_thumbnail").change(function(){
        var client_id = jQuery('#client option:selected').val();
        if($("#store_thumbnail").val() != ""){
            $("#hidden_store_thumbnail").val("");
        }else{
            $.ajax({
                type: "POST",
                url: "<?php echo site_url() ?>ajax_admin/get_thumb_image",
                data: {'id': client_id},
                success: function(data) {
                    if(data != ""){
                        var  url = "<?php echo base_url(); ?>uploads/"+data;
                        $('#thumb').attr("src", url);
                        $('#hidden_store_thumbnail').val(data);
                    }else{
                        $('#thumb').attr("src", " http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image");
                        $('#hidden_store_thumbnail').val("");
                    }                               
                }
            });
        }
    });
    
    $("#store_image").change(function(){
        var client_id = jQuery('#client option:selected').val();
        if($("#store_image").val() != ""){
            $("#hidden_store_image").val("");
        }else{
            $.ajax({
                type: "POST",
                url: "<?php echo site_url() ?>ajax_admin/get_store_image",
                data: {'id': client_id},
                success: function(data) {
                    if(data != ""){
                        var  url = "<?php echo base_url(); ?>uploads/"+data;
                        $('#store').attr("src", url);
                        $('#hidden_store_image').val(data);
                    }else{
                        $('#store').attr("src", " http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image");
                        $('#hidden_store_image').val("");
                    }
                }
            });
        }
    });
    
    $("#country").change(function(){
        
        if($("#country").val() == ""){
            $("#state").val("");
            $("#city").val("");            
        }
        var country_id = jQuery('#country option:selected').val();
        // alert(country_id);
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_states",
            data: {'country_id': country_id},
            success: function(data) {
                //alert(data);
                //return false;
                $('#state').html(data);
            }
        });
    });
    /*
    $("#state").change(function(){
        if($("#state").val() == ""){
            $("#city").val("");            
        }
        var state_id = $("#state").val();
        //alert(country_id);
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_cities",
            data: {'state_id': state_id},
            success: function(data) {
                $('#city').html(data);
            }
        });
    });
    
    jQuery('#address').blur(function() {
        
        var add1 = $('#address').val();
        var add2 = $('#address2').val();
        jQuery.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_latitude",
            data: {'address': add1, 'address2': add2},
            success: function(message) {
                $('#latitude').val(message);
            }
        });

        jQuery.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_longitude",
            data: {'address': add1, 'address2': add2},
            success: function(message) {
                $('#longitude').val(message);
            }
        });
    });
    
    jQuery('#address2').blur(function() {
        
        var add1 = $('#address').val();
        var add2 = $('#address2').val();
        jQuery.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_latitude",
            data: {'address': add1, 'address2': add2},
            success: function(message) {
                $('#latitude').val(message);
            }
        });

        jQuery.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_longitude",
            data: {'address': add1, 'address2': add2},
            success: function(message) {
                $('#longitude').val(message);
            }
        });
        
//        jQuery.ajax({
//            type: "POST",
//            url: "<?php echo site_url() ?>ajax_admin/get_time_zone",
//            data: dataString,
//            success: function(message) {
//                $('#time_zone').val(message);
//            }
//        });
    });
    */
  
</script>

