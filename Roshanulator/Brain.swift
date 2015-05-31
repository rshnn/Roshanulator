//
//  Brain.swift
//  Roshanulator
//
//  Created by Roshan Patel on 5/25/15.
//  Copyright (c) 2015 Roshan Patel. All rights reserved.
//

import Foundation

class Brain
{
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double)-> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        knownOps["x"] = Op.BinaryOperation("x",*)
        knownOps["+"] = Op.BinaryOperation("+",+)
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["√"] = Op.UnaryOperation("√",sqrt)

    }
    
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
     
        if !ops.isEmpty{
            var remainingOps = ops;
            let op = remainingOps.removeLast();
            
            switch op{
                case .Operand(let operand):
                    return(operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
                
            case .BinaryOperation(_, let operation):
                let op1Eval = evaluate(remainingOps)
                if let operand1 = op1Eval.result{
                    let op2Eval = evaluate(op1Eval.remainingOps)
                    if let operand2 = op2Eval.result{
                        return (operation(operand1, operand2), op2Eval.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, _ ) = evaluate(opStack)
        return result;
    }
    
    
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand));
        return evaluate();
    }
    
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }

    
    
}
