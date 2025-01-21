//
//  SwiftUIView.swift
//  CountryTask
//
//  Created by Eslam on 21/01/2025.
//

import SwiftUI

struct DetailView: View {
    let country: Country

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Capital: \(country.capital ?? "N/A")")
            Text("Currency: \(country.currencies?.first?.name ?? "N/A") (\(country.currencies?.first?.symbol ?? ""))")
        }
        .padding()
        .navigationTitle(country.name)
    }
}
