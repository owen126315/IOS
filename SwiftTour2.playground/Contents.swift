//: Playground - noun: a place where people can play

import UIKit

extension Int
{
    var abs: Int
    {
        if(self<0)
        {
            return -self
        }
        
        return self
    }
    
    var digitsCount: Int
    {
        var temp = self
        var count = 1
        while(temp>10)
        {
            temp /= 10
            count += 1
        }
        return count
    }
    
    func isPrime() -> Bool
    {
        for i in 2..<self
        {
            if(self%i == 0)
            {
                return false
            }
        }
        return true
    }
}


var num = -1301081
var pnum = num.abs
pnum.digitsCount
pnum.isPrime()
