/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package agentsimulatorg;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;

import java.awt.Rectangle;
import java.awt.Stroke;

/**
 * class to represent a bounding box for the output
 */
public class BBox {
    
    // box thickness
    private static final float THICKNESS = (float)2.0;
    // box color
    private static final Color color = new Color(0,0,0);
    
    // window dimensions
    private final int width;
    private final int height;
    
    /* constructor to take in window size and set variables for an
     * appropriately sized box
    */
    public BBox(int _width, int _height) { width = _width; height = _height; }
    
    /* method to overrite the paintComponent method in the JComponent class */
    public void drawBox(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        Rectangle rect = new Rectangle(20, 20, width-57, height-85);
        Stroke old_stroke = g2d.getStroke();
        g2d.setStroke(new BasicStroke(THICKNESS));
        g2d.setPaint(color);
        g2d.draw(rect);
        g2d.setStroke(old_stroke);
        g2d.setPaint(Client.getDefaultColor());       // reset paint color
    }
    
}
