/** \file
 * Spherical physics.
 *
 * This implements a simple physics model for object locked
 * to the surface of a sphere.
 *
 */

// Predict the position p using the Rodrigues' rotation formula
// https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
// P = P cos(theta) + (V x P) sin(theta) + V(V.P)(1-cos(theta))
// Rotates vector P by theta around vector V.
PVector vectorRotate(PVector p, PVector v, float theta)
{
	return PVector.mult(p,cos(theta))
		.add(v.cross(p).mult(sin(theta)))
		.add(PVector.mult(v,v.dot(p)*(1.0-cos(theta))));
}


// Processing's "angleBetween" doesn't go the long way around
float vectorAngle(PVector a, PVector b)
{
	return atan2(a.cross(b).mag(), a.dot(b));
}

class SpherePoint
{
	SpherePoint()
	{
		p = new PVector(1,0,0);
		v = new PVector(0,1,0);
		vel = 0;
		radius = 0;
	}

	void fromLatLon(float lat, float lon, float psi, float mag)
	{
		lon = radians(lon);
		lat = radians(lat);

		// project n,e into x,y,z
		p = new PVector(
		 (float) (Math.cos(lat)*Math.cos(lon)),
		 (float) (Math.cos(lat)*Math.sin(lon)),
		 (float) (Math.sin(lat))
		);
	}

	PVector p; // position on the sphere
	PVector v; // perpendicular to p, describing the great circle
	float vel; // magnitude of the velocity rotation in rads/s
	float radius; // collision detection radius

	PVector predict(float dt)
	{
		float theta = dt * vel;
		return vectorRotate(p, v, theta);
	}

	// Update the position
	void update(float dt)
	{
		p = predict(dt);
	}

	// check if the two sphere points will collide over the
	// next dt, iterating a few times to deal with errors
	boolean collide(SpherePoint b, float dt)
	{
		for(float t = 0 ; t < dt ; t += dt/8)
		{
			PVector p1 = predict(t);
			PVector p2 = b.predict(t);
			float dist = p1.sub(p2).mag();

			// they are close enough to hit at time t
			if (dist < radius + b.radius)
				return true;
		}

		// they do not collide over the next dt
		return false;
	}

	void display(float planet_radius)
	{
		pushStyle();
		pushMatrix();

		noFill();
		stroke(0,255,0,20);
		PVector px = PVector.mult(p, planet_radius+30);
		translate(px.x, px.y, px.z);
		sphere(planet_radius * radius);

		popMatrix();
		popStyle();
	}
};
