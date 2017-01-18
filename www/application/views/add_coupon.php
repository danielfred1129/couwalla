<div class="row-fluid" >
    <!-- BEGIN VALIDATION STATES-->
    <div class="portlet box green">
        <div class="portlet-title">
            <div class="caption">Add Customer</div>

        </div>
        <div class="portlet-body form">
            <!-- BEGIN FORM-->
            <h3></h3>
            <form  class="form-horizontal" name="adduserform"  id="adduserform" action="<?php echo site_url(); ?>/admin/add_new_customer" method="post" enctype="multipart/form-data">


                <div class="alert alert-error hide">
                    <button class="close" data-dismiss="alert"></button>
										You have some form errors. Please check below.
                </div>

                <div class="alert alert-success hide">
                    <button class="close" data-dismiss="alert"></button>
										Your form validation is successful!
                </div>







                <div class="control-group">
                    <label class="control-label">Company Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="companyname" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Admin User Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="adminusername" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group password-strength">
                    <label class="control-label">Password<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" class="m-wrap" name="password" id="password">

                    </div>
                </div>


                <div class="control-group password-strength">
                    <label class="control-label">Confirm Password<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" class="m-wrap" name="confirmpassword" id="confirmpassword">

                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Full Name<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="fullname" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Is Real Brand<span class="required">*</span></label>
                    <div class="controls">
                        <input type="checkbox" name="isrealbrand " class="checkboxes" value="" />
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">National Brand</label>
                    <div class="controls">
                        <div class="switch switch-large">
                            <input type="checkbox" checked class="toggle" />
                        </div>

                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Manufacturer Coupon<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="manufacturercoupon">
                            <option value="">Select...</option>
                            <option value="yes">Yes</option>
                            <option value="no">No</option>
                        </select>
                    </div>
                </div>



                <div class="control-group">
                        <label class="control-label">Notes<!--<span class="required">*</span>--></label>
                    <div class="controls">
                            <!--<input type="textarea" name="notes" class="span6 m-wrap" value="" />-->
                        <textarea name="notes" class="span6 m-wrap" value=""></textarea>
                    </div>
                </div>



                <div class="control-group">
                    <label class="control-label">Description<span class="required">*</span></label>
                    <div class="controls">
                        <input type="textarea" name="description" class="span6 m-wrap" value="" />
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
                    <label class="control-label">Thumbnail Image<span class="required">*</span></label>
                    <div class="controls">
                        <input type="file" name="thumbnailimage">
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Company Image<span class="required">*</span></label>
                    <div class="controls">
                        <input type="file" name="companyimage">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Subscription Type<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="subscriptiontype">
                            <option value="">Select...</option>
                            <option value="Category 1">Business</option>
                            <option value="Category 2">Superior</option>
                            <option value="Category 3">Executive</option>

                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">ContactNo<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="contactno" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Contact Name<span class="required">*</span></label>
                    <div class="controls">
                        <input name="contactname" type="text" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Email<span class="required">*</span></label>
                    <div class="controls">
                        <input name="email" type="text" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Corporate Address<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="corporateaddress" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Corporate Address 2<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="corporateaddress2" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Billing Address <span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="billingaddress" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Categories</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="categories" data-placeholder="Choose a Category" tabindex="1">
                            <option value="">Select...</option>
                            <option value="Category 1">Category 1</option>
                            <option value="Category 2">Category 2</option>
                            <option value="Category 3">Category 5</option>
                            <option value="Category 4">Category 4</option>
                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Sub Categories</label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="subcategories" data-placeholder="Choose a Category" tabindex="1">
                            <option value="">Select...</option>
                            <option value="Category 1">Category 1</option>
                            <option value="Category 2">Category 2</option>
                            <option value="Category 3">Category 5</option>
                            <option value="Category 4">Category 4</option>
                        </select>
                    </div>
                </div>





                <!--<div class="control-group">
										<label class="control-label">Countery<span class="required">*</span></label>
										<div class="controls">
                                <select class="span6 m-wrap" name="country">
												<option value="">Select...</option>
												<option value="Category 1">United States</option>
												<option value="Category 2">Category 2</option>
												<option value="Category 3">Category 3</option>

											</select>
										</div>
									</div>-->



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
                    <label class="control-label">State<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="state">
                            <option value="">Select...</option>
                            <option value="Category 1">States1</option>
                            <option value="Category 2">States2</option>
                            <option value="Category 3">States3</option>

                        </select>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">city<span class="required">*</span></label>
                    <div class="controls">
                        <select class="span6 m-wrap" name="city">
                            <option value="">Select...</option>
                            <option value="Category 1">city1</option>
                            <option value="Category 2">city2</option>
                            <option value="Category 3">city3</option>

                        </select>
                    </div>
                </div>




                <div class="control-group">
                    <label class="control-label">Zip<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="zip" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>




                <div class="control-group">
                    <label class="control-label">Legal URL<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="legalurl" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>


                <div class="control-group">
                    <label class="control-label">Store URL<span class="required">*</span></label>
                    <div class="controls">
                        <input type="text" name="storeurl" data-required="1" class="span6 m-wrap"/>
                    </div>
                </div>




                <div class="control-group">
                    <label class="control-label">Keywords<span class="required">*</span></label>

                    <div class="controls" id="newlink">
                            <!--<input type="text" name="keywords" data-required="1" class="span6 m-wrap"/>-->
                        <!--<div id="newlink" > -->
                        <input type="text" name="keywords[]" class="span6 m-wrap" >
                        <p id="addnew">
                            <a href="javascript:add_feed()">Add New </a>
                        </p>
                        <!--</div>  -->
                    </div>
                </div>


                <!-- Template. This whole data will be added directly to working form above -->
                <div id="newlinktpl" style="display:none">
                    <div class="feed">
                        <input type="text" name="keywords[]"  class="span6 m-wrap" >
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

