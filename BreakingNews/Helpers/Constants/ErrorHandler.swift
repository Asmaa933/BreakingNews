//
//  ErrorHandler.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import Foundation

enum ErrorHandler: Error {
    case generalError
    case selectDropDown
    case custom(String)
    
    var message: String {
        switch self {
        case .generalError:
            return "Something went wrong, please try again"
        case .selectDropDown:
            return "Please select all fields"
        case .custom(let message):
            return message
        }
    }
}
