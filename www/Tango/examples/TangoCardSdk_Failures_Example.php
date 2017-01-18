<?php
/**
 * TangoCardSdk_Failures_Example.php, Example code using Tango Card SDK forcing 
 * failures and then collecting responses.
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
 * @version     $Id: TangoCardSdk_Failures_Example.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */

namespace TangoCard\Sdk\Example;

require_once dirname(__FILE__) . "/../lib/TangoCardSdkAutoloader.php";

/**
 * 
 * PHP Script example using Tango Card PHP SDK demonstrating how to handle failure responses.
 *
 */
class TangoCardSdk_Failures_Example
{
    /**
     * 
     * Constructor that prevents a default instance of this class from being created.
     */
    private function __construct() {}
    
    /**
     * 
     * Example of running failure requests to Tango Card Service API
     * through Tango Card PHP SDK.
     */
    public static function Run()
    {

        echo "\n==============================\n";
        echo   "= Tango Card PHP SDK Example =\n";
        echo   "=   with Failures            =\n";
        echo   "==============================\n";
        echo   "\tTango Card PHP SDK version: " . \TangoCard\Sdk\TangoCardServiceApi::Version();
        echo "\n";
        
        self::Example_GetAvailableBalance_InvalidCredentials();
        self::Example_PurchaseCard_InsufficientFunds();
        
        echo "\n==============================\n";
        echo   "=   The End                  =\n";
        echo   "==============================\n";
    }
    
    /**
     * 
     * Tests failure response condition for InvalidCredentials
     */
    protected static function Example_GetAvailableBalance_InvalidCredentials()
    {
        $app_config_file = dirname(__FILE__) . "/../config/app_config_example.ini";
        if (!file_exists($app_config_file)) {
            throw new \RuntimeException('The app_config_example.ini file is required.');
        }
                    
        $app_config             = parse_ini_file($app_config_file, 'TANGOCARD');
        if (null == $app_config) {
            throw new \RuntimeException('Unable to parse app_config_example.ini.');
        }
        
        $app_username           = $app_config['TANGOCARD']['app_username'];
        $app_password           = $app_config['TANGOCARD']['app_password'];
        $app_card_sku_example           = $app_config['TANGOCARD']['app_card_sku_example'];
                    
        $app_tango_card_service_api = $app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
    
        $username = "burt@example.com";
        $password = "password";
    
        try
        {
            echo "\n======== Get Available Balance with Invalid Credentials ========\n";
    
            $responseGetAvailableBalance = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                    $enumTangoCardServiceApi,
                    $username, 
                    $password,
                    $responseGetAvailableBalance
                    ) 
                && (null != $responseGetAvailableBalance)
            ) { 
                echo "=== Expected failure ===\n";
            }
        }
        catch (\TangoCard\Sdk\Service\TangoCardServiceException $e)
        {
            echo "\n=== Tango Card Service Failure ===";        
            echo "\nFailure response type: " . $e->getResponseType();
            echo "\nFailure response:      " . $e->getMessage();
        }
        catch (\TangoCard\Sdk\Common\TangoCardSdkException $e)
        {
            echo "\n=== Tango Card SDK Failure ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
        catch (\RuntimeException $e)
        {
            echo "\n=== Runtime Exception Error ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
        catch (Exception $e)
        {
            echo "\n=== Unexpected Error ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
    
        echo "\n\n===== End Get Available Balance with Invalid Credentials ====\n\n\n";
    }
    
    /**
     * 
     * Example of purchace attempt with insufficent funds and how the error status is caught.
     *
     */
    protected static function Example_PurchaseCard_InsufficientFunds()
    {
        $app_config_file = dirname(__FILE__) . "/../config/app_config_example.ini";
        if (!file_exists($app_config_file)) {
            throw new \RuntimeException('The app_config_example.ini file is required.');
        }
                    
        $app_config             = parse_ini_file($app_config_file, 'TANGOCARD');
        if (null == $app_config) {
            throw new \RuntimeException('Unable to parse app_config_example.ini.');
        }
        
        $cardValueTangoCardCents = 100; // $1.00 dollars
        
        $app_username           = $app_config['TANGOCARD']['app_username'];
        $app_password           = $app_config['TANGOCARD']['app_password'];
        $app_card_sku_example           = $app_config['TANGOCARD']['app_card_sku_example'];
                    
        $app_tango_card_service_api = $app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
    
        $username = "155.com";
        $password = "password";
    
        try
        {
            echo "\n======== Purchase Card with Insufficient Funds ========\n";
    
            $responsePurchaseCard_NoDelivery = null;
            if ( \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                $enumTangoCardServiceApi,
                $username, 
                $password,
                $app_card_sku_example,                      // cardSku
                $cardValueTangoCardCents,           // cardValue
                false,                              // tcSend 
                null,                               // recipientName
                null,                               // recipientEmail
                null,                               // giftMessage
                null,                               // giftFrom
                null,                               // companyIdentifier
                $responsePurchaseCard_NoDelivery    // response
                ) 
                && (null != $responsePurchaseCard_NoDelivery)
            ) {
                echo "=== Expected failure ===\n";
            }
        }
        catch (\TangoCard\Sdk\Service\TangoCardServiceException $e)
        {
            echo "\n=== Tango Card Service Failure ===";        
            echo "\nFailure response type: " . $e->getResponseType();
            echo "\nFailure response:      " . $e->getMessage();
            
            if ( $e->getResponseType() == \TangoCard\Sdk\Response\ServiceResponseEnum::toString(\TangoCard\Sdk\Response\ServiceResponseEnum::INS_FUNDS) ) {
                echo "\nAvailable Balance: " . $e->getResponse()->getAvailableBalance();
                echo "\nOrder Cost       : " . $e->getResponse()->getOrderCost();
            }
        }
        catch (\TangoCard\Sdk\Common\TangoCardSdkException $e)
        {
            echo "\n=== Tango Card SDK Failure ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
        catch (\RuntimeException $e)
        {
            echo "\n=== Runtime Exception Error ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
        catch (Exception $e)
        {
            echo "\n=== Unexpected Error ===\n\n";
            echo sprintf("%s: %s", get_class($e), $e->getMessage());
        }
    
        echo "\n\n======== End Purchase Card with Insufficient Funds ========\n\n\n";
    }
}

/**
 * Run Tango Card SDK failure request examples
 */
TangoCardSdk_Failures_Example::Run();