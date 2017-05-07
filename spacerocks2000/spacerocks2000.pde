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
float radius = 900;
Planet planet;

Ship ship;

boolean easy = true;
int starting_asteroids = 10;
int starting_satellites = 4;


ArrayList<Asteroid> asteroids;
ArrayList<Satellite> satellites;

void restart()
{
	asteroids = new ArrayList<Asteroid>();

	for(int i = 0 ; i < starting_asteroids ; i++)
		asteroids.add(new Asteroid());

	satellites = new ArrayList<Satellite>();

	for(int i = 0 ; i < starting_satellites ; i++)
		satellites.add(new Satellite());

	ship.restart();
}

void setup()
{
	planet = new Planet();

	ship = new Ship();

	size(2560, 1400, P3D);
	//fullScreen(P3D);
	surface.setResizable(true);

	blendMode(ADD);
	noFill();
	stroke(212, 128, 32, 128);

	frameRate(25);
	restart();
}


void keyPressed()
{
	int now = millis();

	if (key == CODED) {
		if (keyCode == UP)
			ship.thrust = 0.5;
		if (keyCode == DOWN)
			ship.thrust = -0.25;
		if (keyCode == LEFT)
			ship.rcu = -10;
		if (keyCode == RIGHT)
			ship.rcu = +10;
	} else
	if (key == 'e') {
		// toggle the rotation assist
		easy = !easy;
	} else
	if (key == 'z') {
		// space brakes cost delta_v
		if(ship.delta_v >= 50)
		{
			ship.p.vel = 0;
			ship.delta_v -= 50;
		}

		ship.psi_rate = 0;
	} else
	if (key == 'r') {
		restart();
	} else
	if (key == ' ') {
		ship.fire();

		// arrest any rotation
		if (easy)
			ship.psi_rate = 0;
	}
}

void keyReleased()
{
	if (key == CODED) {
		if (keyCode == UP || keyCode == DOWN)
		{
			ship.thrust = 0;
		}

		if (keyCode == LEFT || keyCode == RIGHT)
		{
			ship.rcu = 0;
			if (easy)
				ship.psi_rate = 0;
		}
	}
}


void draw()
{
	final int now = millis();
	radius = width/2;

	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	// draw any overlays
	stroke(100, 100, 200, 255);
	asteroids_write("SpaceRocks 2000", 100, 100, 3.0);

	if (ship.dead != 0)
	{
		if (now - ship.dead > 1000)
		{
			ship.dead = 0;
			ship.p.vel = 0;
			ship.health = 100;
		}
	}

	// check for still lives
	if (ship.lives == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("GAME OVER", -400, 0, 8);
		popMatrix();

		if (now > ship.dead)
			restart();
	}
	for(int i = 1 ; i < ship.lives+1 ; i++)
	{
		pushMatrix();
		stroke(200, 200, 200, 255);
		translate(width-i*50, 100);
		beginShape();
		vertex(0,-50);
		vertex(-20,+20);
		vertex(0,0);
		vertex(+20,+20);
		vertex(0,-50);
		endShape();
		//asteroids_write("A", width-i*100, 100, 3.0);
		popMatrix();
	}

	// draw the delta-v remaining
	if (ship.delta_v < 100)
		stroke(255, 0, 0, 255);
	else
	if (ship.delta_v < 300)
		stroke(200, 200, 0, 255);
	else
		stroke(100, 100, 255, 255);

	asteroids_write("Delta-V " + str(ship.delta_v), 100, 170, 2.0);

	if (ship.health < 10) stroke(255, 0, 0, 255);
	else
	if (ship.health < 30)
		stroke(200, 200, 0, 255);
	else
		stroke(100, 100, 255, 255);

	asteroids_write("Shield  " + str(ship.health), 100, 200, 2.0);

	stroke(100, 100, 255, 255);
	asteroids_write("SVs     " + str(satellites.size()), 100, 230, 2.0);

	// update asteroid chart
	int count[] = { 0, 0, 0, 0 };
	for (Asteroid a : asteroids)
	{
		int bin = ((int)a.size / 5) - 1;
		if (bin < 0) bin = 0;
		if (bin > 3) bin = 3;
		count[bin]++;
	}

	stroke(100, 100, 255, 255);
	Asteroid atmp = new Asteroid();
	for(int bin = 0 ; bin < 4 ; bin++)
	{
		asteroids_write(str(count[bin]), width-100, 200 + 40*bin, 2.0);
		pushMatrix();
		translate(width-150, 200 + 40*bin - 20);
		beginShape();
		float path[] = atmp.paths[bin];
		for(int i = 0 ; i < path.length ; i += 2)
			vertex((bin+1) * path[i+0], (bin+1) * path[i+1]);
		endShape();
		popMatrix();
	}

	// check for no asteroids
	if (asteroids.size() == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("SUCCESS", -300, 0, 8);
		popMatrix();
	}

	ship.update(dt);


	// set the camera to be looking at the planet
	// from off in the X axis.  Our "UP" is in the direction
	// the ship is facing, which is a product of the current
	// velocity vector and our heading relative to it.
	// note that there is an absurd left hand reference frame
	PVector vel_up = ship.p.p.cross(ship.p.v);
	PVector up = vectorRotate(vel_up, ship.p.p, ship.psi);

	// Update the camera position to match the new ship position
	PVector cpos = PVector.mult(ship.p.p, 1.5*radius);
	PVector ccen = PVector.mult(up, -radius/2.5);
	//cpos.sub(ccen);

	camera(
		cpos.x, cpos.y, cpos.z,
		ccen.x, ccen.y, ccen.z,
		up.x, up.y, up.z
	);
	//scale(1,1,-1); // make this right hand

	// draw the planet underneath us,
	// the camera is already in the ship position,
	// so the planet is drawn in ECEF frame
	planet.display(radius);

	// update the asteroid positions
	for (int i = asteroids.size() - 1; i >= 0; i--)
	{
		Asteroid a = asteroids.get(i);
		a.update(dt);
		a.display(radius);

		if (!ship.collide(a.p.p, a.size/radius))
			continue;

		// this was hit by a bullet or the ship
		asteroids.remove(i);

		// if this was a small one, do not spawn any new ones
		if (a.size < 10)
			continue;

		// split it into a few
		for(int j = 0 ; j < 3 ; j++)
		{
			float sz = random(5,a.size/2);

			Asteroid na = new Asteroid(a.p.p, sz);
			na.display(radius);
			asteroids.add(na);
		}
	}

	// update the satellite positions
	for (int i = satellites.size() - 1; i >= 0; i--)
	{
		Satellite s = satellites.get(i);
		s.update(dt);
		s.display(radius);
		boolean dead = false;

		for(Asteroid a : asteroids)
		{
			if (!s.collide(a.p.p, a.size/radius))
				continue;

			// this was hit by an asteroid
			dead = true;
			break;
		}

		// in non-easy mode we can friendly fire the satellites
		if (!easy)
		for(Bullet b : ship.bullets)
		{
			if (!s.collide(b.p.p, 8/radius))
				continue;

			// this was hit by an bullet
			dead = true;
			break;
		}

		if (dead)
			satellites.remove(i);
	}

	ship.display(radius);

	popMatrix();
}



/*
void draw_axis(void)
{
	// draw an axis to help us
	pushMatrix();
	fill(255,0,0,255);
	translate(250,0,0);
	box(500,10,10);
	popMatrix();

	pushMatrix();
	fill(0,255,0,255);
	translate(0,250,0);
	box(10,500,10);
	popMatrix();

	pushMatrix();
	fill(0,0,255,255);
	translate(0,0,250);
	box(10,10,500);
	popMatrix();
}
*/
	
/*
	asteroids_write("abcdefghijklm", -300, -150, 3.0);
	asteroids_write("nopqrstuvwxyz", -300, -100, 3.0);
	asteroids_write("`0123456789-=", -300, -50, 3.0);
	asteroids_write("~!@#$%^&*()_+", -300,  0, 3.0);
	asteroids_write("[]\\;',./", -300, 50, 3.0);
	asteroids_write("{}|:\"<>?", -300, 100, 3.0);
*/
