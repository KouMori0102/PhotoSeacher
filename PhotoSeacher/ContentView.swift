//
//  ContentView.swift
//  PhotoSeacher
//
//  Created by 森下功樹 on 2024/12/31.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .padding()
                } else {
                    Text("ここに撮影した写真が表示されます")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("カメラアプリ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Image(systemName: "camera")
                            .font(.title)
                    }
                }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $capturedImage)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

