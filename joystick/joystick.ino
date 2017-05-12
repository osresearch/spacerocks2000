/** \file
 * Spacerocks 2k joystick interface.
 *
 * This arduino teensy sketch interfaces with a four-way joystick
 * and two buttons.
 */

#define JOY_U	1
#define JOY_D	3
#define JOY_L	2
#define JOY_R	0

#define BUTTON_0 4
#define BUTTON_1 5

#define BUTTON_0_LED 10
#define BUTTON_1_LED 9
#define JOY_LED	12

unsigned int joy_pwm;
unsigned int button_0_pwm;
unsigned int button_1_pwm;

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

	pinMode(BUTTON_0_LED, OUTPUT);
	analogWrite(BUTTON_0_LED, 0);

	pinMode(BUTTON_1_LED, OUTPUT);
	analogWrite(BUTTON_1_LED, 0);

	Serial.begin(9600);

	joy_pwm = button_0_pwm = button_1_pwm = 0;
}

void loop()
{
	int u = !digitalRead(JOY_U);
	int d = !digitalRead(JOY_D);
	int l = !digitalRead(JOY_L);
	int r = !digitalRead(JOY_R);
	int button_0 = !digitalRead(BUTTON_0);
	int button_1 = !digitalRead(BUTTON_1);

	if (joy_pwm >= 256)
		analogWrite(JOY_LED, 512 - joy_pwm);
	else
		analogWrite(JOY_LED, joy_pwm);
	joy_pwm = (joy_pwm + 1) % 512;

	if (button_0)
		button_0_pwm = 0;
	if (button_0_pwm != 255)
	{
		button_0_pwm++;
		analogWrite(BUTTON_0_LED, button_0_pwm);
	}

	if (button_1)
		button_1_pwm = 0;
	if (button_1_pwm != 255)
	{
		button_1_pwm++;
		analogWrite(BUTTON_1_LED, button_1_pwm);
	}

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

	Keyboard.set_key3(button_0 ? KEY_SPACE : 0);
	Keyboard.set_key4(button_1 ? KEY_Z : 0);
	Keyboard.send_now();

	if (0)
	{
	Serial.print(!u ? " " : "U");
	Serial.print(!d ? " " : "D");
	Serial.print(!l ? " " : "L");
	Serial.print(!r ? " " : "R");
	Serial.print(!button_0 ? " " : "0");
	Serial.print(!button_1 ? " " : "1");
	Serial.println();
	}

	//delay(10);
}
