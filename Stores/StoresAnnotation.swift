import Foundation
import MapKit

class StoresAnnotation: NSObject, MKAnnotation
{
    var coordinate = CLLocationCoordinate2D()

    init(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
    }

}