//
//  APIClient.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/14.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    /// タイムインターバル
    static let defaultTimeInterval: TimeInterval = 30
    
    /// 端末の通信状態を取得
    ///
    /// - Returns: true: オンライン, false: オフライン
    static func isReachable() -> Bool {
        
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening(onUpdatePerforming: { _ in
            })
            return reachabilityManager.isReachable
        }
        return false
    }
    
    static func request<T: WebAPIRequestProtocol>(request: T,
                                                  completionHandler: @escaping (Result<Data?, Error>) -> Void = { _ in }) {
        
        guard let url =  URL(string: request.baseURLString + request.path) else {
            fatalError("URLが不正")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.timeoutInterval = defaultTimeInterval
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: request.bodys, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "no body data"
            urlRequest.httpBody = jsonString.data(using: .utf8)
        } catch {
            log?.error(error.localizedDescription)
        }
        
        AF.request(urlRequest).responseJSON { response in
            printRequest(request, response: response)
            receivedResponse(response, completionHandler: completionHandler)
        }
    }
}

extension APIClient {
    
    private static func printRequest<T: WebAPIRequestProtocol>(_ request: T, response: Alamofire.AFDataResponse<Any>) {
        if let body = response.request?.httpBody, let bodyJson = String(data: body, encoding: .utf8) {
            log?.info("\n👆👆👆\nRequestURL:\(request.baseURLString + request.path)" +
                "\nRequestHeader: \(request.headers.prettyPrintedJsonString))" +
                "\nReqeustBody : \(bodyJson)" +
                "\nRequestParameter: \(request.parameters.prettyPrintedJsonString)")
        } else {
            log?.info("\n👆👆👆\nRequestURL:\(request.baseURLString + request.path)" +
                "\nRequestHeader: \(request.headers.prettyPrintedJsonString))" +
                "\nRequestParameter: \(request.parameters.prettyPrintedJsonString)")
        }
    }
    
    private static func receivedResponse(_ response: Alamofire.AFDataResponse<Any>,
                                         completionHandler: @escaping (Result<Data?, Error>) -> Void = { _ in }) {
        
        guard let statusCode = response.response?.statusCode else {
            if let error = response.error {
                completionHandler(Result.failure(error))
            }
            return
        }
        
        var responseJson = ""
        if let json = response.value as? [String: Any] {
            responseJson = json.prettyPrintedJsonString
        } else {
            
            if let jsonArray = response.value as? [[String: Any]] {
                
                for json in jsonArray {
                    responseJson += json.prettyPrintedJsonString
                }
            }
        }
        switch response.result {
            
        case .success:
            guard let data = response.data else {
                return
            }
            log?.info("\n👇👇👇" +
                "\nStatusCode: \(statusCode)\nResponseBody: \(responseJson)")
            completionHandler(Result.success(data))
            return
            
        case .failure:
            log?.error("\n🔻🔻🔻" +
                "\nStatusCode: \(statusCode)\nResponseBody: \(responseJson)")
            
            if let error = response.error {
                completionHandler(Result.failure(error))
                return
            }
        }
    }
}
