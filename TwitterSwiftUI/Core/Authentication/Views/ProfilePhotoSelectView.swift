//
//  ProfilePhotoSelectView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import SwiftUI

struct ProfilePhotoSelectView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showImagePicker = false
    @State private var image: UIImage?
    
    var body: some View {
        
        VStack {
            AuthHeaderView(title1: "Setup account.",
                           title2: "Add a profile photo")
            
            Button {
                showImagePicker.toggle()
            } label: {
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(Color(.systemBlue))
                        .clipShape(Circle())
                }
            }
            .padding(.vertical, 40)
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(selectedImage: $image)
            })
            
            if let image = self.image {
                Button {
                    viewModel.uploadProfileImage(image)
                } label: {
                    Text("Countinue")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProfilePhotoSelectView()
}
