![Spacerocks 2000](https://farm5.staticflickr.com/4187/34458961716_5eedc9c024_z_d.jpg)

This is an update to the [Spacerocks](https://trmm.net/Spacerocks)
Arduino vector game, now with a 3D planet and spherical geometry.
It is very much a work in progress.

Todo:

* Scoring: points for smaller asteroids?
* Joystick interface
* Hyperspace? (and possible destruction)
* Sound
* Aliens

Done:

* Asteroids
* Bullets
* Ship counter
* Win/lose screen
* Delta-V: can the ship run out and require a resupply?
* Satellites: prevent asteroids from destroying them
* ICBM launches to be shot down

Country data
===
The country and continent outlines are generated by [pscoast](http://gmt.soest.hawaii.edu/doc/latest/pscoast.html), part of the [Generic Mapping Toolkit](http://gmt.soest.hawaii.edu/home).
This were the commands used to generate the files:

```
gmt pscoast -R0/360/-90/90 -Dc -N1 -M  | sed 's/^>.*/0	0/' | grep -v '#'  > spacerocks2000/data/countries.tsv
gmt pscoast -R0/360/-90/90 -Dc -W  -M | sed 's/^>.*/0	0/' | grep -v '#'  > spacerocks2000/data/continents.tsv
```
