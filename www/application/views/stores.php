<!--<link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/plugins/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/css/style-metro.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/css/style.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/css/style-responsive.css" rel="stylesheet" type="text/css"/>
       <link href="<?php echo base_url(); ?>assets/css/themes/default.css" rel="stylesheet" type="text/css" id="style_color"/>
       <link href="<?php echo base_url(); ?>assets/plugins/uniform/css/uniform.default.css" rel="stylesheet" type="text/css"/>-->
<!-- END GLOBAL MANDATORY STYLES -->
<!-- BEGIN PAGE LEVEL STYLES -->
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
<link rel="stylesheet" href="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.css" />
<!-- END PAGE LEVEL STYLES -->
<!--        <script src="<?php echo base_url(); ?>assets/scripts/jquery.min.js"></script>-->
<link rel="shortcut icon" href="favicon.ico" />

<!-- BEGIN PAGE CONTENT-->
<div class="row-fluid">
    <div class="span12">
        <!-- BEGIN EXAMPLE TABLE PORTLET-->
        <form name="display_users" method="post" action="<?php echo site_url(); ?>admin/delete_stores">
            <div class="portlet box light-grey">
                <div class="portlet-title">
                    <div class="caption"><i class="icon-building"></i>Manage Stores</div>

                </div>
                <div class="portlet-body">
                    <div class="table-toolbar">
                        <div class="btn-group">
                            <a href="<?php echo site_url('admin/add_store'); ?>" class="btn green">Add Store</a>
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn green" id="delete">
                                Delete Store
                            </button>
                        </div>
<!--                        <a data-toggle="modal" class="btn" role="button" href="#myModal">Import Stores</a>-->
                        <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" class="modal hide fade" id="myModal" tabindex="-1" style="display: none; margin-top: -122px;">
                            <div class="modal-header">
                                <button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
                                <h3 id="myModalLabel">Import Stores </h3>
                            </div>
                            <div class="modal-body">
                                <form class="horizontal-form" action="#" >
                                    <div class="row-fluid">
                                        <div class="span6 ">
                                            <div class="control-group">
                                                <label class="control-label">Select File</label>
                                                <div class="controls">
                                                    <div data-provides="fileupload" class="fileupload fileupload-new"><input type="hidden" value="" name="">
                                                        <div class="input-append">
                                                            <div class="uneditable-input">
                                                                <i class="icon-file fileupload-exists"></i> 
                                                                <span class="fileupload-preview"></span>
                                                            </div>
                                                            <span class="btn btn-file">
                                                                <span class="fileupload-new">Select file</span>
                                                                <span class="fileupload-exists">Change</span>
                                                                <input type="file" class="default" name="">
                                                            </span>
                                                            <a data-dismiss="fileupload" class="btn fileupload-exists" href="#">Remove</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <span for="store_id" class="err" style="color:red; font-size: 15px;"></span>
                    <table class="table table-striped table-bordered table-hover" id="sample_2">
                        <thead>
                            <tr>
                                <th style="width:8px;"><input type="checkbox" class="group-checkable" data-set="#sample_2 .checkboxes" /></th>
                                <th>Store Name</th>
                                <th class="hidden-480">Description</th>
                                <th class="hidden-480">country</th>
                                <th class="hidden-480">State</th>
                                <th class="hidden-480">City</th>
                                <th class="hidden-480">QR Code</th>
<!--                                <th class="hidden-480">Image</th>-->
                            </tr>
                        </thead>
                        <tbody>

                            <?php foreach ($result as $r) { ?>
                                <tr class="odd gradeX">
                                    <td><input type="checkbox" name="store_id[]" class="checkboxes store" value="<?php echo $r['id']; ?>" /></td>
                                    <td><a href="<?php echo site_url(); ?>/admin/show_store_details?id=<?php echo $r['id']; ?>"><?php echo $r['storename']; ?></a></td>
                                    <td class="hidden-480"><?php echo $r['description']; ?></td>
                                    <td class="hidden-480"><?php
                            $sql = mysql_query("Select countryName from countries where countryID='$r[country]'") or die(mysql_error());
                            $result = mysql_fetch_array($sql);
                                echo $result['countryName'];
                            ?></td>
                                    <td class="center hidden-480"><?php
                                    $sql = mysql_query("Select stateName from states where stateid='$r[state]'") or die(mysql_error());
                                    $result = mysql_fetch_array($sql);
                                    echo $result['stateName'];
                                ?></td>
                                    <td class="center hidden-480"><?php
                                    $sql = mysql_query("Select cityname from cities where cityid='$r[city]'") or die(mysql_error());
                                    $result = mysql_fetch_array($sql);
                                    echo $result['cityname'];
                                ?></td>
                                    <td class="center hidden-480">
                                        <a data-toggle="modal" class="btn" role="button" href="#myModal<?php echo $r['id']; ?>" >Preview</a>
                                    </td>

    <!--                                    <td ><img src="<?php echo base_url() ?>uploads/<?php echo $r['storeimage']; ?>" alt="<?php echo $r['storeimage']; ?>" height="20" width="20"></td>-->
                                </tr>
                            <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" class="modal hide fade" id="myModal<?php echo $r['id']; ?>" tabindex="-1" style="display: none; margin-top: -122px;">
                                <div class="modal-header">
                                    <button aria-hidden="true" data-dismiss="modal" class="close" type="button"></button>
                                    <h3 id="myModalLabel">Stores QR Code </h3>
                                </div>
                                <div class="modal-body">
                                    <form class="horizontal-form" action="#" >
                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/qr/<?php echo $r['qr_code']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                    </form>
                                </div>
                            </div>  
                        <?php } ?>
                        </tbody>
                    </table>

                </div>
            </div>
            <!-- END EXAMPLE TABLE PORTLET-->
        </form>

        <script>
            $("#delete").click(function(){
                var cat_id  = new Array();
                var i=0;
                $(".store").each(function() {
                    //alert("sdfs");
                    if ($(this).is(':checked')) {
                        cat_id[i] = $(this).val();
                        //alert(cat_id);
                        i++;
                    }
                }); 
                if(cat_id == ""){
                    $("span.err").text("Please select Atleast One Store");
                    return false;
                }else{
                    $("span.err").text("");
                    if (confirm("Are you sure you want to Delete Store?") == true) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }                
            }); 
        </script>

    </div>
</div>


<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script> 
<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
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
<!-- BEGIN PAGE LEVEL PLUGINS -->
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/select2/select2.min.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/data-tables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/data-tables/DT_bootstrap.js"></script>
<!-- END PAGE LEVEL PLUGINS -->
<!-- BEGIN PAGE LEVEL SCRIPTS -->
<script src="<?php echo base_url(); ?>assets/scripts/app.js"></script>
<script src="<?php echo base_url(); ?>assets/scripts/table-managed.js"></script>     
<script>
    jQuery(document).ready(function() { 
        App.init();
        TableManaged.init();
    });
</script>