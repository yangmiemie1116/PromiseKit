import MessageUI
import PromiseKit
import UIKit
import XCTest

#if false  // not possible to test these in the simulator

class Test_MessageUI_Swift: UIKitTestCase {
    func test_can_cancel_mail_composer() {
        let ex1 = expectation(withDescription: "")
        let ex2 = expectation(withDescription: "")
        var order = false

        let mailer = MFMailComposeViewController()
        mailer.setToRecipients(["mxcl@me.com"])

        let promise = rootvc.promiseViewController(mailer, animated: false, completion: {
            after(interval: 0.25).then { _ -> Void in
                XCTAssertFalse(order)
                let button = mailer.viewControllers[0].navigationItem.leftBarButtonItem!
                UIControl().sendAction(button.action, to: button.target, forEvent: nil)
                ex1.fulfill()
            }
        })
        promise.catch { _ -> Void in
            XCTFail()
        }
        promise.error(policy: .AllErrors) { _ -> Void in
            // seems necessary to give vc stack a bit of time
            after(interval: 0.5).then(ex2.fulfill)
            order = true
        }
        waitForExpectations(withTimeout: 10, handler: nil)

        XCTAssertNil(rootvc.presentedViewController)
    }

    func test_can_cancel_message_composer() {
        let ex1 = expectation(withDescription: "")
        let ex2 = expectation(withDescription: "")
        var order = false

        let messager = MFMessageComposeViewController()

        let promise = rootvc.promiseViewController(messager, animated: false, completion: {
            after(interval: 0.25).then { _ -> Void in
                XCTAssertFalse(order)

                let button = messager.viewControllers[0].navigationItem.leftBarButtonItem!
                UIControl().sendAction(button.action, to: button.target, forEvent: nil)
                ex1.fulfill()
            }
        })

        promise.catch { _ -> Void in
            XCTFail()
        }
        promise.error(policy: .AllErrors) { _ -> Void in
            // seems necessary to give vc stack a bit of time
            after(interval: 0.5).then(ex2.fulfill)
            order = true
        }
        waitForExpectations(withTimeout: 10, handler: nil)

        XCTAssertNil(rootvc.presentedViewController)
    }
}

#endif
