# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Eater' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Eater
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'SwiftyJSON'
  pod 'GoogleSignIn'
  pod 'GoogleAPIClientForREST/Gmail'
  pod 'AlamofireImage'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
  pod 'STRatingControl'

  target 'EaterUnitTests' do
    inherit! :complete
    pod 'Firebase'
  end
  target 'EaterUITests' do
        inherit! :complete
        pod 'Firebase'
  end
end

# Workaround for Cocoapods v.1.5 issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
