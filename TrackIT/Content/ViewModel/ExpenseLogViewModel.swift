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
extension ExpenseLogViewModel {
    var pieSlices: [PieSliceData] {
        let grouped = Dictionary(grouping: logs, by: { $0.category })
        let sortedKeys = grouped.keys.sorted()
        var slices: [PieSliceData] = []
        var startAngle: Angle = .degrees(0)

        for category in sortedKeys {
            let total = grouped[category]?.reduce(0) { $0 + $1.amount } ?? 0
            let endAngle = startAngle + .degrees(total / logs.reduce(0) { $0 + $1.amount } * 360)
            slices.append(PieSliceData(startAngle: startAngle, endAngle: endAngle, color: .random, value: total, category: category))
            startAngle = endAngle
        }

        return slices
    }
}
extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
