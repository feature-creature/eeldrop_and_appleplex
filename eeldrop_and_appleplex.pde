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
float fftScale = 50; //scale bandwidth
float[] fftSum;

// audio file
String fileSource = "jc.mp3"; //"eeldropAndAppleplex.mp3"

void setup() {
    // size : 1920 x 1080 - A2
    // mode : PDF export?
    size(255, 255);
    background(150);

    // initialize Minim
    // 'this' identifies this sketch/data directory 
    // as the filepath for the audioplayers' audio file
    // 10 bit buffersize (default)
    eliot = new Minim(this);
    eeldropAndAppleplexPlayer = eliot.loadFile(fileSource, 1024);
    eeldropAndAppleplexPlayer.play();

    // initialize FFT analyzer
    // ?? "patch" FFT analyzer
    // ?? where is sample rate declared
    // ?? calculate band averages by linearly grouping frequency bands.
    fft = new FFT(eeldropAndAppleplexPlayer.bufferSize(), eeldropAndAppleplexPlayer.sampleRate());
    fft.linAverages(fftBandRange);
    fftSum = new float[fftBandRange]; //empty array

    // initialize Visualization
    // ?? spectrum size function
    eeldropAndAppleplexVis = new Visualization(fft.specSize());
    eeldropAndAppleplexVis.setup();
}

void draw() {

    // send fft data to visualization
    fft.forward(eeldropAndAppleplexPlayer.mix);
    for (int i = 0; i < fftBandRange; i++) {
        // update the fftSum value by adding itself to
        // the difference between itself and the changing average fft, times a smoothing factor
        fftSum[i] += (fft.getAvg(i) - fftSum[i]) * fftSmoothFactor;
        eeldropAndAppleplexVis.setBand(i, fftSum[i] * fftScale); //raw data: fft.getAvg(i)
        
        // DEBUGGING
        //println("avg: " + fft.getAvg(i));
        //println("updated sum: " + fftSum[i]);
        //println("updated sum with scaling: " + fftSum[i] * fftScale);
        //println("-----------------------------------------");
    }

    // draw visualization
    eeldropAndAppleplexVis.draw();
}








// GLOBAL HELPER FUNCTIONS
String date() {
    fill(200);
    rectMode(CORNER);
    rect(width/2- 75, height - 25, 140, 25);
    fill(0);
    textSize(10);
    return(
        year()
        + "_" + month() 
        + "_" + day()
        + "_" + hour()
        + "_" + minute()
        + "_" + second()
        );
}