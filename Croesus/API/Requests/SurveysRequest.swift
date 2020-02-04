//
//  SurveysRequest.swift
//  Croesus
//
//  Created by Bourne K on 05/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation

class SurveysRequest:NSObject, Codable {
    var userId = ""
    
    override init(){
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case userId = "uid"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(userId , forKey: .userId)
    }
}
