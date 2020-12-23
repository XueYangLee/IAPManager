//
//  IAPITunesInfo.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IAPITunesReceiptModel;
@class IAPITunesReceiptRenewalInfoModel;
@class IAPITunesReceiptInfoModel;

/** ⚠️本地验证⚠️iTunes数据结果模型 */
@interface IAPITunesInfo : NSObject

@property (nonatomic,copy) NSString *environment;

/**
 A JSON representation of the receipt that was sent for verification.
 For information about keys found in a receipt, see Receipt Fields.
 */
@property (nonatomic,strong) IAPITunesReceiptModel *receipt;

/**
 @ auto-renewable subscription
 
 Only returned for iOS 7 style app receipts containing auto-renewable subscriptions. In the JSON file, the value of this key is an array where each element contains the pending renewal information for each auto-renewable subscription identified by the Product Identifier. A pending renewal may refer to a renewal that is scheduled in the future or a renewal that failed in the past for some reason.
 */
@property (nonatomic,strong) NSArray <IAPITunesReceiptRenewalInfoModel *>*pending_renewal_info;

/**
 For iOS 7 style app receipts, the status code is reflects the status of the app receipt as a whole. For example, if you send a valid app receipt that contains an expired subscription, the response is 0 because the receipt as a whole is valid.
 
 https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html#//apple_ref/doc/uid/TP40010573-CH104-SW5
 
 Status Code
 21000    The App Store could not read the JSON object you provided.
 
 21002    The data in the receipt-data property was malformed or missing.
 
 21003    The receipt could not be authenticated.
 
 21004    The shared secret you provided does not match the shared secret on file for your account.
 
 21005    The receipt server is not currently available.
 
 21006    This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
 Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
 
 21007    This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead.
 
 21008    This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead.
 
 21010    This receipt could not be authorized. Treat this the same as if a purchase was never made.
 
 21100-21199 Internal data access error.
 
 */
@property (nonatomic,assign) NSInteger status;

/**
 @ auto-renewable subscription
 
 Only returned for receipts containing auto-renewable subscriptions. For iOS 6 style transaction receipts, this is the JSON representation of the receipt for the most recent renewal. For iOS 7 style app receipts, the value of this key is an array containing all in-app purchase transactions. This excludes transactions for a consumable product that have been marked as finished by your app.
 */
@property (nonatomic,strong) NSArray <IAPITunesReceiptInfoModel *>*latest_receipt_info;

/**
 @ auto-renewable subscription
 
 Only returned for receipts containing auto-renewable subscriptions. For iOS 6 style transaction receipts, this is the base-64 encoded receipt for the most recent renewal. For iOS 7 style app receipts, this is the latest base-64 encoded app receipt.
 */
@property (nonatomic,copy) NSString *latest_receipt;

@end


@interface IAPITunesReceiptModel : NSObject

@property (nonatomic,copy) NSString *receipt_type;

@property (nonatomic,copy) NSString *app_item_id;

@property (nonatomic,copy)/*NSDate格式*/ NSString *receipt_creation_date;

@property (nonatomic,copy) NSString *bundle_id;

@property (nonatomic,copy)/*NSDate格式*/ NSString *original_purchase_date;

/**
 In the JSON file, the value of this key is an array containing all in-app purchase receipts based on the in-app purchase transactions present in the input base-64 receipt-data. For receipts containing auto-renewable subscriptions, check the value of the latest_receipt_info key to get the status of the most recent renewal.
 
 Note: An empty array is a valid receipt.
 
 The in-app purchase receipt for a consumable product is added to the receipt when the purchase is made. It is kept in the receipt until your app finishes that transaction. After that point, it is removed from the receipt the next time the receipt is updated - for example, when the user makes another purchase or if your app explicitly refreshes the receipt.
 
 The in-app purchase receipt for a non-consumable product, auto-renewable subscription, non-renewing subscription, or free subscription remains in the receipt indefinitely.
 */
@property (nonatomic,strong) NSArray <IAPITunesReceiptInfoModel *>*in_app;

@property (nonatomic,copy) NSString *adam_id;

@property (nonatomic,copy)/*NSDate格式*/ NSString *receipt_creation_date_pst;

@property (nonatomic,copy)/*NSDate格式*/ NSString *request_date;

@property (nonatomic,copy)/*NSDate格式*/ NSString *request_date_pst;

@property (nonatomic,copy) NSString *version_external_identifier;

@property (nonatomic,copy) NSString *request_date_ms;

@property (nonatomic,copy)/*NSDate格式*/ NSString *original_purchase_date_pst;

@property (nonatomic,copy) NSString *application_version;

@property (nonatomic,copy) NSString *original_purchase_date_ms;

@property (nonatomic,copy) NSString *receipt_creation_date_ms;

@property (nonatomic,copy) NSString *original_application_version;

@property (nonatomic,copy) NSString *download_id;

@end


@interface IAPITunesReceiptRenewalInfoModel : NSObject

@property (nonatomic,copy) NSString *product_id;

@property (nonatomic,copy) NSString *original_transaction_id;

@property (nonatomic,copy) NSString *auto_renew_product_id;

/**
 “1” - Subscription will renew at the end of the current subscription period.
 
 “0” - Customer has turned off automatic renewal for their subscription.
 */
@property (nonatomic,assign) NSInteger auto_renew_status;

@end


@interface IAPITunesReceiptInfoModel : NSObject

/**
 The default value is 1, the minimum value is 1, and the maximum value is 10.
 */
@property (nonatomic,assign) NSInteger quantity;

@property (nonatomic,copy) NSString *purchase_date_ms;

/**
 到期时间
 针对SKPaymentTransactionObserver的监听，当交易信息发生更新时，苹果会自动推送当前的交易状态，
 不包含过期信息表示无自动续期交易   缓存票据更新时的请求时间，通过与过期时间对比来确定用户的订阅是否过期
 This key is only present for auto-renewable subscription receipts.
 Use this value to identify the date when the subscription will renew or expire, to determine if a customer should have access to content or service.
 After validating the latest receipt, if the subscription expiration date for the latest renewal transaction is a past date, it is safe to assume that the subscription has expired.
 
 */
@property (nonatomic,copy)/*NSDate格式*/ NSString *expires_date;

@property (nonatomic,copy)/*NSDate格式*/ NSString *expires_date_pst;

/**
 仅用于，自动续费订阅
 true，表示处于 引导价格 时期
 如果已有票据中含有is_trial_period或者is_in_intro_offer_period为true，用户不再具备有此项资格
 
 For an auto-renewable subscription, whether or not it is in the introductory price period.
 This key is only present for auto-renewable subscription receipts. The value for this key is "true" if the customer’s subscription is currently in an introductory price period, or "false" if not.
 
 Note: If a previous subscription period in the receipt has the value “true” for either the is_trial_period or the is_in_intro_offer_period key, the user is not eligible for a free trial or introductory price within that subscription group.
 */
@property (nonatomic,assign) BOOL is_in_intro_offer_period;

@property (nonatomic,copy) NSString *transaction_id;

/**
 仅用于，自动续费订阅
 true，表示处于 免费试用 时期
 如果已有票据中含有is_trial_period或者is_in_intro_offer_period为true，用户不再具备有此项资格
 
 For a subscription, whether or not it is in the free trial period.
 This key is only present for auto-renewable subscription receipts. The value for this key is "true" if the customer’s subscription is currently in the free trial period, or "false" if not.
 
 Note: If a previous subscription period in the receipt has the value “true” for either the is_trial_period or the is_in_intro_offer_period key, the user is not eligible for a free trial or introductory price within that subscription group.
 */
@property (nonatomic,assign) BOOL is_trial_period;

@property (nonatomic,copy) NSString *original_transaction_id;

@property (nonatomic,copy)/*NSDate格式*/ NSString *purchase_date;

@property (nonatomic,copy) NSString *product_id;

@property (nonatomic,copy)/*NSDate格式*/ NSString *original_purchase_date_pst;

@property (nonatomic,copy) NSString *subscription_group_identifier;

@property (nonatomic,copy) NSString *original_purchase_date_ms;

/**
 This value is a unique ID that identifies purchase events across devices, including subscription renewal purchase events.
 */
@property (nonatomic,copy) NSString *web_order_line_item_id;

@property (nonatomic,copy) NSString *expires_date_ms;

@property (nonatomic,copy)/*NSDate格式*/ NSString *purchase_date_pst;

@property (nonatomic,copy)/*NSDate格式*/ NSString *original_purchase_date;

/**
 “1” - Customer canceled their subscription.
 “2” - Billing error; for example customer’s payment information was no longer valid.
 “3” - Customer did not agree to a recent price increase.
 “4” - Product was not available for purchase at the time of renewal.
 “5” - Unknown error
 */
@property (nonatomic,assign) NSInteger expiration_intent;

/**
 对于订阅过期的自动续费产品，苹果是否会尝试自动续费
 For an expired subscription, whether or not Apple is still attempting to automatically renew the subscription.
 “1” - App Store is still attempting to renew the subscription.
 “0” - App Store has stopped attempting to renew the subscription.
 
 This key is only present for auto-renewable subscription receipts. If the customer’s subscription failed to renew because the App Store was unable to complete the transaction, this value will reflect whether or not the App Store is still trying to renew the subscription.
 */
@property (nonatomic,assign) BOOL is_in_billing_retry_period;

/**
 退款操作时间
 For a transaction that was canceled by Apple customer support, the time and date of the cancellation. For an auto-renewable subscription plan that was upgraded, the time and date of the upgrade transaction.
 Treat a canceled receipt the same as if no purchase had ever been made.
 A canceled in-app purchase remains in the receipt indefinitely. Only applicable if the refund was for a non-consumable product, an auto-renewable subscription, a non-renewing subscription, or for a free subscription.
 */
@property (nonatomic,copy)/*NSDate格式*/ NSString *cancellation_date;


/**
 内购取消的原因
 “1” - Customer canceled their transaction due to an actual or perceived issue within your app.
 
 “0” - Transaction was canceled for another reason, for example, if the customer made the purchase accidentally.
 
 Use this value along with the cancellation date to identify possible issues in your app that may lead customers to contact Apple customer support.
 */
@property (nonatomic,copy) NSString *cancellation_reason;

/**
 APP唯一标识符
 */
@property (nonatomic,copy) NSString *app_item_id;

/**
 This key is not present for receipts created in the test environment. Use this value to identify the version of the app that the customer bought
 */
@property (nonatomic,copy) NSString *version_external_identifier;

/**
 The current renewal status for the auto-renewable subscription.
 “1” - Subscription will renew at the end of the current subscription period.
 
 “0” - Customer has turned off automatic renewal for their subscription.
 
 This key is only present for auto-renewable subscription receipts, for active or expired subscriptions. The value for this key should not be interpreted as the customer’s subscription status. You can use this value to display an alternative subscription product in your app, for example, a lower level subscription plan that the customer can downgrade to from their current plan.
 
 */
@property (nonatomic,assign) NSInteger auto_renew_status;

/**
 The current renewal preference for the auto-renewable subscription.
 This key is only present for auto-renewable subscription receipts. The value for this key corresponds to the productIdentifier property of the product that the customer’s subscription renews. You can use this value to present an alternative service level to the customer before the current subscription period ends.
 */
@property (nonatomic,copy) NSString *auto_renew_product_id;

/**
 The current price consent status for a subscription price increase.
 “1” - Customer has agreed to the price increase. Subscription will renew at the higher price.
 
 “0” - Customer has not taken action regarding the increased price. Subscription expires if the customer takes no action before the renewal date.
 
 This key is only present for auto-renewable subscription receipts if the subscription price was increased without keeping the existing price for active subscribers. You can use this value to track customer adoption of the new price and take appropriate action.
 */
@property (nonatomic,assign) NSInteger price_consent_status;

@end

NS_ASSUME_NONNULL_END
