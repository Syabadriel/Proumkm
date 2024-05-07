import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
<<<<<<< HEAD
    let flutterViewController = FlutterViewController()
=======
    let flutterViewController = FlutterViewController.init()
>>>>>>> de63020cf17c5461bcacb016b0930b6d85cc7ab8
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
