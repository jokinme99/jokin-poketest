# Uncomment the next line to define a global platform for your project
platform :ios, '12.0' #12.0
use_frameworks!


def pods_pokeTest
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'RealmSwift'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Database'
  google_utilities
  pod 'IQKeyboardManagerSwift'
  pod 'Zero', :git => 'https://bitbucket.org/baturamobile/designsystem-ios', :branch =>'develop'
end

def firebase_messaging
  pod 'Firebase/Messaging'
end

def google_utilities
  pod 'GoogleUtilities'
end

target 'Poke-test' do
  
  pods_pokeTest

  abstract_target 'Tests' do
    target "Poke-testTests"

    pod 'Quick'
    pod 'Nimble'
  end
  
end

target 'NotificationExtension' do
  firebase_messaging
  google_utilities
end
 


