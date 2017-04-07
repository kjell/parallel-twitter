# csv2json tends to hang when piped to jq?
# tmp file as a workaround
toNDJSON = csv2json > tmp; jq -c '.[]' tmp

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
	jq -c '.[]' tweets.json > timeline.json
	rm tweets.json

# Who I follow (`type=followings`)
# and who follows me (`type=followers`)
follows:
	t $(type) | tee $(type).txt \
		| xargs t users --csv \
		| $(toNDJSON) \
		> $(type).json;
	rm tmp

indexUsers:
	cat $(type).json | while read -r user; do \
	  jq '.' <<<$$user > "$(type)/$$(jq -r '."Screen name"' <<<$$user)"; \
	done
