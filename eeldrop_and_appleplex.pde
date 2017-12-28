// Title       : Eeldrop and Appleplex
// Author      : Luke Demarest
// Date        : 2017/12
// License     : GLPv3
// Details     :
// References  :
//
//    Literary :
//    Eeldrop and Appleplex, T.S. Eliot, 1917 - The Project Gutenberg
//    The Hidden Advantage of Tradition: On the Significance of T. S. Eliot's Indic Studies, Jeffry M. Perl and Andrew P. Tuck - Philosophy East & West, V. 35 No. 2 (April 1985), pp. 116-131
//    
//
//    Technical:
//    Libraries - Minim
//
// TODO        :
//    Minim documentation
//    fft documentation


// IMPORT LIBRARIES
import ddf.minim.*;
import ddf.minim.analysis.*;

// GLOBAL DECLARATIONS
// Minim class instance
Minim eliot;
// minim AudioPlayer class instance
AudioPlayer eeldropAndAppleplexPlayer;
// Fast-Fourier Transform class instance (FFT)
FFT fft;
// Visualization class instance (custom)
Visualization eeldropAndAppleplexVis;


// FFT # of bands - 8 bit || 1 byte
int fftBandRange = 256;
float fftSmoothFactor = 0.02; //subjective
float fftScale=0.5; //subjective - ?? what type of scaling
float[] fftSum;

//global colors
int bg = 150; //gray
int ed = 0; //white
int ap = 255; //black

void setup() {
    // size : 1920 x 1080 - A2
    // mode : PDF export?
    size(255, 255);
    background(bg);

    // initialize Minim
    // 'this' identifies this sketch/data directory 
    // as the filepath for the audioplayers' audio file
    // 10 bit buffersize (default)
    eliot = new Minim(this);
    eeldropAndAppleplexPlayer = eliot.loadFile("eeldropAndAppleplex.mp3", 1024);

    // initialize FFT analyzer
    // ?? "patch" FFT analyzer
    // ?? where is sample rate declared
    // ?? calculate band averages by linearly grouping frequency bands.
    fft = new FFT(eeldropAndAppleplexPlayer.bufferSize(), eeldropAndAppleplexPlayer.sampleRate());
    fft.linAverages(fftBandRange);
    fftSum = new float[fftBandRange];

    // initialize Visualization
    // ?? spectrum size
    eeldropAndAppleplexVis = new Visualization.(fft.specSize());
    eeldropAndAppleplexVis.setup();
}

void draw() {
}