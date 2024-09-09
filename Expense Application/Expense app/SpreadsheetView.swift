//
//  ContentView.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import SwiftUI


struct SpreadsheetView: View {
    @State var showView = false
    @State var searchText = ""
    @ObservedObject var data:Expenses
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var body: some View{
     

        NavigationView{
            List(data.expenses.filter(
                {"\($0.name)"                                                                                                                                                                                              .localizedCaseInsensitiveContains(searchText) || searchText.isEmpty
        
                })){ expense in NavigationLink(destination:ExpenseDetailVeiw(expense: expense)) {
                    ExpenseRowView(expense: expense)
                }
                    
               .swipeActions {
                    
                    Button(role: .destructive) {
                            // Remove the expense from the data
                            data.removeExpense(expense: expense)
                        } label: {
                            Label("Delete", systemImage: "trash.circle.fill")
                        }
                
                    
                }
                    
                    
        
                    
                    
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            
                                Button {
                                    
                                        // Implement logic to mark expense as paid
                                    data.markAsPaid(expense:expense) // Assuming you have a method to mark an expense as paid
                                    } label: {
                                        Label("Mark as Paid", systemImage: "checkmark.circle.fill")
                                    }
                                    .tint(.green)
                }
                    
                    
                    
               
                    
                
                }
            
                .navigationTitle("Expenses")
            
               .toolbar{
                   ToolbarItem(placement: .topBarLeading  ){
                       
                       Button(" Add",systemImage: "person.fill.badge.plus"){
                           showView.toggle()
                           
                       }.sheet(isPresented:$showView){ExpenseAddView(expenseList:data)}
                    
                   }
                   
                   ToolbarItem(placement: .primaryAction){
                       
                       
                       Menu{
                         Picker(selection:$data.sortBy, label:
                                 Text("Sorting Options")){
                                 Text("A-Z").tag(0)
                                 Text("Z-A").tag(1)
                             Text("Paid " ).tag(2)
                             
                             
                             
                         }
                     }
                        
                 label:{
                     Label("Sort", systemImage:"arrow.up.arrow.down")
                    }
            
                   }
               }
                

        }.searchable(text:$searchText)
                        .onChange(of: scenePhase){ phase in
                            if phase == .inactive { saveAction()}
                    }
       }
}

   #Preview {
       SpreadsheetView(data:Expenses(),saveAction:{})}
