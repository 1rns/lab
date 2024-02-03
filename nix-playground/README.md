#### Command to run

```bash
nix-shell -p entr findutils bash --run \
        "ls *.nix | \
     entr -rs ' \
       nix-build eval.nix -A config.scripts.output --no-out-link \
       | xargs printf -- \"%s/bin/map\" \
       | xargs bash \
     ' \
    "
```

#### Example

![demo](./demo.png)

***

Generated command (shortened):
```bash

./map path="weight:5|color:blue|geodesic:false|$(./geocode 'Taranaki, New Zealand')|$(./geocode 'Talille, Estonia')" path="weight:5|color:blue|geodesic:false|$(./geocode 'Wellington, New Zealand')|$(./geocode 'Sydney, Australia')" markers="label:Q|size:mid|color:red|$(./geocode 'Taranaki, New Zealand')" markers="label:Q|size:mid|color:red|$(./geocode 'Talille, Estonia')" markers="label:L|size:mid|color:red|$(./geocode 'Wellington, New Zealand')" markers="label:L|size:mid|color:red|$(./geocode 'Sydney, Australia')" size=640x640 scale=2 | feh -
```
