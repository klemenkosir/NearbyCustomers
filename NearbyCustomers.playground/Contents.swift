import Foundation
import PlaygroundSupport

/// Office location
let officeLocation = Location(53.339428, -6.257664)

/// Radius (in km)  in which we want the customers from
let radius = 100.0


/// Customers within the given radius from the office
let nearbyCustomers = Customer.customers(in: radius, from: officeLocation)

/// Sorts and maps the customers to the String for output
let output = nearbyCustomers.sorted { $0.id < $1.id }
	.map { (customer) -> String in
	return "\(customer.id)\t\(customer.name)"
}.joined(separator: "\n")


/// Prints the output
print(output)
