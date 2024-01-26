//
//  APIError.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation

enum APIError: Error, CustomStringConvertible { // 이넘드로 정의해서 APi요청중 발생할 수 있는 다양한 오류유형을 정의 하고 있다 .
    case badURL// 잘못된 Url 나타내는 케이스
    case badResponse(statusCode: Int) // 안좋은 반응이왔을대 200 - 299 범위 에속하지않는 상태가 오는걸 매개변수로 받아서 확인하려고
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown// 정의되지않은 오류를 나타낸다
    
    var localizedDescription: String {
        // user feedback
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    } // 여기서 다 나눠서 처리 해주는거임 근데 이쪽은 고객들한테 알려주는 용
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        }
    } // 여기는 개발자가 아는용
}
