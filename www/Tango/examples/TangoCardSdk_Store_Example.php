<?php
/**
 * TangoCardSdk_Store_Example.php, Example code using Tango Card SDK to get available 
 * balance and purchase card.
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
 * @package     Examples
 * @version     $Id: TangoCardSdk_Store_Example.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */  

namespace TangoCard\Sdk\Example;

require_once dirname(__FILE__) . "/../lib/TangoCardSdkAutoloader.php";

/**
 * 
 * Store Front PHP Script example using Tango Card PHP SDK.
 *
 */
class TangoCardSdk_Store_Example
{
    /**
     * 
     * Constructor that prevents a default instance of this class from being created.
     */
    private function __construct() {}
    
    /**
     * 
     * Example of running successful requests to Tango Card Service API
     * through Tango Card PHP SDK.
     */
    public static function Run()
    {
        echo "\n==============================\n";
        echo   "= Tango Card PHP SDK Example =\n";
        echo   "==============================\n";
        echo   "    Tango Card PHP SDK version: " . \TangoCard\Sdk\TangoCardServiceApi::Version();
        echo "\n";
        
        try {  
            $app_config_file = dirname(__FILE__) . "/../config/app_config_example.ini";
            if (!file_exists($app_config_file)) {
                throw new \RuntimeException('The app_config_example.ini file is required.');
            }
                        
            $app_config             = parse_ini_file($app_config_file, 'TANGOCARD');
			//print_r($app_config);
			//exit;
            if (null == $app_config) {
                throw new \RuntimeException('Unable to parse app_config_example.ini.');
            }
        
            $app_username           = $app_config['TANGOCARD']['app_username'];
            $app_password           = $app_config['TANGOCARD']['app_password'];
            
            // example setup
            $app_card_sku_example           = $app_config['TANGOCARD']['app_card_sku_example'];
            $app_card_value_example         = $app_config['TANGOCARD']['app_card_value_example'];
            $app_recipient_email_example    = $app_config['TANGOCARD']['app_recipient_email_example'];
        
            $app_tango_card_service_api = $app_config['TANGOCARD']['app_tango_card_service_api'];      
            $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
           
            $cardValueTangoCardCents = intval($app_card_value_example);
			
	
            /**
             * Get Available Balance for account of provided username\password credentials
             */
			
            $responseGetAvailableBalance = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                    $enumTangoCardServiceApi,
                    $app_username, 
                    $app_password,
                    $responseGetAvailableBalance
                    ) 
                && (null != $responseGetAvailableBalance)
            ) { 
                // we have a response from the server, lets see what we got (and do something with it)
                if (is_a($responseGetAvailableBalance, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse')) {
                    echo "\nSuccess - GetAvailableBalance - Initial\n";
                    $tango_cents_available_balance = $responseGetAvailableBalance->getAvailableBalance();
                    $tango_dollars_available_balance = number_format(($tango_cents_available_balance/100), 2);
                    echo "    API Environment:    '"  . $app_tango_card_service_api ."'\n";
                    echo sprintf("    '%s': Available balance: %s.\n", $app_username, $tango_cents_available_balance);
                } else {
                    throw new RuntimeException('Unexpected response.');
                }
            } else {
                throw new RuntimeException('Unexpected response.');
            }
        
            /**
             * Purchase Card (with emailing to recipientEmail) using funds from 
             * account of provided username\password credentials
             */
                        
             $responsePurchaseCard_Delivery = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                    $enumTangoCardServiceApi,
                    $app_username,
                    $app_password,
                    $app_card_sku_example,                          // cardSku
                    $cardValueTangoCardCents,               // cardValue
                    true,                                   // tcSend 
                    "Sally Customer",                       // recipientName
                    $app_recipient_email_example,                   // recipientEmail
                    "Hello from Tango Card PHP SDK:\nTango Card\nPhone: 1-877-55-TANGO\n601 Union Street, Suite 4200\nSeattle, WA 98101",                       // giftMessage
                    "Bill Example",                         // giftFrom
                    null,                                   // companyIdentifier
                    $responsePurchaseCard_Delivery          // response
                ) 
                && (null != $responsePurchaseCard_Delivery)
            ) {
                // we have a response from the server, lets see what we got (and do something with it)
                if (is_a($responsePurchaseCard_Delivery, 'TangoCard\Sdk\Response\Success\PurchaseCardResponse')) {
                    echo "\nSuccess - PurchaseCard Confirmation with Email Delivery\n";
                    echo "    API Environment:    '"  . $app_tango_card_service_api ."'\n";
                    echo "    Recipient Email:    '"  . $app_recipient_email_example ."'\n";
                    echo "    Gift Card SKU:      '"  . $app_card_sku_example ."'\n";
                    echo "    Gift Card Value:     "  . $cardValueTangoCardCents ." (cents)\n";
                    echo "    Reference Order ID: '"  . $responsePurchaseCard_Delivery->getReferenceOrderId() ."'\n";
                    echo "    Card Token:         '"  . $responsePurchaseCard_Delivery->getCardToken() . "'\n";
                    echo "    Card Number:        '"  . $responsePurchaseCard_Delivery->getCardNumber() . "'\n";
                    echo "    Card Pin:           '"  . $responsePurchaseCard_Delivery->getCardPin() . "'\n";
                    echo "    Claim Url:          '"  . $responsePurchaseCard_Delivery->getClaimUrl() . "'\n";
                    echo "    Challenge Key:      '"  . $responsePurchaseCard_Delivery->getChallengeKey() . "'\n";
                    echo "    Event Number:       '"  . $responsePurchaseCard_Delivery->getEventNumber() . "'\n";
                } else {
                    throw new RuntimeException('Unexpected response.');
                }
            } else {
                throw new RuntimeException('Unexpected response.');
            } 
        
            /**
             * Purchase Card (without emailing) using funds from account of provided 
             * username\password credentials
             */
             
            $responsePurchaseCard_NoDelivery = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                $enumTangoCardServiceApi,
                $app_username, 
                $app_password,
                $app_card_sku_example,                      // cardSku
                $cardValueTangoCardCents,                   // cardValue
                false,                                      // tcSend 
                null,                                       // recipientName
                null,                                       // recipientEmail
                null,                                       // giftMessage
                null,                                       // giftFrom
                null,                                       // companyIdentifier
                $responsePurchaseCard_NoDelivery            // response
                ) 
                && (null != $responsePurchaseCard_NoDelivery)
            ) {
                // we have a response from the server, lets see what we got (and do something with it)
                if (is_a($responsePurchaseCard_NoDelivery, 'TangoCard\Sdk\Response\Success\PurchaseCardResponse')) {
                    echo "\nSuccess - PurchaseCard Confirmation without Email Delivery\n";
                    echo "    API Environment:    '"  . $app_tango_card_service_api ."'\n";
                    echo "    Gift Card SKU:      '"  . $app_card_sku_example ."'\n";
                    echo "    Gift Card Value:     "  . $cardValueTangoCardCents ." (cents)\n";
                    echo "    Reference Order ID: '"  . $responsePurchaseCard_Delivery->getReferenceOrderId() ."'\n";
                    echo "    Card Token:         '"  . $responsePurchaseCard_Delivery->getCardToken() . "'\n";
                    echo "    Card Number:        '"  . $responsePurchaseCard_Delivery->getCardNumber() . "'\n";
                    echo "    Card Pin:           '"  . $responsePurchaseCard_Delivery->getCardPin() . "'\n";
                    echo "    Claim Url:          '"  . $responsePurchaseCard_Delivery->getClaimUrl() . "'\n";
                    echo "    Challenge Key:      '"  . $responsePurchaseCard_Delivery->getChallengeKey() . "'\n";
                    echo "    Event Number:       '"  . $responsePurchaseCard_Delivery->getEventNumber() . "'\n";
                } else {
                    throw new RuntimeException('Unexpected response.');
                }
            } else {
                throw new RuntimeException('Unexpected response.');
            }
            
            /**
             * Get Available Balance (updated) for account of provided 
             * username\password credentials
             */
             
            /* $responseGetAvailableBalanceUpdate = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                    $enumTangoCardServiceApi,
                    $app_username, 
                    $app_password,
                    $responseGetAvailableBalanceUpdate
                    ) 
                && (null != $responseGetAvailableBalance)
            ) { 
                // we have a response from the server, lets see what we got (and do something with it)
                if (is_a($responseGetAvailableBalanceUpdate, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse')) {
                    echo "\nSuccess - GetAvailableBalance - Concluding\n";
                    $tango_cents_available_balance = $responseGetAvailableBalanceUpdate->getAvailableBalance();
                    $tango_dollars_available_balance = number_format(($tango_cents_available_balance/100), 2);
                    echo "    API Environment:    '"  . $app_tango_card_service_api ."'\n";
                    echo sprintf("    '%s': Available balance: %s.\n", $app_username, $tango_cents_available_balance);
                } else {
                    throw new RuntimeException('Unexpected response.');
                } 
            } else {
                throw new RuntimeException('Unexpected response.');
            } */
        } catch (\TangoCard\Sdk\Service\TangoCardServiceException $e) {
            echo 'TangoCardServiceException: ' . $e->getMessage() . "\n";
        } catch (\TangoCard\Sdk\Common\TangoCardSdkException $e) {
            echo 'TangoCardSdkException: ' . $e->getMessage() . "\n";
        } catch (InvalidArgumentException $e) {
            echo 'Invalid arguments: ' . $e->getMessage() . "\n";
            echo $e->getTraceAsString();
        } catch (UnexpectedValueException $e){
            echo 'Unexpected Value: ' . $e->getMessage() . "\n";
            echo $e->getTraceAsString();
        } catch (RuntimeException $e) {
            echo 'Runtime Exception: ' . $e->getMessage() . "\n";
            echo $e->getTraceAsString();
        } catch (Exception $e) {
            echo 'Exception: ' . $e->getMessage() . "\n";
            echo $e->getTraceAsString();
        }
              
        echo "\n==============================\n";
        echo   "=   The End                  =\n";
        echo   "==============================\n";
    }
}

/**
 * Run Tango Card SDK successful request examples
 */
TangoCardSdk_Store_Example::Run();
