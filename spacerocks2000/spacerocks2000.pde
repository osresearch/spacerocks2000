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

SpherePoint ship;
ArrayList<Bullet> bullets;
int ship_dead = 0;
int ship_lives = 3;

boolean easy = true;
float thrust = 0;
float rcu = 0;
float psi_rate = 0;
float psi = 0;
int last_fire_ms = 0;
int starting_asteroids = 10;


ArrayList<Asteroid> asteroids;

void restart()
{
	bullets = new ArrayList<Bullet>();
	asteroids = new ArrayList<Asteroid>();

	for(int i = 0 ; i < starting_asteroids ; i++)
		asteroids.add(new Asteroid());

	ship.vel = 0.1;

	ship_lives = 3;
	ship_dead = 0;
}

void setup()
{
	planet = new Planet();

	ship = new SpherePoint();
	ship.p = new PVector(1,0,0).normalize();
	ship.v = new PVector(0,-1,0).normalize();

	size(2840, 1400, P3D);
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
			thrust = 0.5;
		if (keyCode == DOWN)
			thrust = -0.25;
		if (keyCode == LEFT)
			rcu = -2.5;
		if (keyCode == RIGHT)
			rcu = +2.5;
	} else
	if (key == 'e') {
		// toggle the rotation assist
		easy = !easy;
	} else
	if (key == 'z') {
		// space brakes
		ship.vel = 0;
	} else
	if (key == ' ') {
		if (now - last_fire_ms > 200)
		{
			ship_fire();
			last_fire_ms = now;
		}

		// arrest any rotation
		if (easy)
			psi_rate = 0;
	}
}

void keyReleased()
{
	if (key == CODED) {
		if (keyCode == UP || keyCode == DOWN)
		{
			thrust = 0;
		}

		if (keyCode == LEFT || keyCode == RIGHT)
		{
			rcu = 0;
			if (easy)
				psi_rate = 0;
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

	if (ship_dead != 0)
	{
		if (now - ship_dead > 1000)
			ship_dead = 0;
		ship.vel = 0;
	}

	// check for still lives
	if (ship_lives == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("GAME OVER", -400, 0, 8);
		popMatrix();

		if (now > ship_dead)
			restart();
	}
	for(int i = 1 ; i < ship_lives+1 ; i++)
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

	// check for no asteroids
	if (asteroids.size() == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("SUCCESS", -300, 0, 8);
		popMatrix();
	}

	ship_update();


	// set the camera to be looking at the planet
	// from off in the X axis.  Our "UP" is in the direction
	// the ship is facing, which is a product of the current
	// velocity vector and our heading relative to it.
	// note that there is an absurd left hand reference frame
	PVector vel_up = ship.p.cross(ship.v);
	PVector up = vectorRotate(vel_up, ship.p, psi);

	// Update the camera position to match the new ship position
	PVector cpos = PVector.mult(ship.p, 1.5*radius);
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

		// check for a ship collision
		float dist = PVector.sub(a.p.p, ship.p).mag() * radius;
		if (dist < a.size * 4 && ship_dead == 0)
		{
			ship_dead = millis() + 1000;
			if (--ship_lives == 0)
				ship_dead += 5000;
		}

		if (!bullet_collision(a))
		{
			a.display(radius);
			continue;
		}

		// this was hit by a bullet
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

	// update the bullets, deleting them after their lifetime
	for (int i = bullets.size() - 1; i >= 0; i--)
	{
		Bullet b = bullets.get(i);
		if (!b.update(dt))
		{
			bullets.remove(i);
			continue;
		}

		// draw it and check for collision
		b.display(radius);
	}

	draw_ship(radius);

	popMatrix();
}


void ship_update()
{
	if (ship_dead != 0 || ship_lives == 0)
		return;

	// set the camera to be looking at the planet
	// from off in the X axis.  Our "UP" is in the direction
	// the ship is facing, which is a product of the current
	// velocity vector and our heading relative to it.
	// note that there is an absurd left hand reference frame
	PVector vel_up = ship.p.cross(ship.v);
	PVector up = vectorRotate(vel_up, ship.p, psi);

	// Update our ship position
	psi_rate += rcu * dt;
	if (psi_rate > PI)
		psi_rate = PI;
	else
	if (psi_rate < -PI)
		psi_rate = -PI;

	psi += psi_rate * dt;
	if (psi > PI)
		psi -= 2*PI;
	else
	if (psi < -PI)
		psi += 2*PI;

	if (thrust != 0)
	{
		// we are thrusting, so adjust the velocity component
		// by computing the current tangental velocity, applying
		// the acceleration due to thrust, then convert back
		// to a perpendicular great circle.
		// there might be a better way...
		PVector vel_dir = ship.v.cross(ship.p).normalize();
		PVector acc_dir = vectorRotate(vel_dir, ship.p, psi);
		PVector vel = PVector.mult(vel_dir, ship.vel);
		PVector acc = PVector.mult(acc_dir, thrust*dt);

		// add the angled thrust to our velocity
		// and compute the magnitude of it.
		vel.add(acc);
		ship.vel = vel.mag();

		// limit the max velocity
		if (ship.vel > 2)
			ship.vel = 2;
		System.out.println(ship.vel);

		// if the velocity is too close to zero,
		// which ever way we were is fine
		// otherwise if our psi was negative, use the negative
		// direction between the angles
		if (abs(ship.vel) > 0.001)
		{
			ship.v = ship.p.cross(vel).normalize();
			PVector new_vel_dir = ship.v.cross(ship.p).normalize();
			float new_psi = vectorAngle(acc_dir, new_vel_dir);
			if (psi < 0)
				new_psi = -new_psi;
			psi = new_psi;
		}
	}

	ship.update(dt);
}

boolean bullet_collision(Asteroid a)
{
	// check for collisions with the bullets
	for (int j = bullets.size() - 1; j >= 0; j--)
	{
		Bullet b = bullets.get(j);
		float dist = PVector.sub(a.p.p, b.p.p).mag() * radius;
		if (dist > a.size * 6)
			continue;

		// close enough
		bullets.remove(j);
		return true;
	}

	// no bullets collided with this asteroid
	return false;
}

void draw_ship(float radius)
{
	pushStyle();

	// move to the current position of the ship
	pushMatrix();
	PVector p = PVector.mult(ship.p, radius);
	translate(p.x, p.y, p.z);

	// instead of trying to produce a series of rotations,
	// we can just use our own rotation matrix
	PVector vel_dir = ship.v.cross(ship.p).normalize();
	PVector acc_dir = vectorRotate(vel_dir, ship.p, psi);
	PVector tan_dir = acc_dir.cross(ship.p).normalize();
	applyMatrix(
		tan_dir.x, acc_dir.x, ship.p.x, 0,
		tan_dir.y, acc_dir.y, ship.p.y, 0,
		tan_dir.z, acc_dir.z, ship.p.z, 0,
		0, 0, 0, 1
	);
		
	if (ship_dead == 0)
		stroke(255,255,255,255);
	else
		stroke(255,0,0,255);
		
	noFill();
	beginShape();
	vertex(0,50,0);
	vertex(-20,-20,0);
	vertex(0,+0,0);
	vertex(+20,-20,0);
	vertex(0,50,0);
	endShape();

	popMatrix();

	// project the next ten seconds
	if (ship_dead == 0)
	{
		noFill();
		beginShape();
		for(int i = 0 ; i < 20 ; i+=3)
		{
			p = PVector.mult(ship.predict(i/10.0), radius+50);
			stroke(100,100,200,200 - i * 10);
			vertex(p.x, p.y, p.z);
		}
		endShape();
	}

	popStyle();
}


void ship_fire()
{
	// fire a space bullet, lined up with current direction
	Bullet b = new Bullet(ship, psi);
	bullets.add(b);
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
