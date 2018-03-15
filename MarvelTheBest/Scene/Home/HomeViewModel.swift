//
//  HomeViewModel.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

class HomeViewModel: ViewModel {
    
    func bind(to view: HomeViewController) {
        
        var request: HttpRequest? = nil
        
        // do not need strong weak dance, HomeViewController will never be released
        view.searchAction = {
//            [weak view]
            keyword in
            
//            guard let `view` = view else {
//                return
//            }
            
            request?.cancel()
            
            view.status = .loading
            
            var currentOffset: Int = 0
            
            var isLoading: Bool = true
            
            view.showMoreAction = nil
            
            var viewModels: [HomeHeroTableViewModel] = []
            
            var params: [String: Any] = [:]
            
            if keyword != "" {
                params["nameStartsWith"] = keyword
            }
            
            params["limit"] = 20
            params["orderBy"] = "modified"
            
            request =  HttpRequest
                .get(url: "characters",
                     params: params,
                     success: {
                        (model: API.DataContainer<API.Character>) in
                        
                        currentOffset = model.count + model.offset
                        
                        viewModels = model.results.map({ HomeHeroTableViewModel(model: $0) })
                        
                        view.status = .success(viewModels, model.hasMore)
                        
                        isLoading = false
                        
                        view.showMoreAction = {
                            if isLoading {
                                return
                            }
                            
                            isLoading = true
                            
                            var `params` = params
                            
                            params["offset"] = currentOffset
                            
                            HttpRequest
                                .get(url: "characters",
                                     params: params,
                                     success: { (moreModel: API.DataContainer<API.Character>) in
                                        
                                        currentOffset = moreModel.count + moreModel.offset
                                        
                                        viewModels.append(contentsOf: moreModel.results.map({ HomeHeroTableViewModel(model: $0) }))
                                        
                                        view.status = .success(viewModels, moreModel.hasMore)
                                        
                                        isLoading = false
                                },
                                     failed: { (error) in
                                        isLoading = false
                                })
                        }
                }) { (error) in
                    view.status = .failed("failed")
            }
        }
        
        view.searchAction?("")
    }
}
