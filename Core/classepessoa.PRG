DEFINE CLASS ClassePessoa as Custom 

	nId = 0
	cNome = ''
	cEmail = ''
	cSenha = ''
	cUsuario = ''
	
	PROTECTED FUNCTION _AlgumCampoVazio()
		RETURN EMPTY(this.cNome) OR EMPTY(this.cSenha) OR EMPTY(this.cEmail) OR EMPTY(this.cUsuario)
	ENDFUNC 
	
	FUNCTION Salvar()
		IF !this._AlgumCampoVazio() AND !this.UsuarioCadastrado(this.cUsuario) AND !this.EmailCadastrado(this.cEmail)
			
			INSERT INTO Usuarios(Nome, Email, Usuario, Senha);
			VALUES (this.cNome, this.cEmail, this.cUsuario, this.cSenha)
			
			THIS._CarregarUsuario(this.cUsuario)
			
			RETURN .T.
		ENDIF
		
		RETURN .F.

	ENDFUNC
		
	FUNCTION ValidarUsuarioLogin(tcLogIn)
 
		LOCAL llRetorno, loEmail
		llRetorno = .T.
		loEmail = NEWOBJECT('EmailClass', 'EmailClass.prg')
	
		DO case
			CASE loEmail.ValidarEmail(tcLogIn, .F.)
				IF !THIS.EmailCadastrado(tcLogIn)
					llRetorno = .F.
				ELSE
					llRetorno = .T.
					THIS._CarregarUsuario(tcLogIn)
				ENDIF
			CASE !THIS.UsuarioCadastrado(tcLogIn)
				llRetorno = .F.
			OTHERWISE
				llRetorno = .T.
				THIS._CarregarUsuario(tcLogIn)
		ENDCASE				
		
		RETURN llRetorno
		
	ENDFUNC
	
	PROTECTED FUNCTION _CarregarUsuario(tcLogIn as String)
	
		SELECT * FROM USUARIOS WHERE;
			(UPPER(ALLTRIM(USUARIO )) == UPPER(ALLTRIM(tcLogIn)); 
			OR UPPER(ALLTRIM(EMAIL)) == UPPER(ALLTRIM(tcLogIn))); 
		INTO CURSOR curCarregandoUsuario
	 
		IF RECCOUNT('curCarregandoUsuario') != 1
			MESSAGEBOX('Erro ao carregar o usu�rio!')
		ELSE
			this.nId = curCarregandoUsuario.ID
			this.setNome(curCarregandoUsuario.Nome)
			this.setEmail(curCarregandoUsuario.Email)
			this.setUsuario(curCarregandoUsuario.Usuario)
			this.setSenha(curCarregandoUsuario.Senha)
		ENDIF
		
		USE IN curCarregandoUsuario
	
	ENDFUNC
	
	FUNCTION UsuarioCadastrado(tcNome as String)
	
		LOCAL llRetorno
		llRetorno = .F.
		
		SELECT * FROM USUARIOS WHERE UPPER(ALLTRIM(USUARIO)) == UPPER(ALLTRIM(TCNOME)) INTO CURSOR curUsuarioCadastrado
		llRetorno = (RECCOUNT('curUsuarioCadastrado') > 0)
		USE IN curUsuarioCadastrado
		
		RETURN llRetorno
	
	ENDFUNC
	
	FUNCTION EmailCadastrado(tcEmail as String)
	
		LOCAL llRetorno
		llRetorno = .F.
		
		SELECT * FROM USUARIOS WHERE UPPER(ALLTRIM(Email)) == UPPER(ALLTRIM(tcEmail)) INTO CURSOR curEmailCadastrado
		llRetorno = (RECCOUNT('curEmailCadastrado') > 0)
		USE IN curEmailCadastrado
		
		RETURN llRetorno
	
	ENDFUNC
	
	FUNCTION ValidarSenha(tcSenha as String )

		LOCAL llRetorno
		llRetorno = .F.
		
		SELECT SENHA FROM USUARIOS WHERE NOME = ALLTRIM(this.cNome) AND EMAIL = ALLTRIM(this.cEmail) INTO CURSOR curValidandoSenha
		llRetorno = (RECCOUNT('curValidandoSenha') > 0) AND ALLTRIM(tcSenha) == ALLTRIM(curValidandoSenha.Senha)
		USE IN curValidandoSenha
		
		RETURN llRetorno

	ENDFUNC
	
	FUNCTION ValidarNovoCadastroDeUsuario(tcMensagem_Ret as String, tnCampoInvalido_Ret as Number)

		LOCAL loEmail
		loEmail = NEWOBJECT('EmailClass', 'EmailClass.prg')		

		tnCampoInvalido_Ret = 0
		tcMensagem_Ret = ''

		IF EMPTY(this.cNome)
			tnCampoInvalido_Ret = 1
			tcMensagem_Ret = 'Campo nome � obrigat�rio!'
			RETURN .F.
		ENDIF
		
		IF EMPTY(this.cEmail)
			tnCampoInvalido_Ret = 2
			tcMensagem_Ret = 'Campo e-mail � obrigat�rio!'
			RETURN .F.
		ELSE
		
			IF !loEmail.ValidarEmail(this.cEmail,.F.)
				tnCampoInvalido_Ret = 2
				tcMensagem_Ret = 'E-mail inv�lido!'
				RETURN .F.
			ENDIF
			
			IF THIS.EmailCadastrado(this.cEmail)
				tnCampoInvalido_Ret = 2
				tcMensagem_Ret = 'E-mail j� cadastrado!'
				RETURN .F.
			ENDIF			
							
		ENDIF
		
		IF EMPTY(this.cUsuario)
			tnCampoInvalido_Ret = 3
			tcMensagem_Ret = 'Campo usu�rio � obrigat�rio!'
			RETURN .F.
		ELSE
			IF THIS.UsuarioCadastrado(this.cUsuario)
				tnCampoInvalido_Ret = 3
				tcMensagem_Ret = 'Usu�rio j� cadastrado!'
				RETURN .F.
			ENDIF		
		ENDIF
		
		IF EMPTY(this.cSenha)
			tnCampoInvalido_Ret = 4
			tcMensagem_Ret = 'Campo senha � obrigat�rio!'
			RETURN .F.
		ENDIF

	ENDFUNC
	
	FUNCTION setNome(tcNome)
		THIS.cNome = tcNome
	ENDFUNC
	
	FUNCTION getNome()
		RETURN this.cNome
	ENDFUNC
	
	FUNCTION setEmail(tcEmail)
		THIS.cEmail = tcEmail
	ENDFUNC
	
	FUNCTION getEmail()
		RETURN this.cEmail
	ENDFUNC
	
	FUNCTION setUsuario(tcUsuario)
		THIS.cUsuario = tcUsuario
	ENDFUNC
	
	FUNCTION getUsuario()
		RETURN this.cUsuario
	ENDFUNC
	
	FUNCTION setSenha(tcSenha)
		THIS.cSenha = tcSenha
	ENDFUNC
	
	FUNCTION getSenha()
		RETURN this.cSenha
	ENDFUNC	

ENDDEFINE