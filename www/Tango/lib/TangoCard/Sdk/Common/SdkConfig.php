<?php
/**
 * Configuration file parser SdkConfig.php
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
 * @version     $Id: SdkConfig.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Common;

/**
 * SdkConfig reads configuration file config/tc_sdk_config.ini
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
class SdkConfig
{
    /**
     * 
     * SDK Config file path
     * @var string
     */
    private $_tc_sdk_config_file = null;
    /**
     * 
     * Parsed SDK config file's contents
     * @var array
     */
    private $_tc_sdk_config = null;
    
    /**
     * 
     * Constructs by reading the SDK configuration settings from tc_sdk_config.ini.
     *  
     * @throws \TangoCardSdkException
     * @throws Exception
     * 
     * @access private
     */
    private function __construct()
    { 
        $this->_tc_sdk_config_file = dirname(dirname(dirname(__FILE__))) . "/config/tc_sdk_config.ini";
        if (!file_exists($this->_tc_sdk_config_file)) {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException('The tc_sdk_config.ini file is required: ' . $this->_tc_sdk_config_file );
        }
                        
        try {
            $this->_tc_sdk_config = parse_ini_file($this->_tc_sdk_config_file, 'TANGOCARD');
			//print_r($this->_tc_sdk_config);
        } catch (Exception $e) {
            throw new Exception("Error reading tc_sdk_config.ini", 0, $e);
        }
        
        if (null == $this->_tc_sdk_config ) {
            throw new Exception( "Reference to '_tc_sdk_config' is null.");
        }
    }
    
    /**
     * 
     * Reads configuration setting for provided key.
     * 
     * @param string $key
     * 
     * @throws Exception
     */
    public function getConfigValue($key)
    {
        if ( null == $this->_tc_sdk_config ) {
            throw new Exception( "Reference to '_tc_sdk_config' is null.");
        }
        if ( Helper::isNullOrEmptyString($key) ) {
            throw new Exception( "Parameter 'key' is null."); 
        }
		//echo $this->_tc_sdk_config['TANGOCARD'][$key]; ;
		
        return $this->_tc_sdk_config['TANGOCARD'][$key];    
    }
    
    /**
     * 
     * Returns a singleton instance.
     * 
     * @return \TangoCard\Sdk\Common\SdkConfig
     */
    public static function &getInstance ()
    {
        static $instance;
        
        if (!isset($instance)) {
            $c = __CLASS__;
            $instance = new $c;
        } // if
        //print_r($instance);
		//exit;
        return $instance;
        
    } // getInstance
}