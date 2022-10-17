import Turbo

@objc(TurboViewManager)
class TurboViewManager: RCTViewManager {
    override func view() -> TurboView {
        TurboView()
    }
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc func viewWillAppear(_ reactTag: NSNumber) {
        getView(reactTag: reactTag) { view in
            view.visitableViewWillAppear()
        }
    }
    
    @objc func viewDidAppear(_ reactTag: NSNumber) {
        getView(reactTag: reactTag) { view in
            view.visitableViewDidAppear()
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
    
    private var viewController: VisitableViewController?
    
    private lazy var session: Session = {
        let session = SessionManager.shared.getOrCreateSession(sessionKey)
        session.delegate = self
        return session
    }()
    
    override func didMoveToWindow() {
        if (window != nil && viewController == nil) {
            visit(url: url)
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
    
    func visitableViewWillAppear() {
        viewController?.visitableDelegate?.visitableViewWillAppear(viewController!)
    }
    
    func visitableViewDidAppear() {
        viewController?.visitableDelegate?.visitableViewDidAppear(viewController!)
    }
    
    private func visit(url: URL) {
        let viewController = VisitableViewController(url: url)
        installViewController(viewController)
        session.visit(viewController)
        
        self.viewController = viewController
    }
    
    private func installViewController(_ viewController: VisitableViewController) {
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

class RNVisitableViewController: VisitableViewController {
    open override func viewWillAppear(_ animated: Bool) {}
    open override func viewDidAppear(_ animated: Bool) {}
}
