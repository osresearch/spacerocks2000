/** \file
 * Space Rocks 2000
 *
 * The updated version of the hit game, "Space Rocks".
 * Position of things must be tracked in quaternions to avoid
 * discontinuos errors
 *
 * (c) 2017 Trammell Hudson
 */

float radius = 1000;
Planet planet;

Asteroid asteroids[];

void setup()
{
	planet = new Planet();

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
float vx = 0;
float vy = 0;
float vz = 0;
float psi = 0;

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
		//xv = zv = 0;
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

/*
	// update the velocity vector
	vx += hx * thrust * dt;
	vy += hy * thrust * dt;
	vz += hz * thrust * dt;
	
	// update the position
	x += vx * dt;
	y += vy * dt;
	z += vz * dt;

	// normalize the position on the sphere
	float r = sqrt(x*x + y*y + z*z);
	x /= r;
	y /= r;
	z /= r;

	// update the heading and velocity vectors to be tangent
	// to our new lat/lon
	
	float lat = Math.atan2(y, x);
	float lon = Math.acos(z);
*/

	// draw the planet underneath us
	pushMatrix();
	translate(0,200,-radius*0.8);
	//rotateX(-lat);
	//rotateY(-lon);
	//rotate(-psi);
	planet.display(radius);

	// update the asteroid positions
	for(Asteroid asteroid : asteroids)
	{
		asteroid.update(0.4);
		asteroid.display(radius);
	}
	
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
