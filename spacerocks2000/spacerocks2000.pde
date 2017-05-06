/** \file
 * Space Rocks 2000
 *
 * The updated version of the hit game, "Space Rocks".
 * Position of things must be tracked in quaternions to avoid
 * discontinuos errors
 *
 * (c) 2017 Trammell Hudson
 */

final float dt = 1.0 / 25;
float radius = 1000;
Planet planet;
SpherePoint ship;

Asteroid asteroids[];

void setup()
{
	planet = new Planet();
	ship = new SpherePoint();
	ship.v = new PVector(0,1,1).normalize();

	asteroids = new Asteroid[8];
	for(int i = 0 ; i < 8 ; i++)
	{
		asteroids[i] = new Asteroid();
	}

	size(2000, 1125, P3D);
	surface.setResizable(true);

	blendMode(ADD);
	noFill();
	stroke(212, 128, 32, 128);

	frameRate(25);
}


float thrust = 0;
float rcu = 0;
float psi_rate = 0;
float psi = 0;

void keyPressed()
{
	if (key == CODED) {
		if (keyCode == UP)
			thrust = 0.1;
		if (keyCode == DOWN)
			thrust = -0.05;
		if (keyCode == LEFT)
			rcu = -0.5;
		if (keyCode == RIGHT)
			rcu = +0.5;
	} else
	if (key == ' ') {
		// fire a space bullet?

		// arrest any rotation
		psi_rate = 0;
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

float x_angle;
float z_angle;

void draw()
{
	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	// draw any overlays
	pushMatrix();
	translate(width/2, height/2);
	translate(0,0,400);
	asteroids_write("SpaceRocks 2000", -400, -400, 3.0);
	popMatrix();

	// Update our ship position
	psi_rate += rcu * dt;
	psi += psi_rate * dt;
	ship.vel += thrust * dt;
	ship.update(dt);

	// set the camera to be looking at the planet
	// from off in the X axis
	PVector vel_up = ship.p.cross(ship.v);
	PVector up = vectorRotate(vel_up, ship.p, psi);

	camera(
		1.5*radius*ship.p.x,
		1.5*radius*ship.p.y,
		1.5*radius*ship.p.z,
		0,
		0,
		0,
		up.x,
		up.y,
		up.z
	);

/*
	// draw the ship
	stroke(255,255,255,255);
	fill(255,255,255,100);
	line(0,-50, -20,+20);
	line(0,-50, +20,+20);
	line(-20,+20, 0,+10);
	line(+20,+20, 0,+10);
	popMatrix();
*/

	// draw the planet underneath us,
	// the camera is already in the ship position,
	// so the planet is drawn in ECEF frame
	pushMatrix();
	planet.display(radius);

	// update the asteroid positions
	for(Asteroid asteroid : asteroids)
	{
		asteroid.update(dt);
		asteroid.display(radius);
	}

	// draw the "ship" based on our XYZ position to track errors
	noStroke();
	fill(255,0,0,255);
	PVector p = PVector.mult(ship.p, radius);
	translate(p.x, p.y, p.z);
	sphere(15);
	
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
