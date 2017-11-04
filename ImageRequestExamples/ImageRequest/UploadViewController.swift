//
//  UploadViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - UploadViewController: ExampleViewController

class UploadViewController: ExampleViewController {
    
    // MARK: Properties
    
    var imageToUpload: UIImage?
    
    let imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        return controller
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add upload button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload Image", style: .plain, target: self, action: #selector(selectImage))
        
        // respond to image picker events
        imagePickerController.delegate = self
    }
    
    // MARK: Actions
    
    @objc func selectImage() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Upload
    
    func uploadImage(_ image: UIImage) {
        guard let imageData = UIImagePNGRepresentation(image) else { return }

        // FIXME: Make an upload request
        print("Make an upload request using the image data: \(imageData)")
    }
}

// MARK: - UploadViewController: URLSessionDataDelegate

extension UploadViewController: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // FIXME: If task was successful, then update the UI
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        // FIXME: Print upload progress
    }
}

// MARK: - UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToUpload = image
            uploadImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
