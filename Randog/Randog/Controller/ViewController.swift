//
//  ViewController.swift
//  Randog
//
//  Created by Owen LaRosa on 10/16/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageURL = URL(string: imageData?.message ?? "") else {
            return
        }
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
        
    }

    func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
}

