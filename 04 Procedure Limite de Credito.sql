
create procedure LimitCred   
  
  
@cliente int ,  
@credito smallmoney   
  
AS  
begin   
  
 if exists(select iIDCliente from tCADCliente where iIDCliente=@cliente and nTipoPessoa=1 )  
  begin  
   if @credito <= 400.00  
   begin  
    update tCADCliente   
    set mCredito=@credito  
    where iIDCliente=@cliente  
      
    select 'Limite atualizado ' +CAST(@credito as varchar(30))+ ''  
   end  
  else   
  begin   
   select 'Limite permitido para pessoa fisica R$400,00'  
  end  
     
 end  
 else if  exists(select iIDCliente from tCADCliente where iIDCliente=@cliente and nTipoPessoa=2 )  
  begin   
   if @credito <=900.00  
   begin   
   update tCADCliente   
   set mCredito = @credito  
   where iIDCliente=@credito  
     
   select 'Limite atualizado ' +CAST(@credito as varchar(30))+ ''  
  end  
  else   
  begin   
   select 'Limite permitido para pessoa Juridica R$900,00'  
  end  
  
 end  
 else if @cliente = null or @credito = null  
  begin   
   select 'Necess�rio inserir todas as informa��es.'  
  end  
  
 else  
 select 'Dados n�o encontrado.'  
  
end 