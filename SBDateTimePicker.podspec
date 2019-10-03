
Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = "SBDateTimePicker"
  spec.version      = "0.0.1"
  spec.summary      = "SBDateTimePicker is used to select the date, time and countdown timer easily in your application"

   spec.description  = <<-DESC

   It becomes hectic when we talk about date selection or or time selection or date   
   and time selection or implementing a countdown timer in iOS Application. So here is     
   the UI that will be implemented just by selecting the mode you want to set. You can  
   also set the default date and time.

   DESC

  spec.homepage     = "https://github.com/Shivani-Bajaj/SBDateTimePicker.git"
  spec.license      = "GNU General Public License v3.0"
  spec.license      = { :type => "GNU General Public License v3.0", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = { "Shivani-Bajaj" => "shivani.bajaj9@gmail.com" }
  spec.authors            = { "Shivani-Bajaj" => "shivani.bajaj9@gmail.com" }
 
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/Shivani-Bajaj/SBDateTimePicker.git", :tag => "0.0.1" }

  spec.source_files  = "SBDateTimePicker/*"
  spec.framework      = 'SystemConfiguration'
  spec.ios.framework  = 'UIKit'

end
