//
//  Assignment_2App.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//
import SwiftUI

@main
struct Assignment_2App: App {
    @StateObject private var data = Expenses()
    var body: some Scene {
        WindowGroup {
            SpreadsheetView(data:self.data){
                
                Expenses.save(expenses: data.expenses){ result in
                    if case .failure(let error) = result{
                        fatalError(error.localizedDescription)
                    }
                }
            }.onAppear{
                Expenses.load{ result in
                    switch result{
                    case .failure(let error):
                    fatalError(error.localizedDescription)
                    case .success(let expenses):
                        data.expenses = expenses
                    }
                    
                }
            }
        }
    }
}

