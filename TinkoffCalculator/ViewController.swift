//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by @_@ on 25.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Enums
    enum CalculatorError: Error {
        case divideByZero
    }
    
    enum Operation: String {
        case add = "+"
        case substract = "-"
        case divide = "/"
        case multiply = "x"
        
        func calculate(lhs: Double, rhs: Double) throws -> Double {
            switch self {
            case .add:
                return lhs + rhs
                
            case .substract:
                return lhs - rhs
                
            case .divide:
                if rhs == 0 {
                    throw CalculatorError.divideByZero
                } else {
                    return lhs / rhs
                }
                
            case .multiply:
                return lhs * rhs
            }
        }
    }
    
    enum CalculationHistoryItem {
        case number(Double)
        case operation(Operation)
    }
    
    // MARK: - Variables
    @IBOutlet var label: UILabel!
    
    var calculationHistory = [CalculationHistoryItem]()
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: - Functions
    @IBAction func clearButtonTapped() {
        calculationHistory.removeAll()
        
        resetLabel()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if label.text == "Zero division" {
            resetLabel()
        }
        
        if case .operation(_) = calculationHistory.last {
            resetLabel()
        }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" && buttonText != "," {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
    }
    
    @IBAction func calculateButtonTapped() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Zero division"
        }
        
        calculationHistory.removeAll()
    }
    
    func resetLabel() {
        label.text = "0"
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentRusult = firstNumber
        
        for index in stride(from: 1, through: calculationHistory.count-1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index+1]
            else { break }
            
            currentRusult = try operation.calculate(lhs: currentRusult, rhs: number)
        }
        
        return currentRusult
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetLabel()
    }
}

