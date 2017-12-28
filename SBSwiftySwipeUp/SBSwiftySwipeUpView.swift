

import UIKit


let CELL_TEXT_TAG = 100

class SBSwiftySwipeUpView: UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var screenSize : CGSize!
    var slideSuperView : UIView!
    var pan : UIPanGestureRecognizer!
    var foregroundTapped : UIButton!
    var dictData : [String : String] = [String : String]()
    
    var openViewAnimateDuration : TimeInterval!
    var closeViewAnimateDuration : TimeInterval!
    var closeViewWithButtonActionAnimateDuration : TimeInterval!
    
    var visible_Y_Value  : CGFloat!
    var inVisible_Y_Value : CGFloat!
    var swipeUp_Y_Value : CGFloat!
    
    var tblView : UITableView!
    var swipeImgView : UIImageView!
    
    override init (frame : CGRect) {
        
        inVisible_Y_Value = 50
        visible_Y_Value = 87
        swipeUp_Y_Value = 70
        
        super.init(frame: CGRect.init(x: 0, y: frame.size.height + inVisible_Y_Value, width: frame.size.width, height: frame.size.height))
        self.backgroundColor = HEADER_COLOR.withAlphaComponent(0.1);
        
        openViewAnimateDuration = 0.28
        closeViewAnimateDuration = 0.18
        closeViewWithButtonActionAnimateDuration = 0.5

        pan = UIPanGestureRecognizer (target: self, action: #selector(self.didPan(gesture:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
       
        addBlurEffect(self)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: SetUp User Interface
    func setUpUserInterface () {
        
        let contentView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: visible_Y_Value))
        contentView.backgroundColor = HEADER_COLOR
        self.addSubview(contentView)
        
        let imgFrame : UIView = UIView.init(frame: CGRect.init(x: 5, y: 5, width: visible_Y_Value - 10, height: visible_Y_Value - 10))
        imgFrame.backgroundColor = WHITE_COLOR.withAlphaComponent(0.5)
        self.addSubview(imgFrame)
        
        let imgView : UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: imgFrame.frame.size.height - 5, height: imgFrame.frame.size.height - 5))
        imgView.tag = 100
        imgView.center = imgFrame.center
        self.addSubview(imgView)
        
        let xValue : CGFloat = imgFrame.frame.origin.x + imgFrame.frame.size.width + 5
        let width : CGFloat  = self.frame.size.width - imgFrame.frame.size.width - 10
        
        let lbl_Data : UILabel = UILabel.init(frame: CGRect.init(x: xValue, y: contentView.frame.size.height/2 - 20, width: width, height: 40))
        lbl_Data.tag = 101
        lbl_Data.textColor = WHITE_COLOR
        lbl_Data.textAlignment = .center
        lbl_Data.backgroundColor = CLEAR_COLOR
        self.addSubview(lbl_Data)
        
        let foregroundButton : UIButton = UIButton ()
        foregroundButton.tag = 102
        foregroundButton.addTarget(self, action: #selector(self.peformForegroundButton(sender:)), for: .touchUpInside)
        foregroundButton.backgroundColor = CLEAR_COLOR
        foregroundButton.frame = contentView.frame
        self.addSubview(foregroundButton)
        
        tblView = UITableView.init(frame: CGRect.init(x: 0, y: contentView.frame.origin.x + contentView.frame.size.height + 5, width: self.frame.size.width, height: self.frame.size.height - (contentView.frame.origin.x + contentView.frame.size.height + visible_Y_Value)))
        tblView.delegate = self
        tblView.dataSource = self
        tblView.backgroundColor = CLEAR_COLOR
        tblView.separatorColor = CLEAR_COLOR
        tblView.backgroundView = UIView ()
        tblView.backgroundView?.backgroundColor = CLEAR_COLOR
        tblView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CELL-IDENTIFIER")
        self.addSubview(tblView)
        
        swipeImgView = UIImageView.init(frame: CGRect.init(x: self.frame.size.width / 2 - (43/2), y: 0, width: 43, height: 20))
        swipeImgView.image = UIImage (named: "ControlCenter-Up")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR
        self.addSubview(swipeImgView)
        
    }
    
    //MARK: Update View Frame and Data
    func setViewData (_ superView : UIView, theData : [String : String]) {
        
        self.frame = CGRect.init(x: 0, y: superView.frame.size.height - visible_Y_Value, width: superView.frame.size.width, height: superView.frame.size.height)
        self.slideSuperView = superView
        screenSize = superView.bounds.size
        dictData = theData
        updateViewData ()
    }
    
    func updateViewData () {
        let imgName : String = dictData["title"]!
        (self.viewWithTag(100) as? UIImageView)?.image = UIImage (named: imgName)
        (self.viewWithTag(101) as? UILabel)?.text = dictData["locationName"]
    }
    
    //MARK: Peform Foreground Button
    @objc func peformForegroundButton (sender : UIButton) {
        
        if (sender.isSelected == false) {
            
            openViewWithDuration(openViewAnimateDuration)
            sender.isSelected = true
            
        } else {
            
            closeViewWithDuration(closeViewWithButtonActionAnimateDuration)
            sender.isSelected = false
    
        }

    }
    
    //MARK: Pan Gesture
    @objc func didPan (gesture : UIPanGestureRecognizer) {
        
        var viewCenter : CGPoint = (gesture.view?.center)!
        let translation : CGPoint = gesture.translation(in: gesture.view?.superview)
       
        if gesture.state == .began || gesture.state == .changed {
           
            if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + screenSize.height) {
                
                viewCenter.y = fabs(viewCenter.y + translation.y)
                
                if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + screenSize.height) {
                    self.center = viewCenter
                    
                }
            }
            gesture.setTranslation(CGPoint.zero, in: slideSuperView)
            
        } else if gesture.state == .ended {
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
    func openViewWithDuration (_ duration : TimeInterval) {
        
        swipeImgView.image = UIImage (named: "ControlCenter-Down")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR

        UIView.animate(withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.56,
            initialSpringVelocity: 20,
            options: .curveEaseOut,
            animations: { () -> Void in
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.swipeUp_Y_Value, width: self.frame.size.width, height: self.frame.size.height)
            }) { (Bool) -> Void in
                (self.viewWithTag(102) as! UIButton).isSelected = true
        }
    }

    //MARK: Close View Duration
    func closeViewWithDuration (_ duration : TimeInterval) {
        
        swipeImgView.image = UIImage (named: "ControlCenter-Up")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        swipeImgView.tintColor = WHITE_COLOR
        
        UIView.animate(withDuration: duration,
            animations: { () -> Void in
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.size.height - self.visible_Y_Value, width: self.frame.size.width, height: self.frame.size.height)

            }) { (Bool) -> Void in
                (self.viewWithTag(102) as! UIButton).isSelected = false

        }
        
    }
    
    //MARK: Hide / Dismiss View
    func dismissView () {
        
        UIView.animate(withDuration: 0.2,
            animations: { () -> Void in
                
                self.frame = CGRect.init(x: 0, y: self.slideSuperView.frame.size.height + self.inVisible_Y_Value, width: self.slideSuperView.frame.size.width, height: self.slideSuperView.frame.size.height)
        })
    }
    
    //MARK: Add Blur Effect
    func addBlurEffect (_ view : UIView) {
        let blur : UIBlurEffect = UIBlurEffect (style: .light)
        let effectView : UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = view.bounds
        view.addSubview(effectView)
        
    }
    
    
    // MARK: ALL DELEGATE FUNCTIONS
    
    //MARK: Gesture Delegate Function
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: TableView Delegate And DataSource Function
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 4
        }
        return 3

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tblView.bounds.size.width, height: 30))
        let titleLable : UILabel = UILabel.init(frame: CGRect.init(x: 5, y: 5, width: self.tblView.bounds.size.width - 10, height: 20))
        tableHeaderView.backgroundColor = HEADER_COLOR
        titleLable.text = NSString (format: "Section : %d", section) as String
        titleLable.textColor = WHITE_COLOR
        titleLable.backgroundColor = CLEAR_COLOR
        tableHeaderView.addSubview(titleLable)
        return tableHeaderView

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL-IDENTIFIER", for: indexPath)
        cell.backgroundColor = CLEAR_COLOR
        cell.contentView.backgroundColor = CLEAR_COLOR
        let cellTextLable = UILabel()
        cellTextLable.tag = CELL_TEXT_TAG
        cellTextLable.numberOfLines = 0
        cellTextLable.adjustsFontSizeToFitWidth = true
        cellTextLable.backgroundColor = CLEAR_COLOR
        cellTextLable.textColor = BLACK_COLOR
        cellTextLable.textAlignment = .left
        cellTextLable.font = UIFont.systemFont(ofSize: 12)
        cellTextLable.frame = CGRect.init(x: 10, y: 5, width: tblView.frame.size.width - 20, height: 30)
       cellTextLable.text = NSString(format: " Section : %d And Row : %d",indexPath.section, indexPath.row) as String
        cell.contentView.addSubview(cellTextLable)
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
