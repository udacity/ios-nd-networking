/*:
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 ****
 # Event Handler Example
 
 Another common scenario that requires escaping closures is when a view needs to hold a reference to a closure. For example, if a view wants to call a closure each time a button is pressed, then an escaping closure could be utilized.
 */

import UIKit
import PlaygroundSupport

// setup
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 In this example, we have a view called `ButtonView`. This view contains an "Increase Count" button, a "Perform Closure" button, and a label displaying a numeric count. The `ButtonView` also has a closure property called `activeClosure` which it is uses to perform an action each time the "Perform Closure" button is pressed.
 */

// MARK: - ButtonView: UIView

class ButtonView: UIView {
    
    // MARK: Properties
    
    var activeClosure: (Void) -> Void = {} // closure property
    var count = 0
    var countLabel: UILabel? = nil
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        // configure view
        super.init(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
        backgroundColor = .white
        
        // create "Increase Count" button
        let increaseCountButton = UIButton(type: .system)
        increaseCountButton.frame = CGRect(x: frame.minX, y: 50, width: frame.width, height: 32)
        increaseCountButton.setTitle("Increase Count", for: .normal)
        increaseCountButton.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        addSubview(increaseCountButton)
        
        // create countLabel
        countLabel = UILabel(frame: CGRect(x: frame.minX, y: 120, width: frame.width, height: 32))
        countLabel?.text = "\(count)"
        countLabel?.textAlignment = .center
        addSubview(countLabel!)
        
        // create "Perform Closure" button
        let printButton = UIButton(type: .system)
        printButton.frame = CGRect(x: frame.minX, y: 190, width: frame.width, height: 32)
        printButton.setTitle("Perform Closure (Print Count)", for: .normal)
        printButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        addSubview(printButton)
    }
    
    // MARK: Run Closure
    
    func performAction() {
        activeClosure()
    }
}

/*:
 Whenever the "Increase Count" button is pressed, the `changeClosure` function is called. This function takes a closure parameter called `closure` that is declared as escaping. It is declared as escaping because the closure needs to be called after `changeClosure` finishes execution (specifically, when the "Perform Closure" button is pressed).
 
 Also, notice when `changeClosure` is called, we must use the `self` keyword. This is required for any values belonging to the `ButtonView` because the closure has been defined as escaping.
 */

// MARK: ButtonView (Saving the Closure)

extension ButtonView {
    
    func increaseCount() {
        count += 1
        if let countLabel = countLabel {
            countLabel.text = "\(count)"
        }
        changeClosure {
            print("the count is \(self.count)")
        }
    }

    func changeClosure(closure: @escaping (Void) -> Void) {
        activeClosure = closure
    }
}

// see example in live view...
let buttonView = ButtonView()
PlaygroundPage.current.liveView = buttonView

/*:
 ****
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 */
