<div class="page-sidebar nav-collapse collapse">
    <!-- BEGIN SIDEBAR MENU -->        
    <ul class="page-sidebar-menu">
        <li>
            <!-- BEGIN SIDEBAR TOGGLER BUTTON -->
            <div class="sidebar-toggler hidden-phone"></div>
            <!-- BEGIN SIDEBAR TOGGLER BUTTON -->
        </li>
        <li>
            <!-- BEGIN RESPONSIVE QUICK SEARCH FORM -->
            <!--<form class="sidebar-search">
                    <div class="input-box">
                            <a href="javascript:;" class="remove"></a>
                            <input type="text" placeholder="Search..." />
                            <input type="button" class="submit" value="" />
                    </div>
            </form>-->
            <!-- END RESPONSIVE QUICK SEARCH FORM -->
        </li>

        <!--<li class="start active">-->
        <?php if ($this->uri->segment(1) == "admin" && $this->uri->segment(2) == "") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin'); ?>">
                <i class="icon-home"></i> 
                <span class="title">Dashboard</span>
                <span class="selected"></span>
            </a>
        </li>

        <?php //echo $test ; ?>
        <!--code by Mayank - Start -->
        <li>
        <?php if ($this->uri->segment(2) == "subscriber_dashboard" || $this->uri->segment(2) == "get_subscriber_report" || $this->uri->segment(2) == "get_coupon_summary" || $this->uri->segment(2) == "coupon_detailed_report") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="javascript:;">
                <i class="icon-bar-chart"></i> 
                <span class="title">Report</span>
                <span class="arrow "></span>
            </a>
            <ul class="sub-menu">
                <li>
                        <!--<a href="<?php echo base_url(); ?>layout_blank_page.html">-->
                    <a href="<?php echo site_url('admin/subscriber_dashboard'); ?>">
                        Subscriber Dashboard
                        <span class="arrow"></span>
                    </a>

                </li>
                <li>
                    <a href="<?php echo site_url('admin/get_subscriber_report'); ?>">
                        Subscriber Report
                        <span class="arrow"></span>
                    </a>

                </li>
                <li>
                    <a href="<?php echo site_url('admin/get_coupon_summary'); ?>">
                        Coupon Summary Report
                        <span class="arrow"></span>
                    </a>

                </li>
                <li>
                    <a href="<?php echo site_url('admin/coupon_detailed_report'); ?>">
                        Coupon Detailed Report
                        <span class="arrow"></span>
                    </a>

                </li>

            </ul>
        </li>




        <!--<li>-->
        <?php if ($this->uri->segment(2) == "add_coupons" || $this->uri->segment(2) == "delete_coupons" || $this->uri->segment(2) == "add_new_coupon") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/add_coupons'); ?>">
                <i class="icon-barcode"></i> 
                <span class="title">Coupons</span>
                <span class="arrow "></span>
            </a>
        </li>


        <!--<li>-->
        <?php if ($this->uri->segment(2) == "display_customers" || $this->uri->segment(2) == "delete_customer" || $this->uri->segment(2) == "add_customer") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>

            <a href="<?php echo site_url('admin/display_customers'); ?>">
                <i class="icon-group"></i> 
                <span class="title">Clients</span>
                <span class="arrow "></span>
            </a>
        </li>

        <!--<li>-->
        <?php if ($this->uri->segment(2) == "display_users" || $this->uri->segment(2) == "delete_user" || $this->uri->segment(2) == "add_user") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_users'); ?>">
                <i class="icon-group"></i> 
                <span class="title">Users</span>
                <span class="arrow "></span>
            </a>
        </li>

        <!--<li>-->
        <?php if ($this->uri->segment(2) == "display_stores" || $this->uri->segment(2) == "delete_stores" || $this->uri->segment(2) == "add_store") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_stores'); ?>">
                <i class="icon-building"></i> 
                <span class="title">Stores</span>
                <span class="arrow "></span>
            </a>
        </li>

        <!--<li>
                <a href="<?php echo site_url('admin/add_campaigns'); ?>">
                <i class="icon-folder-open"></i> 
                <span class="title">Campaigns</span>
                <span class="arrow "></span>
                </a>
        </li>-->

        <li>
        <?php if ($this->uri->segment(2) == "display_adverts" || $this->uri->segment(2) == "delete_advertisement" || $this->uri->segment(2) == "add_advertisement") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_adverts'); ?>">
                <i class=" icon-film"></i> 
                <span class="title">Advertisenments (Add Banner) </span>
                <span class="arrow "></span>
            </a>
        </li>

        <!--<li>-->
        <?php if ($this->uri->segment(2) == "display_giftcards" || $this->uri->segment(2) == "delete_giftcard" || $this->uri->segment(2) == "add_giftcard") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_giftcards'); ?>">
                <i class="icon-credit-card"></i> 
                <span class="title">Gift Cards</span>
                <span class="arrow "></span>
            </a>
        </li>
        <?php if ($this->uri->segment(2) == "display_staff" || $this->uri->segment(2) == "delete_staff" || $this->uri->segment(2) == "add_staff") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_staff'); ?>">
                <i class="icon-user"></i> 
                <span class="title">Manage Staff</span>
                <span class="arrow "></span>
            </a>
        </li>

        <!--<li>-->
        <?php if ($this->uri->segment(2) == "display_notifications" || $this->uri->segment(2) == "delete_notification" || $this->uri->segment(2) == "add_notification") { ?> <li class="start active"> <?php } else { ?><li class=""><?php } ?>
            <a href="<?php echo site_url('admin/display_notifications'); ?>">
                <i class="icon-bullhorn"></i> 
                <span class="title">Notifications</span>
                <span class="arrow "></span>
            </a>  
        </li>

        <?php //if ($this->uri->segment(2) == "display_surveys" || $this->uri->segment(2) == "add_surveys" || $this->uri->segment(2) == "delete_surveys") { ?>  <li class="start active" > <?php //} else { ?>
<!--        <li class=""><?php //} ?>
            <a href="<?php echo site_url('admin/display_surveys'); ?>">
                <i class="icon-bullhorn"></i> 
                <span class="title">Surveys</span>
                <span class="arrow "></span>
            </a>  
        </li>-->
        
<!--        <li>
    <a href="<?php echo site_url('admin/display_surveys'); ?>">
        <i class="icon-folder-open"></i> 
        <span class="title">Surveys</span>
        <span class="arrow "></span>
        </a>  
    </li>-->
        <!--code by Mayank - End -->
        <!--	<li >
                        <a href="javascript:;">
                        <i class="icon-cogs"></i> 
                        <span class="title">Layouts</span>
                        <span class="arrow "></span>
                        </a>
                        <ul class="sub-menu">
                                <li >
                                        <a href="layout_language_bar.html">
                                        <span class="badge badge-roundless badge-important">new</span>Language Switch Bar</a>
                                </li>
                                <li >
                                        <a href="layout_horizontal_sidebar_menu.html">
                                        Horizontal & Sidebar Menu</a>
                                </li>
                                <li >
                                        <a href="layout_horizontal_menu1.html">
                                        Horizontal Menu 1</a>
                                </li>
                                <li >
                                        <a href="layout_horizontal_menu2.html">
                                        Horizontal Menu 2</a>
                                </li>
                                <li >
                                        <a href="layout_promo.html">
                                        Promo Page</a>
                                </li>
                                <li >
                                        <a href="layout_email.html">
                                        Email Templates</a>
                                </li>
                                <li >
                                        <a href="layout_ajax.html">
                                        Content Loading via Ajax</a>
                                </li>
                                <li >
                                        <a href="layout_sidebar_closed.html">
                                        Sidebar Closed Page</a>
                                </li>
                                <li >
                                        <a href="layout_blank_page.html">
                                        Blank Page</a>
                                </li>
                                <li >
                                        <a href="layout_boxed_page.html">
                                        Boxed Page</a>
                                </li>
                                <li >
                                        <a href="layout_boxed_not_responsive.html">
                                        Non-Responsive Boxed Layout</a>
                                </li>
                        </ul>
                </li>
        <!-- BEGIN FRONT DEMO -->
        <!--<li class="tooltips" data-placement="right" data-original-title="Frontend&nbsp;Theme&nbsp;For&nbsp;Metronic&nbsp;Admin">
                <a href="http://keenthemes.com/preview/index.php?theme=metronic_frontend" target="_blank">
                <i class="icon-gift"></i> 
                <span class="title">Frontend Theme</span>
                </a>
        </li>
        <!-- END FRONT DEMO -->
        <!--<li >
                <a href="javascript:;">
                <i class="icon-bookmark-empty"></i> 
                <span class="title">UI Features</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="ui_general.html">
                                General</a>
                        </li>
                        <li >
                                <a href="ui_buttons.html">
                                Buttons</a>
                        </li>
                        <li >
                                <a href="ui_modals.html">
                                Enhanced Modals</a>
                        </li>
                        <li >
                                <a href="ui_tabs_accordions.html">
                                Tabs & Accordions</a>
                        </li>
                        <li >
                                <a href="ui_jqueryui.html">
                                jQuery UI Components</a>
                        </li>
                        <li >
                                <a href="ui_sliders.html">
                                Sliders</a>
                        </li>
                        <li >
                                <a href="ui_tiles.html">
                                Tiles</a>
                        </li>
                        <li >
                                <a href="ui_typography.html">
                                Typography</a>
                        </li>
                        <li >
                                <a href="ui_tree.html">
                                Tree View</a>
                        </li>
                        <li >
                                <a href="ui_nestable.html">
                                Nestable List</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-table"></i> 
                <span class="title">Form Stuff</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="form_layout.html">
                                Form Layouts</a>
                        </li>
                        <li >
                                <a href="form_samples.html">
                                Advance Form Samples</a>
                        </li>
                        <li >
                                <a href="form_component.html">
                                Form Components</a>
                        </li>
                        <li >
                                <a href="form_editable.html">
                                <span class="badge badge-roundless badge-warning">new</span>Form X-editable</a>
                        </li>
                        <li >
                                <a href="form_wizard.html">
                                Form Wizard</a>
                        </li>
                        <li >
                                <a href="form_validation.html">
                                Form Validation</a>
                        </li>
                        <li >
                                <a href="form_image_crop.html">
                                <span class="badge badge-roundless badge-important">new</span>Image Cropping</a>
                        </li>
                        <li >
                                <a href="form_fileupload.html">
                                Multiple File Upload</a>
                        </li>
                        <li >
                                <a href="form_dropzone.html">
                                Dropzone File Upload</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-briefcase"></i> 
                <span class="title">Pages</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="page_timeline.html">
                                <i class="icon-time"></i>
                                <span class="badge badge-info">4</span>Timeline</a>
                        </li>
                        <li >
                                <a href="page_coming_soon.html">
                                <i class="icon-cogs"></i>
                                Coming Soon</a>
                        </li>
                        <li >
                                <a href="page_blog.html">
                                <i class="icon-comments"></i>
                                Blog</a>
                        </li>
                        <li >
                                <a href="page_blog_item.html">
                                <i class="icon-font"></i>
                                Blog Post</a>
                        </li>
                        <li >
                                <a href="page_news.html">
                                <i class="icon-coffee"></i>
                                <span class="badge badge-success">9</span>News</a>
                        </li>
                        <li >
                                <a href="page_news_item.html">
                                <i class="icon-bell"></i>
                                News View</a>
                        </li>
                        <li >
                                <a href="page_about.html">
                                <i class="icon-group"></i>
                                About Us</a>
                        </li>
                        <li >
                                <a href="page_contact.html">
                                <i class="icon-envelope-alt"></i>
                                Contact Us</a>
                        </li>
                        <li >
                                <a href="page_calendar.html">
                                <i class="icon-calendar"></i>
                                <span class="badge badge-important">14</span>Calendar</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-gift"></i> 
                <span class="title">Extra</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="extra_profile.html">
                                User Profile</a>
                        </li>
                        <li >
                                <a href="extra_lock.html">
                                Lock Screen</a>
                        </li>
                        <li >
                                <a href="extra_faq.html">
                                FAQ</a>
                        </li>
                        <li >
                                <a href="inbox.html">
                                <span class="badge badge-important">4</span>Inbox</a>
                        </li>
                        <li >
                                <a href="extra_search.html">
                                Search Results</a>
                        </li>
                        <li >
                                <a href="extra_invoice.html">
                                Invoice</a>
                        </li>
                        <li >
                                <a href="extra_pricing_table.html">
                                Pricing Tables</a>
                        </li>
                        <li >
                                <a href="extra_image_manager.html">
                                Image Manager</a>
                        </li>
                        <li >
                                <a href="extra_404_option1.html">
                                404 Page Option 1</a>
                        </li>
                        <li >
                                <a href="extra_404_option2.html">
                                404 Page Option 2</a>
                        </li>
                        <li >
                                <a href="extra_404_option3.html">
                                404 Page Option 3</a>
                        </li>
                        <li >
                                <a href="extra_500_option1.html">
                                500 Page Option 1</a>
                        </li>
                        <li >
                                <a href="extra_500_option2.html">
                                500 Page Option 2</a>
                        </li>
                </ul>
        </li>
        <li>
                <a class="active" href="javascript:;">
                <i class="icon-sitemap"></i> 
                <span class="title">3 Level Menu</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li>
                                <a href="javascript:;">
                                Item 1
                                <span class="arrow"></span>
                                </a>
                                <ul class="sub-menu">
                                        <li><a href="#">Sample Link 1</a></li>
                                        <li><a href="#">Sample Link 2</a></li>
                                        <li><a href="#">Sample Link 3</a></li>
                                </ul>
                        </li>
                        <li>
                                <a href="javascript:;">
                                Item 1
                                <span class="arrow"></span>
                                </a>
                                <ul class="sub-menu">
                                        <li><a href="#">Sample Link 1</a></li>
                                        <li><a href="#">Sample Link 1</a></li>
                                        <li><a href="#">Sample Link 1</a></li>
                                </ul>
                        </li>
                        <li>
                                <a href="#">
                                Item 3
                                </a>
                        </li>
                </ul>
        </li>
        <li>
                <a href="javascript:;">
                <i class="icon-folder-open"></i> 
                <span class="title">4 Level Menu</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li>
                                <a href="javascript:;">
                                <i class="icon-cogs"></i> 
                                Item 1
                                <span class="arrow"></span>
                                </a>
                                <ul class="sub-menu">
                                        <li>
                                                <a href="javascript:;">
                                                <i class="icon-user"></i>
                                                Sample Link 1
                                                <span class="arrow"></span>
                                                </a>
                                                <ul class="sub-menu">
                                                        <li><a href="#"><i class="icon-remove"></i> Sample Link 1</a></li>
                                                        <li><a href="#"><i class="icon-pencil"></i> Sample Link 1</a></li>
                                                        <li><a href="#"><i class="icon-edit"></i> Sample Link 1</a></li>
                                                </ul>
                                        </li>
                                        <li><a href="#"><i class="icon-user"></i>  Sample Link 1</a></li>
                                        <li><a href="#"><i class="icon-external-link"></i>  Sample Link 2</a></li>
                                        <li><a href="#"><i class="icon-bell"></i>  Sample Link 3</a></li>
                                </ul>
                        </li>
                        <li>
                                <a href="javascript:;">
                                <i class="icon-globe"></i> 
                                Item 2
                                <span class="arrow"></span>
                                </a>
                                <ul class="sub-menu">
                                        <li><a href="#"><i class="icon-user"></i>  Sample Link 1</a></li>
                                        <li><a href="#"><i class="icon-external-link"></i>  Sample Link 1</a></li>
                                        <li><a href="#"><i class="icon-bell"></i>  Sample Link 1</a></li>
                                </ul>
                        </li>
                        <li>
                                <a href="#">
                                <i class="icon-folder-open"></i>
                                Item 3
                                </a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-user"></i> 
                <span class="title">Login Options</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="login.html">
                                Login Form 1</a>
                        </li>
                        <li >
                                <a href="login_soft.html">
                                Login Form 2</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-th"></i> 
                <span class="title">Data Tables</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="table_basic.html">
                                Basic Tables</a>
                        </li>
                        <li >
                                <a href="table_responsive.html">
                                Responsive Tables</a>
                        </li>
                        <li >
                                <a href="table_managed.html">
                                Managed Tables</a>
                        </li>
                        <li >
                                <a href="table_editable.html">
                                Editable Tables</a>
                        </li>
                        <li >
                                <a href="table_advanced.html">
                                Advanced Tables</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-file-text"></i> 
                <span class="title">Portlets</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="portlet_general.html">
                                General Portlets</a>
                        </li>
                        <li >
                                <a href="portlet_draggable.html">
                                Draggable Portlets</a>
                        </li>
                </ul>
        </li>
        <li >
                <a href="javascript:;">
                <i class="icon-map-marker"></i> 
                <span class="title">Maps</span>
                <span class="arrow "></span>
                </a>
                <ul class="sub-menu">
                        <li >
                                <a href="maps_google.html">
                                Google Maps</a>
                        </li>
                        <li >
                                <a href="maps_vector.html">
                                Vector Maps</a>
                        </li>
                </ul>
        </li>
        <li class="last ">
                <a href="charts.html">
                <i class="icon-bar-chart"></i> 
                <span class="title">Visual Charts</span>
                </a>
        </li> -->
    </ul>
    <!-- END SIDEBAR MENU -->
</div>
<!-- END SIDEBAR -->