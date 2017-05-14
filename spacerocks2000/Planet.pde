/** \file
 * Planet and continents.
 *
 * Generated from the wikipedia simplified earth map:
 * https://upload.wikimedia.org/wikipedia/commons/8/8e/BlankMap_World_simple.svg
 *
 * unfortunatley processing's reference frame is left-hand, so the
 * normal equations don't work and we have to invert the Y axis.
 */


class Planet
{
	float map_points[];
	float country_points[];

	Planet()
	{
		String points[];

		points = loadStrings("data/countries.txt");
		country_points = new float[points.length*2];
		for(int i = 0 ; i < points.length ; i++)
		{
			float row[] = float(split(points[i],'\t'));
			country_points[2*i+0] = radians(row[0]);
			country_points[2*i+1] = radians(row[1]);
		}

		points = loadStrings("data/continents.txt");
		map_points = new float[points.length*2];
		for(int i = 0 ; i < points.length ; i++)
		{
			float row[] = float(split(points[i],'\t'));
			map_points[2*i+0] = radians(row[0]);
			map_points[2*i+1] = radians(row[1]);
		}
	}

	void display_points(float radius, float points[])
	{
		beginShape();
		for(int i = 0 ; i < points.length; i+=2)
		{
			float lon = points[i+0];
			float lat = points[i+1];
			if (lat == 0 && lon == 0)
			{
				endShape();
				beginShape();
				continue;
			}

			// project n,e into x,y,z,
			// remembering that processing has a left hand frame
			float x = radius * cos(lat)*cos(lon);
			float y = radius * cos(lat)*sin(lon);
			float z = radius * sin(lat);
			vertex(x,-y,z);
		}

		endShape();
	}


	void display(float radius)
	{
		//pushStyle();

		fill(0,0,0);
		stroke(30,30,30);
		pushMatrix();
		rotateX(PI/2); // put the poles on the poles
		sphere(radius-3);
		popMatrix();

		noFill();
		stroke(255,255,255,80);
		display_points(radius, map_points);
		stroke(255,255,255,60);
		display_points(radius, country_points);

		//popStyle();
	}
};
