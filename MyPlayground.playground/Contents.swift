import UIKit

func stepForward(_ input:Int) -> Int{
    return input+1
}

func stepBackward(_ input:Int) -> Int{
    return input-1
}

func chooseStepFunction(backward:Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
var currentValue = 4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)

print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
