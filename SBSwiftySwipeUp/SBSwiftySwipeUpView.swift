

import UIKit


let CELL_TEXT_TAG = 100

class SBSwiftySwipeUpView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var screenSize : CGSize!
    var slideSuperView : UIView!
    var pan : UIPanGestureRecognizer!
    var foregroundTapped : UIButton!
    var dictData : NSDictionary!
    
    var openViewAnimateDuration : NSTimeInterval!
    var closeViewAnimateDuration : NSTimeInterval!
    var closeViewWithButtonActionAnimateDuration : NSTimeInterval!
    
    var visible_Y_Value  : CGFloat!
    var inVisible_Y_Value : CGFloat!
    var swipeUp_Y_Value : CGFloat!
    
    var tblView : UITableView!
    var swipeImgView : UIImageView!
    
    override init (frame : CGRect) {
        
        inVisible_Y_Value = 50
        visible_Y_Value = 87
        swipeUp_Y_Value = 70
        
        super.init(frame : CGRectMake(0, frame.size.height + inVisible_Y_Value, frame.size.width, frame.size.height))
        
        self.backgroundColor = HEADER_COLOR.colorWithAlphaComponent(0.1);
        
        openViewAnimateDuration = 0.28
        closeViewAnimateDuration = 0.18
        closeViewWithButtonActionAnimateDuration = 0.5

        pan = UIPanGestureRecognizer (target: self, action: "didPan:")
        pan.delegate = self
        self.addGestureRecognizer(pan)
       
        addBlurEffect(self)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: SetUp User Interface
    func setUpUserInterface () {
        
        let contentView : UIView = UIView (frame: CGRectMake(0, 0, self.frame.size.width, visible_Y_Value))
        contentView.backgroundColor = HEADER_COLOR
        self.addSubview(contentView)
        
        let imgFrame: UIView = UIView (frame: CGRectMake (5, 5, visible_Y_Value - 10, visible_Y_Value - 10))
        imgFrame.backgroundColor = WHITE_COLOR.colorWithAlphaComponent(0.5)
        self.addSubview(imgFrame)
        
        let imgView : UIImageView = UIImageView (frame: CGRectMake(0, 0, imgFrame.frame.size.height - 5, imgFrame.frame.size.height - 5))
        imgView.tag = 100
        imgView.center = imgFrame.center
        self.addSubview(imgView)
        
        let xValue : CGFloat = imgFrame.frame.origin.x + imgFrame.frame.size.width + 5;
        let width : CGFloat  = self.frame.size.width - imgFrame.frame.size.width - 10;
        
        let lbl_Data : UILabel = UILabel (frame: CGRectMake(xValue, contentView.frame.size.height/2 - 20, width, 40))
        lbl_Data.tag = 101
        lbl_Data.textColor = WHITE_COLOR
        lbl_Data.textAlignment = NSTextAlignment.Center
        lbl_Data.backgroundColor = CLEAR_COLOR
        self.addSubview(lbl_Data)
        
        let foregroundButton : UIButton = UIButton ()
        foregroundButton.tag = 102
        foregroundButton.addTarget(self, action: "peformForegroundButton:", forControlEvents: UIControlEvents.TouchUpInside)
        foregroundButton.backgroundColor = CLEAR_COLOR
        foregroundButton.frame = contentView.frame
        self.addSubview(foregroundButton)
        
        tblView = UITableView (frame: CGRectMake(0, contentView.frame.origin.x + contentView.frame.size.height + 5, self.frame.size.width, self.frame.size.height - (contentView.frame.origin.x + contentView.frame.size.height + visible_Y_Value)), style: UITableViewStyle.Grouped)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.backgroundColor = CLEAR_COLOR
        tblView.separatorColor = CLEAR_COLOR
        tblView.backgroundView = UIView ()
        tblView.backgroundView?.backgroundColor = CLEAR_COLOR
        self.addSubview(tblView)
        
        swipeImgView = UIImageView (frame: CGRectMake(self.frame.size.width / 2 - (43/2), 0, 43, 20))
        swipeImgView.image = UIImage (named: "ControlCenter-Up")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR
        self.addSubview(swipeImgView)
        
    }
    
    //MARK: Update View Frame and Data
    func setViewData (superView : UIView, theData : NSDictionary) {
        
        self.frame = CGRectMake(0, superView.frame.size.height - visible_Y_Value, superView.frame.size.width, superView.frame.size.height)
        self.slideSuperView = superView;
        screenSize = superView.bounds.size;
        dictData = theData;
        
        updateViewData ()
    }
    
    func updateViewData () {
        
        let imgName : String = String (format: "%@",dictData.valueForKey("title") as! String)

        (self.viewWithTag(100) as? UIImageView)?.image = UIImage (named: imgName)
        (self.viewWithTag(101) as? UILabel)?.text = String (format: "%@",dictData.valueForKey("locationName") as! String)
        
    }
    
    //MARK: Peform Foreground Button
    func peformForegroundButton (sender : UIButton) {
        
        if (sender.selected == false) {
            
            openViewWithDuration(openViewAnimateDuration)
            sender.selected = true;
            
        } else {
            
            closeViewWithDuration(closeViewWithButtonActionAnimateDuration)
            sender.selected = false
    
        }

    }
    
    //MARK: Pan Gesture
    func didPan (gesture : UIPanGestureRecognizer) {
        
        var viewCenter : CGPoint = (gesture.view?.center)!
        let translation : CGPoint = gesture.translationInView(gesture.view?.superview)
       
        if gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Changed {
           
            if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + screenSize.height) {
                
                viewCenter.y = fabs(viewCenter.y + translation.y)
                
                if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + screenSize.height) {
                    self.center = viewCenter
                    
                }
            }
            gesture.setTranslation(CGPoint.zero, inView: slideSuperView)
            
        } else if gesture.state == UIGestureRecognizerState.Ended {
            if (viewCenter.y < self.frame.size.height) {
                // Open Menu
                openViewWithDuration (openViewAnimateDuration)
            }else {
                // Close Menu
                closeViewWithDuration(closeViewAnimateDuration)
            }
        }
    }
    
    
    //MARK: Open View Duration
    func openViewWithDuration (duration : NSTimeInterval) {
        
        swipeImgView.image = UIImage (named: "ControlCenter-Down")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR

        UIView.animateWithDuration(duration,
            delay: 0.0,
            usingSpringWithDamping: 0.56,
            initialSpringVelocity: 20,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, self.swipeUp_Y_Value, self.frame.size.width, self.frame.size.height);

            }) { (Bool) -> Void in
                (self.viewWithTag(102) as! UIButton).selected = true
                
        }
    }

    //MARK: Close View Duration
    func closeViewWithDuration (duration : NSTimeInterval) {
        
        swipeImgView.image = UIImage (named: "ControlCenter-Up")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR
        
        UIView.animateWithDuration(duration,
            animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, self.frame.size.height - self.visible_Y_Value, self.frame.size.width, self.frame.size.height);

            }) { (Bool) -> Void in
                (self.viewWithTag(102) as! UIButton).selected = false

        }
        
    }
    
    //MARK: Hide / Dismiss View
    func dismissView () {
        
        UIView.animateWithDuration(0.2,
            animations: { () -> Void in
                self.frame = CGRectMake(0, self.slideSuperView.frame.size.height + self.inVisible_Y_Value, self.slideSuperView.frame.size.width, self.slideSuperView.frame.size.height)
        })
    }
    
    //MARK: Add Blur Effect
    func addBlurEffect (view : UIView) {
        let blur : UIBlurEffect = UIBlurEffect (style: .Light)
        let effectView : UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = view.bounds
        view.addSubview(effectView)
        
    }
    
    
    // MARK: ALL DELEGATE FUNCTIONS
    
    //MARK: Gesture Delegate Function
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
        
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    // MARK: TableView Delegate And DataSource Function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 4
        }
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tableHeaderView : UIView = UIView (frame: CGRectMake(0, 0, self.tblView.bounds.size.width, 30))
        let titleLable : UILabel = UILabel (frame: CGRectMake(5, 5, self.tblView.bounds.size.width - 10, 20))
        tableHeaderView.backgroundColor = HEADER_COLOR
        titleLable.text = NSString (format: "Section : %d", section) as String
        titleLable.textColor = WHITE_COLOR
        titleLable.backgroundColor = CLEAR_COLOR
        tableHeaderView.addSubview(titleLable)
        return tableHeaderView;

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CELL-IDENTIFIER"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        var cellTextLable:UILabel? = nil
        
        if cell == nil {
            
            cell = UITableViewCell (style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = CLEAR_COLOR
            cell?.contentView.backgroundColor = CLEAR_COLOR
            
            cellTextLable = UILabel()
            cellTextLable?.tag = CELL_TEXT_TAG
            cellTextLable?.numberOfLines = 0
            cellTextLable?.adjustsFontSizeToFitWidth = true
            cellTextLable?.backgroundColor = CLEAR_COLOR
            cellTextLable?.textColor = BLACK_COLOR
            cellTextLable?.textAlignment = NSTextAlignment.Left
            cellTextLable?.font = UIFont.systemFontOfSize(12)
            cell?.contentView.addSubview(cellTextLable!)
            
        }
        else {
            cellTextLable = cell?.contentView.viewWithTag(CELL_TEXT_TAG) as? UILabel;
        }
        
        (cell?.contentView.viewWithTag(CELL_TEXT_TAG) as! UILabel).text = NSString(format: " Section : %d And Row : %d",indexPath.section, indexPath.row) as String
        (cell?.contentView.viewWithTag(CELL_TEXT_TAG) as! UILabel).frame = CGRectMake(10, 5, tblView.frame.size.width - 20, 30)
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    

}
