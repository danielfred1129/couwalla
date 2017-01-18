<?php
/**
 * BaseRequest.php.
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
 * @version     $Id: BaseRequest.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Request;

/**
 * BaseRequest provides the basic interface for all the possible request types.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
abstract class BaseRequest 
{   
    /**
     * 
     * Username
     * @var string
     */
    private $_username = null;
    /**
     * 
     * Password
     * @var string
     */
    private $_password = null;

    /**
     * 
     * Tango Card Service API environment selection
     * @var \TangoCard\Sdk\Service\TangoCardServiceApiEnum
     */
    private $_enumTangoCardServiceApi = \TangoCard\Sdk\Service\TangoCardServiceApiEnum::UNDEFINED;
    
    /**
     * 
     * Get controller action for this request.
     * 
     * @return string
     */
    abstract public function getRequestAction();
    
    /**
     * 
     * Get JSON mapped and encoded request body.
     * 
     * @param object $requestJsonEncoded
     */
    abstract public function getJsonEncodedRequest(&$requestJsonEncoded);
             
    /**
     * Construct a new abstract request object.
     * 
     * @param \TangoCard\Sdk\Service\TangoCardServiceApiEnum   $enumTangoCardServiceApi Selection of which Tango Card Service API environment
     * @param string                                           $username Tango Card Service access username
     * @param string                                           $password Tango Card Service access password
     * 
     * @throws InvalidArgumentException One of the supplied arguments was 
     *        not in the expected state.
     *        
     * @access public
     */
    function __construct(
        $enumTangoCardServiceApi,
        $username,
        $password
        ) 
    {
        // -----------------------------------------------------------------
        // validate inputs
        // -----------------------------------------------------------------
        // isProductionMode
        if ( !\TangoCard\Sdk\Service\TangoCardServiceApiEnum::isValid($enumTangoCardServiceApi) ) {
            throw new \InvalidArgumentException("Parameter 'enumTangoCardServiceApi' must be TangoCardServiceApiEnum.");
        }
        // username
        if ( is_null($username) ) {
            throw new \InvalidArgumentException("Parameter 'username' is not defined.");
        }
        if (!is_string($username)) {
            throw new \InvalidArgumentException("Parameter 'username' must be a string.");
        } 
        // password
        if ( is_null($password) ) {
            throw new \InvalidArgumentException("Parameter 'password' is not defined.");
        }
        if (!is_string($password)) {
            throw new \InvalidArgumentException("Parameter 'password' must be a string.");
        }
               
        $this->_enumTangoCardServiceApi = $enumTangoCardServiceApi;
        $this->_username = $username;
        $this->_password = $password;
    }
    
    
    /**
     * 
     * Get username property
     */
    public function getUsername()
    {
        return $this->_username;
    }

    /**
     * 
     * Set username property
     * @param string $username
     */
    public function setUsername( $username )
    {
        $this->_username = $username;
    }

    /**
     * 
     * Get password property
     */
    public function getPassword()
    {
        return $this->_password;
    }
    
    /**
     * 
     * Set password property
     * @param $password
     */
    public function setPassword( $password )
    {
        $this->_password = $password;
    }

    /**
     * 
     * Get TangoCardServiceApiEnum property
     * @return TangoCardServiceApiEnum
     */
    public function getTangoCardServiceApiEnum()
    {
        return $this->_enumTangoCardServiceApi;
    }
    
    /**
     * 
     * Set TangoCardServiceApiEnum property
     * @param TangoCard\Sdk\Service\TangoCardServiceApiEnum $enumTangoCardServiceApi
     */
    public function setTangoCardServiceApiEnum($enumTangoCardServiceApi)
    {
        $this->_enumTangoCardServiceApi = $enumTangoCardServiceApi;
    }
    
    /**
     * 
     * Execute request
     * 
     * @param \TangoCard\Sdk\Response\Success\SuccessResponse $response
     * 
     * @return True upon success, else False
     */
    public function execute(&$response)
    {
        $proxy = new \TangoCard\Sdk\Service\ServiceProxy($this);
        return $proxy->executeRequest($response);
    }
}