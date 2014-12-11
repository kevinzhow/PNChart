#
#  Be sure to run `pod spec lint PNChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "PNChart"
  s.version      = "0.5.6"
  s.summary      = "A simple and beautiful chart lib with animation used in Piner for iOS"

  s.description  = <<-DESC
                  #PNChart

                  [![Build Status](https://travis-ci.org/kevinzhow/PNChart.png?branch=master)](https://travis-ci.org/kevinzhow/PNChart)

                  You can also find swift version at here https://github.com/kevinzhow/PNChart-Swift

                  A simple and beautiful chart lib with **animation** used in [Piner](https://itunes.apple.com/us/app/piner/id637706410) and [CoinsMan](https://itunes.apple.com/us/app/coinsman/id772163893) for iOS

                  [![](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)](https://dl.dropboxusercontent.com/u/1599662/pnchart.gif)

                  ## Requirements

                  PNChart works on iOS 6.0 and later version and is compatible with ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

                  * Foundation.framework
                  * UIKit.framework
                  * CoreGraphics.framework
                  * QuartzCore.framework

                  You will need LLVM 3.0 or later in order to build PNChart.




                  ## Usage

                  ### Cocoapods

                  [CocoaPods](http://cocoapods.org) is the recommended way to add PNChart to your project.

                  1. Add a pod entry for PNChart to your Podfile `pod 'PNChart', '~> 0.5'`
                  2. Install the pod(s) by running `pod install`.
                  3. Include PNChart wherever you need it with `#import "PNChart.h"`.


                  ### Copy the PNChart folder to your project


                  [![](https://dl.dropboxusercontent.com/u/1599662/line.png)](https://dl.dropboxusercontent.com/u/1599662/line.png)

                  ```objective-c
                    #import "PNChart.h"

                    //For LineChart
                    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
                    [lineChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];

                    // Line Chart No.1
                    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];
                    PNLineChartData *data01 = [PNLineChartData new];
                    data01.color = PNFreshGreen;
                    data01.itemCount = lineChart.xLabels.count;
                    data01.getData = ^(NSUInteger index) {
                        CGFloat yValue = [data01Array[index] floatValue];
                        return [PNLineChartDataItem dataItemWithY:yValue];
                    };
                    // Line Chart No.2
                    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2];
                    PNLineChartData *data02 = [PNLineChartData new];
                    data02.color = PNTwitterColor;
                    data02.itemCount = lineChart.xLabels.count;
                    data02.getData = ^(NSUInteger index) {
                        CGFloat yValue = [data02Array[index] floatValue];
                        return [PNLineChartDataItem dataItemWithY:yValue];
                    };

                    lineChart.chartData = @[data01, data02];
                    [lineChart strokeChart];

                  ```

                  [![](https://dl.dropboxusercontent.com/u/1599662/bar.png)](https://dl.dropboxusercontent.com/u/1599662/bar.png)

                  ```objective-c
                    #import "PNChart.h"

                    //For BarChart
                    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
                    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
                    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
                    [barChart strokeChart];

                  ```

                  [![](https://dl.dropboxusercontent.com/u/1599662/circle.png)](https://dl.dropboxusercontent.com/u/1599662/circle.png)


                  ```objective-c
                  #import "PNChart.h"

                  //For CircleChart

                  PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:60] andClockwise:NO];
                  circleChart.backgroundColor = [UIColor clearColor];
                  [circleChart setStrokeColor:PNGreen];
                  [circleChart strokeChart];

                  ```


                  [![](https://dl.dropboxusercontent.com/u/1599662/pie.png)](https://dl.dropboxusercontent.com/u/1599662/pie.png)

                  ```objective-c
                  # import "PNChart.h"
                  //For PieChart
                  NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
                                             [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
                                             [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
                                             ];



                  PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
                  pieChart.descriptionTextColor = [UIColor whiteColor];
                  pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
                  [pieChart strokeChart];
                  ```

                  #### Callback

                  Currently callback only works on Linechart

                  ```objective-c
                    #import "PNChart.h"

                  //For LineChart

                  lineChart.delegate = self;


                  ```

                  ```objective-c

                  //For DelegateMethod


                  -(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
                      NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
                  }

                  -(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
                      NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
                  }

                  ```


                  ## License

                  This code is distributed under the terms and conditions of the [MIT license](LICENSE).

                  ## SpecialThanks

                  [@lexrus](http://twitter.com/lexrus)  CocoaPods Spec

                   DESC

  s.homepage     = "https://github.com/kevinzhow/PNChart"
  s.screenshots  = "https://camo.githubusercontent.com/e99c1bbab103c63efd561c4997a4bedb878bb2a2/68747470733a2f2f646c2e64726f70626f7875736572636f6e74656e742e636f6d2f752f313539393636322f706e63686172742e676966"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "kevinzhow" => "kevinchou.c@gmail.com" }
  # Or just: s.author    = "kevinzhow"
  # s.authors            = { "kevinzhow" => "kevinchou.c@gmail.com" }
  # s.social_media_url   = "http://twitter.com/kevinzhow"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "6.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/kevinzhow/PNChart.git", :tag => "0.5.6" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "PNChart", "PNChart/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  s.public_header_files = "PNChart/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  s.frameworks   = 'CoreGraphics', 'UIKit', 'Foundation', 'QuartzCore'
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'UICountingLabel', '~> 1.0.0'

end
