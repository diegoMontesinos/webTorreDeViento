class UserMailer < ActionMailer::Base

	default from: "diegoa.montesinos@gmail.com"

	def contact_us(name, from, message)
		@name = name
		@from = from
		@message = message
		mail(to: 'totalmente_franco@hotmail.com', subject: 'Nuevo correo de contacto [www.torredevientoproducciones.com]')
	end 

end
