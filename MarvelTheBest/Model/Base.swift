//
//  Base.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

protocol Model: Codable { }

struct API {
    
}

extension API {
    struct Url: Model {
        var type: String
        var url: String
    }
    
    struct Image: Model {
        var path: String
        var ext: String
        
        var url: URL? {
            return URL(string: "\(path).\(ext)")
        }
        
        private enum Key: String, CodingKey {
            case path
            case ext = "extension"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            
            path    = try container.decode(String.self, forKey: .path)
            ext     = try container.decode(String.self, forKey: .ext)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            
            try container.encode(path, forKey: .path)
            try container.encode(ext, forKey: .ext)
        }
    }
    
    struct DataContainer<Item: Model>: Model {
        var offset: Int
        var limit: Int
        var total: Int
        var count: Int
        var results: [Item]
        
        var hasMore: Bool {
            return total > (offset + count)
        }
    }
}
