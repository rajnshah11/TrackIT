//
//  FilterCategoriesView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//

import SwiftUI

struct FilterCategoriesView: View {
    
    // define some variables
    @Binding var selectedCategories: Set<Category>
    private let categories = Category.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    FilterButtonView(
                        category: category,
                        isSelected: self.selectedCategories.contains(category),
                        onTap: self.onTap
                    )
                    .id(category) // Provide an identifier
                    .padding(.leading, category == self.categories.first ? 16 : 0)
                    .padding(.trailing, category == self.categories.last ? 16 : 0)
                }
            }
        }
        .padding(.vertical)
    }
    
    func onTap(category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct FilterButtonView: View {
    
    var category: Category
    var isSelected: Bool
    var onTap: (Category) -> ()
    
    var body: some View {
        Button(action: {
            self.onTap(self.category)
        }) {
            HStack(spacing: 8) {
                Text(category.rawValue.capitalized)
                    .fixedSize(horizontal: true, vertical: true)
                
                if isSelected {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
                
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? category.color : Color(UIColor.lightGray), lineWidth: 1))
                .frame(height: 44)
        }
        .foregroundColor(isSelected ? category.color : Color(UIColor.gray))
    }
    
    
}
