/** \file
 * Bullet
 */
class Bullet
{
	SpherePoint p;
	int creation;

	Bullet(SpherePoint initial, float psi)
	{
		creation = millis();

		p = new SpherePoint();
		p.vel = 2.1;
		p.p = initial.p.copy();
		PVector vel_dir = initial.v.cross(initial.p).normalize();
		PVector acc_dir = vectorRotate(vel_dir, initial.p, psi);
		p.v = initial.p.cross(acc_dir).normalize();
	}

	boolean update(float dt)
	{
		p.update(dt);
		if (millis() - creation > 2000)
			return false;
		return true;
	}

	void display(float radius)
	{
		pushStyle();
		pushMatrix();
		noFill();
		stroke(255,0,255,255);
		PVector pos = PVector.mult(p.p, radius+30);
		translate(pos.x, pos.y, pos.z);
		//sphere(3);
		box(10);
		popMatrix();

		// draw a tracer
		stroke(255,0,255,100);
		beginShape();
		for(float dt = -0.1 ; dt < 0.5 ; dt += 0.1)
		{
			PVector np = p.predict(-dt/10).mult(radius+30);
			vertex(np.x, np.y, np.z);
		}
		endShape();
		popStyle();
	}

	boolean collide(PVector pos, float size)
	{
		// check over the next dt, subdivided
		for(float dt = 0 ; dt < 0.5 ; dt += 0.05)
		{
			PVector np = p.predict(dt/10);
			float dist = PVector.sub(pos, np).mag();
			if (dist < size * 6)
				return true;
		}

		// nope
		return false;
	}
};
