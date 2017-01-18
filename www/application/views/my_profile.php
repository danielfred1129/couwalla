<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
    <!-- BEGIN HEAD -->
    <head>
        <meta charset="utf-8" />

        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <meta content="" name="description" />
        <meta content="" name="author" />

        <!-- BEGIN PAGE LEVEL STYLES -->
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
        <!-- END PAGE LEVEL STYLES -->
        <link rel="shortcut icon" href="favicon.ico" />
    </head>
    <!-- END HEAD -->
    <!-- BEGIN BODY -->
    <body class="page-header-fixed">

        <div class="row-fluid">
            <!-- BEGIN VALIDATION STATES-->
            <div class="portlet box green">
                <div class="portlet-title">
                    <div class="caption">My Profile</div>
                </div>
                <div class="portlet-body form">
                    <!-- BEGIN FORM-->
                    <h3></h3>
                    <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>admin/edit_my_profile" method="post">

                        <?php //print_r($customer_type); echo $customer_type[0]['type_name']; exit; ?>
                        <input type="hidden" name="id" value="<?php echo $result->id; ?>"  readonly class="span6 m-wrap" />
                        <div class="alert alert-error hide">
                            <button class="close" data-dismiss="alert"></button>
                            You have some form errors. Please check below.
                        </div>

                        <div class="alert alert-success hide">
                            <button class="close" data-dismiss="alert"></button>
                            Your form validation is successful!
                        </div>
                        <div class="control-group">
                            <label class="control-label">UserName</label>
                            <div class="controls">
                                <input type="text" name="username" value="<?php echo $result->username; ?>" readonly data-required="1" class="span6 m-wrap" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label class="control-label">FirstName</label>
                            <div class="controls">
                                <input type="text" name="firstname" value="<?php echo $result->firstname; ?>" readonly data-required="1" class="span6 m-wrap" />
                            </div>
                        </div>

                        <div class="control-group">
                            <label class="control-label">LastName</label>
                            <div class="controls">
                                <input type="text" name="lastname" value="<?php echo $result->lastname; ?>" readonly data-required="1" class="span6 m-wrap" />
                            </div>
                        </div>



                        <div class="control-group">
                            <label class="control-label">Email</label>
                            <div class="controls">
                                <input name="email" type="text" value="<?php echo $result->email; ?>" readonly class="span6 m-wrap" />
                            </div>
                        </div>

<!--                        <div class="control-group">
                            <label class="control-label">Customer<span class="required">*</span></label>
                            <div class="controls">
                                <select class="span6 m-wrap" name="customer" readonly >
                                    <option value="<?php echo $customer_type[0]['id']; ?>"><?php echo $customer_type[0]['type_name']; ?></option>
                                </select>
                            </div>
                        </div>-->


                        <div class="control-group">
                            <label class="control-label">Contact No</label>
                            <div class="controls">
                                <input type="text" name="contactno" value="<?php echo $result->contact_info; ?>" readonly data-required="1" class="span6 m-wrap" />
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
    </body>
    <!-- END BODY -->
</html>