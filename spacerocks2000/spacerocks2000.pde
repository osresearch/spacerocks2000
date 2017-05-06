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


float x_angle = 0;
float z_angle = 0;

void keyPressed() {
	//int keyIndex = -1;
	if (key == CODED) {
		if (keyCode == UP)
			x_angle += 0.1;
		if (keyCode == DOWN)
			x_angle -= 0.1;
		if (keyCode == LEFT)
			z_angle += 0.1;
		if (keyCode == RIGHT)
			z_angle -= 0.1;
	}
}


void draw()
{
	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	translate(width/2, height/2);


	asteroids_write("Hello, world!", -300, -200, 3.0);

	// draw the ship
	stroke(255,255,255,255);
	fill(255,255,255,100);
	line(0,50, -20,-20);
	line(0,50, +20,-20);
	line(-20,-20, 0,-10);
	line(+20,-20, 0,-10);

	// draw the planet underneath us
	pushMatrix();
	translate(0,0,-1200);
	rotateX(x_angle);
	rotateZ(z_angle);
	planet.display();
	popMatrix();

	
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


