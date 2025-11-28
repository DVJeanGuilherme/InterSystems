Class Treinamento.Data.Turma Extends (%Persistent, %XML.Adaptor)
{

Property Instrutor As Treinamento.Data.Instrutor [ SqlColumnNumber = 2 ];

Property DataInicio As %Date [ SqlColumnNumber = 3 ];

Property Status As %String [ SqlColumnNumber = 4 ];

Property Alunos As list Of Treinamento.Data.Aluno [ SqlColumnNumber = 5 ];

Property Curso As Treinamento.Data.Curso [ SqlColumnNumber = 6 ];

Method VerificaStatus(curso As %String) As %String [ Language = objectscript ]
{
  Set status = $$$OK   
    
  Try 
  {
        Set StatusTuma = ""
        Set SQL = "SELECT * FROM Treinamento_Data.Turma WHERE Curso->Nome = '"_curso_"'" 
        #; Set SQL = ##class(Core.XData.Base).GetXDataWithoutMimeType("consultaTurma")_"'"_curso_"'"
        Set resultSet = ##class(%ResultSet).%New()
        
        Set status = resultSet.Prepare(SQL)
        if $SYSTEM.Status.IsError(status) return status

        Set status = resultSet.Execute()
            if $SYSTEM.Status.IsError(status) return status

        if resultSet.Next()
        {

            Set StatusTuma = resultSet.%Get("Status")
        }         
    
    }
    Catch ex 
    {
        Set status= ex.AsStatus()
        Set erroMsg  = $SYSTEM.Status.GetOneErrorText(status)
        Throw ex
    }             
 Return StatusTuma
}

ClassMethod ImprimeTurma(curso As %String) As %String [ Language = objectscript ]
{
    Try {
        Set resultSet = ##class(%ResultSet).%New()
        Set sql = "SELECT ID FROM Treinamento_Data.Turma WHERE Curso->Nome = '"_curso_"'" 

        Set result = resultSet.Prepare(sql)
        Set result = resultSet.Execute()


        Set turma = ##class(Treinamento.Data.Turma).%OpenId(result)

        Set Instrutor = turma.Instrutor
        Set Curso     = turma.Curso

        Write "Curso: ", Curso.Nome,!
        Write "Instrutor: ", Instrutor.Nome,!
        Write "Status: ", turma.Status,!
   
        Write "Alunos:",!!
        Set quantidade = turma.Alunos.Count()
        
        For i=1:1:quantidade {
            Set aluno = turma.Alunos.GetAt(i)

            Write "Aluno ", i, ":",!
            Write "   Nome: ", aluno.Nome,!
            Write "   Matrícula: ", aluno.Matricula,!
            Write "   Idade: ", aluno.Idade,!!
        }
        QUIT
    }
    Catch ex 
    {
        Set status= ex.AsStatus()
        Set erroMsg  = $SYSTEM.Status.GetOneErrorText(status)
        Throw ex
    }
}

Storage Default
{
<Data name="TurmaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Instrutor</Value>
</Value>
<Value name="3">
<Value>DataInicio</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>Alunos</Value>
</Value>
<Value name="6">
<Value>Curso</Value>
</Value>
</Data>
<DataLocation>^Treinamento.Data.TurmaD</DataLocation>
<DefaultData>TurmaDefaultData</DefaultData>
<IdLocation>^Treinamento.Data.TurmaD</IdLocation>
<IndexLocation>^Treinamento.Data.TurmaI</IndexLocation>
<StreamLocation>^Treinamento.Data.TurmaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
