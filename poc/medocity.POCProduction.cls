shed			debug on
^||shed.http.accept="*/*"
Get medocity medocity.POCProduction.cls 
Class medocity.POCProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="medocity.POCProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description>POC demonstrating connectivity between Medocity and Healthshare</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HS-Medocity HTTP" Category="" ClassName="EnsLib.HTTP.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="HTTPPort">45678</Setting>
    <Setting Target="Adapter" Name="HTTPServer">127.0.0.1</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="Medocity-HS HTTP" Category="" ClassName="EnsLib.HTTP.GenericService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">medocity.MedocityToHSProcess</Setting>
    <Setting Target="Adapter" Name="Port">56789</Setting>
  </Item>
  <Item Name="EMR-HS HL7 HTTP" Category="" ClassName="EnsLib.HL7.Service.HTTPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">medocity.DataProcessor</Setting>
    <Setting Target="Adapter" Name="Port">56788</Setting>
  </Item>
  <Item Name="medocity.MedocityToHSProcess" Category="" ClassName="medocity.MedocityToHSProcess" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="medocity.DataProcessor" Category="" ClassName="medocity.DataProcessor" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MedocityEndpoint">HS-Medocity HTTP</Setting>
  </Item>
</Production>
}

}

