/** \file
 * Satellite to be protected by the player
 */
class Satellite
{
	SpherePoint p;
	float angle;

	Satellite()
	{
		this(PVector.random3D().normalize());
	}

	Satellite(PVector pos)
	{
		p = new SpherePoint();
		p.p = pos;
		p.v = PVector.random3D().normalize().cross(p.p).normalize();
		p.vel = 0.1;
	}

	void update(float dt)
	{
		p.update(dt);
		angle += dt;
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
		rotateX(angle);
		
		noFill();
		stroke(0,0,255,255);
/*
		beginShape();
		vertex(0,-5,-10);
		vertex(0,-5,+10);
		vertex(0,+5,+10);
		vertex(0,+5,-10);
		vertex(0,-5,-10);
		endShape();
*/
		box(5,5,20);
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
		popMatrix();

		// draw a forecast
		stroke(0,0,255,100);
		beginShape();
		for(float dt = 0.5 ; dt < 10 ; dt += 1)
		{
			PVector np = p.predict(dt).mult(radius+30);
			stroke(0,0,255,200 - dt*20);
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
