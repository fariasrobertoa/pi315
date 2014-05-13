package ajmu;

import java.awt.event.ActionEvent;

public aspect TareaAPPConnect extends TareaConnect{
	
	pointcut inicializacion():execution(void net.sf.jmoney.gui.AccountEntriesPanel.newEntry());
	
	pointcut finalizacion():execution(void net.sf.jmoney.gui.MainFrame.saveSession())||execution(void net.sf.jmoney.gui.MainFrame.saveSessionAs());
	
	before(): inicializacion(){
		if (!iniciada) {
			iniciada	= true;
			miTarea = new Tarea("Nombre de la Tarea: CREAR y SALVAR MAPA", iniciada);			
		}
	}
	
}
