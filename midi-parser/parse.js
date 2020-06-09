/**
 * MIDI to C array converter
 * FPGA sound synthesizer software
 * 
 * @author  Alexandre CHAU
 * @date    June 9, 2020
 */

const midiParser = require('midi-parser-js')
const fs = require('fs')

/**
 * JS helpers
 */
const range = (start, end) => {
    const length = end - start;
    return Array.from({ length }, (_, i) => start + i);
}

/**
 * Music and MIDI helpers
 */
const NOTE_START_TYPE = 9

// Enumerate possible tones
const tones = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]

// Range of MIDI notes identfiers is [21, 108]
const midiRange = range(21, 109)

// Map each MIDI note identifer to a human readable tone + scale number
const midiNotes = {}
midiRange.forEach((num, i) => midiNotes[num] = {
    note: tones[i % tones.length],
    scale: ~~(num / tones.length - 1),
})

function findDelta(events, index) {
    // must find distance to next note start by aggregating deltaTimes
    // if last (i.e. no note start is found afterwards, it must be 0)
    const eventsLeft = events.slice(index + 1, events.length)
    const nextIndex = eventsLeft.findIndex(e => e.type === NOTE_START_TYPE)
    if (nextIndex === -1) return 0
    else {
        return eventsLeft.slice(0, nextIndex + 1).reduce((acc, curr) => acc + curr.deltaTime, 0)
    }
}

/**
 * CLI helpers
 */

function printUsage() {
    console.log("Usage: node parse <MIDI file> <C variable name (ex: BACH_PRELUDE_C)>")
}

if (process.argv[2] == null) {
    console.log("Please provide a valid MIDI input file!")
    printUsage()
    return
}

if (process.argv[3] == null) {
    console.log("Please provide a valid C variable name!")
    printUsage()
    return
}

file = process.argv[2]
name = process.argv[3]

fs.readFile(file, 'base64', (err, data) => {
    const midi = midiParser.parse(data)
    const track = midi.track[0].event
    const notes = track.map((event, i) => {
        // only consider note starts (type = 9)
        if (event.type !== NOTE_START_TYPE) return null
        else {
            // retrieve note value
            const value = Object.assign({}, midiNotes[event.data[0]])
            // attach time delta
            value["delta"] = findDelta(track, i)
            return value
        }
    }).filter(e => e !== null)

    // generate C array (IMPORTANT! Preserve spacing!)
    const code = `
#define ${name}_LENGTH ${notes.length}
struct note ${name}[${name}_LENGTH] = {
${notes.map(n => `\t{${n.note.replace('#', 's')}, ${n.scale}, ${n.delta}}`).join(`,\n`)}
};
`
    fs.writeFileSync(`${file}.converted.c`, code, {encoding: 'utf8'})
})