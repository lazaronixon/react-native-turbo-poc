import Turbo

@objc(TurboViewManager)
class TurboViewManager: RCTViewManager {
    override func view() -> TurboView {
        TurboLog.debugLoggingEnabled = true;
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
    
    func getView(reactTag: NSNumber, callback: @escaping (TurboView) -> Void) {
      bridge.uiManager.addUIBlock { _, viewRegistry in
        callback(viewRegistry![reactTag] as! TurboView)
      }
    }
}

class TurboView: UIView, SessionDelegate {
    @objc var sessionKey: String!
    @objc var url: URL!
    @objc var onProposeVisit: RCTBubblingEventBlock!
    
    private var viewController: RNVisitableViewController?
    
    private lazy var session: Session = {
        let session = SessionManager.shared.getOrCreateSession(sessionKey)
        session.delegate = self
        return session
    }()
    
    override func didMoveToWindow() {
        if (window != nil && viewController == nil) {
            visit(url: url)
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
    
    private func visit(url: URL) {
        let viewController = RNVisitableViewController(url: url)
        installViewController(viewController)
        session.visit(viewController)
        
        self.viewController = viewController
    }
    
    private func installViewController(_ viewController: RNVisitableViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewController?.view?.removeFromSuperview()
        
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
    override func viewWillAppear(_ animated: Bool) {}
    override func viewDidAppear(_ animated: Bool) {}
    
    func visitableViewWillAppear() {
        visitableDelegate?.visitableViewWillAppear(self)
    }
    
    func visitableViewDidAppear() {
        visitableDelegate?.visitableViewDidAppear(self)
    }
}

class SessionManager {
    static let shared = SessionManager();
    
    private lazy var sessions: [String: Session] = [:]
    
    func getOrCreateSession(_ key: String) -> Session {
        if sessions[key] != nil {
            return sessions[key]!
        } else {
            sessions[key] = Session(); return sessions[key]!
        }
    }
}
