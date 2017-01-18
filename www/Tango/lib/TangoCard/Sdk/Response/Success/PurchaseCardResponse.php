<?php
/**
 * PurchaseCardResponse.php
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
 * @version     $Id: PurchaseCardResponse.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Response\Success;

/**
 * The successful response to a {@link TangoCard\Sdk\Request\PurchaseCard} 
 * request.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class PurchaseCardResponse extends SuccessResponse
{
    /**
     * @var Confirmation number of purchase.
     */
    private $_referenceOrderId;
    
    /**
     * @var Card reference to the aforementioned purchase.
     */
    private $_cardToken;
    
    /**
     * @var Card number provided to the recipient to be used at redemption upon the 
     * www.tangocard.com site.
     */
    private $_cardNumber = null;
    
    /**
     * @var Card pin provided to the recipient used to validate provided Card number 
     * a redemption upon the www.tangocard.com site.
     */
    private $_cardPin = null;
    
    /**
     * @var It is the address of a web page on the World Wide Web. This URL can only 
     * be accessed through the email you received. It is a unique URL, meaning that 
     * it cannot be duplicated or altered.
     */
    private $_claimUrl = null;
    
    /**
     * @var Depending on the retailer, some eGift Cards Challenge Key in order to be 
     * accessed; if that is the case you will find it next to your link or URL. You 
     * will be prompted to input your Challenge Key when you try to open your eGift 
     * Card.
     */
    private $_challengeKey = null;
    
    
    /**
     * @var Depending on the retailer, 
     */
    private $_eventNumber = null;
    
    /**
     * Construct a new PurchaseCard success type.
     * @param object $responseJson The parsed (JSON) object returned from the 
     *       Tango Card services.
     */
    public function __construct($responseJson)
    {
    	/* print_r($responseJson); */
    	
        $this->_referenceOrderId = $responseJson->referenceOrderId;
        $this->_cardToken        = $responseJson->cardToken;
        
        if (property_exists($responseJson, 'cardNumber')) {
            $this->_cardNumber = $responseJson->cardNumber;
        }
        if (property_exists($responseJson, 'cardPin')) {
            $this->_cardPin = $responseJson->cardPin;
        }
        if (property_exists($responseJson, 'claimUrl')) {
            $this->_claimUrl = $responseJson->claimUrl;
        }
        if (property_exists($responseJson, 'challengeKey')) {
            $this->_challengeKey = $responseJson->challengeKey;
        }
        if (property_exists($responseJson, 'eventNumber')) {
            $this->_eventNumber = $responseJson->eventNumber;
        }
    }
    
    /**
     * Get the reference order id. This id can be used (by Tango Card) to 
     * look up the order at a later date.
     * @return string The reference order id.
     */
    public function getReferenceOrderId()
    {
        return $this->_referenceOrderId;
    }
    
    /**
     * Get the card's token. This token can be used (by Tango Card) to 
     * look up a card at a later date.
     * @return string The card's token.
     */
    public function getCardToken()
    {
        return $this->_cardToken;
    }
    
    /**
     * Get the card's number (if available).
     * @return string|null The card's number or null. This will only be 
     *        set if the original request had tcSend set to false.
     */
    public function getCardNumber()
    {
        return $this->_cardNumber;
    }
    
    /**
     * Get the card's pin (if available).
     * @return string|null The card's pin or null. This will only be set 
     *        if the original request had tcSend set to false and the 
     *        card type requires a pin.
     */
    public function getCardPin()
    {
        return $this->_cardPin;
    }
    
    /**
     * Get the card's claim URL (if available).
     * @return string|null.
     */
    public function getClaimUrl()
    {
        return $this->_claimUrl;
    }
    
    
    /**
     * Get the card's challenge key (if available).
     * @return string|null.
     */
    public function getChallengeKey()
    {
        return $this->_challengeKey;
    }
    
    /**
     * Get the card's event number (if available).
     * @return string|null.
     */
    public function getEventNumber()
    {
        return $this->_eventNumber;
    }
}
