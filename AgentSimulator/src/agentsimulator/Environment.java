/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package agentsimulator;

import java.awt.Graphics;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
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
    // output directory name
    private final String output_dir;
    // log file object
    private final File log_file;
    // file containing initial state (r => random distribution)
    private final String init_state;
    
    // maximum number of iterations (never used in code, just for output)
    private final int MAX_ITER;
    
    // random number generator
    private final Random rand;
    // scale values for Gaussian distribution (disc rand walk)
    private final double pos_stdv;
    private final double ang_stdv;
    
    // iterations ran so far
    private int iterations;
    // simulation start time
    private double start;
    
    // variables required for the environment
    private final int num_agents;
    private final double alpha;    
    private final double perceived_weight;
    private final double threshold;
    private final double velocity;

    // array to store the agents
    private Agent[] agents;
    
    /* constructor to instantiate agents
     * _num_agents: number of agents
     * _alpha: half-angle for vision cone
     * _dist_scale: affects how far a agents can percieve
     * _threshold: minimum number of agents percieved to move forward
     * _velocity: forward velocity when agent is activated
     * _pos_stdv: Gaussian standard deviation for deltas in position
     * _ang_stdv: Gaussian standard deviation for deltas in orientation
     * _init_state: String to denote how to initially distribute agents
     *              - r means distribute generate all values randomly
     *              - anything else is interpreted as a file name
     * _output_dir: output directory name
    */
    Environment(int _num_agents, double _alpha, double _perceived_weight,
                    double _threshold, double _velocity,
                    double _pos_stdv, double _ang_stdv, int _MAX_ITER,
                    String _init_state, String _output_dir) throws FileNotFoundException, IOException {
        // set class attributes
        num_agents = _num_agents;  alpha = _alpha;        perceived_weight = _perceived_weight;
        threshold = _threshold;    velocity  = _velocity;
        pos_stdv = _pos_stdv;      ang_stdv = _ang_stdv;
        // output directory and log file
        output_dir = _output_dir;  log_file = new File(output_dir + "/.log");
        // initial state file and max iterations
        init_state = _init_state;  MAX_ITER = _MAX_ITER;
        // throwaway values for iterations and time
        iterations = -1;  start = -1;
        // set static variables in Agent class
        Agent.setAlpha(alpha);
        Agent.setPerceivedWeight(perceived_weight);
        Agent.setVelocity(velocity);
        // set up data
        bbox = new BBox(WIDTH, HEIGHT);                             // init bounding box
        rand = new Random(System.currentTimeMillis());              // init random
        initAgents();                                    // initialize agents
    }
    
    /* method to move the agents (random movement as well as rule movement) */
    public void moveAgents() {
        iterations++;
        gaussianBrownMotion();
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
    private void gaussianBrownMotion() {
        // iterate over agents
        double dx, dy, dtheta;
        for (int a = 0; a < agents.length; a++) {
            dx = rand.nextGaussian() * pos_stdv;
            dy = rand.nextGaussian() * pos_stdv;
            dtheta = rand.nextGaussian() * ang_stdv;
            agents[a].update(dx, dy, dtheta);
        }
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
    
    /* method to initialize the agents in the environment 
     * init_states: String to denote how to initially distribute agents
     *                - r means distribute generate all values randomly
     *                - anything else is interpreted as a file name
     */
    private void initAgents() throws FileNotFoundException, IOException {
        // set characteristics in Agent class
        Agent.setWidth(WIDTH);
        Agent.setHeight(HEIGHT);
        agents = new Agent[num_agents];
        // if initial state is randomly distributed
        if (init_state.equals("r")) {
            double x, y, theta;
            for (int a = 0; a < agents.length; a++) {
                // generate attributes
                x = rand.nextDouble();  y = rand.nextDouble();
                theta = 2*Math.PI*rand.nextDouble();
                // construct agent
                agents[a] = new Agent(x, y, theta);
            }
        }
        // otherwise interpret init_states as a file
        else { stateFromFile(init_state); }
    }
    
    /* method to begin the simulation
     *
     * this will create info.txt, write an initial state to a csv, and begin the log file
    */
    public void beginSim() throws FileNotFoundException {
        // write to readme and header file
        writeReadme();  headerToFile();
        // set environment variables
        iterations = 0;  start = System.currentTimeMillis();
        // write initial state to csv
        stateToFile("init.csv", false); // false - don't write to log
        // construct log line
        String log_line = "\nBegan Simulation\nInitial state written to file";
        // write line to log file
        PrintWriter writer = new PrintWriter(new FileOutputStream(log_file, true));
        writer.append(log_line);
        writer.close();
        // write to console
        System.out.print(log_line);
    }
    
    /* method to terminate the simulation
     *
     * this will write a final state to a csv and complete the log file
    */
    public void terminateSim() throws FileNotFoundException {
        // compute simulation time
        double end = System.currentTimeMillis();
        double time = (end-start) / 1000.0;
        
        // write final state to file
        stateToFile("final.csv", false);
        
        // construct log line
        String log_line = String.format("\nFinal state written to file"
                                            + "\nSimulation complete "
                                            + "%-7d iterations %7.0f s elapsed\n", iterations, time);
        // write line to log file
        PrintWriter writer = new PrintWriter(new FileOutputStream(log_file, true));
        writer.append(log_line);
        writer.close();
        // write to console
        System.out.print(log_line);        
    }
    
    /* method to log simulation progress info in the .log file */
    public void logProgress() throws FileNotFoundException {
        // compute time passed
        double time = (System.currentTimeMillis()-start) / 1000.0;
        // construct log line
        String log_line = String.format("\n%-7d iterations completed %7.0f s elapsed", iterations, time);
        // append to log file
        PrintWriter writer = new PrintWriter(new FileOutputStream(log_file, true));
        writer.append(log_line);
        writer.close();
        // write to console
        System.out.print(log_line);
    }
    
    /* method to write a README for this directory
     * this will make it easier for humans to understand the contents of the directory
     */
    private void writeReadme() throws FileNotFoundException {
        // set up strings for output
        String file_name = "README.md";
        String output = "This README contains information for the simulation output in this directory.";
        
        // extra info for the readme
        output += "\n\nThere are few types of files in this directory."
                + "\n * **config** - File that the jar accessed to get simulation information "
                        + "(ie initial conditions). All information to run a simulation can be found there."
                + "\n * **log** - File logging the program status throughout the simulation."
                + "\n * **header** - File containing the initial conditions for the simulation."
                + "\n * **state** - File containing the state of the system at a number of iterations (file names are "
                        + "*init.csv, final.csv,* and *INTEGER.csv*). Each state file is of the form\n"
                        + "\n        iterations,time"
                        + "\n        1,x_1,y_1,theta_1,active_1"
                        + "\n        2,x_2,y_2,theta_2,active_2"
                        + "\n         :" 
                        + "\n         :"
                        + "\n        n,x_n,y_n,theta_n,active_n";
        
        output += "\n\nThis table contains the initial conditions.\n";
        
        // populate output string
        output += "\n| Property     | Value     |";
        output += "\n|--------------|-----------|";
        output += "\n|MAX_ITER|"         + MAX_ITER         + "|";
        output += "\n|INITIAL_STATE|"    + init_state       + "|";
        output += "\n|POS_STDV|"         + pos_stdv         + "|";
        output += "\n|ANG_STDV|"         + ang_stdv         + "|";
        output += "\n|NUM_AGENTS|"       + num_agents       + "|";
        output += "\n|ALPHA| "           + alpha            + "|";
        output += "\n|PERCEIVED_WEIGHT|" + perceived_weight + "|";
        output += "\n|THRESHOLD|"        + threshold        + "|";
        output += "\n|VELOCITY|"         + velocity         + "|";
        
        // set output file
        File fout = new File(output_dir + "/" + file_name);
        PrintWriter writer = new PrintWriter(new FileOutputStream(fout));
        writer.write(output);
        writer.close();
        // set file as read only
        fout.setReadOnly();
        
        // construct log line
        String log_line = "README written to file"; // first line of log file so no \n
        // write to log file
        writer = new PrintWriter(new FileOutputStream(log_file));
        writer.append(log_line);
        writer.close();
        // write log line to console
        System.out.print(log_line);
    }
    
    /* method to output the header to a file */
    private void headerToFile() throws FileNotFoundException {
        String file_name = "header.csv";
        String output = "";
        
        // populate output string
        output += "max_iter,"         + MAX_ITER;
        output += "\ninitial_state,"    + init_state;
        output += "\npos_stdv,"         + pos_stdv;
        output += "\nang_stdv,"         + ang_stdv;
        output += "\nnum_agents,"       + num_agents;
        output += "\nalpha,"            + alpha;
        output += "\nperceived_weight," + perceived_weight;
        output += "\nthreshold,"        + threshold;
        output += "\nvelocity,"         + velocity;
        
        // set output file
        File fout = new File(output_dir + "/" + file_name);
        PrintWriter writer = new PrintWriter(new FileOutputStream(fout));
        writer.write(output);
        writer.close();
        // set file as read only
        fout.setReadOnly();
        
        // construct log line
        String log_line = "header written to file"; // first line of log file so no \n
        // write to log file
        writer = new PrintWriter(new FileOutputStream(log_file));
        writer.append(log_line);
        writer.close();
        // write log line to console
        System.out.print(log_line);
    }
    
    /* method to call stateToFile() with appropriate file name */
    public void stateToFile() throws FileNotFoundException { stateToFile(iterations + ".csv", true); }
    
    /* method to output the environment state to a file 
     * file_name is the name of the output file
     * write_to_log tells whether to write to the log that state was saved
     */
    private void stateToFile(String file_name, boolean write_to_log) throws FileNotFoundException {
        // create output string
        String output = "";
        // compute time passed
        double time = (System.currentTimeMillis()-start) / 1000.0;
        
        // populate output string
        
        // variables for environment
        output += iterations + "," + time;
        //output += "\nid,x,y,theta,active"; // not sure if should include this
        // output each agent to a file
        for (int a = 0; a < agents.length; a++) {
            output += "\n" + agents[a].fileInfo();
        }
        output += "\n";
        
        // output state to file
        File fout = new File(output_dir + "/" + file_name);
        PrintWriter writer = new PrintWriter(new FileOutputStream(fout));
        writer.write(output);
        writer.close();
        // set file as read only
        fout.setReadOnly();
        
        // check 
        if (write_to_log) {
            // log that state was put to file
            // construct log_line
            String log_line = "\nState " + iterations + " saved to file";
            // append to log file
            writer = new PrintWriter(new FileOutputStream(log_file, true));
            writer.append(log_line);
            writer.close();
            // write to console
            System.out.print(log_line);
        }
    }
    
    /* method to read the initial state of the agents (pos and orientation) from a file
     * NOTE: this file is expected to be of the form
     * 1. num_agents
     * 2. x_1,y_1,theta_1
     * .
     * .
     * n+1. x_n,y_n,theta_n
     *
     * if num_agents from the file does not equal the global variable num_agents, the 
     * program will be stopped and an error will be reported
    */
    private void stateFromFile(String file_name) throws FileNotFoundException, IOException {
        // create file object
        File fin = new File(output_dir + "/" + file_name);
        
        // construct the buffered reader
        BufferedReader br = new BufferedReader(new FileReader(fin));
        
        // string to store lines as they are read
        String line = br.readLine();
        // first line should be file length
        int len = Integer.parseInt(line);
        // test if len equals num_agents, if not: terminate
        if (len != num_agents) { 
            System.err.println("number of agents in file must be equal to NUMAGENTS in config file");
            System.exit(1);
        }
        // otherwise, read in agents from the file
        else {
            // position and orientation
            double x, y, theta;
            // iterate through file lines, createing agents
            for (int a = 0; a < agents.length; a++) {
                // read new line
                line = br.readLine();
                // split line
                String[] split_line = line.split(",");
                // parse values from line
                x = Double.parseDouble(split_line[0]);  y = Double.parseDouble(split_line[1]);
                theta = Double.parseDouble(split_line[2]);
                // construct agent
                agents[a] = new Agent(x, y, theta);
            }
        }
        
        // close buffered reader
        br.close();
    }
    
    // static methods to set class properties
    public static void setWidth(int length)  { WIDTH  = length; }
    public static void setHeight(int length) { HEIGHT = length; }
    
}
