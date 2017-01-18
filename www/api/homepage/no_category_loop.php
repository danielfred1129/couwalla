<?php
	
	                $whatshot_data = array();
//                $nearme_data = array();
//                $popular_data = array();
                //whats Hot array
                $whatshot_result = mysql_query("SELECT * FROM coupons WHERE whats_hot = '1'");
                while ($whatshot_row = mysql_fetch_array($whatshot_result)) {
                    $store = mysql_query("SELECT storename,latitude,longitude,address,description,thumbnailimage FROM stores where id in ($whatshot_row[store_name])") or die('store err');
                    $str1 = array();
                    while ($str = mysql_fetch_assoc($store)) {
                        $str1[] = array(
                            "storename" => $str['storename'],
                            "latitude" => $str['latitude'],
                            "description" => $str['description'],
                            "storethumbnail" => $thumb_path . $str['thumbnailimage'],
                            "address" => str_replace("+", " ", str_replace("%", ",", $str['address'])),
                            "longitude" => $str['longitude']
                        );
                    }
                    $customer = mysql_query("SELECT companyname FROM customer where id = $whatshot_row[customer_name]") or die('cust err');
                    $cust = mysql_fetch_assoc($customer);


                    $barcode_image = "";
                    if ($whatshot_row['code_type'] == "barcode") {
                        if ($whatshot_row['bar_type'] != "qr") {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                        } else if ($whatshot_row['bar_type'] != 'code128') {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                        } else if ($whatshot_row['bar_type'] != 'code39') {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                        } else if ($whatshot_row['bar_type'] != 'itf') {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                        } else if ($whatshot_row['bar_type'] != 'ean8') {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                        } else if ($whatshot_row['bar_type'] != 'ean13') {
                            $barcode_image = "https://api.scandit.com/barcode-generator/v1/$whatshot_row[bar_type]/$whatshot_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200";
                        }
                    }
                    if(strtotime($whatshot_row['expiry_date']) > time()) { // Tracker
	                    $whatshot_data[] = array(
	                        "id" => $whatshot_row["id"],
	                        "name" => $whatshot_row["name"],
	                        "category" => $whatshot_row["category"],
	                        "description" => $whatshot_row["description"],
	                        "customer_name" => $cust['companyname'],
	                        "store_name" => $str1,
	                        "code_type" => $whatshot_row["code_type"],
	                        "coupon_description" => $whatshot_row["coupon_description"],
	                        "coupon_thumbnail" => $thumb_path . $whatshot_row["coupon_thumbnail"],
	                        "coupon_image" => $upload_path . $whatshot_row["coupon_image"],
	                        "promo_text_short" => $whatshot_row["promo_text_short"],
	                        "promo_text_long" => $whatshot_row["promo_text_long"],
	                        "launch_date" => $whatshot_row["launch_date"],
	                        "expiry_date" => $whatshot_row["expiry_date"],
	                        "savings" => $whatshot_row["savings"],
	                        "downloads" => $whatshot_row["downloads"],
	                        "limit" => $whatshot_row["limit"],
	                        "type" => $whatshot_row["type"],
	                        "barcode_image" => $barcode_image
	                    );
                    }
                }
                $arrResponse['whatshot'] = $whatshot_data;
				

                //near me coupons
                if (mysql_num_rows($nearstore_result) > 0) {
                    while ($nearme_store_row = mysql_fetch_assoc($nearstore_result)) {
                        $nearme_data = array();
                        //$coupon_result = mysql_query("SELECT * FROM coupons WHERE store_name like '%$nearme_store_row[id]%' AND customer_name = '$nearme_store_row[customer]'");
                        $coupon_result = mysql_query("SELECT * FROM coupons WHERE store_name like '%$nearme_store_row[id]%'");
                        while ($nearme_coupon_row = mysql_fetch_assoc($coupon_result)) {
                            //echo "<pre>";
                            //print_r($nearme_coupon_row);
                            $nearme_str1 = array();
                            $store = mysql_query("SELECT storename,latitude,longitude,address,description,thumbnailimage FROM stores where id in ($nearme_coupon_row[store_name])");

                            while ($nearme_str = mysql_fetch_assoc($store)) {
                                $nearme_str1[] = array(
                                    "storename" => $nearme_str['storename'],
                                    "latitude" => $nearme_str['latitude'],
                                    "description" => $nearme_str['description'],
                                    "storethumbnail" => $thumb_path . $nearme_str['thumbnailimage'],
                                    "address" => str_replace("+", " ", str_replace("%", ",", $nearme_str['address'])),
                                    "longitude" => $nearme_str['longitude']
                                );
                            }
                            $nearme_customer = mysql_query("SELECT companyname FROM customer where id = $nearme_coupon_row[customer_name]");
                            $nearme_cust = mysql_fetch_assoc($nearme_customer);


                            $barcode_image = "";
                            if ($nearme_coupon_row['code_type'] == "barcode") {
                                if ($nearme_coupon_row['bar_type'] != "qr") {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                                } else if ($nearme_coupon_row['bar_type'] != 'code128') {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                                } else if ($nearme_coupon_row['bar_type'] != 'code39') {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                                } else if ($nearme_coupon_row['bar_type'] != 'itf') {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                                } else if ($nearme_coupon_row['bar_type'] != 'ean8') {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
                                } else if ($nearme_coupon_row['bar_type'] != 'ean13') {
                                    $barcode_image = "https://api.scandit.com/barcode-generator/v1/$nearme_coupon_row[bar_type]/$nearme_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200";
                                }
                            }
                            if(strtotime($nearme_coupon_row['expiry_date']) > time()) { // Tracker
								$nearme_data[] = array(
	                                "id" => $nearme_coupon_row["id"],
	                                "name" => $nearme_coupon_row["name"],
	                                "description" => $nearme_coupon_row["description"],
	                                "customer_name" => $nearme_cust['companyname'],
	                                "store_name" => $nearme_str1,
	                                "code_type" => $nearme_coupon_row["code_type"],
	                                "coupon_description" => $nearme_coupon_row["coupon_description"],
	                                "coupon_thumbnail" => $thumb_path . $nearme_coupon_row["coupon_thumbnail"],
	                                "coupon_image" => $upload_path . $nearme_coupon_row["coupon_image"],
	                                "promo_text_short" => $nearme_coupon_row["promo_text_short"],
	                                "promo_text_long" => $nearme_coupon_row["promo_text_long"],
	                                "launch_date" => $nearme_coupon_row["launch_date"],
	                                "expiry_date" => $nearme_coupon_row["expiry_date"],
	                                "savings" => $nearme_coupon_row["savings"],
	                                "downloads" => $nearme_coupon_row["downloads"],
	                                "limit" => $nearme_coupon_row["limit"],
	                                "type" => $nearme_coupon_row["type"],
	                                "barcode_image" => $barcode_image
	                            );
                            }
                        }
                    }
                    
                } else {
                    
                    $nearme_data = array();
                    
                }

                //exit;
                $arrResponse['nearme_data'] = $nearme_data;


                //Most popular
				$popular_data = array();
				$coupon_result = mysql_query("SELECT * FROM coupons ORDER BY downloads DESC;");
				while ($popular_coupon_row = mysql_fetch_assoc($coupon_result)) {
					//echo "<pre>";
					//print_r($popular_coupon_row);
					$popular_str1 = array();
					$store = mysql_query("SELECT storename,latitude,longitude,address,description,thumbnailimage FROM stores where id in ($popular_coupon_row[store_name])");

					while ($popular_str = mysql_fetch_assoc($store)) {
						$popular_str1[] = array(
							"storename" => $popular_str['storename'],
							"latitude" => $popular_str['latitude'],
							"description" => $popular_str['description'],
							"storethumbnail" => $thumb_path . $popular_str['thumbnailimage'],
							"address" => str_replace("+", " ", str_replace("%", ",", $popular_str['address'])),
							"longitude" => $popular_str['longitude']
						);
					}
					$popular_customer = mysql_query("SELECT companyname FROM customer where id = $popular_coupon_row[customer_name]");
					$popular_cust = mysql_fetch_assoc($popular_customer);


					$barcode_image = "";
					if ($popular_coupon_row['code_type'] == "barcode") {
						if ($popular_coupon_row['bar_type'] != "qr") {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
						} else if ($popular_coupon_row['bar_type'] != 'code128') {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
						} else if ($popular_coupon_row['bar_type'] != 'code39') {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
						} else if ($popular_coupon_row['bar_type'] != 'itf') {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
						} else if ($popular_coupon_row['bar_type'] != 'ean8') {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_";
						} else if ($popular_coupon_row['bar_type'] != 'ean13') {
							$barcode_image = "https://api.scandit.com/barcode-generator/v1/$popular_coupon_row[bar_type]/$popular_coupon_row[barcodedata]?key=3uP_r479pvc-XJxLXmIR7TUa6HaP4NybUjtVBgkSmE_&size=200";
						}
					}
					if(strtotime($popular_coupon_row['expiry_date']) > time()) { // Tracker
						$popular_data[] = array(
							"id" => $popular_coupon_row["id"],
							"name" => $popular_coupon_row["name"],
							"description" => $popular_coupon_row["description"],
							"customer_name" => $popular_cust['companyname'],
							"store_name" => $popular_str1,
							"code_type" => $popular_coupon_row["code_type"],
							"coupon_description" => $popular_coupon_row["coupon_description"],
							"coupon_thumbnail" => $thumb_path . $popular_coupon_row["coupon_thumbnail"],
							"coupon_image" => $upload_path . $popular_coupon_row["coupon_image"],
							"promo_text_short" => $popular_coupon_row["promo_text_short"],
							"promo_text_long" => $popular_coupon_row["promo_text_long"],
							"launch_date" => $popular_coupon_row["launch_date"],
							"expiry_date" => $popular_coupon_row["expiry_date"],
							"savings" => $popular_coupon_row["savings"],
							"downloads" => $popular_coupon_row["downloads"],
							"limit" => $popular_coupon_row["limit"],
							"type" => $popular_coupon_row["type"],
							"barcode_image" => $barcode_image
						);
					}
				}
			}      
			$arrResponse['popular_data'] = $popular_data;          
			}
			}
			}

?>