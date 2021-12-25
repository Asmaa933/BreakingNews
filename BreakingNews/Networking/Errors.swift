//
//  Errors.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import Foundation

struct ErrorModel: Codable {
    let status: String?
    let code: String?
    let message: String?
}
