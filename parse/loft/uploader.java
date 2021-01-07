/**  
//  =============================================================
//
//  Purpose: 
//           
//
//  Usage:   java uploader reference_file   
//
//
//  $Source$
//  $Date$
//  $Author$
//
//  _____________________________________________________________
//
//  $Log$
//
//  =============================================================
*/

import java.io.*;
import java.sql.*;
import java.util.*;

public class uploader {
  
  private static String DBUrl  = "jdbc:oracle:thin:@tonic.ebi.ac.uk:1521:PRDB1";
  private static String DBUser = "spselect";
  private static Connection con;
  private static PreparedStatement query_user = null;
  private static PreparedStatement query_date = null;

  public static void main (String argv [])
    throws IOException, SQLException, ClassNotFoundException 
  {
    String ch = argv[0];
    String ac = null;
    String date = null;
 
    // some constant string for the srslinks

    String embllink = "http://srs6.ebi.ac.uk/srs6bin/cgi-bin/wgetz?-e+[embl-acc:";

    //       System.out.println (ch);

    // connect
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
    }
    catch( Exception e ){
      e.printStackTrace();
      return;
    }
    
    try {
	con = DriverManager.getConnection(DBUrl, DBUser, DBUser);
      //            System.err.println("Connected!");

      // print header of html page
      
      System.out.println("<html><head>" + "<title>Gene set for chromosome "+ ch + "</title></head>" +"<body>\n");
      System.out.println("<!--<TABLE BORDER=0>--><TR VALIGN=\"top\" ALIGN=\"left\"><TD ></TD><TD  ALIGN=\"left\" VALIGN=\"top\"><A HREF=\"http://www.ebi.ac.uk/\"><IMG id=\"Picture1\" SRC=\"http://www.ebi.ac.uk/~contrino/imagazine/ebibanner.gif\" BORDER=0  ALT=\"Click here for EBI's Homepage\" ></A></TD></table>");
      System.out.println("<h2>Gene set for chromosome " + ch + ", according to SPTr</a></h2> \n");
      System.out.println("<br>" + "<table border=1>");

      System.out.println("<tr bgcolor=\"#C0EAC0\"><th>Gene</th><th>GDB</th><th>GeneCard</th><th>Location</th><th>Accession nr</th><th>Entry Name</th><th>MIM</th><th>Description</th><th>EMBL</th><th>InterPro</th><th>CluSTr</th></tr>");
      
      //
      // setting up cursors
      //

      query_user = con.prepareStatement
	("SELECT user from dual");

      query_date = con.prepareStatement
	  ("SELECT substr(sysdate,1,11) from dual ");

      //
      // getting the results
      //
      ResultSet user_cursor = query_user.executeQuery();
      while(user_cursor.next()){
	ac         = user_cursor.getString(1);

	/*
      ResultSet loc_cursor = query_loc.executeQuery();
      while(loc_cursor.next()){
	ac         = loc_cursor.getString(1);
	String gene       = loc_cursor.getString(2);
	String location   = loc_cursor.getString(3);

	String entry_name = null;
	String db         = null;
	String mim        = null;
	String embl       = null;

	
	// getting entry name and db
	query_user.setString( 1, ac);
	ResultSet gn_cursor = query_user.executeQuery();
	while( gn_cursor.next()){
	  System.err.println(ac);
	  db         = gn_cursor.getString(2);
	}
	*/

      ResultSet date_cursor = query_date.executeQuery();
      while(date_cursor.next()){
	date         = date_cursor.getString(1);
      }	
      // footer	
      System.out.println("<hr><table><tr><td>The user is:</td><td>"+ ac +"</td><td></tr></table>");


            System.out.println("<hr><table><tr><td>This report was created:</td><td>"+ date +"</td><td><pre>  </pre></td><td> <a href=\"mailto:contrino@ebi.ac.uk\">contrino@ebi.ac.uk</a></i></td><td><pre>  </pre></td><td ><a href=\"http://www.ebi.ac.uk/~contrino\">^</a></td></tr></table>");		   

      System.out.println("</body></html>");
      }
    }
  
    catch ( SQLException e ) {
      e.printStackTrace();
    }    
    finally {
      System.out.close();
      con.close();
      // System.err.println("Disconnected!");
    }    
  }
}

