# Uncomment the next line to define a global platform for your project
platform :ios, '12.0' #12.0
use_frameworks!

def firebase_messaging
  pod 'Firebase/Messaging'
end

def google_utilites
  pod 'GoogleUtilities'
end

target 'Poke-test' do
  # Comment the next line if you don't want to use dynamic frameworks
  # Pods for Poke-test
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'RealmSwift'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Database'
  google_utilites
  pod 'IQKeyboardManagerSwift'
  pod 'Zero', :git => 'https://bitbucket.org/baturamobile/designsystem-ios', :branch =>'develop'
end

target 'NotificationExtension' do
  firebase_messaging
  google_utilites
end
 


