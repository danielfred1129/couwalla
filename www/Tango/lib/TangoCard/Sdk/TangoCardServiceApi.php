<?php
/**
 * TangoCardServiceApi.php, wrapper class for accessing the Tango Card Service API 
 * controller and its available actions.
 * 
 */
 
/**
 * 
 * Copyright (c) 2013 Tango Card, Inc
 * All rights reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions: 
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software. 
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * PHP Version 5.3
 * 
 * @category    TangoCard
 * @package     SDK
 * @version     $Id: TangoCardServiceApi.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk;

/**
 * 
 * Tango Card Service API access class
 *
 */
class TangoCardServiceApi
{
    /**
     * 
     * Constructor that prevents a default instance of this class from being created.
     */
    private function __construct() {}

    /**
     * 
     * Get the current version of this SDK from configuration file
     *
     * @return string version number
     */
    public static function Version()
    {
        $appConfig = \TangoCard\Sdk\Common\SdkConfig::getInstance();
        
        $tc_sdk_version = $appConfig->getConfigValue("tc_sdk_version");
        
        return $tc_sdk_version;
    }

    /**
     * 
     * Get the available Tango Card account balance for provided authentication (username and password)
     * 
     * @param \TangoCard\Sdk\Service\TangoCardServiceApiEnum $enumTangoCardServiceApi
     * @param string $username The username to access User's registered Tango Card account
     * @param string $password The password to access User's registered Tango Card account
     * @param \TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse $responseGetAvailableBalance
     * 
     * @return boolean Returns true upon success, else false.
     * 
     * @throws TangoCardServiceException
     * @throws TangoCardSdkException
     * @throws InvalidArgumentException
     * 
     */
    public static function GetAvailableBalance(
        $enumTangoCardServiceApi,
        $username,
        $password,
        &$responseGetAvailableBalance
    ) {
        // username
        if ( \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($username) ) {
            throw new \InvalidArgumentException("Parameter 'username' is not defined.");
        }
        // password
        if ( \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($password) ) {
            throw new \InvalidArgumentException("Parameter 'password' is not defined.");
        }
        // set up the request
        $requestGetAvailableBalance = new \TangoCard\Sdk\Request\GetAvailableBalanceRequest(
            $enumTangoCardServiceApi,
            trim($username), 
            $password
            );
            
        // make the request
        return $requestGetAvailableBalance->execute($responseGetAvailableBalance);
    }
    
    /**
     * 
     * Based upon available funds within authenticated user's Tango Card account,
     * purchase a gift card for a specific recipient. How it is delivered is determined
     * by how parameter 'tcSend' is set; if 'true', then the Tango Card Service will email 
     * a digital gift card to recipient's provided email address 'recipientEmail'; else 
     * user of this SDK is responsible.
     * 
     * Upon successful purchase, Tango Card Service will respond with confirmation information.
     * 
     * @param \TangoCard\Sdk\Service\TangoCardServiceApiEnum $enumTangoCardServiceApi
     * @param string $username The username to access User's registered Tango Card account
     * @param string $password The password to access User's registered Tango Card account
     * @param string $cardSku The SKU of the card to purchase.
     * @param int    $cardValue The value of the card to buy in cents (example 500 = $5.00).
     * @param bool   $tcSend Determines if Tango Card Service will send an email with gift card information to recipient. 
     *       Email gift card and return the card's details (true), or just return the card's details (false).
     * @param string $recipientName The name of the recipient. Only 
     *       necessary if tcSend = true. If tcSend = false, then this input will be 
     *       ignored.
     * @param string $recipientEmail The email address of the recipient. 
     *       Only necessary if tcSend = true. If tcSend = false, then this input will 
     *       be ignored.
     * @param string $giftMessage The gift message to send to the recipient. 
     *       Only necessary if tcSend = true. If tcSend = false, this input will 
     *       be ignored.
     * @param string $giftFrom The name of the person giving the gift. Optional 
     *       if tcSend = true. If tcSend = false, then this input will be 
     *       ignored.
     * @param string $companyIdentifier The Company identifier for which 
     *       Email Template to use when sending Gift Card. Optional 
     *       if tcSend = true. If tcSend = false, then this input will be 
     *       ignored.
     * @param \TangoCard\Sdk\Response\Success\PurchaseCardResponse $responsePurchaseCard
     * 
     * @return boolean Returns true upon success, else false.
     * 
     * @throws TangoCardServiceException
     * @throws TangoCardSdkException
     * @throws InvalidArgumentException
     */
    public static function PurchaseCard(
        $enumTangoCardServiceApi,
        $username,
        $password,
        $cardSku,
        $cardValue,
        $tcSend,
        $recipientName,
        $recipientEmail,
        $giftMessage,
        $giftFrom,
        $companyIdentifier,
        &$responsePurchaseCard
    ) {
        // username
        if ( \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($username) ) {
            throw new \InvalidArgumentException("Parameter 'username' is not defined.");
        }
        // password
        if ( \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($password) ) {
            throw new \InvalidArgumentException("Parameter 'password' is not defined.");
        }
        // cardSku
        if ( \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($cardSku) ) {
            throw new \InvalidArgumentException("Parameter 'cardSku' is not defined.");
        }
        // cardValue
        if ( is_int($cardValue) === false ) {
            throw new \InvalidArgumentException("Parameter 'cardValue' is not an integer.");
        }         
        // tcSend
        if ( is_bool($tcSend) === false ) {
            throw new \InvalidArgumentException("Parameter 'tcSend' is not a boolean.");
        }
        
        // set up the request
        $requestPurchaseCard = new \TangoCard\Sdk\Request\PurchaseCardRequest(
            $enumTangoCardServiceApi,
            trim($username),
            $password,
            trim($cardSku),
            $cardValue,
            $tcSend,
            \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($recipientName) ? null : trim($recipientName),
            \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($recipientEmail) ? null : trim($recipientEmail),
            \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($giftMessage) ? null : nl2br(trim($giftMessage)),
            \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($giftFrom) ? null : trim($giftFrom),
            \TangoCard\Sdk\Common\Helper::isNullOrEmptyString($companyIdentifier) ? null : trim($companyIdentifier)
        );
        
        // make the request
        return $requestPurchaseCard->execute($responsePurchaseCard);
    }
}