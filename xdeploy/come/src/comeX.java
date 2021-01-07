/**  
//  =============================================================
//
//  Purpose: builds an html pages with a list of entries with name
//           or instance containing a certain string
//
//  Usage:   http://wwwdev.ebi.ac.uk:8080/servlets/contrino/comeIN?gn=z
//
//
//  $Source: /home/contrino/come/webapp/contrino/come/RCS/comeX.java,v $
//  $Date: 2004/03/15 15:14:30 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: comeX.java,v $
//  Revision 1.2  2004/03/15 15:14:30  contrino
//  untabified + footer
//
//  Revision 1.1  2003/05/09 15:17:11  contrino
//  Initial revision
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

public class comeX extends HttpServlet {

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

    private static PreparedStatement query_entry = null;
    private static PreparedStatement query_date = null;
    
    // some constant string for the http links
    static Connection con = null;
    
    /**
       doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException, ServletException {
        
        String gn = req.getParameter("gn");
        
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();       
        
        // print header of html page
        out.println("<html><head>" +
                    "<link rel=\"stylesheet\" href=\"" + css + "\" type=\"text/css\">" +
                    "<title>*"+ gn + "*</title></head>" 
                    + "<body BGCOLOR=lightblue VLINK=darkgreen ALINK=darkred>\n");
        
        checkConnection();
        
 try {

     String date = null;
 
     //
     // setting up cursors
     //
     query_entry = con.prepareStatement
         ("SELECT e.name, e.old_id " +
          "FROM entry e, db_xref x " +
          "WHERE upper(x.dbid) like upper('" + gn + "%')" +
          "and e.id = x.id_come " +
          "union " +
          "SELECT e.name, e.old_id " +
          "FROM entry e, db_xref x, instance i " +
          "WHERE upper(x.dbid) like upper('" + gn + "%') " +
          "and i.id_instance = x.id_come " +
          "and i.id = e.id"
          );
  
     query_date = con.prepareStatement
        ("SELECT current_date ");
     
     //
     // getting the results
     //
     
     String name     = null;
     String instance = "";
     String old_id = "";

     int cid = 0;  // counter for results (entries)
 
     // display title and header of table
     out.println("<center><table><tr><td class=\"tablegreen\">" + 
                 "<span class=\"whitetitle\">COMe query results</span></table></center>");
     out.println("<table width=\"100%\" class =\" tabletop\">" +
                 "<tr class =\" tablebody\"><td>Entries referencing " +
                 "<b><font color=\"bf0000\">"
                 + gn + "</b></font> as an external identifier. " +
                 "</tr></table>");
     
     ResultSet entry_cursor = query_entry.executeQuery();
     while(entry_cursor.next())
         {
             name = entry_cursor.getString(1);
             old_id   = entry_cursor.getString(2);
             cid++;     
             if ( cid == 1 )
                 out.println("<table width=\"100%\">");  
             out.println("<tr ><td><a href=\"" + comeLink + old_id
                         + "\">" + old_id + "</a></td>" +
                         "<td><b>" + name + "</b></td></tr>");
         }
     if ( cid == 0 )
         out.println("</table>Sorry, no record found with this name.");
     else out.println("</table><p>");   
     
     // get the date from oracle
     ResultSet date_cursor = query_date.executeQuery();
     while(date_cursor.next()){
         date         = date_cursor.getString(1);
     } 
     
     out.println("<pre>  </pre>"+ cid + " record(s) found."); 

     // footer 
     out.println(footer);
     out.println("</center><i><font class=small>This report was created:" + date + "</font></i>");
     
     out.println("</body></html>");
 }
 
 catch (SQLException sqle){
     out.println("<i>Sorry, there was an SQLError: "+sqle+"</i>");
 }
 
 out.close();
 destroy();
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
