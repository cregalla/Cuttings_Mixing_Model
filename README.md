# Cuttings_Mixing_Model
Matlab code for a mixing model for simulated curttings recovered during riser drilling.
Used to generate mixing models in Cornard et al., (in review)



# Description: Linear Vertical Mixing model to simuluate observations made from drill cuttings.
 Author: Christine Regalla
 Written: August 2024
 Code based on a vertical mixing model produced by IODP Exp 338 shipboard
 scientists. Plots are based on those in IODP Exp 338, 348 and 358
 reports. http://iodp.tamu.edu/publications/PR.html


 This mixing model assumes that cuttings are mixed over a 20m interval, 
 with a linear decay of contributions of cuttings with distance uphole, 
 within that interval, from 100% at the base of the interval to 0% at the 
 top of the interval. 

 The mixing model is mathematically defined by the equation:
   the integral (∫) from (x-v) to x of mx*dx = 1. 
   where x = downhole depth, v = the vertical mixing interval and m= the linear mixing gradient. 



