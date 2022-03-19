declare @chavenfe varchar(50),@numeronf varchar(20), @remCNPJ varchar(30),@remRazaoSocial varchar(50)
declare @destinatario varchar(50),@CPF varchar(50), @linha varchar(500), @DTHoje varchar(40)

BEGIN 

   IF OBJECT_ID('TEMPDB..##tmpTabela') IS NOT NULL DROP TABLE ##tmpTabela

  set @DTHoje = CONVERT(VARCHAR, GETDATE(), 112) 
               + CAST(DATEPART(HOUR, GETDATE()) AS VARCHAR)  
               + CAST(DATEPART(MINUTE,GETDATE()) AS VARCHAR) 


	  CREATE TABLE ##tmpTabela                    
	  (                    
	  idtexto INT IDENTITY (1, 1) NOT NULL,                    
	  texto   CHAR(160) NOT NULL                    
	  ) 

	set @linha = '01' + @DTHoje
	insert into ##tmpTabela  values (@linha)

	DECLARE tmpCursor insensitive CURSOR FOR   

		SELECT
		chave_NFE,numeroNF,remetenteCNPJ,remetenteRazaoSocial,destinatarioRazaoSocial,destinatarioCPF
		From 
		PEDIDO

	OPEN tmpCursor                    
	FETCH next FROM tmpCursor INTO @chavenfe,@numeronf,@remCNPJ,@remRazaoSocial,@destinatario,@CPF


	WHILE @@FETCH_STATUS = 0                    
	 BEGIN                    
	  set @linha ='02'
	  + @remCNPJ
	  +SPACE(2)
	  + @remRazaoSocial
	insert into ##tmpTabela  values (@linha)

	set @linha ='03'
	+@CPF
	+@numeronf
	+@chavenfe
	+SPACE(2)
	+@destinatario

	insert into ##tmpTabela  values (@linha)

   
	FETCH next FROM tmpCursor INTO  @chavenfe,@numeronf,@remCNPJ,@remRazaoSocial,@destinatario,@CPF
	end -- fim While


	CLOSE tmpCursor                    
	DEALLOCATE tmpCursor

	--Exportar Arquivo TXT
	Declare @Cmd varchar(255), @Caminho varchar(100),@Nome varchar(100)

	SET    @Caminho = 'C:\arquivo\'

	SET    @Nome = 'Arq_' +
		   + CONVERT(VARCHAR, GETDATE(), 112) + '_' +
			 CAST(DATEPART(HOUR, GETDATE()) AS VARCHAR) + '_' +
			 CAST(DATEPART(MINUTE,GETDATE()) AS VARCHAR) + '.txt'

	SET    @Cmd ='SQLCMD -S (local) -E -d DB_Cint -q "select texto from ##tmpTabela" -o "' + @Caminho + @Nome +'" -h-1'

	exec master..xp_cmdshell @Cmd
END

