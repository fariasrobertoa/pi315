package aspects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public aspect TareaLogger {
	
	private static final Logger loggerTarea = LoggerFactory.getLogger(Tarea.class);
	private static final Logger loggerEventos = LoggerFactory.getLogger(Logger.class);
	
	pointcut registrarInicio(Tarea t):initialization(aspects.Tarea.new(String, boolean))&&this(t);
	
	after(Tarea t): registrarInicio(t){
		loggerTarea.info("===================== INICIO TAREA: "+ t.getDescripcion() +" =========================");
		loggerTarea.info("La tarea id " + t.getId() + " ha sido iniciada.");
	}
	
	pointcut registrarDatos(Tarea t):execution(void aspects.Tarea.finaliza(..))&&this(t);
	
	after(Tarea t): registrarDatos(t){
		loggerTarea.info("================= RESULTADOS FINALES ====================");
		loggerTarea.info("La tarea id " + t.getId() + " ha finalizado");
		loggerTarea.info("Tiempo de ejecuci√≥n: " + t.tiempoDeEjecucion() + "ms" + "("+ t.tiempoDeEjecucionSeg() +")");
		loggerTarea.info("Excepciones gestionadas: " + t.getCantExcepciones());
		loggerTarea.info("Diálogos mostrados: " + t.getCantDialogos());
		
	}
	public void grabar(String reg){
		loggerEventos.info("<==> "+reg);
	}
}
