//
//  APIService.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation
import SwiftUI


struct APIService: APIServiceProtocol { // API 서비스 구조체를 정의하고 APIServiceProtocol 프로토콜을 준수해준다고 설정
    
    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T,APIError>) -> Void) { // 자 일단 func fetch<> 이런 생성이 제네릭함수를 선언했다는거고 T가 Decodable 프로토콜을 준수하는 어떤 타입이라도 될수있음을 의미를 하는것이고 Decodable은 표준라이브러리에 정의된 프로토콜로 JSON 과 같은 외부 표현 형식에서 구조체나 클래스로 데이터를 디코딩할수 있도록 해주는녀석아고 함수의 첫번째 매개변수는 타입으로 T.Type의 형태로 전달이 된다 여기서 T.Type은 메타타입을 의미를 하며 함수호출시 디코딩하고자 하는 구체적인 타입의 정보를 전달하기 위해 사용된다 ,
        //이를 통해서 함수는 어던 Decodable타입의 인스턴스를 생성해야할지를 알수가 있게댐 2번째 매개변수인 URL 은 생략을 하고 그냥 옵셔널따르는거임 completion 을 보면 클로저로 함수의 비동기실행이 완료가 된후에 호출이된다. 이스케이핑은 함수의 호출이 끝이나고 나서도 호출을 할수가있다라는 개념임 즉 함수가 반환이 된후에도 실행이될수있다라는 의미이고 Result는 성공하면 T 타입 반환 아니라면 API Error 을 반환한다는 뜻임 .
        guard let url = url
        else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        } // 입력된 url dㅣ nil 인경우 바로 APIError.badURL 오류를 반환하고 함수를 멈춘다.
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }

            }
        }

        task.resume()
    }
    
    
    func fetchBreeds(url: URL?, completion: @escaping(Result<[Breed], APIError>) -> Void) {
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let breeds = try decoder.decode([Breed].self, from: data)
                    completion(Result.success(breeds))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }
                
                
            }
        }

        task.resume()
        
    }
}
