#!/bin/bash
# tc3-apple-build-wrapper.sh, ABr
#
# assume known latest version for compile
OPENSSL_VERSION="${OPENSSL_VERSION:-3.4.0}"
#
# Build openssl for apple with mods to compile correctly
the_log=/tmp/build_openssl_apple.log
echo 'build_openssl_apple: Start...'
echo ''
# no more auto-remove...
#echo 'remove temporary files...'
#echo "rm -fR ./iphoneos/* ./iphonesimulator/* ./macosx/* ./macosx_catalyst/*"
#rm -fR ./iphoneos/* ./iphonesimulator/* ./macosx/* ./macosx_catalyst/*
#echo ''
echo "scripts/build.sh"
scripts/build.sh
the_rc=$? ; [ $the_rc -ne 0 ] && exit $the_rc
echo ''
echo 'Updating include files...'
for i in iphoneos iphonesimulator macosx macosx_catalyst ; do
  echo "cd $i/include"
  cd $i/include
  the_rc=$? ; [ $the_rc -ne 0 ] && continue
  if [ -d ./OpenSSL ] ; then
    echo "mv OpenSSL openssl"
    mv OpenSSL openssl
  fi
  if [ ! -d ./openssl ] ; then
    echo 'Missing openssl'
    cd ../..
    continue
  fi
  echo "cd openssl"
  cd openssl 2>&1
  the_rc=$?
  if [ $the_rc -eq 0 ] ; then
    echo "sed -ie 's/<OpenSSL/<openssl/' *.h"
    sed -ie 's/<OpenSSL/<openssl/' *.h
    echo 'cd ../../..'
    cd ../../..
  else
    echo 'cd ../..'
    cd ../..
  fi
  echo ''
done
echo 'Done.'

