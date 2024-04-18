//
//  LogsTabView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//

import SwiftUI


struct LogsTabView: View {
    
    @EnvironmentObject var viewModel: ExpenseLogViewModel
       
       var body: some View {
           NavigationView {
               List(viewModel.logs) { log in
                   Text(log.name)
               }
               .navigationBarTitle("Expense Logs")
               .navigationBarItems(trailing: NavigationLink(destination: LogsFormView()) {
                   Image(systemName: "plus")
               })
               .navigationBarBackButtonHidden(true)

           }
           .onAppear {
               self.viewModel.fetchData()
           }
       }
}
