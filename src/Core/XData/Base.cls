Class Core.XData.Base [ Abstract ]
{

/// 
/// Criação         
/// Descrição    : Treinamento Iris InterSystems - Classe Base para manipulação de XData 
/// Desenvolvedor: Jean Tavares   
/// Dt Inclusão  : 26/11/2025    
ClassMethod GetXDataWithoutMimeType(pXDataName As %String) As %String
{
 Set tReturnQuery = ""
 
 If (pXDataName = "")
 {
  Return tReturnQuery
 }
 
 ; - Get a stream from the XData block contained on child class:
 Set tXDataID = ..%ClassName(1)_"||"_pXDataName
 Set tCompiledXData = ##Class(%Dictionary.CompiledXData).%OpenId(tXDataID)
 
 If ('$IsObject(tCompiledXData))
 {
  Return tReturnQuery
 }
 
 Set tReturnQuery = $Piece($Piece(tCompiledXData.Data.Read($$$MaxLocalLength), "<Query>", 2), "</Query>", 1)
 Set tReturnQuery = $Piece($Piece(tReturnQuery, "<![CDATA[", 2), "]]>", 1)
 
 ; - remove tab, carriage return e line feed.
 Set tReturnQuery = $Translate(tReturnQuery, $Char(9,13,10), "  ")
 
 Return tReturnQuery
}

}
