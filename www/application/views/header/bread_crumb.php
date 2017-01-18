
<div class="page-content" >

    <!-- BEGIN PAGE CONTAINER-->
    <div class="container-fluid">
        <!-- BEGIN PAGE HEADER-->


        <!-- BEGIN PAGE HEADER-->
        <div class="row-fluid" >
            <div class="span12">
                <h3 class="page-title">
                    <?php echo $title; ?>

                </h3>
                <ul class="breadcrumb">

                    <li>
                        <a href="<?php echo site_url(); ?>admin"><i class="icon-home"></i>Home</a><i class="icon-angle-right"></i>
                    </li>

                    <?php if (isset($heading1)) {
                        ?>
                        <li>
                            <a href="<?php echo site_url(); ?>admin/<?php echo $heading1_url; ?>"><?php echo $heading1; ?></a><i class="icon-angle-right"></i>
                        </li>
                    <?php } ?>

                    <li><?php echo $heading2; ?><span class="divider-last">&nbsp;</span></li>

                </ul>
            </div>
        </div>
        <!-- END PAGE HEADER-->

