/**  
//  =============================================================
//
//  Purpose: frame based display for come ontology 
//
//  Usage:  http://wwwdev.ebi.ac.uk:8080/servlets/contrino/comeON?gn=z  
//
//
//  $Source: /ebi/microarray/l/tools/tomcat/test/webapps/contrino/come/RCS/comeON.java,v $
//  $Date: 2004/03/12 13:46:58 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: comeON.java,v $
//  Revision 1.9  2004/03/12 13:46:58  contrino
//  before cleaning
//
//  Revision 1.8  2002/04/15 13:54:12  contrino
//  still dev
//
//  Revision 1.7  2002/04/10 15:42:57  contrino
//  new thing really..(former comeBYf)
//
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

public class comeON extends HttpServlet {
        
    private String dbDriver;
    private String dbURL;   
    private String dbUser;  
    private String dbPassword;  

    private String comeLink;  
    private String allPathLink;  
    private String pathLink;  
    private String css;  
    private String home;  
    private String formulae;  
    private String dags;  
    private String footer;  

    private static PreparedStatement query_entry = null;
    private static PreparedStatement get_firstpath = null;
    private static PreparedStatement query_apath = null;
    private static PreparedStatement query_kid = null;
    private static PreparedStatement query_date = null;
      
    // some constant string for the http links
    //String blink = "http://www2.ebi.ac.uk/servlets/contrino/comeBY?gn=";
    String blink = "http://wwwdev.ebi.ac.uk:8080/servlets/contrino/comeBY?gn=";

    static Connection con = null;
    
    /**
    doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
 throws IOException, ServletException {
 
        String gn  = req.getParameter("gn").toUpperCase();


 res.setContentType("text/html");
 PrintWriter out = res.getWriter();       

 checkConnection();
 
 try {
     // setting up cursors
     get_firstpath = con.prepareStatement
  ("SELECT p.path " + 
   "FROM  path p, entry e " +
   "WHERE p.id = e.id " + 
   "and e.old_id = upper('" + gn + "')" +
   "AND rownum < 2 ");

     // getting the results
      int pathid = 0;
     ResultSet firstpath_cursor = get_firstpath.executeQuery();
     while(firstpath_cursor.next()){
  pathid = firstpath_cursor.getInt(1);
     }

     // html display
     String HTMLheader = "<html><head>" + 
  // no underlined links
  "<style><!-- A{text-decoration:none} --></style>\n" +
  "<title>"+ gn + "</title></head>\n" + 
  "<frameset rows=\"55%, 45%\" border=0>\n" + 
  "<frame src=\"" + blink + gn + "\" name=\"upper\">" +
  "<frame src=\"" + pathLink + pathid + "\" name=\"lower\">" +
  "<noframes>" +
  "Sorry, this document can be viewed only with a frame-capable browser." +
  "Please use <a href=\"" + blink + gn + "\">this other link</a>." +
  "</noframes></FRAMESET></html>";
 
     out.println(HTMLheader);
 }
 
 catch (SQLException sqle){
     out.println("<i>Sorry, there was an SQLError: "+sqle+"</i>");
 }
 out.close();
    }
    
    
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
   throw new UnavailableException("Can't connect to database");
      } catch (Exception anything){
   log("Other exception:" + anything);
   throw new UnavailableException("Can't connect to database");
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
     throw new UnavailableException("Can't connect to database");
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
            this.css = p.getProperty("css");
            this.home = p.getProperty("home");
            this.formulae = p.getProperty("formulae");
            this.dags = p.getProperty("dags");
            this.allPathLink = p.getProperty("allPathLink");
            this.pathLink = p.getProperty("pathLink");
            this.footer = p.getProperty("footer");

            
        } catch (Exception e) {
            throw new RuntimeException("UNABLE TO INITIALIZE, EXITING...");
        }
    }


}
