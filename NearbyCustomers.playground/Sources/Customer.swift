import Foundation

public struct Customer: Decodable {
	
	public let id: Int
	public let name: String
	public let location: Location
	
	enum CodingKeys: String, CodingKey {
		case id = "user_id"
		case name
		case latitude
		case longitude
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		let latitudeString = try container.decode(String.self, forKey: .latitude)
		let longitudeString = try container.decode(String.self, forKey: .longitude)
		if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
			location = Location(latitude, longitude)
		} else {
			throw DecodingError.locationNil
		}
	}
	
	
	/// Loads all the customers from the file and parses them into Customer model
	public static func loadCustomers() -> [Customer] {
		do {
			let content = try string(fromResource: "customers", withExtension: "txt")
			let customers = try content.split { $0.isNewline }.map {
					try JSONDecoder().decode(Customer.self, from: $0.data(using: .utf8)!)
			}
			return customers
			
		} catch let error {
			print(error)
			return []
		}
	}
	
	
	/// Returns a String content of a given resource
	private static func string(fromResource resource: String, withExtension ext: String) throws -> String {
		guard let fileURL = Bundle.main.url(forResource: resource, withExtension: ext) else {
			throw FileError.invalidFileURL
		}
		return try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
	}
	
	
	/// Returns all the customers within the given radius (in kilometers)
	public static func customers(in radius: Double, from location: Location) -> [Customer] {
		return loadCustomers().filter { customer in
			let distance = Location.distance(from: location, to: customer.location)
			return distance < radius
		}
	}
	
}

enum FileError: Error {
	/// FileURL was nil
	case invalidFileURL
}

enum DecodingError: Error {
	/// Location couldnt be parsed
	case locationNil
}
