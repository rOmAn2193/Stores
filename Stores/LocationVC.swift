import UIKit
import MapKit

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!

    let regionRadius: CLLocationDistance = 1000

    let locationManager = CLLocationManager()

    // Lets pretend we downloaded from the server
    let addresses = ["1040 Independent Ave, Grand Junction, CO 81505", "1450 W Independent Ave, Grand Junction, CO 81505", "Grand Mesa Center, 2464 US-6, Grand Junction, CO 81505"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        for add in addresses
        {
            getPlacemarkFromAddress(add)
        }
        
    }

    override func viewDidAppear(animated: Bool)
    {
        locationAuthStatus()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

    }

    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            map.showsUserLocation = true
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)

        map.setRegion(coordinateRegion, animated: true)
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        if let loc = userLocation.location
        {
            centerMapOnLocation(loc)
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isKindOfClass(StoresAnnotation)
        {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blackColor()
            annoView.animatesDrop = true
            return annoView
        }
        else if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }

        return nil

    }

    func createAnnotationForLocation(location: CLLocation)
    {
        let stores = StoresAnnotation(coordinate: location.coordinate)
        map.addAnnotation(stores)
    }

    func getPlacemarkFromAddress(address: String)
    {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0
            {
                if let loc = marks[0].location
                {
                    // Got a valid location with coordinates
                    self.createAnnotationForLocation(loc)
                }
            }
        }
    }

}

