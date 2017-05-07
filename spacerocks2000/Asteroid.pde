/** \file
 * Asteroid class
 */
class Asteroid
{
	SpherePoint p;
	float path[];
	float size;
	float rate;
	float angle;

	Asteroid()
	{
		this(
			PVector.random3D().normalize(), // random position
			random(10, 30) // random size
		);
	}

	Asteroid(PVector pos, float sz)
	{
		p = new SpherePoint();
		p.p = pos;
		p.v = PVector.random3D().normalize().cross(p.p).normalize();
		p.vel = random(0.1,0.3);
		rate = random(-0.5,0.5);
		size = sz;
		path = paths[(int)random(paths.length)];
	}

	final float paths[][] = {
	{
                -4, -2,
                -4, +2,
                -2, +4,
                 0, +2,
                +2, +4,
                +4, -2,
                 0, -4,
                -4, -2,
	},
	{
                -4, -2,
                -4, +2,
                -2, +4,
                 0, +2,
                +2, +4,
                +4, -2,
                 0, -4,
                -4, -2,
        },
        {
                -4, -2,
                -3,  0,
                -4, +2,
                -2, +4,
                +4, +2,
                +2, +1,
                +4, -3,
                -4, -2,
        },
        {
                -2, -4,
                -4, -1,
                -3, +4,
                +2, +4,
                +4, +1,
                +3, -4,
                 0, -1,
                -2, -4,
        },
        {
                -4, -2,
                -4, +2,
                -2, +4,
                +2, +4,
                +4, +2,
                +4, -2,
                +1, -4,
                -4, -2,
        },
	};


	void update(float dt)
	{
		p.update(dt);
		angle += rate * dt;
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
		stroke(255,255,255,255);
		beginShape();
		for(int i = 0 ; i < path.length ; i+=2)
			vertex(0,path[i+0]*size, path[i+1]*size);
		endShape();

/*
		noStroke();
		fill(255,255,255,255);
		PVector p = PVector.mult(p.p, radius);
		translate(p.x, p.y, p.z);
		sphere(20);
*/
		popMatrix();

		pushMatrix();
		PVector next = p.predict(1).mult(radius);
		translate(next.x, next.y, next.z);
		stroke(255,0,0,80);
		box(2);

		popMatrix();
		popStyle();
	}
};
