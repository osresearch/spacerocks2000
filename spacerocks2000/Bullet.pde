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
		p.vel = 1;
		p.p = initial.p.copy();
		PVector vel_dir = initial.v.cross(initial.p).normalize();
		PVector acc_dir = vectorRotate(vel_dir, initial.p, psi);
		p.v = initial.p.cross(acc_dir).normalize();
	}

	boolean update(float dt)
	{
		p.update(dt);
		if (millis() - creation > 5000)
			return false;
		return true;
	}

	void display(float radius)
	{
		pushStyle();
		pushMatrix();
		noFill();
		stroke(0,0,255,255);
		PVector pos = PVector.mult(p.p, radius+30);
		translate(pos.x, pos.y, pos.z);
		sphere(3);
		popMatrix();
		popStyle();
	}
};
