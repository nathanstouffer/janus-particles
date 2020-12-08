/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package agentsimulatorg;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;

/**
 * Class to represent an Agent. An agent has a position, orientation,
 * and can be drawn using the drawAgent() method
 * 
 * The position is bounded within [0,1] and is mapped to the appropriate
 * screen coordinates. Before rendering, the static variables WIDTH and 
 * HEIGHT should be given values instead of the assumed pair (100, 100)
 */
public class Agent {
    
    // static variables involving the window
    // assumed to be 100
    private static int WIDTH = 100;
    private static int HEIGHT = 100;
    // static variables for drawing the agent
    private static final int SHAPE = 0;   // 0 is circle, 1 is triangle
    private static final double H     = 0.03;       // triangle height
    private static final double HALFB = 0.01;       // triangle base
    private static final Color INACTIVECOLOR = new Color(100, 100, 100);     // inactive
    private static final Color   ACTIVECOLOR = new Color(0, 0, 255);         // active
    // static variable for id
    // actual id counts from 1 (my cs hurts)
    private static int ID_SEED = 0;
    
    // static variables for computing rule movement
    private static double ALPHA;
    private static double PERCEIVED_WEIGHT;
    private static double VELOCITY;
    
    
    private final int id;           // index for the agent
    private final double[] pos;     // position (only array address is final, elements can be changed)
    private double theta;           // orientation
    private boolean active;         // boolean indicator of activity
    private Color color;            // color
    
    /* constructor to instantiate an agent at a position 
     * and orientation
    */
    Agent(double _x, double _y, double _theta) {
        pos = new double[2];
        // set global variables
        setXPos(clamp01(_x));
        setYPos(clamp01(_y));
        theta = toAngle(_theta);
        id = ++ID_SEED;
        setActive(false);
    }
    
    /* method to return the perception strenght of the query agent 
     * 
     * first we test if the query is in the fov of this agent,
     * we then scale 1/d (the distance) by the PERCEIVED_WEIGHT
     * and return
     *
     * @return if agent is itself:  0
     *         if not visible:      0
     *         if visible:          r \in R (how "percieved" it is)
     */
    public double perceptionStrength(Agent query) {
        // return 0 if agent is itself
        if (id == query.getID()) { return 0.0; }
        // vector in direction of query agent
        double dist_sqrd = dot(vecTo(query), vecTo(query));
        // return 0.0 if distance is 0
        if (dist_sqrd == 0.0) { return 0.0; }
        // return 0.0 if not visible
        if (!visible(query)) { return 0.0; }
        else { 
            // we now return the perception strength: 1 / (PERCEIVED_WEIGHT * dist_sqrd)
            return 1 / (PERCEIVED_WEIGHT * Math.sqrt(dist_sqrd));
        }
    }
        
    /* method to update the pos and orientation of the agent (via addiation) */
    public void update(double dx, double dy, double dtheta) {
        setXPos(clamp01(getXPos()+dx));
        setYPos(clamp01(getYPos()+dy));
        theta = toAngle(theta+dtheta);
    }
    
    /* method to move forward computations are made according 
     * to VELOCITY and theta 
     */
    public void moveForward() {
        setXPos(clamp01(getXPos()+VELOCITY*Math.cos(theta)));
        setYPos(clamp01(getYPos()+VELOCITY*Math.sin(theta)));
    }
    
    /* method to paint the agent in the window */
    public void drawAgent(Graphics g) {
        switch (SHAPE) {
            case 0:     // circle
                drawCircle(g);
                break;
            case 1:     // triangle
                drawTriangle(g);
                break;
            default:
                System.err.println("Shape unspecified");
                break;
        }
    }
    
    /* method to compute whether a is visible to this agent */
    private boolean visible(Agent query) {
        double[] gaze_dir = gazeDir();      // vector in the view direction of this agent
        double[] q_dir = vecTo(query);      // vector in direction of a
        // compute dot product of normed vectors
        double dot = dot(norm(gaze_dir), norm(q_dir));
        // test if query is in fov
        if (dot >= Math.cos(ALPHA)) { return true; }
        else { return false; }
    }
    
    /* method to compute the dot product of the two vectors (as arrays) */
    private double dot(double[] v1, double[] v2) {
        assert v1.length == v2.length : "vectors are of different length";
        double dot = 0.0;
        for (int v = 0; v < v1.length; v++) { dot += (v1[v] * v2[v]); }
        return dot;
    }
    
    /* method to compute and return the normed input vectord (as an array) */
    private double[] norm(double[] v) {
        // ensure v is not the 0 vector
        boolean zero = true;
        for (int i = 0; i < v.length && zero; i++) { if (v[i] != 0.0) { zero = false; } }
        if (zero) { System.err.println("Can't norm the zero vector");  return v; }
        double[] norm = new double[2];          // will be normed vector
        double mag = Math.sqrt(dot(v, v));      // magnitude
        // iterate over components
        for (int i = 0; i < v.length; i++) { norm[i] = v[i] / mag; }
        return norm;
    }
    
    /* method to compute the vector to the query Agent 
     * NOTE: not normed
     */
    private double[] vecTo(Agent a) { 
        return new double[] { a.getXPos()-getXPos(), a.getYPos()-getYPos() }; 
    }
    
    /* method to compute the current gaze direction of this agent 
     * NOTE: this is a normal vector
     */
    private double[] gazeDir() { return new double[] { Math.cos(theta), Math.sin(theta) }; }
    
    /* method to clamp values between 0 and 1 */
    private double clamp01(double d) {
        if (d > 1.0) { return 1.0; }
        if (d < 0.0) { return 0.0; }
        else { return d; }
    }
    
    /* method to compute equivalent angles in [0, 2 pi ) */
    private double toAngle(double d) {
        // loop until less than 2 pi
        while (d >= 2*Math.PI) { d -= 2*Math.PI; }
        // loop until greater than 0
        while (d < 0.0)        { d += 2*Math.PI; }
        // return d
        return d;
    }
    
    // setter methods
    public void setActive(boolean act) {
        active = act;
        if (act) { color = ACTIVECOLOR; }
        else { color = INACTIVECOLOR; }
    }
    private void setXPos(double x) { pos[0] = x; }
    private void setYPos(double y) { pos[1] = y; }
    
    // getter methods
    public double getXPos() { return pos[0]; }
    public double getYPos() { return pos[1]; }
    public int getID() { return id; }
    
    /* methods to compute the box coordinates for query variables */
    // Circles ---- x: (23, 58) and y: (23, 86)
    // Triangles -- x: (31, 66) and y: (31, 94)
    private int toBoxX(double x) { 
        switch (SHAPE) {
            case 0:     // circles
                return toBoxXCircles(x);
            case 1:     // triangles
                return toBoxXTriangles(x);
            default:
                System.err.println("invalid shape " + SHAPE);
                break;
        }
        return -1;
    }
    private int toBoxY(double y) { 
        switch (SHAPE) {
            case 0:     // circles
                return toBoxYCircles(y);
            case 1:     // triangles
                return toBoxYTriangles(y);
            default:
                System.err.println("invalid shape " + SHAPE);
                break;
        }
        return -1;
    }
    
    // methods to compute box coordinates for specific shapes
    private int toBoxXCircles(double x)   { return 23 + ((int)( (WIDTH-58)*x)); }
    private int toBoxYCircles(double y)   { return 23 + ((int)((HEIGHT-86)*y)); }
    private int toBoxXTriangles(double x) { return 31 + ((int)( (WIDTH-66)*x)); }
    private int toBoxYTriangles(double y) { return 31 + ((int)((HEIGHT-94)*y)); }
    
    // static methods to set class properties
    public static void setWidth(int length)  { WIDTH  = length-12; }
    public static void setHeight(int length) { HEIGHT = length-12; }
    public static void setAlpha(double alpha) { ALPHA = alpha; }
    public static void setPerceivedWeight(double perc_weight) { PERCEIVED_WEIGHT = perc_weight; }
    public static void setVelocity(double velocity) { VELOCITY = velocity; }
    
    // OUTPUT STUFF
    
    /* method to draw the agent as a circle */
    private void drawCircle(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setPaint(color);                            // set paint color
        g2d.fill(new Ellipse2D.Double(toBoxX(getXPos()), toBoxY(getYPos()), 7, 7));
        g2d.setPaint(Client.getDefaultColor());       // reset paint color
    }
    
    /* methd to draw the agent as a triangle */
    private void drawTriangle(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        g2d.setPaint(color);                            // set paint color
        g2d.fill(triangPath());
        g2d.setPaint(Client.getDefaultColor());       // reset paint color
    }
    
    private Path2D triangPath() {
        int[][] points = triangPoints();
        Path2D path = new Path2D.Double();
        path.moveTo(points[0][0], points[0][1]);
        for (int p = 1; p < points.length; p++) {
            path.lineTo(points[p][0], points[p][1]);
        }
        path.closePath();
        return path;
    }
    
    /* method to return the coordinates of the triangle 
     * array is of the form { {x, y}, {x, y} ... {x, y} }
    */
    private int[][] triangPoints() {
        int[][] points = new int[4][];
        points[0] = new int[] { toBoxX(getXPos()-HALFB*Math.sin(theta)), 
                                toBoxY(getYPos()+HALFB*Math.cos(theta)) };
        points[1] = new int[] { toBoxX(getXPos()+H*Math.cos(theta)),
                                toBoxY(getYPos()+H*Math.sin(theta))};
        points[2] = new int[] { toBoxX(getXPos()+HALFB*Math.sin(theta)), 
                                toBoxY(getYPos()-HALFB*Math.cos(theta)) };
        points[3] = new int[] { toBoxX(getXPos()-HALFB*Math.sin(theta)), 
                                toBoxY(getYPos()+HALFB*Math.cos(theta)) };
        return points;
    }
    
    /* method to return information required for the file */
    public String fileInfo() {
        // return string of the form "id,x,y,theta,active"
        String a = "0";
        if (active) { a = "1"; }
        return id + "," + getXPos() + "," + getYPos() + "," + theta + "," + a;
    }
    
    /* to string method */
    @Override
    public String toString() {
        String ret = "Agent " + id + ":\n";
        ret += "pos: (" + getXPos() + ", " + getYPos() + ")\n";     // pos
        ret += "theta: " + theta + "\n";            // orientation
        ret += "active: ";
        if (active) { ret += "1"; }
        else { ret += "0"; }
        ret += "\n";
        return ret;
    }
    
}
