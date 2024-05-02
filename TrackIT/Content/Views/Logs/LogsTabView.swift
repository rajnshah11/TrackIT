import SwiftUI
import FirebaseFirestore

struct LogsTabView: View {
    
    @EnvironmentObject var viewModel: ExpenseLogViewModel
    @State private var showingEditSheet = false
    @State private var selectedLog: ExpenseLog? = nil
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedCategories: Set<Category> = Set()
    @State private var sortType: SortType = .date
    @State private var sortOrder: SortOrder = .ascending
    @State private var showLogsForm = false
    @State private var isShowingLogsForm = false
    // DateFormatter for formatting the date
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText, isEditing: $isSearching, placeholder: "Search expenses")
                FilterCategoriesView(selectedCategories: $selectedCategories)
                Divider()
                    SelectSortOrderView(sortType: $sortType, sortOrder: $sortOrder)
                Divider()
                HStack {
                               Button(action: {
                                   // Navigate to the add expense view
                                   self.isShowingLogsForm = true
                               }) {
                                   Image(systemName: "plus")
                                       .foregroundColor(.blue)
                                   Text("Add expense")
                                       .font(.headline)
                                       .foregroundColor(.blue)
                               }
                               Spacer()
                           }
                           .padding(.vertical, 8)
                           .sheet(isPresented: $isShowingLogsForm) {
                               NavigationView {
                                   LogsFormView(log: nil)
                                       .padding(.top, 20)
                                       .navigationBarItems(leading: Button("Back") {
                                           isShowingLogsForm = false
                                       })
                               }
                           }
                List {
                    if viewModel.logs.isEmpty {
                        VStack{
                            Text("No expense added")
                                .font(.headline)
                        } 
                    } else {
                        ForEach(filteredLogs) { log in
                            HStack(spacing: 16) {
                                CategoryImageView(category: log.category)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(log.name).font(.headline)
                                    Text(self.dateFormatter.string(from: log.date.dateValue())).font(.subheadline)
                                }
                                Spacer()
                                Text("\(log.amount)").font(.headline)
                            }
                            .padding(.vertical, 4)
                            .contextMenu {
                                Button(action: {
                                    self.selectedLog = log
                                    self.showingEditSheet = true
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteLogs) // Swipe to delete
                    }
                }
            }
            
            
        }
        .onAppear {
            self.viewModel.fetchData()
        }
        .sheet(item: $selectedLog) { log in
            Spacer()
            LogsFormView(log: log)
        }
    }
    
    private var filteredLogs: [ExpenseLog] {
        var logs = viewModel.logs
        
        // Filter logs based on search text and selected categories
        logs = searchText.isEmpty ? logs : logs.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        logs = selectedCategories.isEmpty ? logs : logs.filter { selectedCategories.contains($0.category) }
        
        // Sort logs based on the selected sort type and order
        switch sortType {
        case .date:
            logs.sort(by: { log1, log2 in
                if sortOrder == .ascending {
                    return log1.date < log2.date
                } else {
                    return log1.date > log2.date
                }
            })
        case .amount:
            logs.sort(by: { log1, log2 in
                if sortOrder == .ascending {
                    return log1.amount < log2.amount
                } else {
                    return log1.amount > log2.amount
                }
            })
        }
        
        return logs
    }

}
