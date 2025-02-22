/*Author: Janardhan Muddana
 * test class: XIRRTest
 * Created Date: 03/02/2023
 * Desc: To optimize the cpu time this code is added
 * 
 * */

Public class XIRR{
    public static double calculateExcelIRR(List<Double> cashValues){
    
        Boolean containsInitialInvestmentAmount = false;     
            
        //Used to store the IRR result
        Double iRR = 0;
            
        //Check that the first element in the cashvalue list is less than 0
        //If true, set containsInitialInvestmentAmount to true in order to proceed
        if(!cashValues.isEmpty() && cashValues[0] < 0){
                
           containsInitialInvestmentAmount = true;
                
         }
         
         
         //IF containsInitialInvestmentAmount is true, execute the rest of the code
         if(containsInitialInvestmentAmount){
                
             //To calculate the IRR, we are going to utilize Edmond Halley's Method root-finding algorithm
             //Halley's Method states the following
             //xNplus1 = xN - (2f(xN)*f'(xN))/(2(f'(xN))^(2)*f''(xN)*f(xN))
             //Where xN equals the value of the initial root guess and 
             //xNplus1 equals the next potential root guess that is closer to making the initial function equal to 0.
             
             //Used to store initial and subsequent root guesses
             Double xN = 0;
             
             //Used to store next root guess 
             Double xNplus1 = 0;
             
             //Used to store the initial and subsequent IRR function Values of xN
             Double initialGuessFunctionValue = 0;
             
             //Used to store the IRR function Value of the next best root guess, xNplus1
             Double nextGuessFunctionValue = 0;
             
             //Used to store the first derivative value of xN
             Double firstDerivativeValue = 0;
             
             //Used to store the second derivate value of xN
             Double secondDerivativeValue = 0; 
             
             //Used to store the number of guesses or iterations needed to find the root solution (100) 
             Integer guessCount = 1;
             
             //Initiate while loop
             //After each xN root guess, check if f(xN) equals is less than 0.0001 for extra precision
             //If not, continue guessing the next root solution until that occurrs 
             //The max number of guesses allowed will be 100
             while(guessCount < 101){
                 
                 //System.debug('Guess #'+guessCount);
                 
                 //Find the first, second derivative and initial function values of IRR function when x equals the value of xN
                 for(Integer i = 1; i < cashValues.size(); i++){
                     
                     firstDerivativeValue += (-i*cashValues[i])*Math.pow(1+xN,-(1+i));
                     
                     secondDerivativeValue += (-i*cashValues[i]*(-(1+i)))*Math.pow(1+xN,-(2+i));
                     
                     initialGuessFunctionValue += cashValues[i]*Math.pow((1+xN), -i);
                     
                 }
                 
                 //System.debug('First Derivative Value of f(xN) when xN = '+xN+' is: '+firstDerivativeValue);
                 
                 //System.debug('Second Derivative Value of f(xN) when xN = '+xN+' is: '+secondDerivativeValue);
                 
                 //Add initial invesment cost to function value. Remember this is a negative number
                 initialGuessFunctionValue = initialGuessFunctionValue + cashValues[0];
                 
                 //System.debug('The IRR Function Value (f(x)) when xN = '+xN+' is: '+initialGuessFunctionValue);
                 
                 //Use Edmond Halley's Method root-finding algorithm to find the next best x root guess solution
                 //As mentioned previously, Halley's method states: 
                 //xNplus1 = xN - (2f(xN)*f'(xN))/(2(f'(xN))^(2)*f''(xN)*f(xN))
                 xNplus1 = xN - ((2*initialGuessFunctionValue*firstDerivativeValue) /((2*(Math.pow(firstDerivativeValue,2)))-(secondDerivativeValue*firstDerivativeValue)));
                 
                 //Output next Best IRR root guess
                 //System.debug('Next IRR Root Guess (xNplus1): '+xNplus1);
                 
                 //Evaluate the next best root guess IRR functional value
                 //The goal is to find a x root value that makes the initial IRR function value equal to less than 0.0001 for extra precision.
                 for(Integer i = 0; i < cashValues.size(); i++){
                     
                     nextGuessFunctionValue += cashValues[i]*Math.pow((1+xNplus1), -i);
                     
                 }
    
           //System.Debug('The IRR Function Value (f(x)) for the Next Best Guess Root (xNplus1) is: '+nextGuessFunctionValue);
                 
                 //If the value of the IRR function at (xNplus1) is less than 1 ten thousandths, then return this as the IRR value
                 If(nextGuessFunctionValue < 0.0001){
                     
                    // System.debug('Found IRR. Returning Result....');
                     
                     //Return the IRR decimal value as a percentage
                     iRR = xNplus1*100;
                     
                     //Break the while loop since we found an answer
                     break; 
                     
                 }
                 //else id no answer was found, continue guessing
                 else{
                     
                    // System.debug('Evaluating Next Guess...');
                     
                     //Set iRR to the current xNplus1 just in case the max amount of guesses were made
                     iRR = xNplus1*100;
                     
                     //Increase the guess Count by 1
                     guessCount++;
                     
                     //Set xNplus1 to xN for the next guess count iteration
                     xN = xNplus1;
                     
                     //Reset all other calculated values for the next guess iteration
                     firstDerivativeValue = 0;
                     secondDerivativeValue = 0;
                     initialGuessFunctionValue = 0;
                     nextGuessFunctionValue = 0;
                     
                 }
            
             }
             
           }
            
             return iRR;
        }
}