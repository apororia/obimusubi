class Curve {
  ArrayList<Vertex> vtx;
  //int posX, posY;
  //boolean moving;
  color col;

  Curve(color _c) {
    vtx = new ArrayList<Vertex>();
    //moving = false;
    col = _c;
  }

  //=============================================================

  Vertex getStartVtx() {
    return vtx.get(1);
  }

  Vertex getEndVtx() {
    return vtx.get(vtx.size()-2);
  }

  Vertex getStartCtrl() {
    return vtx.get(0);
  }

  Vertex getEndCtrl() {
    return vtx.get(vtx.size()-1);
  }

  //------------------------------------------------------

  void drawCurve() {
    stroke(col);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i=0; i<vtx.size(); i++) {
      curveVertex(vtx.get(i).x, vtx.get(i).y);
    }
    endShape();
  }

  void drawCurve(PGraphics g, int _x, int _y) {
    g.stroke(col);
    g.strokeWeight(2);
    g.noFill();
    g.beginShape();
    for (int i=0; i<vtx.size(); i++) {
      g.curveVertex(vtx.get(i).x + _x, vtx.get(i).y + _y);
    }
    g.endShape();
  }

  void drawCtrlLine() {
    //control point line
    stroke(col, 80);
    strokeWeight(1);
    noFill();
    line(vtx.get(0).x, vtx.get(0).y, vtx.get(1).x, vtx.get(1).y);
    int lastV = vtx.size()-1;
    line(vtx.get(lastV-1).x, vtx.get(lastV-1).y, vtx.get(lastV).x, vtx.get(lastV).y);
  }

  void drawCtrlLine(PGraphics g, int _x, int _y) {
    //control point line
    g.stroke(col, 80);
    g.strokeWeight(1);
    g.noFill();
    g.line(vtx.get(0).x + _x, vtx.get(0).y + _y, vtx.get(1).x + _x, vtx.get(1).y + _y);
    int lastV = vtx.size()-1;
    g.line(vtx.get(lastV-1).x + _x, vtx.get(lastV-1).y + _y, vtx.get(lastV).x + _x, vtx.get(lastV).y + _y);
  }

  void drawVtx() {
    noStroke();
    fill(255, 120, 100);
    //ellipse(vtx[flag].x, vtx[flag].y, 16, 16);
    fill(col);
    for (int i=0; i<vtx.size(); i++) {
      ellipse(vtx.get(i).x, vtx.get(i).y, 5, 5);
    }
  }

  //------------------------------------------

  void setVtxList(ArrayList<Vertex> _v) {
    vtx = _v;
  }

  void setVtx(int num, int _x, int _y) {
    vtx.get(num).x = _x;
    vtx.get(num).y = _y;
  }

  //------------------------------------------

  void printVtx() {
    println();
    for (int i=0; i<vtx.size(); i++) {
      println(vtx.get(i).x + ", " + vtx.get(i).y);
    }
  }
}