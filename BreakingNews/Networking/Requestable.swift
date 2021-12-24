//
//  Requestable.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
}
