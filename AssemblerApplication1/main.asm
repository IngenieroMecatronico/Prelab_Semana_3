//*******************************************************************************************************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programaci�n de Microcontroladores
// Autor: Juan Fer Maldonado 
// Proyecto Semaforo.asm
// Descripci�n: implementaci�n de contadores de 4 bits para suma en el microcontrolador.
// Hardware: ATMega328P
// Created: 28/01/2024 18:35:34
//*******************************************************************************************************************************************************
// Encabezado
//*******************************************************************************************************************************************************
.include "M328PDEF.inc"

.cseg
.org 0x00
//*******************************************************************************************************************************************************
// Configuraci�n de la Pila
//*******************************************************************************************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17
//*******************************************************************************************************************************************************
// Configuraci�n de MCU
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
	LDI R17, 0b00011111  //0b00011111  ; Activo que los botones ser�n pullup, debido a que los pushbutton est�n conectados de PC0 - PC4
	OUT PORTC, R17
//*******************************************************************************************************************************************************
// Loop infinito
//*******************************************************************************************************************************************************
Contador:
	LDI R26, 0           ; Inicializo el contador de la posici�n R26, posee los valores para los leds verdes.
	LDI R28, 0			 ; Inicializo el contador de la posici�n R28, posee los valores para los leds amarillos.
	LDI R25, 0           ; Inicializo el contador de la posici�n R25, posee los valores para los leds azules.
	LDI R29, 0           ; Es una bandera que nos servir� para evitar el rebote en PB1.
	LDI R30, 0			 ; Es una bandera que nos servir� para evitar el rebote en PB2.
	LDI R27, 0           ; Es una bandera que nos servir� para evitar el rebote en PB5.
LOOP:
		IN R21, PINC         ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.
		SBRC R21, 0 //1		 ; Revisa si el bit 0 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB1   ; Llamo al delay del primer bot�n solo cuando el bit 0 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 0 esta en 0 y tambien si esta en 1
		SBRS R21, 0 		 ; Revisa si el bit 0 tiene 1 y salta omitiendo la siguiente instruccion si esta as�.
		CALL IncrementaPB1  ; Llamo a la subfunci�n de encendido PB1 por que el bit 0 esta en 0 (Se haya oprimido o no).
		IN R22, PINC     ; Leo el PINC completo, para evaluar si el bot�n de decremento esta activo o no.
		SBRC R22, 1       ; Revisa si el bit 1 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB2   ; Llamo al delay del segundo bot�n solo cuando el bit 0 esta en 1 (oprimido)
		IN R22, PINC     ; Leo el PINB cuando el bit 1 esta en 0 y tambien si esta en 1
		SBRS R22, 1 		 ; Revisa si el bit 1 tiene 1 y salta omitiendo la siguiente instruccion si esta as�.
		CALL DecrementaPB2  ; Llamo a la subfunci�n de encendido PB2 por que el bit 0 esta en 0 (Se haya oprimido o no).
		
		//Revisi�n del contador 2.

		IN R21, PINC  ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.	 
		SBRC R21, 2 		 ; Revisa si el bit 2 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB3   ; Llamo al delay del primer bot�n solo cuando el bit 2 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 2 esta en 0 y tambien si esta en 1
		SBRS R21, 2		 ; Revisa si el bit 2 tiene 1 y salta omitiendo la siguiente instruccion si esta as�.
		CALL IncrementaPB3  ; Llamo a la subfunci�n de encendido PB3 por que el bit 2 esta en 0 (Se haya oprimido o no).
		IN R22, PINC     ; Leo el PINC completo, para evaluar si el bot�n de decremento esta activo o no.
		SBRC R22, 3       ; Revisa si el bit 3 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB4   ; Llamo al delay del segundo bot�n solo cuando el bit 3 esta en 1 (oprimido)
		IN R22, PINC     ; Leo el PINB cuando el bit 3 esta en 0 y tambien si esta en 1
		SBRS R22, 3 		 ; Revisa si el bit 3 tiene 1 y salta omitiendo la siguiente instruccion si esta as�.
		CALL DecrementaPB4  ; Llamo a la subfunci�n de encendido PB4 por que el bit 3 esta en 0 (Se haya oprimido o no).

		//Revisi�n de la suma
		IN R21, PINC  ; Leo el PINC completo para evaluar si esta oprimido el boton o no PIN es para leer lo que hay en un puerto.	 
		SBRC R21, 4 		 ; Revisa si el bit 4 tiene 0 y salta omitiendo la siguiente instruccion si esta asi.
		CALL PresionaPB5   ; Llamo al delay del primer bot�n solo cuando el bit 4 esta en 1 (oprimido)
		IN R21, PINC      ; Leo el PINC cuando el bit 4 esta en 0 y tambien si esta en 1
		SBRS R21, 4		 ; Revisa si el bit 4 tiene 1 y salta omitiendo la siguiente instruccion si esta as�.
		CALL SumaPB5  ; Llamo a la subfunci�n de encendido PB5 por que el bit 4 esta en 0 (Se haya oprimido o no).

		RJMP LOOP
//*******************************************************************************************************************************************************
// Subrutina
//*******************************************************************************************************************************************************
PresionaPB1: 
	LDI R16, 0			 ; Inicializo la posici�n de memoria R16.
	LDI R29, 1           ; Es una bandera para saber que se oprimi� el bot�n y debo incrementar el contador.
RetrasoPB1:
	INC R16				 ; Inicializo la posici�n de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB1      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
IncrementaPB1:
    CPI R29, 1			 ; Verificar la bandera que indica que se detect� que se oprimi� el bot�n.
	BRNE ActivaLedInc	 ; Si la bandera indica que no se oprimi�, solo muestra los led.
	LDI R29, 0			 ; Apaga la bandera que indica que se oprimi� el bot�n.
	CPI R26, 15          ; Si el contador es quince, no sumar�.
	BREQ ActivaLedInc    ; Se va a mostrar el valor de quince.
	INC R26              ; SI la bandera indica que se oprimi� y el contador no es quince, incrementa el contador y muestra los led.
ActivaLedInc:
	OUT PORTB, R26 //R27       ; Muestro los led en el puerto B.
	RET	

//******************************************************************************************************************************************************
// Revisi�n del PB2
//******************************************************************************************************************************************************
PresionaPB2:
	LDI R16, 0			 ; Inicializo la posici�n de memoria R16.
	LDI R30, 1           ; Es una bandera para saber que se oprimi� el bot�n y debo incrementar el contador.
RetrasoPB2:
	INC R16				 ; Inicializo la posici�n de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB2      ; Mientras no sea 100, regresa a RetrasoPB1
	RET	
DecrementaPB2:
    CPI R30, 1			 ; Verificar la bandera que indica que se detect� que se oprimi� el bot�n.
	BRNE ActivaLedDec    ; Si la bandera indica que no se oprimi�, solo muestra los led.
    LDI R30, 0			 ; Apaga la bandera que indica que se oprimi� el bot�n.
	CPI R26, 0           ; Si el contador es cero, no restar�.
	BREQ ActivaLedDec    ; Se va a mostrar el valor de cero.
	DEC R26              ; SI la bandera indica que se oprimi� y el contador no es cero, decrementa el contador y muestra los led.

ActivaLedDec:
	OUT PORTB, R26 //R27       ; Muestro los led en el puerto B.
	RET	
//*****************************************************************************************************************************************************
// Revisi�n del PB3
//*****************************************************************************************************************************************************
PresionaPB3: 
	LDI R16, 0			 ; Inicializo la posici�n de memoria R16.
	LDI R18, 1           ; Es una bandera para saber que se oprimi� el bot�n y debo incrementar el contador.
RetrasoPB3:
	INC R16				 ; Inicializo la posici�n de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB3      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
IncrementaPB3:
    CPI R18, 1			 ; Verificar la bandera que indica que se detect� que se oprimi� el bot�n.
	BRNE ActivaLedSum	 ; Si la bandera indica que no se oprimi�, solo muestra los led.
	LDI R18, 0			 ; Apaga la bandera que indica que se oprimi� el bot�n.
	CPI R28, 15          ; Si el contador es quince, no sumar�.
	BREQ ActivaLedSum    ; Se va a mostrar el valor de quince.
	INC R28              ; SI la bandera indica que se oprimi� y el contador no es quince, incrementa el contador y muestra los led.
ActivaLedSum:
	OUT PORTD, R28       ; Muestro los led en el puerto B.
	RET	
//******************************************************************************************************************************************************
// Revisi�n del PB4
//******************************************************************************************************************************************************
PresionaPB4:
	LDI R16, 0			 ; Inicializo la posici�n de memoria R16.
	LDI R19, 1           ; Es una bandera para saber que se oprimi� el bot�n y debo incrementar el contador.
RetrasoPB4:
	INC R16				 ; Inicializo la posici�n de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB4      ; Mientras no sea 100, regresa a RetrasoPB4
	RET	
DecrementaPB4:
    CPI R19, 1			 ; Verificar la bandera que indica que se detect� que se oprimi� el bot�n.
	BRNE ActivaLedRes    ; Si la bandera indica que no se oprimi�, solo muestra los led.
    LDI R19, 0			 ; Apaga la bandera que indica que se oprimi� el bot�n.
	CPI R28, 0           ; Si el contador es cero, no restar�.
	BREQ ActivaLedRes    ; Se va a mostrar el valor de cero.
	DEC R28              ; SI la bandera indica que se oprimi� y el contador no es cero, decrementa el contador y muestra los led.

ActivaLedRes:
	OUT PORTD, R28 //R27       ; Muestro los led en el puerto B.
	RET	
//******************************************************************************************************************************************************
// Revisi�n del PB5
//******************************************************************************************************************************************************
PresionaPB5: 
	LDI R16, 0			 ; Inicializo la posici�n de memoria R16.
	LDI R27, 1           ; Es una bandera para saber que se oprimi� el bot�n y debo incrementar el contador.
	MOV R20, R26         ; Muevo el contador1 (Leds Verdes) a la posici�n R20
	OUT PORTB, R20       ; Muestro el contador 
RetrasoPB5:
	INC R16				 ; Inicializo la posici�n de memoria R16.
	CPI R16, 100		 ; Retardo de 100 ms
	BRNE RetrasoPB5      ; Mientras no sea 100, regresa a RetrasoPB1
	RET		
SumaPB5:
 //   CPI R27, 1			 ; Verificar la bandera que indica que se detect� que se oprimi� el bot�n.
//	BRNE ActivaLedSuma	 ; Si la bandera indica que no se oprimi�, solo muestra los led.
	LDI R27, 0			 ; Apaga la bandera que indica que se oprimi� el bot�n.
	LDI R25, 0           ; Inicializo posiciones de memoria R25 en 0.
	LDI R23, 0           ; Inicializo posiciones de memoria R en 0.
	LDI R20, 16          ; Inicializo posiciones de memoria R20en 16.
Sumaverdes:
	ADD R25, R20	 ; Sumar� 16 en la posici�n de memoria R25.
	INC R23          ; Luego tendr� otro contador donde sumar� 16 veces el valor de cada bit debido a que no me func�on� la multiplicaci�n.
	CP R23, R26		 ; Comparo si ya sum� 16 veces el dato.
	BRNE Sumaverdes     ; Si no, regreso a sumar, de lo contrario, me dirijo a la suma del siguiente contador.
	LDI R23, 0         ; Inicializo la posicion del contador en 0
	LDI R20, 17       ; establezco ahora en 17 mi suma.
Sumamarillos:
    ADD R25, R20	; Sumo 17 a la posici�n R25.
	INC R23          ; Incremento un contador que sumar� hasta las 17veces.
	CP R23, R28		 ; Si cumple, termin� de sumar 17 veces, de lo contrario, reinicia el ciclo.
	BRNE Sumamarillos     ; Regresa al inicio.
	//MOV R25, R26         ; Muevo los valores de los leds verdes (contador 1) a R25.
	//MUL R25, R20
	//LDI R20, 17
	//MOV R23, R28         ; Muevo los valores de los leds amarillos (contador 2) a R23.
	//MUL R23, R20
	//ADD R25, R23         ; Sumo el valor de los leds amarillos (contador 2) a R25
	MOV R16, R26       ; Muevo el valor de sumado hasta la posici�n R26.
	ADD R16, R28       ; Le sumo el contador de los leds (amarillos)
	CPI R16, 16        ; Si el contador es1 16, este no sumar�.
	BRLO ActivaLedSuma
	LDI R24, 16        ; Asigno 16 a R24.
	MOV R25, R28       ; Para que los led azules no se enciendan.
	MOV R20, R26       ; Muevo el registro del contador para la posici�n R20.
	ADD R20, R24       ; Le a�ado los 16 bits para que se mantenga el color en los leds verdes y a la vez, encienda el led de carry.
	OUT PORTB, R20     ; Muestro el contador de led verde y los leds de carry.
ActivaLedSuma:
	//LDI R25, 132
	OUT PORTD, R25 //R27       ; Muestro los led en el puertoD.
	RET	