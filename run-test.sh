#!/usr/bin/env bash

if [ -z "$1" ]
then
	echo "Oops, pass an arg with a name for output"
        echo "Example: ./run-ee-test.sh test1"
	exit 1
fi

name="$1"

echo "Performing benchmark tests ... runs for approximately 90s"
wrk --script post.lua --latency --rate 300 --connections 5 --threads 2 --duration 30s http://localhost:8080/reactive-fruits.html > results/"$name"_300.txt
wrk --script post.lua --latency --rate 500 --connections 5 --threads 2 --duration 30s http://localhost:8080/reactive-fruits.html > results/"$name"_500.txt
wrk --script post.lua --latency --rate 700 --connections 5 --threads 2 --duration 30s http://localhost:8080/reactive-fruits.html > results/"$name"_700.txt

cat results/"$name"_300.txt results/"$name"_500.txt results/"$name"_700.txt | wrk2img --log -n "$name"-300,"$name"-500,"$name"-700 results/"$name"-final.png
echo ""
echo "Created graph!"
echo "Done."
