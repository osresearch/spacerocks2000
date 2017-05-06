/** \file
 * Planet and continents.
 *
 * Generated from the wikipedia simplified earth map:
 * https://upload.wikimedia.org/wikipedia/commons/8/8e/BlankMap_World_simple.svg
 */


class Planet
{
	float radius = 1500;
	float planet_points[];

	Planet()
	{
		int i = 0;
		Table points = loadTable("map.csv", "header");
		planet_points = new float[points.getRowCount()*2];
		for(TableRow row : points.rows())
		{
			planet_points[i++] = row.getFloat("x");
			planet_points[i++] = row.getFloat("y");
		}
	}

	void display()
	{
		pushStyle();
		fill(0,0,0,255);
		stroke(20,20,20,200);
		sphere(radius-4);

		noFill();
		stroke(255,255,255,40);
		beginShape();

		for(int i = 0 ; i < planet_points.length; i+=2)
		{
			float px = planet_points[i+0];
			float py = planet_points[i+1];
			if (px == 0 && py == 0)
			{
				endShape();
				beginShape();
				continue;
			}

			float lon = -3.1415 * px / 180;
			float lat = +3.1415 * py / 180;

			// project n,e into x,y,z
			float x = (float) (radius * Math.cos(lat)*Math.cos(lon));
			float z = (float) (radius * Math.cos(lat)*Math.sin(lon));
			float y = (float) (radius * Math.sin(lat));
			vertex(x,y,z);
		}

		endShape();
		popStyle();
	}
};
