shed			debug on
^||shed.http.accept="*/*"
Get medocity medocity.PatientIDPostToGET.cls 
Class medocity.PatientIDPostToGET Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HTTP.GenericMessage ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HTTP.GenericMessage' targetClass='EnsLib.HTTP.GenericMessage' create='new' language='objectscript' >
<annotation>Convert an HTTP POST with Patient ID data into a GET</annotation>
<assign value='"foo"' property='target.HTTPHeaders' action='set' key='"URL"' />
<assign value='"GET"' property='target.HTTPHeaders' action='set' key='"HttpRequest"' />
</transform>
}

}

