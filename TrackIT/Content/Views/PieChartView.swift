//
//  PieChartView.swift
//  TrackIT
//
//  Created by Dikshita Rajendra Patel on 17/04/24.
//

import Foundation
import SwiftUI

struct PieChartView: View {
    var slices: [PieSliceData]

    func textOffset(for slice: PieSliceData, in geometry: GeometryProxy) -> CGSize {
        let midAngle = (slice.startAngle + slice.endAngle) / 2
        let radius = min(geometry.size.width, geometry.size.height) / 2 * 0.35 // Adjust radius as necessary
        let x = cos(CGFloat(midAngle.radians)) * radius
        let y = sin(CGFloat(midAngle.radians)) * radius
        return CGSize(width: x, height: y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(slices.indices, id: \.self) { index in
                    PieSliceView(slice: slices[index])
                        .overlay {
                            let offset = self.textOffset(for: slices[index], in: geometry)
                            Text("\(slices[index].category)\n\(slices[index].value, specifier: "%.2f")")
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                .offset(x: offset.width, y: offset.height)
                        }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


struct PieSliceView: View {
    var slice: PieSliceData
    var radiusFraction: CGFloat = 0.35 // You can adjust the radius as needed

    var midAngle: Angle {
        return (slice.startAngle + slice.endAngle) / 2
    }

    func textOffset(in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height) / 2 * radiusFraction
        let x = cos(CGFloat(midAngle.radians)) * radius
        let y = sin(CGFloat(midAngle.radians)) * radius
        return CGSize(width: x, height: y)
    }

    var body: some View {
        Path { path in
            let width: CGFloat = 100
            let height: CGFloat = 100
            path.move(to: CGPoint(x: width / 2, y: height / 2))
            path.addArc(center: .init(x: width / 2, y: height / 2),
                        radius: width / 2,
                        startAngle: slice.startAngle,
                        endAngle: slice.endAngle,
                        clockwise: false)
        }
        .fill(slice.color)
    }
}

