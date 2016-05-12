#!/bin/bash

cd figures_2_3_sigfunalt1/sig0_i02
make && nohup ./smart_disp &
cd ../sig0_i05
make && nohup ./smart_disp &
cd ../sig0_i08
make && nohup ./smart_disp &
cd ../sig125_i02
make && nohup ./smart_disp &
cd ../sig125_i05
make && nohup ./smart_disp &
cd ../sig125_i08
make && nohup ./smart_disp &
cd ../sig25_i02
make && nohup ./smart_disp &
cd ../sig25_i05
make && nohup ./smart_disp &
cd ../sig25_i08
make && nohup ./smart_disp &
wait
cd ../figures_2_3_sigfunalt2/sig0_i02
make && nohup ./smart_disp &
cd ../sig0_i05
make && nohup ./smart_disp &
cd ../sig0_i08
make && nohup ./smart_disp &
cd ../sig125_i02
make && nohup ./smart_disp &
cd ../sig125_i05
make && nohup ./smart_disp &
cd ../sig125_i08
make && nohup ./smart_disp &
cd ../sig25_i02
make && nohup ./smart_disp &
cd ../sig25_i05
make && nohup ./smart_disp &
cd ../sig25_i08
make && nohup ./smart_disp &
