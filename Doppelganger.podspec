#
# Be sure to run `pod lib lint Doppelganger.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Doppelganger"
  s.version          = "1.2"
  s.summary          = "Array diffs as collection view wants it."
  s.description      = <<-DESC
                        Are you still using `reloadData` with collection or table
                        view because figuring out transfomration is too hard?
                        Worry no more! This utility takes two arrays: an old and
                        a new one and returns a set of diffs that you feed directly
                        to your collection or table view.
                        Happy users, seeing data mutation animating in front of their
                        eyes, less hassle for you!
                       DESC
  s.homepage         = "http://github.com/Wondermall/Doppelganger"
  s.license          = 'MIT'
  s.author           = { "Sash Zats" => "sash@zats.io" }
  s.source           = { :git => "https://github.com/Wondermall/Doppelganger.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zats'

  s.requires_arc = true
  s.source_files = 'Pod/Classes/*.{h,m}'
  s.ios.source_files = 'Pod/Classes/iOS/*.{h,m}'
  s.osx.source_files = 'Pod/Classes/OSX/*.{h,m}'
  s.frameworks = 'Foundation'
end
