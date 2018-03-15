//
//  HttpRequest+Call.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

extension HttpRequest {
    
    @discardableResult
    static func get<M: Model>(url: String,
                       params: [String: Any]? = nil,
                       success: @escaping (M) -> Void,
                       failed: ((HttpRequestError) -> Void)? = nil) -> HttpRequest? {
        let httpRequest = HttpRequest(urlString: url,
                                      params: params,
                                      method: .get) { (result) in
                                        switch result {
                                        case .failed(let error):
                                            failed?(error)
                                        case .success(let data):
                                            do {
                                                let dataWrapper = try HttpRequest
                                                    .getDataWrapperFrom(responseData: data)
                                                
                                                let model: M = try HttpRequest.getResponseModel(data: dataWrapper)
                                                
                                                DispatchQueue
                                                    .main
                                                    .async {
                                                        success(model)
                                                }
                                                
                                            } catch HttpRequestError.responseError(let code, let status) {
                                                DispatchQueue
                                                    .main
                                                    .async {
                                                        failed?(HttpRequestError.responseError(code, status))
                                                }
                                            } catch {
                                                
                                                print(error)
                                                
                                                DispatchQueue
                                                    .main
                                                    .async {
                                                        failed?(HttpRequestError.decodeFailed)
                                                }
                                            }
                                        }
        }
        
        return httpRequest
    }
}
