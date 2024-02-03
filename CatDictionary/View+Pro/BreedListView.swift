//
//  BreedFetcher.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation
import SwiftUI
struct BreedListView: View {
    let breeds: [Breed] // breeds 라는 변수에다가 Breed 데이터 셋에 엤는 데이터들을 사용하기 위해서 가져온거임
    
    @State private var searchText: String = "" // searchText 라는 변수넣어주고 이제 텍스트필드에서 바인딩을 해줘서 상태를 관리해주기 위해서 이를 사용함
    
    var filteredBreeds: [Breed] {// 검색로직을 해결하기 위해서 실행한 함수이다 .
        if searchText.count == 0 { // 만약에 텍스트가 들어간 숫자가 없다라고 정의가 된다면
          return breeds // 그대로 Breeds 객체를 반환하는것이고
        } else {
            return breeds.filter { $0.name.lowercased().contains(searchText.lowercased()) // 그게아닐경우에 내가 원하는 필터로 걸러서 보여주는거고
                // 이름을 모두 소문자로 바구고 그중 겹치는 일들을 searchText를 인지하고 잇다가 바뀌면 그 포함되는 객체를 반환한다 .
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredBreeds) { breed in
                    NavigationLink {
                        BreedDetailView(breed: breed)
                    } label: {
                        BreedRow(breed: breed)
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Find Your Perfect Cat")
            .searchable(text: $searchText)
            
        }
    }
}

struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedListView(breeds: BreedFetcher.successState().breeds)
    }
}
