//
//  LoadingView.swift
//  CatDictionary
//
//  Created by 양시관 on 1/25/24.
//

import Foundation

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20)  {
            Text("😸")
                .font(.system(size: 80))
            ProgressView()
            Text("Getting the cats ...")
                .foregroundColor(.gray)
            
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
