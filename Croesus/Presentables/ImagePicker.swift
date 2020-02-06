//
//  ImagePicker.swift
//  Croesus
//
//  Created by Bourne K on 03/02/2020.
//  Copyright © 2020 Triglobe Soft Solutions. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?

        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiImage = rotatedUp(imagePicked)
            isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
        //MARK: - Function for rotating image
        func rotatedUp(_ src:UIImage)->UIImage {
            if src.imageOrientation == UIImage.Orientation.up {
                return src
            }
            var transform: CGAffineTransform = CGAffineTransform.identity
            switch src.imageOrientation {
            case UIImageOrientation.down, UIImageOrientation.downMirrored:
                transform = transform.translatedBy(x: src.size.width, y: src.size.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
                break
            case UIImageOrientation.left, UIImageOrientation.leftMirrored:
                transform = transform.translatedBy(x: src.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi/2))
                break
            case UIImageOrientation.right, UIImageOrientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: src.size.height)
                transform = transform.rotated(by: CGFloat(-Double.pi/2))
                break
            case UIImageOrientation.up, UIImageOrientation.upMirrored:
                break
            @unknown default:
                break
            }

            switch src.imageOrientation {
            case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
                transform.translatedBy(x: src.size.width, y: 0)
                transform.scaledBy(x: -1, y: 1)
                break
            case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
                transform.translatedBy(x: src.size.height, y: 0)
                transform.scaledBy(x: -1, y: 1)
            case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
                break
            @unknown default:
                break
            }

            let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

            ctx.concatenate(transform)

            switch src.imageOrientation {
            case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
                ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
                break
            default:
                ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
                break
            }

            let cgimg:CGImage = ctx.makeImage()!
            let img:UIImage = UIImage(cgImage: cgimg)

            return img
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        #if targetEnvironment(simulator)
          // simulator 
        #else
          // real device
          picker.sourceType = .camera
          picker.cameraDevice = .front
        #endif
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    

}
