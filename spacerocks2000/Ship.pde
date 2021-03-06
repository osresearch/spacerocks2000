/* \file
 * Player's ship class.
 */

class Ship
{
	int dead;
	int delta_v_zero_ms;
	float dead_angle;
	int lives;
	float health;
	boolean healing;
	float delta_v;
	int shield_deployed_ms;
	boolean shield_deployed;


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
		//p.v = new PVector(0,-1,0).normalize();
		p.v = new PVector(0,-1,-2.2).normalize();
		p.radius = 20 / 1000.0;

		restart();
	}

	void restart()
	{
		bullets = new ArrayList<Bullet>();

		dead_angle = 0;
		psi_rate = 0;
		p.vel = 0.3;
		lives = 3;
		dead = 0;
		thrust = 0;
		health = 100;
		delta_v = 999;
		shield_deployed = false;
		p.radius = 20 / 1000.0;
	}

	void update(float dt)
	{
		int now = millis();
/*
		if (dead != 0 || lives == 0)
			return;
*/
		if (delta_v <= 0)
		{
			if (delta_v_zero_ms == 0)
				delta_v_zero_ms = now;
			if (now - delta_v_zero_ms > 10000)
				shipDead();
		} else {
			delta_v_zero_ms = 0;
		}

		shield_update();

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

		if (thrust != 0 && delta_v > 0 && dead == 0)
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

			// expend some delta_v for thrust
			delta_v--;

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
		int now = millis();

		//p.display(radius);
		//pushStyle();

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
			
		noFill();
		if (dead == 0)
		{
			// draw the outline of the ship
			if (healing)
				stroke(0, 255, 0, 255);
			else
			if (health < 30)
				stroke(255, 0, 0, 255);
			else
			if (health < 60)
				stroke(200, 200, 0, 255);
			else
				stroke(255, 255, 255, 255);

			beginShape();
			vertex(0,50,0);
			vertex(-20,-20,0);
			vertex(0,+0,0);
			vertex(+20,-20,0);
			vertex(0,50,0);
			endShape();
		} else {
			// animate the ship coming apart over 1 second
			stroke(255,0,0,255);
			int dead_ms = dead - now;
			if (dead_ms < 0)
				dead_ms = 0;
			if (dead_ms > 1000)
				dead_ms = 1000;
			rotateZ(dead_angle);
			dead_angle += 0.2;

			scale(dead_ms / 1000.0);
			beginShape();
			vertex(0,50,0);
			vertex(-20,-20,0);
			vertex(0,+0,0);
			vertex(+20,-20,0);
			vertex(0,50,0);
			endShape();
		}
			

		// thrusters
		stroke(255,0,0,100);

		// if we are using the rcu
		if (dead != 0)
		{
			// no rcu
		} else
		if (rcu > 0)
		{
			beginShape();
			vertex(+8,30);
			vertex(+25,25);
			vertex(+12,20);
			vertex(+8,30);
			endShape();
		} else
		if (rcu < 0)
		{
			beginShape();
			vertex(-8,30);
			vertex(-25,25);
			vertex(-12,20);
			vertex(-8,30);
			endShape();
		}

		// if we have delta_v and are thrusting, draw
		// a little plume
		if (delta_v > 0 && dead == 0)
		{
			if (thrust > 0)
			{
				// main rocket
				beginShape();
				vertex(0,-2);
				vertex(-10,-12);
				vertex(-5,-30);
				vertex(0,-20);
				vertex(+5,-30);
				vertex(+10,-12);
				vertex(0,-2);
				endShape();
			} else
			if (thrust < 0)
			{
				// retro rocket
				beginShape();
				vertex(0,50);
				vertex(-4,30);
				vertex(-8,60);
				vertex(0,55);
				vertex(+8,60);
				vertex(+4,30);
				vertex(0,50);
				endShape();
			}
		}

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

		if (shield_deployed && dead == 0)
		{
			// fade out the shield over the last second
			int shield_remaining = shield_deployed_ms - now;
			int fade = shield_remaining > 1024 ? 128
				: shield_remaining / 8;

			pushMatrix();
			stroke(0,255,0,fade);
			PVector px = PVector.mult(p.p, radius+50);
			translate(px.x, px.y, px.z);
			sphere(100);
			popMatrix();
		}


		//popStyle();

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
		if (now - last_fire_ms < 250)
			return;
		if (dead != 0)
			return;
		if (delta_v <= 0)
			return;

		delta_v--;
		last_fire_ms = now;
		//fire_sound.play();

		// fire a space bullet, lined up with current direction
		Bullet b = new Bullet(p, psi);
		bullets.add(b);
	}

	// see if the ship has impacted an asteroids
	boolean collide(SpherePoint p2, float dt, float damage)
	{
		// check for a ship collision
		if (p.collide(p2, dt))
		{
			// draw the impact sphere
			p.display(1000);

			// if we do not have the shield deployed
			// then we're ok, but the asteroid is destroyed
			if (shield_deployed)
				return true;

			// subtract a few health points
			health -= damage;
			if (health > 0)
				return true;

			shipDead();
			return true;
		}

		// check for collisions with the bullets
		for (int j = bullets.size() - 1; j >= 0; j--)
		{
			Bullet b = bullets.get(j);
			if (!b.p.collide(p2, dt))
				continue;

			// close enough
			b.p.display(1000);
			bullets.remove(j);
			return true;
		}

		// no bullets nor the ship collided with this asteroid
		return false;
	}

	void shield(int ms)
	{
		int now = millis();

		// don't allow redeployment
		if (shield_deployed)
			return;

		// prevent shield redeploy too soon
		if (now - shield_deployed_ms < 3000)
			return;

		// don't allow shield deployment if delta_v is too low
		if (delta_v < 100)
			return;
		delta_v -= 100;

		// they have deployed the shield for ms miliseconds
		// increase the size of the ship for now
		shield_deployed = true;
		shield_deployed_ms = now + ms;
		p.radius = 100.0 / 1000;
	}

	void shield_update()
	{
		if (!shield_deployed)
			return;

		int now = millis();
		int shield_remaining = shield_deployed_ms - now;
		if (shield_remaining > 0)
			return;

		// the shield has run out; start the timer for
		// redeployment and reduce to normal ship collision size
		shield_deployed = false;
		shield_deployed_ms = now;
		p.radius = 20.0 / 1000;
	}


	void shipDead()
	{
		// we're already dead
		if (dead != 0)
			return;

		// we've run out of health
		health = 0;
		dead = millis() + 1000;
		if (--lives == 0)
			dead += 5000;
	}

};
