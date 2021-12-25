//
//  Encodable+Ext.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

extension Encodable {
    func toJSON() -> [String: Any] {
        let encoder = JSONEncoder()
        return (try? JSONSerialization.jsonObject(with: encoder.encode(self), options: .allowFragments)) as? [String: Any] ?? [:]
    }
}
