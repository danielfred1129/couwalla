<?php
/**
 * PurchaseCardRequest.php
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
 * @version     $Id: PurchaseCardRequest.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */  

namespace TangoCard\Sdk\Request;

/**
 * PurchaseCardRequest purchases a card using a user account.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class PurchaseCardRequest extends BaseRequest
{
    /**
     * @ignore
     */
    private $_card_sku = null;
    
    /**
     * @ignore
     */
    private $_card_value = 0;
    
    /**
     * @ignore
     */
    private $_tc_send = false;
    
    /**
     * @ignore
     */
    private $_recipient_name = null;
    
    /**
     * @ignore
     */
    private $_recipient_email = null;
    
    /**
     * @ignore
     */
    private $_gift_message = null;
    
    /**
     * @ignore
     */
    private $_gift_from = null;
    
    /**
     * @ignore
     */
    private $_company_identifier = null;
    
    /**
     * Set up a new PurchaseCard request.
     * 
     * @param \TangoCard\Sdk\Service\TangoCardServiceApiEnum   $enumTangoCardServiceApi Selection of which Tango Card Service API environment
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
     * @param string $companyIdentifier The Company identifier for which Email Template when sending Gift Card. Optional 
     *       if tcSend = true. If tcSend = false, then this input will be 
     *       ignored.
     *       
     * @throws \InvalidArgumentException One of the supplied arguments was 
     *        not in the expected state.
     */
    function __construct(
        $enumTangoCardServiceApi,
        $username,
        $password,
        $cardSku,
        $cardValue,
        $tcSend,
        $recipientName = null,
        $recipientEmail = null,
        $giftMessage = null,
        $giftFrom = null,
        $companyIdentifier = null
    ) {      
        // parent construct
        parent::__construct($enumTangoCardServiceApi, $username, $password);
        
        // -----------------------------------------------------------------
        // validate inputs
        // ----------------------------------------------------------------- 
     
        // cardSku
        if (!is_string($cardSku)) {
            throw new \InvalidArgumentException("Parameter 'cardSku' must be a string.");
        }
        if (strlen($cardSku) < 1) {
            throw new \InvalidArgumentException("Parameter 'cardSku' must have a length greater than zero.");
        }
        if (strlen($cardSku) > 255) {
            throw new \InvalidArgumentException("Parameter 'cardSku' must have a length less than 255.");
        }
        
        // cardValue
        if (!is_int($cardValue)) {
            throw new \InvalidArgumentException("Parameter 'cardValue' must be an integer.");
        }
        if ($cardValue < 1) {
            throw new \InvalidArgumentException("Parameter 'cardValue' must have a value which is greater than or equal to 1.");
        }   
        
        // tcSend
        if (!is_bool($tcSend)) {
            throw new \InvalidArgumentException("Parameter 'tcSend' must be a boolean.");
        }
        
        // all of the inputs that are conditional on tcSend
        if ($tcSend) {
        
            // recipientName
            if (is_null($recipientName)) {
                throw new \InvalidArgumentException("Parameter 'recipientName' must be present (not null) if tcSend is set to true.");
            }
            if (!is_string($recipientName)) {
                throw new \InvalidArgumentException("Parameter 'recipientName' must be a string.");
            } 
            if (strlen($recipientName) < 1) {
                throw new \InvalidArgumentException("Parameter 'recipientName' must have a length greater than zero.");
            }
            if (strlen($recipientName) > 255) {
                throw new \InvalidArgumentException("Parameter 'recipientName' must have a length less than 256.");
            }

            // recipientEmail
            if (is_null($recipientEmail)) {
                throw new \InvalidArgumentException("Parameter 'recipientEmail' must be present (not null) if tcSend is set to true.");
            }
            if (!is_string($recipientEmail)) {
                throw new \InvalidArgumentException("Parameter 'recipientEmail' must be a string.");
            } 
            if (strlen($recipientEmail) < 3) {
                throw new \InvalidArgumentException("Parameter 'recipientEmail' must have a length greater than two.");
            }
            if (strlen($recipientEmail) > 255) {
                throw new \InvalidArgumentException("Parameter 'recipientEmail' must have a length less than 256.");
            }

            // giftFrom
            if (is_null($giftFrom)) {
                throw new \InvalidArgumentException("Parameter 'giftFrom' must be present (not null) if tcSend is set to true.");
            }
            if (!is_string($giftFrom)) {
                throw new \InvalidArgumentException("Parameter 'giftFrom' must be a string.");
            } 
            if (strlen($giftFrom) < 1) {
                throw new \InvalidArgumentException("Parameter 'giftFrom' must have a length greater than zero.");
            }
            if (strlen($giftFrom) > 255) {
                throw new \InvalidArgumentException("Parameter 'giftFrom' must have a length less than 256.");
            }

            // giftMessage
            if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($giftMessage) ) {
                if (strlen($giftMessage) > 255) {
                    throw new \InvalidArgumentException("Parameter 'giftMessage' must have a length less than 256.");
                }
            }

            // companyIdentifier
            if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($companyIdentifier) ) {
                if (strlen($companyIdentifier) > 255) {
                    throw new \InvalidArgumentException("Parameter 'companyIdentifier' must have a length less than 256.");
                }
            }
        }
        
        // -----------------------------------------------------------------
        // save inputs
        // -----------------------------------------------------------------

        $this->_card_sku   = $cardSku;
        $this->_card_value = $cardValue;
        $this->_tc_send    = $tcSend;
        if ($tcSend) {
            
            $app_tango_card_service_api = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::PRODUCTION != $enumTangoCardServiceApi ? \TangoCard\Sdk\Service\TangoCardServiceApiEnum::toString($enumTangoCardServiceApi) : null;
            $this->_recipient_name  = $recipientName; 
            $this->_recipient_email = $recipientEmail;
            $this->_gift_from       = $giftFrom;
            if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($giftMessage) ) {
                $this->_gift_message    = is_null($app_tango_card_service_api) ? $giftMessage : sprintf("*** Tango Card (%s) Test ***\n%s", strtolower($app_tango_card_service_api), $giftMessage);
            }
            if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($companyIdentifier) ) {
                $this->_company_identifier    = $companyIdentifier;
            }
        }
    }
        
    /**
     * 
     * Execute request
     * 
     * @param \TangoCard\Sdk\Response\Success\PurchaseCardResponse $response
     * 
     * @return True upon success, else False
     * 
     * (non-PHPdoc)
     * @see src/TangoCard/Sdk/Request/TangoCard\Sdk\Request.BaseRequest::execute()
     */
    public function execute(&$response) 
    {        
        return parent::execute($response);
    }
    
    /**
     * (non-PHPdoc)
     * @see src/TangoCard/Sdk/Request/TangoCard\Sdk\Request.BaseRequest::getRequestAction()
     */
    public function getRequestAction()
    {
        return "PurchaseCard";
    }
    
    /**
     * 
     * JSON representation of a PurchaseCard Request
     * 
     * @param string &$requestJsonEncoded
     * 
     * @return True upon success, else False
     *
     * (non-PHPdoc)
     * @see src/TangoCard/Sdk/Request/TangoCard\Sdk\Request.BaseRequest::getJsonEncodedRequest()
     */
    public function getJsonEncodedRequest(&$requestJsonEncoded)
    {
        $isSuccess = true;
        $requestJsonEncoded = null;
        try 
        {           
            $request = array();
            
            $request['username' ] = parent::getUsername();
            $request['password' ] = parent::getPassword();
            $request['cardSku'  ] = $this->_card_sku;
            $request['cardValue'] = $this->_card_value;
            $request['tcSend'   ] = $this->_tc_send;                                     
            
            if ($this->_tc_send) {
                $request['recipientName' ] = $this->_recipient_name;
                $request['recipientEmail'] = $this->_recipient_email;           
                $request['giftFrom'      ] = $this->_gift_from;
                if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($this->_gift_message) ) {
                    $request['giftMessage'] = $this->_gift_message;
                }
                if ( !\TangoCard\Sdk\Common\Helper::isNullOrEmptyString($this->_company_identifier) ) {
                    $request['companyIdentifier'] = $this->_company_identifier;
                }
            }
            
            // encode the request as a JSON object
            $requestJsonEncoded = json_encode($request);
            $isSuccess = true;
        }
        catch (Exception $e)
        {
            throw $e;
        }
        
        return $isSuccess;
    }
}