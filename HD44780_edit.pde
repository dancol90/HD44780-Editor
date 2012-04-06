/**************************************************************************
 *                    HD44780 Custom Character Editor                     *
 *                   Copyright 2012 Daniele Colanardi.                    *
 *                     dancol90 (at) gmail (dot) com                      *
 *                                                                        *
 *  This program is free software: you can redistribute it and/or modify  *
 *  it under the terms of the GNU General Public License as published by  *
 *  the Free Software Foundation, either version 3 of the License, or     *
 *  (at your option) any later version.                                   *
 *                                                                        *
 *  This program is distributed in the hope that it will be useful,       *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *  GNU General Public License for more details.                          *
 *                                                                        *
 *  You should have received a copy of the GNU General Public License     *
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. *
 **************************************************************************/

static final String program_version = "v1.1.7";

/*********************************************************
    POSITIONS and DIMENSIONS
 *********************************************************/ 

static final int lcd_pos[] = {15, 20}; // Left & top position of lcd preview
static final int lcd_scale  = 3;       // Scale of lcd preview characters (3 times 5x7 pixel)
static final int[] lcd_char_dim = {5 * lcd_scale + 1, 8 * lcd_scale + 1};  // CALCULATED. Width & height of a single lcd char 
static final int[] lcd_size = {20 * lcd_char_dim[0], 4 * lcd_char_dim[1]}; // CALCULATED. Width & height of lcd preview.

static final int custom_chars_pos[] = {10, 140}; // Position of custom chars thumbnails
static final int custom_chars_scale  = 5;        // Scale of custom chars thumbnail
static final int[] custom_char_dim   = {5 * custom_chars_scale + 1, 8 * custom_chars_scale + 1}; // CALCULATED. Width & height of a single thumbnail
static final int[] custom_chars_size = {4 * custom_char_dim[0], 2 * custom_char_dim[1]};         // CALCULATED. Width & height of all thumbnail

static final int char_table_pos[] = {10, 330}; // Position
static final int char_table_scale  = 2;        // Scale
static final int[] char_table_char_dim   = {5 * char_table_scale + 1, 8 * char_table_scale + 1}; // CALCULATED. Width & height of a single
static final int[] char_table_size = {32 * char_table_char_dim[0], 6 * char_table_char_dim[1]};  // CALCULATED. Width & height of all

static final int edit_char_pos[] = {150, 140}; // Position of editing area
static final int edit_char_scale = 20;         // Scale of editing area

/*int[][] chrtbl = {
    {  0,  0,  0,  0,  0,  0,  0 }, // 0 - 32 
    // The first 32 character are empty, do not repeat
    {  4,  4,  4,  4,  4,  0,  4 }, // 33
    { 10, 10, 10,  0,  0,  0,  0 }, // 34
    { 10, 10, 31, 10, 31, 10, 10 }, // 35
    {  4, 15, 20, 14,  5, 30,  4 }, // 36
    { 24, 25,  2,  4,  8, 19,  3 }, // 37
    { 12, 18, 20,  8, 21, 18, 13 }, // 38
    { 12,  4,  8,  0,  0,  0,  0 }, // 39
    {  2,  4,  8,  8,  8,  4,  2 }, // 40
    {  8,  4,  2,  2,  2,  4,  8 }, // 41
    {  0,  4, 21, 14, 21,  4,  0 }, // 42
    {  0,  4,  4, 31,  4,  4,  0 }, // 43
    {  0,  0,  0,  0, 12,  4,  8 }, // 44
    {  0,  0,  0, 31,  0,  0,  0 }, // 45
    {  0,  0,  0,  0,  0, 12, 12 }, // 46
    {  0,  1,  2,  4,  8, 16,  0 }, // 47
    { 14, 17, 19, 21, 25, 17, 14 }, // 48
    {  4, 12,  4,  4,  4,  4, 14 }, // 49
    { 14, 17,  1,  2,  4,  8, 31 }, // 50
    { 31,  2,  4,  2,  1, 17, 14 }, // 51
    {  2,  6, 10, 18, 31,  2,  2 }, // 52
    { 31, 16, 30,  1,  1, 17, 14 }, // 53
    {  6,  8, 16, 30, 17, 17, 14 }, // 54
    { 31,  1,  2,  4,  8,  8,  8 }, // 55
    { 14, 17, 17, 14, 17, 17, 14 }, // 56
    { 14, 17, 17, 15,  1,  2, 12 }, // 57
    {  0, 12, 12,  0, 12, 12,  0 }, // 58
    {  0, 12, 12,  0, 12,  4,  8 }, // 59
    {  2,  4,  8, 16,  8,  4,  2 }, // 60
    {  0,  0, 31,  0, 31,  0,  0 }, // 61
    { 16,  8,  4,  2,  4,  8, 16 }, // 62
    { 14, 17,  1,  2,  4,  0,  4 }, // 63
    { 14, 17,  1, 13, 21, 21, 14 }, // 64
    { 14, 17, 17, 17, 31, 17, 17 }, // 65
    { 30, 17, 17, 30, 17, 17, 30 }, // 66
    { 14, 17, 16, 16, 16, 17, 14 }, // 67
    { 30, 17, 17, 17, 17, 17, 30 }, // 68
    { 31, 16, 16, 30, 16, 16, 31 }, // 69
    { 31, 16, 16, 30, 16, 16, 16 }, // 70
    { 14, 17, 16, 23, 17, 17, 15 }, // 71
    { 17, 17, 17, 31, 17, 17, 17 }, // 72
    { 14,  4,  4,  4,  4,  4, 14 }, // 73
    {  7,  2,  2,  2,  2, 18, 12 }, // 74
    { 17, 18, 20, 24, 20, 18, 17 }, // 75
    { 16, 16, 16, 16, 16, 16, 31 }, // 76
    { 17, 27, 21, 21, 17, 17, 17 }, // 77
    { 17, 17, 25, 21, 19, 17, 17 }, // 78
    { 14, 17, 17, 17, 17, 17, 14 }, // 79
    { 30, 17, 17, 30, 16, 16, 16 }, // 80
    { 14, 17, 17, 17, 21, 18, 13 }, // 81
    { 30, 17, 17, 30, 20, 18, 17 }, // 82
    { 15, 16, 16, 14,  1,  1, 30 }, // 83
    { 31,  4,  4,  4,  4,  4,  4 }, // 84
    { 17, 17, 17, 17, 17, 17, 14 }, // 85
    { 17, 17, 17, 17, 17, 10,  4 }, // 86
    { 17, 17, 17, 21, 21, 21, 10 }, // 87
    { 17, 17, 10,  4, 10, 17, 17 }, // 88
    { 17, 17, 17, 10,  4,  4,  4 }, // 89
    { 31,  1,  2,  4,  8, 16, 31 }, // 90
    { 14,  8,  8,  8,  8,  8, 14 }, // 91
    { 17, 10, 31,  4, 31,  4,  4 }, // 92
    { 14,  2,  2,  2,  2,  2, 14 }, // 93
    {  4, 10, 17,  0,  0,  0,  0 }, // 94
    {  0,  0,  0,  0,  0,  0, 31 }, // 95
    {  8,  4,  2,  0,  0,  0,  0 }, // 96
    {  0,  0, 14,  1, 15, 17, 15 }, // 97
    { 16, 16, 22, 25, 17, 17, 30 }, // 98
    {  0,  0, 14, 16, 16, 17, 14 }, // 99
    {  1,  1, 13, 19, 17, 17, 15 }, // 100
    {  0,  0, 14, 17, 31, 16, 14 }, // 101
    {  6,  9,  8, 28,  8,  8,  8 }, // 102
    {  0,  0, 15, 17, 15,  1, 14 }, // 103
    { 16, 16, 22, 25, 17, 17, 17 }, // 104
    {  4,  0, 12,  4,  4,  4, 14 }, // 105
    {  2,  6,  2,  2,  2, 18, 12 }, // 106
    { 16, 16, 18, 20, 24, 20, 18 }, // 107
    { 12,  4,  4,  4,  4,  4, 14 }, // 108
    {  0,  0, 26, 21, 21, 17, 17 }, // 109
    {  0,  0, 22, 25, 17, 17, 17 }, // 110
    {  0,  0, 14, 17, 17, 17, 14 }, // 111
    {  0,  0, 30, 17, 30, 16, 16 }, // 112
    {  0,  0, 13, 19, 15,  1,  1 }, // 113
    {  0,  0, 22, 25, 16, 16, 16 }, // 114
    {  0,  0, 15, 16, 14,  1, 30 }, // 115
    {  8,  8, 28,  8,  8,  9,  6 }, // 116
    {  0,  0, 17, 17, 17, 19, 13 }, // 117
    {  0,  0, 17, 17, 17, 10,  4 }, // 118
    {  0,  0, 17, 17, 21, 21, 10 }, // 119
    {  0,  0, 17, 10,  4, 10, 17 }, // 120
    {  0,  0, 17, 17, 15,  1, 14 }, // 121
    {  0,  0, 31,  2,  4,  8, 31 }, // 122
    {  2,  4,  4,  8,  4,  4,  2 }, // 123
    {  4,  4,  4,  4,  4,  4,  4 }, // 124
    {  8,  4,  4,  2,  4,  4,  8 }, // 125
    {  0,  4,  2, 31,  2,  4,  0 }, // 126
    {  0,  4,  8, 31,  8,  4,  0 }, // 127
    {  0,  0,  0,  0,  0,  0,  0 }, // 128 - 160
    {  0,  0,  0,  0, 28, 20, 28 }, // 161
    {  7,  4,  4,  4,  0,  0,  0 }, // 162
    {  0,  0,  0,  4,  4,  4, 28 }, // 163
    {  0,  0,  0,  0, 16,  8,  4 }, // 164
    {  0,  0,  0, 12, 12,  0,  0 }, // 165
    {  0, 31,  1, 31,  1,  2,  4 }, // 166
    {  0,  0, 31,  1,  6,  4,  8 }, // 167
    {  0,  0,  2,  4, 12, 20,  4 }, // 168
    {  0,  0,  4, 31, 17,  1,  6 }, // 169
    {  0,  0,  0, 31,  4,  4, 31 }, // 170
    {  0,  0,  2, 31,  6, 10, 18 }, // 171
    {  0,  0,  8, 31,  9, 10,  8 }, // 172
    {  0,  0,  0, 14,  2,  2, 31 }, // 173
    {  0,  0, 30,  2, 30,  2, 30 }, // 174
    {  0,  0,  0, 21, 21,  1,  6 }, // 175
    {  0,  0,  0,  0, 31,  0,  0 }, // 176
    { 31,  1,  5,  6,  4,  4,  8 }, // 177
    {  1,  2,  4, 12, 20,  4,  4 }, // 178
    {  4, 31, 17, 17,  1,  2,  4 }, // 179
    {  0,  0, 31,  4,  4,  4, 31 }, // 180
    {  2, 31,  2,  6, 10, 18,  2 }, // 181
    {  8, 31,  9,  9,  9,  9, 18 }, // 182
    {  4, 31,  4, 31,  4,  4,  4 }, // 183
    {  0, 15,  9, 17,  1,  2, 12 }, // 184
    {  8, 15, 18,  2,  2,  2,  4 }, // 185
    {  0, 31,  1,  1,  1,  1, 31 }, // 186
    { 10, 31, 10, 10,  2,  4,  8 }, // 187
    {  0, 24,  1, 25,  1,  2, 28 }, // 188
    {  0, 31,  1,  2,  4, 10, 17 }, // 189
    {  8, 31,  9, 10,  8,  8,  7 }, // 190
    {  0, 17, 17,  9,  1,  2, 12 }, // 191
    {  0, 15,  9, 21,  3,  2, 12 }, // 192
    {  2, 28,  4, 31,  4,  4,  8 }, // 193
    {  0, 21, 21,  1,  1,  2,  4 }, // 194
    { 14,  0, 31,  4,  4,  4,  8 }, // 195
    {  8,  8,  8, 12, 10,  8,  8 }, // 196
    {  4,  4, 31,  4,  4,  8, 16 }, // 197
    {  0, 14,  0,  0,  0,  0, 31 }, // 198
    {  0, 31,  1, 10,  4, 10, 16 }, // 199
    {  4, 31,  2,  4, 14, 21,  4 }, // 200
    {  2,  2,  2,  2,  2,  4,  8 }, // 201
    {  0,  4,  2, 17, 17, 17, 17 }, // 202
    { 16, 16, 31, 16, 16, 16, 15 }, // 203
    {  0, 31,  1,  1,  1,  2, 12 }, // 204
    {  0,  8, 20,  2,  1,  1,  0 }, // 205
    {  4, 31,  4,  4, 21, 21,  4 }, // 206
    {  0, 31,  1,  1, 10,  4,  2 }, // 207
    {  0, 14,  0, 14,  0, 14,  1 }, // 208
    {  0,  4,  8, 16, 17, 31,  1 }, // 209
    {  0,  1,  1, 10,  4, 10, 16 }, // 210
    {  0, 31,  8, 31,  8,  8,  7 }, // 211
    {  8,  8, 31,  9, 10,  8,  8 }, // 212
    {  0, 14,  2,  2,  2,  2, 31 }, // 213
    {  0, 31,  1, 31,  1,  1, 31 }, // 214
    { 14,  0, 31,  1,  1,  2,  4 }, // 215
    { 18, 18, 18, 18,  2,  4,  8 }, // 216
    {  0,  4, 20, 20, 21, 21, 22 }, // 217
    {  0, 16, 16, 17, 18, 20, 24 }, // 218
    {  0, 31, 17, 17, 17, 17, 31 }, // 219
    {  0, 31, 17, 17,  1,  2,  4 }, // 220
    {  0, 24,  0,  1,  1,  2, 28 }, // 221
    {  4, 18,  8,  0,  0,  0,  0 }, // 222
    { 28, 20, 28,  0,  0,  0,  0 }, // 223
    {  0,  0,  9, 21, 18, 18, 13 }, // 224
    { 10,  0, 14,  1, 15, 17, 15 }, // 225
    {  0, 14, 17, 30, 17, 30, 16 }, // 226
    {  0,  0, 14, 16, 12, 17, 14 }, // 227
    {  0, 17, 17, 17, 19, 29, 16 }, // 228
    {  0,  0, 15, 20, 18, 17, 14 }, // 229
    {  0,  6,  9, 17, 17, 30, 16 }, // 230
    {  0, 15, 17, 17, 17, 15,  1 }, // 231
    {  0,  0,  7,  4,  4, 20,  8 }, // 232
    {  2, 26,  2,  0,  0,  0,  0 }, // 233
    {  2,  0,  6,  2,  2,  2,  2 }, // 234
    {  0, 20,  8, 20,  0,  0,  0 }, // 235
    {  4, 14, 20, 21, 14,  4,  0 }, // 236
    {  8,  8, 28,  8, 28,  8, 15 }, // 237
    { 14,  0, 22, 25, 17, 17, 17 }, // 238
    { 10,  0, 14, 17, 17, 17, 14 }, // 239
    {  0, 22, 25, 17, 17, 30, 16 }, // 240
    {  0, 13, 19, 17, 17, 15,  1 }, // 241
    { 14, 17, 31, 17, 17, 14,  0 }, // 242
    {  0,  0,  0,  0, 11, 21, 26 }, // 243
    {  0, 14, 17, 17, 10, 27,  0 }, // 244
    { 10,  0, 17, 17, 17, 19, 13 }, // 245
    { 31, 16,  8,  4,  8, 16, 31 }, // 246
    {  0, 31, 10, 10, 10, 19,  0 }, // 247
    { 31,  0, 17, 10,  4, 10, 17 }, // 248
    {  0, 17, 17, 17, 17, 15,  1 }, // 249
    {  1, 30,  4, 31,  4,  4,  0 }, // 250
    {  0, 31,  8, 15,  9, 17,  0 }, // 251
    {  0, 31, 21, 31, 17, 17,  0 }, // 252
    {  0,  0,  4,  0, 31,  0,  4 }, // 253
    {  0,  0,  0,  0,  0,  0,  0 }, // 254
    { 31, 31, 31, 31, 31, 31, 31 }  // 255
};*/

// 20x4 Matrix for lcd preview
int     lcd_matrix[][][];
// 8x custom char. Each one has 5x7 pixels.
boolean custom_char[][][];

int current_lcd_preview = 0;
// Selected char to be edited.
int current_custom_char = 1;
// Currently mouse dragged char. -1 means no dragging activity.
int current_dragging_char = -1;
// Last modified point in 5x7 char matrix. Needed for "click&drag" drawing.
int last_edit_pos[] = {-1, -1};

// Export to C code requested? 
// Using the flag because calling file dialogs in event thread throws an exception (now selectOutput() runs in draw())
boolean do_export = false;

boolean do_open = false;
boolean do_save = false;

// State of Reset All button. To reset, press twice. This flag monitor at which click we are.
boolean sure_about_reset = false;
boolean sure_about_clear_preview = false;

/*********************************************************
    SETUP
 *********************************************************/ 

// Init preview and custom chars arrays 
void initArrays() {
  custom_char = new boolean[9][5][8];
  lcd_matrix  = new int[5][20][4];
}

// Entrypoint of the sketch
void setup() {
  frame.setTitle("HD44780 Custom Character Editor " + program_version);
  
  size(lcd_size[0] + 50, 325 /*+ 130*/);
  
  // Let's call draw() only when needed.
  noLoop();
  
  // Set custom font.
  PFont font;
  font = loadFont("Ubuntu-12.vlw"); 
  textFont(font, 12);
  // Reduce space between lines
  textLeading(14);
  
  noStroke();
  
  // Now we can init data.
  initArrays();
  
  // Draw all for the first time.
  draw();
}

/*********************************************************
    SCREEN UPDATE METHODS
 *********************************************************/ 

void draw() {
  // Clear all.
  background(#202020);
  
 /* --- Common dialogs operations --- */ 
  
  if(do_export) export();
  if(do_open)   openFile();
  if(do_save)   saveFile();
  
  /* --- LCD Preview area --- */
  
  fill(#ffffff);
  text("LCD Preview", lcd_pos[0], lcd_pos[1] - 5);
  
  // For each row...
  for(int r = 0; r < 4; r++) {
    // ...and for each column...
    for(int c = 0; c < 20; c++) {
      // ...draw the char.
      drawChar(lcd_pos[0] + c * lcd_char_dim[0], lcd_pos[1] + r * lcd_char_dim[1], 
               lcd_scale,
               custom_char[lcd_matrix[current_lcd_preview][c][r]]);
    }
  }
  
  drawButton(width - 10 - 20, 40, 20, 20, ">");
  drawButton(width - 10 - 20, 80, 20, 20, "<");
  
  text(current_lcd_preview + 1 + "/5", width - 10 - 20, 75);
  
  /* --- Custom chars area --- */
  
  //fill(#ffffff);
  text("Custom charaters", custom_chars_pos[0], custom_chars_pos[1] - 5);
  
  int i, x, y;
  
  for(int r = 0; r < 2; r++) {
    for(int c = 0; c < 4; c++) {
      i = r * 4 + c + 1;
      
      // Determine left & top position of the single current char. 
      x = custom_chars_pos[0] + c * custom_char_dim[0];
      y = custom_chars_pos[1] + r * custom_char_dim[1];
      
      // Draw a border around the char if it's the currently selected.
      if(i == current_custom_char) {
        pushStyle();
        
        stroke(#ffffff, 150);
        noFill();
        
        rect(x - 1, y - 1, custom_char_dim[0] - 1, custom_char_dim[1] - 1);
        
        popStyle();
      }
      
      // Draw the char thumbnails itself.
      drawChar(x, y, custom_chars_scale, custom_char[i]);
    }
  }

  /* --- Char edit area --- */

  text("Edit character", edit_char_pos[0], edit_char_pos[1] - 5);
    
  drawChar(edit_char_pos[0], edit_char_pos[1], edit_char_scale, custom_char[current_custom_char]);
  
  /* --- Standard character table --- */
  
  /*
  text("HD44780 standard characters", char_table_pos[0], char_table_pos[1] - 5);
  
  for(i = 0; i < chrtbl.length; i++) {
    drawChar(char_table_pos[0] + (i % 32) * char_table_char_dim[0], char_table_pos[1] + (i / 32) * char_table_char_dim[1], char_table_scale, getCharFromTable(i));
  }
  */
  
  /* --- Quick help --- */
  
  text("Drag chars above \nin LCD preview \nto place them.\nRight click to delete.", 10, 245);
  
  /* --- Drag shadow --- */
  
  // If dragging a char...
  if(current_dragging_char != -1 && !mouseInRect(custom_chars_pos, custom_chars_size))
    // ...draw it under the mouse pointer. 
    drawChar(mouseX - lcd_char_dim[0] / 2, mouseY - lcd_char_dim[1] / 2, lcd_scale, custom_char[current_custom_char]);  
  
  /* --- Buttons area --- */
  
  // Draw a border around buttons area.
  stroke(#ffffff); noFill();
  rect(width - 10 - 83, 140, 100, 145);
  noStroke();
  
  // Draw actual buttons.
  drawButton(width - 10 - 75, 145, 75, 20, "Open", #6680B7);
  drawButton(width - 10 - 75, 170, 75, 20, "Save", #6680B7);
  drawButton(width - 10 - 75, 195, 75, 20, "Export");
  
  // Here caption is different if we have alredy clicked once the button.
  drawButton(width - 10 - 75, 235, 75, 20, sure_about_clear_preview ? "Are you sure?" : "Clear preview", #FF6262);
  drawButton(width - 10 - 75, 260, 75, 20, sure_about_reset ? "Are you sure?" : "Reset all", #FF6262);
  
  /* --- Footer --- */
  pushStyle();

  fill(#aaaaaa, 50);
  textAlign(RIGHT, BOTTOM);
  
  text(program_version + " ©Daniele Colanardi 2012", width - 5, height - 5);
  
  // Restore text align
  popStyle();
}


/*int getCharTableIndex(char c) {
  int i = (int)c;
  
  if(i >= 0 && i <= 32) return 0;
  
  if(i >= 33 && i <= 127) return i - 32;
  
  if(i >= 128 && i <= 160) return 96;
  
  return i - 64;  
}

boolean[][] getCharFromTable(int i) {
  boolean tmpChar[][] = new boolean[5][8];
  
  for(int y = 0; y < 7; y++) 
      for(int x = 0; x < 5; x++)
        tmpChar[x][y] = ( chrtbl[i][y] & (1 << (4-x)) ) != 0;
  
  return tmpChar;
}
*/

// Draw a char at given position, with given scale. (scale = 1 : 5x7 pixel, scale = 2 : 10x14, and so on)
void drawChar(int xPos, int yPos, int charScale, boolean[][] charData) {
  pushStyle();
  
  noStroke();
  
  // For each row...
  for(int y = 0; y < 8; y++) {
    // ...and for each pixel in that row...
    for(int x = 0; x < 5; x++) {
      // ...draw on/off pixel.
      fill(charData[x][y] ? #ffffff : #477EF2);
      
      rect(xPos + x * charScale, yPos + y * charScale, charScale - 1, charScale - 1);
    }
  }
  
  popStyle();
}

// Draw a button at given pos, with given size and text.
void drawButton(int x, int y, int w, int h, String caption) { drawButton(x, y, w, h, caption, -1); }
void drawButton(int x, int y, int w, int h, String caption, color backColor) {
  pushStyle();
  
  fill(backColor != -1 ? backColor : #477EF2);
  textAlign(CENTER, CENTER);
  
  // Background rect.
  rect(x, y, w, h);

  fill(#ffffff);
  
  // Caption text in the middle
  text(caption, x + w / 2, y + h / 2);
  
  // Restore style
  popStyle();
}

/*********************************************************
    EVENTS
 *********************************************************/ 

// Mouse click event handler
void mousePressed() {
  // Check for clicks in thumbnail area.
  checkCharsClick();
  
  // Check for clicks in edit area
  checkPointEdit();
  
  // Check for clicks in lcd preview area.
  checkLcdClick();
  
  // Check for clicks in buttons
  if(checkButtonClick(40, 20)) {
    current_lcd_preview++;
    
    if(current_lcd_preview == 5) current_lcd_preview = 0;
  } else if(checkButtonClick(80, 20)){
    current_lcd_preview--;
    
    if(current_lcd_preview == -1) current_lcd_preview = 4;
  } else if(checkButtonClick(195))
    // Export button clicked.
    do_export = true;
  else if(checkButtonClick(170))
    // Save button clicked.
    do_save = true;
  else if(checkButtonClick(145))
    // Open button clicked.
    do_open = true;
  else if(checkButtonClick(235)) {
    // Clear prview button clicked.
    
    // flag is true if we had already clicked the button once.
    if(sure_about_clear_preview) {
      // So the user is sure. Farewall, current preview!
      lcd_matrix[current_lcd_preview] = new int[20][4];
      
      // Reset flag. We are ready to restart.
      sure_about_clear_preview = false;
    } else
      // This was the first click, wait for another one.
      sure_about_clear_preview = true;
    
  } else if(checkButtonClick(260)) {
    // Reset All button clicked.
    
    // flag is true if we had already clicked the button once.
    if(sure_about_reset) {
      // So the user is sure. Farewall, current data!
      initArrays();
      
      // Reset flag. We are ready to restart.
      sure_about_reset = false;
    } else
      // This was the first click, wait for another one.
      sure_about_reset = true;
    
  } else {
    // Clicked elsewhere, restart. 
    sure_about_reset = false;
    sure_about_clear_preview = false;
  }
  
  redraw();
}

// Mouse dragged event handler
void mouseDragged() {
  // Redraw needed only if we are dragging a char to preview, to draw its shadow.
  if(current_dragging_char != -1)
    redraw();
  else // We are not dragging anything.
    // Check if mouse is in edit area, and draw.
    checkPointEdit();
  
}

// Mouse button released event handler.
void mouseReleased() {
  // Reset last edited pixel
  last_edit_pos[0] = -1;
  last_edit_pos[1] = -1;
  
  // If we were dragging a char...
  if(current_dragging_char != -1) {
    // ...and we are now in lcd preview area...    
    if(mouseInRect(lcd_pos, lcd_size) && mouseButton == LEFT) {
      // ...set that lcd char.
      
      // Determine which char in lcd preview we are on.
      int x = mouseX - lcd_pos[0];
      int y = mouseY - lcd_pos[1];
      
      x = floor(x / lcd_char_dim[0]);
      y = floor(y / lcd_char_dim[1]);
      
      // Set it to the dragged char's index.
      lcd_matrix[current_lcd_preview][x][y] = current_dragging_char;
    }
    
    // Reset dragging flag
    current_dragging_char = -1;
    
    // Update the screen.
    redraw();
  }
}

// Check if mouse is in edit area.
void checkPointEdit() {
  // If mouse is in edit area and the left button is pressed...
  if(mouseInRect(edit_char_pos, edit_char_scale) && mouseButton == LEFT) {
    // ...draw on the pixel we are on!
    
    // Determine which pixel we are on...
    int x = mouseX - edit_char_pos[0];
    int y = mouseY - edit_char_pos[1];
    
    x = floor(x / edit_char_scale);
    y = floor(y / edit_char_scale);
    
    // ...and if it's different from the last one...
    // NOTE: this is needed when we drag the mouse. Do the drawing stuff only if the mouse has moved enough to be on a different pixel. 
    if(x != last_edit_pos[0] || y != last_edit_pos[1]) {
      // ...invert it's color.
      custom_char[current_custom_char][x][y] = !custom_char[current_custom_char][x][y];
      
      // Update the last visited pixel.
      last_edit_pos[0] = x;
      last_edit_pos[1] = y;
      
      // Update the screen.
      redraw();
    }
  }  
}

// Check if mouse is in preview area.
void checkLcdClick() {
  // If mouse is in preview area and the right button is pressed...
  if(mouseInRect(lcd_pos, lcd_size) && mouseButton == RIGHT) {
    // ...clear the char we are on!
    
    // Determine which char we are on...
    int x = mouseX - lcd_pos[0];
    int y = mouseY - lcd_pos[1];
    
    x = floor(x / lcd_char_dim[0]);
    y = floor(y / lcd_char_dim[1]);

    // ..and clear it.
    lcd_matrix[current_lcd_preview][x][y] = 0;
    
    //redraw();
  }
}

// Check if mouse is in thumbnails area.
void checkCharsClick() {
  // If mouse is in thumbnails area and the left button is pressed...
  if(mouseInRect(custom_chars_pos, custom_chars_size) && mouseButton == LEFT) {
    // ...select the char under the mouse pointer and mark it for possibile dragging.
    
    // Determine which char thumbnail we are on...
    int x = mouseX - custom_chars_pos[0];
    int y = mouseY - custom_chars_pos[1];
    
    // ...set it as current char in editor...
    current_custom_char = floor(y / custom_char_dim[1]) * 4 + floor(x / custom_char_dim[0]) + 1;
    
    // ...and mark as target of a possible dragging to lcd preview area.
    current_dragging_char = current_custom_char;
    
    //redraw();
  }
}

// Check if mouse has been left-clicked in a button area.
boolean checkButtonClick(int posY) { return checkButtonClick(posY, 75); }
boolean checkButtonClick(int posY, int w) {
  return (mouseInRect(width - 10 - w, posY, w, 20) && mouseButton == LEFT);
}

/*********************************************************
    FILE I/O
 *********************************************************/ 

// Export data to file.
void export() {  
  // Opens file chooser
  String savePath = selectOutput();
  
  if (savePath != null) {
    // If a file was selected, print path to folder
    println(savePath);
    
    // Open selected file
    PrintWriter output = createWriter(savePath);
    int row;
    
    output.println("// Generated by HD44780 Custom Character Editor");
    output.println("uint8_t custom_chars[8][8] = {");
    
    for(int i = 0; i < 8; i++) {
      output.print("   {");
      
      for(int y = 0; y < 8; y++) {
        row = 0;
        
        for(int x = 0; x < 5; x++) 
          if(custom_char[i + 1][x][y]) row += pow(2, 4 - x);
         
        // That's strange: if I put a space after the comma (", ") down here,
        // Notepad shows me garbage, while other editors works ok. Fringe event?
        output.print("0x" + hex(row, 2) + (y != 7 ? ", " : ""));
      }
      
      output.println("}" + (i != 7 ? "," : "")); 
    }
    
    output.println("};");
    
    // Write the remaining data
    output.flush();
    // Close the file.
    output.close();
  }
  
  // Reset the flag.
  do_export = false;
}


void saveFile() {
  // Opens file chooser
  String savePath = selectOutput();
  byte row;
  
  if (savePath != null) {
    byte[] data = new byte[8 * 8 + 5 * 4 * 10];
    
    // Save characters' data    
    for(int i = 0; i < 8; i++)
      for(int y = 0; y < 8; y++) {
        row = 0;
        
        for(int x = 0; x < 5; x++) 
          if(custom_char[i + 1][x][y]) row = (byte)(row | (1 << (4-x)));
          
        data[8 * i + y] = row;
      }
    
    // Save preview data
    for(int i = 0; i < 5; i++)
      for(int y = 0; y < 4; y++)
          for(int hx = 0; hx < 10; hx++) // hx for half-x, because 10 is half of 20 :)
            data[64 + i * 40 + 10 * y + hx] = (byte)( (lcd_matrix[i][2 * hx][y] << 4) + lcd_matrix[i][2 * hx + 1][y] );
    
    saveBytes(savePath, data);
  }
  
  // Reset the flag.
  do_save = false;
}

void openFile() {
  String openPath = selectInput();
  
  if(openPath != null) {
    // Reset all
    initArrays();
    
    byte data[] = loadBytes(openPath);
    int  preview_pages;
    
    switch(data.length) {
      // Retro-compatibility: file saved before v1.1.7 has only one preview screen.
      case 8 * 8 + 4 * 10:
        preview_pages = 1;
        break;
      // Current version: 5 pages, so bigger file size.
      case 8 * 8 + 5 * 4 * 10:
        preview_pages = 5;
        break;
      default:
        return;
    }
    
    // Load characters' data
    for(int i = 0; i < 8; i++) 
      for(int y = 0; y < 8; y++) 
        for(int x = 0; x < 5; x++)
          custom_char[i + 1][x][y] = ( data[8 * i + y] & (1 << (4-x)) ) != 0;
          
    // Load preview data
    int b;
    
    for(int i = 0; i < preview_pages; i++)
      for(int y = 0; y < 4; y++)
          for(int hx = 0; hx < 10; hx++) {
            //  char data len + page offest + line offset + column  
            b = 64            + 40 * i      + 10 * y      + hx;
            
            lcd_matrix[i][2 * hx][y]     = (data[b] & 0xF0) >> 4 ;
            lcd_matrix[i][2 * hx + 1][y] =  data[b] & 0x0F;
          }
  }
  
  // Reset the flag.
  do_open = false;
}

/*********************************************************
    HELPER METHODS
 *********************************************************/ 

boolean inRange(int value, int val_min, int val_max) {
  return (value > val_min && value < val_max);
}
boolean mouseInRect(int x, int y, int w, int h) {
  return inRange(mouseX, x, x+w) && inRange(mouseY, y, y+h);
}
boolean mouseInRect(int[] pos, int[] dim) {
  return mouseInRect(pos[0], pos[1], dim[0], dim[1]);
}
boolean mouseInRect(int[] pos, int charScale) {
  return mouseInRect(pos[0], pos[1], 5 * charScale, 8 * charScale);
}
