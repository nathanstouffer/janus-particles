/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javatest;

import java.awt.Color;
import java.io.FileNotFoundException;
import javax.swing.JFrame;

/**
 *
 */
public class JavaTest {

    private final static Color default_color = new Color(0,0,0);
    private final static Color background_color = new Color(255,255,255);
    public static Color getDefaultColor() { return default_color; }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException {
        int MAX_ITER = 100000;
        // parameter information
        int num_agents = 250;
        double alpha = Math.PI / 4.0;
        double dist_scale = 1 / (2*Math.PI);
        double velocity = 0.0001;
        double threshold = ((double)num_agents) / (2.0);
        
        // set up window
        int width = 480;              int height = 480;
        Environment.setWidth(width);  Environment.setHeight(height);
        JFrame window = initWindow(width, height);
        
        double start = System.currentTimeMillis();
        
        Environment env = new Environment(num_agents, threshold, 
                                            alpha, dist_scale, velocity);
        window.add(env);
        
        for (int i = 0; i < MAX_ITER; i++) {
            if (i % (MAX_ITER / 10) == 0) { 
                double time = (System.currentTimeMillis()-start) / 1000.0;
                System.out.print(i + " iterations completed    ");
                System.out.println(String.format("%.0f s elapsed", time));
                window.repaint();
            }
            env.moveAgents();
            window.repaint();
        }
        System.out.println(MAX_ITER + " iterations completed");
        System.out.println("Simulation complete");
        
        double end = System.currentTimeMillis();
        double time = (end-start) / 1000.0;
        System.out.println(String.format("Total time elapsed: %.0f s", time));
    }
    
    /* method to initialize the window */
    private static JFrame initWindow(int width, int height) {
        JFrame window = new JFrame();
        // color
        window.getContentPane().setBackground(background_color);
        // window title
        window.setTitle("Current environment state");
        // window properties
        window.setSize(width, height);
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        window.setVisible(true);
        window.setResizable(false);
        // return window
        return window;
    }
    
}
