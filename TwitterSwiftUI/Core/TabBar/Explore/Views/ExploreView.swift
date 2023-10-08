//
//  ExploreView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel = ExploreViewModel()
    var body: some View {
        
        NavigationStack {
            VStack {
                SearchBar(text: $viewModel.searchText)
                    .padding()

                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.searchableUsers) { user in
                            NavigationLink {
                                ProfileView(user: user)
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ExploreView()
}
