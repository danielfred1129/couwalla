<?php
/**
 * InsufficientInventoryResponse.php
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
 * @version     $Id: InsufficientInventoryResponse.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */   

namespace TangoCard\Sdk\Response\Failure;

/**
 * This response type indicates that the item was not available for purchase 
 * due to there not being enough available inventory.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class InsufficientInventoryResponse extends FailureResponse
{
    /**
     * @ignore
     */
    private $_sku;
    
    /**
     * @ignore
     */
    private $_value;
    
    /**
     * Construct a new InsufficientInventory failure type.
     * @param object $responseJson The parsed (JSON) object returned from the 
     *       Tango Card services.
     */
    public function __construct($responseJson)
    {
        $this->_sku   = $responseJson->sku;
        $this->_value = (int)$responseJson->value;
    }
    
    /**
     * Get the SKU that was requested.
     * @return string The requested sku.
     */
    public function getSku()
    {
        return $this->_sku;
    }
    
    /**
     * Get the value that was requested.
     * @return int The requested card value (in cents).
     */
    public function getValue()
    {
        return $this->_value;
    }
    
    /**
     * Get error message for this failure response.
     * @return string
     */    
    public function getMessage()
    {
        return sprintf("SKU: %s, Value: %s", $this->_sku, $this->_value);
    }
}
