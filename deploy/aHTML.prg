************************************************************************
*PROCEDURE aHTML
****************************
***  Function: Processes incoming Web Requests for aHTML
***            requests. This function is called from the wwServer 
***            process.
***      Pass: loServer -   wwServer object reference
*************************************************************************
LPARAMETER loServer
LOCAL loProcess
PRIVATE Request, Response, Server, Session, Process
STORE NULL TO Request, Response, Server, Session, Process

#INCLUDE WCONNECT.H

loProcess = CREATEOBJECT("aHTML", loServer)
loProcess.lShowRequestData = loServer.lShowRequestData

IF VARTYPE(loProcess)#"O"
   *** All we can do is return...
   RETURN .F.
ENDIF

*** Call the Process Method that handles the request
loProcess.Process()

*** Explicitly force process class to release
loProcess.Dispose()

RETURN

*************************************************************
DEFINE CLASS aHTML AS WWC_PROCESS
*************************************************************

*** Response class used - override as needed
cResponseClass = [WWC_PAGERESPONSE]

*** Default for page script processing if no method exists
*** 1 - MVC Template (ExpandTemplate()) 
*** 2 - Web Control Framework Pages
*** 3 - MVC Script (ExpandScript())
nPageScriptMode = 3

*!* cAuthenticationMode = "UserSecurity"  && `Basic` is default


*** ADD PROCESS CLASS EXTENSIONS ABOVE - DO NOT MOVE THIS LINE ***


#IF .F.
* Intellisense for THIS
LOCAL THIS as aHTML OF aHTML.prg
#ENDIF
 
*********************************************************************
* Function aHTML :: OnProcessInit
************************************
*** If you need to hook up generic functionality that occurs on
*** every hit against this process class , implement this method.
*********************************************************************
FUNCTION OnProcessInit

*!* LOCAL lcScriptName, llForceLogin
*!*	THIS.InitSession("myAtestpp")
*!*
*!*	lcScriptName = LOWER(JUSTFNAME(Request.GetPhysicalPath()))
*!*	llIgnoreLoginRequest = INLIST(lcScriptName,"default","login","logout")
*!*
*!*	IF !THIS.Authenticate("any","",llIgnoreLoginRequest) 
*!*	   IF !llIgnoreLoginRequest
*!*		  RETURN .F.
*!*	   ENDIF
*!*	ENDIF

*** Explicitly specify that pages should encode to UTF-8 
*** Assume all form and query request data is UTF-8
Response.Encoding = "UTF8"
Request.lUtf8Encoding = .T.


*** Add CORS header to allow cross-site access from other domains/mobile devices on Ajax calls
 Response.AppendHeader("Access-Control-Allow-Origin","*")
*!* Response.AppendHeader("Access-Control-Allow-Origin",Request.ServerVariables("HTTP_ORIGIN"))
*!* Response.AppendHeader("Access-Control-Allow-Methods","POST, GET, DELETE, PUT, OPTIONS")
*!* Response.AppendHeader("Access-Control-Allow-Headers","Content-Type, *")
*!* *** Allow cookies and auth headers
*!* Response.AppendHeader("Access-Control-Allow-Credentials","true")
*!* 
*!* *** CORS headers are requested with OPTION by XHR clients. OPTIONS returns no content
*!*	lcVerb = Request.GetHttpVerb()
*!*	IF (lcVerb == "OPTIONS")
*!*	   *** Just exit with CORS headers set
*!*	   *** Required to make CORS work from Mobile devices
*!*	   RETURN .F.
*!*	ENDIF   


RETURN .T.
ENDFUNC


FUNCTION allemployees()
TEXT TO retVal noshow
 [
    {
        name: 'Vincent Staggs',
        age: 25,
        admin: false,
        possition: WorkingPossition.JUNIOR,
    },
    {
        name: 'Tom Macinnis',
        age: 35,
        admin: true,
        possition: WorkingPossition.MANAGER
    },
    {
        name: 'Sherwood Keel',
        age: 27,
        admin: true,
        possition: WorkingPossition.PROGRAMMER
    },
    {
        name: 'Chas Stubbs',
        age: 28,
        admin: false,
        possition: WorkingPossition.EXPERT
    },
    {
        name: 'Dorian Spoon',
        age: 25,
        admin: false,
        possition: WorkingPossition.JUNIOR
    },
    {
        name: 'Paris Haag',
        age: 35,
        admin: true,
        possition: WorkingPossition.MANAGER
    },
    {
        name: 'Eddie Bohl',
        age: 27,
        admin: true,
        possition: WorkingPossition.PROGRAMMER
    },
    {
        name: 'George Downes',
        age: 28,
        admin: false,
        possition: WorkingPossition.EXPERT
    },
    {
        name: 'Sonny Mcdowell',
        age: 45,
        admin: false,
        possition: WorkingPossition.PROGRAMMER
    },
    {
        name: 'Andrew Billman',
        age: 25,
        admin: true,
        possition: WorkingPossition.MANAGER
    },
    {
        name: 'Delmar Neptune',
        age: 27,
        admin: true,
        possition: WorkingPossition.PROGRAMMER
    },
    {
        name: 'Keith Axelrod',
        age: 28,
        admin: false,
        possition: WorkingPossition.JUNIOR
    },
    {
        name: 'Maynard Hoffmeister',
        age: 25,
        admin: true,
        possition: WorkingPossition.EXPERT
    },
    {
        name: 'Sherman Browning',
        age: 35,
        admin: true,
        possition: WorkingPossition.MANAGER
    },
    {
        name: 'Christian Reber',
        age: 27,
        admin: true,
        possition: WorkingPossition.EXPERT
    },
    {
        name: 'Jewel Aceuedo',
        age: 28,
        admin: false,
        possition: WorkingPossition.EXPERT
    },
];
endtext
response.write(retVal)

ENDFUNC


*********************************************************************
FUNCTION TestPage()
************************

THIS.StandardPage("Hello World from the aHTML process",;
                  "If you got here, everything is working fine.<p>" + ;
                  "Server Time: <b>" + TIME()+ "</b>")
                  
ENDFUNC
* EOF TestPage


*********************************************************************
FUNCTION HelloScript()
************************
PRIVATE poError 

*** Configure a model and pass it into the script
*** Use this to display an ErrorDisplay object
poError = CREATEOBJECT("HtmlErrorDisplayConfig")
poError.Message = "Welcome from the " + this.Class + " class, using MVC scripting."
poError.Icon = "info"

*** Run a query and pass the data to the script
SELECT TOP 10 * FROM wwRequestLog  ;
INTO CURSOR TRequests ;
ORDER BY Time Desc

*** Render HelloScript page template
Response.ExpandScript()

USE IN TRequests
ENDFUNC
* EOF HelloScript


*************************************************************
*** PUT YOUR OWN CUSTOM METHODS HERE                      
*** 
*** Any method added to this class becomes accessible
*** as an HTTP endpoint with MethodName.Extension where
*** .Extension is your scriptmap. If your scriptmap is .rs
*** and you have a function called Helloworld your
*** endpoint handler becomes HelloWorld.rs
*************************************************************


ENDDEFINE