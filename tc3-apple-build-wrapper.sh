#!/bin/bash
# tc3-apple-build-wrapper.sh, ABr
#
# Build openssl for apple with mods to compile correctly
the_log=/tmp/build_openssl_apple.log
echo 'build_openssl_apple: Start...' | tee "$the_log"
echo '' | tee -a "$the_log"
# no more auto-remove...
#echo 'remove temporary files...' | tee "$the_log"
#echo "rm -fR ./iphoneos/* ./iphonesimulator/* ./macosx/* ./macosx_catalyst/*" | tee -a "$the_log"
#rm -fR ./iphoneos/* ./iphonesimulator/* ./macosx/* ./macosx_catalyst/* 2>&1 | tee -a "$the_log"
#echo '' | tee -a "$the_log"
echo "scripts/build.sh" | tee -a "$the_log"
scripts/build.sh 2>&1 | tee -a "$the_log"
the_rc=$? ; [ $the_rc -ne 0 ] && exit $the_rc
echo '' | tee -a "$the_log"
echo 'Updating include files...' | tee -a "$the_log"
for i in iphoneos iphonesimulator macosx macosx_catalyst ; do
  echo "cd $i/include" | tee -a "$the_log"
  cd $i/include 2>&1 | tee -a "$the_log"
  the_rc=$? ; [ $the_rc -ne 0 ] && continue
  if [ -d ./OpenSSL ] ; then
    echo "mv OpenSSL openssl" | tee -a "$the_log"
    mv OpenSSL openssl 2>&1 | tee -a "$the_log"
  fi
  if [ ! -d ./openssl ] ; then
    echo 'Missing openssl'
    cd ../..
    continue
  fi
  echo "cd openssl" | tee -a "$the_log"
  cd openssl 2>&1 | tee -a "$the_log"
  the_rc=$?
  if [ $the_rc -eq 0 ] ; then
    echo "sed -ie 's/<OpenSSL/<openssl/' *.h" | tee -a "$the_log"
    sed -ie 's/<OpenSSL/<openssl/' *.h 2>&1 | tee -a "$the_log"
    echo 'cd ../../..' | tee -a "$the_log"
    cd ../../.. 2>&1 | tee -a "$the_log"
  else
    echo 'cd ../..' | tee -a "$the_log"
    cd ../.. 2>&1 | tee -a "$the_log"
  fi
  echo '' | tee -a "$the_log"
done
echo 'Done.' | tee -a "$the_log"

