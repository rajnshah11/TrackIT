import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExpenseLogViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var logs = [ExpenseLog]()
    
    func fetchData() {
        db.collection("expenseLogs").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.logs = documents.compactMap { document in
                try? document.data(as: ExpenseLog.self)
            }
        }
    }
    
    func addLog(log: ExpenseLog) {
        do {
            _ = try db.collection("expenseLogs").addDocument(from: log)
        } catch {
            print(error)
        }
    }
    
    // Add update and delete methods as needed
}
