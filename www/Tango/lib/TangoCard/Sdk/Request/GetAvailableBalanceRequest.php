<?php
/**
 * GetAvailableBalanceRequest.php
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
 * @version     $Id: GetAvailableBalanceRequest.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */  

namespace TangoCard\Sdk\Request;

/**
 * GetAvailableBalanceRequest gets the available balance for a user account.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class GetAvailableBalanceRequest extends BaseRequest
{    
    /**
     * Set up a new GetAvailableBalance request.
     *
     * @param \TangoCard\Sdk\Service\TangoCardServiceApiEnum   $enumTangoCardServiceApi Selection of which Tango Card Service API environment
     * @param string $username The username to access User's registered Tango Card account
     * @param string $password The password to access User's registered Tango Card account
     */
    public function __construct(
        $enumTangoCardServiceApi,
        $username,
        $password
        ) 
    {    
        // parent construct
        parent::__construct($enumTangoCardServiceApi, $username, $password);
    }

    /**
     * 
     * Execute request
     * 
     * @param \TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse &$response
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
        return "GetAvailableBalance";
    }

    /**
     * 
     * JSON representation of a GetAvailableBalance Request
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
            $request = array(
                'username'  => parent::getUsername(),
                'password'  => parent::getPassword()
            );
            
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