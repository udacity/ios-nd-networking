/*:
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 ****
 # Simple Example
 
 ## A Nonescaping Closure
 
 The function `justDoIt` takes a closure parameter called `it`. The `it` closure is only used within the body of the function, and it is considered **nonescaping**.
 */

func justDoIt(it: (Void) -> Void) {
    // the closure never escapes the body of the function
    it()
}

justDoIt {
    print("print me now!")
}

/*:
 
 ## An Escaping Closure
 
 The function `doItLater` also takes a closure parameter called `it`. In the function, the `it` closure is saved so that it can be used at a later time. Therefore `it` must be specified as **escaping** (by using the @escaping syntax) because it can be called after `doItLater` finishes executing.
 */

var somethingToDo: (Void) -> Void = {}

func doItLater(it: @escaping (Void) -> Void) {
    // keep a reference to `it` so we can call it later...
    somethingToDo = it
}

// this only keeps a reference to the closure
doItLater {
    print("print me later...")
}

// here is where we call the closure (after doItLater has finished)
somethingToDo()

/*:
 ****
 [Table of Contents](Table%20of%20Contents) | [Previous](@previous) | [Next](@next)
 */
