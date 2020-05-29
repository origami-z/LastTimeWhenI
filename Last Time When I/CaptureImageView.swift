//
//  CaptureImageView.swift
//  Last Time When I
//
//  Created by Zhihao Cui on 25/05/2020.
//  Copyright © 2020 zhihaocui. All rights reserved.
//

import SwiftUI

struct CaptureImageView: View {
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, image: $image)
    }
}

struct CaptureImageView_Previews: PreviewProvider {
//    @State var isShown : Bool = false
//    @State var image: Image? = nil
    
    static var previews: some View {
//        CaptureImageView(isShown: $isShown, image: $image)
        Text("No preview")
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
