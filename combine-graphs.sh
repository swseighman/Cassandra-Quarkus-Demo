#!/usr/bin/env bash

echo -n "Combining graphs ..."

#cat results/graalvm-jvm_1000.txt results/graalvm-jvm_3000.txt results/graalvm-jvm_5000.txt results/graalvm-native_1000.txt results/graalvm-native_3000.txt results/graalvm-native_5000.txt | wrk2img --log -n graalvm-jvm-1000,graalvm-jvm-3000,graalvm-jvm-5000,graalvm-native-1000,graalvm-native-3000,graalvm-native-5000 results/combined-final.png  >> /dev/null
cat results/graalvm-jvm_final.txt results/graalvm-native_final.txt | wrk2img --log -n graalvm-jvm,graalvm-native results/combined-1-final.png  >> /dev/null
#echo ""
echo " created graph!"
echo "Done."
