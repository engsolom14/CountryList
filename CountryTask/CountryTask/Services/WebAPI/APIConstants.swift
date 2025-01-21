//
//  APIConstants.swift
//  Digybite CaseStudy
//
//  Created by Eslam on 02/06/2023.
//

import Foundation

struct APIConstants {
    
    //MARK: API base URL
    static var baseURL = "https://restcountries.com/v2/"

    //MARK: Header
    enum HttpHeaderField: String {
        case ApiKey = "key"
    }

}

enum AuthErrorEnum:Int,Codable{
    case SocialError = 1
    case NormalError
    case NotVerfify
    case DeletedUser
    case DeactivatedUser
    case Emailalreadyused
    case UsernameAlreadyUsed
    case Phonealreadyused
    case SocialAccountAlreadyused
}

//MARK: Error Messages
let ServerError = "We are sorry something went wrong"
let NetworkError = "Please check your internet connection and try again"
let requestCancelled = ""
//MARK: Alert Messages
let AlertServerErrorTitle = "Try again"
let AlertNetworkErrorTitle = "No Internet Connection"
let AlertDataMessignTitle = "Data Missing"
let AlertServerResponseTitle = "Alert Alert Title"
let AlertExpireTitle = "Your session wa expired"

//MARK: UserDefualts Const
let COUNTRIES_DATA = "countriesData"
