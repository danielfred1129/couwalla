<?php
/**
 * ServiceProxy.php
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
 * @version     $Id: ServiceProxy.php 2013-03-08 12:00:00 PST $
 * @copyright   Copyright (c) 2013, Tango Card (http://www.tangocard.com)
 * 
 */ 

namespace TangoCard\Sdk\Service;

/**
 * Proxy to the Tango Card Service
 *
 * @package TangoCard_PHP_SDK
 * @access  public
 */
use TangoCard\Sdk\Common\TangoCardSdkException;

/**
 * 
 * HTTP POST connection class to Tango Card Service API environment.
 *
 */
class ServiceProxy
{
    /**
     * 
     * Base URL
     * @var string
     */
    private $_base_url = null;
    /**
     * 
     * Controller
     * @var string
     */
    private $_controller = null;
    /**
     * 
     * Action
     * @var string
     */
    private $_action = null;
    /**
     * 
     * Full request path
     * @var string
     */
    private $_path = null;
    /**
     * 
     * Action request
     * @var JSON Object
     */
    private $_request_json = null;
    /**
     * 
     * Requesting object
     * @var BaseRequest
     */
    private $_requestObject = null;

    /**
     * Constructor
     *
     * @param \TangoCard\Sdk\Request\BaseRequest $requestObject reference
     * 
     * @return bool   Return true upon success, else false.
     * 
     * @access public
     * 
     * @throws \InvalidArgumentException
     */
    public function __construct( $requestObject ) 
    {
        if ( is_null($requestObject) ) {
            throw new \InvalidArgumentException("Parameter 'requestObject' is not set.");
        }
        
        try  {
            $this->_requestObject = $requestObject;
            
            $appConfig = \TangoCard\Sdk\Common\SdkConfig::getInstance();
            
            $this->_base_url = null;
            $enumAPI = $requestObject->getTangoCardServiceApiEnum();
            
            switch ( $enumAPI )
            {
                case \TangoCard\Sdk\Service\TangoCardServiceApiEnum::INTEGRATION:
                    $this->_base_url = $appConfig->getConfigValue("tc_sdk_environment_integration_url");
					
                    break;
                
                case \TangoCard\Sdk\Service\TangoCardServiceApiEnum::PRODUCTION:
                    $this->_base_url = $appConfig->getConfigValue("tc_sdk_environment_production_url");
                    break;
                
                case \TangoCard\Sdk\Service\TangoCardServiceApiEnum::QA:
                    $this->_base_url = $appConfig->getConfigValue("tc_sdk_environment_qa_url");
                    break;
                    
                default:
                    throw new \TangoCard\Sdk\Common\TangoCardSdkException( "Unexpected Tango Card Service API request: " . $enumAPI);
            }
            
            $this->_controller = $appConfig->getConfigValue("tc_sdk_controller");
			//echo $this->_controller;
            $this->_action = $requestObject->getRequestAction();
            $this->_path = sprintf("%s/%s/%s", $this->_base_url, $this->_controller, $this->_action); 
			echo $this->_path;
			//exit;
        } 
        catch (Exception $e) 
        {
            throw $e;
        }
    }

    /**
     * Map request by encoding JSON paramters.
     * 
     * @return bool   Return true upon success, else false.
     * 
     * @access protected
     */
    protected function mapRequest()
    {
        $isSuccess = false;
        try
        {
            $requestJsonEncoded = null;
            if ($this->_requestObject->getJsonEncodedRequest($requestJsonEncoded) 
                && (null != $requestJsonEncoded)
            ) {
                $this->_request_json = $requestJsonEncoded;
				//print_r($this->_request_json);
				//exit;
                $isSuccess = true;
            }
        }
        catch (Exception $e)
        {
            throw \TangoCard\Sdk\Common\TangoCardSdkException( "Failed to map request.", $e->getCode(), $e);
        }
        return $isSuccess;
    }
    
    /**
     * POST request to Tango Card service
     *
     * @param JSON &$responseJsonEncoded reference
     * 
     * @return bool   Return true upon success, else false.
     * 
     * @access public
     */    
    protected function postRequest(&$responseJsonEncoded)
    {
        if (is_null($this->_path)) {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException('_path is not set.');
        }
        if (!in_array('curl', get_loaded_extensions())) {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException('The cURL PHP module is required.');
        }
        
        $isSuccess = false;
        $responseJsonEncoded = null;
        
        try
        {
            // root certificate authority (CA) certificate
            $caCertPath = dirname(dirname(dirname(__FILE__))) . "/ssl/cacert.pem";
			
            if (!file_exists($caCertPath)) {
                throw new \TangoCard\Sdk\Common\TangoCardSdkException('The CAcerts file is required: ' . $caCertPath );
            }
            
            if ( $this->mapRequest() ) {
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL            , $this->_path);
                curl_setopt($ch, CURLOPT_PORT           , 443);
                curl_setopt($ch, CURLOPT_VERBOSE        , 0);
                curl_setopt($ch, CURLOPT_HEADER         , 0);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER , 1);
                curl_setopt($ch, CURLOPT_POST           , 1);
                curl_setopt($ch, CURLOPT_POSTFIELDS     , $this->_request_json);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER , true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST , 2);
                curl_setopt($ch, CURLOPT_CAINFO         , $caCertPath);
                curl_setopt($ch, CURLOPT_HTTPHEADER     , array('Content-Type: application/json; charset=utf-8'));
                
                // make the request and get the response
                $responseJsonEncoded = curl_exec($ch);
                
                if(curl_errno($ch)) {
                    $message = curl_error($ch);
                    curl_close($ch);
                    throw new \TangoCard\Sdk\Common\TangoCardSdkException($message);
                }
        
                curl_close($ch);
                
                $isSuccess = true;
            }         
        }
        catch (Exception $e)
        {
            throw \TangoCard\Sdk\Common\TangoCardSdkException( "Failed to post request.", $e->getCode(), $e);
        }
        return $isSuccess;
    }
    
    
    /**
     * Executes request upon Tango Card service
     *
     * @param BaseResponse &$responseSuccess reference
     * 
     * @return bool   Return true upon success, else false.
     * 
     * @access public
     */
    public function executeRequest(&$responseSuccess) 
    {
        $isSuccess = false;
        $responseJsonEncoded = null;
        try
        {
            if ($this->postRequest($responseJsonEncoded)) {  
                $responseJson = json_decode($responseJsonEncoded);
                
                ServiceProxy::throwOnError($responseJson);
                
                if (is_a($this->_requestObject, 'TangoCard\Sdk\Request\GetAvailableBalanceRequest')) {
                    $responseSuccess = new \TangoCard\Sdk\Response\Success\GetAvailableBalanceResponse($responseJson->response);
                } else if (is_a($this->_requestObject, 'TangoCard\Sdk\Request\PurchaseCardRequest')) {
                    $responseSuccess = new \TangoCard\Sdk\Response\Success\PurchaseCardResponse($responseJson->response);
                } else {
                    throw new \UnexpectedValueException('requester from TangoCard appears to be invalid: ' . get_class($this->_requestObject));
                }
                
                $isSuccess = true;
            }        
        }
        catch (\TangoCard\Sdk\Service\TangoCardServiceException $e)
        {
            throw $e;
        }
        catch (\TangoCard\Sdk\Common\TangoCardSdkException $e) 
        {
            throw $e;
        }
        catch (Exception $e)
        {
            throw new \TangoCard\Sdk\Common\TangoCardSdkException( "Failed to process request.", $e->getCode(), $e);
        }
        return $isSuccess;       
    }
    
    
    /**
     * Throw TangoCardServiceException if Tango Card service indicates failure.
     *
     * @param JSON    $responseJson from Tango Card service
     * 
     * @return void
     * 
     * @access protected
     */
    protected static function throwOnError($responseJson)
    {
        if (is_null($responseJson)) {
            throw new \UnexpectedValueException('Supplied JSON does not appear to be valid.');
        }
        
        switch($responseJson->responseType) {
            case "SUCCESS":
                break;
            case "SYS_ERROR":
                {
                    $responseFailure = new \TangoCard\Sdk\Response\Failure\SystemErrorResponse($responseJson->response);
                    throw new \TangoCard\Sdk\Service\TangoCardServiceException( \TangoCard\Sdk\Response\ServiceResponseEnum::SYS_ERROR, $responseFailure );
                }
                break;
            case "INV_INPUT":
                {
                    $responseFailure = new \TangoCard\Sdk\Response\Failure\InvalidInputResponse($responseJson->response);
                    throw new \TangoCard\Sdk\Service\TangoCardServiceException( \TangoCard\Sdk\Response\ServiceResponseEnum::INV_INPUT, $responseFailure );
                }
                break;
            case "INV_CREDENTIAL":
                {
                    $responseFailure = new \TangoCard\Sdk\Response\Failure\InvalidCredentialsResponse($responseJson->response);
                    throw new \TangoCard\Sdk\Service\TangoCardServiceException( \TangoCard\Sdk\Response\ServiceResponseEnum::INV_CREDENTIAL, $responseFailure );
                }
                break;
            case "INS_INV":
                {
                    $responseFailure = new \TangoCard\Sdk\Response\Failure\InsufficientInventoryResponse($responseJson->response);
                    throw new \TangoCard\Sdk\Service\TangoCardServiceException( \TangoCard\Sdk\Response\ServiceResponseEnum::INS_INV, $responseFailure);
                }
                break;
            case "INS_FUNDS":
                {
                    $responseFailure = new \TangoCard\Sdk\Response\Failure\InsufficientFundsResponse($responseJson->response);
                    throw new \TangoCard\Sdk\Service\TangoCardServiceException( \TangoCard\Sdk\Response\ServiceResponseEnum::INS_FUNDS, $responseFailure);
                }
                break;
            default:
                throw new \UnexpectedValueException('responseType from TangoCard appears to be invalid.');
                break;
        }  
    }
}