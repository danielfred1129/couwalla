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
        <form  class="form-horizontal"  id="form_sample_2" action="<?php echo site_url(); ?>admin/delete_giftcard" method="post">
            <div class="portlet box light-grey">
                <div class="portlet-title">
                    <div class="caption"><i class="icon-credit-card"></i>Manage Gift Cards</div>

                </div>

                <div class="portlet-body">
                    <div class="table-toolbar">
                        <!--                        <div class="btn-group">
                                                    <a href="<?php echo site_url('admin/add_giftcard'); ?>" class="btn green">Add Gift Card</a>
                                                </div>
                                                <div class="btn-group">
                                                    <button type="submit" class="btn green" id="delete">
                                                        Delete Gift Card
                                                    </button>
                                                    <div class="btn-group">
                        
                                                    </div>
                        
                                                </div>-->
                    </div>
                    <span for="coupon_id" class="err" style="color:red; font-size: 15px;"></span>
                    <table class="table table-striped table-bordered table-hover" id="sample_2">
                        <thead>
                            <tr>
                                <th style="width:8px;"><input type="checkbox" class="group-checkable" data-set="#sample_2 .checkboxes" /></th>
                                <th class="hidden-480">Card Name</th>
                                <th class="hidden-480">Rewards Description</th>
                                <th class="hidden-480">Card Image</th>
<!--                                <th class="hidden-480">Valid Till</th>
                                <th class="hidden-480">Quantity</th>
                                <th class="hidden-480">Points</th>-->

                            </tr>
                        </thead>
                        <tbody>

                            <?php foreach ($result as $card) { ?>
                                <tr class="odd gradeX">
                                    <td><input type="checkbox" name="id" class="checkboxes giftcards" value="<?php echo $card['id']; ?>" /></td>
                                    <td><a href="<?php echo site_url(); ?>admin/show_giftcard_details?id=<?php echo $card['id']; ?>" > <?php echo $card['card_name']; ?> </a> </td>
                                    <td><?php echo $card['description']; ?></td> 
                                    <td><img src="<?php echo $card['image_url']; ?>" /></td>    
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>

                </div>
            </div>
        </form>
        <!-- END EXAMPLE TABLE PORTLET-->
    </div>
</div>

<!-- BEGIN CORE PLUGINS -->  
<script>
    $("#delete").click(function(){
        var cat_id  = new Array();
        var i=0;
        $(".cust").each(function() {
            //alert("sdfs");
            if ($(this).is(':checked')) {
                cat_id[i] = $(this).val();
                //alert(cat_id);
                i++;
            }
        }); 
        if(cat_id == ""){
            //alert(cat_id);
            $("span.err").text("Please select Atleast One Gift Cards");
            return false;
        }else{
            $("span.err").text("");
            if (confirm("Are you sure you want to Delete Gift Cards?") == true) {
                return true;
            }
            else {
                return false;
            }
        }                
    }); 
</script>
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