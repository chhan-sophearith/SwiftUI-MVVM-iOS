//
//  HomeView.swift
//  Sample-MVVM-Swift
//
//  Created by Chhan Sophearith on 24/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0..<(viewModel.users?.count ?? 0), id: \.self) { index in
                    let name = viewModel.users?[index].name ?? ""
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .imageScale(.large)
                        Text("\(name)")
                    }
                    .padding()
                }
            }
        }
        .padding()
        
        .onAppear {
            viewModel.getUserList()
        }
    }
}

#Preview {
    HomeView()
}
