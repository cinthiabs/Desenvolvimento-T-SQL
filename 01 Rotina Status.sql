/*
	ROTINA CRIADA PARA VERIFICAR O STATUS DO PEDIDO
	Banco: eBook. 
*/

declare @pedidoid int =9
declare @status int


begin

	select @status = iidstatus from tMOVPedido where iIDPedido = @pedidoid -- atribuindo o select a variavel		

	 if(@status = 1)
			begin
				print 'Pedido '+cast(@pedidoid as varchar(20)) + ' Em aberto'
			end
		if @status = 2
			begin
				print 'Pedido '+cast(@pedidoid as varchar(20))+' Entregue'
			end
		if @status = 3
			begin
				print 'Pedido ' +cast(@pedidoid as varchar(20))+' Andamento'
			end
		if @status = 99
			begin
				print 'Pedido '+cast(@pedidoid as varchar(20))+' Cancelado'
			end	

	else if @pedidoid = null
		begin
			print 'Pedido Inexistente'
		end

end 