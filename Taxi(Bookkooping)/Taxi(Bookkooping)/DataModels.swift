//
//  DataModels.swift
//  Taxi(Bookkooping)
//
//  Created by Teboho Mohale on 2023/08/10.
//

import Foundation

struct DailyRecord: Identifiable {
    let id = UUID()
    let date: Date
    var earnings: Double
    var petrolExpense: Double
    var serviceExpense: Double
}

class DataManager: ObservableObject {
    @Published var records: [DailyRecord] = []
    
    // Function to add a new record
    func addRecord(date: Date, earnings: Double, petrolExpense: Double, serviceExpense: Double) {
        let newRecord = DailyRecord(date: date, earnings: earnings, petrolExpense: petrolExpense, serviceExpense: serviceExpense)
        records.append(newRecord)
    }
    
    // Function to update an existing record
    func updateRecord(_ record: DailyRecord, with newEarnings: Double, newPetrolExpense: Double, newServiceExpense: Double) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index].earnings = newEarnings
            records[index].petrolExpense = newPetrolExpense
            records[index].serviceExpense = newServiceExpense
        }
    }
    
    // Function to delete a record
    func deleteRecord(_ record: DailyRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records.remove(at: index)
        }
    }
}
