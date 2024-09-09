//
//  ExpenseDetailVeiw.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import SwiftUI

struct ExpenseDetailVeiw: View {
    @StateObject var expense:Expense
    @State private var vatApplied = false // Flag to track whether VAT has been applied
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Expense Receipt") // Set title
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 200)
        }
        VStack(alignment: .leading){
            Text("Name: \(expense.name)").font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "dollarsign.circle.fill") // SF Symbol for money icon
                    .foregroundColor(.blue) // Customize icon color if needed
                Text("Price: \(formatPrice(expense.number)) GBP")
                Toggle(isOn: $vatApplied) {
                    Text(vatApplied ?  "        Applied(VAT)" : "            Apply(VAT)")
                }
                .onChange(of: vatApplied) { _ in
                    updatePrice()
                }
            }
            
            
            HStack {
                Image(systemName: "text.bubble.fill") // SF Symbol for text bubble icon
                    .foregroundColor(.green) // Customize icon color if needed
                Text("Summary: \(expense.info)")
                
                    .padding()
            }
            if let image = expense.image{
                HStack {
                    Image(systemName: "photo.fill") // SF Symbol for photo icon
                        .foregroundColor(.purple) // Customize icon color if needed
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }
            }
            HStack {
                Image(systemName: "calendar.circle.fill") // SF Symbol for calendar icon
                    .foregroundColor(.orange) // Customize icon color if needed
                // Display the date if needed
                Text("Date added: \(dateFormatter.string(from: expense.date))")
            }
            //Expense Incurred Date:
            HStack {
                Image(systemName: "calendar.circle.fill")
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading) {
                        Text("Expense Incurred Date:")
                            .foregroundColor(.primary)
                        if let expenseDate = expense.expenseDate {
                            Text(dateFormatter.string(from: expenseDate))
                        } else {
                            Text("Not set")
                        }
                    }
        
                DatePicker( "",selection: Binding<Date>(
                        get: { expense.expenseDate ?? Date() },
                        set: { expense.expenseDate = $0 }
                    ), displayedComponents: .date)
                    .padding()
            }
            //Paid expense date
            if expense.paid == true{
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.yellow)
                    
                    Text("Payment Paid On: \(expense.paymentDate != nil ? dateFormatter.string(from: expense.paymentDate!) : "Not set")")
                        .foregroundColor(.primary)
                    
                    .padding()
                    Spacer()
                    DatePicker("", selection: Binding<Date>(
                        get: { expense.paymentDate ?? Date() },
                        set: { expense.paymentDate = $0 }
                    ), displayedComponents: .date)
                    .padding()
                }
            }
        }
            .padding()
            .navigationBarItems(trailing:NavigationLink("Edit"){ExpenseEditView(expense: expense )})
        }
        
        func updatePrice() {
            let originalPrice = expense.number.doubleValue
            let vatRate: Double = 0.20 // Assuming VAT rate is 20%, you can adjust it accordingly
            
            if vatApplied {
                // VAT is applied, so add it to the original price
                let updatedPrice = originalPrice * (1 + vatRate)
                expense.number = NSNumber(value: updatedPrice)
            } else {
                // VAT is not applied, so remove it from the original price
                let updatedPrice = originalPrice / (1 + vatRate)
                expense.number = NSNumber(value: updatedPrice)
            }
        }
    
        //formating thr number function price
        func formatPrice(_ number: NSNumber) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "£"
            return formatter.string(from: number) ?? ""
        }
    }
    #Preview {   ExpenseDetailVeiw(expense:Expense( name:"Example", number:0,info: "'Payment for Bills'")) }
