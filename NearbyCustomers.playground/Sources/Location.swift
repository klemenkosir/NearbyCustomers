import Foundation

public struct Location {
	
	let latitude: Double
	let longitude: Double
	
	public init(_ latitude: Double, _ longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	var longitudeRad: Double {
		longitude.degreesToRadians
	}
	
	var latitudeRad: Double {
		latitude.degreesToRadians
	}
	
	
	// MARK: - Distance
	
	/// Distance between two locations in kilometers
	public static func distance(from fromLocation: Location, to toLocation: Location) -> Double {
		let longitudeDelta = abs(fromLocation.longitudeRad - toLocation.longitudeRad)
		
		let angleBetween = acos(sin(fromLocation.latitudeRad)*sin(toLocation.latitudeRad) + cos(fromLocation.latitudeRad)*cos(toLocation.latitudeRad)*cos(longitudeDelta))
		
		let distance = earthRadius * angleBetween
		return distance
	}
	
	
	// MARK: - Helpers
	
	/// Earth's radius in kilometers
	static private let earthRadius = 6378.1370
}

/// Helper extension for Double type
extension Double {
	var degreesToRadians: Double {
		self * .pi / 180
	}
	
	var radiansToDegrees: Double {
		self * 180 / .pi
	}
}
