## YNAB 4 / YNAB Classic APK patcher

KEEP YNAB4 ALIVE!

Patches the deprecated YNAB4\_classic-3.4.1 Android app to use TLS1.2, allowing it to continue syncing with Dropbox.  
  
  Unfortunately the app is no longer on Google Play, so you will need to find your own copy from backups or whatever. If you downloaded it from Google Play previously, you can still download it, though.
  
  The correct SHA256 d49148b7c9501526c40890599d4ec4b5aad2bf57c0bd949d4649255c17f87772"
  
### Usage

./YNABPATCH.sh /path/to/YNAB4\_classic-3.4.1\_classic.apk

The script will spit out a modified APK in the script directory. It will still need signing with _apksigner_ before sideloading onto your device.

The script requires apktool and zipalign to be in your path. These can be obtained from the Android SDK Tools.

Homebrew also has these.

	brew install apktool
	brew install android-commandlinetools
	//then run
	sdkmanager --install "build-tools;33.0.0"

### Tested
Only on MacOS Monterey.
Should work on Linux also.

### THANKS

HUUUGE thanks to Bradley Miller for keeping YNAB4 running on the desktop with [Y64](https://gitlab.com/bradleymiller/Y64)

### Legal Stuff
IMPORTANT NOTE: This shell script is not affiliated with YNAB in any way and YNAB has not endorsed this at all. You Need a Budget and YNAB are registered trademarks of You Need A Budget LLC and/or one of its subsidiaries.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.