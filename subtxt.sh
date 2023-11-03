#!/bin/sh
# subtxt - pulls and prints twtxt files
CONFIG="./"
SUBS="$CONFIG/following.txt"
FEEDS="$CONFIG/feeds"
TIMEOUT=10

# Make dirs if they don't exist, clean up old main feed
mkdir -p "$FEEDS"
touch "$SUBS"
if [ -e main.feed ]; then rm main.feed; fi

# Fetch all feeds
sed -e "/^[\s\#]/d" "$SUBS" | while read -r l; do
	user=$(echo "$l" | cut -d"	" -f1)
	url=$(echo "$l" | cut -d"	" -f2-)
	feed="$FEEDS"/"$user".feed

	# Multi-step to handle local feeds
	curl -s "$url" -o "$feed" --max-time $TIMEOUT

	# Check to see if curl failed
	if ! curl -s "$url" -o "$feed" --max-time $TIMEOUT; then
		echo "ERROR: Couldn't fetch $user ($url)\n"
	else
		# Remove all settings and lines that start with whitespace
		sed "/^[\s\#]/d" "$feed" > "$feed".tmp
		sed -e "s/^/$user\t/" "$feed".tmp >> main.feed
	fi
done

# cat all feeds, sorted by datetime
sort -k 2,2r main.feed > tmp && mv tmp main.feed
column -s"	" -t main.feed
