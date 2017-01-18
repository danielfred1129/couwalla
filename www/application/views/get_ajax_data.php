<?php if (isset($sub_category)) { ?>
    <?php if (!empty($sub_category)) { ?>
        <label class="control-label">Sub Categories<span class="required">*</span></label>
        <div class="controls" >
            <div class="multiselect" >
                <?php foreach ($sub_category as $sub_cat) { ?>
                    <label>
                        <input type="checkbox" class="subcategory" name="sub_category[]"
                        <?php
                        foreach ($selectedsubcategory as $value) {
                            if ($sub_cat['id'] == $value['id']) {
                                echo 'checked';
                            }
                        }
                        ?>
                               id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>" />
                               <?php echo $sub_cat['category_name']; ?>
                    </label>
                <?php } ?>
            </div> 
         <span for="subcategoryid" class="suberr" style="color:red; font-size: 15px;"></span>
        </div>
    <?php } else { ?>
        <label class="control-label">Sub Categories<span class="required">*</span></label>
        <div class="controls" >

            <div class="multiselect" >

            </div>
        </div>
    <?php } ?>

<?php } else if (isset($states)) { ?>
    <option value="">Select State.......</option>
    <?php foreach ($states as $state) { ?>
        <option value="<?php echo $state['stateID']; ?>"> <?php echo $state['stateName']; ?></option>
    <?php }
} else if (isset($cities)) { ?>
    <option value="">Select City.......</option>
    <?php foreach ($cities as $city) { ?>
        <option value="<?php echo $city['cityID']; ?>"> <?php echo $city['cityName']; ?></option>
    <?php }
} else if (isset($stores)) { ?>
    <div class="multiselect" >
        <?php foreach ($stores as $store) { ?>
            <label>
                <input type="checkbox" name="store_list[]" id="store<?php echo $store['id']; ?>" value="<?php echo $store['id']; ?>" />
                <?php echo $store['storename']; ?>
            </label>
        <?php } ?>
    </div>
<?php } else if (isset($coupons)) { ?>
    <option value="">Select Coupon...</option>
    <?php foreach ($coupons as $coupon) { ?>
        <option value="<?php echo $coupon['id']; ?>"> <?php echo $coupon['name']; ?></option>
    <?php }
} else if (isset($category)) { ?>

    <?php foreach ($category as $cat) { ?>
        <label><input type="checkbox" class="category" name="category[]" id="category<?php echo $cat['id']; ?>" value="<?php echo $cat['id']; ?>" checked readonly /><?php echo $cat['category_name']; ?></label>

    <?php }
} else if (isset($subcategory)) { ?>

    <?php foreach ($subcategory as $cat) { ?>
        <label><input type="checkbox" class="subcategory" name="sub_category[]" id="category<?php echo $cat['id']; ?>" value="<?php echo $cat['id']; ?>" checked readonly />
            <?php echo $cat['category_name']; ?></label>

    <?php }
} else if (isset($cust_sub_category)) { ?>
    <?php if (!empty($cust_sub_category)) { ?>
        <label class="control-label">Sub Categories<span class="required">*</span></label>
        <div class="controls" >
            <div class="multiselect" >
                <?php foreach ($cust_sub_category as $sub_cat) { ?>
                    <label>
                        <input type="checkbox" class="subcategory" name="sub_category[]" id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>" />
                        <?php echo $sub_cat['category_name']; ?>
                    </label>
                <?php } ?>
            </div> 
        <span for="subcategoryid" class="suberr" style="color:red; font-size: 15px;"></span></div>
    <?php } else { ?>
        <label class="control-label">Sub Categories<span class="required">*</span></label>
        <div class="controls" >

            <div class="multiselect" >

            </div>
        </div>
    <?php }
} ?>
