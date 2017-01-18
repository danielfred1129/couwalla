<?php 

	header('Content-Type: text/csv; charset=utf-8');
	header('Content-Disposition: attachment; filename=offers.csv');
	$output = fopen('php://output', 'w');
	fputcsv($output, array('name', 'categories', 'start_date', 'end_date', 'offer_data', 'offer_type', 'terms', 'description', 'image', 'logo', 'merchant_name'));

	$offers = simplexml_load_file('api.xml'); 
	foreach($offers->Offers as $offer) {
		foreach($offer->Offer as $offer_datax) {
			$categories = (string)$offer_datax->Categories;
			$start_date = (string)$offer_datax->StartDate;
			$end_date = (string)$offer_datax->EndDate;
			$offerData = (string)$offer_datax->OfferData;
			$offerType = (string)$offer_datax->OfferType;
			$terms = (string)$offer_datax->TermsConditions;
			$offername = (string)$offer_datax->Title;
			$description = (string)$offer_datax->MerchantDescription;
			$image = (string)$offer_datax->MerchantImage;
			$logo = (string)$offer_datax->MerchantLogo;
			$merchantName = (string)$offer_datax->MerchantName;
			fputcsv($output, array($offername, $categories, $start_date, $end_date, $offerData, $offerType, $terms, $description, $image, $logo, $merchantName));
		}
	}

?>