//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andrew Laedies on 5/23/16.
//  Copyright © 2016 Zahed Shareef. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({$0 * $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double,Double) -> (Double))
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private func executePendingOperations() {
        if (pending != nil) {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function) :
                executePendingOperations()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingOperations()
                
            }
        }
    }
        var result: Double {
            get {
                return accumulator
            }
        }
}