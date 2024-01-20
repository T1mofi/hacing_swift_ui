//
//  NavigationStyleContentView.swift
//  Navigation
//
//  Created by Tima Sikorski on 20/01/2024.
//

import SwiftUI

struct NavigationStyleContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { i in
                Text("Row \(i)")
            }
            .navigationTitle("Title goes here")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.blue, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .toolbar(.automatic)
        }
    }
}

#Preview {
    NavigationStyleContentView()
}