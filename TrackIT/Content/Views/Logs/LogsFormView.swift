import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LogsFormView: View {
    let categories = ["Food", "Transportation", "Housing", "Utilities", "Entertainment", "Healthcare", "Education", "Shopping", "Travel", "Other"]
    
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory = "Food" // Default category
    @State private var date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Style the picker as a menu
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                }
            .navigationBarItems(
                trailing: Button(action: {
                    saveExpenseLog()
                }) {
                    Text("Save")
                }
            )
            .navigationBarTitle("Create Expense Log")
            .navigationBarBackButtonHidden(true)

        }
    }
    private func saveExpenseLog() {
        let newLog = ExpenseLog(name: name, amount: Double(amount) ?? 0, category: selectedCategory, date: Timestamp(date: date))
        self.viewModel.addLog(log: newLog)
        self.presentationMode.wrappedValue.dismiss()
    }
}
