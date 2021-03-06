![Short game play clip ](https://j.gifs.com/k54QOE.gif)

This is an update to the [Spacerocks](https://trmm.net/Spacerocks)
Arduino vector game, now with a 3D planet and spherical geometry.
It is very much a work in progress, but playable and somewhat fun.
[Short video](https://www.youtube.com/watch?v=84LSe9Srnpw) of the
game play shows the major features:

* Left and right arrows rotate the ship. The faint blue line indicates your ground track velocity.
* Up arrow is the main thruster, in line with the ship.
* Down arrow is retro-thruster.
* Space bar fires.
* `e` switches off "easy" mode, enables friendly fire against satellites and disables spin stabilization.
* 'z' activates shield, but costs 100 delta-V.

The retro-thruster is not quite as powerful as the main thruster,
so to slow down it is better to do a a "skew flip" to face the opposite
direction of travel and fire the main thruster.

The ship will heal damage and regain delta-V when it is close to a
satellite (health and delta-V indicators turn green to show that they
are healing).

When a rocket is launched it will attempt to home in on the ship.
It can be out run or shot down.  The rocket dynamics need some updates.



Todo:

* Scoring: points for smaller asteroids?
* Hyperspace? (and possible destruction)
* Sound (in progress)
* Aliens

Done:

* Asteroids
* Bullets
* Ship counter
* Win/lose screen
* Delta-V: can the ship run out and require a resupply?
* Satellites: prevent asteroids from destroying them
* ICBM launches to be shot down
* Level up
* Joystick interface
* Track number of bullets fired.
* Improve bullet accuracy

Country data
===
![Spacerocks 2000](https://farm5.staticflickr.com/4187/34458961716_5eedc9c024_z_d.jpg)

The country and continent outlines are generated by [pscoast](http://gmt.soest.hawaii.edu/doc/latest/pscoast.html), part of the [Generic Mapping Toolkit](http://gmt.soest.hawaii.edu/home).
This were the commands used to generate the files:

```
gmt pscoast -R0/360/-90/90 -Dc -N1 -M  | sed 's/^>.*/0	0/' | grep -v '#'  > spacerocks2000/data/countries.tsv
gmt pscoast -R0/360/-90/90 -Dc -W  -M | sed 's/^>.*/0	0/' | grep -v '#'  > spacerocks2000/data/continents.tsv
```
