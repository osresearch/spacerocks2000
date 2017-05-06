/** \file
 * Asteroid class
 */
class Asteroid
{
	SpherePoint pos;

	Asteroid()
	{
		pos = new SpherePoint();
		pos.p = PVector.random3D().normalize();
		pos.v = PVector.random3D().normalize().cross(pos.p).normalize();
		//pos.v = new PVector(1,0,0).cross(pos.p);
		pos.vel = 0.1;
	}


	void update(float dt)
	{
		pos.update(dt);
	}

	void display(float radius)
	{
		pushStyle();
		pushMatrix();

		noStroke();
		fill(255,255,255,255);
		PVector p = PVector.mult(pos.p, radius);
		translate(p.x, p.y, p.z);
		sphere(20);
		popMatrix();

		pushMatrix();
		PVector next = pos.predict(1).mult(radius);
		translate(next.x, next.y, next.z);
		fill(255,0,0,80);
		sphere(2);

		popMatrix();
		popStyle();
	}
};
