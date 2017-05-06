/** \file
 * Planet and continents.
 *
 * Generated from the wikipedia simplified earth map:
 * https://upload.wikimedia.org/wikipedia/commons/8/8e/BlankMap_World_simple.svg
 */


class Planet
{
	float map_points[];
	float country_points[];

	Planet()
	{
		int i = 0;
		Table points = loadTable("countries.tsv");
		country_points = new float[points.getRowCount()*2];
		for(TableRow row : points.rows())
		{
			country_points[i++] = row.getFloat(0);
			country_points[i++] = row.getFloat(1);
		}

		i = 0;
		points = loadTable("continents.tsv");
		map_points = new float[points.getRowCount()*2];
		for(TableRow row : points.rows())
		{
			map_points[i++] = row.getFloat(0);
			map_points[i++] = row.getFloat(1);
		}
	}

	void display_points(float radius, float points[])
	{
		beginShape();
		for(int i = 0 ; i < points.length; i+=2)
		{
			float px = points[i+0];
			float py = points[i+1];
			if (px == 0 && py == 0)
			{
				endShape();
				beginShape();
				continue;
			}

			float lon = radians(px);
			float lat = radians(py);

			// project n,e into x,y,z
			float x = radius * cos(lat)*cos(lon);
			float z = radius * cos(lat)*sin(lon);
			float y = radius * sin(lat);
			vertex(x,y,z);
		}

		endShape();
	}


	void display(float radius)
	{
		pushStyle();

		fill(0,0,0,1);
		stroke(50,50,50,100);
		sphere(radius-3);

		noFill();
		stroke(255,255,255,80);
		display_points(radius, map_points);
		stroke(255,255,255,60);
		display_points(radius, country_points);

		popStyle();
	}
};
