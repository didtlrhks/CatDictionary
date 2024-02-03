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
            //url세션을 활용해서 네트워크요청을 생성을 한다 자세하게는 URL 세션은 URL 로 지정된 리소스와 상호작용하기위한 aPi를 제공하는 클래스이고 shared 싱글턴 인스턴스를 사용함으로써, 기본구성의 세션ㅇ르 통해 네트웤작업을 수행함
            //dataTask with url 이부분은 URL에 대한 HTTPGet 요청을 생성하고 실행하는 작업을 함 이메서드에서는 데이터작업을 위한 URLSessionDataTask 인스턴스를 반환함 끝에 data,res,err 은 클로저이고 각상태가 어떻게 되었는지에 따라서 판별이됨 data는 서버로 부터 받은 데이터이고 성공하면 요청한 리소스내용 res는 서버로부터 받은 응답에 대한 정보를 가지고있ㄴ느 객체임 error 은 error 는 잘못됬을때 나옴
            if let error = error as? URLError { // error 객체가 URLerror 타입으로 다운캐스팅 될수있는지 확인 그리고 오류가 발생을 하면 completion 한테 던져서 나 에러났어 이렇게 알려주는거네
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
                }// 요청이 완료되었을때이 부분이고 JsonDecoder 를 사용하여 수신된 데이터를 원하는 타입으로 디코딩함 그게 여기서는 Breed 타입이고 이 디코딩이 되면 completion 핸들러에 성공결과를 전닿한다
                

            }
        }

        task.resume() // 여기서 이제 조건처리르 다하고 시작하는거고나 이게 이제 그럼 호출인가보네
    }
    
    
    func fetchBreeds(url: URL?, completion: @escaping(Result<[Breed], APIError>) -> Void) {
        guard let url = url else { // url 이 nil 인지확인한다 nil일경우에 바로
            let error = APIError.badURL // 여기서 작업을 종료하고 이를 핸들러에 전달함
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in// 네트워크 요청을 시작한다. 비동기적으로 실행이 되ㅕ며, 완료되면 클로저안에 소스코드 실행함
            
            if let error = error as? URLError { // 에러라면
                completion(Result.failure(APIError.url(error))) // 에러호출해서 끝내고
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) { // 만약에 속하지않는다면 에러 핸들러에 값을 전달해서 반응이 안좋게 나오도록 유도하고
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let breeds = try decoder.decode([Breed].self, from: data)
                    completion(Result.success(breeds))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                } // 그게아니라면 ,즉 data 가 들어온다면 여기에서 다받고 핸들러에 처리 넘기고
                
                
            }
        }

        task.resume() // 실행 
        
    }
}
