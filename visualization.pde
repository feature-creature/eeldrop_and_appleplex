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
        //rect(0, 0, width, height);
        //rotation(rotAngle, angleStep);
        if (rotAngle <= 0.0 || rotAngle >= 10.0) angleStep = -angleStep;
        rotAngle += angleStep;
        if (ed <= 0 || ed >= 255) colorStep = -colorStep;
        ed += colorStep;
        // basic lines
        for (int i  = 0; i < fftBandRange; i++) {
            fill(ed, 10);
            //ellipse((width/fftBandRange)*i + (width/2), (height/2) - bands[i], 2, 2);
            if(frameCount % 3 == 0){
            ellipse((width/fftBandRange)*i + (width/2), (height/2) + (bands[i]*2), 2, 2);
            }else{
            ellipse(width - (width/fftBandRange/1.5)*i - (width/2), (height/2) - (bands[i]*2), 2, 2);
            }
            //ellipse(width - (width/fftBandRange/1.5)*i - (width/2), (height/2) + bands[i], 2, 2);
        }

        pushMatrix();
        translate(width/2, height/2);
        //scale(2);
        rotate(rotAngle);

        for (int i  = 0; i < fftBandRange; i++) {

            fill(ed - i + 20, 5);
            stroke(ed - i + 20, 20);
            //line(i, height, i, height - bands[i]);
            if (i < 50 && i > 0 && bands[i] != 0) {
                pushMatrix();
                rotate(i);
                line(i, height/25 - bands[i], i-1, height/25 - bands[i-1]);
                popMatrix();
                // draw 'footpaths' on top of 'waves'
                if (i < 5 && i > 0) {
                    stroke(255, 50); //255  - ed
                    ellipse(i, height/25 - bands[i], 1, 1);
                }
            }
        }
        fill(bg, 75);
        stroke(255, 75);
        ellipse(0, 0, 75, 75);
        popMatrix();
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