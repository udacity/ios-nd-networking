/*:
 
 # Nonescaping and Escaping Closures
 
 As of Swift 3, when a closure is passed into a function it is considered **nonescaping** by default. A nonescaping closure can only be used within the body of the function and nowhere else. Or, more simply, "a nonescaping closure is trapped inside the body of a function".
 
 ![Mouse Trapped in a Cage](mouse-in-a-cage.jpg "Help! I'm trapped!")
 
 But, there are cases like asynchronous control flow when a closure should be able to escape the body of the function to which it is passed. When this happens, we must specify a closure parameter as **escaping** by using the @escaping syntax.
 
 - [Simple Example](Simple%20Example)
 - [Async Network Example](Async%20Network%20Example)
 - [Event Handler Example](Event%20Handler%20Example)
 - [Summary](Summary)
 
 ****
 [Next](@next)
 */
