//
//  Restaurant.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/15.
//  Copyright © 2020 ryuton. All rights reserved.
//

import Foundation

struct Restaurant: Codable {
    
    let id: String
    let name: String
    let nameKana: String
    let latitude: String
    let longitude: String
    let image_url: Picture
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameKana = "name_kana"
        case latitude
        case longitude
        case image_url
    }
}
