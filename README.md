
# react-native-dtmf

## Getting started

`$ npm install react-native-dtmf --save`

### Automatic installation

`$ react-native link react-native-dtmf`

## Usage
```javascript
import dtmf from 'react-native-dtmf';

// Start playing back the tone corresponding to the number "2".
dtmf.startTone(dtmf.DTMF_2);

// 300ms later stop the tone.
setTimeout(() => {
  dtmf.stopTone();
}, 300);
```
### API

Function | Description
--- | ---
<nobr>**startTone**(*tone*)</nobr> | This method starts the playback of a tone of the specified type for a maximum of 5 seconds.
<nobr>**playTone**(*tone*,&#160;*durationMs*)</nobr> | This method starts the playback of a tone of the specified type for the specified duration.
<nobr>**stopTone**()</nobr> | This method stops the tone currently playing.

### Constants

| Constant            | Digit | Tone             |
| ------------------- | ----- | ---------------- |
| DTMF_0              | 0     | 941 Hz + 1336 Hz |
| DTMF_1              | 1     | 697 Hz + 1209 Hz |
| DTMF_2              | 2     | 697 Hz + 1336 Hz |
| DTMF_3              | 3     | 697 Hz + 1477 Hz |
| DTMF_4              | 4     | 770 Hz + 1209 Hz |
| DTMF_5              | 5     | 770 Hz + 1336 Hz |
| DTMF_6              | 6     | 770 Hz + 1477 Hz |
| DTMF_7              | 7     | 852 Hz + 1209 Hz |
| DTMF_8              | 8     | 852 Hz + 1336 Hz |
| DTMF_9              | 9     | 852 Hz + 1477 Hz |
| DTMF_A              | A     | 697 Hz + 1633 Hz |
| DTMF_B              | B     | 770 Hz + 1633 Hz |
| DTMF_C              | C     | 852 Hz + 1633 Hz |
| DTMF_D              | D     | 941 Hz + 1633 Hz |
| DTMF_S / DTMF_STAR  | *     | 941 Hz + 1209 Hz |
| DTMF_P / DTMF_POUND | #     | 941 Hz + 1477 Hz |

## Manual installation

### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-dtmf` and add `RNDtmf.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNDtmf.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import ca.bigdata.voice.dtmf.BigDataDTMFPackage;` to the imports at the top of the file
  - Add `new BigDataDTMFPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-dtmf'
  	project(':react-native-dtmf').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-dtmf/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-dtmf')
  	```
  