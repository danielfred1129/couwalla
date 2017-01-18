<?php
/**
 * InsufficientFundsResponse.php
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
 * @version     $Id: InsufficientFundsResponse.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */  

namespace TangoCard\Sdk\Response\Failure;

/**
 * This response type indicates that the authenticated account did not have 
 * sufficient funds available to make the purchase.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class InsufficientFundsResponse extends FailureResponse
{
    /**
     * @ignore
     */
    private $_availableBalance;
    
    /**
     * @ignore
     */
    private $_orderCost;
    
    /**
     * Construct a new InsufficientFunds failure type.
     * @param object $responseJson The parsed (JSON) object returned from the 
     *       Tango Card services.
     */
    public function __construct($responseJson)
    {
        $this->_availableBalance = $responseJson->availableBalance;
        $this->_orderCost        = $responseJson->orderCost;
    }
    
    /**
     * Get the funds available (in cents) to the authenticated account.
     * @return int The funds available to the user.
     */
    public function getAvailableBalance()
    {
        return (int)$this->_availableBalance;
    }
    
    /**
     * Get the final cost of the order, were it processed.
     * @return int The order cost.
     */
    public function getOrderCost()
    {
        return (int)$this->_orderCost;
    }
    
    /**
     * Get error message for this failure response.
     * @return string
     */    
    public function getMessage()
    {
        return sprintf("Available Balance: %s, Order Cost: %s", $this->_availableBalance, $this->_orderCost);
    }
}
