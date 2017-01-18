
<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">User Details</div>
        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>admin/edit_user" method="post">

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
                        <input type="hidden" name="user_id" readonly value="<?php echo $result->id; ?>" data-required="1" class="span6 m-wrap" />
                        <input type="text" name="firstname" readonly value="<?php echo $result->firstname; ?>" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Last Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="lastname" readonly value="<?php echo $result->lastname; ?>" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Email<span class="required">*</span></label>
                    <div class="controls">
                        <input name="email" type="text" readonly value="<?php echo $result->email; ?>" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">DOB</label>
                    <div class="controls">
                        <input type="text" name="dob" readonly value="<?php echo $result->dob; ?>" data-required="1" class="span6 m-wrap" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Gender</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="gender" readonly>
                            <option value="<?php echo $result->gender; ?>"> <?php echo $result->gender; ?> </option>
                        </select>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Ethenticity</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="ethenticity" readonly >
                            <option value="<?php echo $result->ethenticity; ?>"> <?php echo $result->ethenticity; ?> </option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Marital Status</label>
                    <div class="controls">
                        <input name="marital_status" type="text" readonly value="<?php echo $result->marital_status; ?>" class="span6 m-wrap" />
                    </div>
                </div>



<!--                <div class="control-group">
                    <label class="control-label">Country</label>
                    <div class="controls">
                        <select name="country" class="span6 m-wrap" id="country">
                            <?php //foreach ($country as $country1) { ?>
                                <option value="<?php //echo $country1['id']; ?>" > <?php// echo $country1['name']; ?></option>
                            <?php //} ?>
                        </select>
                    </div>
                </div>-->
                <div class="control-group">
                    <label class="control-label">State</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="state" readonly >
                            <?php foreach ($state as $state1) { ?>
                                <option value="<?php echo $state1['stateID']; ?>" ><?php echo $state1['stateName']; ?></option>
                            <?php } ?>
                        </select>
                    </div>
                </div>
<!--                <div class="control-group">
                    <label class="control-label">City</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="state" readonly >
                            <?php //foreach ($city as $city1) { ?>
                                <option value="<?php //echo $city1['cityid']; ?>" ><?php //echo $city1['cityname']; ?></option>
                            <?php// } ?>
                        </select>
                    </div>
                </div>-->

                <div class="control-group">
                    <label class="control-label">Zip Code<span class="required">*</span></label>
                    <div class="controls">
                        <input name="zipcode" type="text" readonly value="<?php echo $result->zip; ?>" class="span6 m-wrap" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label" style="width:171px;">No of Children under 18-</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="no_of_childs" readonly >
                            <option value="<?php echo $result->no_of_childerns; ?>"> <?php echo $result->no_of_childerns; ?> </option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Have Pets</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="have_pets" readonly >
                            <option value="<?php echo $result->have_pets; ?>"> <?php echo $result->have_pets; ?> </option>
                        </select>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label" style="width:171px;">Yearly Household Income</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="house_income" readonly >
                            <option value="<?php echo $result->yearly_income; ?>"> <?php echo $result->yearly_income; ?> </option>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn green">Edit</button>
                    <!--<button type="button" class="btn">Cancel</button>-->
                </div>
            </form>
            <!-- END FORM-->
        </div>
    </div>
    <!-- END VALIDATION STATES-->

</div>
<!-- END PAGE CONTENT-->         
