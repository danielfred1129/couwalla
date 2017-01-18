/*
    Copyright (c) 2013 Tango Card, Inc
    All rights reserved

    Tango Card - RaaS API - Test Tool
    Version     1.0
    Updated     2013-05-08
    Company     Tango Card
*/
var merchants = {};
var apiEndPoints = [];
apiEndPoints.push({ name: 'Sandbox', url: 'https://sandbox.tangocard.com', platform: { name: 'TangoTest', key: '5xItr3dMDlEWAa9S4s7vYh7kQ01d5SFePPUoZZiK/vMfbo3A5BvJLAmD4tI=' } });
apiEndPoints.push({ name: 'Gamma', url: 'https://gamma-api.tangocard.com', platform: { name: 'TangoTest', key: 'FDy/uXSX4VV3rLW/mXQyd6v798nfFblspY+cvAlHexr5+n2m/0VMkk2Rx8o=' } });
apiEndPoints.push({ name: 'Production', url: 'https://api.tangocard.com', platform: { name: '', key: '' } });
//apiEndPoints.push({ name: 'KK-QA', url: 'https://dev-kk.tangocard.com', platform: { name: 'TangoTest', key: '5xItr3dMDlEWAa9S4s7vYh7kQ01d5SFePPUoZZiK/vMfbo3A5BvJLAmD4tI=' } });
apiEndPoints.push({ name: 'QA', url: 'https://qa-api.tangocard.com', platform: { name: 'TangoTest', key: 'D6GTBzlTS2uQocKBz0FgBz/urrldrkDPzpED3dSP3HVzdBwJARA2Wlb6VQE=' } });
apiEndPoints.push({ name: 'Other', url: 'https://dev-kk.tangocard.com', platform: { name: 'TangoTest', key: '5xItr3dMDlEWAa9S4s7vYh7kQ01d5SFePPUoZZiK/vMfbo3A5BvJLAmD4tI=' } });
//apiEndPoints.push({ name: 'QA', url: 'https://qa-api.tangocard.com', platform: { name: 'TangoTestPlatform', key: 'NR9kQluZd0QhTdsbL/65nX1J28pwhUPG0i0NJdmDTGYkCyx4zo/fswygqFI=' } });

var selectReward = function (merchantId, rewardId) {
    var id = "#placeorder_sku_" + merchantId + "_" + rewardId;
    var jsonString = $(id).data('json');
    $("#PlaceOrder_SKU").val(jsonString).attr("selected", true);
}

var doTheDew = function () {
    var loadedPPT = false;
    setTimeout(function () {
        $('#WhatIsRaasIFrame').attr('src', 'https://skydrive.live.com/embed?cid=FF0E8C34925BE2F1&resid=FF0E8C34925BE2F1%21108&authkey=AOVntK1PZ5FYp5Y&em=2')
            .load(function () {
                $(this).fadeIn();
                $('#divWhatIsRaaS').fadeIn();
                loadedPPT = true;
            });
    }, 4500);
    setInterval(function () {
        var visible = 0;
        $('.testinfo').each(function () {
            if ($(this).is(':visible')) {
                visible++;
                $('#divWhatIsRaaS').hide();
            }
        });
        if (visible == 0 && loadedPPT) {
            $('#divWhatIsRaaS').fadeIn();
        }
        var platformName = $('#Platform_Name').val();
        var platformKey = $('#Platform_Key').val();
        if (platformName != '' && platformKey != '') {
            var auth = $.base64.encode(platformName + ':' + platformKey);
            $('#BasicAuthorization').val('Basic ' + auth);
        }
        else {
            $('#BasicAuthorization').val('<not set>');
        }
    }, 1000);

    $('.test').each(function () {
        $(this).next().toggle();
    });
    $('.testinfo').each(function () {
        $(this).hide();
    });

    $('.test').click(function () {
        $('.advisory').effect('highlight', {}, 5000);
        var id = $(this).attr('id');
        if ($(this).next().is(':visible')) {
            $(this).next().effect('blind', null, 500, function () {
                $('#' + id + '_Tests').effect('blind', null, 500, function () {
                });
            });
        }
        else {
            $(this).next().effect('slide', null, 500, function () {
                $('#' + id + '_Tests').effect('slide', null, 500, function () {
                });
            });
        }
    });
    $('#selectSKUs').hide();
    $('#selectSKUsInfo').hide();
    var i = 0;
    for (var apiEndPoint in apiEndPoints) {
        $('#selectAPIEndPoint').append($('<option></option>').attr('value', i++).text(apiEndPoints[apiEndPoint].name));
    }
    $('#OrderHistory_StartDate').datepicker({ 'dateFormat': 'yy-mm-dd' });
    $('#OrderHistory_EndDate').datepicker({ 'dateFormat': 'yy-mm-dd' });
    selectPlatform(0);
    selectSku(null);

    $.support.cors = true;
    $('#APIEndPoint_Url').keyup(function () {
        updateUrl();
    });
    $('#textCustomer').keyup(function () {
        updateCustomer($('#textCustomer'));
    });
    $('#textAccountIdentifier').keyup(function () {
        updateAccountIdentifier($('#textAccountIdentifier'));
    });
    $('#selectAPIEndPoint').change(function () {
        selectPlatform($('#selectAPIEndPoint').val());
    });
    $('#PlaceOrder_SKU').change(function () {
        var sku = JSON.parse($(this).children(':selected').data('json'));
        selectSku(sku);
    });
    $('#buttonGetAccountInformation').click(function () {
        var customer = $('#GetAccountInformation_Customer').val();
        var accountIdentifier = $('#GetAccountInformation_AccountIdentifier').val();

        $('#buttonGetAccountInformation').attr('disabled', 'disabled').siblings().filter(':first').show();
        $('#GetAccountInformation_APIResponse, #GetAccountInformation_APIResponseStatus').removeClass('error').text('');
        $('#GetAccountInformation_APIRequest').text(customer + '/' + accountIdentifier);
        $('#tableGetAccountInformation_Response').hide();
        $('#tableGetAccountInformation_Request').effect('slide');

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.getAccountInformation({
            customer: customer,
            accountIdentifier: accountIdentifier,
            callbacks: {
                successFn: function (data) { // success
                    $('#GetAccountInformation_APIResponseStatus').removeClass('error').text('Success');
                    $('#GetAccountInformation_APIResponse').removeClass('error').text(JSON.stringify(data.account));
                },
                failFn: function (status, statusText, data) { // fail
                    $('#GetAccountInformation_APIResponseStatus').addClass('error').text('Error: HTTP Status ' + status + ' (' + statusText + ')');
                    $('#GetAccountInformation_APIResponse').addClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                },
                alwaysFn: function () { // always
                    $('#tableGetAccountInformation_Response').effect('slide');
                    $('#buttonGetAccountInformation').removeAttr('disabled').siblings().filter(':first').hide();
                }
            }
        });
    });
    $('#buttonFundAccount').click(function () {
        $('#buttonFundAccount').attr('disabled', 'disabled').siblings().filter(':first').show();
        $('#FundAccount_APIResponseStatus').removeClass('error').text('');
        $('#FundAccount_APIResponse').removeClass('error').text('');
        $('#tableFundAccount_Request').effect('slide');
        $('#tableFundAccount_Response').hide();

        var customer = $('#FundAccount_Customer').val();
        var accountIdentifier = $('#FundAccount_AccountIdentifier').val();
        var amount = $('#FundAccount_Amount').val();
        var clientIPAddress = $('#FundAccount_IPAddress').val();

        var credit_card = {};
        credit_card.number = $('#FundAccount_CreditCard_Number').val();
        credit_card.security_code = $('#FundAccount_CreditCard_Security_Code').val();
        credit_card.expiration = $('#FundAccount_CreditCardExpiration').val();
        credit_card.billing_address = {};
        credit_card.billing_address.f_name = $('#FundAccount_BillingAddress_FName').val();
        credit_card.billing_address.l_name = $('#FundAccount_BillingAddress_LName').val();
        credit_card.billing_address.address = $('#FundAccount_BillingAddress_Address').val();
        credit_card.billing_address.city = $('#FundAccount_BillingAddress_City').val();
        credit_card.billing_address.state = $('#FundAccount_BillingAddress_State').val();
        credit_card.billing_address.zip = $('#FundAccount_BillingAddress_Zip').val();
        credit_card.billing_address.country = $('#FundAccount_BillingAddress_Country').val();
        credit_card.billing_address.email = $('#FundAccount_BillingAddress_Email').val();

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.fundAccount({
            customer: customer,
            accountIdentifier: accountIdentifier,
            amount: amount,
            clientIPAddress: clientIPAddress,
            creditCard: credit_card,
            updateElement: $('#FundAccount_APIRequest'),
            callbacks: {
                successFn: function (data) { // success
                    console.log(data);
                    if (data.success) {
                        $('#FundAccount_APIResponse').removeClass('error').addClass('noerror').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                    }
                    else {
                        $('#FundAccount_APIResponse').addClass('error').text('Error: ' + JSON.stringify(data));
                    }
                },
                failFn: function (status, statusText, data) { // fail
                    $('#FundAccount_APIResponseStatus').addClass('error').html('Error: HTTP Status ' + status + ' (' + statusText + ')');
                    $('#FundAccount_APIResponse').addClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                },
                alwaysFn: function () { // always
                    $('#tableFundAccount_Response').effect('slide');
                    $('#buttonFundAccount').removeAttr('disabled').siblings().filter(':first').hide();
                }
            }
        });
    });
    $('#buttonRewardList').click(function () {
		alert("adsfasd");
        $('#buttonRewardList').attr('disabled', 'disabled');
        $('#buttonRewardList').siblings().filter(':first').show();
        $('#selectSKUs').empty().append($('<option>reading...</option>'));
        $('#PlaceOrder_SKU').empty().append($('<option>reading...</option>'));
        $('#tableRewardList_Response').hide();

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.getRewardList({
            callbacks: {
                successFn: function (data) {
                    $('#selectSKUs').empty().show();
                    $('#tableRewardList_Images').empty().show();

                    $('#selectSKUsInfo').show();
                    $('#PlaceOrder_SKU').empty();
                    $('#PlaceOrder_SKU').show();
                    $('#RewardList_APIResponse').removeClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                    if (data && true == data.success) {
                        merchants = data.brands;
                        for (var merchant in data.brands) {
                            var prices = [];
                            $('#selectSKUs').append($('<option></option>').attr('value', merchant).attr('style', 'font-style:bold').attr('disabled', 'disabled')
                                .text(data.brands[merchant].description));
                            $('#PlaceOrder_SKU').append($('<option></option>').attr('value', merchant).attr('style', 'font-style:bold').attr('disabled', 'disabled')
                                .text(data.brands[merchant].description));
                            var rewards = data.brands[merchant].rewards;
                            for (var reward in rewards) {
                                var description = rewards[reward].description;
                                if (rewards[reward].unit_price == -1) {
                                    description += " (Variable: ";
                                    description += "$" + rewards[reward].min_price / 100;
                                    description += " to ";
                                    description += "$" + rewards[reward].max_price / 100;
                                    description += ")";
                                    prices.push('<span class="reward_denom_span' + (rewards[reward].available ? '' : ' reward_denom_unavail') + '"><a href="#" class="reward_denom" ' +
                                        'onclick=\'selectReward(' + merchant + ',' + reward + ');return false;\'' +
                                        '>' + 'Variable ($' + rewards[reward].min_price / 100 + ' to $' + rewards[reward].max_price / 100 + (rewards[reward].available ? '' : '*') + ')' + '</a></span>');
                                } else {
                                    prices.push('<span class="reward_denom_span ' + (rewards[reward].available ? '' : ' reward_denom_unavail') + '"><a href="#" class="reward_denom"' +
                                        'onclick=\'selectReward(' + merchant + ',' + reward + ');return false;\'' +
                                        '>' + '$' + rewards[reward].unit_price / 100 + (rewards[reward].available ? '' : '*') + '</a></span>');
                                }
                                $('#selectSKUs').append($('<option></option>').attr('id', 'select_sku_' + merchant + '_' + reward)
                                    .val(JSON.stringify(rewards[reward]))
                                    .data('json', JSON.stringify(rewards[reward])).attr('disabled', 'disabled')
                                    .html('&nbsp;&nbsp;&nbsp;&nbsp;' + description));
                                $('#PlaceOrder_SKU').append($('<option></option>').attr('id', 'placeorder_sku_' + merchant + '_' + reward)
                                    .val(JSON.stringify(rewards[reward]))
                                    .data('json', JSON.stringify(rewards[reward]))
                                    .html('&nbsp;&nbsp;&nbsp;&nbsp;' + description));
                            }
                            $('#tableRewardList_Images').append($('<div></div>')
                                .attr('class', 'reward_image_box')
                                .attr('style', 'background-image:url(' + data.brands[merchant].image_url + ')')
                                .html('<br/><br/><br/><br/>' + (1 + parseInt(merchant, 10)) + '. ' + data.brands[merchant].description + '<br/>' + prices.join('&nbsp;')));

                            $('#PlaceOrder_SKU').change();
                        }
                    }
                },
                failFn: function (status, statusText, data) { // fail
                    $('#selectSKUs').empty();
                    $('#PlaceOrder_SKU').empty();
                },
                alwaysFn: function () { // always
                    $('#tableRewardList_Response').effect('slide');
                    $('#buttonRewardList').attr('disabled', null).siblings().filter(':first').hide();
                }
            }
        });
    });
    $('#buttonCreateAccount').click(function () {
        var elemThis = $(this);
        var elemFnBlock = elemThis.parents('.fnblock');
        preRaaSCall(elemThis);

        TangoCardRaasAPI.createAccount({
            customer: elemFnBlock.find('.RaaSCustomer').val(),
            accountIdentifier: elemFnBlock.find('.RaaSAccountIdentifier').val(),
            email: elemFnBlock.find('.RaaSEmailAddress').val(),
            updateElement: elemFnBlock.find('.apirequest'),
            callbacks: {
                successFn: function (data) {
                    successRaaSCall(data, elemThis);
                },
                failFn: function (status, statusText, data) {
                    failRaaSCall(status, statusText, data, elemThis);
                },
                alwaysFn: function () {
                    console.log('ca: alwaysfn');
                    postRaaSCall(elemThis);
                }
            }
        });
    });
    $('#buttonPlaceOrder').click(function () {
        $('#buttonPlaceOrder').attr('disabled', 'disabled').siblings().filter(':first').show();
        $('#PlaceOrder_APIResponse, #PlaceOrder_APIResponseStatus').removeClass('error').text('');
        $('#tablePlaceOrder_Request').effect('slide');
        $('#tablePlaceOrder_Response').hide();

        var sku = JSON.parse($('#PlaceOrder_SKU').children(':selected').data('json'));

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.placeOrder({
            customer: $('#PlaceOrder_Customer').val(),
            accountIdentifier: $('#PlaceOrder_AccountIdentifier').val(),
            campaign: $('#PlaceOrder_Campaign').val(),
            rewardFrom: $('#PlaceOrder_From').val(),
            rewardSubject: $('#PlaceOrder_Subject').val(),
            recipient: {
                name: $('#PlaceOrder_RecipientName').val(),
                email: $('#PlaceOrder_RecipientEmail').val()
            },
            sku: sku.sku,
            amount: $('#PlaceOrder_Amount').val(),
            rewardMessage: $('#PlaceOrder_RewardMessage').val(),
            sendReward: $('#PlaceOrder_SendReward').is(':checked'),
            updateElement: $('#PlaceOrder_APIRequest'),
            callbacks: {
                successFn: function (data) { // success
                    if (data.success) {
                        $('#PlaceOrder_APIResponseStatus').removeClass('error').text('Success');
                        $('#PlaceOrder_APIResponse').removeClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                        $('#GetOrderInformation_OrderId').val(data.order.order_id);
                    }
                    else {
                        $('#PlaceOrder_APIResponseStatus').addClass('error').text('Error');
                        $('#PlaceOrder_APIResponse').addClass('error').text(data.error_message);
                    }
                },
                failFn: function (status, statusText, data) { // fail
                    $('#PlaceOrder_APIResponseStatus').addClass('error').text('Error: HTTP Status ' + status + ' (' + statusText + ')');
                    $('#PlaceOrder_APIResponse').addClass('error').text((data ? JSON.stringify(data, null, 2) : '<empty>'));
                },
                alwaysFn: function () { // always
                    $('#tablePlaceOrder_Response').effect('slide');
                    $('#buttonPlaceOrder').removeAttr('disabled').siblings().filter(':first').hide();
                }
            }
        });
    });
    $('#buttonOrderInformation').click(function () {
        $('#buttonOrderInformation').attr('disabled', 'disabled').siblings().filter(':first').show();
        $('#GetOrderInformation_APIRequest').text('/' + $('#GetOrderInformation_OrderId').val());
        $('#GetOrderInformation_APIResponseStatus').removeClass('error').text('');
        $('#GetOrderInformation_APIResponse').removeClass('error').text('');

        $('#tableGetOrderInformation_Request').effect('slide');
        $('#tableGetOrderInformation_Response').hide();

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.getOrderInformation({
            orderId: $('#GetOrderInformation_OrderId').val(),
            callbacks: {
                successFn: function (data) { // success
                    if (data.success) {
                        $('#GetOrderInformation_APIResponse').removeClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty>');
                    }
                    else {
                        $('#GetOrderInformation_APIResponse').addClass('error').text(data.error_message);
                    }
                },
                failFn: function (status, statusText, data) { // fail
                    $('#GetOrderInformation_APIResponseStatus').addClass('error').text('Error: HTTP Status ' + status + ' (' + statusText + ')');
                    $('#GetOrderInformation_APIResponse').addClass('error').text((data ? JSON.stringify(data, null, 2) : '<empty>'));
                },
                alwaysFn: function () { // always
                    $('#tableGetOrderInformation_Response').effect('slide');
                    $('#buttonOrderInformation').removeAttr('disabled').siblings().filter(':first').hide();
                }
            }
        });
    });
    $('#buttonRetrieveOrderHistory').click(function () {
        $('#buttonRetrieveOrderHistory').attr('disabled', 'disabled').siblings().filter(':first').show();
        $('#OrderHistory_APIResponseStatus').removeClass('error').text('');
        $('#OrderHistory_APIResponse').removeClass('error').text('');

        $('#tableOrderHistory_Request').effect('slide');
        $('#tableOrderHistory_Response').hide();

        TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
        TangoCardRaasAPI.platformName = $('#Platform_Name').val();
        TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
        TangoCardRaasAPI.retrieveOrderHistory({
            customer: $('#OrderHistory_Customer').val(),
            accountIdentifier: $('#OrderHistory_AccountIdentifier').val(),
            offset: $('#OrderHistory_Offset').val(),
            limit: $('#OrderHistory_Limit').val(),
            startDate: $('#OrderHistory_StartDate').val(),
            endDate: $('#OrderHistory_EndDate').val(),
            updateElement: $('#OrderHistory_APIRequest'),
            callbacks: {
                successFn: function (data) { // success
                    if (data.success) {
                        $('#OrderHistory_APIResponse').removeClass('error').text(data ? JSON.stringify(data, null, 2) : '<empty response>');
                    }
                    else {
                        $('#OrderHistory_APIResponse').addClass('error').text(data.error_message);
                    }
                },
                failFn: function (status, statusText, data) { // fail
                    $('#OrderHistory_APIResponseStatus').addClass('error').text('Error: HTTP Status ' + status + ' (' + statusText + ')');
                    $('#OrderHistory_APIResponse').addClass('error').text((data ? JSON.stringify(data, null, 2) : '<empty>'));
                },
                alwaysFn: function () { // always
                    $('#tableOrderHistory_Response').effect('slide');
                    $('#buttonRetrieveOrderHistory').removeAttr('disabled').siblings().filter(':first').hide();
                }
            }
        });
    });
}

var selectPlatform = function (index) {
    var platform = apiEndPoints[index].platform;
    if (platform) {
        $('#Platform_Name').val(platform.name);
        $('#Platform_Key').val(platform.key);
        /*if (platform.name != '') {
            $('#Platform_Name').attr('readonly', 'readonly').attr('disabled', 'disabled');
        }
        else {
            $('#Platform_Name').removeAttr('readonly').removeAttr('disabled');
        }
        if (platform.key != '') {
            $('#Platform_Key').attr('readonly', 'readonly').attr('disabled', 'disabled');
        }
        else {
            $('#Platform_Key').removeAttr('readonly').removeAttr('disabled');
        }*/
        $('#BasicAuthorization').attr('readonly', 'readonly').attr('disabled', 'disabled');
    }

    var host = apiEndPoints[index].url;
    $('#APIEndPoint_Url').val(host == '' ? 'https://' : host);
    $('#APIEndPoint_Url_Row').hide();

    if (apiEndPoints[index].name == 'Other') $('#APIEndPoint_Url_Row').show();

    updateUrl();
}

var updateUrl = function()
{
    var host = $('#APIEndPoint_Url').val();

    $('.fnblock').each(function(index, value){
        var elem = $(this).find('.endpoint');
        elem.text((elem.data('endpoint') || '').replace('{url}', host));
    });
}

var updateCustomer = function (elem) {
    $('#GetAccountInformation_Customer, #FundAccount_Customer, #PlaceOrder_Customer, #OrderHistory_Customer').val(elem.val());
}

var updateAccountIdentifier = function (elem) {
    $('#GetAccountInformation_AccountIdentifier, #FundAccount_AccountIdentifier, #PlaceOrder_AccountIdentifier, #OrderHistory_AccountIdentifier').val(elem.val());
}

var selectSku = function (sku) {
    $('#PlaceOrder_Amount_Row').hide();
    if (sku == null) return;
    if (sku.unit_price == -1) {
        $('#PlaceOrder_Amount_Row').show();
        $('#PlaceOrder_Amount').val(999);
    }
    else {
        $('#PlaceOrder_Amount').val('');
    }
    if (sku.available) {
        $('#buttonPlaceOrder').removeAttr('disabled');
        $('#PlaceOrder_OutOfInventory').hide();
    }
    else {
        $('#buttonPlaceOrder').attr('disabled', 'disabled');
        $('#PlaceOrder_OutOfInventory').show();
    }
}

// real helpers
var preRaaSCall = function (elemThis) {
    var elemFnBlock = elemThis.parents('.fnblock');
    elemThis.attr('disabled', 'disabled').siblings().filter(':first').show();
    elemFnBlock.find('.tangoTableRequest').effect('slide');
    elemFnBlock.find('.tangoTableResponse').hide();

    TangoCardRaasAPI.hostUrl = $('#APIEndPoint_Url').val();
    TangoCardRaasAPI.platformName = $('#Platform_Name').val();
    TangoCardRaasAPI.platformKey = $('#Platform_Key').val();
}

var postRaaSCall = function (elemThis) {
    var elemFnBlock = elemThis.parents('.fnblock');
    elemFnBlock.find('.tangoTableResponse').effect('slide');
    elemThis.removeAttr('disabled').siblings().filter(':first').hide();
}

var successRaaSCall = function (data, elemThis) {
    var elemFnBlock = elemThis.parents('.fnblock');
    if (data.success) {
        elemFnBlock.find('.apiresponsestatus').removeClass('error').text('Success');
        elemFnBlock.find('.apiresponse').removeClass('error').addClass('noerror')
            .text(data ? JSON.stringify(data, null, 2) : '<empty>');
    }
    else {
        elemFnBlock.find('.apiresponse').addClass('error').text(data.error_message);
    }
}

var failRaaSCall = function (status, statusText, data, elemThis) {
    var elemFnBlock = elemThis.parents('.fnblock');
    console.log(data);
    elemFnBlock.find('.apiresponsestatus').addClass('error').html('Error: HTTP Status ' + status + ' (' + statusText + ')');
    elemFnBlock.find('.apiresponse').addClass('error').text((data ? JSON.stringify(data, null, 2) : ''));
}
