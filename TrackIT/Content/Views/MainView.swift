import SwiftUI
import Firebase
import SwiftUI
import Firebase

struct MainView: View {
    let firebaseManager = FirebaseManager.shared
    let viewModel = ExpenseLogViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            TabView {
                LogsTabView().environmentObject(viewModel)
                    .tabItem {
                        VStack {
                            Text("Expense Logs")
                            Image(systemName: "tray")
                        }
                    }.tag(0)
                Dashboard()
                    .tabItem {
                        VStack {
                            Text("Dashboard")
                            Image(systemName: "chart.pie")
                        }
                    }
                    .tag(1)
                
                FinanceNewsView().tabItem {
                    VStack {
                        Text("Financial News")
                        Image(systemName: "newspaper")
                    }
                }
                .tag(2)
                ExpenseVideo().tabItem {
                    VStack {
                        Text("Expense Video")
                        Image(systemName: "video")
                    }
                }
                .tag(3)
                
            }.environmentObject(viewModel)
                .navigationBarItems(trailing:
                                NavigationLink(destination: ProfileMenuView()) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(colorScheme == .dark ? .white : .black) // Change color based on system-wide appearance
                                        .frame(width: 24, height: 24)
                                }
                            )
                            .edgesIgnoringSafeArea(.bottom)
                        }
    }
}
