import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LogsFormView: View {
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var name = ""
    @State private var amount = ""
    @State private var category = ""
    @State private var date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Amount", text: $amount)
                TextField("Category", text: $category)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newLog = ExpenseLog(name: name, amount: Double(amount) ?? 0, category: category, date: Timestamp(date: date))
                    self.viewModel.addLog(log: newLog)
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarTitle("Create Expense Log")
        }
    }
}
