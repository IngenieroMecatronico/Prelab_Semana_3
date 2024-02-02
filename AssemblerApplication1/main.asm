//*******************************************************************************************************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de Microcontroladores
// Autor: Juan Fer Maldonado 
// Proyecto Semaforo.asm
// Descripción: implementación de contadores de 4 bits para suma en el microcontrolador.
// Hardware: ATMega328P
// Created: 28/01/2024 18:35:34
//*******************************************************************************************************************************************************
// Encabezado
//*******************************************************************************************************************************************************
.include "M328PDEF.inc"

.cseg
.org 0x00
//*******************************************************************************************************************************************************
// Configuración de la Pila
//*******************************************************************************************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17
//*******************************************************************************************************************************************************
// Configuración de MCU
//*******************************************************************************************************************************************************
SETUP:
	// Configuracion de reloj.
	LDI R31,  (1 << CLKPCE)
	STS CLKPR, R31
	LDI R31, 0b0000_0100
	STS CLKPR, R31
	//Configuracion de los I/O Ports
	//DDRB SOLO LO USAMOS PARA DECIRLE QUE ES SALIDA O ENTRADA.
	LDI	R16, 0b00011111   ; Estoy asignando que los puertos PB del 4-0 son Salidas
	OUT	DDRB, R16
	LDI	R16, 0b11111111   ; Estoy asignando que los puertos PD de 7-0 son salidas.
	OUT	DDRD, R16
	LDI	R16, 0b00000000   ; Estoy asignando que los puertos PC de 7-0 son entradas.
	OUT	DDRC, R16
	LDI R17, 0b00011111  //0b00011111  ; Activo que los botones serán pullup, debido a que los pushbutton están conectados de PC0 - PC4
	OUT PORTC, R17
//*******************************************************************************************************************************************************
// Loop infinito
//*******************************************************************************************************************************************************
Contador:
	LDI R26, 0           ; Inicializo el contador de la posición R26, posee los valores para los leds verdes.
	LDI R28, 0			 ; Inicializo el contador de la posición R28, posee los valores para los leds amarillos.
	LDI R25, 0           ; Inicializo el contador de la posición R25, posee los valores para los leds azules.
	LDI R29, 0           ; Es una bandera que nos servirá para evitar el rebote en PB1.
	LDI R30, 0			 ; Es una bandera que nos servirá para evitar el rebote en PB2.
	LDI R27, 0           ; Es una bandera que nos servirá para evitar el rebote en PB5.
LOOP:
		IN R21, PINC         ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.
		SBRC R21, 0 //1		 ; Revisa si el bit 0 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB1   ; Llamo al delay del primer botón solo cuando el bit 0 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 0 esta en 0 y tambien si esta en 1
		SBRS R21, 0 		 ; Revisa si el bit 0 tiene 1 y salta omitiendo la siguiente instruccion si esta así.
		CALL IncrementaPB1  ; Llamo a la subfunción de encendido PB1 por que el bit 0 esta en 0 (Se haya oprimido o no).
		IN R22, PINC     ; Leo el PINC completo, para evaluar si el botón de decremento esta activo o no.
		SBRC R22, 1       ; Revisa si el bit 1 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB2   ; Llamo al delay del segundo botón solo cuando el bit 0 esta en 1 (oprimido)
		IN R22, PINC     ; Leo el PINB cuando el bit 1 esta en 0 y tambien si esta en 1
		SBRS R22, 1 		 ; Revisa si el bit 1 tiene 1 y salta omitiendo la siguiente instruccion si esta así.
		CALL DecrementaPB2  ; Llamo a la subfunción de encendido PB2 por que el bit 0 esta en 0 (Se haya oprimido o no).
		
		//Revisión del contador 2.

		IN R21, PINC  ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.	 
		SBRC R21, 2 		 ; Revisa si el bit 2 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB3   ; Llamo al delay del primer botón solo cuando el bit 2 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 2 esta en 0 y tambien si esta en 1
		SBRS R21, 2		 ; Revisa si el bit 2 tiene 1 y salta omitiendo la siguiente instruccion si esta así.
		CALL IncrementaPB3  ; Llamo a la subfunción de encendido PB3 por que el bit 2 esta en 0 (Se haya oprimido o no).
		IN R22, PINC     ; Leo el PINC completo, para evaluar si el botón de decremento esta activo o no.
		SBRC R22, 3       ; Revisa si el bit 3 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB4   ; Llamo al delay del segundo botón solo cuando el bit 3 esta en 1 (oprimido)
		IN R22, PINC     ; Leo el PINB cuando el bit 3 esta en 0 y tambien si esta en 1
		SBRS R22, 3 		 ; Revisa si el bit 3 tiene 1 y salta omitiendo la siguiente instruccion si esta así.
		CALL DecrementaPB4  ; Llamo a la subfunción de encendido PB4 por que el bit 3 esta en 0 (Se haya oprimido o no).

		//Revisión de la suma
		IN R21, PINC  ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.	 
		SBRC R21, 4 		 ; Revisa si el bit 4 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB5   ; Llamo al delay del primer botón solo cuando el bit 4 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 4 esta en 0 y tambien si esta en 1
		SBRS R21, 4		 ; Revisa si el bit 4 tiene 1 y salta omitiendo la siguiente instruccion si esta así.
		CALL SumaPB5  ; Llamo a la subfunción de encendido PB5 por que el bit 4 esta en 0 (Se haya oprimido o no).

		RJMP LOOP
//*******************************************************************************************************************************************************
// Subrutina
//*******************************************************************************************************************************************************
PresionaPB1: 
	LDI R16, 0			 ; Inicializo la posición de memoria R16.
	LDI R29, 1           ; Es una bandera para saber que se oprimió el botón y debo incrementar el contador.
RetrasoPB1:
	INC R16				 ; Inicializo la posición de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB1      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
IncrementaPB1:
    CPI R29, 1			 ; Verificar la bandera que indica que se detectó que se oprimió el botón.
	BRNE ActivaLedInc	 ; Si la bandera indica que no se oprimió, solo muestra los led.
	LDI R29, 0			 ; Apaga la bandera que indica que se oprimió el botón.
	CPI R26, 15          ; Si el contador es quince, no sumará.
	BREQ ActivaLedInc    ; Se va a mostrar el valor de quince.
	INC R26              ; SI la bandera indica que se oprimió y el contador no es quince, incrementa el contador y muestra los led.
ActivaLedInc:
	OUT PORTB, R26 //R27       ; Muestro los led en el puerto B.
	RET	

//******************************************************************************************************************************************************
// Revisión del PB2
//******************************************************************************************************************************************************
PresionaPB2:
	LDI R16, 0			 ; Inicializo la posición de memoria R16.
	LDI R30, 1           ; Es una bandera para saber que se oprimió el botón y debo incrementar el contador.
RetrasoPB2:
	INC R16				 ; Inicializo la posición de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB2      ; Mientras no sea 100, regresa a RetrasoPB1
	RET	
DecrementaPB2:
    CPI R30, 1			 ; Verificar la bandera que indica que se detectó que se oprimió el botón.
	BRNE ActivaLedDec    ; Si la bandera indica que no se oprimió, solo muestra los led.
    LDI R30, 0			 ; Apaga la bandera que indica que se oprimió el botón.
	CPI R26, 0           ; Si el contador es cero, no restará.
	BREQ ActivaLedDec    ; Se va a mostrar el valor de cero.
	DEC R26              ; SI la bandera indica que se oprimió y el contador no es cero, decrementa el contador y muestra los led.

ActivaLedDec:
	OUT PORTB, R26 //R27       ; Muestro los led en el puerto B.
	RET	
//*****************************************************************************************************************************************************
// Revisión del PB3
//*****************************************************************************************************************************************************
PresionaPB3: 
	LDI R16, 0			 ; Inicializo la posición de memoria R16.
	LDI R18, 1           ; Es una bandera para saber que se oprimió el botón y debo incrementar el contador.
RetrasoPB3:
	INC R16				 ; Inicializo la posición de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB3      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
IncrementaPB3:
    CPI R18, 1			 ; Verificar la bandera que indica que se detectó que se oprimió el botón.
	BRNE ActivaLedSum	 ; Si la bandera indica que no se oprimió, solo muestra los led.
	LDI R18, 0			 ; Apaga la bandera que indica que se oprimió el botón.
	CPI R28, 15          ; Si el contador es quince, no sumará.
	BREQ ActivaLedSum    ; Se va a mostrar el valor de quince.
	INC R28              ; SI la bandera indica que se oprimió y el contador no es quince, incrementa el contador y muestra los led.
ActivaLedSum:
	OUT PORTD, R28       ; Muestro los led en el puerto B.
	RET	
//******************************************************************************************************************************************************
// Revisión del PB4
//******************************************************************************************************************************************************
PresionaPB4:
	LDI R16, 0			 ; Inicializo la posición de memoria R16.
	LDI R19, 1           ; Es una bandera para saber que se oprimió el botón y debo incrementar el contador.
RetrasoPB4:
	INC R16				 ; Inicializo la posición de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB4      ; Mientras no sea 100, regresa a RetrasoPB4
	RET	
DecrementaPB4:
    CPI R19, 1			 ; Verificar la bandera que indica que se detectó que se oprimió el botón.
	BRNE ActivaLedRes    ; Si la bandera indica que no se oprimió, solo muestra los led.
    LDI R19, 0			 ; Apaga la bandera que indica que se oprimió el botón.
	CPI R28, 0           ; Si el contador es cero, no restará.
	BREQ ActivaLedRes    ; Se va a mostrar el valor de cero.
	DEC R28              ; SI la bandera indica que se oprimió y el contador no es cero, decrementa el contador y muestra los led.

ActivaLedRes:
	OUT PORTD, R28 //R27       ; Muestro los led en el puerto B.
	RET	
//******************************************************************************************************************************************************
// Revisión del PB5
//******************************************************************************************************************************************************
PresionaPB5: 
	LDI R16, 0			 ; Inicializo la posición de memoria R16.
	LDI R27, 1           ; Es una bandera para saber que se oprimió el botón y debo incrementar el contador.
	MOV R20, R26         ; Muevo el contador1 (Leds Verdes) a la posición R20
	OUT PORTB, R20       ; Muestro el contador 
RetrasoPB5:
	INC R16				 ; Inicializo la posición de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB5      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
SumaPB5:
 //   CPI R27, 1			 ; Verificar la bandera que indica que se detectó que se oprimió el botón.
//	BRNE ActivaLedSuma	 ; Si la bandera indica que no se oprimió, solo muestra los led.
	LDI R27, 0			 ; Apaga la bandera que indica que se oprimió el botón.
	LDI R25, 0           ; Inicializo posiciones de memoria R25 en 0.
	LDI R23, 0           ; Inicializo posiciones de memoria R en 0.
	LDI R20, 16          ; Inicializo posiciones de memoria R20en 16.
Sumaverdes:
	ADD R25, R20	 ; Sumaré 16 en la posición de memoria R25.
	INC R23          ; Luego tendré otro contador donde sumaré 16 veces el valor de cada bit debido a que no me funcíonó la multiplicación.
	CP R23, R26		 ; Comparo si ya sumé 16 veces el dato.
	BRNE Sumaverdes     ; Si no, regreso a sumar, de lo contrario, me dirijo a la suma del siguiente contador.
	LDI R23, 0         ; Inicializo la posicion del contador en 0
	LDI R20, 17       ; establezco ahora en 17 mi suma.
Sumamarillos:
    ADD R25, R20	; Sumo 17 a la posición R25.
	INC R23          ; Incremento un contador que sumará hasta las 17veces.
	CP R23, R28		 ; Si cumple, terminó de sumar 17 veces, de lo contrario, reinicia el ciclo.
	BRNE Sumamarillos     ; Regresa al inicio.
	//MOV R25, R26         ; Muevo los valores de los leds verdes (contador 1) a R25.
	//MUL R25, R20
	//LDI R20, 17
	//MOV R23, R28         ; Muevo los valores de los leds amarillos (contador 2) a R23.
	//MUL R23, R20
	//ADD R25, R23         ; Sumo el valor de los leds amarillos (contador 2) a R25
	MOV R16, R26       ; Muevo el valor de sumado hasta la posición R26.
	ADD R16, R28       ; Le sumo el contador de los leds (amarillos)
	CPI R16, 16        ; Si el contador es1 16, este no sumará.
	BRLO ActivaLedSuma
	LDI R24, 16        ; Asigno 16 a R24.
	MOV R25, R28       ; Para que los led azules no se enciendan.
	MOV R20, R26       ; Muevo el registro del contador para la posición R20.
	ADD R20, R24       ; Le añado los 16 bits para que se mantenga el color en los leds verdes y a la vez, encienda el led de carry.
	OUT PORTB, R20     ; Muestro el contador de led verde y los leds de carry.
ActivaLedSuma:
	//LDI R25, 132
	OUT PORTD, R25 //R27       ; Muestro los led en el puertoD.
	RET	