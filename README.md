Simple project for MU-class 'mu_dev11_mdbcore' using ATSAMD21J18A xplained Pro (https://www.microchip.com/en-us/development-tool/atsamd21-xpro) with three basic functions:
a) toggle onboard LED (pin-PB30) at 1Hz
b) send chars over the vCOM (->SERCOM3_pad0=TX=pin-PA22 , _pad1=RX=pin-PA23)
c) use onboard-button SW0 (pin-PA15) to stop

The MCC-Harmony3 project is in folder 'dev11Labs_fw' and last successful test with this environment
  -) MPLABX-v6.15
  -) XC32-v4.35
  -) DFP SAMD21-v3.6.144
  -) MCC-plugin v (->MCCcore-v5.4.14, Harmony3Libraries-v1.2.0)
  -) H3-manifest:  dev_packs-v3.10.0 , csp-v3.10.0

The parallel folder 'dev11Labs_mdbScripts' contains the MDBCore-scripts to compile-from-cmdLine as well as test with  mdb and mdbcs
(SL, 15.12.2023)
end 
