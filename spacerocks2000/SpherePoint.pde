/** \file
 * Spherical physics.
 *
 * This implements a simple physics model for object locked
 * to the surface of a sphere.
 *
 */

// Predict the position p using the Rodrigues' rotation formula
// P = P cos(theta) + (V x P) sin(theta) + V(V.P)(1-cos(theta))
PVector vectorRotate(PVector p, PVector v, float theta)
{
	return PVector.mult(p,cos(theta))
		.add(v.cross(p).mult(sin(theta)))
		.add(PVector.mult(v,v.dot(p)*(1.0-cos(theta))));
}

class SpherePoint
{
	SpherePoint()
	{
		p = new PVector(1,0,0);
		v = new PVector(0,1,0);
		vel = 0;
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
};
