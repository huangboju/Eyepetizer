//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEChoiceCell: UICollectionViewCell {
    lazy var backgroundImageView: UIImageView = {
        let background = UIImageView()
        return background
    }()
    
    lazy var coverButton: UIButton = {
        let coverButton = UIButton()
        coverButton.userInteractionEnabled = false
        coverButton.backgroundColor = UIColor.blackColor()
        coverButton.alpha = 0.3
        return coverButton
    }()
}
