<!DOCTYPE html>

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Update User</div>
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


            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>admin/update_user" method="post">

                <?php //foreach ($res as $r) { ?>
                <input type="hidden" name="id" value="<?php echo $result->id; ?>"  class="span6 m-wrap" />
                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
                    You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
                    Your form validation is successful!
                </div>

                <div class="control-group">
                    <label class="control-label">First Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="hidden" name="user_id"  value="<?php echo $result->id; ?>" data-required="1" class="span6 m-wrap" />
                        <input type="text" name="firstname"  value="<?php echo $result->firstname; ?>" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Last Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="lastname"  value="<?php echo $result->lastname; ?>" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Email<span class="required">*</span></label>
                    <div class="controls">
                        <input name="email" type="text"  value="<?php echo $result->email; ?>" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">DOB</label>
                    <div class="controls">
                        <div class="input-append date date-picker" data-date="2013-12-02" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
                            <input class="m-wrap m-ctrl-medium date-picker" name="dob" id="dob"  size="16" type="text" value="<?php echo $result->dob; ?>" /><span class="add-on"><i class="icon-calendar"></i></span>
                        </div>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Gender</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="gender" >
                            <option value="Male" <?php
                if ($result->gender == "Male") {
                    echo "selected=selected";
                }
                ?> > Male </option>
                            <option value="Female" <?php
                                    if ($result->gender == "Female") {
                                        echo "selected=selected";
                                    }
                ?> > Female </option>
                        </select>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Ethenticity</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="ethenticity"  >
                            <option value="Caucasian/white" <?php
                                    if ($result->ethenticity == "Caucasian/white") {
                                        echo "selected=selected";
                                    }
                ?> > Caucasian/white </option>
                            <option value="African American/Black" <?php
                                    if ($result->ethenticity == "African American/Black") {
                                        echo "selected=selected";
                                    }
                ?> > African American/Black </option>
                            <option value="Hispanic/Latino" <?php
                                    if ($result->ethenticity == "Hispanic/Latino") {
                                        echo "selected=selected";
                                    }
                ?> > Hispanic/Latino </option>
                            <option value="Asian" <?php
                                    if ($result->ethenticity == "Asian") {
                                        echo "selected=selected";
                                    }
                ?> > Asian </option>
                            <option value="Other" <?php
                                    if ($result->ethenticity == "Other") {
                                        echo "selected=selected";
                                    }
                ?> > Other </option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Marital Status</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="marital_status"  >
                            <option value="single" <?php
                                    if ($result->marital_status == "single") {
                                        echo "selected=selected";
                                    }
                ?> > single </option>
                            <option value="divorced" <?php
                                    if ($result->marital_status == "divorced") {
                                        echo "selected=selected";
                                    }
                ?> > divorced </option>
                            <option value="married" <?php
                                    if ($result->marital_status == "married") {
                                        echo "selected=selected";
                                    }
                ?> > married </option>
                            <option value="other" <?php
                                    if ($result->marital_status == "other") {
                                        echo "selected=selected";
                                    }
                ?> > other </option>
                        </select>
                    </div>
                </div>

<!--                <div class="control-group">
                    <label class="control-label">Country</label>
                    <div class="controls">
                        <select name="country" class="span6 m-wrap" id="country"  >
                            <?php //foreach ($countries as $country) { ?>
                                <option value="<?php //echo $country['shortcode']; ?>" <?php
                           // if ($country['id'] == $result->country) {
                                //echo "selected=selected";
                           // }
                                ?> > <?php// echo $country['name']; ?></option>
                                    <?php// } ?>
                        </select>
                    </div>
                </div>-->

                <div class="control-group">
                    <label class="control-label">State</label>
                    <div class="controls">
                        <select name="state" class="span6 m-wrap" id="state"  >
                            <?php foreach ($state as $state1) { ?>
                                <option value="<?php echo $state1['stateID']; ?>" ><?php echo $state1['stateName']; ?></option>
                            <?php } ?>
                        </select>
                    </div>
                </div>

<!--                <div class="control-group">
                    <label class="control-label">City</label>
                    <div class="controls">
                        <select  name="city" class="span6 m-wrap" id="city"  >
                            <?php //foreach ($city as $city1) { ?>
                                <option value="<?php //echo $city1['cityid']; ?>" ><?php //echo $city1['cityname']; ?></option>
                            <?php //} ?>
                        </select>
                    </div>
                </div>-->

                <div class="control-group">
                    <label class="control-label">Zip Code<span class="required">*</span></label>
                    <div class="controls">
                        <input name="zipcode" type="text"  value="<?php echo $result->zip; ?>" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label" style="width:171px;">No of Children under 18-</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="no_of_childs"  >
                            <option value="1" <?php
                            if ($result->no_of_childerns == "1") {
                                echo "selected=selected";
                            }
                            ?> > 1 </option>
                            <option value="2" <?php
                                    if ($result->no_of_childerns == "2") {
                                        echo "selected=selected";
                                    }
                            ?> > 2 </option>
                            <option value="3" <?php
                                    if ($result->no_of_childerns == "3") {
                                        echo "selected=selected";
                                    }
                            ?> > 3 </option>
                            <option value="4" <?php
                                    if ($result->no_of_childerns == "4") {
                                        echo "selected=selected";
                                    }
                            ?> > 4 </option>
                            <option value="5+" <?php
                                    if ($result->no_of_childerns == "5+") {
                                        echo "selected=selected";
                                    }
                            ?> > 5+ </option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Have Pets</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="have_pets"  >
                            <option value="Yes" <?php
                                    if ($result->gender == "Yes") {
                                        echo "selected=selected";
                                    }
                            ?> > Yes </option>
                            <option value="No" <?php
                                    if ($result->gender == "No") {
                                        echo "selected=selected";
                                    }
                            ?> > No </option>
                        </select>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label" style="width:171px;">Yearly Household Income</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="house_income"  >
                            <option value="-under 25,000" <?php
                                    if ($result->yearly_income == "-under 25,000") {
                                        echo "selected=selected";
                                    }
                            ?> > -under 25,000 </option>
                            <option value="25,001-49,999" <?php
                                    if ($result->yearly_income == "25,001-49,999") {
                                        echo "selected=selected";
                                    }
                            ?> > 25,001-49,999 </option>
                            <option value="50,000-74,999" <?php
                                    if ($result->yearly_income == "50,000-74,999") {
                                        echo "selected=selected";
                                    }
                            ?> > 50,000-74,999 </option>
                            <option value="75,000-99,999" <?php
                                    if ($result->yearly_income == "75,000-99,999") {
                                        echo "selected=selected";
                                    }
                            ?> > 75,000-99,999 </option>
                            <option value="100,000-249,999" <?php
                                    if ($result->yearly_income == "100,000-249,999") {
                                        echo "selected=selected";
                                    }
                            ?> > 100,000-249,999 </option>
                            <option value="250,000 plus" <?php
                                    if ($result->yearly_income == "250,000 plus") {
                                        echo "selected=selected";
                                    }
                            ?> > 250,000 plus </option>
                            <option value="decline to answer" <?php
                                    if ($result->yearly_income == "decline to answer") {
                                        echo "selected=selected";
                                    }
                            ?> > decline to answer </option>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green">Update</button>
                    <!--<button type="button" class="btn">Cancel</button>-->
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->         

<!-- BEGIN PAGE LEVEL STYLES -->
<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
<!-- END PAGE LEVEL STYLES --> 
<!-- Js For Form Component-->

<!--<script type="text/javascript">

 $("#country").change(function(){
        
        if($("#country").val() == ""){
            $("#state").val("");
            $("#city").val("");            
        }
        var country_id = $("#country").val();
        //alert(country_id);
        $.ajax({
            type: "POST",
            url: "<?php //echo site_url() ?>ajax_admin/get_states",
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
            url: "<?php //echo site_url() ?>ajax_admin/get_cities",
            data: {'state_id': state_id},
            success: function(data) {
                $('#city').html(data);
            }
        });
    });
  
</script>-->
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
