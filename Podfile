# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

use_frameworks!

# Pods for HNAssignment

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'Action'
  pod 'RxSwiftExt'
  pod 'RxOptional'
end

def tools
  pod 'SwiftLint', :configurations => ['Debug']
  pod 'Kingfisher'
  pod 'Action'
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'R.swift'
end

def testing
  pod 'Quick'
  pod 'Nimble'
end

workspace 'HNAssignment.xcworkspace'
target :'HNAssignment' do
  project 'HNAssignment.xcodeproj'
  inherit! :search_paths
  rx
  tools
end

abstract_target 'APP' do
  target :'HNCommon' do
    project 'APP/HNCommon/HNCommon.xcodeproj'
    inherit! :search_paths
    rx
  end
  
  target :'HNService' do
    project 'APP/HNService/HNService.xcodeproj'
    inherit! :search_paths
    
    pod 'Alamofire'
    pod 'ObjectMapper'
    rx
  end
  
end

target :'HNAssignmentTests' do
  project 'HNAssignment.xcodeproj'
  inherit! :search_paths
  pod 'ObjectMapper'
  testing
  rx
end

target 'HNAssignmentUITests' do
  # Pods for testing
end

