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
float fftScale = 100; //scale bandwidth
float[] fftSum;

// audio file
String fileSource = "STE-002.wav"; //"jc.mp3" "eeldrop_and_appleplex.wav"

// text file
ArrayList<String> words;

// import pdf library
import processing.pdf.*;
// draw into offscreen graphics buffer
PGraphicsPDF pdf;

void setup() {
    // size : 1920 x 1080 - A2
    // mode : PDF export?
    size(1920, 1080);
    //fullScreen();

    // initialize Minim
    // 'this' identifies this sketch/data directory 
    // as the filepath for the audioplayers' audio file
    // 10 bit buffersize (default)
    eliot = new Minim(this);
    eeldropAndAppleplexPlayer = eliot.loadFile(fileSource, 1024);
    eeldropAndAppleplexPlayer.play();

    // initialize FFT analyzer
    // transforms amplitude vs time data to amplitude vs frequency data (generates a spectrum)
    // frequency resolution = 1 / time range constant
    // ?? where is sample rate declared
    // ?? calculate band averages by linearly grouping frequency bands.
    fft = new FFT(eeldropAndAppleplexPlayer.bufferSize(), eeldropAndAppleplexPlayer.sampleRate());
    fft.linAverages(fftBandRange);
    fftSum = new float[fftBandRange]; //empty array

    // initialize Visualization
    // ?? spectrum size function
    eeldropAndAppleplexVis = new Visualization(fft.specSize());
    eeldropAndAppleplexVis.setup();
    // initialize graphics buffer
    pdf = (PGraphicsPDF)beginRecord(PDF, "eeldrop_and_appleplex_"+date()+".pdf");
    // start recording the output file
    beginRecord(pdf);
    background(150);
    initializeText();
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

void initializeText() {
    String[] lines = loadStrings("eeldrop_and_appleplex_only.txt");
    int fontSize = 10;
    fill(255, 25);
    textSize(10);
    words = new ArrayList<String>();
    String lineOne = lines[2];
    String lineTwo = lines[2];
    for (int i = 1; (i*100) < lineOne.length(); i++) {
        if (lineOne.length() - (i * 100) < 100) {
            text(lineOne.substring((i*100) - 100, i*100), fontSize*3, (i*25) + (fontSize * 1.5));
            text(lineOne.substring((i*100), lineOne.length()), fontSize*3, (i*25) + (fontSize * 3.5));
        } else if (i == 1) {
            text(lineOne.substring(0, (i*100)), fontSize*3, (i*25) + (fontSize * 1.5));
        } else {
            text(lineOne.substring((i*100) - 100, i*100), fontSize*3, (i*25) + (fontSize * 1.5));
        }
    }
    for (int i = 1; (i*100) < lineTwo.length(); i++) {
        fill(0, 25);
        if (lineTwo.length() - (i * 100) < 100) {
            text(lineTwo.substring((i*100) - 100, i*100), width/1.8 + fontSize*3, (i*25) + (fontSize * 1.5));
            text(lineTwo.substring((i*100), lineTwo.length()), width/1.8 + fontSize*3, (i*25) + (fontSize * 3.5));
        } else if (i == 1) {
            text(lineTwo.substring(0, (i*100)), width/1.8 + fontSize*3, (i*25) + (fontSize * 1.5));
        } else {
            text(lineTwo.substring((i*100) - 100, i*100), width/1.8 + fontSize*3, (i*25) + (fontSize * 1.5));
        }
    }

    //for (int i = 0; i < lines.length; i++) {
    //    if (i % 3 == 0) {
    //        fill(0,70);
    //        text(lines[i], fontSize*1.5, (fontSize*i) + (fontSize * 1.5));
    //    } else {
    //        fill(255,70);
    //        text(lines[i], (width/2) + fontSize*1.5, (fontSize*i) + (fontSize * 1.5));
    //    }
    //}
}






// GLOBAL HELPER FUNCTIONS
String date() {
    return(
        year()
        + "_" + month() 
        + "_" + day()
        + "_" + hour()
        + "_" + minute()
        + "_" + second()
        );
}

void keyPressed() {
    if (key == 's') {
        // end data transfer to PDF buffer
        // save PDF
        endRecord();
        // quit program
        exit();
    }
}