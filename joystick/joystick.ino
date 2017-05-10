/** \file
 * Spacerocks 2k joystick interface.
 *
 * This arduino teensy sketch interfaces with a four-way joystick
 * and two buttons.
 */

#define JOY_U	0
#define JOY_D	2
#define JOY_L	1
#define JOY_R	3

#define BUTTON_0 4
#define BUTTON_1 5

#define JOY_LED	10
unsigned int joy_pwm;

void setup()
{
	pinMode(JOY_U, INPUT_PULLUP);
	pinMode(JOY_D, INPUT_PULLUP);
	pinMode(JOY_L, INPUT_PULLUP);
	pinMode(JOY_R, INPUT_PULLUP);
	pinMode(BUTTON_0, INPUT_PULLUP);
	pinMode(BUTTON_1, INPUT_PULLUP);

	pinMode(JOY_LED, OUTPUT);
	analogWrite(JOY_LED, 0);

	Serial.begin(9600);
}

void loop()
{
	int u = !digitalRead(JOY_U);
	int d = !digitalRead(JOY_D);
	int l = !digitalRead(JOY_L);
	int r = !digitalRead(JOY_R);
	int button0 = !digitalRead(BUTTON_0);
	int button1 = !digitalRead(BUTTON_1);

	if (joy_pwm >= 256)
		analogWrite(JOY_LED, 512 - joy_pwm);
	else
		analogWrite(JOY_LED, joy_pwm);
	joy_pwm = (joy_pwm + 1) % 512;

	if (u)
		Keyboard.set_key1(KEY_UP);
	else
	if (d)
		Keyboard.set_key1(KEY_DOWN);
	else
		Keyboard.set_key1(0);

	if (l)
		Keyboard.set_key2(KEY_LEFT);
	else
	if (r)
		Keyboard.set_key2(KEY_RIGHT);
	else
		Keyboard.set_key2(0);

	Keyboard.set_key3(button0 ? KEY_SPACE : 0);
	Keyboard.set_key4(button1 ? KEY_Z : 0);
	Keyboard.send_now();

	Serial.print(u ? " " : "U");
	Serial.print(d ? " " : "D");
	Serial.print(l ? " " : "L");
	Serial.print(r ? " " : "R");
	Serial.print(button0 ? " " : "0");
	Serial.print(button1 ? " " : "1");
	Serial.println();

	delay(10);
}
