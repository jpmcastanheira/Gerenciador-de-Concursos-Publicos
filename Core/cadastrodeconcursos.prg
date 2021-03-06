DEFINE CLASS CadastroDeConcursos as CUSTOM

	dDataProva = {}
	cEndereco = ''
	cComplemento = ''
	cHoraProva = ''
	nSalario = 0.00
	dVencimentoBoleto = {}
	nValorInscricao = 0.00
	cBanco = ''
	cObservacao = ''
	cConcurso = ''
	cCargo = ''
	nAlerta = 0
	dHomologacao = {}
	cLink = ''
	cPdf = ''
	
	cIncluindoEditando = ''
	nID = 0
	
	PROTECTED FUNCTION _CamposVazios
	
		RETURN 	EMPTY(THIS.dDataProva) AND EMPTY(THIS.cEndereco) AND EMPTY(THIS.cComplemento) AND EMPTY(THIS.cHoraProva) AND EMPTY(THIS.nSalario) ;
				AND EMPTY(THIS.dVencimentoBoleto) AND EMPTY(THIS.nValorInscricao)AND EMPTY(THIS.cBanco) AND EMPTY(THIS.cObservacao);
				AND EMPTY(THIS.cConcurso) AND EMPTY(THIS.cCargo) AND EMPTY(THIS.dHomologacao) AND EMPTY(THIS.cLink) AND EMPTY(THIS.cPdf)
	
	ENDFUNC && _CamposVazios
	
	FUNCTION Gravar
		
		LOCAL llRetorno
		llRetorno = .T.
		
		IF !THIS._CamposVazios()
		
			THIS._FormatarCampos()
		
			IF this.cIncluindoEditando == 'E'
				
				UPDATE Concursos SET DataProva = this.dDataProva, Endereco = this.cEndereco, compl = this.cComplemento, horaprova = this.cHoraProva,;
					salario = this.nSalario, vencimento = this.dVencimentoBoleto, inscricao = this.nValorInscricao, banco = this.cBanco, obs = this.cObservacao, ;
					concurso = this.cConcurso, cargo = this.cCargo, Alerta = this.nAlerta, homol = this.dHomologacao, link = this.cLink, pdf = this.cPdf ;
					WHERE id = this.nID
			
			ELSE
			
				INSERT INTO Concursos (IDUsuario, dataprova, endereco, compl, horaprova, salario, vencimento, inscricao, banco, ;
										obs,concurso, cargo, Alerta, homol, link, pdf);
				VALUES	(poPessoa.nID, this.dDataProva, this.cEndereco, this.cComplemento, this.cHoraProva,;
						this.nSalario, this.dVencimentoBoleto, this.nValorInscricao, this.cBanco, this.cObservacao,;
						this.cConcurso, this.cCargo, this.nAlerta, this.dHomologacao, this.cLink, this.cPdf)
				
			ENDIF
		ELSE
			MESSAGEBOX('Preencha ao menos um campo (al�m do alerta).')
			llRetorno = .F.
		ENDIF
					
		RETURN llRetorno

	ENDFUNC
	
	FUNCTION _FormatarCampos()
		THIS.cEndereco = ALLTRIM(UPPER(LEFT(THIS.cEndereco,1)) + RIGHT(THIS.cEndereco,LEN(THIS.cEndereco)-1))
		THIS.cComplemento = ALLTRIM(UPPER(LEFT(THIS.cComplemento ,1)) + RIGHT(THIS.cComplemento ,LEN(THIS.cComplemento )-1))
		THIS.cBanco = ALLTRIM(UPPER(LEFT(THIS.cBanco,1)) + RIGHT(THIS.cBanco,LEN(THIS.cBanco)-1))
		THIS.cConcurso = ALLTRIM(UPPER(LEFT(THIS.cConcurso,1)) + RIGHT(THIS.cConcurso,LEN(THIS.cConcurso)-1))
		THIS.cCargo = ALLTRIM(UPPER(LEFT(THIS.cCargo,1)) + RIGHT(THIS.cCargo,LEN(THIS.cCargo)-1))
	ENDFUNC
	
	FUNCTION ValidarDinheiro(tnValor)

		LOCAL llRetorno
		llRetorno = .T.

		IF !EMPTY(tnValor) AND tnValor < 0
			MESSAGEBOX('Valor negativo inv�lido!')
			llRetorno = .F.
		ENDIF
		
		IF tnValor > 9999999999999.00
			MESSAGEBOX('Valor muito grande.')
			llRetorno = .F.
		ENDIF
		
		RETURN llRetorno
	ENDFUNC

	FUNCTION ValidarData(tdData, tlDataFutura)
		
		LOCAL llRetorno
		llRetorno = .T.

		IF this.cIncluindoEditando == 'I' AND !EMPTY(tdData) AND tdData < DATE()
			
			IF tlDataFutura
				llRetorno = (MESSAGEBOX('Data inferior a data atual, deseja incluir?',4) = 6)
			ELSE
				MESSAGEBOX('Data inferior a data atual!')
				llRetorno = .F.
			ENDIF
			
		ENDIF
		
		RETURN llRetorno
	ENDFUNC
	
	FUNCTION ValidarDataHomologacao(tdDataHomol, tdDataProva)
		
		LOCAL llRetorno
		llRetorno = .T.
		
		IF !EMPTY(tdDataHomol) AND !EMPTY(tdDataProva)
			IF tdDataHomol < tdDataProva
				MESSAGEBOX('Data de homologa��o inferior a data da prova!')
				llRetorno = .F.	
			ENDIF
		ENDIF

		RETURN llRetorno

	ENDFUNC
	
	FUNCTION ValidarDataVencimento(tdDataVencimento, tdDataProva)
		
		LOCAL llRetorno
		llRetorno = .T.
		
		IF !EMPTY(tdDataVencimento) AND !EMPTY(tdDataProva)
			IF tdDataVencimento > tdDataProva
				MESSAGEBOX('Data do vencimento do boleto � superior a data da prova!')
				llRetorno = .F.	
			ENDIF
		ENDIF
		
		RETURN llRetorno

	ENDFUNC	
	
	FUNCTION ValidarHora (tcHora)
		
		LOCAL llRetorno
		llRetorno = .T.
	
		DO CASE
			CASE EMPTY(LEFT(tcHora,2)) AND EMPTY(RIGHT(tcHora,2)) && S� valida se n�o for hora vazia.
				llRetorno = .T.
				
			CASE EMPTY(LEFT(tcHora,1)) OR EMPTY(SUBSTR(tcHora,2,1)) OR EMPTY(SUBSTR(tcHora,4,1)) OR EMPTY(RIGHT(tcHora,1)) && Alguma casa vazia, ex: x :yz
				llRetorno = .F.
				
			CASE VAL(LEFT(tcHora,1)) > 2 && Ex: 3x:yz
				llRetorno = .F.
				
			CASE VAL(LEFT(tcHora,1)) = 2 AND VAL(SUBSTR(tcHora,2,1)) > 3 && Ex: 26:xy
				llRetorno = .F.
				
			CASE VAL(SUBSTR(tcHora,4,1)) > 5 && Ex: xy:79
				llRetorno = .F.
				
		ENDCASE
		
		IF !llRetorno
			MESSAGEBOX('Hora inv�lida!')
		ENDIF
			
		
		RETURN llRetorno
		
	ENDFUNC


ENDDEFINE