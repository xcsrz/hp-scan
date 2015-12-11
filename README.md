# hp-scan
A simple OSX app to fetch a PDF file from an HP Deskjet MFP.  It may work with other HP devices. 

This is just an initial pass at this app.  There is no UI and no settings other than the IP which needs to be set before compiling.

## Prereqs
* OSX
* golang (standard libraries)
* imagemagick (for customizing icons)

## Building
* fetch
		git clone https://github.com/xcsrz/hp-scan.git
* config
		cd hp-scan
		make config
* build
		make build

## Usage
Simply launch the "HP Scan" app created from the build step.  There is no output so the icon will bounce in the dock while the scanner is capturing the image.  Once that's done the PDF will be saved to your desktop and opened in your default image application (most likely Preview).

## ToDos
* add Notifications so there is more than a bouncing icon for feedback
* move the config step to after compiling so releases can be distributed and customized as needed.
* add some form of a UI to offer options on scan quality and JPG files 
