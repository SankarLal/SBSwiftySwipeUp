

import UIKit

class MapDataObject: NSObject {

    var str_Title, str_SubTitle, str_LocationName, str_Lat, str_Lng, str_Type : String!
    var dictionaryData : [String : String] = [String : String]()
    
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
   
    convenience init(dict : [String : String]) {
        self.init()
        
        self.str_Title = dict["title"]
        self.str_SubTitle = dict["subTitle"]
        self.str_LocationName = dict["locationName"]
        self.str_Lat = dict["latitude"]
        self.str_Lng = dict["longitude"]
        self.str_Type = dict["type"]
        self.dictionaryData  = dict 

    }

}
