//
//  Enums.swift
//  VGSFramework
//
//  Created by Vitalii Obertynskyi on 8/14/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

/// Organization vault environment.
public enum Environment: String {
    
    /// Should be used for development and testing purpose.
    case sandbox
    
    /// Should be used for production.
    case live
}

/// Type of `VGSTextField` configuration.
public enum FieldType: Int, CaseIterable {
    
    /// Field type that doesn't require any input formatting and validation.
    case none
    
    /// Field type that requires Credit Card Number input formatting and validation.
    case cardNumber
    
    /// Field type that requires Expiration Date input formatting and validation.
    case expDate
    
    /// Field type that requires Credit Card CVC input formatting and validation.
    case cvc
    
    /// Field type that requires Cardholder Name input formatting and validation.
    case cardHolderName
}

internal extension FieldType {
    
    var formatPattern: String {
        switch self {
        case .cardNumber:
            return "#### #### #### ####"
        case .cvc:
            return "####"
        case .expDate:
            return "##/##"
        default:
            return ""
        }
    }
    
   var regex: String {
        switch self {
        case .cardNumber:
            return "^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$"
        case .cvc:
            return VGSTextField.cvcRegexForAnyCardType
        case .expDate:
            return "^(0[1-9]|1[0-2])\\/?([0-9]{4}|[0-9]{2})$"
        case .cardHolderName:
            return "^([a-zA-Z0-9\\ \\,\\.\\-\\']{2,})$"
        default:
            return ""
        }
    }
    
    var isSecureDate: Bool {
        switch self {
        case .cvc:
            return true
        default:
            return false
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .cardNumber, .cvc, .expDate:
            return .asciiCapableNumberPad
        default:
            return .alphabet
        }
    }
}
