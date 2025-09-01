//
//  ApiStringConstant.swift
//  Plutope
//
//  Created by Trupti Mistry on 03/01/24.
//
import Foundation
enum ServerType {
    case live
    case test
}
enum MerchnantID {
    case live
    case test
}
enum XVersion {
    case live
    case test
}
enum AppVersion {
    case live
    case test
}
enum PayoutAppVersion {
    case live
    case test
}

var serverTypes: ServerType = .live
var merchantId: MerchnantID = .live
var xVersion: XVersion = .live
var appVersions: AppVersion = .live
var payoutAppVersions: PayoutAppVersion = .live
struct ServiceNameConstant {
    
    struct BaseUrl {
        static let baseUrl = serverTypes == .live ? "https://plutope.app/" : "https://plutopaybrowsers.appworkdemo.com/"
//        static let baseUrl = "https://plutopaybrowsers.appworkdemo.com/"
//        static let baseUrl = "https://plutope.app/"
        static let clientVersion = "api/"
        static let images = "images/"
        static let user = "user/"
        static let admin = "admin/"
        static let card = "card/"
        static let mobile = "mobile/"
        static let baseUrlNew = serverTypes == .live ? "https://api.crypterium.com/" : "https://api.vault.sandbox.testessential.net/"
        
    }
    /// live Server Endpoints
    static let login  = "oauth/token"
    static let signupNew = "mobile/signup"
    static let masterCardListNew = "card/list"
    static let appVersion = appVersions == .live ? "v2/" : "v2/"
    static let payoutAppVersion = payoutAppVersions == .live ? "v2/" : "v2/"
    static let kycStatusNew = "customer/kyc/data"
    static let customerProfile = "customer/profile"
    static let getwalletsNew = "wallets"
    static let confirmOtp = "mobile/phone/confirm"
    static let resendOtpNew = "mobile/phone/verify/resend"
    static let confirmAddmail = "mobile/email/add"
    static let confirmEmailNew = "mobile/email/confirm"
    static let kycLimitsNew = "v1/kyc/limits"
    static let historyNew = "history/operations"
    static let passwordChangeNew = "mobile/password/change"
    static let payoutData = "v4/payout/data"
    static let payoutAddCardNew = "v4/payout/card"
    static let payoutCreateOfferNew = "v4/payout/offer"
    static let payoutExicuteOfferNew = "v4/payout/pay"
    static let exchangeDataNew = "v2/exchange"
    static let exchangeNew = "v1/mobile/exchange"
    static let kycStartNew = "v4/kyc/start"
    static let kycStartNewV5 = "v5/kyc/start"
    static let kycFinishNew = "v4/kyc/ondato/finished"
    static let resetPaawordNew = "mobile/password/reset"
    static let resetConfirmCodeNew = "mobile/password/reset/confirm/code"
    static let confirmPasswordNew = "mobile/password/reset/confirm"
    static let cardPriceNew = "card/prices"
    static let cardRequestsNew = "card/card-requests"
    static let cardAddressUpdateRequestsNew = "v2/card/card-requests"
    static let additionalPersonalInfoNew = "v3/card/additional-personal-info?cp=CP_2"
    static let paymentOfferNew = "v3/card/additional-personal-info?cp=CP_2"
    static let historyByCardIdNew = "history/card"
    static let masterCardInfoDetailsNew = "details"
    static let softBlockNew = "soft-block"
    static let softUnblockNew = "soft-unblock"
    static let createWalletsNew = "wallets"
    static let payinFiatRatesNew = "v3/payin/fiat-rates"
    static let payinRatesCardsNew = "v3/payin/data"
    static let payinOfferCreateNew = "v3/payin/offer"
    static let payinExecuteOfferPaymentNew = "v3/payin/pay/"
    static let payinPayCallbackNew = "v3/payin/pay-callback"
    static let payinAddCardNew = "v3/payin/card"
    static let payinCardBillingAddressNew = "billing-address"
    static let historyOperationsNew = "history/operations"
    static let payloadNew = "payload"
    static let createCardPayloadOffer = "offers"
    static let getFeeCurrencyNew = "v1/wallet/send/fee"
    static let walletSendValidateNew = "v1/wallet/send/validate"
    static let walletSendNew = "v1/wallet/send"
    static let historyTransactionNew = "history/operations"
    static let detailsDecrypted = "details-decrypted"
    static let numberDecrypted = "number-decrypted"
    static let changeCardPin = "/pin?cp=CP_2"
//    static let payouGetRateCardsNew = "v4/payout/data"
    /// old
    static let register = "register-user"
    static let walletActive = "set-wallet-active"
    static let btcTransfer = "btc-transfer"
    static let getAllTtokens = "get-all-tokens"
    static let marketsPrice = "markets-price"
    static let onMeta = "on-meta"
    static let unlimitQuoteBuy = "unlimit-quote-buy"
    static let rangoSwap = "rango-swap"
    static let rangoSwapQuote = "rango-swap-quote"
    static let btcBalance = "btc-balance"
    static let getAllImages = "get-all-images"
    static let domainCheck = "domain-check"
    static let signup = "signup"
    static let phoneConfirm = "phone-confirm"
    static let resendOTP = "resend-otp"
    static let addEmail = "add-email"
    static let confirmEmail = "confirm-email"
    static let swapQuote = "swap-exchange-okx-rangoswap-quote"
    static let buyQuote = "quote-buy"
    static let exodusSwapUpdateOrders = "exodus-swap-update-orders"
    static let exodusSwapSingleOrders = "exodus-swap-single-orders"
    
    static let okxApproveTranscation = "okx-approve-transcation"
    static let okxSwapTranscation = "okx-swap-transcation"
    /// mastercard userManagemant
    static let updateProfile = "update-profile"
    static let getProfile = "get-profile"
    static let signIn = "signin"
    static let resetConfirmCode = "reset/confirm/code"
    static let resetPassword = "reset-password"
    static let setPassword = "set-password"
    static let changePassword = "change-password"
    
   /// kyc status
    static let kycStatus = "kyc-status"
    static let kycStart = "kyc-start"
    static let kycOndatoFinished = "kyc-ondato-finished"
    static let kycUploadDocument = "kyc-upload-document"
    static let kycLimits = "kyc-limits"
    
    /// Card Wallet
    static let getWallets = "get-wallets"
    static let createWallets = "create-wallets"
    /// mastercard List
    static let masterCardList = "card-list"
    static let cardRequests = "card-requests"
    static let getAdditionalPersonalInfo  = "get-additional-personal-info"
    static let additionalPersonalInfo = "additional-personal-info"
    static let signOut = "signout"
    static let cardPrice = "card-price"
    static let paymentOffer = "payment-offer" 
    
    /// mastercard Information
    static let masterCardInfoDetails = "details"
    static let getCardPublicPrivateKey = "get-card-publick-private-key"
    static let softBlock = "soft-block"
    static let softUnblock = "soft-unblock"
    static let mobileEmailVerify = "mobile/email/verify/resend"
    
    ///
     static let payinFiatRates = "payin-fiat-rates"
    static let payinAddCard = "payin-add-card"
    static let payinCardBillingAddress = "payin-card-billing-address"
    static let payinOfferCreate = "payin-offer-create"
    static let payinExecuteOfferPayment = "payin-execute-offer-payment"
    static let payinPayCallback = "payin-pay-callback"
    
    /// Card TopUp
    
    static let payload = "payload"
    
   // static let masterCardInfoDetails = "card-list"
    /// Send Wallet
    static let getFeeCurrency = "get-fee-currency"
    static let walletSend = "wallet-send"
    static let walletSendValidate = "wallet-send-validate"
    
    static let payinRatesCards = "payin-rates-cards"
    /// All Transaction history
    static let historyTransaction = "history-transaction"
    static let historyOperations = "history-operations"
    static let historyByCardId = "history-by-cardId"
    /// Exchnage
    static let exchange = "exchange"
    /// currency change
    static let changeCurrency = "change-currency"
    static let cardDashboardImages = "card-dashboard-images"
    
    static let payouGetRateCards = "payout-get-rate-cards"
    static let payoutAddCard = "payout-add-card"
    static let payoutCreateOffer = "payout-create-offer"
    static let payoutUpdateOffer = "payout-update-offer"
    
    /// referral
   
    static let referral = "my-referral-codes/"
    static let referralCodeUser = "my-refferal-user/"
    static let updateClaimUser = "update-claim/"
    
    /// Sell Provider
    static let getAllSellProvider = "get-all-sell-provider"
    
}

var merchantID = merchantId == .live ? "merchantID" : "merchantID"
var headerVersion = xVersion == .live ? "1.2" : "1.2"
var appUpdatedFlag = ""
let loginApiToken = "loginApiToken"
let loginApiRefreshToken = "loginApiRefreshToken"
let loginApiTokenType = "loginApiTokenType"
let loginPhoneNumber = "phoneNumber"
let loginPassword = "password"
let cardHolderfullName = "cardHolderfullName"
let mainPublicKey = "mainPublicKey"
let mainPrivetKey = "mainPrivetKey"
let loginApiTokenExpirey = "loginApiTokenExpirey"
let cryptoCardNumber = "cryptoCardNumber"
let cardTypes = "cardTypes"
let fiateValue = "fiateValue"
let cardCurrency = "cardCurrency"
let serverType = "LIVE"
var appUpdatedFlagValue = "appUpdatedFlagValue"
var isFromAppUpdated = "true"
var isFromAppUpdatedKey = "isFromAppUpdatedKey"
var appUpdatedFlagUpdate = "2"
var lastFetchTimestampKey = "lastFetchTimestampKey"
var encodePublicKey = "encodePublicKey"
var encodePrivetKey = "encodePrivetKey"
