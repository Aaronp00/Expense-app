//
//  ExpenseRowView.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import SwiftUI
struct ExpenseRowView: View {
    @StateObject var expense:Expense
    
    var body: some View {
        HStack{
            Text(expense.name.prefix(1))
                .font(.title2)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding(0.0)
                .frame(width: 40.0, height: 40.0)
                .background(Color.blue)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text(expense.name)
            }.padding(.leading, 15.0)
            Spacer()
            
            // Checkmark indicating paid status
            Image(systemName: expense.paid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(expense.paid ? .green : .gray )
                .font(.title2)
                .padding(.trailing, 10) // Add padding for better tap area
                .onTapGesture {
                    
                    // Toggle the paid status when the checkmark is tapped
                    expense.paid.toggle()
                
                }
    }.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)) // Add padding around the row
    }
    struct ExpenseRowView_Previews: PreviewProvider {
        static var previews: some View {
            ExpenseRowView(expense: Expense(name: " Expense", number: 100, info: "", paid: false))
                .previewLayout(.fixed(width: 300, height: 100))
        }
    }
}
    

