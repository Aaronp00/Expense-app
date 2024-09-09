//
//  Expense .swift
//  Assignment 2
//
//  Created by Sir Aaron  Patterson on 18/03/2024.
//

import Foundation
import SwiftUI
// Define a class named Expense which conforms to Identifiable, ObservableObject, and Codable protocols
class Expense:Identifiable, ObservableObject,Codable{
    let id = UUID() // Unique identifier for each expense
    
    // Published properties that automatically notify views when their values change
    @Published var name:String
    @Published var number:NSNumber
    @Published var image:UIImage?
    @Published var info:String
    @Published var paid: Bool
    @Published var date: Date
    @Published var paymentDate: Date?
    @Published var expenseDate: Date?
    
    // Properties used for editing purposes
    var editName:String
    var editNumber:NSNumber
    var editInfo:String
    var editPaid:Bool
    @Published var editImage:UIImage?
    var editDate: Date
    var editPaymentDate:Date?
    var editExpenseDate:Date?
    
    // Initialize an Expense object with default parameter values
    init(name: String, number: NSNumber, info: String, paid: Bool = false, date: Date = Date(), paymentDate: Date? = nil, expenseDate: Date? = nil){
        
        self.name = name
        self.number =  number
        self.info = info
        self.paid = paid
        self.date = date
        self.paymentDate = paymentDate
        self.expenseDate = expenseDate
        self.editName = name
        self.editNumber = number
        self.editInfo = info
        self.editPaid = paid
        self.editDate = date
        self.editPaymentDate = paymentDate
        self.editExpenseDate = expenseDate
    }
    
    // Define keys for encoding and decoding
    enum CodingKeys:CodingKey{
        case name, number, id , info ,paid, date , paymentDate,expenseDate
        
    }
    // Encode the Expense object to JSON format
    func encode(to encoder: Encoder) throws{
        writeImageToDisk()  // Save image to disk before encoding
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(number.intValue, forKey: .number)
        try container.encode(info, forKey: .info)
        try container.encode(paid, forKey: .paid)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(paymentDate, forKey: .paymentDate)
        try container.encodeIfPresent(expenseDate, forKey: .expenseDate)
        
    }
    // Decode JSON data to initialize an Expense object
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let loadedName = try container.decode(String.self, forKey: .name)
        let loadedNumber = try container.decode(Int.self, forKey: .number)
        let loadedInfo = try container.decode(String.self, forKey: .info)
        let loadedPaid = try container.decode(Bool.self, forKey: .paid)
        let loadedDate = try container.decode(Date.self, forKey: .date)
        let loadedPaymentDate = try container.decodeIfPresent(Date.self, forKey: .paymentDate)
        let loadedExpenseDate = try container.decodeIfPresent (Date.self, forKey: .expenseDate)
    
        // Assign decoded values to properties        
        name = loadedName
        number = loadedNumber as NSNumber
        info = loadedInfo
        paid = loadedPaid
        date = loadedDate
        paymentDate = loadedPaymentDate
        expenseDate = loadedExpenseDate
        editName = loadedName
        editNumber = loadedNumber as NSNumber
        editInfo = loadedInfo
        editPaid = loadedPaid
        editDate = loadedDate
        editPaymentDate = loadedPaymentDate
        editExpenseDate = loadedExpenseDate
        
        //load image from disk if it exists!
        let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(number).jpg")
        
        if let loadPath = imagePath{
            if let data = try? Data(contentsOf: loadPath){
                self.image = UIImage(data: data)
                print("loaded")
            }
        }
            
    }
    // Save image to disk
    func writeImageToDisk() {
        if let imageToSave = self.image{
            let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(number).jpg") //Don't use the UUID for the image name.
            if let jpegData = imageToSave.jpegData(compressionQuality: 0.5) { // I can adjust the compression quality.
                if let savePath = imagePath{
                    try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
                    print("saved \(savePath)")
                }
            }
        }
    }
    
}


