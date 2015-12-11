test: check-prereq
	@go run *.go

executable: check-prereq
	@go build -o hp-scan

build: executable
	@test -d HP\ Scan.app && rm -rf "HP Scan.app" 
	@mkdir -p HP\ Scan.app/Contents/MacOS
	@test -f Info.plist && cp Info.plist HP\ Scan.app/Contents/Info.plist
	@cp hp-scan HP\ Scan.app/Contents/MacOS/hp-scan
	@chmod +x hp-scan HP\ Scan.app/Contents/MacOS/hp-scan
	@test -f icon.icns && mkdir -p HP\ Scan.app/Contents/Resources \
		&& cp icon.icns HP\ Scan.app/Contents/Resources/icon.icns

install: build
	@cp HP\ Scan.app /Applications/

icon: 
	@mkdir icon.iconset
	@convert -resize 16x16 ./icon.png icon.iconset/icon_16x16.png
	@convert -resize 32x32 ./icon.png icon.iconset/icon_16x16@2x.png
	@convert -resize 32x32 ./icon.png icon.iconset/icon_32x32.png
	@convert -resize 64x64 ./icon.png icon.iconset/icon_32x32@2x.png
	@convert -resize 128x128 ./icon.png icon.iconset/icon_128x128.png
	@convert -resize 256x256 ./icon.png icon.iconset/icon_128x128@2x.png
	@convert -resize 256x256 ./icon.png icon.iconset/icon_256x256.png
	@iconutil -c icns icon.iconset
	@rm -rf icon.iconset

config:
	@read -p "What is the IP of your HP printer?   " test ; \
		echo "package main\n\nconst (\n\tPrinterAddress = \"$$test\"\n)\n" > config.go

check-prereq:
	@test -f config.go || { echo "ERROR: config.go not present. Try running make config first."; exit 2; }