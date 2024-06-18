# QEMU for Trusty

The `trusty-x86_64` contains the binaries for the QEMU emulator
used to test Trusty with Android.

## Downloading the sources

To download the exact repository used to build these binaries,
run the following command:

```
$ repo init --standalone-manifest -u file://path/to/prebuilts/android-emulator/trusty-x86_64/manifest.xml
```

## Updating the binaries (for Googlers)

Run `update_emulator_trusty.sh <BUILD_NUMBER>` with the build number as its
only argument.
