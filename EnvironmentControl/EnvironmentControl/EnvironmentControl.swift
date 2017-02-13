//
//  EnvironmentControl.swift
//
//  Created by Mike Pesate on 10/02/17.
//


/*  TODO List: (Not ordered by any priority)
 1.- Create another object to handle a "full cache wipe". To avoid having to unistall apps for a fresh start.
 2.- ¿? Do we need a config init instead of modifiying the file to set the properties?
 */

/* Done:
 1.- Handle different environments in an scalable way. So more can be added in the future if needed.
 2.- Make the object a singleton.
 3.- Determine the environment to use according to the schema.
 4.- If build is the AppStore version. Force the production environment.
 5.- Do not show the extra settings on the AppStore build.
 6.- Propagate a notification if the environment changes and the config is set to NOT force restart.
 */


import UIKit

//Key to use to register to the notification in case the environment changes
let EnvironmentDidChangeNotification = NSNotification.Name("EnvironmentDidChangeNotification")

enum Environment : Int {
    case test = 0
    case stage = 1
    case prod = 2
    
    init(rawValue : Int) {
        switch rawValue {
        case 0:
            self = .test
        case 1:
            self = .stage
        case 2:
            self = .prod
        default:
            self = .test
        }
    }
    
    func description() -> String {
        switch self {
        case .prod:
            return "Prod"
        case .stage:
            return "Stage"
        case .test:
            fallthrough
        default:
            return "Test"
        }
        
        
    }
}

class EnvironmentControl: NSObject {
    
    //Configuration:
    
    //Change this to the bundle identifier the app will use when release to the AppStore.
    //This will force the environment to be production always.
    private let releaseBundleIdentifier = "com.release.EnvironmentControl"
    
    //If force restart is set to true. The "DidChangeEnvironment" notification wont be propagated.
    private let shouldForceRestart : Bool = true
    
    //DON'T TOUCH BELOW THIS POINT =======================================
    static let shared = EnvironmentControl()
    private let kEnvironment = "currentEnvironment"
    private let kEnvironmentVariable = "environment"
    
    private(set) var currentEnvironment : Environment!
    
    override init() {
        super.init()
        currentEnvironment = getSelectedEnvironment()
    }
    
    //MARK: Class Methods
    
    //If a custom config method is going to be defined. This method will no longer be needed.
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        print("Star. ENVIRONMENT = \(shared.currentEnvironment.description())")
        
    }
    
    class func applicationWillEnterForeground(_ application: UIApplication) {
        
        //If the environment changed we need to noitify the app
        if shared.didEnvironmentChange() {
            //Either by, prompting an alert to force the user to reopen the app.
            if shared.shouldForceRestart {
                let alert = UIAlertController.init(title: "WARNING!", message: "The selected ENVIRONMENT has CHANGED.\nPlease, kill and reopen app.", preferredStyle: .alert)
                application.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
            }
            //Or by posting a notification so the information can be adjusted accordingly
            else {
                NotificationCenter.default.post(name: EnvironmentDidChangeNotification, object: nil)
            }
        }
    }
    
    //MARK: PRivate Methods
    
    //This checks the environment. If it changed then it stores the new value.
    private func didEnvironmentChange() -> Bool {
        
        let newEnvironment = getSelectedEnvironment()
        let didChange : Bool = newEnvironment != currentEnvironment
        if  didChange {
            currentEnvironment = newEnvironment
            print("Changed. NEW ENVIRONMENT = \(currentEnvironment.description())")
        }
        
        return didChange
    }
    
    //Retrieves the selected environment according to the settings bundle. Also configured the app depending on how it was launched.
    private func getSelectedEnvironment() -> Environment {
        
        //If the product is the release version, this will make sure it is always on Prod
        if Bundle.main.bundleIdentifier == releaseBundleIdentifier {
            return .prod
        }
        
        //This is to help with the quick launch options for developers.
        //First, fetch the environment variables associated with the selected schema
        let environmentVariables = ProcessInfo.processInfo.environment
        //If the schema has the "environment" variable defines, the the app will force use it
        if let environmentString = environmentVariables[kEnvironmentVariable],
            let environment = Int(environmentString) {
            
            //Convert the string/int to the corresponding enum
            let selectedEnvironment = Environment(rawValue: environment)
            
            //Force set the selected environment.
            UserDefaults.standard.set(selectedEnvironment.rawValue, forKey: kEnvironment)
            UserDefaults.standard.synchronize()
            
            //Return the environment
            return selectedEnvironment
        }
        
        //If all above is false. Then just check which environment is selected and use that.
        //This is the path the app will always take when not running from Xcode using a schema with a defined environment
        let currentEnvironment = Environment.init(rawValue: UserDefaults.standard.integer(forKey: kEnvironment))
        return currentEnvironment;
        
    }
    
}
