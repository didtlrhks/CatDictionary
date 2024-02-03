//
//  BreedRow.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation
import SwiftUI

struct BreedRow: View {
    let breed: Breed
    let imageSize: CGFloat = 100
    var body: some View {
        HStack {
            
            if breed.image?.url != nil { // 브리드안에 이미지안에 url 이 있다면 닐을반환하지않고
                AsyncImage(url: URL(string: breed.image!.url!)) { phase in // 여기에서 로딩상태에 따른 뷰를 반환하기위한 용도로 어싱크 이미지를 사용하였고
                    if let image = phase.image {// 만약에 이미지가 들어오게 되면 이미지의 크기나 등등이 처리된 뷰를 반환하고
                        image.resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                        
                     } else if phase.error != nil { // 그게아닌경우 error 를 보여주는 뷰를 반환하고
                         
                         Text(phase.error?.localizedDescription ?? "error")
                             .foregroundColor(Color.pink)
                             .frame(width: imageSize, height: imageSize)
                     } else {
                        ProgressView() // 그게아니라면 RrogressView 를 반환하면서 로딩을 하고 있다는걸 보여준다
                             .frame(width: imageSize, height: imageSize)
                     }
                    
                }
            } else {
                Color.gray.frame(width: imageSize, height: imageSize)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(breed.name)
                    .font(.headline)
                Text(breed.temperament)
            }
        }
     
    }
}

struct BreedRow_Previews: PreviewProvider {
    static var previews: some View {
        BreedRow(breed: Breed.example1())
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
