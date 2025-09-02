// import UIKit
// import Flutter
// import BackgroundTasks
// import workmanager_apple

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
    
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
    
//     WorkmanagerDebug.setCurrent(LoggingDebugHandler())
//     WorkmanagerPlugin.registerPeriodicTask(
//       withIdentifier: "com.mhealthapp.healthSyncTask",   // MUST match Info.plist
//       frequency: NSNumber(value: 30 * 60)                // 30 minutes
//     )
//         // Register plugins
//         GeneratedPluginRegistrant.register(with: self)
        
//         // if #available(iOS 13.0, *) {
//         //     // Register background tasks
//         //     BGTaskScheduler.shared.register(
//         //         forTaskWithIdentifier: "immediateHealthSync",
//         //         using: nil
//         //     ) { task in
//         //         self.handleImmediateTask(task: task as! BGAppRefreshTask)
//         //     }
            
//         //     BGTaskScheduler.shared.register(
//         //         forTaskWithIdentifier: "healthSyncTask",
//         //         using: nil
//         //     ) { task in
//         //         self.handleHealthSyncTask(task: task as! BGAppRefreshTask)
//         //     }
//         // }
        
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
    
//     MARK: - Task Handlers
//     @available(iOS 13.0, *)
//     private func handleImmediateTask(task: BGAppRefreshTask) {
//         print("Immediate Health Sync task triggered ")
        
//         scheduleImmediateTask()
//         task.setTaskCompleted(success: true)
//     }
    
//     @available(iOS 13.0, *)
//     private func handleHealthSyncTask(task: BGAppRefreshTask) {
//         print("Periodic Health Sync task triggered ")
        
//         scheduleHealthSyncTask()
//         task.setTaskCompleted(success: true)
//     }
    
//     // MARK: - Schedulers
//     @available(iOS 13.0, *)
//     private func scheduleImmediateTask() {
//         let request = BGAppRefreshTaskRequest(identifier: "immediateHealthSync")
//         request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // run after 15 mins
//         try? BGTaskScheduler.shared.submit(request)
//     }
    
//     @available(iOS 13.0, *)
//     private func scheduleHealthSyncTask() {
//         let request = BGAppRefreshTaskRequest(identifier: "healthSyncTask")
//         request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60) // run after 30 mins
//         try? BGTaskScheduler.shared.submit(request)
//     }
// }

// import UIKit
// import Flutter
// // import BackgroundTasks
// import workmanager_apple

// @objc class AppDelegate: FlutterAppDelegate {
    
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
        
//         WorkmanagerDebug.setCurrent(LoggingDebugHandler())
//         WorkmanagerPlugin.registerPeriodicTask(
//             withIdentifier: "com.mhealthapp.healthSyncTask",   // MUST match Info.plist
//             frequency: NSNumber(value: 30 * 60)                // 30 minutes
//         )
        
//         // Register plugins
//         GeneratedPluginRegistrant.register(with: self)
        
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
// }

import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
            WorkmanagerPlugin.registerPeriodicTask(
            withIdentifier: "com.mhealthapp.healthSyncTask",   // MUST match Info.plist
            frequency: NSNumber(value: 30 * 60) )    
            
            WorkmanagerPlugin.registerPeriodicTask(
            withIdentifier: "com.mhealthapp.yesterdayhealthSyncTask",   // MUST match Info.plist
            frequency: NSNumber(value: 24 * 60 * 60) )                // 30 minutes
        
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}