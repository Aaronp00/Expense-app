//
//  Expenses.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import Foundation
import SwiftUI

class Expenses:ObservableObject{
    // Published array of expenses and sortBy property to determine sorting order
    @Published var expenses:[Expense] = []
    @Published var sortBy: Int = 0 {
        
            didSet {
                // Sorting expenses based on sortBy value
                switch sortBy {
                case 0:
                    // Sort by name ascending
                    expenses.sort { $0.name < $1.name }
                case 1:
                    // Sort by name descending
                    expenses.sort { $0.name > $1.name }
                case 2:
                    // Sort by paid status
                    expenses.sort { $0.paid && !$1.paid }
                default:
                    break
                }
            }
        }
   
    // Function to get the file URL for saving and loading expenses
    private static func fileURL() throws -> URL{
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false)
            .appendingPathComponent("expenses.data")
    }
    
    
    // Function to save expenses to a file asynchronously
    static func save(expenses:[Expense], completion: @escaping (Result<Int, Error>)->Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let data = try JSONEncoder().encode(expenses)
                let outfile = try fileURL()
                try data.write(to:outfile)
                DispatchQueue.main.async{
                    completion(.success(expenses.count))
                }
            }catch {
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
    }
    // Function to load expenses from a file asynchronously
    static func load(completion: @escaping (Result<[Expense], Error>)->Void){
        DispatchQueue.global(qos: .background).async{
            do{
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async{
                        completion(.success([]))
                    }
                        return
                    }
                let newExpense = try JSONDecoder().decode([Expense].self, from: file.availableData)
                DispatchQueue.main.async{
                    completion(.success(newExpense))
                    }
            }catch{
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
            }
        }
    }
    // Function to remove an expense from the expenses array
 func removeExpense( expense: Expense) {
        if let index =  expenses.firstIndex(where: { $0.id == expense.id }){
            expenses.remove(at: index)
        }
    }
    
    // Function to mark an expense as paid
    func markAsPaid(expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index].paid = true // Mark the expense as paid
        }}
    

    
    
}
