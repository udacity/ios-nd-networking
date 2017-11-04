//
//  SearchViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - SearchViewController: UIViewController

class SearchViewController: UIViewController {
    
    // MARK: Properties
    
    var activeTextField: UITextField?
    let searchDataSource = SearchDataSource()
    
    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var phraseSearchButton: UIButton!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latLonSearchButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDataSource.delegate = self        
        phraseTextField.delegate = self
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Search Actions
    
    @IBAction func search(_ sender: AnyObject) {
        userDidTapView(self)
        setUIEnabled(false, withPhotoText: "Searching...")
        
        guard let tag = sender.tag else { return }
        
        if tag == 0 {
            searchByPhrase()
        } else {
            searchByLocation()
        }
    }
    
    private func searchByPhrase() {
        guard let phrase = phraseTextField.text, !phrase.isEmpty else {
            presentAlert(forError: FlickrError.emptyPhrase) { (alert) in
                self.setUIEnabled(true)
            }
            return
        }
        
        searchDataSource.searchForRandomPhoto(withRequest: .searchPhotosByPhrase(phrase, page: nil))
    }
    
    private func searchByLocation() {
        guard let latitude = Double(latitudeTextField.text ?? ""), let longitude = Double(longitudeTextField.text ?? ""), latitude.inRange(Flickr.searchLatRange), longitude.inRange(Flickr.searchLatRange) else {
            presentAlert(forError: FlickrError.invalidLocation) { (alert) in
                self.setUIEnabled(true)
            }
            return
        }
        
        searchDataSource.searchForRandomPhoto(withRequest: .searchPhotosByLocation(latitude: latitude, longitude: longitude, page: nil))
    }
}

// MARK: - SearchViewController: SearchDataSourceDelegate

extension SearchViewController: SearchDataSourceDelegate {
    
    func searchDataSourceDidFetchPhoto(searchDataSource: SearchDataSource) {
        setUIEnabled(true, withPhotoText: searchDataSource.photo?.title)
        photoImageView.image = searchDataSource.image
    }
    
    func searchDataSource(_ searchDataSource: SearchDataSource, didFailWithError error: Error) {
        presentAlert(forError: error) { (alert) in
            self.setUIEnabled(true)
        }
    }
}

// MARK: - SearchViewController: UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // apply inset to move scroll view up when keyboard appears
        let inset = keyboardHeight(forNotification: notification) * 1.5
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
        
        guard let activeTextField = activeTextField else {
            return
        }
        
        // if text field is obscured by the keyboard, then scroll to it
        var aRect = view.frame
        aRect.size.height -= inset
        if !aRect.contains(activeTextField.frame.origin) {
            mainScrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardHeight(forNotification notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        
        if let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return keyboardSize.cgRectValue.height
        } else {
            return 0
        }
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(phraseTextField)
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
    }
}

// MARK: - SearchViewController (Configure UI)

private extension SearchViewController {
    
    func setUIEnabled(_ enabled: Bool, withPhotoText photoText: String? = "") {
        photoTitleLabel.isEnabled = enabled
        phraseTextField.isEnabled = enabled
        latitudeTextField.isEnabled = enabled
        longitudeTextField.isEnabled = enabled
        phraseSearchButton.isEnabled = enabled
        latLonSearchButton.isEnabled = enabled
        
        phraseSearchButton.alpha = enabled ? 1.0 : 0.5
        latLonSearchButton.alpha = enabled ? 1.0 : 0.5
        
        photoTitleLabel.text = photoText
    }
}

// MARK: - SearchViewController (Notifications)

private extension SearchViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
