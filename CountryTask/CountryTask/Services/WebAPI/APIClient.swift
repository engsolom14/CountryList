//
//  APIClient.swift
//  Digybite CaseStudy
//
//  Created by Eslam on 02/06/2023.
//

import Foundation
import UIKit
import Alamofire
//import SwiftyJSON

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

struct CustomError: Error {
    var somethingBadHappened:String
    var statusCode: Int
    var code:AuthErrorEnum?
    var key:String = ""
}

public enum APIErrorCases: Error {
    case custom
    case customWith(statusCode: Int)
}

extension APIErrorCases: LocalizedError {
    
    var localizedDescription: String {
        switch self {
            
        case .custom:
            return ServerError
            
        case  .customWith(let statusCode):
            
            switch statusCode {
                
            case 0: return ServerError // common server error
            case 1: return NetworkError
            case 2: return requestCancelled
            case 401:
                return "Your session was expired. Please login again."
                
            case 402...500:
                return ServerError
            default:
                return ServerError
            }
        }
    }
}

class APIClient {
    typealias ReqCompleted = (String? , _ errorStr:CustomError?) -> ()
    
    func stopTheDamnRequests() {
        let sessionManager = Alamofire.Session.default
        sessionManager.session.getTasksWithCompletionHandler { (dataTasks, downloadTasks, a)  in
            dataTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
        sessionManager.cancelAllRequests()
        print("Request is cancelled")
    }
    
    public static func encode<T: Encodable>(_ value: T) throws -> Data? {
        do {
            let data = try JSONEncoder().encode(value)
            return data
        } catch {
            throw error
        }
    }
    
    //MARK: Generic Request
    func executeQuery<T: Decodable>(params: Parameters, mapTo: URLRequestConvertible, completion: @escaping (Result<T, CustomError>) -> Void) {
        if Connectivity.isConnectedToInternet {
            print("Yes! Alamofire internet is available.")
            do {
                let alamofireRequest = try Alamofire.URLEncoding(arrayEncoding: .noBrackets).encode(mapTo, with: params)
                AF.request(alamofireRequest).responseData { (response) in
                    print("THE FULL REQUEST:", response.debugDescription)
                    print("RESULTTTT: ", response)

                    do {
                        switch response.result {
                        case .success(_):
                            let code = response.response?.statusCode ?? 0
                            switch code {
                            case 200:
                                completion(.success(try JSONDecoder().decode(T.self, from: response.data!)))
                                print("THE FULL REQUEST:", response.result)
                            default:
                                completion(.failure(CustomError.init(somethingBadHappened: APIErrorCases.customWith(statusCode: code).localizedDescription , statusCode: code )))
                            }
                            
                        case .failure(let error):
                            if error.localizedDescription == "Request explicitly cancelled." {
                                break
                            } else {
                                completion(.failure(CustomError.init(somethingBadHappened: APIErrorCases.custom.localizedDescription, statusCode: response.response?.statusCode ?? 0 )))
                            }
                        }
                    } catch _ {
                            completion(.failure(CustomError.init(somethingBadHappened: APIErrorCases.custom.localizedDescription , statusCode: response.response?.statusCode ?? 0 )))
                        }
                }
            } catch {
                completion(.failure(CustomError(somethingBadHappened: error.localizedDescription, statusCode: 0)))
            }
        } else {
            completion(.failure(CustomError.init(somethingBadHappened: APIErrorCases.customWith(statusCode: 1).localizedDescription , statusCode: 1 )))

        }
    }
}
