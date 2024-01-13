//
//  ContentView.swift
//  iExpense
//
//  Created by Tima Sikorski on 29/12/2023.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter({ item in
                        item.type == "Personal"
                    })) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(colorForAmount(item.amount))
                        }
                    }
                    .onDelete(perform: removeItemsPersonal)
                }
                Section("Business") {
                    ForEach(expenses.items.filter({ item in
                        item.type == "Business"
                    })) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(colorForAmount(item.amount))
                        }
                    }
                    .onDelete(perform: removeItemsBusiness)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                .background(.blue)
                EditButton()
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }

    func removeItemsPersonal(at offsets: IndexSet) {
        for index in offsets {
            let item = expenses.items.filter({ item in item.type == "Personal" })[index]
            if let sectionIndex = expenses.items.firstIndex(of: item) {
                expenses.items.remove(at: sectionIndex)
            }
        }
    }

    func removeItemsBusiness(at offsets: IndexSet) {
        for index in offsets {
            let item = expenses.items.filter({ item in item.type == "Business" })[index]
            if let sectionIndex = expenses.items.firstIndex(of: item) {
                expenses.items.remove(at: sectionIndex)
            }
        }
    }

    func colorForAmount(_ amount: Int) -> Color {
        switch amount {
        case 10...100:
            return .green
        case 100...:
            return .red
        default:
            return .black
        }
    }
}

#Preview {
    ContentView()
}
