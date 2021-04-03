
/*
Data: 03/04/2021
Objetivo: consultar pedidos com informação do cliente e informação de descontos/cancelamento de pedido
Autor : Cinthia Barbosa 
Execução: stp_ConsultaPedido 334,1
*/


create procedure stp_ConsultaPedido 
@pedidoid int,
@tipo int --0 cliente, 1- desconto,cancelamento 
as 

BEGIN 
if @tipo =0 

select
	 p.iIDPedido    as 'Pedido'
	,c.iIDCliente   as 'IdCliente'
	,c.cNome        as 'Nome do Cliente'
	,c.cDocumento   as 'Documento'
	,p.iIDStatus    as 'Status'
	,p.dpedido      as 'Data do pedido'
	,p.dEntrega     as 'Data da entrega'
 from tMOVPedido p
 inner join tCADCliente c  on p.iIDCliente=c.iIDCliente
 where p.iIDPedido =@pedidoid

 if @tipo = 1

 select 
	  p.iIDPedido   as 'Pedido'
	 ,p.iIDStatus   as 'Status'
	 ,p.dEntrega    as 'Data da Entrega'
	 ,p.dCancelado  as 'Data do cancelamento' 
	 ,p.mDesconto   as 'Desconto'

 from tMOVPedido p
 
 where iIDPedido = @pedidoid

END


