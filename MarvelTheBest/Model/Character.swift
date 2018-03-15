//
//  Character.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

extension API {
    struct Character: Model {
        let id: Int
        let name: String
        let description: String
        let modified: String
        let resourceURI: String
        let urls: [API.Url]
        let thumbnail: Image
//        let comics: List<ComicSummary>
//        let stories: List<StorySummary>
//        let events: List<EventSummary>
//        let series: List<SeriesSummary>
//        
//        struct List<M: Model>: Model {
//            var available: Int
//            var returned: Int
//            var collectionURI: String
//            var items: [M]
//        }
//        
//        struct ComicSummary: Model {
//            var resourceURI: String
//            var name: String
//        }
//        
//        struct EventSummary: Model {
//            var resourceURI: String
//            var name: String
//        }
//        
//        struct StorySummary: Model {
//            var resourceURI: String
//            var name: String
//            var type: String
//        }
//        
//        struct SeriesSummary: Model {
//            var resourceURI: String
//            var name: String
//        }
        
    }
}
