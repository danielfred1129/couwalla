<?php if ($result == '0') { ?>
    <div class="alert alert-error">
        <button class="close" data-dismiss="alert"></button>
        <span>Invalid Email id!</span>
    </div>
<?php } else { ?>
    <div class="alert alert-success">
        <button class="close" data-dismiss="alert"></button>
        <span>Please check your mail for further proceedings!</span>
    </div>
<?php } ?>
