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
boolean easy = true;
float thrust = 0;
float rcu = 0;
float psi_rate = 0;
float psi = 0;
final int max_bullets = 16;
int last_fire_ms = 0;


ArrayList<Asteroid> asteroids;

void setup()
{
	planet = new Planet();

	ship = new SpherePoint();
	ship.p = new PVector(1,0,0).normalize();
	ship.v = new PVector(0,-1,0).normalize();
	ship.vel = 0.1;

	bullets = new ArrayList<Bullet>();

	asteroids = new ArrayList<Asteroid>();

	for(int i = 0 ; i < 8 ; i++)
	{
		asteroids.add(new Asteroid());
	}

	size(2000, 1125, P3D);
	surface.setResizable(true);

	blendMode(ADD);
	noFill();
	stroke(212, 128, 32, 128);

	frameRate(25);
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
			rcu = -1.5;
		if (keyCode == RIGHT)
			rcu = +1.5;
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

	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	// draw any overlays
	asteroids_write("SpaceRocks 2000", 100, 100, 3.0);

	// set the camera to be looking at the planet
	// from off in the X axis.  Our "UP" is in the direction
	// the ship is facing, which is a product of the current
	// velocity vector and our heading relative to it.
	// note that there is an absurd left hand reference frame
	PVector vel_up = ship.p.cross(ship.v);
	PVector up = vectorRotate(vel_up, ship.p, psi);

	// Update our ship position
	psi_rate += rcu * dt;
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

		if (!bullet_collision(a))
		{
			a.display(radius);
			continue;
		}

		// this was hit by a bullet
		asteroids.remove(i);

		// if this was a small one, do not spawn any new ones
		if (a.size < 5)
			continue;

		// split it into a few
		for(int j = 0 ; j < 3 ; j++)
		{
			float sz = random(3,a.size/2);

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
		System.out.print("hit! ");
		System.out.print(a.p.p);
		System.out.print(" ");
		System.out.print(b.p.p);
		System.out.println();
		bullets.remove(j);
		return true;
	}

	// no bullets collided with this asteroid
	return false;
}

void draw_ship(float radius)
{
/*
	pushMatrix();
	noStroke();
	fill(255,0,0,255);
	PVector p = PVector.mult(ship.p, radius);
	translate(p.x, p.y, p.z);
	sphere(15);
	popMatrix();
*/

	// move to the current position of the ship
	pushMatrix();
	PVector p = PVector.mult(ship.p, radius);
	translate(p.x, p.y, p.z);

/*

	pushMatrix();
	stroke(255,0,0,255);
	noFill();
	beginShape();
	vertex(0,0,+50);
	vertex(0,-20,-20);
	vertex(0,0,+0);
	vertex(0,+20,-20);
	vertex(0,0,+50);
	endShape();
	popMatrix();

	// the angle depends on the velocity great circle and
	// the heading offset from that circle.  The "north" on
	// the tangent plane is pointing towards (0,0,1) so we
	// want to compute the angle between that and our ship
	PVector pole_dir = new PVector(0,0,1).sub(ship.p);
	PVector vel_dir = ship.v.cross(ship.p).normalize();
	PVector acc_dir = vectorRotate(vel_dir, ship.p, psi);
	float angle = vectorAngle(vel_dir, pole_dir);
	rotateX(-angle);
	//System.out.print(lon*180/PI);
	//System.out.print(" ");
	//System.out.print(lat*180/PI);
	//System.out.println();
*/
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
		

	stroke(255,255,255,255);
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
	noFill();
	beginShape();
	for(int i = 0 ; i < 12 ; i+=3)
	{
		p = PVector.mult(ship.predict(i/10.0), radius+10);
		stroke(100,100,200,200 - i * 20);
		vertex(p.x, p.y, p.z);
	}
	endShape();

	pushMatrix();
	stroke(100,100,200,200);
	p = PVector.mult(ship.predict(1.0), radius+10);
	translate(p.x, p.y, p.z);
	box(10);
	popMatrix();
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
