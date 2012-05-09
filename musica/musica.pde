/*
  Melody
 
 Plays a melody 
 
 circuit:
 * 8-ohm speaker on digital pin 8
 
 created 21 Jan 2010
 by Tom Igoe 

This example code is in the public domain.
 
 http://arduino.cc/en/Tutorial/Tone
 
 */
 #include "pitches.h"




// notes in the melody:
int melody[] = {
  NOTE_C0, NOTE_D0, NOTE_E0, NOTE_F0};

// note durations: 4 = quarter note, 8 = eighth note, etc.:
int noteDurations[] = {
  4, 8, 8, 4 };

void setup() {
  //NOTE_C0, NOTE_D0, NOTE_E0, NOTE_F0
  tone(8, NOTE_C0,250);
  delay(200);
  tone(8, NOTE_D0,250);
  delay(200);
  tone(8, NOTE_E0,250);
  delay(200);
  tone(8, NOTE_F0,250);

/*
  // iterate over the notes of the melody:
  for (int thisNote = 0; thisNote < 4; thisNote++) {

    // to calculate the note duration, take one second 
    // divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000/noteDurations[thisNote];
    tone(8, melody[thisNote],noteDuration);

    // to distinguish the notes, set a minimum time between them.
    // the note's duration + 30% seems to work well:
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
  }
*/
}

void loop() {
  // no need to repeat the melody.
}
