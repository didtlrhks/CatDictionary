//
//  APIServiceProtocol.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation

import Foundation


protocol APIServiceProtocol {
    func fetchBreeds(url: URL?, completion: @escaping(Result<[Breed], APIError>) -> Void)
}
