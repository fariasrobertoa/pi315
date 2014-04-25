package aspects;

import org.aspectj.lang.Signature;


abstract aspect TareaConnect {
	boolean iniciada	= false;	
	Tarea miTarea = null;
	private int nroEvento = 0;
	//para ventans de dialogo
	private int nroDialogo	= 0;
	
	/*
	 * POINTCUT INICIALIZACION()
	 * Descripción: Define el conjunto de puntos de corte que marcan el inicio de la tarea cuya usabilidad se desea estudiar.
	 */
	abstract pointcut inicializacion();
	
	/*
	 * POINTCUT FINALIZACION()
	 * Descripción: Define el conjunto de puntos de corte que marcan el fin de la tarea cuya usabilidad se desea estudiar.
	 */
	abstract pointcut finalizacion();
	
	/*
	 * POINCUT REGISTRAREXCEPCIONES()
	 * Descripción: Captura las excepciones gestionadas por catch, en el flujo de control iniciado por el pointcut inicializacion()
	 */
	pointcut registrarExcepciones(): cflow(inicializacion())&&!cflow(adviceexecution())&&handler(Exception+);
	
	/*
	 * The implementation for the after advice without returning needs to use a try/catch block
	 * 
	 */	 
	after() returning: finalizacion(){
		if (iniciada) {
			miTarea.finaliza();	
		}
		iniciada = false;
		nroEvento	= 0;
		nroDialogo	= 0;
		
	}
	
	before(): registrarExcepciones(){
		
		Signature sig = thisJoinPointStaticPart.getSignature();
		String kind = thisJoinPointStaticPart.getKind();
        String line =""+ thisJoinPointStaticPart.getSourceLocation().getLine();
        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getCanonicalName();
        
        String reg = "Excepción "+ ++nroEvento + ": Ocurrió una excepción en "+ sourceName+ "("+ kind +") línea " + line + " en el método " + sig + "(" + thisJoinPoint.toLongString() + ")";
		
		miTarea.setCantExcepciones();
		
		TareaLogger.aspectOf().grabar(reg);
		
	}
	/*
	 * 
	 * Descripción: Captura las excepciones gestionadas por catch, en el flujo de control LUEGO de la accion definida en pointcut inicializacion()
	 */
	before():!cflow(inicializacion())&&!cflow(adviceexecution())&&handler(Exception+){
		if((miTarea!=null)&&(!miTarea.isCompleta())){			 
			Signature sig = thisJoinPointStaticPart.getSignature();
			String kind = thisJoinPointStaticPart.getKind();
			String line =""+ thisJoinPointStaticPart.getSourceLocation().getLine();
	        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getCanonicalName();
	        
	        String reg = "Excepción "+ ++nroEvento + ": Ocurrió una excepción en "+ sourceName+ "("+ kind +") línea " + line + " en el método " + sig + "(" + thisJoinPoint.toLongString() + ")";
	        
	        //faltaba incrementar el numero de excepciones
	        miTarea.setCantExcepciones();
			
	        TareaLogger.aspectOf().grabar(reg);
						
		}
	}
	/**
	 * Descripci�n: La tarea inicia pero no finaliza
	 */	
	pointcut noFinalizoTarea():call(void java.lang.System.exit(..))&&!cflow(finalizacion())&&!cflow(adviceexecution());
	before(): noFinalizoTarea() {			
		TareaLogger.aspectOf().grabar("================= RESULTADOS FINALES ====================");
		TareaLogger.aspectOf().grabar("La tarea id " + miTarea.getId() + " NO ha finalizado");		
		TareaLogger.aspectOf().grabar("Excepciones gestionadas: " + miTarea.getCantExcepciones());		
	}


	/*
	 * 
	 * Descripción: Captura ventanas de tipo Dialog gestionadas en el flujo de control LUEGO de la accion definida en pointcut inicializacion()
	 */	
	pointcut CapturaDialogo(): !cflow(inicializacion())&&!cflow(adviceexecution()) && call( void *Dialog(..));	
	before(): CapturaDialogo(){
		if((miTarea!=null)&&(!miTarea.isCompleta())){	
			 
			if (thisJoinPoint.getTarget().getClass().getSuperclass().getCanonicalName().equals("javax.swing.JDialog") ||
					thisJoinPoint.getTarget().getClass().getSuperclass().getCanonicalName().equals("javax.swing.JOptionPane") ||
					thisJoinPoint.getTarget().getClass().getSuperclass().getCanonicalName().equals("java.awt.Dialog")){
				
				Signature sig = thisJoinPointStaticPart.getSignature();
				String kind = thisJoinPointStaticPart.getKind();
				String line =""+ thisJoinPointStaticPart.getSourceLocation().getLine();
		        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getCanonicalName();
		         
		        String reg = "Dialogo: "+  + ++nroDialogo + ": Ocurrio un llamado en "+ sourceName+ "("+ kind +") linea " + line + " al metodo " + sig + "(" + thisJoinPoint.toLongString() + ")";
		        
		        miTarea.setCantDialogos();
				TareaLogger.aspectOf().grabar(reg);
			}		
		}
	}
}
