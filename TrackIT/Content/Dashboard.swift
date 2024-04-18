//
//  Dashboard.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//
import SwiftUI
import Firebase



struct Dashboard: View {
    @EnvironmentObject var viewModel: ExpenseLogViewModel
  
    var body: some View {
        PieChartView(slices: viewModel.pieSlices)
            .padding()
            .frame(height: 300)
            .onAppear {
                viewModel.fetchData()
            }
    }
}

