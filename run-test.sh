#!/usr/bin/env bash

if [ -z "$1" ]
then
	echo "Oops, pass an arg with a name for output"
    echo "Example: ./run-test.sh graalvm-jvm"
	exit 1
fi

name="$1"

echo -n "Performing benchmark tests ... "
wrk --script post.lua --latency --rate 100 --connections 5 --threads 2 --duration 60s http://localhost:8080/reactive-fruits.html > results/"$name"_1000.txt
wrk --script post.lua --latency --rate 100 --connections 5 --threads 2 --duration 60s http://localhost:8080/reactive-fruits.html > results/"$name"_1001.txt
wrk --script post.lua --latency --rate 100 --connections 5 --threads 2 --duration 60s http://localhost:8080/reactive-fruits.html > results/"$name"_1002.txt
wrk --script post.lua --latency --rate 100 --connections 5 --threads 2 --duration 60s http://localhost:8080/reactive-fruits.html > results/"$name"_1003.txt
wrk --script post.lua --latency --rate 100 --connections 5 --threads 2 --duration 60s http://localhost:8080/reactive-fruits.html > results/"$name"_final.txt

echo " done."
cat results/"$name"_1000.txt results/"$name"_1001.txt results/"$name"_1002.txt results/"$name"_1003.txt results/"$name"_final.txt | wrk2img --log -n "$name"-1000,"$name"-1001,"$name"-1002,"$name"-1003,"$name"_final results/"$name"-final.png  >> /dev/null
#cat results/"$name"_final.txt | wrk2img --log -n graalvm-jvm-1000 results/"$name"-final.png
echo ""
echo -n "Creating graph ..."
echo " done."
