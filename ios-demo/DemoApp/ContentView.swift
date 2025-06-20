//
//  ContentView.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import SwiftUI
import PhotosUI

#Preview {
    ContentView()
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    @State private var showFirstPhotoPicker = false
    @State private var showSecondPhotoPicker = false
    
    @State private var firstSelectedItems = [PhotosPickerItem]()
    @State private var secondSelectedItems = [PhotosPickerItem]()
    
    var body: some View {
        VStack {
            Text("Select two photos to compare them.")
                .font(.title)
                .multilineTextAlignment(.center)
                
            
            Spacer()
            
            HStack {
                PhotoFolderView(images: $viewModel.firstImagesGroup,
                                selectedItems: $firstSelectedItems,
                                isPresented: $showFirstPhotoPicker)
                
                Spacer()
                
                PhotoFolderView(images: $viewModel.secondImagesGroup,
                                selectedItems: $secondSelectedItems,
                                isPresented: $showSecondPhotoPicker)
            }
            .padding([.leading, .trailing, .top], 25)
            
            Spacer()
                        
            makeSimilarityScoreView()
            
            Spacer()
            
            VStack(alignment: .center, spacing: 15) {
                makeStyledButton(title: "Compare Photos") {
                    Task {
                        await viewModel.compareImages()
                    }
                }
                .background(UIColor.darkBlue.suColor)
                .cornerRadius(8)
                
                makeStyledButton(title: "Delete Photos") {
                    firstSelectedItems.removeAll()
                    secondSelectedItems.removeAll()
                    viewModel.resetImages()
                }
                .disabled(!viewModel.hasSelectedImages())
                .background(viewModel.hasSelectedImages() ? .red : UIColor.bluishGrey.suColor)
                .cornerRadius(8)
            }
        }
        .padding()
        .errorAlert($viewModel.error)
    }
    
    @ViewBuilder
    func makeStyledButton(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func makeSimilarityScoreView() -> some View {
        VStack {
            Text("Similarity Score")
                .font(.headline)
                .padding(.bottom, 5)
            
            if let score = viewModel.similarityScore {
                Text(String(format: "%.2f", score))
                    .font(.largeTitle)
                    .foregroundColor(score > ViewModel.threshold ? .green : .red)
            } else {
                Text("No comparison yet")
                    .foregroundColor(.gray)
            }
        }
    }
}
