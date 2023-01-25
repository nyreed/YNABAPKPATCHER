#! /bin/bash


# Look at Y64 and macos-virtualbox.sh for inspiration on portability.


### 2/10/22 Example BASH if exit 0 else exit 1
###  if ls ddd; then echo "Exit 0"; else "Exit 1"; fi


# apktool - https://github.com/iBotPeaches/Apktool
# keytool (part of openjdk/java)
# apksigner (android developer tools)

# macos. brew -> xcode command line -> brew install keytool


# // Install go
# // build $GOOGLEPLAYBIN
# // config $GOOGLEPLAYBIN
# // download apk
# // decompile apk
# // edit apk
# // recompile apk
# // generate signing certificate
# // sign apk.
# // DONE.


#Requirements:# 
# 
# macos: homebrew + xcode clt -> apktool & android-commandline tools -> sdkmanager --install "build-tools;33.0.0"
# go apktool java bash $GOOGLEPLAYBIN
# macos: homebrew, xcode command line tools.

# TODO add contitional make sure script executed in folder.


# //VARS

#STRINGS

STAGE0STRING="Press [Enter] to continue, or [CTRL-C to quit]"
INSTALLERSTRING="press [ENTER] to install, or [CTRL-C] to exit and install manually."
SCRIPTDIR=$(dirname $(realpath -s $0))
HASH="d49148b7c9501526c40890599d4ec4b5aad2bf57c0bd949d4649255c17f87772"


#detect architecture

PLATFORM=$(/usr/bin/uname)
if ! [[ $PLATFORM -eq "Darwin" || $PLATFORM -eq "Linux" ]]
	then
		exit 1
	fi

ARCH=$(/usr/bin/arch)

	if [[ $PLATFORM -eq "Darwin" ]]
		then
		if [[ $ARCH -eq "arm64" ]]
			then
			#echo "arm64 mac"
			ARCHBREW="/opt/homebrew"
		elif [[ $ARCH -eq "i386" ]]
			then
			#echo "intel X86 Mac"
			ARCHBREW="/usr/local"
		else
			echo "Platform: MacOS. Error detecting architecture. Exiting."
			exit 1
		fi
	else
		echo "Error: Script tested for linux and macos only. Exiting"
	fi
	

#detect installed tools
	
if ! command -v apktool &> /dev/null 
	then
		APKTOOLINSTALLED=0 
		else
		APKTOOLINSTALLED=1
		APKTOOLBIN=$(command -v apktool)
fi

if ! command -v zipalign &> /dev/null  ## also requires java
	then
		if [[ $PLATFORM -eq "Darwin" ]]
			then
				if command -v "$ARCHBREW"/share/android-commandlinetools/build-tools/*/zipalign &> /dev/null
					then
						ZIPALIGNINSTALLED=1
						ZIPALIGNBIN=$(command -v "$ARCHBREW"/share/android-commandlinetools/build-tools/*/zipalign)
				elif command -v "$HOME"/Library/Android/sdk/build-tools/*/zipalign &> /dev/null
					then
						ZIPALIGNINSTALLED=1
						ZIPALIGNBIN=$(command -v "$HOME"/Library/Android/sdk/build-tools/*/zipalign)
				else
					ZIPALIGNINSTALLED=0
				fi
		else
			ZIPALIGNINSTALLED=0
		fi
		
else
	ZIPALIGNBIN=$(command -v zipalign)
	ZIPALIGNINSTALLED=1
fi
		
if [[ $PLATFORM -eq "Darwin" ]]; 
	then
		if ! command -v brew &> /dev/null
		then
			BREWINSTALLED=0
		else
			BREWINSTALLED=1
		fi
fi




clear

echo "PATCHER FOR YNAB4 ANDROID CLIENT"
echo ""
echo "This tool will patch the YNAB classic Android app to re-enable Dropbox sync."
echo "This is needed because Dropbox deprecated their TLS1.0 API endpoint."
echo ""
echo ""
if [[ "$#" -ne 1 ]]; then 
echo "Unfortunately this app is no longer available on the Google Play store."
echo "You will need to find a backup of the apk file."
echo "The correct SHA256 is d49148b7c9501526c40890599d4ec4b5aad2bf57c0bd949d4649255c17f87772"
echo ""
echo "Then run the script like this:"
echo "./YNABAPKPATCH.sh /path/to/YNAB4_Classic_3.4.1.apk"
exit 1;
fi

APKPATH="$1"
DECOMP="${APKPATH%.[Aa][Pp][Kk]}"
echo "Checking SHASUM of $APKPATH"
echo "$HASH  $APKPATH" | shasum -c
if [[ $? -ne 0 ]]; then echo "SHASUM not matching. Incorrect or corrupt file"; exit 2; fi
echo ""
read -p "$STAGE0STRING"
clear
echo "REQUIREMENTS"
echo ""
echo "apktool   ->   $(if [ $APKTOOLINSTALLED -eq 1 ]; then printf '\xE2\x9c\x85\x0a'; echo " at $APKTOOLBIN"; else printf '\xe2\x9d\x8c\x0a  Not Found\n'; fi)"
echo "zipalign  ->   $(if [ $ZIPALIGNINSTALLED -eq 1 ]; then printf '\xE2\x9c\x85\x0a'; echo " at $ZIPALIGNBIN"; else printf '\xe2\x9d\x8c\x0a  Not Found\n'; fi)"
echo ""
echo ""
if ! [[ $APKTOOLINSTALLED -eq 1 && $ZIPALIGNINSTALLED -eq 1  ]]
	then
		echo "ensure all these tools are installed and in your terminals $PATH, then rerun this script"
		exit 1
else
	read -p "$STAGE0STRING"
fi


clear
cd "$SCRIPTDIR"
echo "Decompiling APK"
$APKTOOLBIN -r d "$APKPATH" -o "$DECOMP"																	#todo - destination already exists
echo "Patching APK"																				#todo - sed errors / file doesnt exists / rm file doesnt exist.
case $PLATFORM in
	"Linux")		
		sed -i -e 's/"TLSv1"/"TLSv1.2"/g' "$DECOMP/smali/com/dropbox/core/a/b.smali"  #GNU SED! 
		sed -i -e 's/"TLSv1.0"/"TLSv1.2"/g' "$DECOMP/smali/com/dropbox/core/a/b.smali" #GNU SED!
		sed -i -e "s/versionCode: '27296'/versionCode: '27297'/g" "$DECOMP/apktool.yml" #GNU SED!
		sed -i -e 's/3.4.1_classic/3.4.1_YNAB4ever_dropboxtlspatch/g' "$DECOMP/apktool.yml" #GNU SED!
		;;
	"Darwin")
		sed -i '' -e 's/"TLSv1"/"TLSv1.2"/g' "$DECOMP/smali/com/dropbox/core/a/b.smali"  #BSD SED! 
		sed -i '' -e 's/"TLSv1.0"/"TLSv1.2"/g' "$DECOMP/smali/com/dropbox/core/a/b.smali" #BSD SED!
		sed -i '' -e "s/versionCode: '27296'/versionCode: '27297'/g" "$DECOMP/apktool.yml" #BSD SED!
		sed -i '' -e 's/3.4.1_classic/3.4.1_YNAB4ever_dropboxtlspatch/g' "$DECOMP/apktool.yml" #BSD SED!
		;;
esac
rm "$DECOMP/original/META-INF/CERT.SF"
rm "$DECOMP/original/META-INF/MANIFEST.MF"
rm "$DECOMP/META-INF/services/com.fasterxml.jackson.core.JsonFactory"
echo "Recompiling APK"
$APKTOOLBIN b $DECOMP -out "$SCRIPTDIR/patched.apk"						#todo - errors incl output already exists
$ZIPALIGNBIN -p 4 "$SCRIPTDIR/patched.apk" "$SCRIPTDIR/YNAB4_classic_3.4.1_dropbox_tlspatched.apk"						#todo - errors incl output already exists
rm "$SCRIPTDIR/patched.apk"
rm -r "$DECOMP"
echo ""
echo "APK patched and zipaligned."
echo "Renamed to $SCRIPTDIR/YNAB4_classic_3.4.1_dropbox_tlspatched.apk"
read -p "Press [ENTER]"


echo "Done. Now sign the APK, and sideload it to your phone."
echo "You can do this with android-commandlinetools and adb."
read -p "Press any key to exit."