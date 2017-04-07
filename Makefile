toNDJSON = csv2json | jq -c '.[]'

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

# Who I follow
followings:
	t $@ > $@.txt

# Who follows me
followers:
	t $@ > $@.txt
