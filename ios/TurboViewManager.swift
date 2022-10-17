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
    
    private lazy var session = makeSession()
    
    private var viewController: RNVisitableViewController?
    
    override func didMoveToWindow() {
        if (window != nil) {
            session.delegate = self
        }
        
        if (window != nil && viewController == nil) {
            initialVisit(url: url)
        }
        
        if (window != nil && viewController != nil) {
            viewController!.visitableViewWillAppear()
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
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbo Native iOS"
        
        return SessionManager.shared.getOrCreateSession(sessionKey, configuration)
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
    
    func visitableViewWillAppear() {
        visitableDelegate?.visitableViewWillAppear(self)
    }
    
    func visitableViewDidAppear() {
        visitableDelegate?.visitableViewDidAppear(self)
    }
}

class SessionManager {
    static let shared = SessionManager();
    
    private var sessions: [String: Session] = [:]
    
    func getOrCreateSession(_ key: String,_ configuration: WKWebViewConfiguration) -> Session {
        if let session = sessions[key] {
            return session
        } else {
            sessions[key] = Session(webViewConfiguration: configuration); return sessions[key]!
        }
    }
}
