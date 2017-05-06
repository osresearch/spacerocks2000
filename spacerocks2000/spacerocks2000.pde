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


float thrust = 0;
float rcu = 0;
float xv = 0;
float zv = 0;
float x_angle = 0;
float z_angle = 0;

void keyPressed()
{
	if (key == CODED) {
		if (keyCode == UP)
			thrust = 1;
		if (keyCode == DOWN)
			thrust = -0.5;
		if (keyCode == LEFT)
			rcu = -0.1;
		if (keyCode == RIGHT)
			rcu = +0.1;
	} else
	if (key == ' ') {
		// fire a space bullet
		xv = zv = 0;
	}
}

void keyReleased()
{
	if (key == CODED) {
		if (keyCode == UP)
			thrust = 0;
		if (keyCode == DOWN)
			thrust = 0;
		if (keyCode == LEFT)
			rcu = 0;
		if (keyCode == RIGHT)
			rcu = 0;
	}
}


void draw()
{
	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	translate(width/2, height/2);


	pushMatrix();
	translate(0,0,400);
	asteroids_write("SpaceRocks 2000", -400, -400, 3.0);

	// draw the ship
	stroke(255,255,255,255);
	fill(255,255,255,100);
	line(0,-50, -20,+20);
	line(0,-50, +20,+20);
	line(-20,+20, 0,+10);
	line(+20,+20, 0,+10);
	popMatrix();

	// update the angles (should be positions)
	xv += thrust * 0.001;
	zv += rcu * 0.001;
	x_angle += xv;
	z_angle += zv;

	// draw the planet underneath us
	pushMatrix();
	translate(0,0,-1200);
	rotateX(-x_angle);
	rotateZ(-z_angle);
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
