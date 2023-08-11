//
//  ContentView.swift
//  Taxi(Bookkooping)
//
//  Created by Teboho Mohale on 2023/08/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataManager = DataManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.records) { record in
                    NavigationLink(destination: RecordDetail(dataManager: dataManager, record: record)) {
                        Text("\(record.date, formatter: DateFormatter.shortDate)")
                    }
                }
                .onDelete(perform: deleteRecord) // Add onDelete modifier
            }
            .navigationBarTitle("Taxi Records")
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddRecordView(dataManager: dataManager)))
        }
    }

    // Delete function for onDelete modifier
    private func deleteRecord(at offsets: IndexSet) {
        dataManager.records.remove(atOffsets: offsets)
    }
}

struct AddRecordView: View {
    @ObservedObject var dataManager: DataManager
    @State private var earnings = ""
    @State private var petrolExpense = ""
    @State private var serviceExpense = ""
    @State private var selectedDate = Date() // Include this line
    
    var body: some View {
        Form {
            Section(header: Text("Date")) {
                DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
            }
            
            Section(header: Text("Earnings")) {
                TextField("Enter earnings", text: $earnings)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Petrol Expense")) {
                TextField("Enter petrol expense", text: $petrolExpense)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Service Expense")) {
                TextField("Enter service expense", text: $serviceExpense)
                    .keyboardType(.decimalPad)
            }
            
            Button("Save") {
                dataManager.addRecord(date: selectedDate,
                                      earnings: Double(earnings) ?? 0,
                                      petrolExpense: Double(petrolExpense) ?? 0,
                                      serviceExpense: Double(serviceExpense) ?? 0)
            }
            // Optional: Change button color
        }
        
//        Section {
//                       Button("Delete Record") {
//                           dataManager.deleteRecord(record)
//                           // Navigate back to the previous view or dismiss the view
//                       }
//                       .foregroundColor(.red) // Optional: Change button color
//                   }
        .navigationBarTitle("Add Record")
    }
}

struct RecordDetail: View {
    @ObservedObject var dataManager: DataManager
    @State private var editMode: Bool = false
    
    var record: DailyRecord
    
    @State private var updatedEarnings: String = ""
    @State private var updatedPetrolExpense: String = ""
    @State private var updatedServiceExpense: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Date")) {
                Text("\(record.date, formatter: DateFormatter.shortDate)")
            }
            
            Section(header: Text("Earnings")) {
                if editMode {
                    TextField("Enter earnings", text: $updatedEarnings)
                        .keyboardType(.decimalPad)
                } else {
                    Text("$\(record.earnings, specifier: "%.2f")")
                }
            }
            
            Section(header: Text("Petrol Expense")) {
                if editMode {
                    TextField("Enter petrol expense", text: $updatedPetrolExpense)
                        .keyboardType(.decimalPad)
                } else {
                    Text("$\(record.petrolExpense, specifier: "%.2f")")
                }
            }
            
            Section(header: Text("Service Expense")) {
                if editMode {
                    TextField("Enter service expense", text: $updatedServiceExpense)
                        .keyboardType(.decimalPad)
                } else {
                    Text("$\(record.serviceExpense, specifier: "%.2f")")
                }
            }
            
            if editMode {
                Button("Save") {
                    dataManager.updateRecord(record,
                                             with: Double(updatedEarnings) ?? record.earnings,
                                             newPetrolExpense: Double(updatedPetrolExpense) ?? record.petrolExpense,
                                             newServiceExpense: Double(updatedServiceExpense) ?? record.serviceExpense)
                    editMode.toggle()
                }
            }
        }
        .navigationBarTitle("Record Detail")
        .navigationBarItems(trailing: Button(editMode ? "Cancel" : "Edit") {
            if editMode {
                // Discard changes
                updatedEarnings = "\(record.earnings)"
                updatedPetrolExpense = "\(record.petrolExpense)"
                updatedServiceExpense = "\(record.serviceExpense)"
            }
            editMode.toggle()
        })
        .onAppear {
            updatedEarnings = "\(record.earnings)"
            updatedPetrolExpense = "\(record.petrolExpense)"
            updatedServiceExpense = "\(record.serviceExpense)"
        }
    }
}


//@main
//struct TaxiApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
