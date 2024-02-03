//
//  Breed.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation

struct Breed: Codable, CustomStringConvertible, Identifiable { // 코더블은 뭐 데이터를 사용하려는 여러 친구들을 다 구분해놔서 사용하는것들인데 CustomStringConvertible 이건 처음보는데 이건 뭐냐면 한마디로 하면 스트링을 약간 커스텀하는것임 지금 let 으로 많이 표현을 해놨는데 그중에 String도 있고 Int 도 있자나 근데 다른 자료형의 것들을 내가 스트링으로 커스텀을 하려고 하는거임 틀을 밑에 description 으로 사용하면댐
    let id: String
    let name: String
    let temperament: String
    let breedExplaination: String
    let energyLevel: Int
    let isHairless: Bool
    let image: BreedImage?
    
    var description: String { // 그러면 Int 형이던 Bool 형이던간에 내가 원하는 스트링으로 커스텀을 할 수 있게 되는거임
        return "breed with name: \(name) and id \(id), energy level: \(energyLevel) isHairless: \(isHairless ? "YES" : "NO")"
    }
    
    enum CodingKeys: String, CodingKey { // 코딩키라는것은 열거형 데이터를 Json 을 통해서 받아올때 인코딩 디코딩하는과정에서 swift 에서 정의한것과 json에서 받아오는 이름이 달라서 자연스러운 인,디코딩이 되지않을대 이를 사용해서 데이터셋이름을 커스터마이징 할 수 있음
        case id
        case name
        case temperament
        case breedExplaination = "description"
        case energyLevel = "energy_level"
        case isHairless = "hairless"
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)// 디코딩 작업에 사용할 키 - 값쌍의 컨테이너를 얻기위해서 설정함 이 컨테이너에서는 CodingKeys 열거형에 정의된 키를 기반으로 데이터를 추출한다.
        
        id = try values.decode(String.self, forKey: .id)// 디코딩한 데이터들을 id 에 다가 넣어주고 밑에 다 반복임 근데 설명을 좀하자면 일단 decode 메서드는 제네릭이고 앞칸에는 어떤 타입으로 할지 뒤에 forkey는 어떤 키를 사용해서 데이터에 접근하는지들알려줌
       name = try values.decode(String.self, forKey: .name)
        temperament = try values.decode(String.self, forKey: .temperament)
        breedExplaination = try values.decode(String.self, forKey: .breedExplaination)
        energyLevel = try values.decode(Int.self, forKey: .energyLevel)
        
        let hairless = try values.decode(Int.self, forKey: .isHairless)
        isHairless = hairless == 1
        
        image = try values.decodeIfPresent(BreedImage.self, forKey: .image) // 그렇게 쭉 반복을 해주는거임
    }
    
    init(name: String, id: String, explaination: String, temperament: String,
         energyLevel: Int, isHairless: Bool, image: BreedImage?){
        self.name = name
        self.id = id
        self.breedExplaination = explaination
        self.energyLevel = energyLevel
        self.temperament = temperament
        self.image = image
        self.isHairless = isHairless // 여기는 그냥 초기화해주는거고
    }
    
 
    static func example1() -> Breed {
        return Breed(name: "Abyssinian",
                     id: "abys",
                     explaination: "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
                     temperament: "Active, Energetic, Independent, Intelligent, Gentle",
                     energyLevel: 5,
                     isHairless: false, image: BreedImage(height: 100, id: "i", url: "https://cdn2.thecatapi.com/images/unX21IBVB.jpg", width: 100))
        
    }
    
    static func example2() -> Breed {
        return Breed(name: "Cyprus",
                     id: "cypr",
                     explaination: "Loving, loyal, social and inquisitive, the Cyprus cat forms strong ties with their families and love nothing more than to be involved in everything that goes on in their surroundings. They are not overly active by nature which makes them the perfect companion for people who would like to share their homes with a laid-back relaxed feline companion.",
                     temperament: "Affectionate, Social",
                     energyLevel: 4,
                     isHairless: false,
                     image: BreedImage(height: 100, id: "i", url: "https://cdn2.thecatapi.com/images/unX21IBVB.jpg", width: 100))
        
    }
}


