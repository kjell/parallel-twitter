# parallel-twitter

Crudely encode my engagement with twitter at a given point in time.

This is in fact nothing like straup/parallel-flickr, but that's where
I cribbed the name.

# TODO

- [ ] prune follow\*s account info to stable data (it not 'last tweet')
- [ ] use `twarc` for timeline? can it get followed/following users?
- [ ] save individual tweets, perhaps as `tweets/<year>/<month>/<day>.md`
- [ ] de-dupe "friends", who are at both `{followings,followers}/<name>.json`
- [ ] is there any way to extrapolate follow\*s back in time?
- [ ] install instructions - csv2json, jq, twarc, t
