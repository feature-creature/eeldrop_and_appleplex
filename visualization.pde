class Visualization {

    // global colors
    int bg = 150; //gray
    int ed = 255; //white
    int ap = 0; //black
    int colorStep = 1;

    // global rotation
    float rotAngle = 1;
    float angleStep = 0.01;    

    // ?? necessary to store locally, works without it
    // maybe needed to prevent leaky functions
    // set vaiables at class initialization
    float[] bands;
    int numBands;
    Visualization(int _numBands) {
        numBands = _numBands;
        bands = new float[numBands];
    }

    void setup() {
        // initialize color
        fill(ed);
        stroke(ap);
    }

    void draw() {

        // background || ghosting
        fill(bg, 25);
        noStroke();
        rect(0, 0, width, height);

        // basic lines
        for (int i  = 0; i < fftBandRange; i++) {
            //if (ed <= 0 || ed >= 255) colorStep = -colorStep;
            //ed += colorStep;
   
            fill(ed,105);
            //line(i, height, i, height - bands[i]);
            ellipse(i, height - bands[i],3,3);
        }
    }

    void setBand(int rangeIndex, float fftData) {
        if (rangeIndex >= 0) {
            bands[rangeIndex] = fftData;
        } else {
            println("data error");
        }
    }

    void rotation(float angle, float stepSize) {
        if (angle <= 0.0 || angle >= 10.0)stepSize = -stepSize;
        angle += stepSize;
    }
}