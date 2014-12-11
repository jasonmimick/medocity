Include Ensemble

/// Convert HL7,... into SDA
Class medocity.DataProcessor Extends Ens.BusinessProcess [ ClassType = persistent ]
{

/// The name of the Output HTTP operation for the Medocity endpoint
Property MedocityEndpoint As Ens.DataType.ConfigName;

Parameter SETTINGS As %String = "MedocityEndpoint";

/// Will send an Ens.StreamContainer with the SDA from this HL7 to TargetConfigName
Method OnRequest(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	break
	$$$TRACE("Only supports HL7 at this time!")
	set pResponse = ##class(Ens.StringContainer).%New()
	set sc=##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest,.sdaStream)
	// Convert the SDA into JSON!
	set jstream = ##class(%Stream.GlobalCharacter).%New()
	do jstream.Write("{")
	set sda=##class(HS.SDA3.Container).%New()
	set sc=sda.InitializeXMLParse(.sdaStream)
	set sc=sda.GetNextSDA(.pType,.pSDA,.pStatus)
	while ( pType '= "" ) { //'
		do jstream.Write(""""_pType_""":")
		set sc=##class(Ens.Util.JSON).ObjectToJSONStream(pSDA,.objectStream)
		do objectStream.Rewind()
		while ( 'objectStream.AtEnd ) { //'
			do jstream.Write(objectStream.Read())
		}
		set sc=sda.GetNextSDA(.pType,.pSDA,.pStatus)
		do:(pType'="") jstream.Write(",")  //'
	}
	do jstream.Write("}")
	do jstream.Rewind()
	break
	//set sdaMessage = ##class(Ens.StreamContainer).%New()
	//set sdaMessage.Stream = jstream
	//quit:$$$ISERR(sc) sc
	if ( ..MedocityEndpoint '= "" ) { //'
		// Here we POST all the data - alternatively can just post some ID
		set httpReq = ##class(EnsLib.HTTP.GenericMessage).%New(jstream,,jstream)
		do httpReq.HTTPHeaders.SetAt("POST","HttpRequest")
		do httpReq.HTTPHeaders.SetAt("200 OK","ResponseCode")
		do httpReq.HTTPHeaders.SetAt("text/xml","Content-Type")
		do httpReq.HTTPHeaders.SetAt(sdaStream.Size,"Content-Length")
		quit ..SendRequestAsync(..MedocityEndpoint,httpReq,0)
	} else {
		// return response as XML Vdoc.
		set xdoc = ##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(sdaStream,.sc)
		set xdoc.DocType="HS.SDA3.Container:Container"
		if $$$ISERR(sc) return sc
		set pResponse = xdoc


	}
	quit $$$OK
}

<Storage name="Default">
<Data name="SDAGeneratorDefaultData">
<Subscript>"SDAGenerator"</Subscript>
<Value name="1">
<Value>TargetConfigName</Value>
</Value>
</Data>
<DefaultData>SDAGeneratorDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
</Storage>
}

