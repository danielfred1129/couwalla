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
            <div class="caption">Coupon Details</div>

        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>admin/edit_coupon" method="post" enctype="multipart/form-data">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>
                <?php //print_r($coupons); exit;?>
                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Client<span class="required">*</span></label>
                            <div class="controls">
                                <input type="hidden" name="coupon_id" data-required="1" value="<?php echo $coupons->id; ?>" />
                                <select class="span12 m-wrap" name="client" disabled id="client">
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
                            <label class="control-label">Code Type<span class="required"></label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="codetype" disabled id="codetype" >
                                    <?php if ($coupons->code_type == "couponcode") { ?>
                                        <option value="couponcode" selected="selected" >Coupon Code</option>
                                    <?php } else if ($coupons->code_type == "barcode") { ?>
                                        <option value="barcode" selected="selected" >Barcode</option>
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
                            <label class="control-label">Store List<span class="required">*</span></label>
                            <div class="controls">
<!--                                <select class="span12 m-wrap" name="store_list" id="store_list">
                                    <option value="" selected="selected">Select Store</option>
                                <?php foreach ($stores as $store) { ?>
                                                        <option value="<?php echo $store['id']; ?>"><?php echo $store['storename']; ?></option>
                                <?php } ?>

                                </select>-->

                                <div class="multiselect">
                                    <?php foreach ($store as $store1) { ?>
                                        <label><input type="checkbox" disabled checked="checked" class="store_list" name="store_list[]" value="<?php echo $store1['id']; ?>" /><?php echo $store1['storename']; ?></label>
                                    <?php } ?>

                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="couponcode" style="display:block;">
                            <label class="control-label">Coupon Code</label>
                            <div class="controls">
                                <input type="text" name="coupon_code" disabled value="<?php echo $coupons->couponcode; ?>" id="coupon_code" value="" class="span12 m-wrap"/>
<!--                                <span id="couponcode_eg" style="font-size: 14px;">Enter Any Text or Number <br />Example : abcde123 Or 123456</span>-->
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Coupon Name<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="coupon_name" disabled value="<?php echo $coupons->name; ?>" id="coupon_name" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="bar_code" style="display:block;">
                            <label class="control-label">Bar Type</label>
                            <div class="controls">
                                <select class="span12 m-wrap" name="barcode_type" disabled id="barcode_type" >
                                    <?php if ($coupons->bar_type == "qr") { ?>
                                        <option value="qr">QR Code</option>
                                    <?php } else if ($coupons->bar_type == "code128") { ?>
                                        <option value="code128">Code-128</option>
                                    <?php } else if ($coupons->bar_type == "code39") { ?>
                                        <option value="code39">Code-39</option>
                                    <?php } else if ($coupons->bar_type == "itf") { ?>
                                        <option value="itf">ITF Barcode</option>
                                    <?php } else if ($coupons->bar_type == "ean8") { ?>
                                        <option value="ean8">EAN-8</option>
                                    <?php } else if ($coupons->bar_type == "ean13") { ?>
                                        <option value="ean13">EAN-13</option>
                                    <?php } else if ($coupons->bar_type == "upca_upce") { ?>
                                        <option value="upca_upce">UPC-A and UPC-E </option>
                                    <?php } else if ($coupons->bar_type == "code93") { ?>
                                        <option value="code93">Code-93</option>
                                    <?php } else if ($coupons->bar_type == "codabar") { ?>
                                        <option value="codabar">Codabar</option>
                                    <?php } else if ($coupons->bar_type == "rss14") { ?>
                                        <option value="rss14">RSS-14(all variants)</option>
                                    <?php } else if ($coupons->bar_type == "rssexp") { ?>
                                        <option value="rssexp">RSS Expanded(most variants)</option>
                                    <?php } else if ($coupons->bar_type == "datamatrix") { ?>
                                        <option value="datamatrix">Data Matrix</option>
                                    <?php } else if ($coupons->bar_type == "aztec") { ?>
                                        <option value="aztec">Aztec</option>
                                    <?php } else if ($coupons->bar_type == "pdf417") { ?>
                                        <option value="pdf417">PDF 417</option>
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
                            <label class="control-label">Promo Text Short<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="promotext_short" disabled value="<?php echo $coupons->promo_text_short; ?>" id="promotext_short" data-required="1" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="bar_code_text" style="display:block;">
                            <label class="control-label">Bar Code Text<span class="required">*</span></label>
                            <!--                            <div class="controls">
                                                            <input type="text" name="barcode_text[]"  id="barcode_text" data-required="1"  class="span12 m-wrap"/>
                                                            <div id="newlinktpl_barcode" style="display:none">  
                                                                <div class="feed">  
                                                                    <input type="text" name="barcode_text[]"  class="span12 m-wrap" >  
                                                                </div>  
                                                            </div>
                                                            <span id="barcode_eg" style="font-size: 14px;"></span>
                                                        </div>-->

                            <div class="controls" id="newlink_barcode">
                                <input type="text" name="barcode_text[]" disabled id="barcode_text" data-required="1" value="<?php echo $coupons->barcodedata; ?>" class="span12 m-wrap"/>
                                <div id="newlinktpl_barcode" style="display:none">  
                                    <div class="feed">  
                                        <input type="text" name="barcode_text[]"  value="<?php echo $coupons->barcodedata; ?>"  class="span12 m-wrap" >  
                                    </div>  
                                </div>

                            </div>
<!--                            <div class="controls" id="newlink">
                                <span id="barcode_eg" style="font-size: 14px;"></span>
                                <p id="addnew">  
                                    <a href="javascript:add_barcode_feed()" id="bar_cd">Add New </a>  
                                </p>
                            </div>-->
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Coupon Description<span class="required">*</span></label>
                            <div class="controls">
                                <textarea  name="coupon_description" disabled id="coupon_description" class="span12 m-wrap"><?php echo $coupons->coupon_description; ?></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="couponthumb" style="display:block;">
                            <label class="control-label">Coupon Thumbnail</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($coupons->coupon_thumbnail)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/thumb/<?php echo $coupons->coupon_thumbnail; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
<!--                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="coupon_thumbnail" id="coupon_thumbnail" class="default" /></span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                    </div>-->
                                </div>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Terms & Conditions<span class="required">*</span></label>
                            <div class="controls">
                                <!--<input type="text" name="terms_condition_url"  class="span12 m-wrap"/>-->
                                <textarea  name="terms_conditions" id="terms_conditions" disabled class="span12 m-wrap"><?php echo $coupons->terms_conditions; ?></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" id="couponimage" style="display:non;">
                            <label class="control-label">Coupon Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($coupons->coupon_image)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/<?php echo $coupons->coupon_image; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
<!--                                    <div>
                                        <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                            <span class="fileupload-exists">Change</span>
                                            <input type="file" name="coupon_image" id="coupon_image" class="default" /></span>
                                        <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                    </div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <!--                        <div class="control-group">
                                                    <label class="control-label">What's Hot<span class="required">*</span></label>
                                                    <div class="controls">
                                                        <input type="checkbox" name="whats_hot" class="checkboxes" value="1" />
                                                    </div>
                        
                                                </div>
                                                <div class="control-group">
                                                    <label class="control-label">National Coupon<span class="required">*</span></label>
                                                    <div class="controls">
                                                        <input type="checkbox" name="national_coupon" class="checkboxes" value="1" />
                                                    </div>
                                                </div>-->

                        <div class="control-group">
                            <!--                            <label class="control-label">Checkbox</label>-->
                            <div class="controls">
                                <label>What's Hot <span class="required" style="color: red;">*</span> &nbsp;&nbsp;&nbsp;&nbsp; National Coupon <span class="required" style="color: red;">*</span> </label> 
                                <input type="checkbox" disabled name="whats_hot"  value="<?php echo $coupons->whats_hot; ?>" <?php if ($coupons->whats_hot == 1) { echo "checked=checked"; }?> /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" disabled name="national_coupon"  value="<?php echo $coupons->national_coupon; ?>" <?php if ($coupons->national_coupon == 1) { echo "checked=checked"; }?> />
<!--                                    National Coupon<span class="required" style="color: red;">*</span> <div class="checker"><span><input type="checkbox" ></span></div> -->

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Category<span class="required">*</span></label>
                            <div class="controls">
<!--                                <select class="multiselect" name="category[]" id="category" multiple="multiple">
                                    <option value="">Select...</option>
                                <?php //foreach ($category as $cat) { ?>
                                                <option value="<?php //echo $cat['id'];   ?>"><?php //echo $cat['category_name'];                 ?></option>
                                <?php //} ?>
                                </select>-->
                                <div class="multiselect" >
<!--                                    <label><input type="checkbox" name="category[]"  value="0" />Select Category</label>-->
                                    <?php foreach ($category as $cat) { ?>
                                        <label><input type="checkbox" disabled class="category" name="category[]" id="category<?php echo $cat['id']; ?>" checked="checked" value="<?php echo $cat['id']; ?>"   /><?php echo $cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">downloads per subscriber<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="no_of_downloads" disabled id="no_of_downloads" value="<?php echo $coupons->downloads; ?>"  class="span3 m-wrap"/>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Quantity Issued<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="quantity" data-required="1" disabled value="<?php echo $coupons->quantity; ?>" class="span3 m-wrap"/>
                            </div>
                        </div>


                        <div class="control-group">
                            <label class="control-label">Reward Points <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="reward_points" id="reward_points" disabled value="<?php echo $coupons->reward_points; ?>" data-required="1" class="span3 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group" >
                            <label class="control-label">Sub Category<span class="required">*</span></label>
                            <div class="controls" id="sub_category">
<!--                                <select class="span12 m-wrap" name="sub_category[]" multiple="multiple" >
                                    <option value="">Select...</option>
                                </select>-->
                                <div class="multiselect" >
  <!--                                    <label><input type="checkbox" name="category[]"  value="0" />Select Category</label>-->
                                    <?php foreach ($subcategory as $sub_cat) { ?>
                                        <label><input type="checkbox" disabled class="category" name="sub_category[]"  id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>"  checked="checked" /><?php echo $sub_cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Launch & Expiration Date</label>
                            <div class="controls">
                                <div class="input-prepend" >
                                    <span class="add-on"><i class="icon-calendar"></i></span><input type="text" disabled value="<?php echo $coupons->launch_date . " to " . $coupons->expiry_date; ?>" class="m-wrap date-range" name="coupon_date"  />
                                </div>
                                <!--                                <div class="input-append date date-picker" data-date="2013-12-02" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
                                                                    <input class="m-wrap m-ctrl-medium date-picker" name="expirydate" id="expirydate"  size="16" type="text" value="" /><span class="add-on"><i class="icon-calendar"></i></span>
                                                                </div>-->
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Legal Url<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="legal_url" disabled class="span12 m-wrap" value="<?php echo $coupons->legal_url; ?>" />
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
                                    <!--<input type="text" name="keywords" data-required="1" class="span12 m-wrap"/>-->
                                <!--<div id="newlink" > --> 
                                <input type="text" name="keywords[]" value="<?php echo $coupons->keywords; ?>" disabled class="span12 m-wrap" />
                                <div id="newlinktpl_keyword" style="display:none">  
                                    <div class="feed">  
                                        <input type="text" name="keywords[]" style="margin-top: 5px;" class="span12 m-wrap" >  
                                    </div>  
                                </div>

                                <!--</div>  -->
                            </div>
<!--                            <div class="controls" id="newlink">
                                <p id="addnew">  
                                    <a href="javascript:add_feed()">Add New </a>  
                                </p>
                            </div>-->
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green" id="add_btn">Edit</button>
                </div>

            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->     

<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-toggle-buttons/static/js/jquery.toggle.buttons.js"></script>

<!-- BEGIN PAGE LEVEL STYLES -->
<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>


<script type="text/javascript" >
        
//    $("#codetype").change(function(){
//        //alert("asdfas");
//        if($("#codetype").val() == "couponcode"){
//            $("#barcode_type").prop('disabled', 'disabled');
//            $("#barcode_type").val("");
//            $("#couponcode_eg").html("Enter Any Text or Number <br />Example : abcdefgh Or 123456");
//            $("#coupon_code").prop('disabled', false);
//            $("#barcode_text").prop('disabled', 'disabled');
//            $("#barcode_text").val("");
//            $("#coupon_image").prop('disabled', false);
//            $("#coupon_thumbnail").prop('disabled', false);
//        }else if($("#codetype").val() == "barcode"){
//            $("#barcode_type").prop('disabled', false);
//            $("#coupon_code").prop('disabled', 'disabled');
//            $("#coupon_code").val("");
//            $("#barcode_text").prop('disabled', false);
//            $("#coupon_image").prop('disabled', 'disabled');
//            $("#coupon_thumbnail").prop('disabled', 'disabled');
//            $("#couponcode_eg").html("");            
//        }else {
//            $("#barcode_type").val("");
//            $("#coupon_code").val("");
//            $("#barcode_text").val("");
//            $("#barcode_type").prop('disabled', 'disabled');
//            $("#coupon_code").prop('disabled', 'disabled');
//            $("#barcode_text").prop('disabled', 'disabled');
//            $("#coupon_image").prop('disabled', 'disabled');
//            $("#coupon_thumbnail").prop('disabled', 'disabled');            
//        }
//    });
//    $("#barcode_type").change(function(){
//        if($("#barcode_type").val() == "qr"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "block");
//            $("#barcode_eg").html("Enter Any Text. (Example : hello world Or abc)");
//            //$("#coupon_code").css("display", "block");
//        }
//        else if($("#barcode_type").val() == "code128"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "block");
//            $("#barcode_eg").html("Enter ASCII data (example: abc123).");
//        }
//        else if($("#barcode_type").val() == "code39"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "block");
//            $("#barcode_eg").html("Enter capital letters A-Z, digits 0-9, and symbols -.$/+%* and space (example: $ABC%123)");
//        }
//        else if($("#barcode_type").val() == "itf"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "none");            
//            $("#barcode_eg").html("Enter 14 numeric digits (example: 12345678912345)");
//        }
//        else if($("#barcode_type").val() == "ean8"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "none");
//            $("#barcode_eg").html("Enter 8 numeric digits (example: 03867856)");
//        }
//        else if($("#barcode_type").val() == "ean13"){
//            $("#barcode_text").css("display", "block");
//            $("#bar_cd").css("display", "none");
//            $("#barcode_eg").html("Enter 13 numeric digits (example: 1234567891234)");
//        }else{
//            $("#barcode_eg").html("");
//        }
//    });
//    
//    
//    
//    $("#add_btn").click(function(){
//        var text = $("#barcode_text").val();
//        if($("#barcode_type").val() == "qr"){
//        }
//        else if($("#barcode_type").val() == "code128"){
//            //            if($.isNumeric(text) == false ){
//            //                alert("Please Enter Proper Bar Code Text As Given In Example");
//            //                $("#barcode_text").focus();
//            //                return false;
//            //            }
//        }
//        else if($("#barcode_type").val() == "code39"){
//            //            if($.isNumeric(text) == false || text.length != 14 ){
//            //                alert("Please Enter Proper Bar Code Text As Given In Example");
//            //                $("#barcode_text").focus();
//            //                return false;
//            //            }
//        }
//        else if($("#barcode_type").val() == "itf"){
//            if($.isNumeric(text) == false || text.length != 14 ){
//                alert("Please Enter Proper Bar Code Text As Given In Example");
//                $("#barcode_text").focus();
//                return false;
//            }
//        }
//        else if($("#barcode_type").val() == "ean8"){
//            if($.isNumeric(text) == false || text.length != 8 ){
//                alert("Please Enter Proper Bar Code Text As Given In Example");
//                $("#barcode_text").focus();
//                return false;
//            }
//        }
//        else if($("#barcode_type").val() == "ean13"){
//            if($.isNumeric(text) == false || text.length != 13 ){
//                alert("Please Enter Proper Bar Code Text As Given In Example");
//                $("#barcode_text").focus();
//                return false;
//            }
//        }
//    });
//    $(document).ready(function() {
//        $('.multiselect').multiselect({
//            buttonWidth: '300px',
//            maxHeight: 200,
//            Width: 400
//        });
//    });
//    
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
//                //alert(data);
//                $('#sub_category').html(data);
//            }
//        });
//    });

</script>


<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
<!-- BEGIN CORE PLUGINS -->   <script src="<?php echo base_url(); ?>assets/plugins/jquery-1.10.1.min.js" type="text/javascript"></script>

<!-- IMPORTANT! Load jquery-ui-1.10.1.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->



<!--[if lt IE 9]>
<script src="assets/plugins/excanvas.min.js"></script>
<script src="assets/plugins/respond.min.js"></script>  
<![endif]-->   




<!-- END CORE PLUGINS -->


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



