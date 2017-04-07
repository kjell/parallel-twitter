# csv2json tends to hang when piped to jq?
# tmp file as a workaround
toNDJSON = csv2json > tmp; jq -c '.[]' tmp

# DocNow/twarc, modified to download user favorites
twarc = python vendor/twarc/twarc.py

#	Download and save all tweets as JSON
#
#	I tried using `t`
#
#	    t timeline @kjell_ --number 3000 --decode-uris --long --csv > timeline.csv
#
#	but it didn't appear to download the entire text of tweets, there was "…" at the
#	end of many of them.
#
#	So instead this uses `tweets.csv` from twitter's self-serve archive service:
#	  https://blog.twitter.com/2012/your-twitter-archive
#	  https://twitter.com/settings/account
timeline.json:
	csv2json 10090_*/tweets.csv > tweets.json
	jq -c '.[]' tweets.json > accounts/$$user/timeline.json
	rm tweets.json

# Download favorites
favorites.json:
	$(twarc) favorites $$user > accounts/$$user/favorites.json

# Who I follow (`type=followings`)
# and who follows me (`type=followers`)
follows:
	t $(type) | tee accounts/$$user/$(type).txt \
		| xargs t users --csv \
		| $(toNDJSON) \
		> accounts/$$user/$(type).json;
	rm tmp

indexUsers:
	cat accounts/$$user/$(type).json | while read -r userJson; do \
	  jq '.' <<<$$userJson > "accounts/$$user/$(type)/$$(jq -r '."Screen name"' <<<$$userJson)"; \
	done
