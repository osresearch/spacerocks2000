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
		creation = millis();
	}

	boolean update(float dt, PVector target)
	{
		// steer towards the target, should be rate limited
		p.v = p.p.cross(target).normalize();
		p.update(dt);

		// let them expire
		if (millis() - creation > 10000)
			return false;
		return true;
	}

	void display(float radius)
	{
		pushStyle();

		pushMatrix();
		PVector rp = PVector.mult(p.p, radius+30);
		translate(rp.x, rp.y, rp.z);

		// rotate to create the local tangent plane for the lat/lon
		float lon = atan2(p.p.y, p.p.x);
		float lat = asin(p.p.z / p.p.mag());
		rotateZ(lon);
		rotateY(-lat);
		//rotateX(angle);
		
		noFill();
		stroke(255,0,0,255);
		box(10,10,50);
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
