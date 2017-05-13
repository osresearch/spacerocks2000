/** \file
 * Space Rocks 2000
 *
 * The updated version of the hit game, "Space Rocks".
 * Position of things must be tracked in quaternions to avoid
 * discontinuos errors
 *
 * (c) 2017 Trammell Hudson
 */

final float dt = 1.0 / 30;
float radius = 1000;
Planet planet;

Ship ship;
Rocket rocket;

boolean attract = true;
boolean healing = false;
boolean easy = true;
int rocket_chance;
int starting_asteroids;
int starting_satellites;
float minimum_satellite_size;
int success_time;

//import processing.sound.*;
//SoundFile fire_sound, thrust_sound, boom_sound, rocket_sound, heal_sound;
//boolean heal_sound_playing = false;
//boolean rocket_sound_playing = false;

ArrayList<Asteroid> asteroids;
ArrayList<Satellite> satellites;

void restart()
{
	asteroids = new ArrayList<Asteroid>();

	for(int i = 0 ; i < starting_asteroids ; i++)
		asteroids.add(new Asteroid(random(minimum_satellite_size, 40)));

	satellites = new ArrayList<Satellite>();

	for(int i = 0 ; i < starting_satellites ; i++)
		satellites.add(new Satellite());
}

void restart_full()
{
	ship.restart();
	rocket_chance = 1;
	starting_satellites = 4;
	starting_asteroids = 10;
	minimum_satellite_size = 10;
	attract = true;
	easy = true;

	restart();
}

void setup()
{
	planet = new Planet();
	ship = new Ship();
/*
	fire_sound = new SoundFile(this, "fire.wav");
 	thrust_sound = new SoundFile(this, "thrust.wav");
 	boom_sound = new SoundFile(this, "bangLarge.wav");
 	rocket_sound = new SoundFile(this, "saucerBig.wav");
 	heal_sound = new SoundFile(this, "beat1.wav");
*/

	//size(2560, 1400, P3D);
	size(1920, 1000, P3D);
	//fullScreen(P3D);
	surface.setResizable(true);

	blendMode(ADD);
	noFill();
	stroke(212, 128, 32, 128);

	frameRate(30);
	restart_full();
}


void keyPressed()
{
	int now = millis();
	if (attract)
	{
		attract = false;
		return;
	}

	if (key == CODED) {
		if (keyCode == UP)
		{
			ship.thrust = 0.5;
			//thrust_sound.loop();
		}
		if (keyCode == DOWN)
		{
			ship.thrust = -0.25;
			//thrust_sound.loop();
		}
		if (keyCode == LEFT)
			ship.rcu = -10;
		if (keyCode == RIGHT)
			ship.rcu = +10;
	} else
	if (key == 'e') {
		// toggle the rotation assist
		easy = !easy;
	} else
	if (key == 'z') {
		// space brakes cost delta_v
		if(ship.delta_v >= 50)
		{
			ship.p.vel = 0;
			ship.delta_v -= 50;
		}

		ship.psi_rate = 0;
	} else
	if (key == '9') {
		// fake a level up by erasing all the asteroids
		asteroids = new ArrayList<Asteroid>();
	} else
	if (key == 'r') {
		restart();
	} else
	if (key == 'p') {
		rocket = new Rocket();
	} else
	if (key == ' ') {
		ship.fire();
	}
}

void keyReleased()
{
	if (key == CODED) {
		if (keyCode == UP || keyCode == DOWN)
		{
			ship.thrust = 0;
			//thrust_sound.stop();
		}

		if (keyCode == LEFT || keyCode == RIGHT)
		{
			ship.rcu = 0;
			if (easy)
				ship.psi_rate = 0;
		}
	}
}


void draw()
{
	final int now = millis();
	//radius = width/2;

	background(0);
	pushMatrix();

	ambientLight(255,255,255);

	// draw any overlays
	if (attract)
	{
		draw_attract_flat();
	} else {
		stroke(100, 100, 200, 255);
		asteroids_write("SpaceRocks 2000", 100, 100, 3.0);
	}

	if (ship.dead != 0)
	{
		if (now - ship.dead > 1000)
		{
			ship.dead = 0;
			ship.p.vel = 0;
			ship.health = 100;
		}
	}

	// check for still lives
	if (ship.lives == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("GAME OVER", -400, 0, 8);
		popMatrix();

		if (now > ship.dead)
			restart_full();
	}
	for(int i = 1 ; i < ship.lives+1 ; i++)
	{
		pushMatrix();
		stroke(200, 200, 200, 255);
		translate(width-i*50, 100);
		beginShape();
		vertex(0,-50);
		vertex(-20,+20);
		vertex(0,0);
		vertex(+20,+20);
		vertex(0,-50);
		endShape();
		//asteroids_write("A", width-i*100, 100, 3.0);
		popMatrix();
	}

	if (rocket != null)
	{
		pushMatrix();
		stroke(255, 0, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("DANGER! ROCKET!", -250, -200, 3);
		popMatrix();
	} else {
		// random chance of rocket
		if (random(0,1000) < rocket_chance)
			rocket = new Rocket();
	}

	if (satellites.size() == 0)
	{
		// occasionally launch a new satellite for them
		// if they have lost all of theirs
		if (random(0,1000) < 1)
			satellites.add(new Satellite());
	}

	// draw the delta-v remaining
/*
	if (heal_sound_playing && !healing)
	{
		heal_sound.stop();
		heal_sound_playing = false;
	} else
	if (!heal_sound_playing && healing)
	{
		heal_sound.play();
		heal_sound_playing = true;
	}
*/

	if (healing)
		stroke(0, 255, 0, 255);
	else
	if (ship.delta_v < 100)
		stroke(255, 0, 0, 255);
	else
	if (ship.delta_v < 300)
		stroke(200, 200, 0, 255);
	else
		stroke(100, 100, 255, 255);

	asteroids_write("Delta-V " + str((int) ship.delta_v), 100, 170, 2.0);

	if (healing)
		stroke(0, 255, 0, 255);
	else
	if (ship.health < 10)
		stroke(255, 0, 0, 255);
	else
	if (ship.health < 30)
		stroke(200, 200, 0, 255);
	else
		stroke(100, 100, 255, 255);

	asteroids_write("Shield  " + str((int) ship.health), 100, 200, 2.0);

	stroke(100, 100, 255, 255);
	asteroids_write("SVs     " + str(satellites.size()), 100, 230, 2.0);

	// update asteroid chart
	int count[] = { 0, 0, 0, 0 };
	for (Asteroid a : asteroids)
	{
		int bin = (int)(a.p.radius * 1000 / 20) - 1;
		if (bin < 0) bin = 0;
		if (bin > 3) bin = 3;
		count[bin]++;
	}

	stroke(100, 100, 255, 255);
	stroke(100, 100, 100, 255);
	Asteroid atmp = new Asteroid();
	for(int bin = 0 ; bin < 4 ; bin++)
	{
		asteroids_write(str(count[bin]), width-100, 200 + 40*bin, 2.0);
		pushMatrix();
		translate(width-150, 200 + 40*bin - 20);
		beginShape();
		float path[] = atmp.paths[bin];
		for(int i = 0 ; i < path.length ; i += 2)
			vertex((bin+1) * path[i+0], (bin+1) * path[i+1]);
		endShape();
		popMatrix();
	}

	// check for no asteroids
	if (asteroids.size() == 0)
	{
		pushMatrix();
		stroke(255, 255, 0, 255);
		translate(width/2,height/2,height/2);
		asteroids_write("SUCCESS", -300, 0, 8);
		popMatrix();

		if (success_time == 0)
			success_time = now;
		else
		if (now - success_time > 3000)
		{
			// level up!
			success_time = 0;
			easy = false;
			rocket_chance++;
			minimum_satellite_size *= 0.7;
			starting_asteroids *= 1.5;
			ship.lives++;
			restart();
		}
	}

	ship.update(dt);


	// set the camera to be looking at the planet
	// from off in the X axis.  Our "UP" is in the direction
	// the ship is facing, which is a product of the current
	// velocity vector and our heading relative to it.
	// note that there is an absurd left hand reference frame
	PVector vel_up = ship.p.p.cross(ship.p.v);
	PVector up = vectorRotate(vel_up, ship.p.p, ship.psi);

	// Update the camera position to match the new ship position
	PVector cpos = PVector.mult(ship.p.p, 1.5*radius);
	PVector ccen = PVector.mult(up, -radius/2.5);
	//cpos.sub(ccen);

	camera(
		cpos.x, cpos.y, cpos.z,
		ccen.x, ccen.y, ccen.z,
		up.x, up.y, up.z
	);
	//scale(1,1,-1); // make this right hand

	// draw the planet underneath us,
	// the camera is already in the ship position,
	// so the planet is drawn in ECEF frame
	planet.display(radius);
	ship.display(radius);

	if (attract)
		draw_attract_planet(radius);

	// update the asteroid positions
	for (int i = asteroids.size() - 1; i >= 0; i--)
	{
		Asteroid a = asteroids.get(i);
		a.update(dt);
		a.display(radius);
		if (attract)
			continue;

		if (!ship.collide(a.p, dt, 33))
			continue;

		// this was hit by a bullet or the ship
		asteroids.remove(i);
		//boom_sound.play();


		// split it into a few, but no more than 4
		int new_asteroids = 0;
		for(int j = 0 ; j < 8 && new_asteroids < 4 ; j++)
		{
			float sz = random(1,a.p.radius*1000*.7/4);
			if (sz < minimum_satellite_size)
				continue;

			Asteroid na = new Asteroid(a.p.p, sz);
			na.display(radius);
			asteroids.add(na);
			new_asteroids++;
		}
	}

	// update the satellite positions
	healing = false;
	for (int i = satellites.size() - 1; i >= 0; i--)
	{
		Satellite s = satellites.get(i);
		s.update(dt);
		s.display(radius);
		boolean dead = false;

		// increase ship health if it is around the satellite
		float dist = PVector.sub(s.p.p, ship.p.p).mag();
		if (dist < 0.2)
		{
			if (dist < 0.01) dist = 0.01;

			if (ship.health < 100)
				ship.health += 0.01 / dist;
			ship.delta_v += 0.1 / dist;
			healing = true;
		}

		// check for asteroids wiping out the satellite
		for(Asteroid a : asteroids)
		{
			if (!s.p.collide(a.p, dt))
				continue;

			// this was hit by an asteroid
			s.p.display(radius);
			dead = true;
			break;
		}

		// in non-easy mode we can friendly fire the satellites
		if (!easy)
		for(Bullet b : ship.bullets)
		{
			if (!s.p.collide(b.p, dt))
				continue;

			// this was hit by an bullet
			s.p.display(radius);
			dead = true;
			break;
		}

		if (dead && !attract)
			satellites.remove(i);
	}

	rocket_update();

	popMatrix();
}


void rocket_update()
{
/*
	if (!rocket_sound_playing && rocket != null)
	{
		rocket_sound.loop();
		rocket_sound_playing = true;
	} else
	if (rocket_sound_playing && rocket == null)
	{
		rocket_sound.stop();
		rocket_sound_playing = false;
	}
*/

	if (rocket == null)
		return;


	// if the rocket has expired, delete it
	if (!rocket.update(dt, ship.p.p))
	{
		rocket = null;
		return;
	}

	rocket.display(radius);

	// see if the rocket has been shot down, although it is hard
	for(Bullet b : ship.bullets)
	{
		if (!b.p.collide(rocket.p, dt))
			continue;
		rocket.p.display(radius);
		rocket = null;
		return;
	}


	// if the rocket hits the ship, delete it
	if (ship.collide(rocket.p, dt, attract ? 0 : 100))
	{
		rocket.p.display(radius);
		rocket = null;
		return;
	}
}

/*
	asteroids_write("abcdefghijklm", -300, -150, 3.0);
	asteroids_write("nopqrstuvwxyz", -300, -100, 3.0);
	asteroids_write("`0123456789-=", -300, -50, 3.0);
	asteroids_write("~!@#$%^&*()_+", -300,  0, 3.0);
	asteroids_write("[]\\;',./", -300, 50, 3.0);
	asteroids_write("{}|:\"<>?", -300, 100, 3.0);
*/


// large "SPACEROCKS 2000" cicling the planet
void draw_attract_flat()
{
	pushMatrix();
	translate(width/2,height/2,height/2);

	stroke(255, 255, 255, 255);
	asteroids_write("https://trmm.net/SR2k", -width/5, -height/5+20, 1);

/*
	stroke(100, 0, 0, 200);
	asteroids_write("SpaceRocks", -450, -80, 8.0);
	asteroids_write("2000", -180, 50, 8.0);

	translate(-5,-5,0);
*/
	asteroids_write("SpaceRocks", -270, -80, 4.0);
	asteroids_write("2000", -180, 50, 6.0);

	stroke(255, 0, 0, 100);
	translate(+2,+2,0);
	asteroids_write("SpaceRocks", -270, -80, 4.0);
	asteroids_write("2000", -180, 50, 6.0);

	popMatrix();
}

void draw_attract_planet(float radius)
{
	String title = " Spacerocks 2000  Spacerocks 2000  Spacerocks 2000 ";
	int len = title.length();
	float spacing = 2 * PI / len;


	pushMatrix();
	rotateX(-PI/4);
	rotateZ((millis() % 20000) * 2 * PI / 20000);

	for(int i = 0 ; i < len-1 ; i++)
	{

		// rotate to create the local tangent plane for the lat/lon
		rotateZ(spacing);
		pushMatrix();
		translate(radius+40, 0, 0);
		rotateX(PI/2);
		rotateY(PI/2);

		//float lon = atan2(0, 1);
		//float lat = asin(0);
		//rotateZ(lon);
		//rotateY(-lat);
		//rotateX(angle);
		
		noFill();
		stroke(255,255,255,255);
		asteroids_write(title.substring(i,i+1), -50, -50, 18);
		translate(0,0,-5);
		stroke(0,0,255,255);
		asteroids_write(title.substring(i,i+1), -50, -50, 18);
/*
		translate(0,0,-5);
		stroke(255,0,0,255);
		asteroids_write(title.substring(i,i+1), -50, -50, 18);
*/
		popMatrix();
	}

	popMatrix();
}
