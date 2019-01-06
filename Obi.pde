class Obi {  
  int posX, posY;
  int kind;
  float theta, len;
  boolean isFliped, isSelected;
  float lenMax, lenMin;  //length maximum, minimum
  //boolean lenIsVertical;  //length direction vertical/horizontal
  PImage img;
  PImage topImg, middleImg, bottomImg;
  PGraphics gra;
  int num;

  Curve boneCurve;


  Obi(int _x, int _y, int _k, int _n) {
    posX = _x;
    posY = _y;
    kind = _k;
    isSelected = false;
    gra = createGraphics(640, 480);
    num = _n;
    boneCurve = new Curve(#660000);
    init();
    ArrayList<Vertex> _vtx = new ArrayList<Vertex>();

    int n;  //topImg, bottomImgを決めるために使う

    switch(kind) {
      //種類に応じて画像等を変更
    case 0:
      img = loadImage("hida1.png");
      lenMax = 1;
      lenMin = 1;
      //lenIsVertical = false;
      n = 0;
      splitImg(n);
      updateGra();

      _vtx.add(new Vertex(126, -39));
      _vtx.add(new Vertex(71, -39));
      _vtx.add(new Vertex(-60, -7));
      _vtx.add(new Vertex(-54, 2));
      _vtx.add(new Vertex(72, -28));
      _vtx.add(new Vertex(129, -27));
      boneCurve.setVtxList(_vtx);
      break;

    case 1:
      img = loadImage("hida2.png");
      lenMax = 1;
      lenMin = 1;
      //lenIsVertical = false;
      break;

    case 2:
      img = loadImage("hida3.png");
      lenMax = 1;
      lenMin = 1;
      //lenIsVertical = false;
      break;

    case 3:
      img = loadImage("half1.png");
      lenMax = 1.5;
      lenMin = 0.7;
      //lenIsVertical = true;
      n = 10;
      splitImg(n);
      updateGra();
      _vtx.add(new Vertex(-3, 58));
      _vtx.add(new Vertex(-4, -24));
      _vtx.add(new Vertex(3, 1));
      _vtx.add(new Vertex(-2, 22));
      _vtx.add(new Vertex(-9, -79));
      boneCurve.setVtxList(_vtx);
      break;

    case 4:
      img = loadImage("taiko1.png");
      lenMax = 2;
      lenMin = 0.4;
      //lenIsVertical = true;
      n = 14;
      splitImg(n);
      updateGra();
      _vtx.add(new Vertex(-8, 77));
      _vtx.add(new Vertex(-7, -93));
      _vtx.add(new Vertex(2, -39));
      _vtx.add(new Vertex(0, 50));
      _vtx.add(new Vertex(-6, 90));
      _vtx.add(new Vertex(-9, -62));
      boneCurve.setVtxList(_vtx);
      break;

    case 5:
      img = loadImage("tare1.png");
      lenMax = 2;
      lenMin = 0.4;
      //lenIsVertical = true;
      n = 14;
      splitImg(n);
      updateGra();
      _vtx.add(new Vertex(-4, -116));
      _vtx.add(new Vertex(-4, -95));
      _vtx.add(new Vertex(-2, 95));
      _vtx.add(new Vertex(-2, 112));
      boneCurve.setVtxList(_vtx);
      break;

    default:
      break;
    }
  }

  void init() {
    theta = 0;
    len = 1;
    isFliped = false;
  }

  void splitImg(int n) {
    if (n == 0) {
      topImg = img.get(0, 0, 0, 0);
      bottomImg = img.get(0, 0, 0, 0);
      middleImg = img;
    } else {
      topImg = img.get(0, 0, img.width, img.height/n);
      bottomImg = img.get(0, img.height-img.height/n, img.width, img.height/n);
      middleImg = img.get(0, topImg.height, img.width, img.height-topImg.height-bottomImg.height);
    }
  }

  //----------

  //移動

  void moveWithMouse() {
    posX += mouseX - pmouseX;
    posY += mouseY - pmouseY;
  }

  void moveUp() {
    posY--;
  }

  void moveDown() {
    posY++;
  }

  void moveLeft() {
    posX--;
  }

  void moveRight() {
    posX++;
  }  

  //変形

  //rotate counterclockwise
  //反時計回りに回転
  void rotateCtclws() {
    if (isFliped) {
      theta++;
    } else {
      theta--;
    }
  }

  //rotate clockwise
  //時計回りに回転
  void rotateClws() {
    if (isFliped) {
      theta--;
    } else {
      theta++;
    }
  }

  //lengthen length
  //長くする
  void lengthenLen() {
    len += 0.02;
    if (len >= lenMax) {
      len = lenMax;
    }
  }

  //shorten length
  //短くする
  void shortenLen() {
    len -= 0.02;
    if (len <= lenMin) {
      len = lenMin;
    }
  }

  //左右反転
  void flip() {
    isFliped = !isFliped;
  }

  //----------

  //クリックされたかどうか
  boolean isClicked() {
    //println(mouseX, mouseY);
    //println(gra.width+ "," +  gra.height);
    //println(gra.pixels[0]);
    int col = gra.get(mouseX, mouseY);
    //int col = gra.get(mouseX, mouseY);
    if (col != 16777215 && col != 0) {
      //透明ピクセルや範囲外でないときtrue
      return true;
    }
    return false;
  }

  //----------

  //描画
  void display(PGraphics g) {
    if (isSelected) {
      updateGra();
    }
    g.image(gra, 0, 0);

    //選択中ハイライト
    if (isSelected) {
      g.pushMatrix();
      changeMatrix(g);
      g.noFill();
      g.stroke(0, 0, 255);
      g.strokeWeight(1);
      float y = topImg.height + middleImg.height*len/2;
      g.rect(-img.width/2, -y, img.width, y*2);
      g.popMatrix();
    }
  }

  void updateGra() {
    gra.beginDraw();
    gra.pushMatrix();
    changeMatrix(gra);
    gra.background(255, 0);

    float y = -topImg.height -middleImg.height*len/2;
    gra.image(topImg, -topImg.width/2, y);
    y += topImg.height;
    gra.image(middleImg, -middleImg.width/2, y, middleImg.width, middleImg.height*len);
    y += middleImg.height * len;
    gra.image(bottomImg, -bottomImg.width/2, y);

    gra.popMatrix();
    gra.endDraw();
  }

  //----------

  //座標変換
  void changeMatrix(PGraphics g) {
    g.translate(posX, posY);
    if (isFliped) {
      g.scale(-1, 1);
    }
    g.rotate(radians(theta));
  }
}