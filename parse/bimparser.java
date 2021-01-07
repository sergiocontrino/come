/**
//  =============================================================
//
//  Purpose: parse come xml files
//           
//
//  Usage:   java bimp[arser file.xml
//
//
//  $Source: /homes/contrino/come/parse/RCS/bimparser.java,v $
//  $Date: 2001/08/08 14:06:18 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: bimparser.java,v $
//  Revision 1.8  2001/08/08 14:06:18  contrino
//  changed field separator
//
//  Revision 1.7  2001/07/26 08:47:11  contrino
//  debug: added again the output forprotein terms (needed for dbx)
//
//  Revision 1.6  2001/07/24 11:02:08  contrino
//  *** empty log message ***
//
//  Revision 1.5  2001/06/15 16:19:34  contrino
//  ?
//
//  Revision 1.4  2001/06/13 16:16:56  contrino
//  working version with relationship parsing.
//  need cleaning, comments and test.
//
//
//  =============================================================
*/


import org.xml.sax.*;
import org.apache.xerces.parsers.*;


/**Make this class implement various interfaces including
DocumentHandler, Locator, ErrorHandler, etc.  

Remember there is a helper class for the SAX API...

*/
public class bimparser extends HandlerBase 
{    
    private boolean in_substructure     = false;
    private boolean in_bim              = false;
    private boolean in_term             = false;
    private boolean in_instance         = false;
    private boolean untermed_bim        = true;
    private boolean first_term          = true;
    private boolean bim                 = false;

    private int instance_count =0;

    private String  o_id       = "-";     // all
    private String  o_name     = "-";     // bim, mol
    private String  o_term     = "-";     // bim, mol
    private String  o_instance = "-";     // pr
    private String  o_dbx      = "-";     // all
    private String  o_rx       = "-";     // all
    private String  o_coord    = "-";     // bim
    private String  o_species  = "-";     // pr
    private String  o_state    = "-";     // pr
    private String  o_centre   = "-";     // pr

    private String  o_rel      = "-";     // relation
    private String  rel_site   = "-";     // substructure, term, instance, bim(?) 

    private static String  S = "%";

    /**Main method 
       Usage: java bimparser XML_File */
    public static void main(String[] args) 
    {
	if (args.length<1) 
	    {
		System.out.println("Usage: java bimparser XML_File");
		System.exit(0);
	    }
	
	//Create an instance of this class.
	bimparser saxParser = new bimparser();
	
	//Call a method that takes the file name as input.
	saxParser.parse(args[0]);
    }
    
    /**This class will be where we:
       (i) Instantiate the XML parser.
       (ii) Register the document handler object, error handler, etc.
       (iii) Tell the XML parser to start parsing the XML file.  
    */

    public void parse(String file) 
    {
	//Constructor for the xml4j validating SAX parser.
	//ValidatingSAXParser myParser = new ValidatingSAXParser();
	SAXParser myParser = new SAXParser();
	
	//Register the DocumentHandler object with the parser.
	myParser.setDocumentHandler(this);
	
	//Parse the file - As it is read, it will fire off calls to
	//the appropriate registered objects.
	try 
	    {
		myParser.parse(file);
	    } 
	catch (SAXException ex) {System.out.println("SAXException"+ex);}
	catch (java.io.IOException ex) {System.out.println("IOEXception:"+ex);}
    }
    
    public void startDocument () 
    {
	System.out.println("Start doc" );
}

    public void startElement(String name, AttributeList atts) 
    {
	if (name.equals("substructure"))  
	    in_substructure = true;

	if (name.equals("bim"))           
	    {	   
		in_bim = true;
		bim = true;
	    }
	if (name.equals("term"))
	    {
		// to print MOL data in substructure
		if ( in_bim ) untermed_bim = false;
		if ( bim == false ) 
		    if ( in_substructure && first_term)
			System.out.println( o_id +S+ o_name +S+ o_term +S+ o_instance +S+ o_dbx +S+ o_rx +S+ o_coord +S+ o_species +S+ o_state +S+ o_centre );
		in_term = true;
		first_term = false;
	    }

	if (name.equals("instance"))          
	    {
		// to print data in term
		if ( in_term && instance_count == 0 )
		    System.out.println(o_id +S+ o_name +S+ o_term +S+ o_instance +S+ o_dbx +S+ o_rx +S+ o_coord +S+ o_species +S+ o_state +S+ o_centre );
		in_instance = true;
		instance_count ++;
	    }

    	for (int i = 0; i < atts.getLength(); i++)
	    {
		if ( atts.getName(i).equals("id") ) 
		    o_id = atts.getValue(i);
		if ( atts.getName(i).equals("value") && in_term ) 
		    o_term = atts.getValue(i);
		if ( atts.getName(i).equals("name") )
		    o_name = atts.getValue(i);
		if ( atts.getName(i).equals("inst") )
		    o_instance = atts.getValue(i);
		if ( atts.getName(i).equals("dbxref") ) 
		    o_dbx = atts.getValue(i);
		if ( atts.getName(i).equals("lref") ) 
		    o_rx = atts.getValue(i);

		if ( atts.getName(i).equals("coordination") ) 
		    o_coord = atts.getValue(i);
	       
		// these only for prx
		if ( atts.getName(i).equals("species") ) 
		    o_species = atts.getValue(i);
		if ( atts.getName(i).equals("state") ) 
		    o_state = atts.getValue(i);
		if ( atts.getName(i).equals("centre") ) 
		    o_centre = atts.getValue(i);
	    }
    }
    
    
    public void endElement(String name) 
    {
	if (name.equals("substructure"))
	    {
		//needed for bim!!
		if ( untermed_bim == true )
		    System.out.println( o_id +S+ o_name +S+ o_term +S+ o_instance +S+ o_dbx +S+ o_rx +S+ o_coord +S+ o_species +S+ o_state +S+ o_centre );
		reset();
		//reset_output();
		//in_substructure = false;
	    }

	if (name.equals("bim"))
	    {
		in_bim = false;
	    }

	if (name.equals("term"))
	    { if (instance_count == 0 )
		System.out.println( o_id +S+ o_name +S+ o_term +S+ o_instance +S+ o_dbx +S+ o_rx +S+ o_coord +S+ o_species +S+ o_state +S+ o_centre );

	    //end of the entry if it is a protein (no substructure)
	    if ( in_substructure == false ) reset();
	    else
		{
		reset_output();
		in_term = false;
		untermed_bim = false;
		}
	    }

	if (name.equals("instance"))
	    {
		System.out.println( o_id +S+ o_name +S+ o_term +S+ o_instance +S+ o_dbx +S+ o_rx +S+ o_coord +S+ o_species +S+ o_state +S+ o_centre );
		reset_output();
		in_instance = false;
	    }
    }

    //    public void startElement(String name, AttributeList atts) {
    //	System.out.println("Hit a start element: "+name);
    //	for (int i = 0; i < atts.getLength(); i++)
    //	    System.out.println("  Attribute: "+
    //			       atts.getName(i)+"= \""+
    //			       atts.getValue(i)+"\" : "+
    //			       atts.getType(i));
    //    }

    

    public void characters(char[] ch, int start, int length) 
    {
	// todo: rel..
	if ( in_substructure && in_bim ) //?
	    {
		o_name = String.valueOf(ch, start, length).trim();
	    }
	else o_rel = String.valueOf(ch, start, length).trim().replace('\n', '%');

	// set the relationship site
	if ( in_substructure ) rel_site = "S"; 
	if ( in_term ) rel_site = "T"; 
	if ( in_instance ) rel_site = "I"; 
	if ( in_bim ) rel_site = "B";      //? prob not allowed

	// print relationship
	if ( o_rel.length() > 1 )	
	    System.out.println("REL" +S+ o_id +S+ rel_site +S+ o_rel );
    }
    
    public void ignorableWhitespace(char[] ch, int start, int length) 
    {
	//System.out.println("Ignorable whitespace: <"+String.valueOf(ch, start, length)+">");
    }


    public void endDocument () 
    {
	System.out.println("End doc" );

}

    public void reset_output () 
    {
	//o_name     = "-";     // bim, mol
	//o_term     = "-";     // bim, mol
	o_instance = "-";     // pr
	o_dbx      = "-";     // all
	o_rx       = "-";     // all
	o_coord    = "-";     // bim
	o_species  = "-";     // pr
	o_state    = "-";     // pr
	o_centre   = "-";     // pr
    }

    public void reset () 
    {
	/** 
	    reset all to the initial value
	*/

	o_name     = "-";     
	o_term     = "-";     
	o_instance = "-";
	o_dbx      = "-";     
	o_rx       = "-";     
	o_coord    = "-";     
	o_species  = "-";     
	o_state    = "-";     
	o_centre   = "-";     

	o_rel      = "-";     
	rel_site   = "-";     
	
	in_substructure     = false;
	in_bim              = false;
	in_term             = false;
	in_instance         = false;
	untermed_bim        = true;
	first_term          = true;
	bim                 = false;
	
	instance_count =0;
    }
}
