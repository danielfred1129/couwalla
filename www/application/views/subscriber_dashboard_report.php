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

  

	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-datepicker/css/datepicker.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/select2/select2_metro.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/chosen-bootstrap/chosen/chosen.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo base_url(); ?>assets/plugins/bootstrap-wysihtml5/bootstrap-wysihtml5.css" />
	<!-- END PAGE LEVEL STYLES -->
	<link rel="shortcut icon" href="favicon.ico" />
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<body class="page-header-fixed">
	
	<!-- BEGIN CONTAINER -->
	
		
		<!-- BEGIN PAGE -->  
		<div class="page-content">
			<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<div id="portlet-config" class="modal hide">
				<div class="modal-header">
					<button data-dismiss="modal" class="close" type="button"></button>
					<h3>portlet Settings</h3>
				</div>
				<div class="modal-body">
					<p>Here will be a configuration form</p>
				</div>
			</div>
			<!-- END SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<!-- BEGIN PAGE CONTAINER-->
			<div class="container-fluid">
		
				<!-- BEGIN PAGE CONTENT-->
				       <div class="row-fluid">
					    <!-- BEGIN VALIDATION STATES-->
						<div class="portlet box green">
							<div class="portlet-title">
								<div class="caption">Subscriber Dashboard Report</div>
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
				<form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/add_new_user" method="post">
								<!--<form  class="form-horizontal"  id="form_sample_2" action="#" method="post">-->
								
									<div class="alert alert-error hide">
										<button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
									</div>
									
									<div class="alert alert-success hide">
										<button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
									</div>
										<div class="control-group">
												<label class="control-label">Country</label>
												<div class="controls">
													<select name=""  name="country" class="span6 select2">
														<option value="AF">Afghanistan</option>
														<option value="AL">Albania</option>
														<option value="DZ">Algeria</option>
														<option value="AS">American Samoa</option>
														<option value="AD">Andorra</option>
														<option value="AO">Angola</option>
														<option value="AI">Anguilla</option>
														<option value="AQ">Antarctica</option>
														<option value="AR">Argentina</option>
														<option value="AM">Armenia</option>
														<option value="AW">Aruba</option>
														<option value="AU">Australia</option>
														<option value="AT">Austria</option>
														<option value="AZ">Azerbaijan</option>
														<option value="BS">Bahamas</option>
														<option value="BH">Bahrain</option>
														<option value="BD">Bangladesh</option>
														<option value="BB">Barbados</option>
														<option value="BY">Belarus</option>
														<option value="BE">Belgium</option>
														<option value="BZ">Belize</option>
														<option value="BJ">Benin</option>
														<option value="BM">Bermuda</option>
														<option value="BT">Bhutan</option>
														<option value="BO">Bolivia</option>
														<option value="BA">Bosnia and Herzegowina</option>
														<option value="BW">Botswana</option>
														<option value="BV">Bouvet Island</option>
														<option value="BR">Brazil</option>
														<option value="IO">British Indian Ocean Territory</option>
														<option value="BN">Brunei Darussalam</option>
														<option value="BG">Bulgaria</option>
														<option value="BF">Burkina Faso</option>
														<option value="BI">Burundi</option>
														<option value="KH">Cambodia</option>
														<option value="CM">Cameroon</option>
														<option value="CA">Canada</option>
														<option value="CV">Cape Verde</option>
														<option value="KY">Cayman Islands</option>
														<option value="CF">Central African Republic</option>
														<option value="TD">Chad</option>
														<option value="CL">Chile</option>
														<option value="CN">China</option>
														<option value="CX">Christmas Island</option>
														<option value="CC">Cocos (Keeling) Islands</option>
														<option value="CO">Colombia</option>
														<option value="KM">Comoros</option>
														<option value="CG">Congo</option>
														<option value="CD">Congo, the Democratic Republic of the</option>
														<option value="CK">Cook Islands</option>
														<option value="CR">Costa Rica</option>
														<option value="CI">Cote d'Ivoire</option>
														<option value="HR">Croatia (Hrvatska)</option>
														<option value="CU">Cuba</option>
														<option value="CY">Cyprus</option>
														<option value="CZ">Czech Republic</option>
														<option value="DK">Denmark</option>
														<option value="DJ">Djibouti</option>
														<option value="DM">Dominica</option>
														<option value="DO">Dominican Republic</option>
														<option value="EC">Ecuador</option>
														<option value="EG">Egypt</option>
														<option value="SV">El Salvador</option>
														<option value="GQ">Equatorial Guinea</option>
														<option value="ER">Eritrea</option>
														<option value="EE">Estonia</option>
														<option value="ET">Ethiopia</option>
														<option value="FK">Falkland Islands (Malvinas)</option>
														<option value="FO">Faroe Islands</option>
														<option value="FJ">Fiji</option>
														<option value="FI">Finland</option>
														<option value="FR">France</option>
														<option value="GF">French Guiana</option>
														<option value="PF">French Polynesia</option>
														<option value="TF">French Southern Territories</option>
														<option value="GA">Gabon</option>
														<option value="GM">Gambia</option>
														<option value="GE">Georgia</option>
														<option value="DE">Germany</option>
														<option value="GH">Ghana</option>
														<option value="GI">Gibraltar</option>
														<option value="GR">Greece</option>
														<option value="GL">Greenland</option>
														<option value="GD">Grenada</option>
														<option value="GP">Guadeloupe</option>
														<option value="GU">Guam</option>
														<option value="GT">Guatemala</option>
														<option value="GN">Guinea</option>
														<option value="GW">Guinea-Bissau</option>
														<option value="GY">Guyana</option>
														<option value="HT">Haiti</option>
														<option value="HM">Heard and Mc Donald Islands</option>
														<option value="VA">Holy See (Vatican City State)</option>
														<option value="HN">Honduras</option>
														<option value="HK">Hong Kong</option>
														<option value="HU">Hungary</option>
														<option value="IS">Iceland</option>
														<option value="IN">India</option>
														<option value="ID">Indonesia</option>
														<option value="IR">Iran (Islamic Republic of)</option>
														<option value="IQ">Iraq</option>
														<option value="IE">Ireland</option>
														<option value="IL">Israel</option>
														<option value="IT">Italy</option>
														<option value="JM">Jamaica</option>
														<option value="JP">Japan</option>
														<option value="JO">Jordan</option>
														<option value="KZ">Kazakhstan</option>
														<option value="KE">Kenya</option>
														<option value="KI">Kiribati</option>
														<option value="KP">Korea, Democratic People's Republic of</option>
														<option value="KR">Korea, Republic of</option>
														<option value="KW">Kuwait</option>
														<option value="KG">Kyrgyzstan</option>
														<option value="LA">Lao People's Democratic Republic</option>
														<option value="LV">Latvia</option>
														<option value="LB">Lebanon</option>
														<option value="LS">Lesotho</option>
														<option value="LR">Liberia</option>
														<option value="LY">Libyan Arab Jamahiriya</option>
														<option value="LI">Liechtenstein</option>
														<option value="LT">Lithuania</option>
														<option value="LU">Luxembourg</option>
														<option value="MO">Macau</option>
														<option value="MK">Macedonia, The Former Yugoslav Republic of</option>
														<option value="MG">Madagascar</option>
														<option value="MW">Malawi</option>
														<option value="MY">Malaysia</option>
														<option value="MV">Maldives</option>
														<option value="ML">Mali</option>
														<option value="MT">Malta</option>
														<option value="MH">Marshall Islands</option>
														<option value="MQ">Martinique</option>
														<option value="MR">Mauritania</option>
														<option value="MU">Mauritius</option>
														<option value="YT">Mayotte</option>
														<option value="MX">Mexico</option>
														<option value="FM">Micronesia, Federated States of</option>
														<option value="MD">Moldova, Republic of</option>
														<option value="MC">Monaco</option>
														<option value="MN">Mongolia</option>
														<option value="MS">Montserrat</option>
														<option value="MA">Morocco</option>
														<option value="MZ">Mozambique</option>
														<option value="MM">Myanmar</option>
														<option value="NA">Namibia</option>
														<option value="NR">Nauru</option>
														<option value="NP">Nepal</option>
														<option value="NL">Netherlands</option>
														<option value="AN">Netherlands Antilles</option>
														<option value="NC">New Caledonia</option>
														<option value="NZ">New Zealand</option>
														<option value="NI">Nicaragua</option>
														<option value="NE">Niger</option>
														<option value="NG">Nigeria</option>
														<option value="NU">Niue</option>
														<option value="NF">Norfolk Island</option>
														<option value="MP">Northern Mariana Islands</option>
														<option value="NO">Norway</option>
														<option value="OM">Oman</option>
														<option value="PK">Pakistan</option>
														<option value="PW">Palau</option>
														<option value="PA">Panama</option>
														<option value="PG">Papua New Guinea</option>
														<option value="PY">Paraguay</option>
														<option value="PE">Peru</option>
														<option value="PH">Philippines</option>
														<option value="PN">Pitcairn</option>
														<option value="PL">Poland</option>
														<option value="PT">Portugal</option>
														<option value="PR">Puerto Rico</option>
														<option value="QA">Qatar</option>
														<option value="RE">Reunion</option>
														<option value="RO">Romania</option>
														<option value="RU">Russian Federation</option>
														<option value="RW">Rwanda</option>
														<option value="KN">Saint Kitts and Nevis</option>
														<option value="LC">Saint LUCIA</option>
														<option value="VC">Saint Vincent and the Grenadines</option>
														<option value="WS">Samoa</option>
														<option value="SM">San Marino</option>
														<option value="ST">Sao Tome and Principe</option>
														<option value="SA">Saudi Arabia</option>
														<option value="SN">Senegal</option>
														<option value="SC">Seychelles</option>
														<option value="SL">Sierra Leone</option>
														<option value="SG">Singapore</option>
														<option value="SK">Slovakia (Slovak Republic)</option>
														<option value="SI">Slovenia</option>
														<option value="SB">Solomon Islands</option>
														<option value="SO">Somalia</option>
														<option value="ZA">South Africa</option>
														<option value="GS">South Georgia and the South Sandwich Islands</option>
														<option value="ES">Spain</option>
														<option value="LK">Sri Lanka</option>
														<option value="SH">St. Helena</option>
														<option value="PM">St. Pierre and Miquelon</option>
														<option value="SD">Sudan</option>
														<option value="SR">Suriname</option>
														<option value="SJ">Svalbard and Jan Mayen Islands</option>
														<option value="SZ">Swaziland</option>
														<option value="SE">Sweden</option>
														<option value="CH">Switzerland</option>
														<option value="SY">Syrian Arab Republic</option>
														<option value="TW">Taiwan, Province of China</option>
														<option value="TJ">Tajikistan</option>
														<option value="TZ">Tanzania, United Republic of</option>
														<option value="TH">Thailand</option>
														<option value="TG">Togo</option>
														<option value="TK">Tokelau</option>
														<option value="TO">Tonga</option>
														<option value="TT">Trinidad and Tobago</option>
														<option value="TN">Tunisia</option>
														<option value="TR">Turkey</option>
														<option value="TM">Turkmenistan</option>
														<option value="TC">Turks and Caicos Islands</option>
														<option value="TV">Tuvalu</option>
														<option value="UG">Uganda</option>
														<option value="UA">Ukraine</option>
														<option value="AE">United Arab Emirates</option>
														<option value="GB">United Kingdom</option>
														<option value="US">United States</option>
														<option value="UM">United States Minor Outlying Islands</option>
														<option value="UY">Uruguay</option>
														<option value="UZ">Uzbekistan</option>
														<option value="VU">Vanuatu</option>
														<option value="VE">Venezuela</option>
														<option value="VN">Viet Nam</option>
														<option value="VG">Virgin Islands (British)</option>
														<option value="VI">Virgin Islands (U.S.)</option>
														<option value="WF">Wallis and Futuna Islands</option>
														<option value="EH">Western Sahara</option>
														<option value="YE">Yemen</option>
														<option value="ZM">Zambia</option>
														<option value="ZW">Zimbabwe</option>
													</select>
												</div>
											</div>


									<div class="control-group">
										<label class="control-label">Starts Date</label>
										<div class="controls">
							<div class="input-append date date-picker" data-date="12-02-2012" data-date-format="dd-mm-yyyy" data-date-viewmode="years">
												<input class="m-wrap m-ctrl-medium date-picker" readonly size="16" type="text" value="" /><span class="add-on"><i class="icon-calendar"></i></span>
											</div>
										</div>
									</div>

										<div class="control-group">
										<label class="control-label">End Date</label>
										<div class="controls">
											<div class="input-append date date-picker" data-date="12-02-2012" data-date-format="dd-mm-yyyy" data-date-viewmode="years">
												<input class="m-wrap m-ctrl-medium date-picker" readonly size="16" type="text" value="" /><span class="add-on"><i class="icon-calendar"></i></span>
											</div>
										</div>
									</div>

								
									<div class="form-actions">
										<button type="submit" class="btn green">Generate</button>
									<!--<button type="button" class="btn">Cancel</button>-->
									</div>
								</form>
								<!-- END FORM-->
							</div>
						</div>
						<!-- END VALIDATION STATES-->

				</div>
				<!-- END PAGE CONTENT-->         
			</div>
			<!-- END PAGE CONTAINER-->
		</div>
		<!-- END PAGE -->  

	<!-- END CONTAINER -->
	
	<!-- BEGIN JAVASCRIPTS(Load javascripts at bottom, this will reduce page load time) -->
    <script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/clockface/js/clockface.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-daterangepicker/date.js"></script>
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script> 
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>  
	<script type="text/javascript" src="<?php echo base_url(); ?>assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>

	
	<!-- BEGIN PAGE LEVEL STYLES -->
	<script src="<?php echo base_url(); ?>assets/scripts/form-validation.js"></script>
	<script src="<?php echo base_url(); ?>assets/scripts/form-components.js"></script>  
	<!-- END PAGE LEVEL STYLES --> 
	
	
	<!-- END JAVASCRIPTS -->   
</body>
<!-- END BODY -->
</html>