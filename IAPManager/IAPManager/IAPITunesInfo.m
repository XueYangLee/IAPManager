//
//  IAPITunesInfo.m
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/22.
//

#import "IAPITunesInfo.h"

@implementation IAPITunesInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pending_renewal_info" : [IAPITunesReceiptRenewalInfoModel class],
             @"latest_receipt_info" : [IAPITunesReceiptInfoModel class]
    };
}

@end


@implementation IAPITunesReceiptModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"in_app" : [IAPITunesReceiptInfoModel class]};
}

@end


@implementation IAPITunesReceiptRenewalInfoModel

@end


@implementation IAPITunesReceiptInfoModel

@end



/**
 {
     "environment" = Sandbox;

     "receipt" = {
     "receipt_type" = ProductionSandbox;
     "app_item_id" = 0;
     "receipt_creation_date" = 2020-12-23 02:39:36 Etc/GMT;
     "bundle_id" = com.now.NowMeditation;
     "original_purchase_date" = 2013-08-01 07:00:00 Etc/GMT;
     "in_app" = (
     "{
     "product_id" = com.now.NowMeditation.member.forever;
     "quantity" = 1;
     "transaction_id" = 1000000757832268;
     "purchase_date_ms" = 1608691176000;
     "original_purchase_date_pst" = 2020-12-22 18:39:36 America/Los_Angeles;
     "purchase_date_pst" = 2020-12-22 18:39:36 America/Los_Angeles;
     "original_purchase_date_ms" = 1608691176000;
     "is_trial_period" = false;
     "original_purchase_date" = 2020-12-23 02:39:36 Etc/GMT;
     "original_transaction_id" = 1000000757832268;
     "purchase_date" = 2020-12-23 02:39:36 Etc/GMT;
    }",
     "{
     "quantity" = 1;
     "purchase_date_ms" = 1608631544000;
     "expires_date" = 2020-12-22 10:10:44 Etc/GMT;
     "expires_date_pst" = 2020-12-22 02:10:44 America/Los_Angeles;
     "is_in_intro_offer_period" = false;
     "transaction_id" = 1000000757540005;
     "is_trial_period" = false;
     "original_transaction_id" = 1000000757540005;
     "purchase_date" = 2020-12-22 10:05:44 Etc/GMT;
     "product_id" = com.now.NowMeditation.member.normal.month;
     "original_purchase_date_pst" = 2020-12-22 02:05:45 America/Los_Angeles;
     "original_purchase_date_ms" = 1608631545000;
     "web_order_line_item_id" = 1000000058550066;
     "expires_date_ms" = 1608631844000;
     "purchase_date_pst" = 2020-12-22 02:05:44 America/Los_Angeles;
     "original_purchase_date" = 2020-12-22 10:05:45 Etc/GMT;
    }",
     "{
     "quantity" = 1;
     "purchase_date_ms" = 1608625708000;
     "expires_date" = 2020-12-22 08:30:28 Etc/GMT;
     "expires_date_pst" = 2020-12-22 00:30:28 America/Los_Angeles;
     "is_in_intro_offer_period" = false;
     "transaction_id" = 1000000757488739;
     "is_trial_period" = true;
     "original_transaction_id" = 1000000757488739;
     "purchase_date" = 2020-12-22 08:28:28 Etc/GMT;
     "product_id" = com.now.NowMeditation.member.stepOne.weekly.freeLimit;
     "original_purchase_date_pst" = 2020-12-22 00:28:29 America/Los_Angeles;
     "original_purchase_date_ms" = 1608625709000;
     "web_order_line_item_id" = 1000000058546517;
     "expires_date_ms" = 1608625828000;
     "purchase_date_pst" = 2020-12-22 00:28:28 America/Los_Angeles;
     "original_purchase_date" = 2020-12-22 08:28:29 Etc/GMT;
 }",
 );

     "adam_id" = 0;
     "receipt_creation_date_pst" = 2020-12-22 18:39:36 America/Los_Angeles;
     "request_date" = 2020-12-23 02:39:43 Etc/GMT;
     "request_date_pst" = 2020-12-22 18:39:43 America/Los_Angeles;
     "version_external_identifier" = 0;
     "request_date_ms" = 1608691183236;
     "original_purchase_date_pst" = 2013-08-01 00:00:00 America/Los_Angeles;
     "application_version" = 2020122101;
     "original_purchase_date_ms" = 1375340400000;
     "receipt_creation_date_ms" = 1608691176000;
     "original_application_version" = 1.0;
     "download_id" = 0;
 };

     "pending_renewal_info" = (
     "{
     "product_id" = com.now.NowMeditation.member.normal.halfYear;
     "original_transaction_id" = 1000000757540005;
     "auto_renew_product_id" = com.now.NowMeditation.member.normal.halfYear;
     "auto_renew_status" = 1;
    }",
     "{
     "product_id" = com.now.NowMeditation.member.stepOne.weekly.freeLimit;
     "original_transaction_id" = 1000000757488739;
     "auto_renew_product_id" = com.now.NowMeditation.member.stepOne.weekly.freeLimit;
     "auto_renew_status" = 1;
 }",
 );

     "status" = 0;

     "latest_receipt_info" = (
     "{
     "product_id" = com.now.NowMeditation.member.forever;
     "quantity" = 1;
     "transaction_id" = 1000000757832268;
     "purchase_date_ms" = 1608691176000;
     "original_purchase_date_pst" = 2020-12-22 18:39:36 America/Los_Angeles;
     "purchase_date_pst" = 2020-12-22 18:39:36 America/Los_Angeles;
     "original_purchase_date_ms" = 1608691176000;
     "is_trial_period" = false;
     "original_purchase_date" = 2020-12-23 02:39:36 Etc/GMT;
     "original_transaction_id" = 1000000757832268;
     "purchase_date" = 2020-12-23 02:39:36 Etc/GMT;
    }",
     "{
     "quantity" = 1;
     "purchase_date_ms" = 1608691082000;
     "expires_date" = 2020-12-23 03:08:02 Etc/GMT;
     "expires_date_pst" = 2020-12-22 19:08:02 America/Los_Angeles;
     "is_in_intro_offer_period" = false;
     "transaction_id" = 1000000757831979;
     "is_trial_period" = false;
     "original_transaction_id" = 1000000757540005;
     "purchase_date" = 2020-12-23 02:38:02 Etc/GMT;
     "product_id" = com.now.NowMeditation.member.normal.halfYear;
     "original_purchase_date_pst" = 2020-12-22 02:05:45 America/Los_Angeles;
     "subscription_group_identifier" = 20710093;
     "original_purchase_date_ms" = 1608631545000;
     "web_order_line_item_id" = 1000000058564161;
     "expires_date_ms" = 1608692882000;
     "purchase_date_pst" = 2020-12-22 18:38:02 America/Los_Angeles;
     "original_purchase_date" = 2020-12-22 10:05:45 Etc/GMT;
    }",
     "{
     "quantity" = 1;
     "purchase_date_ms" = 1608625708000;
     "expires_date" = 2020-12-22 08:30:28 Etc/GMT;
     "expires_date_pst" = 2020-12-22 00:30:28 America/Los_Angeles;
     "is_in_intro_offer_period" = false;
     "transaction_id" = 1000000757488739;
     "is_trial_period" = true;
     "original_transaction_id" = 1000000757488739;
     "purchase_date" = 2020-12-22 08:28:28 Etc/GMT;
     "product_id" = com.now.NowMeditation.member.stepOne.weekly.freeLimit;
     "original_purchase_date_pst" = 2020-12-22 00:28:29 America/Los_Angeles;
     "subscription_group_identifier" = 20711695;
     "original_purchase_date_ms" = 1608625709000;
     "web_order_line_item_id" = 1000000058546517;
     "expires_date_ms" = 1608625828000;
     "purchase_date_pst" = 2020-12-22 00:28:28 America/Los_Angeles;
     "original_purchase_date" = 2020-12-22 08:28:29 Etc/GMT;
 }",
 );

     "latest_receipt" =
 }
 
 */
