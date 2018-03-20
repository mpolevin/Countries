//
//  Country.swift
//  Countries
//
//  Created by Mikhail Polyevin on 17/03/2018.
//  Copyright © 2018 MP. All rights reserved.
//

struct Country: Decodable {
    var name: String?
    var capital: String?
    var population: Int?
    var currencies: [Currency]?
    var borders: [String]?
}
