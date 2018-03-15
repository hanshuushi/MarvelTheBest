//
//  HttpRequest.swift
//  MarvelTheBest
//
//  Created by 范舟弛 on 2018/3/12.
//  Copyright © 2018年 范舟弛. All rights reserved.
//

import Foundation

fileprivate let baseURL: String = "https://gateway.marvel.com:443/v1/public/"

fileprivate let publicAppKey: String = "37309290119482e67d2c63cd5a2e3791"

fileprivate let privateAppKey: String = "2af3822c8ccacc32ea456332d2011bca36535381"

enum HttpRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HttpRequestError: Error {
    case badNetwork(Error)
    case responseError(Int, String)
    case decodeFailed
}

enum HttpRequestResult {
    case failed(HttpRequestError)
    case success(Data?)
}

fileprivate extension String {
    func urlEncode() -> String {
        let encodeString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        
        return encodeString
    }
    
    func MD5() -> String {
        guard let messageData = self.data(using:.utf8) else {
            return ""
        }
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}

class HttpRequest: NSObject {
    typealias CallBack = (HttpRequestResult) -> Void
    
    fileprivate let task: URLSessionDataTask
    
    fileprivate static func currentDateStamp() -> Int {
        let date = Date()
        
        let dateStamp = Int(date.timeIntervalSince1970)
        
        return dateStamp
    }
    
    fileprivate static func getHash(with dateStamp: Int) -> String {
        return "\(dateStamp)\(privateAppKey)\(publicAppKey)".MD5()
    }
    
    init?(urlString: String,
         params: [String: Any]? = nil,
         method: HttpRequestMethod = .get,
         callBack: @escaping CallBack) {
        let dateStamp = HttpRequest.currentDateStamp()
        
        var urlString = "\(baseURL)\(urlString)?ts=\(dateStamp)&apikey=\(publicAppKey.urlEncode())&hash=\(HttpRequest.getHash(with: dateStamp))"
        
        if let `params` = params {
            switch method {
            case .get:
                for (key, value) in params {
                    let valueString = "\(value)".urlEncode()
                    
                    urlString += "&\(key.urlEncode())=\(valueString)"
                }
            default:
                break
            }
        }
        
        debugPrint("urlString is \(urlString)")
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        task = HttpRequestConfig
            .share
            .session()
            .dataTask(with: urlRequest,
                      completionHandler: { (data, response, error) in
                        if let `error` = error {
                            callBack(.failed(.badNetwork(error)))
                            
                            return
                        }
                        
                        callBack(.success(data))
            })
        
        task.resume()
    }
    
    func cancel() {
        task.cancel()
    }
}

fileprivate class HttpRequestConfig: NSObject, URLSessionDelegate {
    static let share: HttpRequestConfig = HttpRequestConfig()
    
    let operationQueue: OperationQueue
    
    override init() {
        operationQueue = OperationQueue()
        
        super.init()
    }
    
    func session() -> URLSession {
        return URLSession(configuration: .default,
                          delegate: self,
                          delegateQueue: operationQueue)
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = challenge.protectionSpace.serverTrust.map({ URLCredential(trust: $0) })
            
            completionHandler(.useCredential, credential)
        }
    }
}
