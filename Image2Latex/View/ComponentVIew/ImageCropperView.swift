//
//  ImageCropperView.swift
//  Image2Latex
//
//  Created by Butanediol on 18/4/2021.
//
import Foundation
import Mantis
import SwiftUI

class MantisCoordinator: NSObject, CropViewControllerDelegate {
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
    
    var image: UIImage
    @Binding var showView: Bool
    var imageWasEdited: (UIImage?) -> Void

    init(image: UIImage, showView: Binding<Bool>, imageWasEdited: @escaping (UIImage?) -> Void) {
        self.image = image
        _showView = showView
        self.imageWasEdited = imageWasEdited
    }

    func cropViewControllerDidCrop(_: CropViewController, cropped: UIImage, transformation _: Transformation) {
        // self.$image.wrappedValue = cropped
        imageWasEdited(cropped)
        $showView.wrappedValue = false
    }

    func cropViewControllerDidCancel(_: CropViewController, original _: UIImage) {
        // self.$image.wrappedValue = original
        $showView.wrappedValue = false
    }

    func cropViewControllerDidFailToCrop(_: CropViewController, original _: UIImage) {
        // self.$image.wrappedValue = original
        $showView.wrappedValue = false
    }

    func cropViewControllerWillDismiss(_: CropViewController) {
        $showView.wrappedValue = false
    }
}

struct MantisController: UIViewControllerRepresentable {
    func updateUIViewController(_: CropViewController, context _: UIViewControllerRepresentableContext<MantisController>) {}

    var image: UIImage
    @Binding var showView: Bool

    var imageWasEdited: (UIImage?) -> Void

    var cropShape: CropShapeType = .ellipse(maskOnly: true)

    func makeCoordinator() -> MantisCoordinator {
        return (MantisCoordinator(image: image, showView: $showView, imageWasEdited: imageWasEdited))
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MantisController>) -> CropViewController {

        let cropViewController = Mantis.cropViewController(image: image)

        cropViewController.modalPresentationStyle = .fullScreen
        cropViewController.mode = .normal

        cropViewController.delegate = context.coordinator

        return (cropViewController)
    }
}
