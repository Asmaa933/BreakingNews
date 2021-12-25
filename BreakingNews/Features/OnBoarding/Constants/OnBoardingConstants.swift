//
//  OnBoardingConstants.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

/*
 Available Categories
 business entertainment general health sciences ports technology
 */
enum NewsCategory: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case sciences
    case ports
    case technology
}

enum NewsCountry: String, CaseIterable {
    case unitedStates = "The United States of America"
    case canada = "Canada"
    case switzerland = "Switzerland"
    case germany = "Germany"
    case emirates = "The United Arab Emirates"
    case argentina = "Argentina"
    case austria = "Austria"
    case australia = "Australia"
    case belgium = "Belgium"
    case bulgaria = "Bulgaria"
    case brazil = "Brazil"
    
    var isoCode: String {
        switch self {
        case .unitedStates:
            return "us"
        case .canada:
            return "ca"
        case .switzerland:
            return "ch"
        case .germany:
            return "de"
        case .emirates:
            return "ae"
        case .argentina:
            return "ar"
        case .austria:
            return "at"
        case .australia:
            return "au"
        case .belgium:
            return "be"
        case .bulgaria:
            return "bg"
        case .brazil:
            return "br"            
        }
    }
}
