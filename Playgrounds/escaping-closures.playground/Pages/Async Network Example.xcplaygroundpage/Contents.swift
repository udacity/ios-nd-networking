/*:
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 ****
 # Async Network Example
 
 One of the most common scenarios where you will see escaping closures is when you are working with asynchronous network requests.
 */

import UIKit
import Foundation
import PlaygroundSupport

// setup
var myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
let myImageURL = URL(string: "https://avatars0.githubusercontent.com/u/1331063?v=3&s=400")!
PlaygroundPage.current.liveView = myImageView
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 Consider the following example. Let's say we want to write a function that downloads an image over the network. Also, when the function completes, we want to update our UI to display the newly downloaded image. It might look something like this...
 */

func downloadAndDisplayImage(imageURL: URL, updateImage: @escaping (UIImage?) -> Void) {
    
    // create network request
    let task = URLSession.shared.dataTask(with: myImageURL) { (data, response, error) in
        
        // if no error, then create image and pass it to the completion handler
        if let downloadedImage = UIImage(data: data!), error == nil {
            DispatchQueue.main.async {
                updateImage(downloadedImage)
            }
        } else {
            // otherwise, pass nil to the completion handler
            DispatchQueue.main.async {
                updateImage(nil)
            }
        }
    }
    
    task.resume()
}

/*:
 In the above example, the `updateImage` parameter is a closure used to update our UI with the downloaded image. It is specified as an **escaping** closure. This is because the `updateImage` closure needs to outlive the `downloadAndDisplayImage` function. When `downloadAndDisplayImage` is called it kicks off a network request and the function quickly exits. However, the `updateImage` closure still needs to be called once the network request finishes which happens at an indeterminate amount of time after `downloadAndDisplayImage` exits. Therefore, `updateImage` will be used outside of the body of the original function (when the network request finishes) and should be declared as escaping.
 */

// see example in live view...
downloadAndDisplayImage(imageURL: myImageURL) { downloadedImage in
    // set image and live view
    myImageView.image = downloadedImage
}

/*:
 ****
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 */
