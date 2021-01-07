/**  
//  =============================================================
//
//  Purpose: builds an html page displaying a COMe path
//
//  Usage:  http://www.ebi.ac.uk/servlets/contrino/comePaths?nr=z 
//
//
//  $Source: /home/contrino/come/webapp/contrino/come/RCS/comePath.java,v $
//  $Date: 2004/03/15 13:03:22 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: comePath.java,v $
//  Revision 1.5  2004/03/15 13:03:22  contrino
//  untabified
//
//  Revision 1.4  2004/03/12 13:12:42  contrino
//  changed footer
//
//  Revision 1.3  2003/03/31 14:42:35  contrino
//  before prod
//
//  Revision 1.2  2002/04/15 13:49:27  contrino
//  *** empty log message ***
//
//  Revision 1.1  2002/04/11 13:45:54  contrino
//  Initial revision
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

public class comePath extends HttpServlet {
    
    private String dbDriver;
    private String dbURL;   
    private String dbUser;  
    private String dbPassword;  
    
    private String comeLink;  
    private String allPathLink;  
    private String css;  
    private String home;  
    private String formulae;  
    private String dags;  
    private String footer;  
    
    private static PreparedStatement get_path = null;
    private static PreparedStatement get_last = null;
    private static PreparedStatement query_date = null;
      
    static Connection con = null;
    
    /**
    doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException, ServletException {
        
        String pnr = req.getParameter("nr");

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();       
        
        checkConnection();
 
try {
            
    //
    // setting up cursors
    //
     
    get_path = con.prepareStatement
        ("SELECT distinct e.name, e.old_id, p.rel, " +
         "p.id, p.child, p.len " +
         "FROM entry e, path p " +
         "WHERE p.path = " + pnr + " " +
         "AND e.id = p.id " + 
         "order by p.len ");
    
    query_date = con.prepareStatement
        ("SELECT current_date ");
            
    //
    // getting the results
    //

    int id  = 0;       // entry id
    String name    = null;    // come entry  
    String kid     = null;    // come entry  
    String rel     = null;    // come entry  
    int level = 0;
    int child = 0;
    String space   = "&nbsp;&nbsp;";
    String arrow   = "-->";
    
    String date     = null;
    StringBuffer headbuf  = new StringBuffer();
    int pathid = 0;
    StringBuffer pathbuf  = new StringBuffer();

    pathbuf.append("<class =\"subheading\">");
    StringBuffer indentbuf  = new StringBuffer();
    indentbuf.append( arrow );
    StringBuffer idbuf  = new StringBuffer();
    
    //
    // getting the results
    //
    ResultSet path_cursor = get_path.executeQuery();
    while(path_cursor.next()){
        name = path_cursor.getString(1);
        kid  = path_cursor.getString(2);
        rel  = path_cursor.getString(3);
        id   = path_cursor.getInt(4);
        child = path_cursor.getInt(5);
        level = path_cursor.getInt(6);
        
        if (level > 0) pathbuf.append( indentbuf );
        
        pathbuf.append( space + "<b>" + name + space +
                        "</b><a href=\"" + comeLink + kid + "\" target=\"upper\">" +
                        kid + "</a> ");
        if (!rel.equals("="))
            pathbuf.append("<font color=darkred> " + rel + "</font><br>\n");
        indentbuf.insert ( 0, space );
    }

     // 
     // html display
     //

    String HTMLheader = "<html><head>" + 
        "<link rel=\"stylesheet\" href=\"" + css + "\" type=\"text/css\">" +
        "<title>"+ pnr + "</title></head>"; 

    String enHeader = "<center><nobr class=\"pagetitle\">COMe path " + pnr + "</center><br>"; 
    // String enHeader = "<center><p><h4>COMe path " +
    //pnr + "</h4></center>";

    out.println(HTMLheader);
    out.println(enHeader);
    
    out.println(pathbuf.toString());
    
    // get the date from oracle
    ResultSet date_cursor = query_date.executeQuery();
    while(date_cursor.next()){
        date = date_cursor.getString(1);
     } 
    
    // footer 
    out.println(footer);
    out.println("</center><i><font class=small>This report was created:" + date + "</font></i>");
    
    out.println("</body></html>");
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
            this.footer = p.getProperty("footer");
            
        } catch (Exception e) {
            throw new RuntimeException("UNABLE TO INITIALIZE, EXITING...");
        }
    }
}
