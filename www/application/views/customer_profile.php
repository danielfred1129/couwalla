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
            <div class="caption">View Customer Detail</div>
        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="add_customer_form"  id="add_customer_form" action="<?php echo site_url(); ?>admin/edit_customer_form" method="post" enctype="multipart/form-data">
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
                                <input type="hidden" name="customer_id" data-required="1" value="<?php echo $customers->id; ?>" />
                                <input type="text" name="client_name" data-required="1" readonly value="<?php echo $customers->companyname; ?>" class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Address Line 1<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="address1" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->corporateaddress; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Admin Username<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="admin_username" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->adminusername; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Address Line 2</label>
                            <div class="controls">
                                <input type="text" name="address2" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->corporateaddress2; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group password-strength">
                            <label class="control-label">Password<span class="required">*</span></label>
                            <div class="controls">
                                <input type="password" class="span12 m-wrap" name="password" readonly id="password" value="<?php echo $customers->password; ?>" />

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Country<span class="required">*</span></label>
                            <div class="controls">
                                <select name="country" class="span12 m-wrap" id="country" disabled >
                                    <?php foreach ($country as $country1) { ?>
                                        <option value="<?php echo $country1['countryID']; ?>" > <?php echo $country1['countryName']; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">

                    </div>

                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">State<span class="required">*</span></label>
                            <div class="controls">
                                <select name="state" class="span12 m-wrap" id="state" disabled >
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
                            <label class="control-label">Full Name<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="full_name" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->fullname; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">City<span class="required">*</span></label>
                            <div class="controls">

                                <select  name="city" class="span12 m-wrap" id="city" disabled >
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
                        <div class="control-group">
                            <div class="controls">
                                <!--                                <label class="checkbox">
                                                                    <label>Retailer <span class="required" style="color: red;">*</span> <input type="checkbox"  name="retailer"  value=""  /></label> 
                                                                </label>
                                                                <label class="checkbox">
                                                                    <label>National Brand <span class="required" style="color: red;">*</span> <input type="checkbox" name="national_brand"  value="<?php echo $customers->national_brand; ?>" /></label> 
                                                                </label>
                                                                <label class="checkbox">
                                                                    <label>Manufacturer <span class="required" style="color: red;">*</span> <input type="checkbox" name="manufacturer"  value="<?php echo $customers->manufacturer; ?>" /></label> 
                                                                </label>
                                                                <label class="checkbox">
                                                                    <label>Single Store <span class="required" style="color: red;">*</span> <input type="checkbox" name="singal_store"  value="<?php echo $customers->singal_store; ?>" /></label> 
                                                                </label>-->

                                <label>Retailer <span class="required" style="color: red;">*</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; National Brand <span class="required" style="color: red;">*</span></label>
                                <input type="checkbox"  name="retailer" readonly value="<?php echo $customers->retailer; ?>" <?php
                                    if ($customers->retailer == 1) {
                                        echo "checked=checked";
                                    }
                                    ?>  />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                <input type="checkbox" name="national_brand" readonly value="<?php echo $customers->national_brand; ?>" <?php
                                       if ($customers->national_brand == 1) {
                                           echo "checked=checked";
                                       }
                                    ?> style="margin-left:90px;" />&nbsp;

                                <label>Manufacturer <span class="required" style="color: red;">*</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Single Store <span class="required" style="color: red;">*</span> </label> 
                                <input type="checkbox" name="manufacturer" readonly value="<?php echo $customers->manufacturer; ?>" <?php
                                       if ($customers->manufacturer == 1) {
                                           echo "checked=checked";
                                       }
                                    ?> />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="checkbox" name="singal_store" readonly value="<?php echo $customers->singal_store; ?>" <?php
                                       if ($customers->singal_store == 1) {
                                           echo "checked=checked";
                                       }
                                    ?> style="margin-left:90px;" /> 

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Zip Code<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="zip" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->zipcode; ?>" />
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
                                <textarea  name="description" class="span12 m-wrap" disabled value=""><?php echo $customers->description; ?></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Contact Number<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="contact_no" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->contactno; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Client Type<span class="required">*</span></label>
                            <div class="controls">
                                <select  name="clienttype" class="span12 m-wrap" id="clienttype" disabled >
                                    <?php foreach ($customer_types as $customer_type) { ?>
                                        <option value="<?php echo $customer_type['id']; ?>">
                                            <?php echo $customer_type['type_name']; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Alt. Contact Number</label>
                            <div class="controls">
                                <input type="text" name="alt_contact_no" data-required="1" readonly class="span12 m-wrap" value="<?php echo $customers->alt_contactno; ?>" />
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
                                <div class="multiselect">
                                    <?php foreach ($category as $cat) { ?>
                                        <label> <input type="checkbox" class="category" disabled name="category[]"  id="category<?php echo $cat['id']; ?>" value="<?php echo $cat['id']; ?>" checked  /><?php echo $cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Email<span class="required">*</span></label>
                            <div class="controls">
                                <input name="email" type="text" class="span12 m-wrap" value="<?php echo $customers->email; ?>" readonly />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>


                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Sub Categories</label>
                            <div class="controls" id="sub_category">
                                <div class="multiselect">
                                    <?php foreach ($subcategory as $sub_cat) { ?>
                                        <label><input type="checkbox" class="sub_category" disabled name="sub_category[]"  id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>"  checked /><?php echo $sub_cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Legal URL<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="legal_url" data-required="1"  readonly class="span12 m-wrap" value="<?php echo $customers->url; ?>" />
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="thumbimage" style="display:block;">
                            <label class="control-label">Thumbnail Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($customers->thumbnailimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/thumb/<?php echo $customers->thumbnailimage; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <!--                                    <div>
                                                                            <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                                                                <span class="fileupload-exists">Change</span>
                                                                                <input type="file" name="thumb_image" id="thumb_image" class="default" /></span>
                                                                            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                                                        </div>-->
                                </div>

                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Keywords</label>

                            <div class="controls" id="newlink_keyword">
                                    <!--<input type="text" name="keywords" data-required="1" class="span12 m-wrap"/>-->
                                <!--<div id="newlink" > --> 
                                <input type="text" name="keywords[]" class="span12 m-wrap" readonly value="<?php echo $customers->keyword; ?>" />
                                <div id="newlinktpl_keyword" style="display:none;" >  
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

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" id="companyimage" style="display:block;">
                            <label class="control-label">Company Image</label>
                            <div class="controls">
                                <div class="fileupload fileupload-new" data-provides="fileupload">
                                    <div class="fileupload-new thumbnail" style="width: 200px; height: 150px;">
                                        <?php if (!isset($customers->companyimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/<?php echo $customers->companyimage; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <!--                                    <div>
                                                                            <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                                                                <span class="fileupload-exists">Change</span>
                                                                                <input type="file" name="company_image" id="company_image" class="default" /></span>
                                                                            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                                                        </div>-->
                                </div>
                            </div>
                        </div>
                    </div>
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

<script type="text/javascript">
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
            url: "<?php echo site_url() ?>ajax_admin/get_sub_category",
            data: {'cid': cat_id},
            success: function(data) {
                //alert(data);
                $('#sub_category').html(data);
            }
        });
    });
</script>

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