//
//  KeyboardManager.swift
//  GomeSwift
//
//  Created by caoye on 2020/5/21.
//  Copyright © 2020 caoye. All rights reserved.
//

import UIKit

let KeyboardWillShow  = UIResponder.keyboardWillShowNotification
let KeyboardDidShow   = UIResponder.keyboardDidShowNotification
let KeyboardWillHide  = UIResponder.keyboardWillHideNotification
let KeyboardDidHide   = UIResponder.keyboardDidHideNotification

let TextFieldTextDidBeginEditing  = UITextField.textDidBeginEditingNotification
let TextFieldTextDidEndEditing    = UITextField.textDidEndEditingNotification

let TextViewTextDidBeginEditing   = UITextView.textDidBeginEditingNotification
let TextViewTextDidEndEditing     = UITextView.textDidBeginEditingNotification

class KeyboardManager: NSObject,UIGestureRecognizerDelegate {


    private var keyBoardHeight: CGFloat? = 0.0;
    private var positionBottomofWindow: CGFloat = 0.0;
    private var editorView: UIView?
    private var isShowed: Bool = false // 是否已经弹出了键盘
    private var viewEditing: Bool = false // 是否将要进行编辑，用来区分textfiled还是textview
    private var originalVCRect: CGRect? // 记录原始vc坐标
    private var _isEnabled: Bool = false

    public static let shared = KeyboardManager()
    
    public var isEnabled: Bool {
        set {
            if newValue == true {
                registerNotifications()
            } else {
                unRegisterNotifications()
            }
            _isEnabled = newValue
        }
        get {
            return _isEnabled
        }
    }
    
    override init() {
        super.init()
    }
    
    
    @objc internal func keyboardWillShow(_ notification: Notification?) {
        if editorView?.isAlertViewTextField() == true {
            return;
        }
        
        let info = notification?.userInfo
        let keyBoardFrame: CGRect? = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect;
        keyBoardHeight = keyBoardFrame?.size.height
        
        if viewEditing == true { // textfield

            let windowH: CGFloat? = keyWindow()?.bounds.size.height
            let keyBoardY: CGFloat = windowH! - keyBoardHeight!
            let difference: CGFloat = positionBottomofWindow - keyBoardY
            let vc: UIViewController? = editorView?.parentContainerViewController()

            guard let parentView = vc?.view  else {
                return
            }
            
            if isShowed == false {
                originalVCRect = parentView.frame
            }
            isShowed = true
            
            if difference > 0 {

                UIView.animate(withDuration: 0.2) {
                    var vcFrame:CGRect? = parentView.frame
                    vcFrame?.origin.y = -difference
                    vc?.view.frame = vcFrame!
                }
            }
        } else {
            // textview的textViewDidBeginEditing 回调晚于此方法，比较特殊
        }
    }
    
    @objc internal func textFieldViewDidBeginEditing(_ notification: Notification) {
          viewEditing = true
          
          editorView = notification.object as? UIView
          let window = keyWindow()
          
          guard let edView = editorView, let wind = window else {
              return
          }
          
          let rectInWindow: CGRect = edView.convert(edView.bounds, to: wind)

          if rectInWindow.origin.y == 0 || rectInWindow.size.height == 0 {
              return
          }
          
           /// textFiled
           positionBottomofWindow = rectInWindow.origin.y + rectInWindow.size.height
            
          addTapGesture()
      }
      

      @objc internal func textViewDidBeginEditing(_ notification: Notification) {
          viewEditing = true

           editorView = notification.object as? UIView
          let window = keyWindow()
          guard let edView = editorView else {
              return
          }
          let vc: UIViewController? = editorView?.parentContainerViewController()
          
          guard let parentView = vc?.view else {
              return
          }
      
          if isShowed == false {
              originalVCRect = parentView.frame
          }
          isShowed = true
      
           let rectInWindow: CGRect = editorView!.convert(editorView!.bounds, to: window!)
          positionBottomofWindow = rectInWindow.origin.y + rectInWindow.size.height

          if edView.isKind(of: UITextView.self) {
                       
              let windowH: CGFloat? = keyWindow()?.bounds.size.height
              let keyBoardY: CGFloat = windowH! - keyBoardHeight!
              
              var difference: CGFloat = positionBottomofWindow - keyBoardY

              // 距离屏幕顶端100位置停下
              if difference > 0 && edView.frame.origin.y - difference < 100 {
                  difference = edView.frame.origin.y - 100
              }
              
              if difference > 0 {
                  
                  UIView.animate(withDuration: 0.3) {
                      var vcFrame:CGRect? = parentView.frame
                      vcFrame?.origin.y = -difference
                      vc?.view.frame = vcFrame!
                  }
              }
          }
                  
          addTapGesture()
      }
      
    

    @objc internal func keyboardWillHide(_ notification: Notification?) {
        viewEditing = false
        
        if editorView?.isAlertViewTextField() == true {
            return;
        }
        
        let vc: UIViewController? = editorView?.parentContainerViewController()
        let parentView = vc?.view
        
        UIView.animate(withDuration: 0.25) {
             var vcFrame:CGRect? = parentView?.frame
            vcFrame?.origin.y = self.originalVCRect?.origin.y ?? 0.0
             vc?.view.frame = vcFrame!
            vc?.view.layoutSubviews()
         }
      }
    

    
    @objc internal func textFieldViewDidEndEditing(_ notification: Notification) {
        viewEditing = false
    }
    
    @objc internal func textViewDidEndEditing(_ notification: Notification) {
         viewEditing = false
     }
    
    
    @objc internal func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        editorView?.window?.addGestureRecognizer(tapGesture)
    }
    
    @objc internal func tapRecognized(_ gesture: UITapGestureRecognizer) {
         
         if gesture.state == .ended {
             resignFirstResponder()
         }
     }
    
    @objc @discardableResult public func resignFirstResponder() -> Bool {
        
        if let textFieldRetain = editorView {
            let isResignFirstResponder = textFieldRetain.resignFirstResponder()
            return isResignFirstResponder
        }
        
        return false
    }
    
}


extension KeyboardManager {
    
    public func registerNotifications() {
        /// keyBoard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: KeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: KeyboardWillHide, object: nil)
        
        /// textFiled
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: TextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewDidEndEditing(_:)), name: TextFieldTextDidEndEditing, object: nil)

        /// textView
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: TextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(_:)), name: TextViewTextDidEndEditing, object: nil)
        
    }
    
    public func unRegisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: KeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: KeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: TextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: TextFieldTextDidEndEditing, object: nil)

        NotificationCenter.default.removeObserver(self, name: TextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: TextViewTextDidEndEditing, object: nil)
    }
}

private func keyWindow() -> UIWindow? {
    var keyWindow: UIWindow?
    var originalKeyWindow : UIWindow? = nil

    #if swift(>=5.1)
    if #available(iOS 13, *) {
       originalKeyWindow = UIApplication.shared.connectedScenes
           .compactMap { $0 as? UIWindowScene }
           .flatMap { $0.windows }
           .first(where: { $0.isKeyWindow })
    } else {
       originalKeyWindow = UIApplication.shared.keyWindow
    }
    #else
    originalKeyWindow = UIApplication.shared.keyWindow
    #endif

    if let originalKeyWindow = originalKeyWindow {
       keyWindow = originalKeyWindow
    }

    return keyWindow
}


