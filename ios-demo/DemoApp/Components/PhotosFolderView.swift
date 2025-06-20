//
//  PhotosFolderView.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import SwiftUI
import PhotosUI

struct PhotoFolderView: View {
    @Binding var images: [UIImage]
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var isPresented: Bool
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            ZStack(alignment: .topTrailing) {
                if images.isEmpty {
                    ZStack {
                        Image(.addPhoto)
                        
                        Rectangle()
                            .foregroundStyle(UIColor.darkBlue.withAlphaComponent(0.1).suColor)
                            .dashedBorder(color: UIColor.lightBlue.suColor)
                    }
                } else {
                    ZStack {
                        ForEach(Array(images.prefix(3).enumerated()), id: \.offset) { index, img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .cornerRadius(8)
                                .clipped()
                                .offset(x: CGFloat(index) * 4, y: CGFloat(index) * 4)
                        }
                    }
                }
                
                if !images.isEmpty {
                    Text("\(images.count)")
                        .font(.caption2)
                        .padding(5)
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
        .frame(width: 120, height: 120)
        .photosPicker(isPresented: $isPresented,
                      selection: $selectedItems,
                      maxSelectionCount: 10,
                      selectionBehavior: .default,
                      matching: .images)
        .task(id: selectedItems) {
            var loadedImages: [UIImage] = []

            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    loadedImages.append(img)
                }
            }

            if !loadedImages.isEmpty {
                images = loadedImages
            }
        }
    }
}
