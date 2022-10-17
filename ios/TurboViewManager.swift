import Turbo

@objc(TurboViewManager)
class TurboViewManager: RCTViewManager {
    override func view() -> TurboView {
        return TurboView()
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc func reload(_ reactTag: NSNumber) {
        getView(reactTag: reactTag) { view in
            view.reload()
        }
    }
    
    private func getView(reactTag: NSNumber, callback: @escaping (TurboView) -> Void) {
      bridge.uiManager.addUIBlock { _, viewRegistry in
        callback(viewRegistry![reactTag] as! TurboView)
      }
    }
}

class TurboView: UIView, SessionDelegate {
    @objc var sessionKey: String!
    @objc var url: URL!
    @objc var onProposeVisit: RCTBubblingEventBlock!
    
    private static var sessions: [String: Session] = [:]
    
    private lazy var session = makeSession()
    
    private var viewController: RNVisitableViewController?
    
    override func didMoveToWindow() {
        if (window != nil && viewController == nil) {
            initialVisit(url: url)
        }
        
        if (window != nil && viewController != nil) {
            viewController!.visitableViewDidAppear()
        }
    }
    
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        onProposeVisit(["url": proposal.url.absoluteString])
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("didFailRequestForVisitable: \(error)")
    }
    
    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
    
    func reload() {
        session.reload()
    }
    
    private func makeSession() -> Session {
        if let session = Self.sessions[sessionKey] {
            return session
        } else {
            let configuration = WKWebViewConfiguration()
            configuration.applicationNameForUserAgent = "Turbo Native iOS"
            
            let session = Session(webViewConfiguration: configuration)
            session.delegate = self
            
            Self.sessions[sessionKey] = session
            return session
        }
    }
    
    private func initialVisit(url: URL) {
        let viewController = RNVisitableViewController(url: url)
        installViewController(viewController)
        session.visit(viewController)
        
        self.viewController = viewController
    }
    
    private func installViewController(_ viewController: RNVisitableViewController) {
        addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

class RNVisitableViewController: VisitableViewController {
    override func viewDidLoad() {
        super.viewDidLoad(); view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ignore it
    }
    override func viewDidAppear(_ animated: Bool) {
        // ignore it
    }
    
    func visitableViewDidAppear() {
        visitableDelegate?.visitableViewWillAppear(self)
        visitableDelegate?.visitableViewDidAppear(self)
    }
}
