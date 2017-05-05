/** \file
 * Super simple font from Asteroids.
 *
 * http://www.edge-online.com/wp-content/uploads/edgeonline/oldfiles/images/feature_article/2009/05/asteroids2.jpg
 */

class AsteroidsChar
{
	final int width;
	final int[] points;

	AsteroidsChar(int w, int[] p)
	{
		width = w;
		points = p;
	}

	float draw(float x, float y, float s)
	{
		float ox = x;
		float oy = y;
		boolean moveto = true;

		for(int i = 0 ; i < points.length ; i+= 2)
		{
			int dx = points[i+0];
			int dy = points[i+1];

			if (dx == -1 && dy == -1)
			{
				moveto = true;
				continue;
			}

			float nx = x + dx * s;
			float ny = y - dy * s;

			if (!moveto)
				line(ox, oy, nx, ny);

			moveto = false;
			ox = nx;
			oy = ny;
		}

		return width * s;
	}
};


AsteroidsChar[] asteroids_font = new AsteroidsChar[]{
	// 0x20
	/* ' '  */ new AsteroidsChar(12, new int[]{ }),
	/* '!'  */ new AsteroidsChar(12, new int[]{ 4,0, 3,2, 5,2, 4,0, -1,-1, 4,4, 4,12 }),
	/* '"'  */ new AsteroidsChar(12, new int[]{ 2,10, 2,6, -1,-1, 6,10, 6,6 }),
	/* '#'  */ new AsteroidsChar(12, new int[]{ 0,4, 8,4, 6,2, 6,10, 8,8, 0,8, 2,10, 2,2 }),
	/* '$'  */ new AsteroidsChar(12, new int[]{ 6,2, 2,6, 6,10, -1,-1, 4,12, 4,0 }),
	/* '%'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,12, -1,-1, 2,10, 2,8, -1,-1, 6,4, 6,2 }),
	/* '&'  */ new AsteroidsChar(12, new int[]{ 8,0, 4,12, 8,8, 0,4, 4,0, 8,4 }),
	/* '\''  */ new AsteroidsChar(12, new int[]{ 2,6, 6,10 }),
	/* '('  */ new AsteroidsChar(12, new int[]{ 6,0, 2,4, 2,8, 6,12 }),
	/* ')'  */ new AsteroidsChar(12, new int[]{ 2,0, 6,4, 6,8, 2,12 }),
	/* '*'  */ new AsteroidsChar(12, new int[]{ 0,0, 4,12, 8,0, 0,8, 8,8, 0,0 }),
	/* '+'  */ new AsteroidsChar(12, new int[]{ 1,6, 7,6, -1,-1, 4,9, 4,3 }),
	/* ','  */ new AsteroidsChar(12, new int[]{ 2,0, 4,2 }),
	/* '-'  */ new AsteroidsChar(12, new int[]{ 2,6, 6,6 }),
	/* '.'  */ new AsteroidsChar(12, new int[]{ 3,0, 4,0 }),
	/* '/'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,12 }),

	// 0x30
	/* '0' */ new AsteroidsChar(12, new int[]{ 0,0, 8,0, 8,12, 0,12, 0,0, 8,12 }),
	/* '1'  */ new AsteroidsChar(12, new int[]{ 4,0, 4,12, 3,10 }),
	/* '2'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, 8,7, 0,5, 0,0, 8,0 }),
	/* '3'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, 8,0, 0,0, -1,-1, 0,6, 8,6 }),
	/* '4'  */ new AsteroidsChar(12, new int[]{ 0,12, 0,6, 8,6, -1,-1, 8,12, 8,0 }),
	/* '5'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,0, 8,6, 0,7, 0,12, 8,12 }),
	/* '6'  */ new AsteroidsChar(12, new int[]{ 0,12, 0,0, 8,0, 8,5, 0,7 }),
	/* '7'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, 8,6, 4,0 }),
	/* '8'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,0, 8,12, 0,12, 0,0, -1,-1, 0,6, 8,6, }),
	/* '9'  */ new AsteroidsChar(12, new int[]{ 8,0, 8,12, 0,12, 0,7, 8,5 }),
	/* ':'  */ new AsteroidsChar(12, new int[]{ 4,9, 4,7, -1,-1, 4,5, 4,3 }),
	/* ';'  */ new AsteroidsChar(12, new int[]{ 4,9, 4,7, -1,-1, 4,5, 1,2 }),
	/* '<'  */ new AsteroidsChar(12, new int[]{ 6,0, 2,6, 6,12 }),
	/* '='  */ new AsteroidsChar(12, new int[]{ 1,4, 7,4, -1,-1, 1,8, 7,8 }),
	/* '>'  */ new AsteroidsChar(12, new int[]{ 2,0, 6,6, 2,12 }),
	/* '?'  */ new AsteroidsChar(12, new int[]{ 0,8, 4,12, 8,8, 4,4, -1,-1, 4,1, 4,0 }),

	// 0x40
	/* '@'  */ new AsteroidsChar(12, new int[]{ 8,4, 4,0, 0,4, 0,8, 4,12, 8,8, 4,4, 3,6 }),
	/* 'A'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,8, 4,12, 8,8, 8,0, -1,-1, 0,4, 8,4 }),
	/* 'B'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,12, 8,10, 4,6, 8,2, 4,0, 0,0 }),
	/* 'C'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12, 8,12 }),
	/* 'D'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,12, 8,8, 8,4, 4,0, 0,0 }),
	/* 'E'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12, 8,12, -1,-1, 0,6, 6,6 }),
	/* 'F'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, -1,-1, 0,6, 6,6 }),
	/* 'G'  */ new AsteroidsChar(12, new int[]{ 6,6, 8,4, 8,0, 0,0, 0,12, 8,12 }),
	/* 'H'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, -1,-1, 0,6, 8,6, -1,-1, 8,12, 8,0 }),
	/* 'I'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,0, -1,-1, 4,0, 4,12, -1,-1, 0,12, 8,12 }),
	/* 'J'  */ new AsteroidsChar(12, new int[]{ 0,4, 4,0, 8,0, 8,12 }),
	/* 'K'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, -1,-1, 8,12, 0,6, 6,0 }),
	/* 'L'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12 }),
	/* 'M'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,8, 8,12, 8,0 }),
	/* 'N'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,0, 8,12 }),
	/* 'O'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,0, 0,0 }),

	// 0x50
	/* 'P'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,6, 0,5 }),
	/* 'Q'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,4, 0,0, -1,-1, 4,4, 8,0 }),
	/* 'R'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,6, 0,5, -1,-1, 4,5, 8,0 }),
	/* 'S'  */ new AsteroidsChar(12, new int[]{ 0,2, 2,0, 8,0, 8,5, 0,7, 0,12, 6,12, 8,10 }),
	/* 'T'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, -1,-1, 4,12, 4,0 }),
	/* 'U'  */ new AsteroidsChar(12, new int[]{ 0,12, 0,2, 4,0, 8,2, 8,12 }),
	/* 'V'  */ new AsteroidsChar(12, new int[]{ 0,12, 4,0, 8,12 }),
	/* 'W'  */ new AsteroidsChar(12, new int[]{ 0,12, 2,0, 4,4, 6,0, 8,12 }),
	/* 'X'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,12, -1,-1, 0,12, 8,0 }),
	/* 'Y'  */ new AsteroidsChar(12, new int[]{ 0,12, 4,6, 8,12, -1,-1, 4,6, 4,0 }),
	/* 'Z'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, 0,0, 8,0, -1,-1, 2,6, 6,6 }),
	/* '['  */ new AsteroidsChar(12, new int[]{ 6,0, 2,0, 2,12, 6,12 }),
	/* '\\'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,0 }),
	/* ']'  */ new AsteroidsChar(12, new int[]{ 2,0, 6,0, 6,12, 2,12 }),
	/* '^'  */ new AsteroidsChar(12, new int[]{ 2,6, 4,12, 6,6 }),
	/* '_'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,0 }),

	// 0x60
	/* '`'  */ new AsteroidsChar(12, new int[]{ 2,10, 6,6 }),
	/* 'a'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,8, 4,12, 8,8, 8,0, -1,-1, 0,4, 8,4 }),
	/* 'b'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,12, 8,10, 4,6, 8,2, 4,0, 0,0 }),
	/* 'c'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12, 8,12 }),
	/* 'd'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,12, 8,8, 8,4, 4,0, 0,0 }),
	/* 'e'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12, 8,12, -1,-1, 0,6, 6,6 }),
	/* 'f'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, -1,-1, 0,6, 6,6 }),
	/* 'g'  */ new AsteroidsChar(12, new int[]{ 6,6, 8,4, 8,0, 0,0, 0,12, 8,12 }),
	/* 'h'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, -1,-1, 0,6, 8,6, -1,-1, 8,12, 8,0 }),
	/* 'i'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,0, -1,-1, 4,0, 4,12, -1,-1, 0,12, 8,12 }),
	/* 'j'  */ new AsteroidsChar(12, new int[]{ 0,4, 4,0, 8,0, 8,12 }),
	/* 'k'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, -1,-1, 8,12, 0,6, 6,0 }),
	/* 'l'  */ new AsteroidsChar(12, new int[]{ 8,0, 0,0, 0,12 }),
	/* 'm'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 4,8, 8,12, 8,0 }),
	/* 'n'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,0, 8,12 }),
	/* 'o'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,0, 0,0 }),

	// 0x70
	/* 'p'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,6, 0,5 }),
	/* 'q'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,4, 0,0, -1,-1, 4,4, 8,0 }),
	/* 'r'  */ new AsteroidsChar(12, new int[]{ 0,0, 0,12, 8,12, 8,6, 0,5, -1,-1, 4,5, 8,0 }),
	/* 's'  */ new AsteroidsChar(12, new int[]{ 0,2, 2,0, 8,0, 8,5, 0,7, 0,12, 6,12, 8,10 }),
	/* 't'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, -1,-1, 4,12, 4,0 }),
	/* 'u'  */ new AsteroidsChar(12, new int[]{ 0,12, 0,2, 4,0, 8,2, 8,12 }),
	/* 'v'  */ new AsteroidsChar(12, new int[]{ 0,12, 4,0, 8,12 }),
	/* 'w'  */ new AsteroidsChar(12, new int[]{ 0,12, 2,0, 4,4, 6,0, 8,12 }),
	/* 'x'  */ new AsteroidsChar(12, new int[]{ 0,0, 8,12, -1,-1, 0,12, 8,0 }),
	/* 'y'  */ new AsteroidsChar(12, new int[]{ 0,12, 4,6, 8,12, -1,-1, 4,6, 4,0 }),
	/* 'z'  */ new AsteroidsChar(12, new int[]{ 0,12, 8,12, 0,0, 8,0, -1,-1, 2,6, 6,6 }),
	
	/* '{'  */ new AsteroidsChar(12, new int[]{ 6,0, 4,2, 4,10, 6,12, -1,-1, 2,6, 4,6 }),
	/* '|'  */ new AsteroidsChar(12, new int[]{ 4,0, 4,5, -1,-1, 4,6, 4,12 }),
	/* '}'  */ new AsteroidsChar(12, new int[]{ 4,0, 6,2, 6,10, 4,12, -1,-1, 6,6, 8,6 }),
	/* '~'  */ new AsteroidsChar(12, new int[]{ 0,4, 2,8, 6,4, 8,8 })
};


float asteroids_write(String s, float x, float y, float sc)
{
	for(char c : s.toCharArray())
	{
		AsteroidsChar ac = asteroids_font[c - 0x20];
		float width = ac.draw(x, y, sc);
		x += width;
	}

	return x;
}
