//
//  Picture.swift
//  FenrirGourmet
//
//  Created by 上野隆斗 on 2020/03/15.
//  Copyright © 2020 ryuton. All rights reserved.
//

import Foundation

struct Picture: Codable  {
    
    let shop_image1: String
    let shop_image2: String
    let qrcode: String

    
    enum CodingKeys: String, CodingKey {
        case shop_image1
        case shop_image2
        case qrcode
    }
}
