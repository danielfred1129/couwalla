<?php
/**
 * ServiceResponseEnum.php
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
 * @version     $Id: ServiceResponseEnum.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Response;

/**
 * Enumeration of expected response types from Tango Card Service API.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class ServiceResponseEnum
{
    /**
     * 
     * Undefined response
     * @var int
     */
    const UNDEFINED = 0;  
      
    /**
     * 
     * Success.
     * @var int
     */
    const SUCCESS = 1;
    /**
     * 
     * Failure - Insufficient Funds.
     * @var int
     */
    const INS_FUNDS = 2;
    
    /**
     * 
     * Failure - Invalid Credentials 
     * @var int
     */
    const INV_CREDENTIAL = 3;
    
    /**
     * 
     * Failure - Invalid Input 
     * @var int
     */
    const INV_INPUT = 4;
    
    /**
     * 
     * Failure - Insufficient Inventory
     * @var int
     */
    const INS_INV = 5;
    
    /**
     * 
     * Failure - Service System Error
     * @var int
     */
    const SYS_ERROR = 6;
    
    /**
     * 
     * TangoCard\Sdk\Response\ServiceResponseEnum to String
     * @var array
     */
    private static $_arrayToString 
        = array (
            ServiceResponseEnum::UNDEFINED => "UNDEFINED",
            ServiceResponseEnum::SUCCESS => "SUCCESS",
            ServiceResponseEnum::INS_FUNDS => "INS_FUNDS",
            ServiceResponseEnum::INV_CREDENTIAL => "INV_CREDENTIAL",
            ServiceResponseEnum::INV_INPUT => "INV_INPUT",
            ServiceResponseEnum::INS_INV => "INS_INV",
            ServiceResponseEnum::SYS_ERROR => "SYS_ERROR",
        ); 
        
    /**
     * 
     * String to TangoCard\Sdk\Response\ServiceResponseEnum
     * @var array
     */
    private static $_arrayToEnum 
        = array (
            "UNDEFINED" => ServiceResponseEnum::UNDEFINED,
            "SUCCESS" => ServiceResponseEnum::SUCCESS,
            "INS_FUNDS" => ServiceResponseEnum::INS_FUNDS,
            "INV_CREDENTIAL" => ServiceResponseEnum::INV_CREDENTIAL,
            "INV_INPUT" => ServiceResponseEnum::INV_INPUT,
            "INS_INV" => ServiceResponseEnum::INS_INV,
            "SYS_ERROR" => ServiceResponseEnum::SYS_ERROR,
        ); 
    
    /**
     * 
     * String value of response type.
     * @param TangoCard\Sdk\Response\ServiceResponseEnum $enumResponseType
     * @return string
     */
    public static function toString($enumResponseType)
    {
        if ( array_key_exists( $enumResponseType, ServiceResponseEnum::$_arrayToString ))
        {
            return ServiceResponseEnum::$_arrayToString[$enumResponseType];
        }
        
        throw new \TangoCard\Sdk\Common\TangoCardSdkException("Unexpected enumeration: " . $enumResponseType);
    }
    
    /**
     * 
     * Enum value of response type.
     * @param string $strResponseType
     * @throws \TangoCard\Sdk\Common\TangoCardSdkException
     */
    public static function toEnum($strResponseType)
    {
        if ( array_key_exists( $strResponseType, ServiceResponseEnum::$_arrayToEnum ))
        {
            return ServiceResponseEnum::$_arrayToEnum[$strResponseType];
        }
        
        throw new \TangoCard\Sdk\Common\TangoCardSdkException("Unexpected enumeration: " . $strResponseType);
    }
}