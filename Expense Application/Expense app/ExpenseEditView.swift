//
//  ExpenseEditView.swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 20/03/2024.
//


import SwiftUI
import LocalAuthentication


struct ExpenseEditView: View {
    // StateObject for observing changes in expense object
    @StateObject var expense:Expense
    // Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    // State variable for handling image selection
    @State private var inputImage: UIImage?
    //variable to check if user has authenticated
    @State private var showImagePicker = false
    
    // Function to load selected image into the expense object
    func loadImage(){
        guard let inputImage = inputImage else {return}
        expense.editImage = inputImage
    }

    var body: some View {
        VStack(alignment: .leading){
            // Display selected image or tap to select
            ZStack{
                Rectangle().fill(.secondary)
                Text("Tap to select a picture")
                    .foregroundColor(.white)
                    .font(.headline)
                if let image = expense.editImage{
                    Image(uiImage:image).resizable().aspectRatio(contentMode: .fit)
                }
            }.onTapGesture {
                showImagePicker = true
            }
            // Text fields for editing expense details
            TextField("Name", text: $expense.editName)
            TextField("Price £", text: Binding<String>(
                get: { "\(expense.editNumber)" },
                set: { newValue in
                    if let value = Double(newValue) {
                        expense.editNumber = NSNumber(value: value)
                    }
                }
            ))
            .keyboardType(.decimalPad) 
            
            TextField("Summary",text: $expense.editInfo)
        }.navigationBarItems(trailing:Button("Save"){
            
            //authenticate the save
            authenticateSave()
        })
        .onChange(of: inputImage){_ in loadImage()}
        .sheet(isPresented: $showImagePicker){
            ImagePicker(image: $inputImage)
        }
        //If the user hides the view before saving, then we cancel changes
        .onDisappear{resetEditFields()
        
        }
    }
    // Function to authenticate and save changes to the expense
    func authenticateSave() {
        expense.name = expense.editName
        expense.number = expense.editNumber
        expense.info = expense.editInfo
        expense.image = expense.editImage
    
    dismiss()

    }
    // Function to reset edit fields if changes are not saved
    func resetEditFields() {
          expense.editName = expense.name
          expense.editNumber = expense.number
          expense.editInfo = expense.info
          expense.editImage = expense.image
      }

    
}

 #Preview {
     ExpenseDetailVeiw(expense:Expense(name:"Example", number:0, info: "'Payment for Bills'"))}
