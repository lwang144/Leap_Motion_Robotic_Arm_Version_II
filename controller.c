#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>

#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

#include "controller.h"
#include "constants.h"

void controlSystemTask(void *pvParameters) {
    struct ControlSystemParams *params =
        (struct ControlSystemParams*)pvParameters;

    // we keep local copies of the global state + semaphores
    unsigned short motors[4];
    double gyro_data[3];
    double acc_data[3];
    double r_rpdy[3];
    double estimate[3] = {0.0};
	double gain[19];
//	double bt = crazyflie_constants.m * crazyflie_constants.g/4;
//double bt = crazyflie_constants.m * crazyflie_constants.g/4;
	gain[0]=-0.0027 ;
	gain[1]=-0.0027  ;
	gain[2]=0.0027  ;
	gain[3]=0.0027  ;
	gain[4]=-0.0039;
	gain[5]=0.0039;
	gain[6]=0.0039;
	gain[7]=-0.0039;
	gain[8]=-0.0086;
 	gain[9]=-0.0086;
  	gain[10]=0.0086;
	gain[11]=0.0086;
	gain[12]=-0.0123 ;
 	gain[13]=0.0123 ;
	gain[14]=0.01231 ;
	gain[15]=-0.0123 ;
	gain[16]=-0.0138;
 	gain[17]=0.0138;
	gain[18]=-0.0138;
	gain[19]=0.0138;
 
 	double error[5];
    // copy the semaphore handles for convenience
    SemaphoreHandle_t motors_sem = params->motors_sem;
    SemaphoreHandle_t references_sem = params->references_sem;
    SemaphoreHandle_t sensors_sem = params->sensors_sem;
    SemaphoreHandle_t estimate_sem = params->estimate_sem;

    while(1) {
    int i, j;
        // read sensor data (gyro)
		xSemaphoreTake(references_sem, portMAX_DELAY);
		xSemaphoreTake(sensors_sem, portMAX_DELAY);		
		xSemaphoreTake(estimate_sem, portMAX_DELAY);
        memcpy(gyro_data, params->gyro_data, sizeof(gyro_data));

        // read filter data (angle estimates)
        memcpy(estimate, params->estimate, sizeof(estimate));

        // read latest references
        memcpy(r_rpdy, params->r_rpdy, sizeof(r_rpdy));
		xSemaphoreGive(references_sem);
		xSemaphoreGive(estimate_sem);
		xSemaphoreGive(sensors_sem);
        // compute error
		xSemaphoreTake(references_sem, portMAX_DELAY);
		xSemaphoreTake(sensors_sem, portMAX_DELAY);		
		xSemaphoreTake(estimate_sem, portMAX_DELAY);
		error[0]=-(r_rpdy[0]-estimate[0])*M_PI/180;
		error[1]=-(r_rpdy[1]-estimate[1])*M_PI/180;
		
		error[2]=(gyro_data[0])*M_PI/180;
		error[3]=(gyro_data[1])*M_PI/180;
		error[4]=gyro_data[2]*M_PI/180;
		xSemaphoreGive(references_sem);
		xSemaphoreGive(estimate_sem);
		xSemaphoreGive(sensors_sem);
        // example of how to log some intermediate calculation
        // and use the provided constants
	xSemaphoreTake(references_sem, portMAX_DELAY);
        params->log_data[0] = crazyflie_constants.m * crazyflie_constants.g;
        params->log_data[2] = r_rpdy[0];
	xSemaphoreGive(references_sem);

        // compute motor outputs
		xSemaphoreTake(references_sem, portMAX_DELAY);
		xSemaphoreTake(sensors_sem, portMAX_DELAY);		
		xSemaphoreTake(estimate_sem, portMAX_DELAY);	
	
 motors[0]= ((-gain[0])*error[0]+(-gain[4])*error[1]+(-gain[8])*error[2]+(-gain[12])*error[3]+(-gain[16])*error[4])*1/(0.06/4*9.82/65536)+30000;
 motors[1]= ((-gain[1])*error[0]+(-gain[5])*error[1]+(-gain[9])*error[2]+(-gain[13])*error[3]+(-gain[17])*error[4])*1/(0.06/4*9.82/65536)+30000;
 motors[2]= ((-gain[2])*error[0]+(-gain[6])*error[1]+(-gain[10])*error[2]+(-gain[14])*error[3]+(-gain[18])*error[4])*1/(0.06/4*9.82/65536)+30000;
 motors[3]= ((-gain[3])*error[0]+(-gain[7])*error[1]+(-gain[11])*error[2]+(-gain[15])*error[3]+(-gain[19])*error[4])*1/(0.06/4*9.82/65536)+30000;
		xSemaphoreGive(references_sem);
		xSemaphoreGive(estimate_sem);
		xSemaphoreGive(sensors_sem);
        // write motor output
		xSemaphoreTake(references_sem, portMAX_DELAY);
		xSemaphoreTake(sensors_sem, portMAX_DELAY);		
		xSemaphoreTake(estimate_sem, portMAX_DELAY);
        memcpy(params->motors, motors, sizeof(motors));
		xSemaphoreGive(references_sem);
		xSemaphoreGive(estimate_sem);
		xSemaphoreGive(sensors_sem);
        // sleep 10ms to make this task run at 100Hz
        vTaskDelay(10 / portTICK_PERIOD_MS);
    }
}
