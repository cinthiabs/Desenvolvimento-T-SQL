/* atualizando credito dos cliente  utilizando transa��es 
*/
Declare @NumeroError int 
declare @credito smallmoney 
declare @idcliente int

Begin 

--passando valores
set @idcliente = 15
set @credito = 200 -- limite de credito
set @NumeroError = @@ERROR  -- fun��o tratament de erro

   Begin transaction

   Update tCADCliente 
      Set mCredito = @credito 
    Where iidcliente = @idcliente
   

   if @@TRANCOUNT > 0 and @NumeroError > 0 
   begin
      raiserror('Desfazendo. C�digo do erro gerado %d',10,1,@NumeroError) 
      rollback
   end

   if @@TRANCOUNT > 0 and @NumeroError = 0
   begin
      raiserror('Confirmando',10,1)
      Commit
   end 

End 

--select * from tCADCliente where iidcliente = 15

