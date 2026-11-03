# gscctl

Open Google Search Console URL inspection and request indexing through background
bmux windows.

```sh
gscctl index https://bmux.cc/articles/bmux-0-1-12/
gscctl index --reindex https://bmux.cc/articles/bmux-0-1-12/
gscctl open https://bmux.cc/articles/bmux-0-1-12/
gscctl link https://bmux.cc/articles/bmux-0-1-12/
gscctl properties
```

The service account selects a matching property and supplies its inspection link.
Grant the service account access to each Search Console property before using it.
`properties` lists the properties accessible to the service account.

The browser uses the `gp` bmux session by default. Set
`GSCCTL_BMUX_SESSION` to use another authenticated session. Successful indexing
requests close their window; failed or already-indexed results leave it open for
inspection.

Requires Python with `google-auth` and `requests`, a service-account key configured
through `GSCCTL_KEY_FILE` or the standard local key locations, and bmux with an
authenticated Search Console profile. Set `GSCCTL_PYTHON` or `GSCCTL_BMUX` to
override executable discovery.
