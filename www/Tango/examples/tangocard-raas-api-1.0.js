/*
    Copyright (c) 2013 Tango Card, Inc
    All rights reserved

    Tango Card - RaaS API - Test Tool
    Version     1.0
    Updated     2013-05-08
    Company     Tango Card
*/
var TangoCardRaasAPI = {};

TangoCardRaasAPI.hostUrl = null;
TangoCardRaasAPI.platformKey = null;
TangoCardRaasAPI.platformName = null;

TangoCardRaasAPI._fundsUri = '/raas/v1/funds';
TangoCardRaasAPI._ordersUri = '/raas/v1/orders';
TangoCardRaasAPI._rewardsUri = '/raas/v1/rewards';
TangoCardRaasAPI._accountsUri = '/raas/v1/accounts';

// callbacks: {successFn, failFn, alwaysFn }
TangoCardRaasAPI.getRewardList = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;
    $.ajax({
        'type': 'GET',
        'url': this.hostUrl + this._rewardsUri,
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/rewards success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function(data){
        console.log('/raas/v1/rewards fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function(){
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { customer, accountIdentifier, email, updateElement, callbacks: {successFn, failFn, alwaysFn } }
TangoCardRaasAPI.createAccount = function (o) { 
    var platformName = this.platformName;
    var platformKey = this.platformKey;
    var data = {
        'customer': o.customer,
        'identifier': o.accountIdentifier,
        'email': o.email
    };
    if (o.updateElement) {
        o.updateElement.text(JSON.stringify(data));
    }
    $.ajax({
        'type': 'POST',
        'url': this.hostUrl + this._accountsUri,
        'data': JSON.stringify(data),
        'contentType': 'application/json',
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/accounts success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/accounts fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { customer, accountIdentifier, callbacks: {successFn, failFn, alwaysFn } }
TangoCardRaasAPI.getAccountInformation = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;
    $.ajax({
        'type': 'GET',
        'url': this.hostUrl + this._accountsUri + '/' + o.customer + '/' + o.accountIdentifier,
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/accounts success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/accounts fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { customer, accountIdentifier, amount, clientIPAddress, creditCard, updateElement, callbacks: {successFn, failFn, alwaysFn } }
TangoCardRaasAPI.fundAccount = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;

    var data = {};
    data.customer = o.customer;
    data.account_identifier = o.accountIdentifier;
    data.amount = parseInt(o.amount, 10);
    data.client_ip = o.clientIPAddress;
    data.credit_card = o.creditCard;
    if (o.updateElement) {
        o.updateElement.text(JSON.stringify(data, null, 2));
    }
    $.ajax({
        'type': 'POST',
        'url': this.hostUrl + this._fundsUri,
        'data': JSON.stringify(data),
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/funds success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/funds fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { customer, accountIdentifier, recipient: { name, email }, sku, amount, rewardMessage, updateElement, 
// callbacks: { successFn, failFn, alwaysFn } }
TangoCardRaasAPI.placeOrder = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;

    var data = {};
    data.customer = o.customer;
    data.account_identifier = o.accountIdentifier;
    data.campaign = o.campaign;
    data.recipient = o.recipient;
    data.sku = o.sku;
    if (o.amount && o.amount != '') {
        data.amount = parseInt(o.amount, 10);
    }
    data.reward_from = o.rewardFrom;
    data.reward_subject = o.rewardSubject;
    data.reward_message = o.rewardMessage;
    data.send_reward = o.sendReward;
    if (o.updateElement) {
        o.updateElement.text(JSON.stringify(data, null, 2));
    }
    $.ajax({
        'type': 'POST',
        'url': this.hostUrl + this._ordersUri,
        'data': JSON.stringify(data),
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/orders success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/orders fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { orderId, callbacks: { successFn, failFn, alwaysFn } }
TangoCardRaasAPI.getOrderInformation = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;

    $.ajax({
        'type': 'GET',
        'url': this.hostUrl + this._ordersUri + '/' + o.orderId,
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/orders success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/orders fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}

// { customer, accountIdentifier, offset, limit, startDate, endDate, updateElement, 
// callbacks: { successFn, failFn, alwaysFn } }
TangoCardRaasAPI.retrieveOrderHistory = function (o) {
    var platformName = this.platformName;
    var platformKey = this.platformKey;

    var data = [];
    data.push('customer=' + escape(o.customer));
    data.push('account_identifier=' + escape(o.accountIdentifier));
    if (o.offset && o.offset != '') {
        data.push('offset=' + o.offset);
    }
    if (o.limit && o.limit != '') {
        data.push('limit=' + o.limit);
    }
    if (o.startDate && o.startDate != '') {
        data.push('start_date=' + o.startDate + 'T00:00:00');
    }
    if (o.endDate && o.endDate != '') {
        data.push('end_date=' + o.endDate + 'T23:59:59');
    }
    if (o.updateElement) {
        o.updateElement.text(data.join('&'));
    }
    $.ajax({
        'type': 'GET',
        'url': this.hostUrl + this._ordersUri,
        'data': data.join('&'),
        'beforeSend': function (xhr) {
            xhr.setRequestHeader('Content-Type', 'text/plain');
            xhr.setRequestHeader('Authorization', 'Basic ' + $.base64.encode(platformName + ':' + platformKey));
        }
    }).success(function (data) {
        console.log('/raas/v1/orders success');
        if (o && o.callbacks && typeof o.callbacks.successFn == 'function') {
            o.callbacks.successFn(data);
        }
    }).fail(function (data) {
        console.log('/raas/v1/orders fail');
        if (o && o.callbacks && typeof o.callbacks.failFn == 'function') {
            o.callbacks.failFn(data.status, data.statusText, data.responseText && data.responseText != 'null' ? JSON.parse(data.responseText) : null);
        }
    }).always(function () {
        if (o && o.callbacks && typeof o.callbacks.alwaysFn == 'function') {
            o.callbacks.alwaysFn();
        }
    });
}
