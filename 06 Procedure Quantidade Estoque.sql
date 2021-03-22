/*
	Autor: Cinthia Barbosa
	Objetivo: Atualizar quantidade de produtos no estoque
	Data: 22/03/2021
*/
create procedure AtualizarEstoque
 @estoque int, 
 @quantidade int 
as
begin 

	if exists	(select IIDestoque from	tRELEstoque where iIDEstoque=@estoque)
		 Begin transaction
			update tRELEstoque 
			set nQuantidade=@quantidade, dAlteracao=GETDATE() 
			where iIDEstoque=@estoque 

	if @@TRANCOUNT = 1
		begin
			commit tran
				select 'Dados atualizados com sucesso ' as Retorno
				Select iIDEstoque,nQuantidade,dAlteracao from tRELEstoque where iIDEstoque=@estoque
	end

	else if @@TRANCOUNT=0
		begin
		select 'Não foi possivel atualizar o estoque.' as Retorno
		end
		 
end

