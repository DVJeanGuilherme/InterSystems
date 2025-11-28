Class Treinamento.Data.LogMensagem Extends (%Persistent, %XML.Adaptor)
{

Property Metodo As %String [ SqlColumnNumber = 2 ];

Property Classe As %String [ SqlColumnNumber = 3 ];

Property Inicio As %String [ SqlColumnNumber = 4 ];

Property Fim As %String [ SqlColumnNumber = 5 ];

Property Status As %Boolean [ SqlColumnNumber = 6 ];

Property StatusProcesso As %String [ SqlColumnNumber = 7 ];

Property ListaLog As list Of Treinamento.VO.LogMensagem;

/// Description
ClassMethod CriarEntrada(pMetodo As %String, pClasse As %String) As Treinamento.Data.LogMensagem
{
    Set tsc = $$$OK
    Try {
        Set teste = ..%ClassName()
        Set teste1 = $ZNAME
        #Dim exception As %Exception.General = ""
        #Dim statusCode As %Status = $SYSTEM.Status.OK()
        #Dim entry As LogMensagem =..%New()
        Set entry.Metodo = pMetodo
        Set entry.Classe = pClasse
        Set entry.Inicio = $ZDATETIME($HOROLOG,4)
        Set entry.Fim = ""
        Set entry.Status = statusCode
        Set statusCode = entry.%Save()
        }
    Catch (exception)
    {   Set tSC=exception.AsStatus()
        Set erroMesg  = $SYSTEM.Status.GetOneErrorText(tSC)
        Throw exception
    }
    Return entry
}

ClassMethod Finalizar(IdLog As %Integer, StatusProcesso As %String, StatusCode As %Boolean) As Treinamento.Data.LogMensagem
{
    Set tsc = $$$OK
    Try {
        #Dim exception As %Exception.General = ""
        #Dim statusCode As %Status = $SYSTEM.Status.OK()
        #Dim entry As LogMensagem =..%New()
        Set entry = ..%OpenId(IdLog)
        Set entry.Fim = $ZDATETIME($HOROLOG,4)
        Set entry.StatusProcesso = StatusProcesso
        Set entry.Status = statusCode
        Set statusCode = entry.%Save()
        }
    Catch (exception)
    {   Set tSC=exception.AsStatus()
        Set erroMesg  = $SYSTEM.Status.GetOneErrorText(tSC)
        Throw exception
    }
    Return entry
}

Method VerificaStatus(curso As %String) As %String [ Language = objectscript ]
{
  Set status = $$$OK   
  Set Clase = $ZNAME
  Set core = ##class(Treinamento.Data.LogMensagem).%New()
    
  Try 
  {
     //Inicio Gravação Log
        Set StatusTuma = "" 
        Set StatusProcesso = "Metodo VerificaStatus Foi executado com sucesso!"
        Set pStatus = 1
        Set init = core.CriarEntrada("VerificaStatus",Clase)
        Set IdLog = init.%Id()
        
        Set SQL = "SELECT * FROM Treinamento_Data.Turma WHERE Curso->Nome = '"_curso_"'" 
        
        // Validação Base de dados e Cconsultas 
        Set resultSet = ##class(%ResultSet).%New() 
        //Prepara a query mas não executa   
         Set status = resultSet.Prepare(SQL) 
        if $SYSTEM.Status.IsError(Status) return Status
        
        //Executa query se estiver tudo certo
        Set status = resultSet.Execute()
        if $SYSTEM.Status.IsError(Status) return Status
        
        if resultSet.Next()
        {

            Set StatusTuma = resultSet.Get("Status")
        }         

    
    }
    Catch ex 
    {
        Set status= ex.AsStatus()
        Set statusErroEspc = status
        Set erroMsg  = $SYSTEM.Status.GetOneErrorText(status)
        Set pStatus = 0
        Set erro     = "IdLog :"_IdLog_" - ErroLog :"_erroMsg_" Detalhes : "_statusErroEspc
        Set fim = core.Finalizar(IdLog,erro,pStatus)       
        Throw ex
    }
     Set fim = core.Finalizar(IdLog,erro,pStatus)            
  Return StatusTuma
}

ClassMethod ConsultaLogPaginacao(pStatus As %Boolean, pLastId As %Integer, pPageSize As %Integer, pDataFim As %String) As Treinamento.VO.LogMensagem
{
       try 
        {   
            Set tSC = $$$OK
             #Dim entry        AS LogMensagem        = ..%New()
            Set SQL  = "SELECT TOP "_pPageSize_"* FROM Treinamento_Data.LogMensagem "
            Set SQL = SQL_"WHERE Status = "_pStatus 
            Set resultSet = ##class(%ResultSet).%New()
            Do resultSet.Prepare(SQL)
            Set tSC = resultSet.Execute()
            Set count = 0 
                While(resultSet.Next())
                {
                    Set count = count +1
                    Write " ID : ", resultSet.%Get("ID") , " | Metodo : ", resultSet.%Get("Metodo"), " | Classe : ", resultSet.%Get("Classe"), "| Inicio : " , resultSet.%Get("Inicio"), !
                    Write "Fim : ", resultSet.%Get("Fim"), "| Status : ", resultSet.%Get("Status"), "| StatusProcesso : ", resultSet.%Get("StatusProcesso") , ! 
                }
                If count > 0
                {
                    W "Total de log encontrados por pagina ", count, ! 
                }
                Else
                {
                W "Nenhum   log encontrados para essa pesquisa"
                }

        }
        Catch(exception)
        {
            Set tSC           = exception.AsStatus()
            Set erroMensagem  = $SYSTEM.Status.GetOneErrorText(tSC)
            Throw exception
            
        }
    return entry
}

Storage Default
{
<Data name="LogMensagemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Metodo</Value>
</Value>
<Value name="3">
<Value>Classe</Value>
</Value>
<Value name="4">
<Value>Inicio</Value>
</Value>
<Value name="5">
<Value>Fim</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>StatusProcesso</Value>
</Value>
<Value name="8">
<Value>ListaLog</Value>
</Value>
</Data>
<DataLocation>^Treinamento.Data.LogMensagemD</DataLocation>
<DefaultData>LogMensagemDefaultData</DefaultData>
<IdLocation>^Treinamento.Data.LogMensagemD</IdLocation>
<IndexLocation>^Treinamento.Data.LogMensagemI</IndexLocation>
<StreamLocation>^Treinamento.Data.LogMensagemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
