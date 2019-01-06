/*How to use
 
 new item
 q key: hida1
 w key: hida2
 e key: hida3
 r key: half1
 t key: taiko1
 y key: tare1
 
 selected item
 mouse click: select
 shift + click: select multiple
 mouse drag: move
 backspace key: remove
 space key: reset
 [ key: layer up
 ] key: layer down
 < key: rotate counterclockwise
 > key: rotate clockwise
 ^ key: flip horizontal
 
 others
 s key: save screen as png
 */

PImage obiBody;  //胴巻き部分の画像

ArrayList<Obi> obiLayer;

boolean shiftPressed;
boolean obiMoving, layerMoving;

boolean boneVisible;

PGraphics canvas;  //帯結び画像
//PGraphics layerMenu;
int lyMenuX, lyMenuY, lyMenuW, lyMenuH;  //layer menu
int lyBoxH;  //obi layer instance box height
int layerNum;

//----------

void settings() {
  obiBody = loadImage("obi_body.png");

  lyMenuX = obiBody.width;
  lyMenuY = 0;
  lyMenuW = 140;
  lyMenuH = obiBody.height;
  size(obiBody.width + lyMenuW, obiBody.height);
}

void setup() {
  obiLayer = new ArrayList<Obi>();


  shiftPressed = false;
  obiMoving = false;
  layerMoving = false;

  boneVisible = false;

  canvas = createGraphics(obiBody.width, obiBody.height);

  //layerMenu = createGraphics(lyMenuW, lyMenuH);
  lyBoxH = 36;
  layerNum = 0;
}

void draw() {
  if (obiMoving) {
    //マウスに合わせて移動
    for (Obi o : obiLayer) {
      if (o.isSelected) {
        o.moveWithMouse();
      }
    }
  }

  //描画
  background(255);
  canvas.beginDraw();
  canvas.background(255, 255, 255, 0);

  canvas.image(obiBody, 0, 0);

  for (Obi o : obiLayer) {
    o.display(canvas);
    //print("draw ");
    if (boneVisible) {
      o.boneCurve.drawCurve(canvas, o.posX, o.posY);
      //o.boneCurve.drawCtrlLine(canvas, o.posX, o.posY);
    }
  }
  //println();
  canvas.endDraw();

  image(canvas, 0, 0);

  //layer menu
  drawLayerMenu();
}

//----------

void mousePressed() {
  if (mouseX <= canvas.width) {
    //canvas 範囲内

    //クリックで選択

    int clicked = getClickedObi();
    Obi clObi;  //クリックされた帯パーツ
    if (clicked >= 0 && clicked < obiLayer.size()) {
      clObi = obiLayer.get(clicked);
      obiMoving = true;

      //シフト押さずに選択されてないアイテムをクリックしたとき
      //選択されているアイテムをクリア
      if (!clObi.isSelected && !shiftPressed) {
        deselectionAll();
      }

      if (shiftPressed) {
        //シフト＋クリック：クリックされたアイテムの選択追加/解除
        clObi.isSelected = !clObi.isSelected;
      } else {
        //シフトなしクリック：クリックされたアイテムだけ選択
        clObi.isSelected = true;
      }
    } else {
      //アイテムがクリックされていないとき
      deselectionAll();
    }
  } else {
    //layer menu

    int clicked = getClickedLayer();
    if (clicked >= 0 && clicked < obiLayer.size()) {
      Obi obi = obiLayer.get(clicked);
      if (!obi.isSelected && !shiftPressed) {
        deselectionAll();
      }
      if (shiftPressed) {
        obi.isSelected = !obi.isSelected;
      } else {
        obi.isSelected = true;
        layerMoving = true;
      }
    }
  }
}

void mouseReleased() {
  obiMoving = false;
  if (layerMoving) {
    layerMoving = false;
    int moved = layerMovedPos();
    int slMin = getSelectedMin();
    int slMax = getSelectedMax();
    println("moved " + moved + ", min "+slMin + ", max "+slMax);
    printlist();
    if (slMax+1 < moved && moved <= obiLayer.size()) {
      //println("layer up");
      for (int i=obiLayer.size()-1; i>=0; i--) {
        Obi o = obiLayer.get(i);
        if (o.isSelected) {
          int def = moved - i -1;
          Obi temp = o;
          obiLayer.remove(i);
          obiLayer.add(i+def, temp);
          moved--;
          printlist();
        }
      }
    } else if (0 <= moved && moved < slMin) {
      //println("layer down");
      for (int i=0; i<obiLayer.size(); i++) {
        Obi o = obiLayer.get(i);
        if (o.isSelected) {
          int def = moved - i;
          Obi temp = obiLayer.get(i);
          obiLayer.remove(i);
          obiLayer.add(i+def, temp);
          moved++;
          printlist();
        }
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case SHIFT:
      shiftPressed = true;
      break;

      //矢印キーで移動
    case UP:
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.moveUp();
        }
      }
      break;
    case DOWN:
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.moveDown();
        }
      }
      break;
    case LEFT:
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.moveLeft();
        }
      }
      break;
    case RIGHT:
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.moveRight();
        }
      }
      break;
    }
  } else {

    println("key "+key);
    switch(key) {
      //画面保存
    case 's':
      saveObi();
      break;

      //新規アイテム追加
    case 'q':
      addObi(0);
      break;
    case 'w':
      //addObi(1);
      break;
    case 'e':
      //addObi(2);
      break;
    case 'r':
      addObi(3);
      break;
    case 't':
      addObi(4);
      break;
    case 'y':
      addObi(5);
      break;

      //アイテム削除
    case BACKSPACE:
      removeObi();
      break;
    case DELETE:
      removeObi();
      break;

      //回転・反転・長さをリセット
    case ' ':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.init();
        }
      }
      break;

      //レイヤー移動
    case '[':
      for (int i=obiLayer.size()-1; i>=0; i--) {
        Obi o = obiLayer.get(i);
        if (o.isSelected) {
          if (i == obiLayer.size()-1) {
            break;
          }
          Obi temp = o;
          obiLayer.remove(i);
          obiLayer.add(i+1, temp);
        }
      }
      //println("layer up");
      break;
    case ']':
      for (int i=0; i<obiLayer.size(); i++) {
        Obi o = obiLayer.get(i);
        if (o.isSelected) {
          if (i == 0) {
            break;
          }
          Obi temp = obiLayer.get(i);
          obiLayer.remove(i);
          obiLayer.add(i-1, temp);
        }
      }
      //println("layer down");
      break;

      //回転
    case '<':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.rotateCtclws();
        }
      }
      break;
    case '>':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.rotateClws();
        }
      }
      break;

      //長さ変更
    case '{':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.lengthenLen();
        }
      }
      break;
    case '}':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.shortenLen();
        }
      }
      break;

      //左右反転
    case '^':
      for (Obi o : obiLayer) {
        if (o.isSelected) {
          o.flip();
        }
      }
      break;

      //bone curve
    case 'b':
      boneVisible = !boneVisible;
      println(boneVisible);
      break;

    default:
      break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case SHIFT:
      shiftPressed = false;
      break;
    }
  }
}

//----------

//新規アイテム追加
void addObi(int kind) {
  obiLayer.add(new Obi(canvas.width/2, canvas.height/2, kind, layerNum));
  deselectionAll();
  obiLayer.get(obiLayer.size()-1).isSelected = true;
  layerNum++;
}

//選択アイテム削除
void removeObi() {
  for (int i=obiLayer.size()-1; i>=0; i--) {
    Obi o = obiLayer.get(i);
    if (o.isSelected) {
      obiLayer.remove(i);
    }
  }
}

//選択全解除
void deselectionAll() {
  for (Obi o : obiLayer) {
    o.isSelected = false;
  }
}

//クリックされたものを取得
int getClickedObi() {
  for (int i=obiLayer.size()-1; i>=0; i--) {
    Obi o = obiLayer.get(i);
    if (o.isClicked()) {
      //println("return "+i);
      return i;
    }
  }
  //println("return -1");
  return -1;
}

//----------

void saveObi() {
  /*PGraphics gra = createGraphics(width, height);
   gra.beginDraw();
   for (Obi o : obiLayer) {
   o.display();
   }
   gra.endDraw();
   */
  String fileName;
  fileName = getCurrentTime();
  canvas.save(fileName + ".png");

  String[] lines = new String[obiLayer.size()];
  for (int j=0; j<lines.length; j++) {
    String[] data = new String[6];
    data[0] = str(obiLayer.get(j).kind);
    data[1] = str(obiLayer.get(j).posX);
    data[2] = str(obiLayer.get(j).posY);
    data[3] = str(obiLayer.get(j).theta);
    data[4] = str(obiLayer.get(j).len);
    data[5] = str(obiLayer.get(j).isFliped);
    lines[j] = join(data, ',');
  }
  saveStrings(fileName + ".csv", lines);
}

//画像保存のファイル名用
//日時の文字列を返す
String getCurrentTime() {
  String str = digits(month()) + digits(day()) + "-" + digits(hour()) + digits(minute()) + "-" + digits(second());
  return str;
}

//ファイル名用
//日付その他を2文字に揃える
String digits(int num) {
  String str = new String();
  if (num < 10) {
    str = "0" + num;
  } else {
    str = str(num);
  }
  return str;
}

//----------------------------------

void drawLayerMenu() {
  fill(230);
  noStroke();
  rect(lyMenuX, lyMenuY, lyMenuW, lyMenuH);

  for (int i=0; i<obiLayer.size(); i++) {
    Obi obi = obiLayer.get(i);
    int j = obiLayer.size() - i -1;

    fill(255);
    if (obi.isSelected) fill(200, 240, 200);
    stroke(100);
    strokeWeight(1);
    rect(lyMenuX, lyMenuY+j*lyBoxH, lyMenuW, lyBoxH);

    noStroke();
    fill(0);
    textSize(lyBoxH / 2);
    textAlign(LEFT, CENTER);
    text("No."+obi.num + " type"+obi.kind, lyMenuX + lyBoxH/3, lyMenuY+j*lyBoxH+lyBoxH/2);
  }

  if (layerMoving) {
    int i = layerMovedPos();
    int j = obiLayer.size() - i;
    int slMin = getSelectedMin();
    int slMax = getSelectedMax();
    //println(j);
    if (0 <= j && j <= obiLayer.size() && (i < slMin || slMax+1 < i)) {
      stroke(100, 200, 100);
      strokeWeight(4);
      noFill();
      line(lyMenuX, lyMenuY+j*lyBoxH, lyMenuX+lyMenuW, lyMenuY+j*lyBoxH);
    }
  }
}

int getClickedLayer() {
  int i = (mouseY - lyMenuY) / lyBoxH;
  int j = obiLayer.size() - i -1;
  return j;
}

int layerMovedPos() {
  int i = (mouseY - lyMenuY + lyBoxH/2) / lyBoxH;
  int j = obiLayer.size() - i;
  return j;
}

int getSelectedMin() {
  for (int i=0; i<obiLayer.size(); i++) {
    Obi o = obiLayer.get(i);
    if (o.isSelected) {
      return i;
    }
  }
  return -1;
}

int getSelectedMax() {
  for (int i=obiLayer.size()-1; i>=0; i--) {
    Obi o = obiLayer.get(i);
    if (o.isSelected) {
      return i;
    }
  }
  return -1;
}

void printlist() {
  for (Obi o : obiLayer) {
    print(o.num + " ");
  }
  println();
}