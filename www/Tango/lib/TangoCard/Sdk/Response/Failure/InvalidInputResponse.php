<?php
/**
 * InvalidInputResponse.php
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
 * @version     $Id: InvalidInputResponse.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */    

namespace TangoCard\Sdk\Response\Failure;

/**
 * This response type indicates that there was a problem with the inputs.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class InvalidInputResponse extends FailureResponse
{
    /**
     * @ignore
     */
    private $_invalid;
    
    /**
     * Construct a new InvalidInput failure type.
     * @param object $responseJson The parsed (JSON) object returned from the 
     *       Tango Card services.
     */
    public function __construct($responseJson)
    {
        $this->_invalid = $responseJson->invalid;
    }
    
    /**
     * Get the invalid inputs.
     * @return array An associative array of the invalid inputs where the 
     *        keys are the name of the invalid input and the values are a 
     *        message describing the problem.
     */
    public function getInvalid()
    {
        return $this->_invalid;
    }
    
    /**
     * Get error message for this failure response.
     * @return string
     */    
    public function getMessage()
    {
        $message = "Unknown.";
        if ( isset( $this->invalid->cardSku ) )
        {
           $message = $this->_invalid->cardSku;
        }
        else if ( isset( $this->invalid->username ) )
        {
           $message = $this->_invalid->username;
        }
        else if ( isset( $this->invalid->password ) )
        {
           $message = $this->_invalid->password;
        }
        else if ( isset( $this->invalid->inputs ) )
        {
           $message = $this->_invalid->inputs;
        }
        return sprintf("Invalid input: %s", $message);
    }
}
