/**  
//  =============================================================
//
//  Purpose: builds an html pages displaying all the paths through
//           a certain COMe entry 
//
//  Usage:   http://wwwdev.ebi.ac.uk:8080/servlets/contrino/comeBY?gn=z
//
//  $Source: /homes/contrino/jserv/come/dev/RCS/comeBY.java,v $
//  $Date: 2002/05/15 11:10:58 $
//  $Author: contrino $
//
//  =============================================================
*/

// package and import declaration

import java.sql.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;


// class declaration

public class comeBY extends HttpServlet {
    
    private String dbDriver;
    private String dbURL;   
    private String dbUser;  
    private String dbPassword;  

    private String comeLink;  
    private String pathLink;  
    //    String pathLink;  



    private static final String includes   = "<font color=d222cc><b>-></b></font>";
    private static final String includeStar= "<font color=cccccc><b>-></b></font>";
    private static final String contains   = "<font color=c0c0c0><b>-></b></font>";
    private static final String binds      = "<font color=ddcc00><b>-></b></font>";


    
    private static PreparedStatement get_entry = null;
    private static PreparedStatement get_pathIDs = null;
    private static PreparedStatement get_apath = null;
    private static PreparedStatement query_date = null;
      
    static Connection con = null;

    static int entryID = 0;
    static int maxDepth = 0;            //max depth of paths (to be used for other display?)

    static String s_path = null;       //display string

    static String entryName = null;
    static Vector v_pathIDs = new Vector(50);
    static Vector v_aPath   = new Vector(50);
    static Vector v_paths   = new Vector(50);
   
    /**
    doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
	throws IOException, ServletException {
	
        String kid  = req.getParameter("gn").toUpperCase();
	res.setContentType("text/html");
	PrintWriter out = res.getWriter();       

	checkConnection();	
	try {
	    //
	    // setting up cursors
	    //
	    get_entry = con.prepareStatement
		("SELECT distinct e.name, e.id " +
		 "FROM entry e " +
		 "WHERE e.old_id = ? ");

	    get_pathIDs = con.prepareStatement
		("SELECT distinct p.path " +
		 "FROM path p " +
		 "WHERE p.id = ? ");

	    get_apath = con.prepareStatement
		("SELECT distinct p.id, e.old_id, e.name, p.rel, p.child, p.len " +
		 "FROM path p, entry e " +
		 "WHERE e.id = p.id " + 
		 "and p.path = ? " +
		 "order by len");

	    query_date = con.prepareStatement
	            ("SELECT current_date ");
	    
	    //	    
	    getID (kid);

	    int pathsTot = getPathIDs (entryID);
	    maxDepth = getPaths (v_pathIDs);

	    s_path = showPathsPlain (v_paths, v_pathIDs);

	    String HTMLheader = "<html><head>" + 
		// no underlined links
		"<style><!-- A{text-decoration:none} --></style>\n" +
		"<title>"+ kid + "</title></head>\n" + 
		"<body BGCOLOR=lightblue VLINK=darkblue ALINK=darkred>\n";
	    
	    String enHeader = "<center><h3>COMe ONtology</h3>" + 
		"<p><table><tr><th>COMe paths through " +
		kid + "</th>" +  
		"<th bgcolor=cornsilk>" + 
		entryName + "</tr></table></center>";
	    
	    out.println(HTMLheader);
	    out.println(enHeader);
	    out.println(s_path);
	    out.println("</body></html>");

	    // needed to avoid funny error...
	    v_paths.removeAllElements();
	    v_pathIDs.removeAllElements();
	}	    

	catch (SQLException sqle){
	    out.println("<i>Sorry, there was an SQLError: "+sqle+"</i>");
	}
	out.close();
    }


    static void getID (String s) throws SQLException
    {
	get_entry.setString( 1, s);
	ResultSet c_entry = get_entry.executeQuery();
	while(c_entry.next()){
	    entryName = c_entry.getString(1);
	    entryID   = c_entry.getInt(2);
	}	
    }
    
    static int getPathIDs (int entryID)
	throws SQLException
    {
	get_pathIDs.setInt( 1, entryID);
	ResultSet c_pathIDs = get_pathIDs.executeQuery();
	while(c_pathIDs.next()){
	    int pathID = c_pathIDs.getInt(1);
	    v_pathIDs.addElement (new Integer (pathID));
	}
	return v_pathIDs.size();
    }
    

    static int getPaths (Vector v)
	throws SQLException
    {
	int depth = 0;
	for ( int i=0; i < v.size(); i++)
	    {
		int j = 0;   // to count the level (nb.: len could be used..)
		get_apath.setInt( 1, ((Integer)v.get(i)).intValue());
		ResultSet c_apath = get_apath.executeQuery();
		while(c_apath.next()){
		    int  parent  = c_apath.getInt(1);
		    String pKid  = c_apath.getString(2);
		    String pname = c_apath.getString(3);
		    String ptoc  = c_apath.getString(4);
		    String child = c_apath.getString(5);
		    int  len = c_apath.getInt(6);
		    
		    Vector v_pathRecord = new Vector(50);
		    v_pathRecord.addElement(new Integer(parent));
		    v_pathRecord.addElement(new String (pKid));
		    v_pathRecord.addElement(new String (pname));
		    v_pathRecord.addElement(new String (ptoc));
		    v_pathRecord.addElement(new String (child));
		    v_pathRecord.addElement(new Integer(len));
		    
		    j++;

		    // add record
		    v_aPath.addElement (new Vector (v_pathRecord));
		}
		v_paths.addElement(new Vector (v_aPath));
		v_aPath.removeAllElements();
		// nb: pathids in correspondent v_pathIDs element
		if (j > depth ) depth = j;
	    }
	return depth;
    }


    //static String showPathsPlain (Vector v, Vector vid)
    protected String showPathsPlain (Vector v, Vector vid)
    {
	StringBuffer b_come = new StringBuffer();
	
	b_come.append ("\n<table>");
	for ( int i=0; i < v.size(); i++)
	    {
		// display path number
		b_come.append("\n<tr>");
		b_come.append("\n<td><a href=\"" + pathLink + vid.get(i) +"\" target=\"lower\">[" + vid.get(i) + "]</a>");
	
		// show the path
		Vector v1 = (Vector)v.get(i);     //i-mo path
		for ( int u=0; u < v1.size(); u++ )
		    {
			Vector v2 = (Vector)v1.get(u);
			b_come.append("<td><a href=\"" +
				      comeLink + v2.get(1) +
				      "\" target=\"lower\" onMouseOver=\"window.status='" + 
				      v2.get(2) +"'; return true\">" + v2.get(1) + 
				      "</a><td>" +relation((String)v2.get(3)));
		    }
	    }
	b_come.append ("\n</table>");
	
	String displayThis = b_come.toString();
	return displayThis;
    }
	
    static String relation (String s)
    {
	if (s.equals("includes"))  return includes;
	if (s.equals("includes*")) return includeStar;	   
	if (s.equals("contains"))  return contains;	   
	if (s.equals("binds"))     return binds;	   
	else return " ";
    }


    // various display attempts.. ============================================
    //see repository..

    //====================    
    	
    /**
       doPost is called for each POST request
    */
    public void doPost(HttpServletRequest req, HttpServletResponse res)
	throws IOException, ServletException {
	// we simply map POSTs to GETs
	doGet(req, res);
    }
    
    
    /**
       init is called once for when the servlet is requested for the
       first time.
    */
    public void init(ServletConfig config) throws ServletException {
	// call init of HttpServlet first
	super.init(config); 

	// get properties
	getProperties();

	// try to get a connection 
	dbConnect();
    }
  
    
    /**
       destroy is called once when the servlet is not required any more.
    */
    public void destroy(){
	// close any open connections
	dbDisconnect();
    }
    
    
    /**
       try to connect to the database
    */
  void dbConnect() throws ServletException {
      
      try {
	  
	  // load (and therefore register) the JDBC driver
	  // might trow a ClassNotFoundException
	  Class.forName(this.dbDriver);
	  
	  // get a connection to database
	  // might throw a SQLException
	  
	  con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
	  
	  // for debugging: report successful connection
	  log(this.getClass().getName()+": Connected");
	  
      } catch (ClassNotFoundException cnfe){
	  log("Driver not found");
	  throw new UnavailableException("Driver not found");
      } catch (SQLException sqle){
	  log("Cant connect to database");
	  throw new UnavailableException("Cant connect to database");
      } catch (Exception anything){
	  log("Other exception:" + anything);
	  throw new UnavailableException("Cant connect to database");
      } 
  }
    
    /**
    check if our connection is alive
    */
    void checkConnection() throws ServletException {
	try {
	    con.setAutoCommit(false);
	} catch (Exception ignored){
	    dbConnect();
	}
	if (con == null) 
	    throw new UnavailableException("Cant connect to database");
    }
    
  /**
     close the connection if there is one
  */
    synchronized void dbDisconnect() {
	try {
	    if (con != null){
		con.close();
		con = null;
		// for debugging: report successful connection
		log(this.getClass().getName()+": Disconnected");
	    }
	} catch (SQLException ignore){}
    }


    /**
       get properties
    */
    synchronized void getProperties() {
        try {
            // figure out the name of the props file
            String propertiesfile = "come.props";
	    
            // this approach will read from the top of any CLASSPATH entry
            InputStream is = getClass().getResourceAsStream("./" + propertiesfile);
	    	    
            Properties p = new Properties();
            // load the file into the Properties object
	                p.load(is);

            // set the properties
            this.dbDriver = p.getProperty("dbDriver");
            this.dbURL = p.getProperty("dbURL");
            this.dbUser = p.getProperty("dbUser");
            this.dbPassword = p.getProperty("dbPassword");

            this.comeLink = p.getProperty("comeLink");
            this.pathLink = p.getProperty("pathLink");
            
        } catch (Exception e) {
            throw new RuntimeException("UNABLE TO INITIALIZE, EXITING...");
        }
    }

}
