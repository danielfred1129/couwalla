

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add Gift Card</div>

        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>admin/add_new_giftcard" method="post" enctype="multipart/form-data">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
                </div>



                <div class="control-group">
                    <label class="control-label">Display Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="display" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Customer Type<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="customertype">
                            <option value="">Select...</option>
                            <option value="Category 1">Category 1</option>
                            <option value="Category 2">Category 2</option>
                            <option value="Category 3">Category 3</option>

                        </select>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="name" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Description<span class="required">*</span></label>
                    <div class="controls">
                        <input type="textarea" name="description" class="span6 m-wrap" value="" />
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Thumbnail Image<span class="required">*</span></label>
                    <div class="controls">
                        <input type="file" name="thumbnailimage">
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Full Image</label>
                    <div class="controls">
                        <input type="file" name="fullimage">
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Barcode Type<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="barcodetype">
                            <option value="">Select...</option>
                            <option value="Category 1">UPC</option>
                            <option value="Category 2">28</option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Barcode Data<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="barcodedata" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Valid From<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="validfrom" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Valid Till<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="validtill" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Points<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="points" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Savings<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="savings" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Quantity<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="quantity" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Legal Url<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="legalurl" data-required="1" class="span6 m-wrap"/>
                    </div>
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
