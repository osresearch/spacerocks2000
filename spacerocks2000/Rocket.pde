/** \file
 * Rocket that attempts to chase down the player
 */
class Rocket
{
	SpherePoint p;
	int creation;

	Rocket()
	{
		this(PVector.random3D().normalize());
	}

	Rocket(PVector pos)
	{
		p = new SpherePoint();
		p.p = pos;
		p.v = PVector.random3D().normalize().cross(p.p).normalize();
		p.vel = 0.5;
		p.radius = 5 / 1000.0;
		creation = millis();
	}

	boolean update(float dt, PVector target)
	{
		// steer towards the target, should be rate limited
		PVector new_pv = p.p.cross(target).normalize();
/*
		PVector vel_dir = p.v.cross(p.p).normalize();
		float angle = vectorAngle(new_pv, p.v);
		if (angle > PI)
			angle -= 2 * PI;
		float max_angle = radians(20);
		if (angle > max_angle)
			angle = max_angle;
		p.v = vectorRotate(p.v, p.p, angle);
*/
		p.v = new_pv;
		p.update(dt);

		// let them expire after 10 seconds
		// indicate to the caller that this should be deleted
		if (millis() - creation < 10000)
			return true;

		// keep going!
		return false;
	}

	void display(float radius)
	{
		//p.display(radius);

		pushStyle();

		pushMatrix();
		PVector rp = PVector.mult(p.p, radius+30);
		translate(rp.x, rp.y, rp.z);

		// instead of trying to produce a series of rotations,
		// we can just use our own rotation matrix
		PVector vel_dir = p.v.cross(p.p).normalize();
		PVector tan_dir = vel_dir.cross(p.p).normalize();
		applyMatrix(
			tan_dir.x, vel_dir.x, p.p.x, 0,
			tan_dir.y, vel_dir.y, p.p.y, 0,
			tan_dir.z, vel_dir.z, p.p.z, 0,
			0, 0, 0, 1
		);
		
		noFill();
		stroke(255,0,0,255);
		beginShape();
		vertex(0,50,0);
		vertex(-5,-10,0);
		vertex(0,+0,0);
		vertex(+5,-10,0);
		vertex(0,50,0);
		endShape();
/*
		beginShape();
		vertex(0,-10,0);
		vertex(0,+10,0);
		endShape();
		// solar panel
		beginShape();
		vertex(0,-18,-30);
		vertex(0,-14,-20);
		vertex(0,-18,-10);
		vertex(0,-14,  0);
		vertex(0,-18, 10);
		vertex(0,-14, 20);
		vertex(0,-18,+30);
		vertex(0,-8,+30);
		vertex(0,-4,+20);
		vertex(0,-8,+10);
		vertex(0,-4,  0);
		vertex(0,-8,-10);
		vertex(0,-4,-20);
		vertex(0,-8,-30);
		vertex(0,-18,-30);
		endShape();
		// solar panel
		beginShape();
		vertex(0,+18,-30);
		vertex(0,+14,-20);
		vertex(0,+18,-10);
		vertex(0,+14,  0);
		vertex(0,+18, 10);
		vertex(0,+14, 20);
		vertex(0,+18,+30);
		vertex(0,+8,+30);
		vertex(0,+4,+20);
		vertex(0,+8,+10);
		vertex(0,+4,  0);
		vertex(0,+8,-10);
		vertex(0,+4,-20);
		vertex(0,+8,-30);
		vertex(0,+18,-30);
		endShape();
	
		//box(50,20,20);
*/
		popMatrix();

		// draw a forecast
		beginShape();
		for(float dt = 0.01 ; dt < 2 ; dt += 0.5)
		{
			PVector np = p.predict(dt).mult(radius+30);
			stroke(255,0,0,200 - dt*40);
			vertex(np.x, np.y, np.z);
		}
		endShape();

		popStyle();
	}

	boolean collide(PVector pos, float size)
	{
		float dist = PVector.sub(pos, p.p).mag();
		if (dist < size * 4)
			return true;

		// nope
		return false;
	}
};
