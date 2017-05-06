/** \file
 * Space Rocks 2000
 *
 * The updated version of the hit game, "Space Rocks".
 *
 * (c) 2017 Trammell Hudson
 */

float angle = 0;
Planet planet;

void setup()
{
	planet = new Planet();

	size(2048, 1500, P3D);
	surface.setResizable(true);

	blendMode(ADD);
	noFill();
	stroke(212, 128, 32, 128);

	frameRate(25);
}



void draw()
{
	background(0);
	pushMatrix();


	translate(width/2, height/2);


	asteroids_write("Hello, world!", -300, -200, 3.0);

	translate(0,0,-1200);
	//rotateX(angle += 0.02);
	//rotateZ(angle += 0.02);

	planet.display();
/*
	asteroids_write("abcdefghijklm", -300, -150, 3.0);
	asteroids_write("nopqrstuvwxyz", -300, -100, 3.0);
	asteroids_write("`0123456789-=", -300, -50, 3.0);
	asteroids_write("~!@#$%^&*()_+", -300,  0, 3.0);
	asteroids_write("[]\\;',./", -300, 50, 3.0);
	asteroids_write("{}|:\"<>?", -300, 100, 3.0);
*/

	popMatrix();
}


