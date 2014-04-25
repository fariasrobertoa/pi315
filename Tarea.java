package aspects;

import java.rmi.server.ObjID;

public class Tarea {
	//private long id;
	private ObjID id;
	private boolean completa,iniciada;
	private Long inicializacion,finalizacion;
	private int cantExcepciones;
	private String descripcion;
	//para ventanas de dialogo
	private int cantDialogos;
    
	public Tarea(String desc, boolean inicio) {
		
		//id = this.hashCode();
		id	= new ObjID();
		iniciada = inicio;
		completa = false;
		inicializacion = System.currentTimeMillis();
		finalizacion = null;
		cantExcepciones = 0;
		descripcion = desc;
	}
	
	public boolean isIniciada() {
		return iniciada;
	}

	public void setIniciada(boolean iniciada) {
		this.iniciada = iniciada;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	//public long getId() {
	public ObjID getId() {
		return id;
	}
	
	public boolean isCompleta() {
		return completa;
	}

	public Long getInicializacion() {
		return inicializacion;
	}

	public Long getFinalizacion() {
		return finalizacion;
	}
	
	//public void finaliza(ObjID id){
	public void finaliza(){	
			finalizacion = System.currentTimeMillis();
			completa = true;
			
	}
	
	public Long tiempoDeEjecucion(){
		return finalizacion - inicializacion;
	}
	
	public String tiempoDeEjecucionSeg(){
		Long tejecucion = finalizacion - inicializacion;
		
		Long horas = tejecucion / 3600000;
		Long restoHoras = tejecucion%3600000;
		
		Long minutos = restoHoras / 60000;
		Long restoMinutos = restoHoras%60000;
		
		Long segundos = restoMinutos / 1000;
		Long restoSegundos = restoMinutos%1000;
		
		return horas + ":" + minutos + ":" + segundos + "." + restoSegundos;
		
	}
	
	public int getCantExcepciones() {
		return cantExcepciones;
	}

	public void setCantExcepciones() {
		this.cantExcepciones++;
	}
	
	public int getCantDialogos() {
		return cantDialogos;
	}

	public void setCantDialogos() {
		this.cantDialogos++;
	}

}
