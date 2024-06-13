ArrayList<movBall> bl;
int initNum=3;
float sz=180;//75
float chue = 45.0;
boolean changeColor = false;
float colHue = 0;
float colAlp =5; 
float alphaDec = 0.1;
PVector cnt;
float vcoef =2.5;  
float dcoef = 0.02;
float fric = .995;
float upLimit = 250.0;
boolean doEvent = false;
float eventRate = 0.01/60.0;
int totalNum=0;
float vlim = 0.01;
int addBallNum=4;
int ballsRemain;
int inithold=60*10;
int interval = 60*10;
boolean dup=false;
int dupBallID=1, dupUntil;
movBall b;
void setup() {

  //size(1280, 768);
  fullScreen();
  noStroke();
  ellipseMode( CENTER );
  cnt = new PVector( width/2.0, height/2.0);
  colorMode( HSB, 360, 100, 100, 100);
  bl = new ArrayList<movBall>();
  for ( int i=0; i<initNum; i++ ) {
    bl.add( new movBall());
    b = bl.get(i);
    //b.col=color(chue, 100, 100, 100);
    b.pos=PVector.random2D();
    b.pos.mult(256.0);
    b.pos.x += width/2.0;
    b.pos.y += height/2.0;
  }
}

void draw() {
  background(#000000);

  float totalV=0.0, averageV =0.0;

  for ( int i=0; i<bl.size(); i++ ) {
    b = bl.get(i);
    b.draw();
    totalV += b.vec.mag();
  }

  if ( frameCount > 600 ) {
    averageV=totalV/(bl.size()*1.0);
    //println( bl.size(), averageV);
    if ( doEvent ) {
      if ( frameCount%2==0 ) {
        if ( ballsRemain>0 ) {
          //分身作成
          b = bl.get(0);
          bl.add( new movBall());//クラス配列に新メンバー追加
          movBall newb = bl.get(bl.size()-1);
          newb.col=b.col;
          newb.pos=PVector.random2D();
          newb.pos.mult(128.0*5);
          newb.pos.x +=width/2.0;
          newb.pos.y +=height/2.0;
          ballsRemain--;
          if ( ballsRemain<=0 ) {
            doEvent=false;
            addBallNum++;
          }
        }
      }
    } else {
      if ( bl.size()<250 ) {
        if ( frameCount%300 == 0 ) {
          doEvent=true;
          ballsRemain = addBallNum;
        }
      } else {
        if ( averageV<vlim ) {
          doEvent=true;
          ballsRemain = addBallNum;
        }
      }
    }
  }
}
class movBall {
  PVector pos, vec, acc, vsum, tmp, dif;
  float icoef, dv, alp=70;
  boolean inEvent;
  color col;
  movBall() {
    pos=new PVector(random(0, width), random(0, height ));
    acc=new PVector( 0, 0 );
    vec=new PVector( 0, 0 );
    vsum=new PVector(0, 0);
    tmp = new PVector(0, 0);
    col = color(random(100), random(100), random(100), alp);

    icoef=1.0;
    inEvent=false;
    totalNum++;
  }

  void draw() {
    newFrame();
    fill( color(chue, 100, 100, alp));
    noStroke();
    ellipse( pos.x, pos.y, sz, sz);
    if ( alp > colAlp ) {
      alp-=alphaDec;
      if ( alp< colAlp ) {
        alp = colAlp;
      }
    }
  }

  void newFrame() {
    dif=PVector.sub(cnt, pos);
    dif.normalize();
    dif.mult(dcoef);
    vsum.mult(0.0);
    tmp.mult(0.0);
    for ( int i = 0; i< totalNum; i++ ) {
      movBall t2 = bl.get(i);
      tmp = PVector.sub(pos, t2.pos);
      if ( (tmp.mag() >0) && (tmp.mag()<upLimit) ) {
        dv = tmp.magSq();
        tmp.normalize();
        tmp.mult( t2.icoef );
        tmp.div( dv );
        vsum = vsum.add( tmp);
      }
    }

    vec.mult(fric);
    vsum.mult(vcoef);
    vec.add(dif);
    vec.add( vsum );
    //if ( !inEvent ) {
    //  if ( vec.mag()<(1/(1.0*initNum)) && doEvent && random(0, 1)<eventRate ) {
    //    float rlt = random(0, 1);
    //    if ( rlt < 0.7 ) { 
    //      icoef=100.0;
    //    } else if (rlt<.9) { 
    //      icoef = 150.0;
    //    } else if ( rlt<.99) { 
    //      icoef = 200.0;
    //    } else {
    //      icoef=2000.0; 
    //      inEvent=true;
    //    }
    //  } else {
    //    icoef= 1.0;
    //    inEvent=false;
    //  }
    //}
    if ( vec.mag() > 10.0) {
      vec.setMag(10.0);
    }
    pos.add( vec );
  }
};

void mousePressed() {
}


void keyPressed() {
  for ( int i=0; i<bl.size(); i++ ) {
    movBall b = bl.get(i);
    b.pos.x = random( 0, width);
    b.pos.y = random( 0, height);
  }
}
