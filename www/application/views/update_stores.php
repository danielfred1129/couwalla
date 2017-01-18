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

<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Store Details</div>
        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="add_store_form"  id="add_store_form" action="<?php echo site_url(); ?>admin/update_store" method="post" enctype="multipart/form-data">

                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>

                <?php
                $add = explode("%", $stores->address);
                //print_r($add);
                //print_r($category); echo "<br/><br/>";  echo "<br/><br/>"; print_r($stores);exit;  
                ?> 
                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Client<span class="required">*</span></label>
                            <div class="controls">
                                <input type="hidden" name="store_id" data-required="1" value="<?php echo $stores->id; ?>" />
                                <select class="span12 m-wrap" name="client" id="client" >
                                    <?php foreach ($customers as $customer) { ?>
                                        <option value="<?php echo $customer['id']; ?>" <?php
                                    if ($customer['id'] == $stores->customer) {
                                        echo "selected=selected";
                                    }
                                        ?> > <?php echo $customer['companyname']; ?></option>
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
                                <input type="text" name="address" id="address" data-required="1" value="<?php echo $add[0]; ?>" class="span12 m-wrap" />
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
                                <input type="text" name="store_name" data-required="1" value="<?php echo $stores->storename; ?>"  class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Address 2</label>
                            <div class="controls">
                                <input type="text" name="address2" id="address2" data-required="1" class="span12 m-wrap" value="<?php echo $add[1]; ?>"  />
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
                                <input type="text" name="store_number" class="span3 m-wrap" value="<?php echo $stores->storenumber; ?>"  />
                            </div>
                        </div>

                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Phone Number</label>
                            <div class="controls">
                                <input type="text" name="store_phone" data-required="1" value="<?php echo $stores->store_phone; ?>" class="span12 m-wrap"/>
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
                                <input type="text" name="checkin_points" data-required="1" value="<?php echo $stores->checkinpoints; ?>"  class="span3 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Country<span class="required">*</span></label>
                            <div class="controls">
                                <select name="country" class="span12 m-wrap" id="country"  >
                                    <?php foreach ($countries as $country) { ?>
                                        <option value="<?php echo $country['countryID']; ?>" <?php
                                    if ($country['countryID'] == $stores->country) {
                                        echo "selected=selected";
                                    }
                                        ?> > <?php echo $country['countryName']; ?></option>
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
                                <textarea  name="description" class="span12 m-wrap"  ><?php echo $stores->description; ?></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">State<span class="required">*</span></label>
                            <div class="controls" id="state_container">
                                <select name="state" class="span12 m-wrap" id="state" >
                                    <?php foreach ($state as $state1) { ?>
                                        <option value="<?php echo $state1['stateID']; ?>" ><?php echo $state1['stateName']; ?></option>
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
                            <label class="control-label">Categories<span class="required">*</span></label>
                            <div class="controls">
                                <div class="multiselect" id="category">
                                    <?php foreach ($catid as $value) { ?>


                                        <label><input type="checkbox"  class="category" name="category[]"
                                            <?php
                                            foreach ($category as $cat) {
                                                if ($cat['id'] == $value['id']) {
                                                    echo 'checked';
                                                }
                                            }
                                            ?>
                                                      id="category<?php echo $value['id']; ?>" value="<?php echo $value['id']; ?>"/><?php echo $value['category_name']; ?></label>
                                        <?php } ?>
                                </div>
                                <span for="store_id" class="err" style="color:red; font-size: 15px;"></span>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">City<span class="required">*</span></label>
                            <div class="controls">
                                <select name="city" class="span12 m-wrap" id="city"  >
                                    <?php foreach ($city as $city1) { ?>
                                        <option value="<?php echo $city1['cityID']; ?>" ><?php echo $city1['cityName']; ?></option>
                                    <?php } ?>
                                </select>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="sub_category_main">
                            <label class="control-label">Sub Categories<span class="required">*</span></label>
                            <div class="controls" >
                                <div class="multiselect" id="sub_category">
                                    <?php foreach ($subcategory as $sub_cat) { ?>
                                        <label><input type="checkbox" class="subcategory" name="sub_category[]" id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>" checked/><?php echo $sub_cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Zip Code<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="zip" data-required="1" value="<?php echo $stores->zip; ?>" class="span12 m-wrap"/>
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
                                <input type="text" name="keywords[]" class="span12 m-wrap" value="<?php echo $stores->keywords; ?>" />
                                <!--                                <div id="newlinktpl_keyword" style="display:none">  
                                                                      
                                                                </div>-->
                            </div>
                            <div class="controls" id="newlink" >
                                <p id="addnew">  
                                    <a href="javascript:update_feed()" >Add New </a>  
                                </p>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Lattitude <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="lattitude" id="latitude" data-required="1" value="<?php echo $stores->latitude; ?>" readonly class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="couponthumb" style="display:block;">
                            <label class="control-label">Store Thumbnail</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($stores->thumbnailimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img id="thumb" src="<?php echo base_url() ?>uploads/thumb/<?php echo $stores->thumbnailimage; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="store_thumbnail" id="store_thumbnail" class="default"  />
                                            <input type="hidden" name="hidden_store_thumbnail" id="hidden_store_thumbnail" class="default" value="<?php echo $stores->thumbnailimage; ?>"/>
                                        </span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload" id="remove_thumb" >Remove</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Longitude <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="longitude" id="longitude" data-required="1" value="<?php echo $stores->longitude; ?>" readonly  class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="storeimage" style="display:block;">
                            <label class="control-label">Store Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($stores->storeimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/<?php echo $stores->storeimage; ?>" id="store" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="store_image" id="store_image" class="default"  />
                                            <input type="hidden" name="hidden_store_image" id="hidden_store_image" class="default" value="<?php echo $stores->storeimage; ?>"/>
                                        </span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload" id="remove_image">Remove</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Time Zone(in GMT) <span class="required">*</span></label>
                            <div class="controls">
                                <select name="time_zone" id="time_zone" class="span12 m-wrap">
                                    <option value=""></option>
                                    <?php foreach ($timezones as $timezone) { ?>
                                        <option value="<?php echo $timezone['gmt']; ?>" <?php if($timezone['gmt'] == $stores->timezone) { echo "selected=selected"; } ?> ><?php echo $timezone['timezone_location']. "&nbsp;&nbsp;&nbsp;&nbsp;" .  $timezone['gmt']; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>
                <div class="form-actions">
                    <button type="submit" id="update" class="btn green">Update</button>
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->        
<!-- END PAGE -->  
<script type="text/javascript">
    $("#client").change(function(){
        //alert("asdfsa");
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
                    $('#thumb').attr("src", "http://www.placehold.it/200x150/EFEFEF/AAAAAA&text=no+image");
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
        if($("#store_thumbnail").val() != ""){
            $("#hidden_store_thumbnail").val("");
        }
    });
    $("#remove_thumb").click(function(){
        var client_id = jQuery('#client option:selected').val();
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
    });
    
    $("#store_image").change(function(){
        if($("#store_image").val() != ""){
            $("#hidden_store_image").val("");
        }
    });
    $("#remove_image").click(function(){
        var client_id = jQuery('#client option:selected').val();
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
    
    $(".category").click(function(){
        //alert("asdfa");
        //alert(getvalues());
        var cat_id  = new Array();
        var i=0;
        $(".category").each(function() {
            //alert("sdfs");
            if ($(this).is(':checked')) {
                cat_id[i] = $(this).val();
                //alert(cat_id);
                i++;
            }
        });
        $.ajax({
            type: "POST",
            url: "<?php echo site_url() ?>ajax_admin/get_storesub_category",
            data: {'cid': cat_id,'id':<?php echo $id ?>},
            success: function(data) {
                $('#sub_category_main').html(data);
            }
        });
    });
    
    $("#country").change(function(){
        
        if($("#country").val() == ""){
            $("#state").val("");
            $("#city").val("");            
        }
        var country_id = $("#country").val();
        //alert(country_id);
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
</script>

<!--<script>
    $("#add_store_form").submit(function(){
        var cat_id  = new Array();
        var i=0;
        $(".category").each(function() {
            //alert("sdfs");
            if ($(this).is(':checked')) {
                cat_id[i] = $(this).val();
                //alert(cat_id);
                i++;
            }
        }); //alert(cat_id);
        if(cat_id == ""){
            $("span.err").text("Please select any one Category");
            $(".category").focus();
            return false;
        }  else{
            var cat_id  = new Array();
            var i=0;
            $(".subcategory").each(function() {
                //alert("sdfs");
                if ($(this).is(':checked')) {
                    cat_id[i] = $(this).val();
                    //alert(cat_id);
                    i++;
                }
            }); //alert(cat_id);
            if(cat_id == ""){
                $("span.suberr").text("Please select any one Sub Category");
                $(".subcategory").focus();
                return false;
            } 
        }     
    }); 
</script>-->


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

