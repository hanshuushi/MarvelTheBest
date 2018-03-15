//
//  HttpRequest+DataTransform.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/14.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

extension HttpRequest {
    static func getDataWrapperFrom(responseData : Any?) throws -> Any {
        let jsonData: Data
        
        if let string = responseData as? String,
            let data = string.data(using: .utf8) {
            jsonData = data
        } else if let data = responseData as? Data {
            jsonData = data
        } else {
            throw HttpRequestError.decodeFailed
        }
        
        guard let responseDict = (try? JSONSerialization.jsonObject(with: jsonData,
        options: .allowFragments) as? [String: Any]).flatMap({ $0 }),
            let code = responseDict["code"] as? Int,
            let status = responseDict["status"] as? String else {
                throw HttpRequestError.decodeFailed
        }
        
        if code != 200 {
            throw HttpRequestError.responseError(code, status)
        }
        
        guard let dataWrapper = responseDict["data"] else {
            throw HttpRequestError.decodeFailed
        }
        
        return dataWrapper
    }
    
    static func getResponseModel<M: Model>(data: Any?) throws -> M  {
        guard let dictionary = data as? [String: Any],
            let jsonData = (try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)).flatMap({ $0 }) else {
                throw HttpRequestError.decodeFailed
        }
        
        let decoder = JSONDecoder()
        
        let model: M
        
        do {
            model = try decoder
                .decode(M.self,
                        from: jsonData)
        } catch {
            debugPrint("error is \(error)")
            
            throw HttpRequestError.decodeFailed
        }
        
        return model
    }
    
    
}
