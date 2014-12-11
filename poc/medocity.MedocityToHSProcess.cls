shed			debug on
^||shed.http.accept="*/*"
Get medocity medocity.MedocityToHSProcess.cls 
/// Processes requests from Medocity to send data to downstream systems
Class medocity.MedocityToHSProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HTTP.GenericMessage' response='EnsLib.HTTP.GenericMessage' height='2350' width='2000' >
<context>
<property name='rStream' type='%GlobalCharacterStream' instantiate='1' >
<annotation><![CDATA[response stream used to build HTTP response]]></annotation>
</property>
<property name='ApiKey' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='100' />
</parameters>
</property>
<property name='getRequest' type='EnsLib.HTTP.GenericMessage' instantiate='1' >
<annotation><![CDATA[GET request to fetch patient data from Meodcity]]></annotation>
</property>
<property name='getResponse' type='EnsLib.HTTP.GenericMessage' instantiate='1' >
</property>
</context>
<sequence xend='200' yend='2100' >
<trace name='request' value='"request="_request' xpos='200' ypos='250' >
<annotation><![CDATA[Medocity POST pt id, HS GET from Medocity, builds SDA and sends down pipeline]]></annotation>
</trace>
<scope xpos='200' ypos='350' xend='200' yend='1900' >
<assign name="Get ApiKey" property="context.ApiKey" value="request.HTTPHeaders.GetAt(&quot;x-hs-apikey&quot;)" action="set" xpos='200' ypos='450' />
<trace name='ApiKey' value='"ApiKey="_context.ApiKey' xpos='200' ypos='550' />
<if name='Validate API-KEY' condition='context.ApiKey="FOO"' xpos='200' ypos='650' xend='200' yend='1650' >
<true>
<trace name='HTTP Method' value='"HTTP Method="_request.HTTPHeaders.GetAt("HttpRequest")' xpos='470' ypos='800' />
<if name='POST' condition='request.HTTPHeaders.GetAt("HttpRequest")="POST"' xpos='470' ypos='900' xend='470' yend='1550' >
<annotation><![CDATA[Handle GET here too to push data back to Medocity]]></annotation>
<true>
<trace name='URL' value='"url="_request.HTTPHeaders.GetAt("URL")' xpos='740' ypos='1050' />
<transform name='Build GET for Medocity' class='medocity.PatientIDPostToGET' source='request' target='context.getRequest' xpos='740' ypos='1150' />
<call name='GET Medocity' target='HS-Medocity HTTP' async='0' xpos='740' ypos='1250' >
<request type='EnsLib.HTTP.GenericMessage' >
<assign property="callrequest" value="context.getRequest" action="set" />
</request>
<response type='EnsLib.HTTP.GenericMessage' >
<assign property="context.getResponse" value="callresponse" action="set" />
</response>
</call>
<trace name='Response from Medocity' value='context.getResponse' xpos='740' ypos='1350' />
<assign name="200 OK" property="context.rStream.Attributes(&quot;ResponseCode&quot;)" value="&quot;200 OK&quot;" action="set" xpos='740' ypos='1450' />
</true>
<false>
<assign name="404 Not Found" property="context.rStream.Attributes(&quot;ResponseCode&quot;)" value="&quot;404 Not Found&quot;" action="set" xpos='470' ypos='1050' >
<annotation><![CDATA[GET not implemented yet]]></annotation>
</assign>
</false>
</if>
</true>
<false>
<assign name="403 Forbidden" property="context.rStream.Attributes(&quot;ResponseCode&quot;)" value="&quot;403 Forbidden&quot;" action="set" xpos='200' ypos='800' />
</false>
</if>
<faulthandlers>
<catchall name='Trap errors' xpos='200' ypos='1750' xend='200' yend='550' >
<trace name='..%Context.%LastError' value='"..%Context.%LastError="_..%Context.%LastError' xpos='200' ypos='250' />
<assign name="500 Internal Server Error" property="context.rStream.Attributes(&quot;ResponseCode&quot;)" value="&quot;500 Internal Sever Error&quot;" action="set" xpos='200' ypos='350' />
<code name='error in response body' xpos='200' ypos='450' >
<![CDATA[ set x=$system.Status.GetOneStatusText(..%Context.%LastError)
 do context.rStream.Write(x)]]>
</code>
</catchall>
</faulthandlers>
</scope>
<assign name="response HTTP" property="response" value="##class(EnsLib.HTTP.GenericMessage).%New(context.rStream,,context.rStream)" action="set" xpos='200' ypos='2000' >
<annotation><![CDATA[Build HTTP Response from context.rStream]]></annotation>
</assign>
</sequence>
</process>
}

<Storage name="Default">
<Type>%Library.CacheStorage</Type>
</Storage>
}

