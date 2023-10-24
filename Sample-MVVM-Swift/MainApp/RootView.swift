//
//  RootView.swift
//  Sample-MVVM-Swift
//
//  Created by Chhan Sophearith on 20/10/23.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!")
        }
        .padding()
        
        .onAppear {
            viewModel.getUserList()
        }
    }
}

