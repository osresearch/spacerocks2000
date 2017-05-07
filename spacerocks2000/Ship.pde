/** \file
 * Player's ship class.
 */

class Ship
{
	int dead;
	int lives;
	float health;

	SpherePoint p;
	float psi; // heading angle relative to the velocity great circle
	float psi_rate = 0;

	float thrust = 0;
	float rcu = 0;

	ArrayList<Bullet> bullets;
	int last_fire_ms = 0;

	Ship()
	{
		p = new SpherePoint();
		p.p = new PVector(1,0,0).normalize();
		p.v = new PVector(0,-1,0).normalize();

		restart();
	}

	void restart()
	{
		bullets = new ArrayList<Bullet>();

		psi_rate = 0;
		p.vel = 0.1;
		lives = 3;
		dead = 0;
		thrust = 0;
		health = 100;
	}

	void update(float dt)
	{
		if (dead != 0 || lives == 0)
			return;

		// set the camera to be looking at the planet
		// from off in the X axis.  Our "UP" is in the direction
		// the ship is facing, which is a product of the current
		// velocity vector and our heading relative to it.
		// note that there is an absurd left hand reference frame
		PVector vel_up = p.p.cross(p.v);
		PVector up = vectorRotate(vel_up, p.p, psi);

		// Update our ship position
		psi_rate += rcu * dt;
		if (psi_rate > 3*PI)
			psi_rate = 3*PI;
		else
		if (psi_rate < -3*PI)
			psi_rate = -3*PI;

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
			PVector vel_dir = p.v.cross(p.p).normalize();
			PVector acc_dir = vectorRotate(vel_dir, p.p, psi);
			PVector vel = PVector.mult(vel_dir, p.vel);
			PVector acc = PVector.mult(acc_dir, thrust*dt);

			// add the angled thrust to our velocity
			// and compute the magnitude of it.
			vel.add(acc);
			p.vel = vel.mag();

			// limit the max velocity
			if (p.vel > 2)
				p.vel = 2;

			// if the velocity is too close to zero,
			// which ever way we were is fine
			// otherwise if our psi was negative, use the negative
			// direction between the angles
			if (abs(p.vel) > 0.001)
			{
				p.v = p.p.cross(vel).normalize();
				PVector new_vel_dir = p.v.cross(p.p).normalize();
				float new_psi = vectorAngle(acc_dir, new_vel_dir);
				if (psi < 0)
					new_psi = -new_psi;
				psi = new_psi;
			}
		}

		p.update(dt);
	}

	void display(float radius)
	{
		pushStyle();

		// move to the current position of the ship
		pushMatrix();
		PVector pos = PVector.mult(p.p, radius);
		translate(pos.x, pos.y, pos.z);

		// instead of trying to produce a series of rotations,
		// we can just use our own rotation matrix
		PVector vel_dir = p.v.cross(p.p).normalize();
		PVector acc_dir = vectorRotate(vel_dir, p.p, psi);
		PVector tan_dir = acc_dir.cross(p.p).normalize();
		applyMatrix(
			tan_dir.x, acc_dir.x, p.p.x, 0,
			tan_dir.y, acc_dir.y, p.p.y, 0,
			tan_dir.z, acc_dir.z, p.p.z, 0,
			0, 0, 0, 1
		);
			
		if (dead == 0)
			stroke(255,255,255,255);
		else
			stroke(255,0,0,255);
			
		// draw the outline of the ship
		noFill();
		beginShape();
		vertex(0,50,0);
		vertex(-20,-20,0);
		vertex(0,+0,0);
		vertex(+20,-20,0);
		vertex(0,50,0);
		endShape();

		// draw a "health" meter with a line for each ten points
		stroke(100,100,100,255);
		for(int i = 0 ; i < health ; i += 25)
		{
			line(-10+i/20, i/4+4, +10-i/20, i/4+4);
		}

		popMatrix();

		// project the next ten seconds
		if (dead == 0)
		{
			noFill();
			beginShape();
			for(int i = 2 ; i < 20 ; i+=3)
			{
				pos = PVector.mult(p.predict(i/10.0), radius+50);
				stroke(100,100,200,255 - i * 10);
				vertex(pos.x, pos.y, pos.z);
			}
			endShape();
		}

		popStyle();

		display_bullets(radius);
	}

	void display_bullets(float radius)
	{
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
	}


	void fire()
	{
		int now = millis();
		if (now - last_fire_ms < 200)
			return;

		last_fire_ms = now;

		// fire a space bullet, lined up with current direction
		Bullet b = new Bullet(p, psi);
		bullets.add(b);
	}

	boolean collide(PVector pos, float size)
	{
		// check for a ship collision
		float dist = PVector.sub(pos, p.p).mag();
		if (dist < size * 4 && dead == 0)
		{
			// subtract a few health points
			health -= 30;
			if (health > 0)
				return true;

			// we've run out of health
			health = 0;
			dead = millis() + 1000;
			if (--lives == 0)
				dead += 5000;

			return true;
		}

		// check for collisions with the bullets
		for (int j = bullets.size() - 1; j >= 0; j--)
		{
			Bullet b = bullets.get(j);
			dist = PVector.sub(pos, b.p.p).mag();
			if (dist > size * 6)
				continue;

			// close enough
			bullets.remove(j);
			return true;
		}

		// no bullets nor the ship collided with this asteroid
		return false;
	}
};
