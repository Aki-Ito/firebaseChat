# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'firebaseChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage'
  # Pods for firebaseChat

  target 'firebaseChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'firebaseChatUITests' do
    # Pods for testing
  end
 post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

end
