#include <io.h>
#include <glcd.h>
#include <font5x7.h>
#include <delay.h>

#define BTN_START  PINB.0
#define BTN_LEFT   PINB.2
#define BTN_RIGHT  PINB.3

#define LCD_W      84
#define LCD_H      48
#define HUD_H      9
#define BASKET_W   18
#define BASKET_H   5
#define STAR_SIZE  5
#define STEP_X     3
#define MAX_MISS   3
#define SPEED_START_MS 90
#define SPEED_MIN_MS   30

unsigned char basket_x;
unsigned char star_x;
unsigned char star_y;
unsigned char old_basket_x;
unsigned char old_star_x;
unsigned char old_star_y;
unsigned char miss_count;
unsigned char game_over;
unsigned int old_score;
unsigned char old_miss_count;
unsigned int score;
unsigned int tick_seed;
unsigned char game_delay_ms;

void uint_to_str(unsigned int value, char *s)
{
    char temp[6];
    unsigned char i = 0;
    unsigned char j = 0;

    if (value == 0) {
        s[0] = '0';
        s[1] = 0;
        return;
    }

    while (value > 0) {
        temp[i++] = (value % 10) + '0';
        value /= 10;
    }

    while (i > 0) {
        s[j++] = temp[--i];
    }
    s[j] = 0;
}

unsigned char rand_x(void)
{
    tick_seed = tick_seed * 109u + 89u;
    return (unsigned char)(tick_seed % (LCD_W - STAR_SIZE - 2)) + 1;
}

void new_star(void)
{
    star_x = rand_x();
    star_y = HUD_H + 1;
}

void draw_star(unsigned char x, unsigned char y)
{
    glcd_putpixel(x + 2, y, 1);
    glcd_putpixel(x + 1, y + 1, 1);
    glcd_putpixel(x + 2, y + 1, 1);
    glcd_putpixel(x + 3, y + 1, 1);
    glcd_putpixel(x,     y + 2, 1);
    glcd_putpixel(x + 1, y + 2, 1);
    glcd_putpixel(x + 2, y + 2, 1);
    glcd_putpixel(x + 3, y + 2, 1);
    glcd_putpixel(x + 4, y + 2, 1);
    glcd_putpixel(x + 1, y + 3, 1);
    glcd_putpixel(x + 3, y + 3, 1);
    glcd_putpixel(x,     y + 4, 1);
    glcd_putpixel(x + 4, y + 4, 1);
}

void clear_star(unsigned char x, unsigned char y)
{
    unsigned char i;
    unsigned char j;

    for (i = 0; i < STAR_SIZE; i++) {
        for (j = 0; j < STAR_SIZE; j++) {
            glcd_putpixel(x + i, y + j, 0);
        }
    }
}

void clear_rect(unsigned char left, unsigned char top, unsigned char right, unsigned char bottom)
{
    unsigned char x;
    unsigned char y;

    for (x = left; x <= right; x++) {
        for (y = top; y <= bottom; y++) {
            glcd_putpixel(x, y, 0);
        }
    }
}

void draw_basket(unsigned char x)
{
    unsigned char y = LCD_H - BASKET_H;

    glcd_setcolor(1);
    glcd_line(x, y, x + 3, LCD_H - 1);
    glcd_line(x + BASKET_W, y, x + BASKET_W - 3, LCD_H - 1);
    glcd_line(x + 3, LCD_H - 1, x + BASKET_W - 3, LCD_H - 1);
    glcd_line(x + 2, y + 2, x + BASKET_W - 2, y + 2);
}

void clear_basket(unsigned char x)
{
    unsigned char y = LCD_H - BASKET_H;

    glcd_setcolor(0);
    glcd_line(x, y, x + 3, LCD_H - 1);
    glcd_line(x + BASKET_W, y, x + BASKET_W - 3, LCD_H - 1);
    glcd_line(x + 3, LCD_H - 1, x + BASKET_W - 3, LCD_H - 1);
    glcd_line(x + 2, y + 2, x + BASKET_W - 2, y + 2);
    glcd_setcolor(1);
}

void draw_hud(void)
{
    char buf[6];

    clear_rect(0, 0, LCD_W - 1, HUD_H);
    glcd_setcolor(1);
    glcd_outtextxy(0, 0, "Diem:");
    uint_to_str(score, buf);
    glcd_outtextxy(34, 0, buf);
    glcd_outtextxy(58, 0, "L:");
    glcd_putchar((MAX_MISS - miss_count) + '0');
    glcd_line(0, HUD_H, LCD_W - 1, HUD_H);
}

void draw_screen(void)
{
    if ((old_score != score) || (old_miss_count != miss_count)) {
        draw_hud();
        old_score = score;
        old_miss_count = miss_count;
    }

    clear_star(old_star_x, old_star_y);
    clear_basket(old_basket_x);
    draw_star(star_x, star_y);
    draw_basket(basket_x);

    old_star_x = star_x;
    old_star_y = star_y;
    old_basket_x = basket_x;
}

void read_buttons(void)
{
    if (BTN_LEFT == 0) {
        delay_ms(12);
        if (BTN_LEFT == 0) {
            if (basket_x > STEP_X) {
                basket_x -= STEP_X;
            } else {
                basket_x = 0;
            }
            tick_seed += 17;
        }
    }

    if (BTN_RIGHT == 0) {
        delay_ms(12);
        if (BTN_RIGHT == 0) {
            if (basket_x < LCD_W - BASKET_W - STEP_X - 1) {
                basket_x += STEP_X;
            } else {
                basket_x = LCD_W - BASKET_W - 1;
            }
            tick_seed += 31;
        }
    }
}

void update_star(void)
{
    if (star_y < LCD_H - STAR_SIZE - 1) {
        star_y++;
        return;
    }

    if ((star_x + STAR_SIZE >= basket_x) && (star_x <= basket_x + BASKET_W)) {
        score++;
        new_star();
        return;
    }

    if (miss_count < MAX_MISS) {
        miss_count++;
    }

    if (miss_count >= MAX_MISS) {
        game_over = 1;
    } else {
        new_star();
    }
}

void update_speed(void)
{
    if (score < 5) {
        game_delay_ms = 90;
    } else if (score < 10) {
        game_delay_ms = 75;
    } else if (score < 15) {
        game_delay_ms = 60;
    } else if (score < 25) {
        game_delay_ms = 45;
    } else {
        game_delay_ms = SPEED_MIN_MS;
    }
}

void reset_game(void)
{
    basket_x = (LCD_W - BASKET_W) / 2;
    old_basket_x = basket_x;
    score = 0;
    miss_count = 0;
    game_over = 0;
    game_delay_ms = SPEED_START_MS;
    new_star();
    old_star_x = star_x;
    old_star_y = star_y;
    old_score = 65535u;
    old_miss_count = 255;
    glcd_clear();
    draw_hud();
    draw_star(star_x, star_y);
    draw_basket(basket_x);
}

void wait_bt3_press(void)
{
    while (BTN_START != 0) {
        tick_seed++;
        delay_ms(5);
    }
    delay_ms(150);
    while (BTN_START == 0);
    delay_ms(80);
}

void show_start(void)
{
    glcd_clear();
    glcd_outtextxy(9, 4, "HUNG SAO");
    glcd_outtextxy(0, 18, "BT1: Trai");
    glcd_outtextxy(0, 28, "BT2: Phai");
    glcd_outtextxy(0, 40, "BT3: Start");

    wait_bt3_press();
}

void show_game_over(void)
{
    char buf[6];

    glcd_clear();
    glcd_outtextxy(15, 5, "THUA CUOC");
    glcd_outtextxy(8, 18, "Diem:");
    uint_to_str(score, buf);
    glcd_outtextxy(44, 18, buf);
    glcd_outtextxy(0, 36, "BT3: Choi lai");

    wait_bt3_press();
}

void main(void)
{
    GLCDINIT_t glcd_init_data;

    DDRD = 0x80;
    PORTD = 0x80;

    DDRB = 0x00;
    PORTB = 0x0D;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 80;
    glcd_init_data.bias = 3;
    glcd_init_data.vlcd = 55;
    glcd_init(&glcd_init_data);

    tick_seed = 1234;
    show_start();

    while (1) {
        reset_game();

        while (game_over == 0) {
            tick_seed++;
            read_buttons();
            update_star();
            update_speed();
            draw_screen();
            delay_ms(game_delay_ms);
        }

        show_game_over();
    }
}
