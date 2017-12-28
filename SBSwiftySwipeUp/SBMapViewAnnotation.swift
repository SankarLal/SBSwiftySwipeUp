
import UIKit
import MapKit
import Foundation

class SBMapViewAnnotation: NSObject, MKAnnotation {
    
    let title : String?
    let subtitle : String?
    let locationName : String
    let dictionaryData : [String : String]
    let coordinate: CLLocationCoordinate2D
    
    init(title : String, subTitle : String, locationName : String, coordinate: CLLocationCoordinate2D, dictData : [String : String] ) {
        

        self.title = title
        self.subtitle = subTitle
        self.locationName = locationName
        self.coordinate = coordinate
        self.dictionaryData = dictData
        
        super.init()

    }


}
