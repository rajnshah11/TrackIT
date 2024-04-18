//
//  LocateUsView.swift
//  TrackIT
//
//  Created by Vrushali Shah on 4/17/24.
//
import SwiftUI
import Firebase
import CoreData

struct LocateUsView: View {
    
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
           }
           .onAppear {
               self.viewModel.fetchData()
           }
       }

}
