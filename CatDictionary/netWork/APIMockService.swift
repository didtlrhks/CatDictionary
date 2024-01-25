//
//  APIMockService.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation

struct APIMockService: APIServiceProtocol {
    
    var result: Result<[Breed], APIError>
    
    func fetchBreeds(url: URL?, completion: @escaping (Result<[Breed], APIError>) -> Void) {
        completion(result)
    }
    
    
    
    
}
