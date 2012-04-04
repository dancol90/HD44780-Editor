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
 

/*********************************************************
    POSITIONS and DIMENSIONS
 *********************************************************/ 

static final int lcd_pos[] = {10, 20}; // Left & top position of lcd preview
static final int lcd_scale  = 3;       // Scale of lcd preview characters (3 times 5x7 pixel)
static final int[] lcd_char_dim = {5 * lcd_scale + 1, 8 * lcd_scale + 1};  // CALCULATED. Width & height of a single lcd char 
static final int[] lcd_size = {20 * lcd_char_dim[0], 4 * lcd_char_dim[1]}; // CALCULATED. Width & height of lcd preview.

static final int custom_chars_pos[] = {10, 140}; // Position of custom chars thumbnails
static final int custom_chars_scale  = 5;        // Scale of custom chars thumbnail
static final int[] custom_char_dim   = {5 * custom_chars_scale + 1, 8 * custom_chars_scale + 1}; // CALCULATED. Width & height of a single thumbnail
static final int[] custom_chars_size = {4 * custom_char_dim[0], 2 * custom_char_dim[1]};         // CALCULATED. Width & height of all thumbnail

static final int edit_char_pos[] = {135, 140}; // Position of editing area
static final int edit_char_scale = 20;         // Scale of editing area
  

// 20x4 Matrix for lcd preview
int     lcd_matrix[][];
// 8x custom char. Each one has 5x7 pixels.
boolean custom_char[][][];

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

/*********************************************************
    SETUP
 *********************************************************/ 

// Init preview and custom chars arrays 
void initArrays() {
  custom_char = new boolean[9][5][8];
  lcd_matrix  = new int[20][4];
}

// Entrypoint of the sketch
void setup() {
  frame.setTitle("HD44780 Custom Character Editor");
  
  size(lcd_size[0] + 20, 325);
  
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
  text("LCD Preview", 10, 15);
  
  // For each row...
  for(int r = 0; r < 4; r++) {
    // ...and for each column...
    for(int c = 0; c < 20; c++) {
      // ...draw the char.
      drawChar(lcd_pos[0] + c * lcd_char_dim[0], lcd_pos[1] + r * lcd_char_dim[1], 
               lcd_scale,
               custom_char[lcd_matrix[c][r]]);
    }
  }
  
  /* --- Custom chars area --- */
  
  fill(#ffffff);
  text("Custom charaters", 10, 135);
  
  int i, x, y;
  
  for(int r = 0; r < 2; r++) {
    for(int c = 0; c < 4; c++) {
      i = r * 4 + c + 1;
      
      // Determine left & top position of the single current char. 
      x = custom_chars_pos[0] + c * custom_char_dim[0];
      y = custom_chars_pos[1] + r * custom_char_dim[1];
      
      // Draw a border around the char if it's the currently selected.
      if(i == current_custom_char) {
        stroke(#ffffff, 150);
        noFill();
        
        rect(x - 1, y - 1, custom_char_dim[0] - 1, custom_char_dim[1] - 1);
      }
      
      // Draw the char thumbnails itself.
      drawChar(x, y, custom_chars_scale, custom_char[i]);
    }
  }

  /* --- Char edit area --- */

  fill(#ffffff);
  text("Edit character", 135, 135);
    
  drawChar(edit_char_pos[0], edit_char_pos[1], edit_char_scale, custom_char[current_custom_char]);
  
  /* --- Quick help --- */
  
  fill(#ffffff);
  text("Drag chars above \nin LCD preview \nto place them.\nRight click to delete.", 10, 235);
  
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
  drawButton(width - 10 - 75, 260, 75, 20, sure_about_reset ? "Are you sure?" : "Reset all", #FF6262);
  
  /* --- Footer --- */
  pushStyle();

  fill(#aaaaaa, 50);
  textAlign(RIGHT, BOTTOM);
  
  text("v1.0 ©Daniele Colanardi 2012", width - 5, height - 5);
  
  // Restore text align
  popStyle();
}

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
  if(checkButtonClick(195))
    // Export button clicked.
    do_export = true;
  else if(checkButtonClick(170))
    // Save button clicked.
    do_save = true;
  else if(checkButtonClick(145))
    // Open button clicked.
    do_open = true;
  else if(checkButtonClick(260)) {
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
    
  } else
    // Clicked elsewhere, restart. 
    sure_about_reset = false;
  
  redraw();
}

// Mouse dragged event handler
void mouseDragged() {
  // Check if mouse is in edit area, and draw.
  checkPointEdit();
  
  // Redraw needed only if we are dragging a char to preview, to draw its shadow.
  if(current_dragging_char != -1)
    redraw();
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
      lcd_matrix[x][y] = current_dragging_char;
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
    lcd_matrix[x][y] = 0;
    
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
boolean checkButtonClick(int posY) {
  return (mouseInRect(width - 10 - 75, posY, 75, 20) && mouseButton == LEFT);
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
    byte[] data = new byte[8 * 8 + 4 * 10];
    
    // Save characters' data    
    for(int i = 0; i < 8; i++)
      for(int y = 0; y < 8; y++) {
        row = 0;
        
        for(int x = 0; x < 5; x++) 
          if(custom_char[i + 1][x][y]) row = (byte)(row | (1 << (4-x)));
          
        data[8 * i + y] = row;
      }
    
    // Save preview data
    for(int y = 0; y < 4; y++)
        for(int hx = 0; hx < 10; hx++) // hx for half-x, because 10 is half of 20 :)
          data[64 + 10 * y + hx] = (byte)( (lcd_matrix[2 * hx][y] << 4) + lcd_matrix[2 * hx + 1][y] );
    
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
    
    if(data.length != 8 * 8 + 4 * 10) return;
    
    // Load characters' data
    for(int i = 0; i < 8; i++) 
      for(int y = 0; y < 8; y++) 
        for(int x = 0; x < 5; x++)
          custom_char[i + 1][x][y] = ( data[8 * i + y] & (1 << (4-x)) ) != 0;
          
    // Load preview data
    for(int y = 0; y < 4; y++)
        for(int hx = 0; hx < 10; hx++) {
          lcd_matrix[2 * hx][y]     = (data[64 + 10 * y + hx] & 0xF0) >> 4 ;
          lcd_matrix[2 * hx + 1][y] =  data[64 + 10 * y + hx] & 0x0F;
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
