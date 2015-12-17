
import UIKit
import MapKit

class SBMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView : MKMapView!
    var currentLocationManager : CLLocationManager!
    var swipeUpView : SBSwiftySwipeUpView!
    var dictionaryData : NSArray!

    // MARK: Life Style
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "SBSwifty Swipe Up"

        let path = NSBundle.mainBundle().pathForResource("SBSwiftyMapList", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)?.valueForKey("mapList")
        dictionaryData = NSArray (array: dict as! [AnyObject])
        
        initializeLocationManager()
        setUpMapView()
        addAnnotationsOnMap(dictionaryData)
        setUpSwipeUpView()
        
    }
    
    // MARK: Initialize Location Manager
    func initializeLocationManager () {
        currentLocationManager = CLLocationManager ()
        currentLocationManager.delegate = self
        if currentLocationManager.respondsToSelector("requestWhenInUseAuthorization") {
            currentLocationManager.requestWhenInUseAuthorization()
        }
        if currentLocationManager.respondsToSelector("requestAlwaysAuthorization") {
            currentLocationManager.requestAlwaysAuthorization()
        }
        
        currentLocationManager.startUpdatingLocation()
        
    }
    
    // MARK: SetUp Map View
    func setUpMapView () {
        
        mapView = MKMapView (frame: self.view.bounds)
        mapView.delegate = self
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        
        let location = CLLocationCoordinate2D(
            latitude: 53.7709505,
            longitude: 12.5753569
        )
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: SetUp SwipeUpView
    func setUpSwipeUpView () {
        
        swipeUpView = SBSwiftySwipeUpView (frame: self.view.frame)
//        swipeUpView.visible_Y_Value = 100
//        swipeUpView.swipeUp_Y_Value = 70
        swipeUpView.setUpUserInterface()
        self.view.addSubview(swipeUpView)

    }
    
    // MARK: Add Annotations OnMap
    func addAnnotationsOnMap (responseMapDataArray : NSArray) {
        
        let tempArray : NSMutableArray = NSMutableArray ()
        for dict in responseMapDataArray {
            let mapD : MapDataObject = MapDataObject (dict: dict as! NSDictionary)
            tempArray.addObject(mapD)
        }
        
        createAnnotations(tempArray)
    }
    
    func createAnnotations (responseData : NSArray) {
        
        for dObject in responseData {
            let row : MapDataObject = dObject as! MapDataObject
            let latStr = row.str_Lat as String
            let lngStr = row.str_Lng as String

            let coord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double (latStr)!,
                Double (lngStr)!)
            
            let annotation : SBMapViewAnnotation = SBMapViewAnnotation (title: row.str_Title,
                subTitle: row.str_SubTitle,
                locationName: row.str_LocationName,
                 coordinate: coord,
            dictData: row.dictionaryData)
            
            self.mapView.addAnnotation(annotation)
            
        }
        
        
    }
    
    func getLocationImage (locationName : String) -> UIImage {
        return UIImage (named: locationName)!
        
    }
    
    func updateSwipeView (theDictionary : NSDictionary) {
        
        UIView.animateWithDuration(0.5,
            animations: { () -> Void in
                
                self.swipeUpView.setViewData(self.view,
                    theData: theDictionary)
        })

    }
    
    // MARK: ALL DELEGATE FUNCTIONS
    // MARK: Location Manager Delegate Function
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if currentLocationManager.respondsToSelector("requestWhenInUseAuthorization") {
            UIApplication.sharedApplication().sendAction("requestWhenInUseAuthorization",
                to: currentLocationManager,
                from: self,
                forEvent: nil)
            
        }
        currentLocationManager.startUpdatingLocation()
    }
    
    // MARK: MapView Delegate Function
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        if annotation.isKindOfClass(SBMapViewAnnotation.self)  {
            let reuseId = "test"
            let temp  = annotation as! SBMapViewAnnotation
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                
                let anImage : UIImage = getAnnotationImage(temp.title!)
                
                anView?.image = UIImage (CGImage: anImage.CGImage!,
                    scale: anImage.scale * 1.3,
                    orientation: anImage.imageOrientation)
                anView!.canShowCallout = false
            }
            else {
                //we are re-using a view, update its annotation reference...
                anView!.annotation = annotation
            }
            return anView
            
        }
        
        return nil
        
    }
    
    func getAnnotationImage (locationName : String) -> UIImage {
        return UIImage (named: locationName+"Annotation")!
        
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation!.isKindOfClass(SBMapViewAnnotation.self)  {
            
            let temp  = view.annotation as! SBMapViewAnnotation
            
            let anImage : UIImage = UIImage (CGImage: view.image!.CGImage!,
                scale: view.image!.scale / 1.3,
                orientation: view.image!.imageOrientation)
            
            UIView.animateWithDuration(0.5,
                animations: { () -> Void in
                    view.image = anImage
            })
            
            updateSwipeView (temp.dictionaryData)
                        
        }
        
    }
  
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        if view.annotation!.isKindOfClass(SBMapViewAnnotation.self)  {
            
            let anImage : UIImage = UIImage (CGImage: view.image!.CGImage!,
                scale: view.image!.scale * 1.3,
                orientation: view.image!.imageOrientation)

            UIView.animateWithDuration(0.5,
                animations: { () -> Void in
                    view.image = anImage
            })
            
            swipeUpView.dismissView()
        }
    }
    
    // MARK: Receive Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
