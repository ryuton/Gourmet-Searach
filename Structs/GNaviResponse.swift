//
//  GNaviResponse.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/15.
//  Copyright © 2020 ryuton. All rights reserved.
//

import Foundation


struct GNaviResponse<Item: Codable>: Codable {
    let totalHitCount: Int
    let hitPerPage: Int
    let pageOffset: Int
    let rest: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalHitCount = "total_hit_count"
        case hitPerPage = "hit_per_page"
        case pageOffset = "page_offset"
        case rest
    }
}
