//
//  Country.swift
//  CountryTask
//
//  Created by Eslam on 18/01/2025.
//

import Foundation

struct Country: Codable {
    let id = UUID()
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let latlng: [Double]?
    let flags: Flag?
    
    struct Currency: Codable {
        let name: String?
        let symbol: String?
    }
    struct Flag: Codable {
        let png: String?
    }
}
