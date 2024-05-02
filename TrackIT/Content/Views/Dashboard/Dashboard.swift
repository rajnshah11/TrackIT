//
//  Dashboard.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//
import SwiftUI
import Firebase
import SwiftUI
import SwiftUICharts
 
struct Dashboard: View {
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var totalExpenses: Double = 0
    @State private var categoriesSum: [CategorySum] = []
    var body: some View {
        ScrollView{
            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("Total expenses")
                        .font(.headline)
                    Text(totalExpenses.formattedCurrencyText)
                        .font(.largeTitle)
                }
                
                if totalExpenses > 0 {
                    PieChartView(
                        data: categoriesSum.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                    Divider()
                    List {
                        Text("Breakdown").font(.headline)
                        ForEach(categoriesSum) { categorySum in
                            CategoryRowView(category: categorySum.category, sum: categorySum.sum)
                        }
                    }
                } else {
                    Text("No expenses data\nPlease add your expenses from the logs tab")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .onAppear{
                fetchData()
            }
        }
    }
   
    func fetchData() {
        guard !viewModel.logs.isEmpty else { return }
        
        totalExpenses = viewModel.logs.map { $0.amount }.reduce(0, +)
        categoriesSum = viewModel.logs.reduce(into: [Category: Double]()) { dict, log in
            dict[log.category, default: 0] += log.amount
        }.map { CategorySum(sum: $0.value, category: $0.key) }
    }
}

struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    var id: String { "\(category)\(sum)" }
}
