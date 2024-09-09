//
//  ExpenseAddview.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import SwiftUI
import Foundation


struct ExpenseAddView: View {
    @ObservedObject var expenseList:Expenses
    //boolean to control the presence of the image picker
    @State private var showImagePicker = false
    @State var image:Image?
    @State private var inputImage: UIImage?
    @StateObject var newExpense = Expense(name:"", number:0, info: "")
    @Environment(\.dismiss) private var dismiss

   
    func loadImage(){
        guard let inputImage = inputImage else {return}
        //store the image as a view for this screen
        image = Image(uiImage:inputImage)
        //save the image data to the contact
        newExpense.image = inputImage
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    dismiss()
                }){
                    Text("Cancel")
                }
                Spacer()
                Button(action:{
                    newExpense.date = Date()
                    expenseList.expenses.append(newExpense)
                    //trigger a sort here to keep things in order.
                    dismiss()
                }){
                    Text("Save")
                }
            }.padding()
            VStack(alignment: .leading){
                ZStack{
                    Rectangle().fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    image?.resizable().scaledToFit()
                }.onTapGesture {
                    showImagePicker = true
                }
                Text("Name")
                TextField("Expense name:", text:$newExpense.name)
                TextField("Price £:", text: Binding<String>(
                                    get: { "\(newExpense.number.doubleValue)" },
                                    set: { newValue in
                                        if let value = Double(newValue) {
                                            newExpense.number = NSNumber(value: value)
                                        }
                                    }
                                )).keyboardType(.decimalPad)
                
                TextField("Summary:", text:$newExpense.info)
            }.padding()
            Spacer()
                .onChange(of: inputImage){_ in loadImage()}
                .sheet(isPresented: $showImagePicker){
                    ImagePicker(image: $inputImage)
                }
        }
    }
}



 #Preview {
   ExpenseAddView(expenseList:Expenses())
    
}

