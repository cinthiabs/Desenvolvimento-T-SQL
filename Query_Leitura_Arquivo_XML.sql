
DECLARE @FileName  VARCHAR(1000)  = 'C:\arquivo\35220364963044000108550010044224291021361249-nfe.xml'                                                    

BEGIN                                     
	IF OBJECT_ID('TEMPDB..#TMPTabela_xml') IS NOT NULL DROP TABLE #TMPTabela_xml
	IF OBJECT_ID('TEMPDB..#TMP_Importa') IS NOT NULL DROP TABLE #TMP_Importa                                     
	IF OBJECT_ID('TEMPDB..#TMP_Importa_ITEMS') IS NOT NULL DROP TABLE #TMP_Importa_ITEMS                                     

                                        
	 DECLARE @XMLBASE XML, @XMLITEMS XML, @SQL VARCHAR(max), @Peso FLOAT, @Qtde INT     
                                    
             
	 SET @SQL ='SELECT  CONVERT(xml, BulkColumn, 2) XML FROM OPENROWSET(Bulk ''' + @FileName + ''', SINGLE_BLOB) [rowsetresults]; '      
      
	 CREATE TABLE #TMPTabela_xml (TEXTO xml)      
      
	 INSERT #TMPTabela_xml(TEXTO)      
	 exec (@SQL)      
       
	 SELECT TOP 1 @XMLBASE=TEXTO FROM #TMPTabela_xml      
	 SET @XMLITEMS = @XMLBASE      
      
	 ;WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe')      
      
	  SELECT       
	  right(m.cteProc.value('(NFe/infNFe/@Id)[1]','varchar(48)'),44) AS Chave_NFE,      
	  m.cteProc.query('NFe/infNFe/ide/nNF').value ('.', 'nvarchar(255)') AS NumeroNF,      
	  m.cteProc.query('NFe/infNFe/ide/serie').value ('.', 'nvarchar(255)') AS serieNFe,      
	  m.cteProc.query('NFe/infNFe/ide/tpNF').value ('.', 'nvarchar(255)') AS tpNF,      
	  m.cteProc.query('NFe/infNFe/ide/cMunFG').value ('.', 'nvarchar(255)') AS Cod_Mun,     
	  m.cteProc.query('NFe/infNFe/ide/dhEmi').value ('.', 'nvarchar(255)') AS Data_NF,      
	  m.cteProc.query('NFe/infNFe/ide/nNF').value ('.', 'nvarchar(255)') AS Documento,      
	  m.cteProc.query('NFe/infNFe/emit/CNPJ').value ('.', 'nvarchar(255)') AS remetenteCNPJ,      
	  m.cteProc.query('NFe/infNFe/emit/IE').value ('.', 'nvarchar(255)') AS remetenteIE,      
	  m.cteProc.query('NFe/infNFe/emit/xNome').value ('.', 'nvarchar(255)') AS remetenteRazaoSocial,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/xLgr').value ('.', 'nvarchar(255)') AS remetenteEndereco,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/nro').value ('.', 'nvarchar(255)') AS remetenteNum,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/xBairro').value ('.', 'nvarchar(255)') AS remetenteBairro,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/xMun').value ('.', 'nvarchar(255)') AS remetenteMunicipio,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/CEP').value ('.', 'nvarchar(255)') AS remetentecep,      
	  m.cteProc.query('NFe/infNFe/emit/enderEmit/UF').value ('.', 'nvarchar(255)') AS remetenteUF,      
	  m.cteProc.query('NFe/infNFe/dest/IE').value ('.', 'nvarchar(255)') AS destinatarioIE,      
	  m.cteProc.query('NFe/infNFe/dest/CPF').value ('.', 'nvarchar(255)') AS destinatarioCPF,      
	  m.cteProc.query('NFe/infNFe/dest/CNPJ').value ('.', 'nvarchar(255)') AS destinatarioCNPJ,      
	  m.cteProc.query('NFe/infNFe/dest/xNome').value ('.', 'nvarchar(255)') AS destinatarioRazaoSocial,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/xLgr').value ('.', 'nvarchar(255)') AS destinatarioEndereco,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/xCpl').value ('.', 'nvarchar(255)') AS destinatarioCompl,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/nro').value ('.', 'nvarchar(255)') AS destinatarioNum,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/xBairro').value ('.', 'nvarchar(255)') AS destinatarioBairro,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/cMun').value ('.', 'nvarchar(255)') AS destinatarioMunicipioID,       
	  m.cteProc.query('NFe/infNFe/dest/enderDest/xMun').value ('.', 'nvarchar(255)') AS destinatarioMunicipio,       
	  m.cteProc.query('NFe/infNFe/dest/enderDest/CEP').value ('.', 'nvarchar(255)') AS destinatariocep,      
	  m.cteProc.query('NFe/infNFe/dest/enderDest/UF').value ('.', 'nvarchar(255)') AS destinatarioUF,      
	  m.cteProc.query('NFe/infNFe/infAdic/infCpl').value ('.', 'nvarchar(255)') AS INFOADCIONAL,      
	  m.cteProc.query('NFe/infNFe/total/ICMSTot/vNF').value ('.', 'nvarchar(255)') AS valor,      
	  m.cteProc.query('protNFe/nProt').value ('.', 'nvarchar(255)') AS ReciboNF  
	  into #TMP_Importa      
	  from @xmlbase.nodes('nfeProc') as m(cteProc)      
	 ;WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe')      
      
	 SELECT @Peso = sum(m.cteProc.query('pesoB').value('.', 'float'))        
			,@Qtde = sum(m.cteProc.query('qVol').value('.', 'float'))      
	 FROM @XMLBASE.nodes('nfeProc/NFe/infNFe/transp/vol') as m(cteProc)      
      
	 ;WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe')      
	  SELECT       
	   d.det.query('prod/cProd').value('.', 'nvarchar(255)') AS Codigo,      
	   d.det.query('prod/xProd').value('.', 'nvarchar(255)') AS Produto,      
	   d.det.query('prod/vProd').value('.', 'nvarchar(255)') AS Valor      
	  INTO #TMP_Importa_ITEMS      
	  FROM @xmlitems.nodes('nfeProc/NFe/infNFe/det') as d(det)      
	 ;WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe')      
      
	 select * from #TMP_Importa 
	 select * from #TMPTabela_xml 
	 select * from #TMP_Importa_ITEMS 
END