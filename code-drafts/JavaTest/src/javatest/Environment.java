/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javatest;

import java.awt.Graphics;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.util.Random;
import javax.swing.JComponent;

/**
 * Class to represent the entire system. The environment
 * is composed of Agent objects. From a client perspective,
 * you can create, iterate, and render an environment.
 * 
 */
public class Environment extends JComponent {
    
    // window/dimensions to render state
    private static int WIDTH = 480;   private static int HEIGHT = 480;
    // bounding box
    private final BBox bbox;
    
    // random number generator
    private final Random rand;
    // scale values for Gaussian distribution (disc rand walk)
    private final double POS_STDV = 0.0005;
    private final double ANG_STDV = 0.1;
    // step size for continuous random walk
    private final double POS_STEP_SIZE = 0.0001;
    private final double ANG_STEP_SIZE = 0.1;
    
    // iterations ran so far
    private int iterations;
    
    // variables required for the environment
    private final int num_agents;
    private final double threshold;
    private final double alpha;
    private final double dist_scale;
    private final double velocity;

    // array to store the agents
    private Agent[] agents;
    
    /* constructor to instantiate agents
     * _num: number of agents
     * _alpha: half-angle for vision cone
     * _dist_scale: affects how far a agents can percieve
     * _threshold: minimum number of agents percieved to move forward
     * _velocity: forward velocity when agent is activated
    */
    Environment(int _num_agents, double _threshold, double _alpha, 
                    double _dist_scale, double _velocity) {
        // set class attributes
        num_agents = _num_agents;  threshold = _threshold;  alpha = _alpha;
        dist_scale = _dist_scale;  velocity  = _velocity;   iterations = 0;
        // set static variables in Agent class
        Agent.setAlpha(_alpha);
        Agent.setDistScale(_dist_scale);
        Agent.setVelocity(_velocity);
        // set up data
        bbox = new BBox(WIDTH, HEIGHT);                             // init bounding box
        rand = new Random(System.currentTimeMillis());              // init random
        initAgents();                                               // initialize agents
    }
    
    /* method to move the agents (random movement as well as rule movement) */
    public void moveAgents() {
        iterations++;
        gaussianRandWalk();
        //coinFlipRandWalk();
        //gravityRandWalk();
        ruleMovement();
    }
    
    /* method to paint the environment to the window */
    @Override
    public void paintComponent(Graphics g) {
        bbox.drawBox(g);
        for (int a = 0; a < agents.length; a++) { agents[a].drawAgent(g); }
    }
    
    /* method to induce a random walk using gaussian-generated
     * deltas) for each
     */
    private void gaussianRandWalk() {
        // iterate over agents
        double dx, dy, dtheta;
        for (int a = 0; a < agents.length; a++) {
            dx = rand.nextGaussian() * POS_STDV;
            dy = rand.nextGaussian() * POS_STDV;
            dtheta = rand.nextGaussian() * ANG_STDV;
            agents[a].update(dx, dy, dtheta);
        }
    }
    
    /* method to induce a random walk by having a fixed step size
     * and flipping a coin to decide the direction of the step 
     * (negative or positive)
     */
    private void coinFlipRandWalk() {
        double dx=0.0, dy=0.0, dtheta=0.0;
        int x, y, theta;
        for (int a = 0; a < agents.length; a++) {
            // generate random number \in {0, 1} (decides step direction)
            x = rand.nextInt(2);  y = rand.nextInt(2);  theta = rand.nextInt(2);
            if (x == 0)      { dx = -POS_STEP_SIZE; }
            else if (x == 1) { dx =  POS_STEP_SIZE; }
            if (y == 0)      { dy = -POS_STEP_SIZE; }
            else if (y == 1) { dy =  POS_STEP_SIZE; }
            if (theta == 0)      { dtheta = -ANG_STEP_SIZE; }
            else if (theta == 1) { dtheta =  ANG_STEP_SIZE; }
            agents[a].update(dx, dy, dtheta);
        }
    }
    
    /* method to induce a random walk by randomly generating
     * gravity wells (one for each point 
     */
    private void gravityRandWalk() {
        
    }
    
    /* method to induce rule-based movement for agents 
     *
     * NOTE: method Agent.perception(Agent q) returns 0
     *       if q is itself
     */
    private void ruleMovement() {
        // iterate over the agents
        for (int a = 0; a < agents.length; a++) {
            Agent cur = agents[a];  // current agent
            double p_strength = 0.0;     // how many particles current agent can see
            boolean activate = false;    // assume particle is inactive until proven otherwise
            // iterate over particles
            for (int i = 0; i < agents.length && !activate; i++) {
                // update p_strength
                p_strength += cur.perceptionStrength(agents[i]);  // compute perception
                if (p_strength >= threshold) { activate = true; }
            }
            // test if cur should move forward
            if (activate) { 
                cur.setActive(true);
                cur.moveForward(); 
            }
            else { cur.setActive(false); }
        }
    }
    
    // static methods to set class properties
    public static void setWidth(int length)  { WIDTH  = length; }
    public static void setHeight(int length) { HEIGHT = length; }
    
    /* method to initialize the agents in the environment */
    private void initAgents() {
        // set characteristics in Agent class
        Agent.setWidth(WIDTH);
        Agent.setHeight(HEIGHT);
        agents = new Agent[num_agents];
        double x, y, theta;
        for (int a = 0; a < agents.length; a++) {
            x = rand.nextDouble();
            y = rand.nextDouble();
            theta = 2*Math.PI*rand.nextDouble();
            agents[a] = new Agent(x, y, theta);
        }
    }
    
    /* method to output the environment to a file */
    public void toFile(String file_name) throws FileNotFoundException {
        // create output string
        String output = "Environment";
        
        // populate output string
        
        // variables for environment
        output += "\niteration,"  + iterations;
        output += "\nnum_agents," + num_agents;
        output += "\nthreshold,"  + threshold;
        output += "\nalpha,"      + alpha;
        output += "\ndist_scale," + dist_scale;
        output += "\nvelocity,"   + velocity;
        output += "\nid,x,y,theta,active";
        // output each agent to a file
        for (int a = 0; a < agents.length; a++) {
            output += "\n" + agents[a].fileInfo();
        }
        output += "\n";
        
        // output to file
        File fout = new File(file_name);
        PrintWriter writer = new PrintWriter(new FileOutputStream(fout));
        writer.write(output);
        writer.close();
        // set file as read only
        fout.setReadOnly();
    }
    
}
