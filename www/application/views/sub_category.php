<!--<select data-placeholder="" class="chosen span12" multiple="multiple" tabindex="6" name="sub_category[]">
<option value="">Select Sub Category</option>
<?php //foreach ($sub_category as $sub_cat) { ?>        
                    <option value="<?php //echo $sub_cat['id'];        ?>"><?php //echo $sub_cat['category_name'];        ?></option>
<?php //} ?>
</select>-->
<!--<style type="text/css">
    .multiselect {
        width:26em;
        height:8em;
        border:solid 1px #c0c0c0;
        overflow:auto;
    }

    .multiselect label {
        display:block;
    }

    .multiselect-on {
        color:#ffffff;
        background-color:#000099;
    }
</style>-->
<div class="multiselect" >
    <label>
        <input type="checkbox" name="sub_category[]"  value="" />
        Select Sub Category
    </label>
<?php foreach ($sub_category as $sub_cat) { ?>
                    <label>
                        <input type="checkbox" name="sub_category[]" id="category<?php echo $sub_cat['id']; ?>" value="<?php echo $sub_cat['id']; ?>" />
    <?php echo $sub_cat['category_name']; ?>
                    </label>
<?php } ?>
</div>

