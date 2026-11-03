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

The service account supplies inspection links when it has property access. If no
matching property is available to it, `open`, `index`, and `link` use the signed-in
bmux account's property picker and URL inspection input. `properties` lists only
service-account properties. Other API errors are reported directly.

The browser fallback uses the `gp` bmux session by default. Set
`GSCCTL_BMUX_SESSION` to use another authenticated session. `link` closes its
temporary browser window after printing the inspection link. Successful indexing
requests close their window; failed or already-indexed results leave it open for
inspection.

Requires Python with `google-auth` and `requests`, a service-account key configured
through `GSCCTL_KEY_FILE` or the standard local key locations, and bmux with an
authenticated Search Console profile. Set `GSCCTL_PYTHON` or `GSCCTL_BMUX` to
override executable discovery.

Run regression checks with a Python that has the dependencies installed:

```sh
python3 scripts/test_gscctl.py
```
