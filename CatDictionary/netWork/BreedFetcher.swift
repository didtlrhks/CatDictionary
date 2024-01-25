//
//  BreedFetcher.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation



class BreedFetcher: ObservableObject {
    
    @Published var breeds = [Breed]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    //이 세개를 관찰가능하게 클래스를 ObservableObject 로 설정을 하고
    
    let service: APIServiceProtocol // service 에다가 APIServiceProtocol 이 프로토콜을 따를 수 있도록 확인해서 알려주고
    
    init(service: APIServiceProtocol = APIService()) { // 생성자에서 APIService 가 가지고 있는 인스턴스를 모두 가지도록 만들어준다 .
        self.service = service
        fetchAllBreeds() //
    }
    
    func fetchAllBreeds() {
        
        isLoading = true // 로딩을 true로 바꿔서 이렇게 해서 로딩을 안하도록 만들어주고
        errorMessage = nil // 에러메세지를 nil로 초기화를 해주고
        
        let url = URL(string: "https://api.thecatapi.com/v1/breeds") //여기서 url 을 불러주고
        service.fetchBreeds(url: url) // service에서 fetch를 해서 apiApi service를 데리고와준다.
        { [unowned self] result in // unowned 와 weak 에 대한 차이점을 생각해보려고하는데 일단 이 줄의 문법은 클로저 내에서 캡처리스트를 사용하여 self 를 캡처하는 방식을 나타낸다. 이 구문에서는 메모리 관리와 관련잉 있으며 특히 순환참조를 방지하기 위해서 사용함 여기서 unowned 키워드는 클로저가 self 를 소유하지않는다는 의미인데 일단 여기서 weak 와의 차이점을 알아보려고한다면 둘다 순환참조를 방지하려고 사용하기는 하지만 weak는 참조하는 인스턴스가 메모리에서 헤제가 될수도있다라는 의미를 가지면서 즉 그뜻은 무조건 옵셔널로 다가가야한다라는 의미를 가지고 그리고 이경우에는 참조는 nil이 된다 그게아닌 unowned 참조하는 인스턴스가 클로저의 생명주기 동안 항상 메모리에 남아있다는걸 말해줌 즉 참조가 nil dㅣ 되지않는다라는 확신이있을때 사용한다 .
            // 그러니까 옵셔널이 아닌타입이며 참조하는 인스턴스가 해제된 후에 접근하려고 하면 런타임오류가 발생을 하나보네
            //자 그래서 총 쭉 해당 소스부분을 해석한다고 하면 fetchBreeds 메소드의 비동기 작업이 완료될때까지 BreedFetcher인스턴스 self 가 메모리에 남아있음을 뜻함
            DispatchQueue.main.async { // 메인 쓰레드에서 UI 관련 업데이트를 수행해주는 부분임
                
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription// 자기자신 클래스 errorMessage 에 다가 error 타입 정의해놓은 부분을 넣어주면서 실패한경우를 에러처리해주는 부분임
                    // print(error.description)
                    print(error)
                case .success(let breeds):
                    print("--- sucess with \(breeds.count)")
                    self.breeds = breeds // 성공한 부분에서는 가져와줌 
                }
            }
        }
        
    }
    
    
    //MARK: preview helpers
    
    static func errorState() -> BreedFetcher {
        let fetcher = BreedFetcher()
        fetcher.errorMessage = APIError.url(URLError.init(.notConnectedToInternet)).localizedDescription
        return fetcher
    }
    
    static func successState() -> BreedFetcher {
        let fetcher = BreedFetcher()
        fetcher.breeds = [Breed.example1(), Breed.example2()]
        
        return fetcher
    }
}
