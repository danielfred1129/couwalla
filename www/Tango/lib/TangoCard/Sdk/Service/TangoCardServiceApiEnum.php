<?php
/**
 * TangoCardServiceApiEnum.php
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
 * @version     $Id: TangoCardServiceApiEnum.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Service;

/**
 * Enumeration of possible endpoint environments that provide Tango Card Service API.
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class TangoCardServiceApiEnum
{
    /**
     * 
     * Undefined service
     * @var int
     */
    const UNDEFINED = 0;
    
    /**
     * 
     * Integration Tango Card Service API.
     * @var int
     */
    const INTEGRATION = 1;
    
    /**
     * 
     * Production Tango Card Service API.
     * @var int
     */
    const PRODUCTION = 2;
	
    
    /**
     * 
     * Production Tango Card Service API.
     * @var int
     */
    const QA = 3;
    
    /**
     * 
     * TangoCard\Sdk\Service\TangoCardServiceApiEnum to String
     * @var array
     */
    private static $_arrayToString 
        = array (
            TangoCardServiceApiEnum::UNDEFINED => "UNDEFINED",
            TangoCardServiceApiEnum::INTEGRATION => "INTEGRATION",
            TangoCardServiceApiEnum::PRODUCTION => "PRODUCTION",
            TangoCardServiceApiEnum::QA => "QA",
        ); 
        
    /**
     * 
     * String to TangoCard\Sdk\Service\TangoCardServiceApiEnum
     * @var array
     */
    private static $_arrayToEnum 
        = array (
            "UNDEFINED" => TangoCardServiceApiEnum::UNDEFINED,
            "INTEGRATION" => TangoCardServiceApiEnum::INTEGRATION,
            "PRODUCTION" => TangoCardServiceApiEnum::PRODUCTION,
            "QA" => TangoCardServiceApiEnum::QA,
        );  

    /**
     * 
     * Determine if enum is a valid service api environment type
     * @param unknown_type $enumServiceType
     */
    public static function isValid($enumServiceType) {
        return array_key_exists($enumServiceType, TangoCardServiceApiEnum::$_arrayToString );
    }
    
    /**
     * 
     * String value of response type.
     * @param TangoCard\Sdk\Service\TangoCardServiceApiEnum $enumServiceType
     * @return string
     */
    public static function toString($enumServiceType)
    {
        if ( array_key_exists( $enumServiceType, TangoCardServiceApiEnum::$_arrayToString ))
        {
            return TangoCardServiceApiEnum::$_arrayToString[$enumServiceType];
        }
        
        throw new \TangoCard\Sdk\Common\TangoCardSdkException("Unexpected enumeration: " . $enumServiceType . "\n");
    }
    
    /**
     * 
     * Enum value of response type.
     * @param string $strServiceType
     * @throws \TangoCard\Sdk\Common\TangoCardSdkException
     */
    public static function toEnum($strServiceType)
    {
        if ( array_key_exists( $strServiceType, TangoCardServiceApiEnum::$_arrayToEnum ))
        {
            return TangoCardServiceApiEnum::$_arrayToEnum[$strServiceType];
        }

		$message = "Unexpected enumeration: " . $strServiceType . "\n";
        throw new \TangoCard\Sdk\Common\TangoCardSdkException($message);
    }
}