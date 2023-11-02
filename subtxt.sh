#!/bin/sh
subs="following.txt"

mkdir -p feeds

# Fetch all feeds
touch main.feed
cat "$subs" | sed -e "/^[\s\#]/d" | while read l; do
	user=$(echo "$l" | cut -d"	" -f1)
	url=$(echo "$l" | cut -d"	" -f2-)

	feed=feeds/"$user".feed
	# Multi-step to handle feeds feeds
	curl -s "$url" -o "$feed"

	# Remove all settings and lines that start with whitespace
	sed "/^\[\s\#]/d" "$feed" > "$feed".tmp

	# Prepend posts with nicknames
	sed -e "s/^/$user	/" "$feed".tmp >> main.feed
	rm "$feed".tmp
done

# cat all feeds, sorted by datetime
sort -k 2,2r main.feed
rm main.feed
