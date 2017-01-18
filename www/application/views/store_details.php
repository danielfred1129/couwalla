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
            <form  class="form-horizontal" name="add_store_form"  action="<?php echo site_url(); ?>admin/edit_store_form" method="post" enctype="multipart/form-data">

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
                $add1 = str_replace(" ", "+", $add[0]);
                
                //print_r($add); exit;
                ////print_r($category); echo "<br/><br/>"; print_r($subcategory); echo "<br/><br/>"; print_r($stores);exit;  
                ?> 
                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Client<span class="required"  >*</span></label>
                            <div class="controls">
                                <input type="hidden" name="store_id" data-required="1" value="<?php echo $stores->id; ?>" />
                                <select class="span12 m-wrap" name="client" readonly>
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
                            <label class="control-label">Store Address<span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="address" data-required="1" value="<?php echo $stores->address; ?>" class="span12 m-wrap" readonly />
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
                                <input type="text" name="store_name" data-required="1" value="<?php echo $stores->storename; ?>" readonly class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Address 2</label>
                            <div class="controls">
                                <input type="text" name="address2" data-required="1" class="span12 m-wrap" value="" readonly />
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
                                <input type="text" name="store_number" class="span3 m-wrap" value="<?php echo $stores->storenumber; ?>" readonly />
                            </div>
                        </div>

                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Store Phone Number</label>
                            <div class="controls">
                                <input type="text" name="store_phone" data-required="1" value="<?php echo $stores->store_phone; ?>" readonly class="span12 m-wrap"/>
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
                                <input type="text" name="checkin_points" data-required="1" value="<?php echo $stores->checkinpoints; ?>" readonly class="span3 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Country<span class="required">*</span></label>
                            <div class="controls">
                                <select name="country" class="span12 m-wrap" id="country" readonly >
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
                        <div class="control-group">
                            <label class="control-label">Description<span class="required">*</span></label>
                            <div class="controls">
                                <textarea  name="description" class="span12 m-wrap" readonly ><?php echo $stores->description; ?></textarea>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">State<span class="required">*</span></label>
                            <div class="controls" id="state_container">
                                <select name="state" class="span12 m-wrap" id="state" readonly>
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
                                <div class="multiselect" >
<!--                                    <label><input type="checkbox" name="category[]"  value="0" />Select Category</label>-->
                                    <?php foreach ($category as $cat) { ?>
                                        <label><input type="checkbox" class="category" name="category[]" disabled readonly id="category<?php echo $cat['id']; ?>" value="<?php echo $cat['id']; ?>"  checked /><?php echo $cat['category_name']; ?></label>
                                    <?php } ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">City<span class="required">*</span></label>
                            <div class="controls">
									<input type="text" name="city" data-required="1" value="<?php echo $stores->city;  ?>" readonly class="span12 m-wrap"/>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                </div>

                <div class="row-fluid">
                    <div class="span6 ">
                        <div class="control-group" >
                            <label class="control-label">Sub Category<span class="required">*</span></label>
                            <div class="controls" id="sub_category">
                                <div class="multiselect">
  <!--                                    <label><input type="checkbox" name="category[]"  value="0" />Select Category</label>-->
                                    <?php foreach ($subcategory as $sub_cat) { ?>
                                        <label><input type="checkbox" class="category" name="sub_category[]" disabled readonly id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>" checked  /><?php echo $sub_cat['category_name']; ?></label>
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
                                <input type="text" name="zip" data-required="1" value="<?php echo $stores->zip; ?>" readonly class="span12 m-wrap"/>
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
                                <input type="text" name="keywords[]" class="span12 m-wrap" readonly value="<?php echo $stores->keywords; ?>" >
                                <div id="newlinktpl_keyword" style="display:none">  
                                    <div class="feed">  
                                        <input type="text" name="keywords[]" class="span12 m-wrap" readonly style="margin-top: 5px;" />  
                                    </div>  
                                </div>
                            </div>
                            <!--                            <div class="controls" id="newlink" >
                                                            <p id="addnew">  
                                                                <a href="javascript:add_feed()" >Add New </a>  
                                                            </p>
                                                        </div>-->
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Lattitude <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="lattitude" data-required="1" value="<?php echo $stores->latitude; ?>" readonly class="span12 m-wrap"/>
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
                                        <?php if (empty($stores->thumbnailimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/thumb/<?php echo $stores->thumbnailimage; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <!--                                    <div>
                                                                            <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                                                                <span class="fileupload-exists">Change</span>
                                                                                <input type="file" name="store_thumbnail" id="store_thumbnail" class="default" disabled /></span>
                                                                            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload" >Remove</a>
                                                                        </div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/span-->
                    <div class="span6 ">
                        <div class="control-group">
                            <label class="control-label">Longitude <span class="required">*</span></label>
                            <div class="controls">
                                <input type="text" name="longitude" data-required="1" value="<?php echo $stores->longitude; ?>" readonly class="span12 m-wrap"/>
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
                                        <?php if (empty($stores->storeimage)) { ?>
                                            <img src="http://www.placehold.it/200x150/EFEFEF/AAAAAA&amp;text=no+image" alt="" />
                                        <?php } else { ?>
                                            <img src="<?php echo base_url() ?>uploads/<?php echo $stores->storeimage; ?>" alt="" />
                                        <?php } ?>
                                    </div>
                                    <div class="fileupload-preview fileupload-exists thumbnail" style="max-width: 200px; max-height: 150px; line-height: 20px;"></div>
                                    <!--                                    <div>
                                                                            <span class="btn btn-file"><span class="fileupload-new">Select image</span>
                                                                                <span class="fileupload-exists">Change</span>
                                                                                <input type="file" name="store_image" id="store_image" class="default" disabled /></span>
                                                                            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
                                                                        </div>-->
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
                                    <option value="<?php echo $stores->timezone; ?>"><?php echo $stores->timezone; ?></option>
                                </select>
                                
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
<!-- END PAGE -->  

<!-- END CONTAINER -->

</body>
<!-- END BODY -->
</html>