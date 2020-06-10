/*
 * FPGA sound synthesizer main program
 * Main NIOS II entry point to play music with the FPGA sound synthesizer
 *
 * file: main.c
 * author: Alexandre CHAU & Loïc DROZ
 * date: June 9, 2020
 */

#include <stdio.h>
#include <unistd.h>

#include "peripherals.h"
#include "music.h"

// current music piece
struct piece* music;

/**
 * Plays the current piece
 */
void play_music() {
	// start oscillator
	sound_osc_start();

	for (size_t i = 0; i < music->length; i++) {
		sound_set_note(music->sheet[i].midi_msg);
		usleep(music->sheet[i].duration_ms * 1000);
	}

	// stop oscillator
	sound_osc_stop();
}

int main() {
  printf("Hello from Nios II!\n");

  printf("Configuring audio codec...\n");
  setup_audio_codec();

  printf("Playing music...\n");
  music = &pieces[1];
  play_music();

  while(1);

  return 0;
}
