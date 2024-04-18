//
//  SearchBar.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(.leading, 30)
                .padding(.vertical, 8)
                .padding(.trailing, 20)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.text = ""
                    self.isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
        .padding(.vertical)
    }
}
