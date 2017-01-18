var FormValidation = function () {

    var handleValidation1 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var form1 = $('#form_sample_1');
        var error1 = $('.alert-error', form1);
        var success1 = $('.alert-success', form1);

        form1.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                name: {
                    minlength: 2,
                    required: true
                },
                username: {
                    minlength: 4,
                    required: true
                },
                email: {
                    required: true,
                    email: true
                },
                url: {
                    required: true,
                    url: true
                },
                number: {
                    required: true,
                    number: true
                },
                digits: {
                    required: true,
                    digits: true
                },
                creditcard: {
                    required: true,
                    creditcard: true
                },
                occupation: {
                    minlength: 5,
                },
                category: {
                    required: true
                }
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                success1.show();
                error1.hide();
            }
        });
    }

    var handleValidation2 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation


        var form2 = $('#adduserform');
        var error2 = $('.alert-error', form2);
        var success2 = $('.alert-success', form2);

        // var pass1 = document.getElementById("password").value;
        //var pass2 = document.getElementById("confirmpassword").value;
			

        //IMPORTANT: update CKEDITOR textarea with actual content before submit
        form2.on('submit', function() {
            for(var instanceName in CKEDITOR.instances) {
                CKEDITOR.instances[instanceName].updateElement();
            }
        })

        form2.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                client: {
                    required: true
                },
 
                codetype: {
                    required: true
                }, 

                store_list: {
                    required: true
                },

                email: {
                    required: true,
                    email: true
                },
                firstname: {
                    required: true
                },
                lastname: {
                    required: true
                },
                zipcode: {
                    required: true
                },

                //                coupon_code: {
                //                    required: true
                //                },
                coupon_name: {
                    required: true
                },
                //                barcode_type: {
                //                    required: true
                //                },

                promotext_short: {
                    required: true
                },  
                  
                //                barcode_text: {
                //                    required: true
                //                },
                coupon_description: {
                    required: true
                },
                terms_conditions: {
                    required: true
                },

                //                whats_hot: {
                //                    required: true
                //						
                //                },  
                //
                //                national_coupon: {
                //                    required: true
                //						
                //                }, 
                category : {
                    required: true						
                },  
                no_of_downloads: {
                    required: true,
                    digits: true
                },
					
                reward_points: {
                    required: true,
                    digits: true
                },
                sub_category: {
                    required: true
                },
                coupon_date: {
                    required: true
                },	

                legal_url: {
                    required: true,
                    url : true
                },
                keywords: {
                    required: true
                },
                options2: {
                    required: true
                },	
                options2: {
                    required: true
                },	
                    
                addressline1: {
                    required: true
						
                }, 	 
                  	
                addressline2: {
                    required: true
						
                }, 

                legalurl: {
                    required: true,
                    url:true
						
                }, 

                keywords: {
                    required: true,
						
                },  


                password: {
                    required: true,
                    minlength:6
						
                },  

                confirmpassword: {
                    required: true,
                    equalTo: '#password'
						
                }, 
						
                corporateaddress: {
                    required: true,
						
                },  

                corporateaddress2: {
                    required: true,
						
                }, 

                billingaddress: {
                    required: true,
						
                }, 

                zip: {
                    required: true,
                    digits: true
						
                },
						
                categories: {
                    required: true,
						
                },  

                subcategories: {
                    required: true,
						
                },  

                contactname: {
                    required: true,
						
                }, 

						

                storeurl: {
                    required: true,
                    url:true
                }, 	
                   

                storename: {
                    required: true,
							
                }, 
						 
                storenumber: {
                    required: true,
                    digits: true
						
                }, 

                description: {
                    required: true,
					
						
                },
                   
                thumbnailimage: {
                    required: true,
					
						
                },

                companyimage: {
                    required: true,
					
						
                },

                storeimage: {
                    required: true,
					
						
                },

                checkinpoints: {
                    required: true,
                    digits: true
                },

                address: {
                    required: true,
                },

                campaignname: {
                    required: true,
                },
                noofdownloads: {
                    required: true,
                    digits:true
                },
                quantity: {
                    required: true,
                    digits:true
                },
					
                rewardpoints_on_redemption: {
                    required: true,
                    digits:true
                },
            },

            messages: { // custom messages for radio buttons and checkboxes
                membership: {
                    required: "Please select a Membership type"
                },
                service: {
                    required: "Please select  at least 2 types of Service",
                    minlength: jQuery.format("Please select  at least {0} types of Service")
                }
            },

            errorPlacement: function (error, element) { // render error placement for each input type
                if (element.attr("name") == "education") { // for chosen elements, need to insert the error after the chosen container
                    error.insertAfter("#form_2_education_chzn");
                } else if (element.attr("name") == "membership") { // for uniform radio buttons, insert the after the given container
                    error.addClass("no-left-padding").insertAfter("#form_2_membership_error");
                } else if (element.attr("name") == "editor1" || element.attr("name") == "editor2") { // for wysiwyg editors
                    error.insertAfter($(element.attr('data-error-container'))); 
                } else if (element.attr("name") == "service") { // for uniform checkboxes, insert the after the given container
                    error.addClass("no-left-padding").insertAfter("#form_2_service_error");
                } else {
                    error.insertAfter(element); // for other inputs, just perform default behavior
                }
            },

            invalidHandler: function (event, validator) { //display error alert on form submit   
                success2.hide();
                error2.show();
                App.scrollTo(error2, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                if (label.attr("for") == "service" || label.attr("for") == "membership") { // for checkboxes and radio buttons, no need to show OK icon
                    label
                    .closest('.control-group').removeClass('error').addClass('success');
                    label.remove(); // remove error label here
                } else { // display success icon for other inputs
                    label
                    .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                    .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
                }
            },

            submitHandler: function (form) {
					
                document.adduserform.submit();
                error2.hide();
            }

        });

        $('#form_2_select2').select2({
            placeholder: "Select an Option",
            allowClear: true
        });

        //apply validation on wysiwyg editors change, this only needed for chosen dropdown integration.
        $('.wysihtml5, .ckeditor', form2).change(function () {
            alert(1);
            form2.validate().element($(this)); //revalidate the wysiwyg editors and show error or success message for the input
        });

        //apply validation on chosen dropdown value change, this only needed for chosen dropdown integration.
        $('.chosen, .chosen-with-diselect', form2).change(function () {
            form2.validate().element($(this)); //revalidate the chosen dropdown value and show error or success message for the input
        });

        //apply validation on select2 dropdown value change, this only needed for chosen dropdown integration.
        $('.select2', form2).change(function () {
            form2.validate().element($(this)); //revalidate the chosen dropdown value and show error or success message for the input
        });
    }
    
    var handleValidation3 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var customer = $('#add_customer_form');
        var error1 = $('.alert-error', customer);
        var success1 = $('.alert-success', customer);

        customer.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                client_name: {
                    required: true
                },
                admin_username: {
                    minlength: 4,
                    required: true
                },
                email: {
                    required: true,
                    email: true
                },
                legal_url: {
                    required: true,
                    url: true
                },
                password: {
                    minlength: 6,
                    required: true
                },
                confirm_password: {
                    required: true,
                    equalTo: '#password'
                },
                address1: {
                    required: true
                },
                description: {
                    required: true
                },
                clienttype: {
                    required: true
                },
                customer_type: {
                    required: true
                },
                country: {
                    required: true
                },
                state: {
                    required: true
                },
                full_name: {
                    required: true
                },
                city: {
                    required: true
                },
                zip: {
                    required: true,
                    number: true
                },
                contact_no: {
                    required: true,
                    number: true
                },
                category: {
                    required: true
                },
                sub_category: {
                    required: true
                }
                
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                document.add_customer_form.submit();
                error1.hide();
            }
        });
    }
    
    var handleValidation4 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var store = $('#add_store_form');
        var error1 = $('.alert-error', store);
        var success1 = $('.alert-success', store);

        store.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                client: {
                    required: true
                },
                store_name: {
                    required: true
                },
                store_number: {
                    required: true
                },
                country: {
                    required: true
                },
                state: {
                    required: true
                },
                city: {
                    required: true
                },
                zip: {
                    required: true,
                    number: true
                },
                description: {
                    required: true
                },
                category: {
                    required: true,
                    minlength: 1
                },
                sub_category: {
                    required: true
                },
                address: {
                    required: true
                },
                lattitude: {
                    required: true
                },
                longitude: {
                    required: true
                },
                time_zone: {
                    required: true
                },
                checkin_points:{
                    required: true,
                    number: true
                }
                
            },
            messages: { // custom messages for radio buttons and checkboxes
                
                category: {
                    required: "Please select  at least 1 types of Categories",
                    minlength: jQuery.format("Please select  at least {0} types of Categories")
                }
            },
            errorPlacement: function (error, element) { // render error placement for each input type
                if (element.attr("name") == "category") { // for uniform checkboxes, insert the after the given container
                    error.addClass("no-left-padding").insertAfter("#form_2_service_error");
                } else {
                    error.insertAfter(element); // for other inputs, just perform default behavior
                }
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                if (label.attr("for") == "category") { // for checkboxes and radio buttons, no need to show OK icon
                    label
                    .closest('.control-group').removeClass('error').addClass('success');
                    label.remove(); // remove error label here
                } else { // display success icon for other inputs
                    label
                    .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                    .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
                }
            },

            submitHandler: function (form) {
                var cat_id  = new Array();
                var i=0;
                $(".category").each(function() {
                    //alert("sdfs");
                    if ($(this).is(':checked')) {
                        cat_id[i] = $(this).val();
                        //alert(cat_id);
                        i++;
                    }
                }); //alert(cat_id);
                if(cat_id == ""){
                    $("span.err").text("Please select any one Category");
                    $(".category").focus();
                    return false;
                } else if(cat_id != ""){
                    var cat_id  = new Array();
                    var i=0;
                    $(".subcategory").each(function() {
                        //alert("sdfs");
                        if ($(this).is(':checked')) {
                            cat_id[i] = $(this).val();
                            //alert(cat_id);
                            i++;
                        }
                    }); //alert(cat_id);
                    if(cat_id == ""){
                        $("span.suberr").text("Please select any one Sub Category");
                        $(".subcategory").focus();
                        return false;
                    } 
                }   
                
                document.add_store_form.submit();
                
                error1.hide();
                 
            }
        });
    }
    
    
    var handleValidation5 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var advertisement = $('#add_advertisement_form');
        var error1 = $('.alert-error', advertisement);
        var success1 = $('.alert-success', advertisement);

        advertisement.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                customer: {
                    required: true
                },
                type: {
                    required: true
                },
                advertisement_date: {
                    required: true
                },
                start_time: {
                    required: true
                },
                end_time: {
                    required: true
                },
                reward_points: {
                    required: true,
                    number: true
                }
                
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                document.add_advertisement_form.submit();
                error1.hide();
            }
        });
    }


    var handleValidation6 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var display_coupons = $('#display_coupons');
        var error1 = $('.alert-error', display_coupons);
        var success1 = $('.alert-success', display_coupons);
        
        display_coupons.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'err', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                coupon_id : {
                    required: true
                }
                
            },
            messages: { // custom messages for radio buttons and checkboxes
                coupon_id : {
                    required: "Please select Atleast One Coupon"
                }
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.err').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                document.display_coupons.submit();
                error1.hide();
            }
        });
    }
    
    var handleValidation7 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var change_password = $('#change_password');
        var error1 = $('.alert-error', change_password);
        var success1 = $('.alert-success', change_password);
        
        change_password.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                old_pwd : {
                    required: true
                },
                new_pwd : {
                    minlength: 6,
                    required: true
                },
                confirm_new_pwd : {
                    required: true,
                    equalTo: '#new_pwd'
                }
                
            },
            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.err').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                document.display_coupons.submit();
                error1.hide();
            }
        });
    }
    var handleValidation8 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var addstaffform = $('#addstaffform');
        var error1 = $('.alert-error', addstaffform);
        var success1 = $('.alert-success', addstaffform);
        
        addstaffform.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                firstname : {
                    required: true
                },
                lastname : {
                    required: true
                },
                username : {
                    required: true
                },
                password : {
                    minlength: 6,
                    required: true
                    
                },
                confirmpassword : {
                    required: true,
                    equalTo: '#pwd'
                },
                email : {
                    required: true,
                    email: true
                },
                contactno : {
                    required: true
                }
                
            },
          
            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
               
                document.addstaffform.submit();
                error1.hide();
            }
        });
    }
    var handleValidation9 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var customer = $('#update_customer_form');
        var error1 = $('.alert-error', customer);
        var success1 = $('.alert-success', customer);

        customer.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                client_name: {
                    required: true
                },
                admin_username: {
                    minlength: 4,
                    required: true
                },
                email: {
                    required: true,
                    email: true
                },
                legal_url: {
                    required: true,
                    url: true
                },
                password: {
                    minlength: 6,
                    required: true
                },
                confirm_password: {
                    required: true,
                    equalTo: '#password'
                },
                address1: {
                    required: true
                },
                description: {
                    required: true
                },
                clienttype: {
                    required: true
                },
                customer_type: {
                    required: true
                },
                country: {
                    required: true
                },
                state: {
                    required: true
                },
                full_name: {
                    required: true
                },
                city: {
                    required: true
                },
                zip: {
                    required: true,
                    number: true
                },
                contact_no: {
                    required: true,
                    number: true
                },
                category: {
                    required: true
                },
                sub_category: {
                    required: true
                }
                
            },

            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
                var cat_id  = new Array();
                var i=0;
                $(".category").each(function() {
                    //alert("sdfs");
                    if ($(this).is(':checked')) {
                        cat_id[i] = $(this).val();
                        //alert(cat_id);
                        i++;
                    }
                }); //alert(cat_id);
                if(cat_id == ""){
                    $("span.err").text("Please select any one Category");
                    $(".category").focus();
                    return false;
                } else if(cat_id != ""){
                    var cat_id  = new Array();
                    var i=0;
                    $(".subcategory").each(function() {
                        //alert("sdfs");
                        if ($(this).is(':checked')) {
                            cat_id[i] = $(this).val();
                            //alert(cat_id);
                            i++;
                        }
                    }); //alert(cat_id);
                    if(cat_id == ""){
                        $("span.suberr").text("Please select any one Sub Category");
                        $(".subcategory").focus();
                        return false;
                    } 
                }
                document.add_customer_form.submit();
                error1.hide();
            }
        });
    }
    var handleValidation10 = function() {
        // for more info visit the official plugin documentation: 
        // http://docs.jquery.com/Plugins/Validation

        var addnotificationform = $('#addnotificationform');
        var error1 = $('.alert-error', addnotificationform);
        var success1 = $('.alert-success', addnotificationform);
        
        addnotificationform.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-inline', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "",
            rules: {
                customer : {
                    required: true
                },
                notification_name : {
                    required: true
                },
                notificationtext : {
                    required: true
                },
                notifyon : {
                    required: true
                    
                },
                launch_date : {
                    required: true
                },
                username : {
                    required: true
                }
                
            },
          
            invalidHandler: function (event, validator) { //display error alert on form submit              
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            highlight: function (element) { // hightlight error inputs
                $(element)
                .closest('.help-inline').removeClass('ok'); // display OK icon
                $(element)
                .closest('.control-group').removeClass('success').addClass('error'); // set error class to the control group
            },

            unhighlight: function (element) { // revert the change done by hightlight
                $(element)
                .closest('.control-group').removeClass('error'); // set error class to the control group
            },

            success: function (label) {
                label
                .addClass('valid').addClass('help-inline ok') // mark the current input as valid and display OK icon
                .closest('.control-group').removeClass('error').addClass('success'); // set success class to the control group
            },

            submitHandler: function (form) {
               
                document.addnotificationform.submit();
                error1.hide();
            }
        });
    }
    var handleWysihtml5 = function() {
        if (!jQuery().wysihtml5) {
            
            return;
        }

        if ($('.wysihtml5').size() > 0) {
            $('.wysihtml5').wysihtml5({
                "stylesheets": ["assets/plugins/bootstrap-wysihtml5/wysiwyg-color.css"]
            });
        }
    }

    return {
        //main function to initiate the module
        init: function () {
            handleWysihtml5();
            handleValidation1();
            handleValidation2();
            handleValidation3();
            handleValidation4();
            handleValidation5();
            handleValidation6();
            handleValidation7();
            handleValidation8();
            handleValidation9();
        }

    };

}();