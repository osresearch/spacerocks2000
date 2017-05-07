/** \file
 * Asteroid class
 */
class Asteroid
{
	SpherePoint pos;
	float path[];
	float size;
	float rate;
	float angle;

	Asteroid()
	{
		pos = new SpherePoint();
		pos.p = PVector.random3D().normalize();
		pos.v = PVector.random3D().normalize().cross(pos.p).normalize();
		//pos.v = new PVector(1,0,0).cross(pos.p);
		pos.vel = 0.1;
		size = random(10, 30);
		rate = random(-0.5,0.5);

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
		pos.update(dt);
		angle += rate * dt;
	}

	void display(float radius)
	{
		pushStyle();

		pushMatrix();
		PVector p = PVector.mult(pos.p, radius+30);
		translate(p.x, p.y, p.z);

		// rotate to create the local tangent plane for the lat/lon
		float lon = atan2(pos.p.y, pos.p.x);
		float lat = asin(pos.p.z / pos.p.mag());
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
		PVector p = PVector.mult(pos.p, radius);
		translate(p.x, p.y, p.z);
		sphere(20);
*/
		popMatrix();

		pushMatrix();
		PVector next = pos.predict(1).mult(radius);
		translate(next.x, next.y, next.z);
		stroke(255,0,0,80);
		box(2);

		popMatrix();
		popStyle();
	}
};
