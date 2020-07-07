/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package agentsimulator;

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 *
 */
public class Client {

    // output directory - should be provided as a command line arg
    private static String dir;

    // the following should all be read in from the config file
    // simulation settings
    private static int MAX_ITER;
    private static int STATE;
    private static int LOG;
    private static int GRAPHICS;
    // initial state file name
    private static String init_state;
    // standard deviations
    private static double pos_stdv;
    private static double ang_stdv;
    // initial conditions
    private static int num_agents;
    private static double alpha;
    private static double perceived_weight;
    private static double threshold;
    private static double velocity;


    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException, IOException {
        // checking for output directory name in command input
        try { dir = args[0]; }
        catch (ArrayIndexOutOfBoundsException a) {
            System.err.println("Enter output directory name");
            // exit no output file provided
            System.exit(1);
        }

        // read in configuration from file
        readConfig();

        // run simulation
        simulate();
    }

    /* method to run the simulation */
    private static void simulate() throws IOException {
        // create environment
        Environment env = new Environment(num_agents, alpha, perceived_weight, threshold, velocity,
                                            pos_stdv, ang_stdv, MAX_ITER, init_state, dir);

        // begin simulation
        env.beginSim();

        // loop for MAX_ITER iterations
        for (int iter = 1; iter <= MAX_ITER; iter++) {
            // move agents
            env.moveAgents();
            // log progress (when necessary)
            if (LOG != 0 && iter % LOG == 0) { env.logProgress(); }
            // output state to file (when necessary)
            if (STATE != 0 && iter % STATE == 0 ) { env.stateToFile(); }
        }

        // terminate simulation
        env.terminateSim();
    }

    /* method to read in the .config file
     * format is expected to be
     * MAX_ITER=            - integer (maximum number of iterations for simulation)
     * STATE=               - integer (interval for writing state to file; 0 => only initial and final)
     * LOG=                 - integer (interval for writing to console/log; 0 => minimal log)
     * GRAPHICS=            - integer (interval for updating graphics window; 0 => no graphics)
     * INITIAL_STATE=       - string  (r => random distribution; anything else is interpreted as a file name)
     * POS_STDV=            - double  (standard deviation for generating position deltas from a Gaussian)
     * ANG_STDV=            - double  (standard deviation for generating angle deltas from a Gaussian)
     * NUM_AGENTS=          - integer (number of agents in the system)
     * ALPHA=               - double  (half-angle alpha for the field-of-view)
     * PERCEIVED_WEIGHT=    - double  (w in 1/(w*d) where d is distance between agents)
     * THRESHOLD=           - double  (perception threshold to move forward)
     * VELOCITY=            - double  (forward velocity of activated agents)
     */
    private static void readConfig() throws FileNotFoundException, IOException {
        // create file
        File config_file = new File(dir + "/.config");

        try {
            // create buffered reader
            BufferedReader br = new BufferedReader(new FileReader(config_file));

            // read configuration
            MAX_ITER         = Integer.parseInt(value(br.readLine()));          // read in MAX_ITER
            STATE            = Integer.parseInt(value(br.readLine()));          // read in state interval
            LOG              = Integer.parseInt(value(br.readLine()));          // read in log interval
            GRAPHICS         = Integer.parseInt(value(br.readLine()));          // read in graphics interval
            init_state       = value(br.readLine());                            // read in initial state type (r => random)
            pos_stdv         = Double.parseDouble(value(br.readLine()));        // read in pos std dev
            ang_stdv         = Double.parseDouble(value(br.readLine()));        // read in angle std dev
            num_agents       = Integer.parseInt(value(br.readLine()));          // read in number of agents
            alpha            = Double.parseDouble(value(br.readLine()));        // read in perception half-angle
            perceived_weight = Double.parseDouble(value(br.readLine()));        // read in perceived weight
            threshold        = Double.parseDouble(value(br.readLine()));        // read in perception threshold
            velocity         = Double.parseDouble(value(br.readLine()));        // read in velocity of active particles

            // close buffered reader
            br.close();

            // exit if config is invalid
            if (!validConfig()) {
                System.err.println("Invalid configuration");
                System.exit(1);
            }
        }
        catch (FileNotFoundException f) {
            System.err.println("No .config file in output directory");
            System.exit(1);
        }
    }

    /* method to return the value from a string of the form *=* */
    private static String value(String line) { return line.split("=")[1].trim(); }

    /* method to check if the configuration is valid - error messages are printed to the console */
    private static boolean validConfig(){
        boolean valid = true;
        // check for problem with MAX_ITER
        if (MAX_ITER < 1) { System.err.println("MAX_ITER must be greater than 1"); valid = false; }
        // check for problem with state interval
        if (STATE < 0) { System.err.println("STATE must be nonnegative"); valid = false; }
        // check for problem with log interval
        if (LOG < 0) { System.err.println("LOG must be nonnegative"); valid = false; }
        // check for problem with graphics interval
        if (GRAPHICS < 0) { System.err.println("GRAPHICS must be nonnegative"); valid = false; }
        // check for problem with state interval
        if (STATE < 0) { System.err.println("STATE must be nonnegative"); valid = false; }
        // check for problem with pos_stdv
        if (pos_stdv < 0) { System.err.println("POS_STDV must be nonnegative"); valid = false; }
        // check for problem with ang_stdv
        if (ang_stdv < 0) { System.err.println("ANG_STDV must be nonnegative"); valid = false; }
        // check for problem with number of agents
        if (num_agents < 0) { System.err.println("NUM_AGENTS must be nonnegative"); valid = false; }
        // check for problem with alpha
        if (alpha < 0) { System.err.println("ALPHA must be nonnegative"); valid = false; }
        // check for problem with perceived weight
        if (perceived_weight < 0) { System.err.println("PERCEIVED_WEIGHT must be nonnegative"); valid = false; }
        // check for problem with threshold
        if (threshold < 0) { System.err.println("THRESHOLD must be nonnegative"); valid = false; }
        // check for problem with velocity
        if (velocity < 0) { System.err.println("VELOCITY must be nonnegative"); valid = false; }
        // return validity of configuration
        return valid;
    }

}
