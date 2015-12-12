# hp-scan
A simple OSX app to fetch a PDF file from an HP Deskjet MFP.  It may work with other HP devices. ¯\\_(ツ)_/¯

This is just the initial pass at this app.  There is no UI and no settings other than the IP which needs to be set before compiling.  It works great as a simple click-to-PDF button but there's room for improvement.  See ToDos below.

## Purpose
If you have an residential grade HP MFP and you want to scan something your options are one of the following:
1. Use the software
  * Install the HP bloatware from the CD or website (first time)
  * Connect the software to your MFP (first time)
  * Click through the menu:
    * Scan
    * Scan to computer
    * Select computer (frequently the scanner won't find your computer and you're SOL here - time to switch to method #2)
    * Export the document from the HP software to wherever you want it.
2. Use the web interface
  * Browse to the IP address of your printer (or dns name if you're savvy)
  * Either
    1. Click "Start Scan" from the home page if you you're feeling lucky about the settings and filetype
    2. Specify your settings by
      * Click the Scan tab
      * Select your settings and filetype
      * Click scan
  * Now comes the fun part, depending on the filetype you chose:
    * JPG
      * Right click on the preview image (it's actually the fullsize image shrunk for display) and use "Save image as ..." to get your image.
    * PDF (aka collosal UX failure)  There's a line that says "Click the Save Icon" ... However, there is no save icon anywhere on the page.  There's nothing.  The right-click method used for JPG's doesn't work.  There is really no way to to get the PDF short of the developer approach:
      * Launch the network inspector (or whatever it's called for your browser)
      * Find the GET request made to a URL like /Scan/Jobs/47/Pages/1 (the 47 is the value that will change)
      * Open that link directly in your browser and save from there or use curl/wget to fetch it from a command line.

After encountering this mess too many times and hearing the screams of frustration "I JUST WANT TO SCAN ONE PAGE!!" ... I finally broke down and wrote this little app here.  In the end I found it shaved so much time and frustration that the scanners are now actually useful where before the scanning functionality was such an inconvenient broken limb of the device that the need to scan was faced with the decision to use the MFP or break out a portable scanner and hook it up.

## Prereqs
* OSX
* golang (standard libraries)
* imagemagick (for customizing icons)

## Building
* fetch
```bash
  git clone https://github.com/xcsrz/hp-scan.git
```
* config
```bash
  cd hp-scan
  make config
```
* build
```bash
  make build
```

## Usage
Simply launch the "HP Scan" app created from the build step.  There is no output so the icon will bounce in the dock while the scanner is capturing the image.  Once that's done the PDF will be saved to your desktop and opened in your default image application (most likely Preview).

## ToDos
* add Notifications so there is more than a bouncing icon for feedback
* move the config step to after compiling so releases can be distributed and customized as needed.
* add some form of a UI to offer options on scan quality and JPG files 
* a better icon would be nice - icon's are not my thing

## Technical Notes
* Requesting a scan is achieved by sending a POST request to the MFP with an XML POST body specifying the desired settings.  HOWEVER,
* The Scan will prepare but not actually start until a GET request is made for the actual file to the path:
```
/Scan/Jobs/<JOB ID>/Pages/1
```
* This URL can be found in the XML files from either of the following URLs.  The first returns an XML file with a summary of all the recent jobs with extra detail to the job in the "Processing" state.  The second URL is actual the Location header from the POST request above and only has the info for the job requested so it's a cleaner option.
```
/Jobs/JobList
/Jobs/JobList/<JOB ID>
```
* If you start a job with the POST request and do not follow it with the correct GET request for the job that has been initiated the MFP will get stuck "Processing Scan".  You either need to find the right URL to request the file or unplug the device.
