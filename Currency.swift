//
//  Currency.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//
import SwiftUI

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let rateToUAH: Double // Курс до гривні

    static let availableCurrencies: [Currency] = [
        Currency(code: "UAH", rateToUAH: 1.0),
        Currency(code: "USD", rateToUAH: 0.036),
        Currency(code: "EUR", rateToUAH: 0.032)
    ]
}
