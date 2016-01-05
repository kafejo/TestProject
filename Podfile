# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

def global_pods
    pod 'AERecord', '~> 2.0'
    pod 'Alamofire', '~> 3.0'
    pod 'Bond', '~> 4.0'
    pod 'JASON', '~> 1.0'
    pod 'PromiseKit', '~> 3.0'
end

target 'MTTTestProject' do
    global_pods
end


target "MTTTestProjectTests" do
    
    global_pods
    
    pod 'Quick', '~> 0.8'
    pod 'Nimble', '~> 3.0'
    
end
