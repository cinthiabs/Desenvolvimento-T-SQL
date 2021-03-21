/* Rotina para atualizar quantidade de produto na tabela tRELEstoque
*/

declare @estoque int = 36009
declare @quantidade int =71

begin 

	if exists	(select IIDestoque from	tRELEstoque where iIDEstoque=@estoque)
		begin tran 
			update tRELEstoque 
			set nQuantidade=@quantidade, dAlteracao=GETDATE() 
			where iIDEstoque=@estoque 

	if @@ROWCOUNT = 1
		begin
			commit tran
				select 'Dados atualizados com sucesso ' as Retorno
				Select iIDEstoque,nQuantidade,dAlteracao from tRELEstoque where iIDEstoque=@estoque
	end

	else if @@ROWCOUNT=0
		select 'Não foi possivel atualizar o estoque.' as Retorno
		 
end

