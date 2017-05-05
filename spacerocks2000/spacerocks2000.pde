/** \file
 * Space Rocks 2000
 *
 * The updated version of the hit game, "Space Rocks".
 *
 * (c) 2017 Trammell Hudson
 */

void setup() {
    size(1024, 768, P3D);
    surface.setResizable(true);

    blendMode(ADD);
    noFill();
    stroke(212, 128, 32, 128);

    frameRate(25);
}


void draw() {
	background(0);
	asteroids_write("Hello, world!", 100, 100, 3.0);
	asteroids_write("abcdefghijklm", 100, 250, 3.0);
	asteroids_write("nopqrstuvwxyz", 100, 300, 3.0);
	asteroids_write("`0123456789-=", 100, 450, 3.0);
	asteroids_write("~!@#$%^&*()_+", 100, 500, 3.0);
	asteroids_write("[]\\;',./", 100, 550, 3.0);
	asteroids_write("{}|:\"<>?", 100, 650, 3.0);
}


