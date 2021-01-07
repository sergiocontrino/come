import org.xml.sax.*;
import org.apache.xerces.parsers.*;


/**Make this class implement various interfaces including
DocumentHandler, Locator, ErrorHandler, etc.  

Remember there is a helper class for the SAX API...

*/
public class refparser extends HandlerBase 
{    
    private boolean in_ol     = false;
    private boolean in_li     = false;
    private boolean in_a     = false;
    private boolean in_i     = false;
    private boolean in_b     = false;

    private int authors = -1;
    private boolean pages_follow = false;

    private boolean in_authors = false;
    private boolean in_journal = false;
    private boolean in_volume  = false;
    private boolean title_follows = false;
    private boolean medium = false;


    /**Main method 
       Usage: java mio XML_File */
    public static void main(String[] args) 
    {
	if (args.length<1) 
	    {
		System.out.println("Usage: java mio XML_File");
		System.exit(0);
	    }
	
	//Create an instance of this class.
	mio saxParser = new mio();
	
	//Call a method that takes the file name as input.
	saxParser.parse(args[0]);
    }
    
    /**This class will be where we:
       
       (i) Instantiate the XML parser.
       
       (ii) Register the document handler object, error handler, etc.
       
       (iii) Tell the XML parser to start parsing the XML file.  */
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
    }

    public void startElement(String name, AttributeList atts) 
    {
	if (name.equals("ol"))           // start of the list of reference
	    in_ol = true;

	if (name.equals("li"))           // start of a reference
	    {	   
		in_li = true;
		authors = -1;
	    }
	if (name.equals("a"))
	    {
		in_a = true;
		authors++;
	    }

	if (name.equals("i"))            // journal
	    in_i = true;

	if (name.equals("b"))            // volume
	    in_b = true;

	//	else {
	//	    in_seq=false;
	//	    in_unique_id = false;
	//	}

	//	System.out.println(name+" "+in_seq+" "+in_unique_id);
    }


    public void endElement(String name) 
    {
	if (name.equals("ol"))
	    {
		in_ol = false;
	    }
	if (name.equals("li"))
	    {
		//		System.out.println("visto: " + name);
		in_li = false;
		authors=-1;
		pages_follow= false;
	    }
	if (name.equals("a"))
	    {
		//		System.out.println("visto: " + name);
		in_a = false;
		authors++;
	    }
	if (name.equals("b"))
	    {	  
		in_b = false;
		pages_follow = true;
	    }
	if (name.equals("i"))
	    in_i = false;
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
	if (in_ol && in_i && authors > 0)
	    System.out.println("<JT>"+String.valueOf(ch, start, length).trim());
	if (in_ol && in_b)
	    System.out.println("<VO>"+String.valueOf(ch, start, length).trim());

	if (in_ol && authors==0 && in_li)
	    System.out.println("<AU>"+String.valueOf(ch, start, length).trim());

	if (in_ol && in_li && pages_follow)
	    {
		System.out.println("<PG>"+String.valueOf(ch, start, length).trim());
	System.out.println("//");
	    }
	if (in_ol &&in_li && authors==1)
	    {
	    System.out.println("<TI>"+String.valueOf(ch, start, length).trim());
	    authors++;
	    }
    }
    
    public void ignorableWhitespace(char[] ch, int start, int length) 
    {
	//System.out.println("Ignorable whitespace: <"+String.valueOf(ch, start, length)+">");
    }
}
