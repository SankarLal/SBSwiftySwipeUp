

import UIKit

class MapDataObject: NSObject {

    var str_Title, str_SubTitle, str_LocationName, str_Lat, str_Lng, str_Type : String!
    var dictionaryData : NSDictionary!
    
   override init()  {
        // perform some initialization here
    super.init()

    self.str_Title = "";
    self.str_SubTitle = "";
    self.str_LocationName = "";
    self.str_Lat = "";
    self.str_Lng = "";
    self.str_Type = "";

    }
   
    convenience init(dict : NSDictionary) {
        self.init()
        
        self.str_Title = dict.valueForKey("title") as! String
        self.str_SubTitle = dict.valueForKey("subTitle") as! String
        self.str_LocationName = dict.valueForKey("locationName") as! String
        self.str_Lat = dict.valueForKey("latitude") as! String
        self.str_Lng = dict.valueForKey("longitude") as! String
        self.str_Type = dict.valueForKey("type") as! String
        self.dictionaryData  = dict 

    }

}
