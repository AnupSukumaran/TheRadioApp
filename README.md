# JazzRadio
JazzRadio is an online radio app which broadcasts only 10 selected Jazz Radio Stations.Audio Urls are being called with the help of AVFoundation. A Player is created with it.

## Number Of Pages

There are only two page for this app. The **First page** is to play the radio and
the **Second page** is a tableview which is used to select the jazz stations(which are listed audio APIs) from the list.
The Second Page is being listed using the plist file called the **Jazzlist.plist**.

## Pods Used
- 'NVActivityIndicatorView'
- 'ReachabilitySwift'

**NVActivityIndicatorView** is used to give  loading animation while calling the audio API.

**ReachabilitySwift** is used to check network availability for the app.

## Persisted Data

Only the selections are made persistent i.e The _Station title_ and the _selected audio urls from the tableview_.
Both are saved using **CoreData**.
