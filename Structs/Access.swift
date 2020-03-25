//
//  Access.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/24.
//  Copyright © 2020 ryuton. All rights reserved.
//

import Foundation

struct Access: Codable  {
    
    let line: String?
    let station: String?
    let station_exit: String?
    let walk: String?
    let note: String?

    
    enum CodingKeys: String, CodingKey {
        case line
        case station
        case station_exit
        case walk
        case note
    }
}
