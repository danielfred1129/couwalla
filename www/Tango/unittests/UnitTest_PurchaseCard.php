<?php
/**
 * UnitTest_PurchaseCard.php, Tango Card SDK PHPUnit Test
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
 * @package     Unittests
 * @version     $Id: UnitTest_PurchaseCard.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */

require_once dirname(__FILE__) . "/../lib/TangoCardSdkAutoloader.php";

/**
 * 
 * PHPUnit test for accessing Tango Card Service API's Version2/PurchaseCard() action.
 *
 */
class UnitTest_PurchaseCard extends PHPUnit_Framework_TestCase {

    /**
     * @ignore
     */
    protected $app_config;
    
    /**
     * 
     * Setup unit tests by parsing application configuration file.
     * @throws \TangoCardSdkException
     */
    protected function setUp() {        
        $this->app_config_file = dirname(__FILE__) . "/../config/app_config_example.ini";
        if (!file_exists($this->app_config_file)) {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException('The app_config_example.ini file is required.');
        }
        
        $this->app_config = parse_ini_file($this->app_config_file, 'TANGOCARD');
        if (null == $this->app_config) {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException('Unable to parse app_config_example.ini.');
        }
    }
    
    /**
     * 
     * Test access to application configuration file.
     */
    public function test_AppConfig() {
        $this->assertNotNull($this->app_config);
           
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
        
        $app_card_sku_example = $this->app_config['TANGOCARD']['app_card_sku_example'];        
        $this->assertEquals("tango-card", $app_card_sku_example);
        
        $this->assertNotNull($this->app_config['TANGOCARD']['app_username']);    // username
        $this->assertNotNull($this->app_config['TANGOCARD']['app_password']);    // password
    }    
    
    /**
     *  
     *  Unit Test for puchasing the Tango Card and requesting
     *  the Tango Card Service to send digital card to provided
     *  email address.
     * 
     */
    public function test_PurchaseCard_with_Delivery() {

        $app_username           = $this->app_config['TANGOCARD']['app_username'];
        $app_password           = $this->app_config['TANGOCARD']['app_password'];
        $app_card_sku_example           = $this->app_config['TANGOCARD']['app_card_sku_example'];
                
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
                  
        $cardValueTangoCardCents = 100; // $1.00 dollars
        $tango_cents_available_balance = 0;
        $tango_cents_updated_balance = 0;

        $responseGetAvailableBalance = null;
        try {
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $responseGetAvailableBalance
                            );
         } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
           
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responseGetAvailableBalance);
        $this->assertTrue(is_a($responseGetAvailableBalance, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse'));
        
        $tango_cents_available_balance = $responseGetAvailableBalance->getAvailableBalance();
        $this->assertGreaterThanOrEqual(0, $tango_cents_available_balance);
        
        try {    
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $app_card_sku_example,                          // cardSku
                            $cardValueTangoCardCents,               // cardValue
                            true,                                   // tcSend 
                            "Sally Example",                        // recipientName
                            "sally@example.com",                    // recipientEmail
                            "Happy Birthday",                       // giftMessage
                            "Bill Example",                         // giftFrom
                            null,                                   // companyIdentifier
                            $responsePurchaseCard                   // response
                            );
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
        
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responsePurchaseCard);
        $this->assertTrue(is_a($responsePurchaseCard, 'TangoCard\Sdk\Response\Success\PurchaseCardResponse'));

        $responseGetAvailableBalance = null;
        try {
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $responseGetAvailableBalance
                            );
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
            
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responseGetAvailableBalance);
        $this->assertTrue(is_a($responseGetAvailableBalance, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse'), get_class($responseGetAvailableBalance));
        
        $tango_cents_updated_balance = $responseGetAvailableBalance->getAvailableBalance();
        $this->assertGreaterThanOrEqual(0, $tango_cents_updated_balance);
                    
        $this->assertNotEquals( $tango_cents_available_balance, $tango_cents_updated_balance);
        $tango_cents_expected_balance = $tango_cents_available_balance - $cardValueTangoCardCents;
        $this->assertEquals( $tango_cents_expected_balance, $tango_cents_updated_balance);
    }
    
    /**
     *  
     *  Unit Test for puchasing the Tango Card and not requesting
     *  the Tango Card Service to send digital card.
     * 
     */
    public function test_PurchaseCard_noSend() {

        $app_username           = $this->app_config['TANGOCARD']['app_username'];
        $app_password           = $this->app_config['TANGOCARD']['app_password'];
        $app_card_sku_example           = $this->app_config['TANGOCARD']['app_card_sku_example'];
                
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
        
        $cardValueTangoCardCents = 100; // $1.00 dollars
        $tango_cents_available_balance = 0;
        $tango_cents_updated_balance = 0;

        $responseGetAvailableBalance = null;
        try {
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $responseGetAvailableBalance
                            );
         } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
           
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responseGetAvailableBalance);
        $this->assertTrue(is_a($responseGetAvailableBalance, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse'), get_class($responseGetAvailableBalance));
        
        $tango_cents_available_balance = $responseGetAvailableBalance->getAvailableBalance();
        $this->assertGreaterThanOrEqual(0, $tango_cents_available_balance);
        
        $responsePurchaseCard = null;
        try {    
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $app_card_sku_example,                          // cardSku
                            $cardValueTangoCardCents,               // cardValue
                            false,                                  // tcSend 
                            null,                                   // recipientName
                            null,                                   // recipientEmail
                            null,                                   // giftMessage
                            null,                                   // giftFrom
                            null,                                   // companyIdentifier
                            $responsePurchaseCard                   // response
                            );
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
            
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responsePurchaseCard);
        $this->assertTrue(is_a($responsePurchaseCard, 'TangoCard\Sdk\Response\Success\PurchaseCardResponse'), get_class($responsePurchaseCard));
        
        $responseGetAvailableBalance = null;
        try {
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::GetAvailableBalance(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            $responseGetAvailableBalance
                            );
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
        
        $this->assertTrue($isSuccess);
        $this->assertNotNull($responseGetAvailableBalance);
        $this->assertTrue(is_a($responseGetAvailableBalance, 'TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse'), get_class($responseGetAvailableBalance));

        $tango_cents_updated_balance = $responseGetAvailableBalance->getAvailableBalance();
        $this->assertGreaterThanOrEqual(0, $tango_cents_updated_balance);
                   
        $this->assertNotEquals( $tango_cents_available_balance, $tango_cents_updated_balance);
        $tango_cents_expected_balance = $tango_cents_available_balance - $cardValueTangoCardCents;
        $this->assertEquals( $tango_cents_expected_balance, $tango_cents_updated_balance);
    }
    
    /**
     *  
     *  Unit test to assure failure when trying to purchase a card
     *  with invalid authentication credentials
     * 
     */
    public function test_PurchaseCard_InvalidCredentials() {

        $username = "burt@example.com"; 
        $password = "password";
        
        $app_card_sku_example           = $this->app_config['TANGOCARD']['app_card_sku_example'];
                
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
                 
        $cardValueTangoCardCents = 100; // $1.00 dollars
        $tango_cents_available_balance = 0;
        $tango_cents_updated_balance = 0;
        
        $isSuccess = false;        
        $responsePurchaseCard = null;            
        try {    
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                            $enumTangoCardServiceApi,
                            $username, 
                            $password,
                            $app_card_sku_example,                          // cardSku
                            $cardValueTangoCardCents,               // cardValue
                            false,                                  // tcSend 
                            null,                                   // recipientName
                            null,                                   // recipientEmail
                            null,                                   // giftMessage
                            null,                                   // giftFrom
                            null,                                   // companyIdentifier
                            $responsePurchaseCard                   // response
                            );
            
            $this->fail("Failed to throw TangoCardServiceException");

        } catch ( TangoCard\Sdk\Service\TangoCardServiceException $e) {
            $this->assertTrue( "INV_CREDENTIAL" == $e->getResponseType() );            
            $message = $e->getMessage();
            $this->assertNotNull($message);
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
        
        $this->assertFalse($isSuccess);  
        $this->assertNull($responsePurchaseCard);         
    }
    
    /**
     *  
     *  Unit test to assure failure when trying to purchase a card
     *  from an account with insufficient funds.
     * 
     */
    public function test_PurchaseCard_InsufficientFunds() {

        $username = "empty@tangocard.com";
        $password = "password"; 

        $app_card_sku_example           = $this->app_config['TANGOCARD']['app_card_sku_example']; 
                
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
        
        $cardValueTangoCardCents = 100; // $1.00 dollars
        $tango_cents_available_balance = 0;
        $tango_cents_updated_balance = 0;
        
        $isSuccess = false;     
        $responsePurchaseCard = null;               
        try {    
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                            $enumTangoCardServiceApi,
                            $username, 
                            $password,
                            $app_card_sku_example,                          // cardSku
                            $cardValueTangoCardCents,               // cardValue
                            false,                                  // tcSend 
                            null,                                   // recipientName
                            null,                                   // recipientEmail
                            null,                                   // giftMessage
                            null,                                   // giftFrom
                            null,                                   // companyIdentifier
                            $responsePurchaseCard                   // response
                            );
            
            $this->fail("Failed to throw TangoCardServiceException");

        } catch ( TangoCard\Sdk\Service\TangoCardServiceException $e) {
            $this->assertTrue( "INS_FUNDS" == $e->getResponseType() );            
            $message = $e->getMessage();
            $this->assertNotNull($message);
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
        
        $this->assertFalse($isSuccess);  
        $this->assertNull($responsePurchaseCard);     
    }
    
    /**
     *  
     *  Unit test to assure failure when purchasing a gift card
     *  with an invalid card sku.
     * 
     */
    public function test_PurchaseCard_InvalidInput_Sku() {

        $app_username           = $this->app_config['TANGOCARD']['app_username'];
        $app_password           = $this->app_config['TANGOCARD']['app_password'];
        $app_card_sku_example           = $this->app_config['TANGOCARD']['app_card_sku_example'];
                
        $app_tango_card_service_api = $this->app_config['TANGOCARD']['app_tango_card_service_api'];      
        $enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toEnum($app_tango_card_service_api);
        $this->assertTrue( \TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) );   
         
        $cardValueTangoCardCents = 100; // $1.00 dollars
        $tango_cents_available_balance = 0;
        $tango_cents_updated_balance = 0;
        
        $isSuccess = false;
        $responsePurchaseCard = null;                    
        try {    
            $isSuccess = \TangoCard\Sdk\TangoCardServiceApi::PurchaseCard(
                            $enumTangoCardServiceApi,
                            $app_username, 
                            $app_password,
                            "mango-card",                           // cardSku
                            $cardValueTangoCardCents,               // cardValue
                            false,                                  // tcSend 
                            null,                                   // recipientName
                            null,                                   // recipientEmail
                            null,                                   // giftMessage
                            null,                                   // giftFrom
                            null,                                   // companyIdentifier
                            $responsePurchaseCard                   // response
                            );
            
            $this->fail("Failed to throw TangoCardServiceException");

        } catch ( TangoCard\Sdk\Service\TangoCardServiceException $e) {
            $this->assertTrue( "INV_INPUT" == $e->getResponseType() );
            $message = $e->getMessage();
            $this->assertNotNull($message);
        } catch ( Exception $e ) {
            $this->fail($e->getMessage());
        }
        
        $this->assertFalse($isSuccess);
        $this->assertNull($responsePurchaseCard);       
    }
}
