//
//  APIRouter.swift
//  Digybite CaseStudy
//
//  Created by Eslam on 02/06/2023.
//

import Foundation
import Alamofire
//import SwiftyJSON

enum APIRouter: URLRequestConvertible {
    
    //TODO: APIs
    case countriesList
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.queryString
            case .post:
                return JSONEncoding.default
                
            case .delete:
                return URLEncoding.default
            default:
                return URLEncoding.queryString
                
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
        
    }
    
    //MARK: - Header
//    private var header: [String: String] {
//
//        switch self {
//        case .gamesList:
//            return [ "":""
//               // APIConstants.HttpHeaderField.ApiKey.rawValue: APIConstants.apiKey
//            ]
//        }
//
//    }
    
    //MARK: - HttpMethod
    // changable //post, get, ....
    private var method: HTTPMethod {
        switch self {
        case .countriesList:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    // changable
    var path: String {
        switch self {
            
        case .countriesList:
            return "all"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
            
        case .countriesList:
            return nil
        }
    }
    
}
