//
//  Order.swift
//  CupcakeCorner
//
//  Created by Pavel Bartashov on 2/10/2024.
//

import Foundation

@Observable
final class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0 {
        didSet {
            save()
        }
    }

    var quantity = 3 {
        didSet {
            save()
        }
    }

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }

            save()
        }
    }

    var extraFrosting = false {
        didSet {
            save()
        }
    }

    var addSprinkles = false {
        didSet {
            save()
        }
    }

    var name = "" {
        didSet {
            save()
        }
    }

    var streetAddress = "" {
        didSet {
            save()
        }
    }

    var city = "" {
        didSet {
            save()
        }
    }

    var zip = ""
    {
        didSet {
            save()
        }
    }

    var hasValidAddress: Bool {
        name.hasValidContent
        && streetAddress.hasValidContent
        && city.hasValidContent
        && zip.hasValidContent
    }

    var cost: Decimal {
        // $2 for cake
        var cost = Decimal(quantity) * 2

        // complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }

    init() {
        guard
            let data = UserDefaults.standard.data(forKey: .orderUserDefaultsKey),
        let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return
        }

        self.type = decoded.type
        self.quantity = decoded.quantity
        self.specialRequestEnabled = decoded.specialRequestEnabled
        self.extraFrosting = decoded.extraFrosting
        self.addSprinkles = decoded.addSprinkles
        self.name = decoded.name
        self.streetAddress = decoded.streetAddress
        self.city = decoded.city
        self.zip = decoded.zip
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: .orderUserDefaultsKey)
        }
    }
}

extension Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
}

// MARK: - Misc

fileprivate extension String {
    var hasValidContent: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - UserDefaults

fileprivate extension String {
    static let orderUserDefaultsKey = "Order"
}

