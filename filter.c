#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <memory.h>

#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

#include "filter.h"
#include "constants.h"

void filterTask(void *pvParameters) {
    double Pi = 3.141592654;
    struct FilterParams *params =
        (struct FilterParams*)pvParameters;

    // we keep local copies of the global state + semaphores
    double gyro_data[3];
    double acc_data[3];

    // copy the semaphore handles for convenience
    SemaphoreHandle_t sensors_sem = params->sensors_sem;
    SemaphoreHandle_t estimate_sem = params->estimate_sem;

    // local internal state.
    double estimate[3] = {0.0};
    double alpha = 0.5;
    double h = 0.001;
    double gamma = alpha/(h+alpha);


    while(1) {
        // read sensor data
        xSemaphoreTake(sensors_sem,portMAX_DELAY);        
        memcpy(gyro_data, params->gyro_data, sizeof(gyro_data));
        memcpy(acc_data, params->acc_data, sizeof(acc_data));
 
        // apply filter
        
        // estimate of the yaw angle provided as an example
        estimate[2] += h * gyro_data[2];
	    double phiA = atan2(acc_data[1],acc_data[2])/Pi*180;
	    double thetaA = atan2(-acc_data[0], sqrt(pow(acc_data[1],2) + pow(acc_data[2],2)))/Pi*180;

	    double phiG = gyro_data[0] * h + estimate[0];
	    double thetaG = gyro_data[1] * h + estimate[1];
	    //printf("###### %4.2f  and another %4.2f   #######\n",phiG,thetaA);
	
	    xSemaphoreTake(estimate_sem,portMAX_DELAY);
	    estimate[0] =(1-gamma)*phiA + gamma*(phiG);
	    estimate[1] = (1-gamma)*thetaA + gamma*(thetaG);
	    estimate[2] += gyro_data[2] * h;
	

        // example of how to log some intermediate calculation
               params->log_data[0] = estimate[0] ;
	params->log_data[1] = estimate[1] ;
	params->log_data[2] += estimate[2] ;
	params->log_data[3] = gyro_data[2] ;
	 xSemaphoreGive(estimate_sem);
	 xSemaphoreGive(sensors_sem);
        // write estimates output
        memcpy(params->estimate, estimate, sizeof(estimate));

        // sleep 1ms to make this task run at 100Hz
        vTaskDelay(1 / portTICK_PERIOD_MS);
    }
}

