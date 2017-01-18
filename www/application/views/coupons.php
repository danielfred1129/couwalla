<!-- BEGIN GLOBAL MANDATORY STYLES -->
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
        <div class="portlet box light-grey">
            <div class="portlet-title">
                <div class="caption"><i class="icon-barcode"></i>Manage Coupons</div>
            </div>
            <div class="portlet-body">
                <div class="table-toolbar">
                    <div class="btn-group">
                        <!--<button type="submit" class="btn green">
                        Add New <i class="icon-plus"></i>
                        </button>-->
                        <a href="<?php echo site_url('admin/add_new_coupon'); ?>" class="btn green">Add Coupons</a>


                    </div>
                    <div class="btn-group">
                        <button type="submit" class="btn green" id="delete">
                            Delete Coupons
                        </button>

                    </div>
                    <div class="alert alert-error hide">
                        <button class="close" data-dismiss="alert"></button>
                        You have some form errors. Please check below.
                    </div>

                    <div class="alert alert-success hide">
                        <button class="close" data-dismiss="alert"></button>
                        Your form validation is successful!
                    </div>
                    <div style="float:right">

                        <form method="post" action="<?php echo site_url(); ?>/admin/filter_coupons">
                            <label class="control-label">Coupon Name
                                <input type="text" name="search"/>
                                Date Range
                                <input id="ui_date_picker_range_from" class="m-wrap small hasDatepicker" type="text" name="from" />
                                <span class="text-inline"> to </span>
                                <input id="ui_date_picker_range_to" class="m-wrap small hasDatepicker" type="text" name="to" />
                                <button id="Filter" class="btn green" type="submit" style="margin-top: -7px;"> Filter </button></label>
                        </form>
                    </div>
                </div>
                <form name="display_coupons" id="display_coupons" method="post" action="" >

                    <span for="coupon_id" class="err" style="color:red; font-size: 15px;"></span>
                    <table class="table table-striped table-bordered table-hover" id="sample_2">
                        <thead>
                            <tr>
                                <th style="width:8px;"><input type="checkbox" class="group-checkable" data-set="#sample_2 .checkboxes" /></th>
                                <th>Coupon name</th>
                                <th class="hidden-480">Promo Text</th>

                                <th class="hidden-480">Uploaded On</th>

                                <th class="hidden-480">Downloaded</th>
                                <th class="hidden-480">Redeemed</th>
                                <th class="hidden-480">Expired</th>


                                <th >Preview</th>
                            </tr>
                        </thead>
                        <tbody>

                            <?php foreach ($result as $r) { ?>
                                <tr class="odd gradeX">
                                    <td><input type="checkbox" name="coupon_id[]" class="checkboxes coupon" id="couponid" value="<?php echo $r['id']; ?>" /></td>
                                    <td><a href="<?php echo site_url(); ?>admin/show_coupon_details?id=<?php echo $r['id']; ?>"><?php echo $r['name']; ?></a></td>
                                    <td class="hidden-480"><?php echo $r['promo_text_short']; ?></td>
                                    <td class="hidden-480"><?php echo $r['launch_date']; ?></td>

                                    <td class="hidden-480"><?php echo $r['downloads']; ?></td>
                                    <td class="hidden-480"><?php echo $r['reward_points']; ?></td>
                                    <td class="hidden-480"><?php echo $r['expiry_date']; ?></td>


                                    <td class="hidden-480">
                                        <?php if ($r['code_type'] == "barcode") { ?>
                                        <a href="javascript:void(0)" id="pre<?php echo $r['id']; ?>" >Preview</a>
                                            <input type="hidden" value="<?php echo $r['bar_type']; ?>" id="bar_type<?php echo $r['id'] ?>" />
                                            <input type="hidden" value="<?php echo $r['barcodedata']; ?>" id="bar_text<?php echo $r['id'] ?>" />
                                        <?php } else if ($r['code_type'] == "couponcode") { ?>
                                            <a href="javascript:void(0)" id="pre<?php echo $r['id']; ?>" >Preview </a>
                                            <input type="hidden" value="<?php echo $r['coupon_image']; ?>" id="<?php echo $r['barcodedata']; ?>" />
                                        <?php } ?>
                                        <script type="text/javascript">
                                            $(function($) {                            	
                                                $("#pre<?php echo $r['id']; ?>").click(function() {
                                                    loading(); // loading
                                                    setTimeout(function(){ // then show popup, deley in .5 second
                                                        loadPopup(); // function show popup 
                                                    }, 500); // .5 second
                                                    return false;                               
                                                });
                                                                                                                                                        	
                                                /* event for close the popup */
                                                $("div.close").hover(
                                                function() {
                                                    $('span.ecs_tooltip').show();
                                                },
                                                function () {
                                                    $('span.ecs_tooltip').hide();
                                                }
                                            );
                                                                                                                                                        	
                                                $("div.close").click(function() {
                                                    disablePopup();  // function close pop up
                                                });
                                                                                                                                                        	
                                                $(this).keyup(function(event) {
                                                    if (event.which == 27) { // 27 is 'Ecs' in the keyboard
                                                        disablePopup();  // function close pop up
                                                    }  	
                                                });
                                                                                                                                                        	
                                                $("div#backgroundPopup").click(function() {
                                                    disablePopup();  // function close pop up
                                                });
                                                                                                                                                        	
                                                $('a.livebox').click(function() {
                                                    alert('Hello World!');
                                                    return false;
                                                });
                                                                                                                                                        	

                                                /************** start: functions. **************/
                                                function loading() {
                                                    $("div.loader").show();  
                                                }
                                                function closeloading() {
                                                    $("div.loader").fadeOut('normal');  
                                                }
                                                                                                                                                        	
                                                var popupStatus = 0; // set value
                                                                                                                                                        	
                                                function loadPopup() { 
                                                    if(popupStatus == 0) { // if value is 0, show popup
                                                        closeloading(); // fadeout loading
                                                        //$("#toPopup").css("display", "block");
                                                        $("#toPopup<?php echo $r['id']; ?>").fadeIn(0500); // fadein popup div
                                                        $("#backgroundPopup").css("opacity", "0.7"); // css opacity, supports IE7, IE8
                                                        $("#backgroundPopup").fadeIn(0001); 
                                                        popupStatus = 1; // and set value to 1
                                                    }	
                                                }
                                                                                                                                                        		
                                                function disablePopup() {
                                                    if(popupStatus == 1) { // if value is 1, close popup
                                                        $("#toPopup<?php echo $r['id']; ?>").fadeOut("normal");  
                                                        $("#backgroundPopup").fadeOut("normal");  
                                                        popupStatus = 0;  // and set value to 0
                                                    }
                                                }
                                                /************** end: functions. **************/
                                            });   
                                        </script>
                                        <div class="popup" id="toPopup<?php echo $r['id']; ?>" >
                                            <div class="close"></div>
                                        <!--            <span class="ecs_tooltip">Press Esc to close <span class="arrow"></span></span>-->
                                            <div id="popup_content"> 
                                                <?php if ($r['code_type'] == "couponcode") { ?>
                                                    <img src ="<?php echo base_url() ?>uploads/<?php echo $r['coupon_image'] ?>" />
                                                <?php } else if ($r['code_type'] == "barcode") {
                                                    if ($r['bar_type'] != "qr") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                                    <?php } else if ($r['bar_type'] != "code128") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                                    <?php } else if ($r['bar_type'] != "code39") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                                    <?php } else if ($r['bar_type'] != "itf") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                                    <?php } else if ($r['bar_type'] != "ean8") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_" /></center>
                                                    <?php } else if ($r['bar_type'] != "ean13") { ?>
                                                        <center> <img src ="https://api.scandit.com/barcode-generator/v1/<?php echo $r['bar_type']; ?>/<?php echo $r['barcodedata']; ?>?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200" /></center>
                                                    <?php }
                                                } ?>
                                            </div> <!--your content end-->

                                        </div>
                                        <div class="loader"></div>
                                        <div id="backgroundPopup"></div>

                                                                                                    </td>         <!--<td ><span class="label label-success">Approved</span></td>-->
                                </tr>
                            <?php } ?>
                        </tbody>

                    </table>
                </form>
            </div>
        </div>
        <!-- END EXAMPLE TABLE PORTLET-->


        <script>
            $("#delete").click(function(){
                var cat_id  = new Array();
                var i=0;
                $(".coupon").each(function() {
                    //alert("sdfs");
                    if ($(this).is(':checked')) {
                        cat_id[i] = $(this).val();
                        //alert(cat_id);
                        i++;
                    }
                }); 
                if(cat_id == ""){
                    //alert(cat_id);
                    $("span.err").text("Please select Atleast One Coupon");
                    return false;
                }else{
                    if (confirm("Are you sure you want to Delete Coupon?") == true) {
                        $("#display_coupons").attr("action","<?php echo site_url(); ?>admin/delete_coupons");
                        $("#display_coupons").submit();
                        return true;
                    }
                    else {
                        return false;
                    }
                }                
            }); 
        </script>
        <script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
    </div>
</div>

<!-- END FOOTER -->
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
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
<script src="<?php echo base_url(); ?>assets/scripts/ui-jqueryui.js"></script>
<!-- END PAGE LEVEL PLUGINS -->
<!-- BEGIN PAGE LEVEL SCRIPTS -->
<script src="<?php echo base_url(); ?>assets/scripts/app.js"></script>
<script src="<?php echo base_url(); ?>assets/scripts/table-managed.js"></script>     
<script>
    jQuery(document).ready(function() {       
        App.init();
        TableManaged.init();
        UIJQueryUI.init();
    });
</script>


